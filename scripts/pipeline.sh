#!/bin/sh
# Run the arXiv pipeline on a build server: fetch and extract the next papers with ax, open a pull request on tamnd/arxiv and merge it, then import the mentions into tamnd/math2 with m2 and do the same there.
#
# Run it from cron, for example each hour: 7 * * * * $HOME/arxiv-pipeline/pipeline.sh >> $HOME/arxiv-pipeline/pipeline.log 2>&1; cp $HOME/arxiv-pipeline/arxiv/scripts/pipeline.sh $HOME/arxiv-pipeline/ 2>/dev/null
#
# The server needs git, Go, gh and flock, and an SSH key that can push to both repositories. The file $AX_PIPELINE/github.env must set GH_TOKEN for gh. Keep it at mode 600.
#
# The papers come from the list $AX_LIST first (gold set X). When the list has no paper left to do, they come from the scope $AX_SCOPE in the order of AX2.6. Each run does at most $AX_LIMIT papers. Only one run can go at a time, and the pipeline must be the only process that fetches from arXiv.
#
# A run merges its pull request only when the checks pass and the branch rebases on main with no conflict. Otherwise it leaves the pull request open, writes the reason to $AX_PIPELINE/blocked, and the later runs do nothing until a person removes that file.
set -eu

dir=${AX_PIPELINE:-$HOME/arxiv-pipeline}
limit=${AX_LIMIT:-100}
pace=${AX_PACE:-15s}
list=${AX_LIST:-manifests/gold/x-v1.txt}
scope=${AX_SCOPE:-math}
# The run stops before the batch when the disk has less free space than this, in MB.
reserve=${AX_RESERVE_MB:-3000}
export PATH="$dir/bin:/usr/local/go/bin:$PATH"
# A cache of its own, because other jobs on the server clean the shared one.
export GOCACHE="$dir/gocache"

mkdir -p "$dir/bin" "$dir/run"
exec 9>"$dir/lock"
flock -n 9 || { echo "another run is going"; exit 0; }
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
# Arguments: the repository, the title, the body file, the result of the checks (pass or fail), and two labels.
publish() {
	name=$1 title=$2 body=$3 checks=$4
	r="$dir/$name"
	git -C "$r" fetch -q origin main
	git -C "$r" rebase -q origin/main || {
		git -C "$r" rebase --abort
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
	gh release download "$tag" -R "tamnd/$1" -p "${2}_${tag}_linux_amd64.tar.gz" -p checksums.txt -D "$t"
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
axv=$(ax version | head -1)
m2v=$(m2 version | head -1)

clone arxiv
clone math2
start arxiv

free=$(df -m "$dir" | tail -1 | awk '{print $4}')
if [ "$free" -lt "$reserve" ]; then
	block "the disk has $free MB free, and a run needs $reserve MB"
fi

# The batch: the list first, then the scope.
export ARXIV_CORPUS="$dir/arxiv"
cd "$dir/arxiv"
out="$dir/run/batch-$stamp.out"
ax census batch -list "$list" -limit "$limit" -pace "$pace" >"$out" 2>"$dir/run/batch-$stamp.err" || log "the batch of the list exited with $?"
from="the list $list"
if ! grep -Eq '^[0-9]+/[0-9]+ [^ ]+ (extracted|stopped)' "$out"; then
	ax census batch -scope "$scope" -limit "$limit" -pace "$pace" >"$out" 2>"$dir/run/batch-$stamp.err" || log "the batch of the scope exited with $?"
	from="the scope $scope"
fi
done=$(grep -Ec '^[0-9]+/[0-9]+ [^ ]+ extracted' "$out" || true)
stopped=$(grep -Ec '^[0-9]+/[0-9]+ [^ ]+ stopped' "$out" || true)
log "the batch of $from: $done extracted, $stopped stopped"

# The tags, the reports and the audits, as the CI of tamnd/arxiv runs them.
ax tags analysis -all >"$dir/run/tags-$stamp.out" 2>&1 || log "ax tags analysis exited with $?"
ax census report >/dev/null 2>&1 || log "ax census report exited with $?"
ax graph report >/dev/null 2>&1 || log "ax graph report exited with $?"
checks=pass
ax audit -report reports/audit.md >/dev/null 2>&1 || checks=fail
ax audit -plane content -report reports/audit-content.md >/dev/null 2>&1 || checks=fail
ax audit -group D -report reports/audit-analysis.md >/dev/null 2>&1 || checks=fail

body="$dir/run/arxiv-$stamp.md"
cat >"$body" <<EOF
The pipeline on the build server ran $axv on the next papers of $from.

- Papers extracted: $done
- Papers stopped: $stopped
- The run: $stamp

It also ran \`ax tags analysis -all\`, the census report, the graph report and the three audits of the CI. The audits $( [ "$checks" = pass ] && echo pass || echo "have a hard finding, so this pull request stays open" ).
EOF
if commit arxiv "Add the census of $done papers of $from"; then
	publish arxiv "Add the census of $done papers of $from" "$body" "$checks" "type: feature" "area: corpus"
fi

# The import into tamnd/math2.
start math2
cd "$dir/math2"
m2 corpus import -source arxiv -corpus "$dir/arxiv" -root "$dir/math2" >"$dir/run/import-$stamp.out" 2>&1 || block "m2 corpus import failed, see $dir/run/import-$stamp.out"
m2 corpus cluster -source arxiv -root "$dir/math2" >"$dir/run/cluster-$stamp.out" 2>&1 || block "m2 corpus cluster failed, see $dir/run/cluster-$stamp.out"
arxiv=$(git -C "$dir/arxiv" rev-parse --short HEAD)
title="Import the arXiv mentions of tamnd/arxiv at $arxiv"
commit math2 "$title" || { log "the run is done"; exit 0; }
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
publish math2 "$title" "$body" "$mchecks" "type: content" "area: inventory"
log "the run is done"
