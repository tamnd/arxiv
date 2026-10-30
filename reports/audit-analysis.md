# The audit

382912 records over 3284 papers of the analysis plane, 9667 findings.

| Group | Rules | Pass | Fail | Not run | N/A | Findings |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Analysis | 12 | 7 | 5 | 0 | 0 | 9667 |

## The rules

| ID | State | Checked | Skipped | Findings | Rule |
| --- | --- | ---: | ---: | ---: | --- |
| D01 | pass | 45 | 0 | 0 | each paper in scope (AX1.2) has a paper state: a stage of the ladder of 2166-04, or a reason why it stops |
| D02 | pass | 6763 | 0 | 0 | each extracted version has a census record, and the census record names the extractor version |
| D03 | pass | 3487 | 0 | 0 | each counted occurrence of a theorem-like environment, proof or manual head in the census has an object record, or a waiver with a reason |
| D04 | pass | 64820 | 0 | 0 | each statement object has a proof_status, and a proof_status of here has a proves edge from a proof object |
| D06 | pass | 145575 | 0 | 0 | no object record from a version of class record holds text of the paper, in any field |
| D07 | fail | 3487 | 0 | 3226 | a counter whose numbers have a gap that the census does not explain |
| D08 | fail | 3487 | 0 | 62 | a paper whose source and render counts differ by more than the threshold of AX4.5 |
| D09 | fail | 3487 | 0 | 4547 | an in-paper reference to a theorem-like number or label that resolves to no object |
| D10 | pass | 233805 | 0 | 0 | each edge has a method and a confidence from the closed lists of AX6.1, and no edge whose method is model has the confidence certain or high |
| D13 | pass | 145575 | 0 | 0 | each object record names its path, its extractor version and its confidence |
| D15 | fail | 3487 | 0 | 1609 | an environment name or title that manifests/environments.yaml does not map |
| D19 | fail | 3209 | 0 | 223 | a cycle in the in-paper uses graph (AX6.3) |

## The findings

### D07

A counter whose numbers have a gap that the census does not explain.

