# The audit

6 records over 2 papers of the analysis plane, nothing found.

| Group | Rules | Pass | Fail | Not run | N/A | Findings |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Analysis | 9 | 9 | 0 | 0 | 0 | 0 |

## The rules

| ID | State | Checked | Skipped | Findings | Rule |
| --- | --- | ---: | ---: | ---: | --- |
| D02 | pass | 3 | 0 | 0 | each extracted version has a census record, and the census record names the extractor version |
| D03 | pass | 2 | 0 | 0 | each counted occurrence of a theorem-like environment, proof or manual head in the census has an object record, or a waiver with a reason |
| D04 | pass | 1 | 0 | 0 | each statement object has a proof_status, and a proof_status of here has a proves edge from a proof object |
| D06 | pass | 4 | 0 | 0 | no object record from a version of class record holds text of the paper, in any field |
| D07 | pass | 2 | 0 | 0 | a counter whose numbers have a gap that the census does not explain |
| D08 | pass | 2 | 0 | 0 | a paper whose source and render counts differ by more than the threshold of AX4.5 |
| D09 | pass | 2 | 0 | 0 | an in-paper reference to a theorem-like number or label that resolves to no object |
| D13 | pass | 4 | 0 | 0 | each object record names its path, its extractor version and its confidence |
| D15 | pass | 2 | 0 | 0 | an environment name or title that manifests/environments.yaml does not map |
