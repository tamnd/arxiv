#!/bin/sh
# Run the arXiv pipeline on a build server: fetch and extract the next papers with ax, open a pull request on tamnd/arxiv and merge it, then import the mentions into tamnd/math2 with m2 and do the same there.
#
# Run it from cron, for example each 10 minutes, so that a run starts soon after the last one ends: */10 * * * * $HOME/arxiv-pipeline/pipeline.sh >> $HOME/arxiv-pipeline/pipeline.log 2>&1; cp $HOME/arxiv-pipeline/arxiv/scripts/pipeline.sh $HOME/arxiv-pipeline/ 2>/dev/null
#
# The server needs git, Go, gh and flock, and an SSH key that can push to both repositories. The file $AX_PIPELINE/github.env must set GH_TOKEN for gh. Keep it at mode 600.
#
# Each run does at most $AX_REDO_LIMIT papers of the redo list, and then at most $AX_LIMIT new papers. The new papers come from the list $AX_LIST first (gold set X). When the list has fewer papers left, the scope $AX_SCOPE gives the rest in the order of AX2.6. Only one run can go at a time, and the pipeline must be the only process that fetches from arXiv.
#
# The new papers get the render, the second witness of the census, one in $AX_RENDER_EVERY, so that a paper takes two requests and not three. The papers of the redo list always get it.
#
# When every batch of a run fails and no paper is done, as when a manifest does not read, the run opens an issue on tamnd/arxiv with the error, or adds the error to the issue that is open. The first run that does papers again closes it.
#
# A run merges its pull request only when the checks pass and the branch rebases on main with no conflict. Otherwise it leaves the pull request open, writes the reason to $AX_PIPELINE/blocked, and the later runs do nothing until a person removes that file. A run with too little disk is skipped and blocks nothing.
set -eu

dir=${AX_PIPELINE:-$HOME/arxiv-pipeline}
limit=${AX_LIMIT:-100}
# The papers of the redo list that one run does before the new papers.
redolimit=${AX_REDO_LIMIT:-25}
pace=${AX_PACE:-15s}
# The new papers get the render one in this many.
every=${AX_RENDER_EVERY:-10}
list=${AX_LIST:-manifests/gold/x-v1.txt}
scope=${AX_SCOPE:-math}
# The run stops before the batch when the disk has less free space than this, in MB.
reserve=${AX_RESERVE_MB:-3000}
# Cron gives a short PATH, and gh is in /usr/local/bin.
export PATH="$dir/bin:/usr/local/go/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
# A cache of its own, because other jobs on the server clean the shared one.
export GOCACHE="$dir/gocache"

mkdir -p "$dir/bin" "$dir/run"
exec 9>"$dir/lock"
# A run takes hours and cron starts one each few minutes, so a start that finds a run going says nothing.
flock -n 9 || exit 0
if [ -f "$dir/blocked" ]; then
	exit 0
fi

set -a
. "$dir/github.env"
set +a

stamp=$(date -u +%Y%m%dT%H%MZ)
log() { echo "$(date -u +%FT%TZ) $*"; }

block() {
	echo "$(date -u +%FT%TZ) $*" >"$dir/blocked"
	log "blocked: $*"
	exit 1
}

# clone makes the clone of a data repository, with the identity of the commits.
clone() {
	if [ ! -d "$dir/$1/.git" ]; then
		git clone -q "git@github.com:tamnd/$1.git" "$dir/$1"
	fi
	git -C "$dir/$1" config user.name tamnd
	git -C "$dir/$1" config user.email 1218621+tamnd@users.noreply.github.com
}

# start puts the clone on main. Changes that an earlier run left in the work tree stay.
start() {
	r="$dir/$1"
	git -C "$r" fetch -q origin main
	if [ -n "$(git -C "$r" status --porcelain)" ]; then
		git -C "$r" stash -q -u
		git -C "$r" checkout -q -B pipeline origin/main
		git -C "$r" stash pop -q || block "the changes that an earlier run left in $1 do not apply on main"
	else
		git -C "$r" checkout -q -B pipeline origin/main
	fi
}

# commit commits the changes of a clone. It fails when there is no change.
commit() {
	git -C "$dir/$1" add -A
	if git -C "$dir/$1" diff --cached --quiet; then
		log "$1: no change"
		return 1
	fi
	git -C "$dir/$1" commit -q -m "$2"
}