```
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#env-2: the counter model gives Theorem 1 and the second witness gives 2.1
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#env-7: the counter model gives Theorem 2 and the second witness gives 3.1
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#env-10: the counter model gives Theorem 3 and the second witness gives 4.1
analysis/census/0709/0709.4546v2.json: 0709.4546v2: 0709.4546v2#env-9:  3.9 is the first in its scope of counter item
analysis/census/0904/0904.2051v1.json: 0904.2051v1: 0904.2051v1#env-1: Theorem 0 is the first in its scope of counter theorem
analysis/census/0904/0904.3493v2.json: 0904.3493v2: 0904.3493v2#env-7: Definition 2.4 comes after 2.2 in counter subsection
analysis/census/0904/0904.3493v2.json: 0904.3493v2: 0904.3493v2#env-10: Observation 3.3 is the first in its scope of counter subsection
analysis/census/0904/0904.3493v2.json: 0904.3493v2: 0904.3493v2#env-11: Proposition 3.5 comes after 3.3 in counter subsection
analysis/census/0904/0904.3493v2.json: 0904.3493v2: 0904.3493v2#env-12: Lemma 3.7 comes after 3.5 in counter subsection
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-1: The Mori Conjecture 1.2 is the first in its scope of counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-3: Theorem 1.5 comes after 1.3 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-5: Theorem 1.10 comes after 1.6 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-6: Lemma 2.5 is the first in its scope of counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-7: Lemma 2.8 comes after 2.5 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-9:  2.11 comes after 2.9 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-10: Theorem 2.13 comes after 2.11 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-11: Corollary 2.16 comes after 2.13 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-13: Corollary 2.21 comes after 2.17 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-14: Remark 2.23 comes after 2.21 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-16:  3.6 comes after 3.1 in counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-18: Theorem 4.4 is the first in its scope of counter equation
analysis/census/0906/0906.2853v5.json: 0906.2853v5: 0906.2853v5#env-19: Lemma 4.8 comes after 4.4 in counter equation
analysis/census/1004/1004.4564v1.json: 1004.4564v1: 1004.4564v1#env-34: Case I is the first in its scope of counter case
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-1: Theorem 1.2 is the first in its scope of counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-4: Theorem 1.6 comes after 1.4 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-6: Lemma 2.3 is the first in its scope of counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-11: Lemma 2.9 comes after 2.7 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-12: Corollary 2.11 comes after 2.9 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-13: Theorem 2.13 comes after 2.11 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-14: Remark 2.15 comes after 2.13 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-16: Theorem 2.18 comes after 2.16 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-18: Corollary 3.3 comes after 3.1 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-22: Lemma 4.5 comes after 4.3 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-26: Lemma 4.12 comes after 4.8 in counter equation
analysis/census/1008/1008.4254v3.json: 1008.4254v3: 1008.4254v3#env-28:  4.15 comes after 4.13 in counter equation
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-1: the counter model gives Definition 2.1 and the second witness gives II.1
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-2: the counter model gives Definition 2.2 and the second witness gives II.2
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-3: the counter model gives Definition 2.3 and the second witness gives II.3
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-4: the counter model gives Definition 2.4 and the second witness gives II.4
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-5: the counter model gives Theorem 3.1 and the second witness gives III.1
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-6: the counter model gives Corollary 3.2 and the second witness gives III.2
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-7: the counter model gives Corollary 3.3 and the second witness gives III.3
analysis/census/1610/1610.01054v2.json: 1610.01054v2: 1610.01054v2#env-8: the counter model gives Lemma 3.4 and the second witness gives III.4
analysis/census/1802/1802.02910v3.json: 1802.02910v3: 1802.02910v3#env-6: D\'efinition 02 comes after 03 in counter equation
analysis/census/1802/1802.02910v3.json: 1802.02910v3: 1802.02910v3#env-10: Remarque 01 comes after 05 in counter equation
analysis/census/1802/1802.02910v3.json: 1802.02910v3: 1802.02910v3#env-13: Lemme 05 comes after 03 in counter equation
analysis/census/1802/1802.02910v3.json: 1802.02910v3: 1802.02910v3#env-21: Corollaire 014 comes after 012 in counter equation
analysis/census/1802/1802.02910v3.json: 1802.02910v3: 1802.02910v3#env-22: Remarque 01 comes after 014 in counter equation
analysis/census/1802/1802.02910v3.json: 1802.02910v3: 1802.02910v3#env-31: Fait 011 comes after 09 in counter equation
analysis/census/1802/1802.02910v3.json: 1802.02910v3: 1802.02910v3#env-32: Fait 013 comes after 011 in counter equation
```

And 3176 more findings, not listed.

### D08

A paper whose source and render counts differ by more than the threshold of AX4.5.

