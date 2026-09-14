#!/usr/bin/env python3
"""Check the manifests for the things a broken corpus looks like.

This is deliberately not the audit. The audit lives in tamnd/arxiv-reader, runs
over the content, and knows about a hundred rules. This runs over the manifests
alone, needs nothing but Python and PyYAML, and exists so that a bad edit to
languages.yaml fails in the pull request that made it rather than in the next
pipeline run three days later.

It is also the only check this repository has that works from the first commit,
before any toolchain release exists to install.
"""

import pathlib
import re
import subprocess
import sys

import yaml

ROOT = pathlib.Path(__file__).resolve().parents[2]

PATHS = {"render", "source", "native", "vision"}
STATUS = {"seeded", "partial", "full"}
SPACING = {"none", "cjk"}
SCRIPTS = {"Latn", "Hans", "Hant", "Jpan", "Cyrl", "Arab", "Deva", "Hang"}
ENGINES = {"lualatex", "xelatex"}
LINEBREAK = {"default", "cjk", "japanese"}
CONFIDENCES = ["certain", "high", "medium"]

# The six licences arXiv offers a submitter, plus the placeholder for a paper
# whose licence we have not read yet. Kept in step with corpus/access.go in the
# toolchain, and rule L01 of the audit is the thing that proves they agree.
LICENCES = {
    "cc0", "cc-by", "cc-by-sa", "cc-by-nc-sa", "cc-by-nc-nd",
    "arxiv-1.0", "unknown",
}

# An audit rule id: one letter for the group, two digits for the rule.
RULE = re.compile(r"^[A-Z][0-9]{2}$")

# An arXiv category, archive or group, as a glossary scope. cs.CL, math.FA,
# math, cond-mat, q-bio.NC are all legal here.
SCOPE = re.compile(r"^[a-z]+(-[a-z]+)?(\.[A-Za-z]{2,3})?$")

problems = []


def bad(where, message):
    problems.append(f"{where}: {message}")


def load(name):
    path = ROOT / "manifests" / name
    if not path.exists():
        bad(name, "is missing")
        return None
    with path.open(encoding="utf-8") as f:
        return yaml.safe_load(f)


def check_typeset():
    """Every profile is named once and asks for a font stack we can build."""
    doc = load("typeset.yaml")
    if doc is None:
        return {}
    profiles = {}
    for p in doc.get("profiles") or []:
        name = p.get("name", "")
        where = f"typeset.yaml[{name or '?'}]"
        if not name:
            bad(where, "missing name")
        if name in profiles:
            bad(where, "duplicate profile name")
        profiles[name] = p
        if p.get("engine") not in ENGINES:
            bad(where, f"engine {p.get('engine')!r} is not one we run")
        if p.get("linebreak") not in LINEBREAK:
            bad(where, f"linebreak {p.get('linebreak')!r} is not a known rule")
        for key in ("main", "fallback", "math"):
            if not p.get(key):
                bad(where, f"missing {key} font, and a font left to a fallback "
                           f"chain is a PDF that differs from CI")
    return profiles


def check_languages(profiles):
    """Every language can be typeset, has a glossary that exists, and if it is
    converted from another language then that language is here too."""
    doc = load("languages.yaml")
    if doc is None:
        return [], set()
    langs = doc.get("languages") or []
    codes, used_profiles = {}, set()
    for lang in langs:
        code = lang.get("code", "")
        where = f"languages.yaml[{code or '?'}]"
        if not code:
            bad(where, "missing code")
        if code in codes:
            bad(where, "duplicate language code")
        codes[code] = lang
        if not lang.get("name"):
            bad(where, "missing name, which is what the reading app shows")
        if lang.get("script") not in SCRIPTS:
            bad(where, f"script {lang.get('script')!r} is not an ISO 15924 code "
                       f"we know")
        if lang.get("status") not in STATUS:
            bad(where, f"status {lang.get('status')!r} is not seeded, partial "
                       f"or full")
        if lang.get("spacing") not in SPACING:
            bad(where, f"spacing {lang.get('spacing')!r} is not none or cjk")
        if lang.get("normalisation") != "NFC":
            bad(where, "normalisation must be NFC, because rule L16 compares "
                       "normalised text and two forms of the same string are "
                       "two strings")
        profile = lang.get("typeset")
        if profile not in profiles:
            bad(where, f"typeset profile {profile!r} is not in typeset.yaml")
        else:
            used_profiles.add(profile)
        glossary = lang.get("glossary") or ""
        # English is the source language and needs no glossary. Every other
        # language does, and it has to be a file that is actually here.
        if code == "en":
            if glossary:
                bad(where, "English is the source language and has no glossary")
        elif not glossary:
            bad(where, "missing glossary path")
        elif not (ROOT / glossary).exists():
            bad(where, f"glossary {glossary} does not exist")
    for lang in langs:
        source = lang.get("converted_from")
        if source is None:
            continue
        where = f"languages.yaml[{lang.get('code')}]"
        if source not in codes:
            bad(where, f"converted_from {source!r} is not a language here")
        elif codes[source].get("glossary") != lang.get("glossary"):
            bad(where, f"a converted language shares the glossary of {source}, "
                       f"because it is a conversion of that text and not a "
                       f"second translation of the English")
        elif codes[source].get("converted_from") is not None:
            bad(where, "converted from a language that is itself converted")
    for name in profiles:
        if name not in used_profiles:
            bad(f"typeset.yaml[{name}]", "no language uses this profile")
    return langs, set(codes)