# publish opens a pull request with the commit of a clone and merges it when the checks passed.
# Arguments: the repository, the title, the body file, the result of the checks (pass or fail), two labels, and "redo" when the commit is generated data that the run can make again on the new main.
# With "redo", a commit that does not rebase on main gives the return code 2 and no pull request. Otherwise the run blocks.
publish() {
	name=$1 title=$2 body=$3 checks=$4
	r="$dir/$name"
	git -C "$r" fetch -q origin main
	git -C "$r" rebase -q origin/main || {
		git -C "$r" rebase --abort
		if [ "${7:-}" = redo ]; then
			log "$name: the commit does not rebase on main, so the run makes it again"
			git -C "$r" checkout -q -B pipeline origin/main
			return 2
		fi
		block "$name: the commit does not rebase on main"
	}
	branch="pipeline/$stamp"
	git -C "$r" push -q origin "HEAD:refs/heads/$branch"
	url=$(gh pr create -R "tamnd/$name" --head "$branch" --base main --title "$title" --body-file "$body" --label "$5" --label "$6")
	log "$name: $url"
	if [ "$checks" != pass ]; then
		block "$name: the checks failed, see $url"
	fi
	gh pr comment "$url" --body "The pipeline ran the checks on the build server, and they pass. The runners are slow, so the pipeline merges with admin rights." >/dev/null
	gh pr merge "$url" --squash --delete-branch --admin >/dev/null || block "$name: the merge of $url failed"
	git -C "$r" fetch -q origin main
	git -C "$r" checkout -q -B pipeline origin/main
	log "$name: merged $url"
}

# tool installs the binary of the latest release of a tool, which has the version of the release in it. The records name that version as the extractor.
# Arguments: the repository and the name of the binary.
tool() {
	tag=$(gh release view -R "tamnd/$1" --json tagName -q .tagName)
	if [ -x "$dir/bin/$2" ] && [ "$(cat "$dir/bin/$2.tag" 2>/dev/null)" = "$tag" ]; then
		return 0
	fi
	t=$(mktemp -d "$dir/run/tool.XXXXXX")
	# A new release has no binaries until its workflow is done, and the runners can be slow. The run then builds the tag from its source, with the flags of the release workflow. When that fails too, it keeps the binary that it has.
	if ! gh release download "$tag" -R "tamnd/$1" -p "${2}_${tag}_linux_amd64.tar.gz" -p checksums.txt -D "$t" 2>/dev/null; then
		rm -f "$t/${2}_${tag}_linux_amd64.tar.gz" "$t/checksums.txt"
		if git clone -q --depth 1 -b "$tag" "https://github.com/tamnd/$1.git" "$t/src" 2>/dev/null && (cd "$t/src" && CGO_ENABLED=0 go build -trimpath -ldflags "-s -w -X main.Version=$tag" -o "$t/$2" "./cmd/$2"); then
			mv "$t/$2" "$dir/bin/$2"
			echo "$tag" >"$dir/bin/$2.tag"
			log "built $2 $tag from its source, because the release has no linux binary yet"
		else
			[ -x "$dir/bin/$2" ] || block "the release $tag of $2 has no linux binary, and its source does not build"
			log "the release $tag of $2 has no linux binary yet and its source does not build, so the run uses $(cat "$dir/bin/$2.tag" 2>/dev/null)"
		fi
		# $t is the temporary directory of this call, so only the clone of this call goes.
		case "$t" in "$dir"/run/tool.*) if [ -d "$t/src" ]; then rm -rf "$t/src"; fi ;; esac
		rm -f "$t/$2"
		rmdir "$t"
		return 0
	fi
	a="${2}_${tag}_linux_amd64"
	(cd "$t" && grep -E "  (\./)?$a.tar.gz\$" checksums.txt | sha256sum -c -) >/dev/null || block "the checksum of $2 $tag does not match"
	tar -xzf "$t/$a.tar.gz" -C "$t" "$a/$2"
	mv "$t/$a/$2" "$dir/bin/$2"
	echo "$tag" >"$dir/bin/$2.tag"
	rm -f "$t/$a.tar.gz" "$t/checksums.txt"
	rmdir "$t/$a" "$t"
	log "installed $2 $tag"
}
tool arxiv-reader ax
tool math2-agent m2
axv="ax $(ax version | head -1)"
m2v=$(m2 version | head -1)

clone arxiv
clone math2
start arxiv

free=$(df -m "$dir" | tail -1 | awk '{print $4}')
# Too little disk skips this run and does not block the later ones, because the
# disk is shared with other jobs and its free space comes back.
if [ "$free" -lt "$reserve" ]; then
	log "skipped: the disk has $free MB free, and a run needs $reserve MB"
	exit 0
fi