```
analysis/census/2407/2407.06927v2.json: 2407.06927v2: the source has 11 theorem environments and the render has 13
analysis/census/2411/2411.16022v1.json: 2411.16022v1: the source has 52 theorem environments and the render has 49
analysis/census/2506/2506.21337v2.json: 2506.21337v2: the source has 39 theorem environments and the render has 33
analysis/census/2606/2606.21391v1.json: 2606.21391v1: the source has 46 theorem environments and the render has 30
analysis/census/2609/2609.39747v2.json: 2609.39747v2: the source has 20 theorem environments and the render has 23
analysis/census/2609/2609.40080v1.json: 2609.40080v1: the source has 4 theorem environments and the render has 14
analysis/census/2610/2610.05512v1.json: 2610.05512v1: the render has 19 theorems and 7 proofs, and the source has 19 and 0
analysis/census/2610/2610.06152v1.json: 2610.06152v1: the render has 110 theorems and 58 proofs, and the source has 110 and 0
analysis/census/2610/2610.06165v1.json: 2610.06165v1: the source has 0 theorem environments and the render has 32
analysis/census/2610/2610.06480v2.json: 2610.06480v2: the source has 79 theorem environments and the render has 85
analysis/census/2610/2610.06490v2.json: 2610.06490v2: the source has 130 theorem environments and the render has 136
analysis/census/2610/2610.06875v1.json: 2610.06875v1: the render has 35 theorems and 24 proofs, and the source has 35 and 0
analysis/census/2610/2610.07240v1.json: 2610.07240v1: the render has 70 theorems and 0 proofs, and the source has 70 and 30
analysis/census/2610/2610.07360v1.json: 2610.07360v1: the source has 0 theorem environments and the render has 7
analysis/census/2610/2610.08149v1.json: 2610.08149v1: the render has 12 theorems and 0 proofs, and the source has 12 and 12
analysis/census/2610/2610.08210v1.json: 2610.08210v1: the source has 22 theorem environments and the render has 24
analysis/census/2610/2610.08583v1.json: 2610.08583v1: the source has 45 theorem environments and the render has 49
analysis/census/2610/2610.09044v1.json: 2610.09044v1: the source has 33 theorem environments and the render has 35
analysis/census/2610/2610.09314v1.json: 2610.09314v1: the source has 32 theorem environments and the render has 30
analysis/census/2610/2610.10257v1.json: 2610.10257v1: the source has 8 theorem environments and the render has 32
analysis/census/2610/2610.10660v1.json: 2610.10660v1: the render has 11 theorems and 9 proofs, and the source has 11 and 0
analysis/census/2610/2610.10745v1.json: 2610.10745v1: the source has 45 theorem environments and the render has 57
analysis/census/2610/2610.10804v1.json: 2610.10804v1: the render has 36 theorems and 10 proofs, and the source has 36 and 13
analysis/census/2610/2610.11679v1.json: 2610.11679v1: the source has 20 theorem environments and the render has 15
analysis/census/2610/2610.11757v1.json: 2610.11757v1: the source has 25 theorem environments and the render has 22
analysis/census/2610/2610.11760v1.json: 2610.11760v1: the source has 24 theorem environments and the render has 15
analysis/census/2610/2610.12120v1.json: 2610.12120v1: the source has 12 theorem environments and the render has 29
analysis/census/2610/2610.12484v1.json: 2610.12484v1: the render has 102 theorems and 40 proofs, and the source has 102 and 30
analysis/census/2610/2610.12544v1.json: 2610.12544v1: the source has 35 theorem environments and the render has 33
analysis/census/2610/2610.12716v1.json: 2610.12716v1: the source has 23 theorem environments and the render has 26
analysis/census/2610/2610.12808v1.json: 2610.12808v1: the source has 2 theorem environments and the render has 7
analysis/census/2610/2610.12888v1.json: 2610.12888v1: the source has 7 theorem environments and the render has 0
analysis/census/2610/2610.13355v1.json: 2610.13355v1: the source has 0 theorem environments and the render has 35
analysis/census/2610/2610.14973v1.json: 2610.14973v1: the source has 5 theorem environments and the render has 10
analysis/census/2610/2610.14979v1.json: 2610.14979v1: the render has 12 theorems and 0 proofs, and the source has 12 and 8
analysis/census/2610/2610.15340v1.json: 2610.15340v1: the source has 148 theorem environments and the render has 5
analysis/census/2610/2610.15720v1.json: 2610.15720v1: the render has 54 theorems and 28 proofs, and the source has 54 and 0
analysis/census/2610/2610.15809v1.json: 2610.15809v1: the render has 15 theorems and 2 proofs, and the source has 15 and 0
analysis/census/2610/2610.16094v1.json: 2610.16094v1: the source has 50 theorem environments and the render has 37
analysis/census/2610/2610.16245v1.json: 2610.16245v1: the render has 15 theorems and 0 proofs, and the source has 15 and 3
analysis/census/2610/2610.16267v1.json: 2610.16267v1: the source has 47 theorem environments and the render has 2
analysis/census/2610/2610.16328v1.json: 2610.16328v1: the source has 5 theorem environments and the render has 7
analysis/census/2610/2610.16408v1.json: 2610.16408v1: the source has 8 theorem environments and the render has 14
analysis/census/2610/2610.16461v1.json: 2610.16461v1: the source has 7 theorem environments and the render has 1
analysis/census/2610/2610.16561v1.json: 2610.16561v1: the render has 17 theorems and 7 proofs, and the source has 16 and 27
analysis/census/2610/2610.17317v1.json: 2610.17317v1: the source has 0 theorem environments and the render has 17
analysis/census/2610/2610.17897v1.json: 2610.17897v1: the render has 15 theorems and 10 proofs, and the source has 15 and 0
analysis/census/2610/2610.18312v2.json: 2610.18312v2: the render has 23 theorems and 0 proofs, and the source has 23 and 15
analysis/census/2610/2610.18739v1.json: 2610.18739v1: the render has 18 theorems and 13 proofs, and the source has 18 and 2
analysis/census/2610/2610.19088v1.json: 2610.19088v1: the source has 65 theorem environments and the render has 74
```