def check_glossaries(langs):
    """One meaning per term per scope, and no term that translates to itself."""
    for lang in langs:
        code = lang.get("code")
        glossary = lang.get("glossary") or ""
        if not glossary or lang.get("converted_from") is not None:
            continue
        path = ROOT / glossary
        if not path.exists():
            continue
        with path.open(encoding="utf-8") as f:
            doc = yaml.safe_load(f)
        if not isinstance(doc.get("version"), int):
            bad(glossary, "version must be an integer, and it goes up whenever "
                          "an existing term changes meaning")
        seen = set()
        for term in doc.get("terms") or []:
            en = term.get("en", "")
            scope = term.get("scope")
            where = f"{glossary}[{en or '?'}" + (f"/{scope}]" if scope else "]")
            if not en:
                bad(where, "missing en")
            if code not in term or not term.get(code):
                bad(where, f"missing the {code} translation")
            elif term[code] == en:
                bad(where, "translates to itself, so either drop the row or "
                           "record it as a term that stays in English")
            if scope is not None and not SCOPE.match(str(scope)):
                bad(where, f"scope {scope!r} is not an arXiv category, archive "
                           f"or group")
            key = (en, scope)
            if key in seen:
                bad(where, "duplicate term at the same scope, and the two rows "
                           "disagree about what the word means")
            seen.add(key)


def check_selection():
    """The four extraction paths, and the rules each one is excused from."""
    doc = load("selection.yaml")
    if doc is None:
        return
    paths = doc.get("paths") or {}
    for name in PATHS:
        if name not in paths:
            bad("selection.yaml", f"path {name} is missing")
    for name, path in paths.items():
        where = f"selection.yaml[paths.{name}]"
        if name not in PATHS:
            bad(where, "is not one of the four extraction paths")
        if not isinstance(path.get("enabled"), bool):
            bad(where, "enabled must be true or false")
    for name, rules in (doc.get("not_applicable") or {}).items():
        where = f"selection.yaml[not_applicable.{name}]"
        if name not in PATHS:
            bad(where, "is not one of the four extraction paths")
        for rule in rules or []:
            if not RULE.match(str(rule)):
                bad(where, f"{rule!r} is not an audit rule id")
        if len(set(rules or [])) != len(rules or []):
            bad(where, "the same rule is excused twice")
    reasons = doc.get("reasons") or []
    if not reasons:
        bad("selection.yaml", "no selection reasons, so no paper can say why "
                              "it is here")
    if len(set(reasons)) != len(reasons):
        bad("selection.yaml", "duplicate selection reason")
    seed = doc.get("seed") or {}
    size = seed.get("size")
    if not isinstance(size, int) or size <= 0:
        bad("selection.yaml[seed]", f"size {size!r} is not a positive integer")
    for licence in seed.get("licences") or []:
        if licence not in LICENCES:
            bad("selection.yaml[seed]", f"licence {licence!r} is not one arXiv "
                                        f"offers")
        if licence in ("cc-by-nc-nd", "arxiv-1.0", "unknown"):
            bad("selection.yaml[seed]", f"licence {licence} forbids derivative "
                                        f"works, so it cannot be seeded into a "
                                        f"corpus we translate")
    per_category = seed.get("max_per_category")
    if per_category is not None and (not isinstance(per_category, int)
                                     or per_category <= 0):
        bad("selection.yaml[seed]", "max_per_category is not a positive integer")


def check_graph():
    """The confidences, the resolution thresholds, and patterns that compile."""
    doc = load("graph.yaml")
    if doc is None:
        return
    if doc.get("confidences") != CONFIDENCES:
        bad("graph.yaml", f"confidences must be exactly {CONFIDENCES}, and an "
                          f"edge that would be lower than medium is a near miss "
                          f"in a report rather than a row in the graph")
    resolution = doc.get("resolution") or {}
    similarity = resolution.get("title_similarity")
    if not isinstance(similarity, (int, float)) or not 0.5 <= similarity <= 1.0:
        bad("graph.yaml[resolution]", f"title_similarity {similarity!r} is not "
                                      f"between 0.5 and 1.0")
    for key in ("year_slack", "surnames_required"):
        value = resolution.get(key)
        if not isinstance(value, int) or value < 0:
            bad("graph.yaml[resolution]", f"{key} {value!r} is not a "
                                          f"non-negative integer")
    patterns = doc.get("locators") or []
    if not patterns:
        bad("graph.yaml", "no locator patterns, so every citation stays at "
                          "paper level")
    for pattern in patterns:
        try:
            re.compile(pattern)
        except re.error as err:
            bad("graph.yaml[locators]", f"{pattern!r} does not compile: {err}")


def check_nothing_binary_is_tracked():
    """Rule S03 in its cheapest form.

    The difference between a corpus and a mirror is this check and one careless
    git add -f. A PDF here would also be a redistribution of somebody else's
    file under a licence we have not read.
    """
    tracked = subprocess.run(
        ["git", "ls-files", "--", "*.pdf", "*.epub", "pdf/", "books/"],
        cwd=ROOT, capture_output=True, text=True, check=True,
    ).stdout.split()
    for path in tracked:
        bad(path, "a built or fetched binary is tracked in a repository that "
                  "commits neither")


def main():
    profiles = check_typeset()
    langs, _ = check_languages(profiles)
    check_glossaries(langs)
    check_selection()
    check_graph()
    check_nothing_binary_is_tracked()
    if problems:
        for p in problems:
            print(p, file=sys.stderr)
        print(f"\n{len(problems)} problem(s)", file=sys.stderr)
        return 1
    print(f"manifests are consistent: {len(langs)} languages, "
          f"{len(profiles)} typesetting profiles")
    return 0


if __name__ == "__main__":
    sys.exit(main())
