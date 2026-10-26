# The audit

794914 records over 421 months of the meta plane, nothing found.

| Group | Rules | Pass | Fail | Not run | N/A | Findings |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Sources | 12 | 12 | 0 | 0 | 0 | 0 |

## The rules

| ID | State | Checked | Skipped | Findings | Rule |
| --- | --- | ---: | ---: | ---: | --- |
| S05 | pass | 794914 | 0 | 0 | every licence field holds one of the values arXiv actually issues |
| S13 | pass | 794914 | 0 | 0 | every record's identifier is one arXiv could have issued, in either scheme |
| S14 | pass | 794914 | 0 | 0 | every record is filed in the month its identifier names |
| S15 | pass | 794914 | 0 | 0 | no identifier appears twice in a month |
| S16 | pass | 794914 | 0 | 0 | every record has a title, an abstract, a category and at least one version |
| S17 | pass | 794914 | 0 | 0 | a record's versions are numbered from v1 with no gaps |
| S18 | pass | 794914 | 0 | 0 | a record's versions are dated in the order they were announced |
| S19 | pass | 794914 | 0 | 0 | no version is dated after the day the record was harvested |
| S20 | pass | 794914 | 0 | 0 | no paper's first version is dated after the month its identifier names |
| S21 | pass | 794914 | 0 | 0 | every record names the surface it was read from |
| S22 | pass | 794914 | 0 | 0 | every category is an archive, or an archive and a subclass |
| S23 | pass | 794914 | 0 | 0 | every month's file is in identifier order |

## The waivers

92 findings are waived. A waived finding does not fail its rule. Each waiver names the record, the rule and the reason.

| ID | Waived |
| --- | ---: |
| S18 | 19 |
| S20 | 73 |