And 12 more findings, not listed.

### D09

An in-paper reference to a theorem-like number or label that resolves to no object.

```
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-8: the text names notation A and the census has no such item (no-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-159: the text names rule \ref{alg:Adapt} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-165: the text names Rule \ref{alg:Extend} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-166: the text names rule \ref{alg:Grow.active} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-167: the text names rule \ref{alg:Grow.passive} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-172: the text names rule \ref{alg:March} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-174: the text names Rule \ref{alg:Heal-revive} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-180: the text names Condition \ref{cond:anim,kill} and the census has no such item (no-label)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-185: the text names rule \ref{alg:Freeze} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-191: the text names Condition \ref{cond:anim,kill} and the census has no such item (no-label)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-204: the text names Condition \ref{cond:anim,kill} and the census has no such item (no-label)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-212: the text names Condition \ref{cond:anim,kill} and the census has no such item (no-label)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-238: the text names rule \ref{alg:March} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-246: the text names rule \ref{alg:End-heal} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-255: the text names rule \ref{alg:copy-1} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-257: the text names Rule \ref{alg:Decode} and the census has no such item (not-an-item)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-322: the text names Condition \ref{cond:anim,kill} and the census has no such item (no-label)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-323: the text names Condition \ref{cond:anim,kill} and the census has no such item (no-label)
analysis/census/0003/math-0003117v2.json: math/0003117v2: math/0003117v2#textref-371: the text names Theorem 3.10 and the census has no such item (no-item)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-1: the text names Proposition \ref{WWW} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-2: the text names Proposition \ref{WWW} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-3: the text names Definition \ref{CV-def} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-4: the text names Theorem \ref{psi-conditionals} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-5: the text names Theorem \ref{psi-conditionals} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-6: the text names Corollary \ref{q-reg3} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-7: the text names Lemma \ref{switch} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-8: the text names Lemma \ref{switch} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-9: the text names Lemma \ref{switch} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-10: the text names Lemma \ref{switch} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-11: the text names Theorem \ref{q-reg classic} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-12: the text names Proposition \ref{WWW} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-13: the text names Theorem \ref{q-Bell} and the census has no such item (no-label)
analysis/census/0009/math-0009023v3.json: math/0009023v3: math/0009023v3#textref-14: the text names Example \ref{E1} and the census has no such item (no-label)
analysis/census/0301/math-0301148v3.json: math/0301148v3: math/0301148v3#textref-13: the text names Theorem 8.1 and the census has no such item (no-item)
analysis/census/0301/math-0301148v3.json: math/0301148v3: math/0301148v3#textref-14: the text names Corollary 1.1.3 and the census has no such item (no-item)
analysis/census/0312/math-0312342v3.json: math/0312342v3: math/0312342v3#textref-1: the text names Theorem 5.1.4 and the census has no such item (no-item)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-1: the text names Theorem \ref{1} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-2: the text names corollary A and the census has no such item (no-item)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-3: the text names Theorem \ref{dec} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-4: the text names theorem \ref{1} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-5: the text names Proposition \ref{wm-localization} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-6: the text names Lemma \ref{well-mixed1} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-7: the text names Theorem V and the census has no such item (no-item)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-8: the text names Proposition \ref{wm-localization} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-9: the text names Lemma \ref{tdim-prep} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-10: the text names Lemma \ref{dim-alg} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-11: the text names Lemma \ref{total-dim-base-change} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-12: the text names Lemma \ref{total-dim-base-change} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-13: the text names Proposition \ref{trans-0} and the census has no such item (no-label)
analysis/census/0406/math-0406514v2.json: math/0406514v2: math/0406514v2#textref-14: the text names Lemma \ref{dim-alg} and the census has no such item (no-label)
```

