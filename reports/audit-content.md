# The audit

12 files over 1 paper of the content plane, nothing found.

| Group | Rules | Pass | Fail | Not run | N/A | Findings |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Sources | 5 | 5 | 0 | 0 | 0 | 0 |
| Structure | 13 | 13 | 0 | 0 | 0 | 0 |
| Mathematics | 12 | 12 | 0 | 0 | 0 | 0 |
| Figures | 11 | 11 | 0 | 0 | 0 | 0 |
| References | 6 | 4 | 0 | 2 | 0 | 0 |
| Tags | 6 | 6 | 0 | 0 | 0 | 0 |
| Objects | 1 | 1 | 0 | 0 | 0 | 0 |

## The rules

| ID | State | Checked | Findings | Rule |
| --- | --- | ---: | ---: | --- |
| S01 | pass | 12 | 0 | no content file exists for a paper the corpus may not publish the text of |
| S04 | pass | 1 | 0 | every paper in the content plane has a record in the metadata plane |
| S07 | pass | 12 | 0 | every content file names the version it was taken from, and the plane has that version |
| S10 | pass | 12 | 0 | every content file's licence was read off the abs page |
| S12 | pass | 12 | 0 | every content file's licence is the one the plane holds for the version it names |
| T01 | pass | 12 | 0 | every content file parses: front matter, then body |
| T02 | pass | 12 | 0 | every front matter field is known and typed |
| T03 | pass | 12 | 0 | content_sha256 matches the body as it stands |
| T04 | pass | 1 | 0 | section numbers within a paper are contiguous from 0 |
| T05 | pass | 12 | 0 | the heading tree is well formed: no level skipped |
| T06 | pass | 1 | 0 | every paper has a 00_front.md with an abstract |
| T07 | pass | 1 | 0 | every paper with a reference section has it last, or last before its appendices |
| T08 | pass | 11 | 0 | no section body under 200 characters, which is a split that went wrong |
| T09 | pass | 12 | 0 | no section body over 40,000 characters, which is a split that did not happen |
| T10 | pass | 12 | 0 | no page furniture left in the body: running heads, bare folios, arXiv's own stamp |
| T11 | pass | 12 | 0 | no raw HTML markup left in a body |
| T12 | pass | 12 | 0 | no link left pointing at an anchor this paper does not have |
| T13 | pass | 12 | 0 | no word left split at the hyphen the page broke it with |
| M01 | pass | 12 | 0 | every math span is closed |
| M02 | pass | 1 | 0 | the number sets are \mathbb, consistently |
| M03 | pass | 12 | 0 | no character stranded out of its TeX |
| M05 | pass | 12 | 0 | no illegible marker left in the corpus |
| M07 | pass | 12 | 0 | no bracket from the prose closes inside the mathematics |
| M08 | pass | 12 | 0 | no matrix left flattened into a pair of scripts |
| M09 | pass | 12 | 0 | no base carries two superscripts or two subscripts |
| M10 | pass | 12 | 0 | no relation sign has lost the stroke that negates it |
| M11 | pass | 12 | 0 | the mathematics is written between dollars, never \( or \[ |
| M12 | pass | 12 | 0 | an inline formula is written tight against its dollars |
| M13 | pass | 12 | 0 | no $ inside a fenced code block opened a span |
| M14 | pass | 1 | 0 | a paper with mathematics in its prose has mathematics in its markup |
| F01 | pass | 26 | 0 | every figure a file references exists on disk |
| F02 | pass | 14 | 0 | no figure under 100 by 100 pixels |
| F03 | pass | 14 | 0 | no figure over 500 KB |
| F05 | pass | 14 | 0 | no two figures within one paper have the same bytes |
| F06 | pass | 14 | 0 | no figure that covers more than three quarters of a page |
| F07 | pass | 1 | 0 | the figure manifest loads, and every numbered figure in it has a caption |
| F08 | pass | 1 | 0 | every figure of a record paper is absent |
| F09 | pass | 16 | 0 | no figure suspected or confirmed to be third party has its bytes committed |
| F10 | pass | 1 | 0 | every figure the paper numbers is present |
| F11 | pass | 1 | 0 | every table exists twice, as <n>.md and as <n>.tex |
| F12 | pass | 15 | 0 | a table's .md and .tex agree on row count, column count and every numeric cell |
| R01 | pass | 1 | 0 | every arXiv id written down in this corpus names a paper the metadata plane has |
| R02 | pass | 12 | 0 | every citation in a body has an entry in that paper's bibliography |
| R03 | pass | 1 | 0 | every paper's bibliography loads, and every entry in it keeps the line the paper printed |
| R04 | not run | 0 | 0 | every resolved reference still resolves that way |
| R05 | not run | 0 | 0 | no reference resolves to the paper that is citing it |
| R06 | pass | 116 | 0 | no citation runs forward in time by more than two years |
| G01 | pass | 1 | 0 | every tag is four characters from the Stacks alphabet |
| G02 | pass | 12 | 0 | every tag reference names a paper as well as a tag |
| G03 | pass | 1 | 0 | no tag appears twice in one paper's register |
| G04 | pass | 1 | 0 | no local identifier appears twice in one paper's register |
| G05 | pass | 12 | 0 | every tag in a body is in that paper's register, against that object |
| G06 | pass | 12 | 0 | every taggable object in a body carries a tag |
| X01 | pass | 12 | 0 | every object's kind is one of the sixteen |