# The batches: the redo list, then the new papers of the list and of the scope.
export ARXIV_CORPUS="$dir/arxiv"
cd "$dir/arxiv"
out="$dir/run/batch-$stamp.out"
# The papers to do again after a fix to ax come first. They are in $dir/redo.txt, one id at the start of each line. A run takes the first $redolimit of them and keeps their sources in work/, so that a finding can be traced. It removes them from the file when the batch ends with no error. The batches run one after the other, so only one process fetches at a time.
# count gives the number of papers of a batch output with a state, as extracted.
count() { grep -Ec "^[0-9]+/[0-9]+ [^ ]+ $2" "$1" || true; }
redo="$dir/redo.txt"
done=0 stopped=0 from=""
# failed has the last line of the error of each batch that exited with an error.
failed=""
fail() {
	log "the batch of $1 exited with $2"
	failed="$failed- the batch of $1: $(tail -n 1 "$3" 2>/dev/null)
"
}
# The flag of the render sample, when the ax of the run has it.
sample=""
if ax census batch -h 2>&1 | grep -q -- -render-every; then
	sample="-render-every $every"
fi
if [ -s "$redo" ]; then
	head -n "$redolimit" "$redo" >"$dir/run/redo-$stamp.txt"
	n=$(wc -l <"$dir/run/redo-$stamp.txt")
	if ax census batch -redo -accept -keep -list "$dir/run/redo-$stamp.txt" -pace "$pace" >"$out.redo" 2>"$dir/run/batch-$stamp.err.redo"; then
		sed -i "1,${n}d" "$redo"
	else
		fail "the redo list" $? "$dir/run/batch-$stamp.err.redo"
	fi
	r=$(count "$out.redo" extracted)
	s=$(count "$out.redo" stopped)
	log "the batch of the redo list: $r extracted, $s stopped"
	done=$((done + r)) stopped=$((stopped + s)) from="the redo list, "
fi
# The new papers. The list gives at most $limit of them, and the scope gives the rest.
ax census batch -list "$list" -limit "$limit" -pace "$pace" $sample >"$out" 2>"$dir/run/batch-$stamp.err" || fail "the list" $? "$dir/run/batch-$stamp.err"
r=$(count "$out" extracted)
s=$(count "$out" stopped)
log "the batch of the list $list: $r extracted, $s stopped"
done=$((done + r)) stopped=$((stopped + s)) from="${from}the list $list"
if [ $((r + s)) -lt "$limit" ]; then
	ax census batch -scope "$scope" -limit $((limit - r - s)) -pace "$pace" $sample >"$out.scope" 2>"$dir/run/batch-$stamp.err.scope" || fail "the scope" $? "$dir/run/batch-$stamp.err.scope"
	r=$(count "$out.scope" extracted)
	s=$(count "$out.scope" stopped)
	log "the batch of the scope $scope: $r extracted, $s stopped"
	done=$((done + r)) stopped=$((stopped + s)) from="$from and the scope $scope"
fi

# alert opens the issue of a run that did no paper, or adds to it. When a run did papers, it closes that issue.
alerttitle="The pipeline does no paper"
alert() {
	open=$(gh issue list -R tamnd/arxiv --state open --search "in:title \"$alerttitle\"" --json number -q '.[0].number' 2>/dev/null || true)
	if [ $((done + stopped)) -gt 0 ]; then
		if [ -n "$open" ]; then
			gh issue close "$open" -R tamnd/arxiv --comment "The run $stamp did $done papers and stopped $stopped, so the pipeline works again." >/dev/null || true
			log "closed the issue #$open"
		fi
		rm -f "$dir/alerted"
		return 0
	fi
	[ -n "$failed" ] || return 0
	msg="The run $stamp on the build server did no paper, and its batches failed:

$failed
The output is in $dir/run on the build server. The pipeline goes on each run, and the first run that does papers closes this issue."
	# A run each few minutes with the same error adds nothing, so the issue gets a comment only when the error changes.
	if [ -n "$open" ] && [ "$(printf '%s' "$failed")" = "$(cat "$dir/alerted" 2>/dev/null)" ]; then
		return 0
	fi
	printf '%s' "$failed" >"$dir/alerted"
	if [ -n "$open" ]; then
		gh issue comment "$open" -R tamnd/arxiv --body "$msg" >/dev/null || true
	else
		url=$(gh issue create -R tamnd/arxiv --title "$alerttitle" --label "type: fix" --label "area: corpus" --body "$msg" || true)
		log "opened the issue $url"
	fi
}
alert
# A run whose batches failed and did no paper has nothing to publish, so it opens no pull request.
if [ $((done + stopped)) -eq 0 ] && [ -n "$failed" ]; then
	log "the run is done, and it did no paper"
	exit 0
fi