And 4497 more findings, not listed.

### D15

An environment name or title that manifests/environments.yaml does not map.

```
analysis/census/0406/math-0406514v2.json: math/0406514v2: environment sta with the title "" has no item kind
analysis/census/0406/math-0406514v2.json: math/0406514v2: occurrence math/0406514v2#env-23 of sta with the title "" has no item kind
analysis/census/0406/math-0406514v2.json: math/0406514v2: occurrence math/0406514v2#env-223 of sta with the title "" has no item kind
analysis/census/0406/math-0406514v2.json: math/0406514v2: occurrence math/0406514v2#env-232 of sta with the title "" has no item kind
analysis/census/0406/math-0406514v2.json: math/0406514v2: occurrence math/0406514v2#env-233 of sta with the title "" has no item kind
analysis/census/0406/math-0406514v2.json: math/0406514v2: occurrence math/0406514v2#env-234 of sta with the title "" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-1 of theo with the title "\\labeln2" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-2 of theo with the title "" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-3 of theo with the title "" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-4 of theo with the title "\\citeast.ge" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-5 of theo with the title "" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-6 of theo with the title "" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-7 of theo with the title "" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-8 of theo with the title "" has no item kind
analysis/census/0709/0709.4546v2.json: 0709.4546v2: occurrence 0709.4546v2#env-9 of theo with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: environment setup with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: environment case with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: occurrence 0805.4273v2#env-8 of setup with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: occurrence 0805.4273v2#env-9 of setup with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: occurrence 0805.4273v2#env-10 of setup with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: occurrence 0805.4273v2#env-11 of setup with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: occurrence 0805.4273v2#env-21 of setup with the title "" has no item kind
analysis/census/0805/0805.4273v2.json: 0805.4273v2: occurrence 0805.4273v2#env-34 of setup with the title "" has no item kind
analysis/census/0902/0902.4479v2.json: 0902.4479v2: environment pr1 with the title "" has no item kind
analysis/census/0904/0904.0817v7.json: 0904.0817v7: environment context with the title "Context" has no item kind
analysis/census/0906/0906.2853v5.json: 0906.2853v5: environment subsec with the title "" has no item kind
analysis/census/0906/0906.2853v5.json: 0906.2853v5: occurrence 0906.2853v5#env-9 of subsec with the title "" has no item kind
analysis/census/0906/0906.2853v5.json: 0906.2853v5: occurrence 0906.2853v5#env-15 of subsec with the title "" has no item kind
analysis/census/0906/0906.2853v5.json: 0906.2853v5: occurrence 0906.2853v5#env-16 of subsec with the title "" has no item kind
analysis/census/0906/0906.2853v5.json: 0906.2853v5: occurrence 0906.2853v5#env-17 of subsec with the title "" has no item kind
analysis/census/0906/0906.2853v5.json: 0906.2853v5: occurrence 0906.2853v5#env-20 of subsec with the title "" has no item kind
analysis/census/0906/0906.2853v5.json: 0906.2853v5: occurrence 0906.2853v5#env-21 of subsec with the title "" has no item kind
analysis/census/1004/1004.4564v1.json: 1004.4564v1: environment application* with the title "Application" has no item kind
analysis/census/1008/1008.4254v3.json: 1008.4254v3: environment argument with the title "Argument" has no item kind
analysis/census/1008/1008.4254v3.json: 1008.4254v3: environment subsec with the title "" has no item kind
analysis/census/1008/1008.4254v3.json: 1008.4254v3: occurrence 1008.4254v3#env-28 of subsec with the title "" has no item kind
analysis/census/1008/1008.4254v3.json: 1008.4254v3: occurrence 1008.4254v3#env-29 of subsec with the title "" has no item kind
analysis/census/1008/1008.4254v3.json: 1008.4254v3: occurrence 1008.4254v3#env-30 of subsec with the title "" has no item kind
analysis/census/1107/1107.2621v3.json: 1107.2621v3: environment Problem with the title "" has no item kind
analysis/census/1704/1704.04089v1.json: 1704.04089v1: environment thesis with the title "Thesis" has no item kind
analysis/census/1709/1709.00677v1.json: 1709.00677v1: environment namedtheorem with the title "\\theoremname" has no item kind
analysis/census/1709/1709.00677v1.json: 1709.00677v1: environment named with the title "\\theoremname" has no item kind
analysis/census/1803/1803.10042v2.json: 1803.10042v2: environment Characterization with the title "Characterization" has no item kind
analysis/census/1806/1806.00877v4.json: 1806.00877v4: environment assumption with the title "A\\!\\!" has no item kind
analysis/census/1806/1806.00877v4.json: 1806.00877v4: occurrence 1806.00877v4#env-2 of assumption with the title "A\\!\\!" has no item kind
analysis/census/1806/1806.00877v4.json: 1806.00877v4: occurrence 1806.00877v4#env-3 of assumption with the title "A\\!\\!" has no item kind
analysis/census/1806/1806.05002v2.json: 1806.05002v2: environment bl with the title "Bergelson--Leibman" has no item kind
analysis/census/1806/1806.05002v2.json: 1806.05002v2: environment rado with the title "Rado's criterion for one equation" has no item kind
analysis/census/1806/1806.05002v2.json: 1806.05002v2: occurrence 1806.05002v2#env-3 of rado with the title "Rado's criterion for one equation" has no item kind
analysis/census/1806/1806.05002v2.json: 1806.05002v2: occurrence 1806.05002v2#env-37 of bl with the title "Bergelson--Leibman" has no item kind
```

