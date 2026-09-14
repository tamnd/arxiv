# arxiv

A corpus built from arXiv: every paper's metadata, and the papers whose licence permits it extracted into tagged Markdown, translated into Vietnamese, Chinese and Japanese, connected to each other, and published as web, EPUB, TeX and PDF.

The toolchain that builds it is [tamnd/arxiv-reader](https://github.com/tamnd/arxiv-reader).
This repository is the content, and it is the thing that has to be right.

## Status

M0, which is the manifests and the shape.
No paper has been extracted yet.
The plan is in the issues, one per milestone, M0 through M11.

## Two planes

The corpus has two planes and they have different rules, because arXiv's metadata and arXiv's papers have different licences.

The **metadata plane** covers every paper on arXiv, which is about 3.17 million of them.
arXiv publishes its metadata under CC0, so this plane needs no licence gate and no permission.
It is JSONL, one file per month under `metadata/`, sharded as `YYMM`.
This is what makes search, the category tree, the author index and the citation graph possible across all of arXiv rather than across the part we have read.

The **content plane** is the papers whose licence permits republishing, extracted into Markdown under `content/<lang>/<YYMM>/<id>/`.
It is a small fraction of the first plane and it always will be.
About 40 per cent of arXiv carries a Creative Commons licence and the rest is under arXiv's default distribution licence, which grants arXiv the right to distribute and grants nobody else the right to republish.

## The licence gate

arXiv offers a submitter six licences.
We sort them into four access classes and the class decides what may be built.

| Licence | Access | Text | Figures | Translation |
| --- | --- | --- | --- | --- |
| cc0, cc-by | open | yes | yes | yes |
| cc-by-sa, cc-by-nc-sa | share-alike | yes | yes | yes, under the same licence |
| cc-by-nc-nd | verbatim | yes | yes | no |
| arxiv-1.0 | record | no | no | no |

A translation is a derivative work, so the no-derivatives licence forbids one.
That is not a technicality we work around, it is a line in the audit: rule `P08` fails a build that emits anything for a forbidden access class.

A licence belongs to a version, not to a paper.
A v1 under CC BY and a v2 under the default licence are two different decisions, and the record keeps them apart rather than taking the latest and assuming.

## Layout

```
metadata/2106.jsonl          every paper submitted in June 2021, CC0, no gate
content/en/2106/2106.09685/  the extraction, per paper, per language
content/vi/2106/2106.09685/
figures/2106/2106.09685/     figures, for open and share-alike papers only
tags/2106/2106.09685.yaml    the permanent tag register for that paper
graph/2106.jsonl             edges whose source is a paper in that shard
manifests/                   languages, typesetting, selection, graph, glossaries
reports/                     what the audit found, committed so it can be read in a diff
```

## Permanent tags

Every theorem, lemma, definition, figure, table and result gets a four character tag, borrowed from [the Stacks Project](https://stacks.math.columbia.edu).
A tag is assigned once, never edited, and never reused, even if the thing it names is deleted.
That is what makes a citation of a result stable across every re-extraction, every re-translation and every renumbering upstream.

Tags are scoped per paper here rather than globally, because the arXiv id already carries global identity and a global register across three million papers would collide with nothing useful to show for it.
So a result is `2106.09685/AB12`, and `ax://paper/2106.09685#AB12` resolves to it.

Rule `G08` checks tags against git history and fails if one has ever been removed.

## Languages

English, Vietnamese, Simplified Chinese, Traditional Chinese and Japanese.

Traditional Chinese is converted from the simplified text rather than translated separately, because converting is mechanical with a small exception list and translating twice produces two texts that drift apart at twice the cost.

Adding a language is a row in `manifests/languages.yaml` plus a glossary seed, a typesetting profile, a normalisation rule, a spacing rule and a route that can translate into it.
No code changes.

## The four extraction paths

| Path | Input | Model |
| --- | --- | --- |
| render | arXiv's own LaTeXML HTML5, at `/html/<id>` | none |
| source | the submitted TeX, compiled with LaTeXML here | none |
| native | the PDF's text layer | none |
| vision | page images, read by a vision model | yes |

Three of the four use no model at all.
About 90 per cent of arXiv has TeX source and about 97 per cent of recent submissions have an HTML rendering, so the paths that cost nothing cover almost everything and the vision path is the fallback for scanned submissions from the 1990s.

Which path a paper went down is recorded, and it decides which audit rules apply to it.
A rule the path cannot possibly satisfy is marked not applicable rather than passing, which is the difference between a rule that is working and a rule that has nothing to look at.

## Checking it

The manifest check needs nothing but Python and runs on every pull request.

```sh
pip install pyyaml
python .github/scripts/check_manifests.py
```

The audit is the real contract and it lives in the toolchain.

```sh
go install github.com/tamnd/arxiv-reader/cmd/ax@latest
ARXIV_CORPUS=$PWD ax audit --hard
```

## Related

- [tamnd/arxiv-reader](https://github.com/tamnd/arxiv-reader), the toolchain
- [tamnd/arxiv-cli](https://github.com/tamnd/arxiv-cli), the arXiv surfaces, the id parser and the `ax://` URI space
- [tamnd/papers](https://github.com/tamnd/papers), the same idea at a hundred papers instead of three million
- [the Stacks Project](https://stacks.math.columbia.edu), where the tag system comes from

## Licence

Our own work is CC BY 4.0.
The metadata is CC0, because arXiv publishes it that way.
Each paper stays under the licence its author chose, recorded per version.
See [LICENCE](LICENCE).