# The tags, the reports and the audits, as the CI of tamnd/arxiv runs them.
ax tags analysis -all >"$dir/run/tags-$stamp.out" 2>&1 || log "ax tags analysis exited with $?"
ax census report >/dev/null 2>&1 || log "ax census report exited with $?"
ax graph report >/dev/null 2>&1 || log "ax graph report exited with $?"
# The metadata audit, the content audit and the structural rules of the analysis plane stop the run. The other rules of group D measure the quality of the extraction (AX-M3). The run writes and commits their report, and lists their findings in the pull request, but they do not stop it.
gate=D01,D02,D04,D06,D10,D13
checks=pass
ax audit -q -report reports/audit.md >"$dir/run/audit-meta-$stamp.out" 2>&1 || checks=fail
ax audit -q -plane content -report reports/audit-content.md >"$dir/run/audit-content-$stamp.out" 2>&1 || checks=fail
ax audit -q -group D -report reports/audit-analysis.md >"$dir/run/audit-analysis-$stamp.out" 2>&1 || true
ax audit -q -group D -rules "$gate" >"$dir/run/audit-gate-$stamp.out" 2>&1 || checks=fail
quality=$(grep -E '^\| D[0-9]+ \| fail \|' reports/audit-analysis.md | awk -F'|' '{gsub(/ /, "", $2); gsub(/ /, "", $6); printf "%s%s %s", sep, $2, $6; sep=", "}')

# The body is built from variables, because dash misreads a command substitution in a here-document that also has escaped backquotes.
tick='`'
if [ "$checks" = pass ]; then
	verdict=pass
else
	verdict="have a hard finding, so this pull request stays open. The output is in $dir/run on the build server"
fi
body="$dir/run/arxiv-$stamp.md"
cat >"$body" <<EOF
The pipeline on the build server ran $axv on the next papers of $from.

- Papers extracted: $done
- Papers stopped: $stopped
- The run: $stamp

It also ran ${tick}ax tags analysis -all${tick}, the census report, the graph report and the three audits of the CI. The metadata audit, the content audit and the rules $gate of the analysis plane $verdict.

The quality rules of the analysis plane with findings: ${quality:-none}. They are the work of AX-M3 and do not stop the pipeline. The full list is in reports/audit-analysis.md.
EOF
if commit arxiv "Add the census of $done papers of $from"; then
	publish arxiv "Add the census of $done papers of $from" "$body" "$checks" "type: feature" "area: corpus"
fi

# The import into tamnd/math2. It is generated data, so when main changes under it, the run makes it again on the new main, at most two times.
# importmath2 makes the commit and the body of the pull request. It fails when the import gives no change.
importmath2() {
	start math2
	cd "$dir/math2"
	m2 corpus import -source arxiv -corpus "$dir/arxiv" -root "$dir/math2" >"$dir/run/import-$stamp.out" 2>&1 || block "m2 corpus import failed, see $dir/run/import-$stamp.out"
	m2 corpus cluster -source arxiv -root "$dir/math2" >"$dir/run/cluster-$stamp.out" 2>&1 || block "m2 corpus cluster failed, see $dir/run/cluster-$stamp.out"
	# The report of the research layer (AX-M8). It does not stop the run when it fails.
	m2 corpus status -layer research -corpus "$dir/arxiv" -root "$dir/math2" -write >"$dir/run/research-$stamp.out" 2>&1 || log "m2 corpus status -layer research failed, see $dir/run/research-$stamp.out"
	arxiv=$(git -C "$dir/arxiv" rev-parse --short HEAD)
	title="Import the arXiv mentions of tamnd/arxiv at $arxiv"
	commit math2 "$title" || return 1
	mchecks=pass
	m2 check >"$dir/run/check-$stamp.out" 2>&1 || mchecks=fail
	for v in volumes/*.yaml; do
		m2 pack -check -q "$v" >>"$dir/run/check-$stamp.out" 2>&1 || mchecks=fail
	done
	m2 audit -changed -base origin/main >"$dir/run/audit-$stamp.out" 2>&1 || mchecks=fail
	# The audit writes its report into the tree. The report of a run of -changed is not committed.
	rm -f "$dir/math2/reports/audit/changed.txt" "$dir/math2/reports/audit/changed.json"
	body="$dir/run/math2-$stamp.md"
	{
		echo "The pipeline on the build server imported the arXiv mentions of tamnd/arxiv at $arxiv with $m2v, and grouped them into rows again."
		echo
		echo '```'
		cat "$dir/run/import-$stamp.out" "$dir/run/cluster-$stamp.out"
		echo '```'
		echo
		if [ "$mchecks" = pass ]; then
			echo "\`m2 check\`, \`m2 pack -check\` and \`m2 audit -changed\` pass."
		else
			echo "\`m2 check\`, \`m2 pack -check\` or \`m2 audit -changed\` has a finding, so this pull request stays open. The output is in $dir/run on the build server."
		fi
	} >"$body"
}

for try in 1 2 3; do
	importmath2 || { log "the run is done"; exit 0; }
	rc=0
	if [ "$try" -lt 3 ]; then
		publish math2 "$title" "$body" "$mchecks" "type: content" "area: inventory" redo || rc=$?
	else
		publish math2 "$title" "$body" "$mchecks" "type: content" "area: inventory"
	fi
	[ "$rc" -eq 2 ] || break
done
log "the run is done"