And 1559 more findings, not listed.

### D19

A cycle in the in-paper uses graph (AX6.3).

The in-paper uses graph must be acyclic. In most cases a refers-to was read as uses, and the fix is in the cue lists.

```
analysis/edges/0512/math-0512416.md: math/0512416v11: 2 uses edges are in a cycle
analysis/edges/0803/0803.0074.md: 0803.0074v1: 2 uses edges are in a cycle
analysis/edges/0806/0806.0678.md: 0806.0678v1: 3 uses edges are in a cycle
analysis/edges/0910/0910.5574.md: 0910.5574v1: 4 uses edges are in a cycle
analysis/edges/1503/1503.05744.md: 1503.05744v1: 7 uses edges are in a cycle
analysis/edges/2108/2108.01302.md: 2108.01302v1: 2 uses edges are in a cycle
analysis/edges/2108/2108.03672.md: 2108.03672v2: 13 uses edges are in a cycle
analysis/edges/2111/2111.00832.md: 2111.00832v3: 2 uses edges are in a cycle
analysis/edges/2203/2203.00606.md: 2203.00606v1: 2 uses edges are in a cycle
analysis/edges/2207/2207.07461.md: 2207.07461v1: 2 uses edges are in a cycle
analysis/edges/2208/2208.07401.md: 2208.07401v2: 3 uses edges are in a cycle
analysis/edges/2208/2208.07784.md: 2208.07784v2: 2 uses edges are in a cycle
analysis/edges/2212/2212.06621.md: 2212.06621v2: 2 uses edges are in a cycle
analysis/edges/2303/2303.09207.md: 2303.09207v1: 43 uses edges are in a cycle
analysis/edges/2312/2312.14445.md: 2312.14445v1: 2 uses edges are in a cycle
analysis/edges/2403/2403.15255.md: 2403.15255v4: 11 uses edges are in a cycle
analysis/edges/2404/2404.13734.md: 2404.13734v2: 3 uses edges are in a cycle
analysis/edges/2405/2405.05684.md: 2405.05684v1: 6 uses edges are in a cycle
analysis/edges/2405/2405.10580.md: 2405.10580v1: 3 uses edges are in a cycle
analysis/edges/2407/2407.20385.md: 2407.20385v4: 2 uses edges are in a cycle
analysis/edges/2411/2411.05198.md: 2411.05198v1: 7 uses edges are in a cycle
analysis/edges/2411/2411.16655.md: 2411.16655v1: 7 uses edges are in a cycle
analysis/edges/2412/2412.14956.md: 2412.14956v3: 15 uses edges are in a cycle
analysis/edges/2412/2412.20238.md: 2412.20238v1: 8 uses edges are in a cycle
analysis/edges/2503/2503.00560.md: 2503.00560v2: 3 uses edges are in a cycle
analysis/edges/2503/2503.08018.md: 2503.08018v4: 29 uses edges are in a cycle
analysis/edges/2504/2504.14383.md: 2504.14383v2: 6 uses edges are in a cycle
analysis/edges/2508/2508.17181.md: 2508.17181v1: 9 uses edges are in a cycle
analysis/edges/2509/2509.10268.md: 2509.10268v2: 2 uses edges are in a cycle
analysis/edges/2601/2601.13782.md: 2601.13782v5: 2 uses edges are in a cycle
analysis/edges/2609/2609.01324.md: 2609.01324v2: 12 uses edges are in a cycle
analysis/edges/2609/2609.18777.md: 2609.18777v2: 2 uses edges are in a cycle
analysis/edges/2609/2609.29326.md: 2609.29326v1: 9 uses edges are in a cycle
analysis/edges/2609/2609.33154.md: 2609.33154v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.33327.md: 2609.33327v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.33529.md: 2609.33529v1: 3 uses edges are in a cycle
analysis/edges/2609/2609.33578.md: 2609.33578v2: 5 uses edges are in a cycle
analysis/edges/2609/2609.33733.md: 2609.33733v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.33775.md: 2609.33775v1: 3 uses edges are in a cycle
analysis/edges/2609/2609.34081.md: 2609.34081v1: 3 uses edges are in a cycle
analysis/edges/2609/2609.34193.md: 2609.34193v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.34852.md: 2609.34852v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.35030.md: 2609.35030v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.35204.md: 2609.35204v1: 9 uses edges are in a cycle
analysis/edges/2609/2609.35339.md: 2609.35339v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.35360.md: 2609.35360v1: 6 uses edges are in a cycle
analysis/edges/2609/2609.35600.md: 2609.35600v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.35762.md: 2609.35762v1: 47 uses edges are in a cycle
analysis/edges/2609/2609.36204.md: 2609.36204v1: 2 uses edges are in a cycle
analysis/edges/2609/2609.36411.md: 2609.36411v1: 3 uses edges are in a cycle
```

And 173 more findings, not listed.
