# The score of the extractor on gold set X v1

The set has 500 papers. 463 have a marked record (463 by claude-opus-5-5 (LLM pass chosen by the owner; not a person)), and 0 have a proposed record only. Only the marked records are scored. The extractor is ax/dev.

| Measure | Value | Target |
| --- | ---: | ---: |
| structural recall | 99.5% (21,108 of 21,212) | 99.5% |
| structural precision | 99.6% (21,108 of 21,191) | 99.0% |
| prose recall | 0.0% (0 of 1,216) | 90.0% |
| number accuracy | 99.7% (14,317 of 14,365) | 99.5% |
| attachment accuracy | 98.5% (6,164 of 6,258) | 98.0% |
| proof_status accuracy | 76.9% (6,898 of 8,969) | measured |
| census strength strong or normal | 100.0% (463 of 463) | 95.0% |

## Structural recall by decade

| Decade | Recall | Target |
| --- | ---: | ---: |
| 1991-2000 | 99.1% (1,477 of 1,491) | 98.0% |
| 2001-2010 | 98.8% (3,439 of 3,481) | 98.0% |
| 2011-2020 | 99.6% (3,885 of 3,900) | 98.0% |
| 2021-2026 | 99.7% (12,307 of 12,340) | 98.0% |

## Papers with a missed or an extra item

Each one is a pattern to find and fix (AX4.9).

| Paper | Missed | Extra |
| --- | --- | --- |
| math/0003117v2 |  | head-1, head-2, head-5 |
| alg-geom/9506022v2 | definition-prose-primitive, notation-1.3, definition-1.4, definition-1.13, definition-prose-primitive-contraction | say-3, say-4, say-7 |
| math/0009023v3 | definition-prose-1, definition-prose-2, definition-prose-3 |  |
| math/9807180v2 | conclusion-2.6 | conclusion-3 |
| math/9908107v14 | theorem-poincare-verdier, definition-ic, definition-nearby-cycles, definition-vanishing-cycles, definition-stratified-critical-point, definition-heart, definition-perverse-t-structure, definition-intermediate-extension |  |
| math/0008020v2 | def-poset-lattice, def-partition, def-dominance, def-cliff-plateau-step, def-transition, def-notation-inc-dirreach, def-lbi, def-tlbi, def-tb |  |
| math/9901049v4 | def-coxeter-system, def-equivalent, def-right-angled, def-nerve, def-davis-vinberg | head-1 |
| hep-th/9409063v2 | def-braces, def-mult-operad, def-mult-brace, def-g-algebra, def-ainf-mult, def-left-noninc, def-dg-bialg |  |
| math/9201244v2 | def-canonical-upper-bound, stage-G-claim, case-4.1-limit, case-4.1-succ-of-limit, case-4.1-succ-of-succ, case-4.1-zero-one |  |
| alg-geom/9712012v2 | remark-erratum-2012 |  |
| math/9802134v3 | def-prose-square, def-prose-souslin, def-prose-lambda-tree, def-prose-Fr, def-prose-cl, conclusion-2.4, conclusion-4.10 | conclusion-4, conclusion-6 |
| math/9602216v3 | adj-x1-head-1 | head-1 |
| math/9801068v3 |  | ack-1, funding-1 |
| 1001.1196v3 | prose-lower, prose-newton-basis |  |
| 0910.5574v1 | def-p-faithful, def-p-generically-free, def-limit-preserving, def-lattice, def-quasi-split, def-genus | head-1 |
| 1004.4564v1 | theorem-restate-5.5, theorem-restate-6.2, prose-induced-track, prose-accessible-interval, prose-marking-graph, prose-train-track-graph |  |
| 0810.0962v1 | prose-height, prose-nbhd-infty, prose-novsik-ring, prose-novsik-homology, prose-filtration |  |
| 0904.3493v2 | def-prose-central-oval, def-prose-skewloop-intro, def-prose-tilt, def-prose-support-map, def-prose-transverse-support-function, def-prose-translate, case-paraboloid |  |
| 0805.4273v2 | def-canonical-dimension, def-pencil |  |
| 0904.2839v1 | problem-P, def-nilpotent, def-reduced, def-U-injective, example-6.3 |  |
| 1008.2480v5 | def-prose-hyperkahler, def-prose-coarse-moduli, def-prose-mapping-class-group, def-prose-teichmuller, def-prose-polarized-teichmuller, def-prose-polarized-moduli, def-prose-inseparable, def-prose-birational-moduli, step-1, proof-2, proof-3 |  |
| 1006.4617v1 | def-prose-1, def-prose-2, def-prose-3 |  |
| 0905.1489v1 | def-mixed-complex, def-beta-acyclic, def-power-maps |  |
| 0809.4587v1 | theorem-B |  |
| 1012.1190v1 | prose-class-leading, prose-resultant, prose-noncontradictory, algorithm-charsera, prose-unmixed |  |
| 1006.3331v2 | def-heis-isom, def-isometric-sphere, def-euclidean-picard, case-i, case-ii, def-spinal-sphere | head-1, head-2, head-3 |
| 0911.1417v4 | definition-massey-triple |  |
| 0906.2853v5 | def-mori-constant, def-quasiconformal, def-ring-capacity, def-distortion-function, def-teichmuller-function, def-hersch-pfluger |  |
| 0905.2181v1 |  | head-1 |
| 1009.2043v1 | def-frame-bounds, def-preframe-op, def-frame-op, remark-manual |  |
| 0807.1652v1 | def-adjacent-pairs, algorithm-1, step-3 |  |
| 0906.4245v1 | def-early-crossing, def-zeta |  |
| 0909.0714v2 | def-hoaf, def-homotopy-functional, def-iterated-integral, def-geometric-origin, def-cuspidal, def-primitive |  |
| 0811.0544v4 | def-lim-downarrow, def-condition-H |  |
| 1009.3308v1 | definition-gevrey |  |
| 1007.4365v1 | def-stellar, def-inversion-set, def-flattening-map, proof-2, proof-4 |  |
| 0905.2248v3 | def-prose-error-pattern, remark-subsec |  |
| 1011.5380v2 | def-extrinsic-distance |  |
| 0806.0678v1 | definition-admissible |  |
| 0806.0033v1 | definition-lattice, definition-signed-measure |  |
| 0906.3062v3 | prose-substitute-conservative-system |  |
| math/0411039v3 | def-verbally-complete, def-contiguity-subdiagram, def-reduced-diagram, def-O-equivalent, def-path-without-backtracking |  |
| 1007.0842v5 | def-sobolev-norm |  |
| 0808.1331v2 | prose-semistar, prose-stable, prose-star-dim, prose-noeth-pmd-qprufer, prose-catenarian, prose-strongS, prose-valuative-jaffard, prose-GD, prose-linked, prose-UMt |  |
| 1006.4470v1 | definition-prose-1, case-1 |  |
| 1008.2055v4 | def-rth-root, def-prob-r, def-r-divisible, def-exponent, def-p-socle |  |
| 1011.4141v3 | def-formal-lc, def-coass |  |
| 0907.5545v1 | def-exponent-local-constancy, def-gamma-function, def-riesz-kernel, def-fundamental-solution, def-sobolev-space |  |
| 0810.2160v1 | def-prose-motive, def-prose-cofundamental |  |
| 1001.3646v1 | definition-pure-product |  |
| 0709.4546v2 | def-local-ub, def-weak-ub, def-2.3, def-2.5, def-2.6, example-2.7, example-2.8, proposition-2.9, def-2.17, def-oc1, def-oc2 | head-1 |
| 0908.3866v1 | definition-2, family-F1, family-F2, family-S1, family-S2, family-U |  |
| math/0301148v3 | prose-def-smooth-vector, prose-def-even-odd |  |
| 0807.1620v1 | definition-1 |  |
| 0809.1307v2 | definition-star-sft |  |
| 0904.2051v1 | def-uniform-recovery, def-row-support, def-spark |  |
| 1008.4946v4 | example-several, def-T-admissible, def-generating, def-scaling-entropy |  |
| 1009.2047v1 | prose-notation-PLP, prose-def-Lell |  |
| 1011.5443v2 | def-prose-regular-pair, def-prose-regular-triple, def-prose-regular-partition |  |
| 1010.3284v1 | def-prose-polyhedral-metric, def-prose-discrete-curvature, def-prose-inversive-distance-circle-packing, def-prose-natural-domain, def-prose-real-analytic-submanifold |  |
| 0812.1600v1 | def-prose-convergence, def-prose-granularity |  |
| 0810.5036v1 | prose-nielsen-transformation |  |
| math/0507030v2 | definition-sensitivity, definition-monotone, definition-layer, definition-minimal-one |  |
| 1008.4254v3 | def-p-angular, def-j-metric |  |
| math/0406514v2 | claim-4.35-1, proof-3971, remark-6.19a, def-abhyankar, def-evenly-spread, def-multiple-tvf, def-valuative-scheme, def-q-frobenius-scheme, def-size, def-properly, def-generically-smooth, def-rr-equivalent, def-weakly-cut-out, proof-9541, def-sigma-graded-ring, def-proj-sigma, def-exceptional-divisor-open, def-closed-blowing-up-ring, def-semi-valuative-algebra | head-12 |
| 1001.0174v3 | definition-initial-link, definition-framed-singular-link |  |
| 1003.5948v3 | def-cd, def-parallel-transport, def-laplacian, def-concave-family, def-gradient-curve, def-gradient-flow, def-hj-shift |  |
| 0803.0074v1 | def-prose-1, def-prose-2 |  |
| 1003.1817v1 | def-symmetric-space, def-fatou-norm, def-fully-symmetric, def-symmetric-sequence-space |  |
| 0903.0651v3 | def-bergman, def-toeplitz |  |
| 0902.4479v2 | def-alpha-amenable, def-reiter-condition, def-alpha-left-module, def-alpha-left-amenable, def-hypergroup-join, def-polynomial-hypergroup, example-I, example-II, example-III, example-IV, example-V, example-VI |  |
| 1003.2117v2 | def-DOR, def-ZR, def-ZR_S, def-OI, def-degree, def-OI_p, def-N, def-N_n, def-GCD, def-Bez, def-DCC, def-p-real-closure, def-p-real-closed-field, def-integer-part, def-ZS-construction |  |
| 0909.2893v4 | def-stress-matrix, def-gpr, def-k-chain, def-attach, def-hennenberg, def-replacement |  |
| 1011.4651v4 | def-tip-simplex, def-iterating |  |
| 1005.3739v1 | definition-polar-body, definition-hausdorff-distance |  |
| 0904.0817v7 | prose-hechler |  |
| 0902.2829v3 | def-residual-approximation, def-nc-stationary-qg, conclusion-1 | conclusion-1 |
| 1002.0879v1 | prose-derived-operation, prose-variety, prose-plain-operad |  |
| 1209.3562v1 | prose-link-model, prose-markov-equivalence, prose-braid-diagram-isotopy |  |
| 2011.12496v1 | def-pds, def-private-neighbor, def-solo-linked-pair, def-replacing, def-A-BC-D-pair, def-linked-D-pair |  |
| 1606.05058v2 | prose-copower, prose-power, prose-twisted-G-action, prose-twisted-G-functor |  |
| 2002.01498v2 | def-blowup, def-andrasfai, def-vega, def-maximal-tf |  |
| 1701.00517v1 | def-distance, def-convergent, def-complete, def-symmetric, def-N-distance, def-F-distance, def-s-distance, def-H-distance, def-C-distance, def-orbit, def-contractive, def-multiple-fixed-point, def-lambda-contraction, def-F-lambda-bounded |  |
| 2012.07638v1 | def-U, def-G, def-M-alpha, def-D-operator |  |
| 1709.01658v1 | def-curvature-spiral, def-moebius-isoparametric |  |
| 2012.11507v1 | def-matrix-measure, def-solution, def-fundamental-matrix, def-ues |  |
| 2011.07352v4 | prose-projdef, notation-intro, prose-redprod, prose-ctsredprod, prose-strinc, prose-precaliber, prose-orthogonal, prose-universal, prose-basis |  |
| 1507.03803v1 | definition-prose-1 |  |
| 1310.6698v1 | def-means |  |
| 2009.11127v9 | prose-def-1, prose-def-2, prose-def-3, prose-def-4, prose-def-5, prose-def-6, prose-def-7, prose-def-8 |  |
| 1704.04089v1 | def-prose-1, def-prose-2, def-prose-3, def-prose-4 |  |
| 1512.06981v1 | def-small, def-simple, def-cover, def-finite-length, def-semisimple, def-finite-category, def-rev, def-monoidal-subcategory, def-additive-monoidal, def-strict, def-right-dual, def-left-dual, def-drinfeld-center, def-morphism-module-functors, def-equivalent-module-categories, def-bimodule-category, def-center-bimodule, def-bicategory, def-crossed-module |  |
| 2012.06334v2 | prose-difference-nevanlinna-characteristic, prose-canonical-representation | acknowledgments-1 |
| 1308.2487v1 | def-black-box-over-G, axiom-BB4, def-morphism, def-structure-recovery, def-black-box-field, def-primitive-prime-divisor |  |
| 1304.4839v1 | definition-ncgraph, definition-ac-group |  |
| 2008.10035v3 | def-prose-vtd, def-prose-pvtn, def-prose-raag, def-prose-spherical, def-prose-link-star, def-prose-rinfty, def-prose-ia |  |
| 1204.5958v1 | prose-frame, prose-block-design, prose-admissible, prose-transversal-matroid, prose-spectral-expander-family, prose-spherical-t-design |  |
| 1303.4328v7 | proof-krs |  |
| 1904.08413v1 | def-identity-functor, def-underlying-map |  |
| 1704.08191v1 | prose-mecbf, prose-ext-beta-distribution |  |
| 1905.02785v1 |  | head-2, head-3, head-4, head-5 |
| 1612.08394v2 | defn-pseudo-orbit, proof-claim-5.1, defn-equicontinuous, defn-f-invariant, defn-borel-selection |  |
| 1301.0175v1 | def-prose-hypercomplex, def-prose-hkt, def-prose-slnh-manifold, def-prose-omega-lagrangian, def-prose-affine, def-prose-integer-monodromy, def-prose-quaternionic-double |  |
| 2011.05871v2 | def-schatten, def-tf-shift, def-gen-average-samples, def-operator-convolution, def-gen-samples |  |
| 1905.00573v1 | def-dual-filter, def-flc, def-convex-expansion |  |
| 1707.06795v1 | def-system-of-ideals, def-fd-n, def-weakly-laskerian, def-phi-weakly-cofinite |  |
| 2006.07610v2 | def-discrete, def-fourier-quasicrystal, def-sparse-fq, def-almost-periodic-function, def-almost-periodic-measure, def-almost-periodic-distribution |  |
| 1504.03271v1 | definition-prose-1, definition-prose-2 |  |
| 2011.06637v3 | definition-good-G-space, definition-sections, proof-A.2, proof-A.3 | say-1, say-2 |
| 1903.11969v1 |  | head-1, head-2 |
| 2011.14561v2 | def-bordered-toeplitz, def-szego-type, def-wh-factorization |  |
| 1904.09810v4 | definition-prose-1 |  |
| 1808.00180v1 | prose-killing-vector-field, prose-killing-potential, prose-ricci-soliton-generator, prose-gradient-ricci-soliton |  |
| 1907.01440v1 | def-prose-nconv, def-prose-isr, def-prose-genmin |  |
| 1209.5343v3 | prose-def-1, prose-def-2 |  |
| 1806.00752v4 | prose-def-prefoam, prose-def-rlinear, prose-def-geomcomplex, prose-def-orientedweb |  |
| 1509.00950v3 | def-p-curvature, def-coefficients, def-darboux-derivative |  |
| 1809.06512v1 | def-subordinate, def-dominant, def-best-subordinant |  |
| 2002.11125v2 | definition-prose-core-block, definition-prose-core-correlator |  |
| 1804.06366v3 | def-prose-1, def-prose-2 |  |
| 1603.00857v3 | prose-brownian-potential |  |
| 1701.00518v1 | def-distance, def-convergent-cauchy-complete, def-symmetric-quasimetric-metric, def-N-distance, def-F-distance, def-s-distance, def-H-distance, def-monotone-sequence, def-sequential-g-monotone, def-monotonically-complete, def-lambda-multiple-fixed-point |  |
| 1803.00317v3 |  | head-4 |
| 1406.2996v2 | def-msosm, def-domains, def-subordinate, def-covariance-functions, proof-1, proof-2, def-covariance-distribution, def-observable, def-deterministic |  |
| 1802.02910v3 | def-prose-position-presque-generale, def-prose-acylindrique, def-prose-espace-des-bulles, def-prose-picard-manin, def-prose-adherent, definition-wright-subsection, def-prose-wright-modifie, def-prose-classe-speciale, def-prose-distance-ensembles |  |
| 1912.02769v6 | prose-semicartesian, prose-kolmogorov-power, prose-finite-permutation |  |
| 1903.07030v1 | prose-def-1, prose-def-2, prose-def-3, prose-def-4, prose-def-5, prose-def-6, prose-def-7, prose-def-8, prose-def-9, prose-def-10 |  |
| 1607.01095v1 | def-hit-prose |  |
| 2005.03073v3 | def-prose-baas-sullivan, def-prose-well-adapted, def-prose-LG-cobordism, def-prose-torpedo |  |
| 1705.04310v2 | def-category, def-univalent, def-ess-surj |  |
| 2004.12552v2 | def-agw-pp, def-index, def-b-linear-translator |  |
| 1709.08958v1 | def-isoaxial, def-angle-spectrum, def-aut-axes, def-commensurator, def-thin-part, def-separated |  |
| 1406.6342v1 | proposition-decomp-phi, proposition-decomp-phitilde, definition-jacobi-form, definition-jk-residue | head-2 |
| 1408.1555v3 | prose-def-orbifold-chart, prose-def-diffeological-orbifold, prose-def-orbifold-form |  |
| 1912.13357v2 | definition-acute-angle-test |  |
| 2010.04617v1 | def-prose-vector-bundle, def-prose-ehresmann, def-prose-parallel-transport, def-prose-covariant-derivative, def-prose-holonomy, def-prose-restricted-holonomy |  |
| 1705.01594v1 | question-1 |  |
| 2004.02766v1 | def-subgaussian, def-relative-degree, def-vector-relative-degree, def-exp-min-phase, def-persistently-exciting |  |
| 1911.06467v3 | def-poking, def-farey-triplet, def-bridge-position |  |
| 2010.14428v1 | def-value-function-Q |  |
| 1107.2621v3 | def-stanley-depth |  |
| 1810.06028v3 | def-perfect-closure, def-depth, def-pure, def-F-pure |  |
| 2604.23212v1 | proof-3.3-i |  |
| 2306.00590v2 | prose-magnetic-dirac-operator, prose-volume-doubling |  |
| 2110.08714v3 | problem-geometric, problem-arithmetic | head-1, head-2 |
| 2512.21427v1 | def-index |  |
| 2504.09928v1 | def-B1 |  |
| 2606.00589v1 | definition-prose-1, definition-prose-2, definition-prose-3, definition-prose-4 |  |
| 2510.02019v1 | prose-jconv, prose-split, prose-nuclear, prose-ncsimplex |  |
| 2407.08004v1 | prose-def-degree |  |
| 2606.21391v1 | prose-extreme-set-face |  |
| 2212.11038v1 | prose-descended-system, prose-shifted-descended-system, prose-G-invariant-ideal, prose-embedded-system | head-1, head-2 |
| 2207.11097v1 | prose-context, prose-hypersequent, prose-derivable, prose-generated-semiconcept | head-1 |
| 2409.17318v1 | def-word, def-weak-partition, def-median-graph, def-cube-polynomial, def-lonely |  |
| 2108.10246v3 | prose-spherical |  |
| 2206.12966v1 | prose-positive, prose-accretive |  |
| 2609.36186v1 | def-prose-rooted-pair, def-prose-ball, def-prose-diameter, def-prose-layering-partition, def-prose-pendant-path, def-prose-separator, def-prose-tree-decomposition, def-prose-treewidth, def-prose-fat-minor, def-prose-asymptotic-minor-free, def-prose-graph-partition, def-prose-rooted-graph, def-prose-level, def-prose-rooted-cover, def-prose-core |  |
| 2103.11107v1 | definition-bg |  |
| 2209.00811v1 | prose-def-qcs, prose-def-dqcs |  |
| 2211.14214v5 | def-c5-flower, def-injective-colouring, def-saturated, def-squash-racket | head-18, head-20 |
| 2302.05529v1 | prose-simple, prose-qdim |  |
| 2607.27246v1 | def-2-domination, def-upper-median |  |
| 2202.13962v1 |  | head-1 |
| 2307.02473v1 | def-special-matching, def-el-labelling |  |
| 2305.10921v2 | prose-acs, prose-mock-injective, prose-proper-mock-injective |  |
| 2208.05276v1 | def-m-ideal |  |
| 2608.00864v1 | def-watson |  |
| 2607.01109v3 | def-prose-gammaS, def-prose-2packing, def-prose-kpacking-function | head-2 |
| 2101.04970v2 | prose-gurau-degree-closed, prose-boundary-graph, prose-H-epsilon |  |
| 2203.06854v1 | def-quasi-parabolic, def-parabolic-bundle, def-parabolic-degree, def-parabolic-stable, def-strongly-parabolic, def-log-connection, def-residue, def-parabolic-connection, def-stable-connection, def-irreducible, def-higgs, def-atiyah-sequence |  |
| 2111.08123v2 | def-shape-regularity |  |
| 2111.01197v1 | def-prose-caputo, def-prose-mittag-leffler, proof-7, def-prose-class-X |  |
| 2210.02997v2 |  | head-1 |
| 2102.10460v1 | def-prose-1, def-prose-2, def-prose-3 |  |
| 2511.05069v1 | def-hd-measure, def-self-similar, def-hyperbolic-periodic, def-types, def-conformal, def-kl, def-lex-dominated, def-super-dominated, def-zeta, def-holder-exponent, def-elementary-loop, def-xi |  |
| 2104.08176v1 | definition-prose-1 |  |
| 2207.07461v1 |  | head-1, head-2 |
| 2210.02261v2 | prose-finite-residual, prose-fitting, prose-s-free, prose-baer-radical, prose-s-group |  |
| 2108.05533v3 | definition-coreset |  |
| 2105.08875v1 | def-prose-1 |  |
| 2203.00606v1 | prose-mfrwt |  |
| 2601.15880v3 | definition-prose-1 | head-1, head-2 |
| 2410.01436v2 | def-conjugate, def-eps-subdifferential, def-inf-convolution, def-extension |  |
| 2610.07180v1 | definition-frohlich, algorithm-wada |  |
| 2202.03009v1 | prose-d-code, prose-additive-linear, prose-optimal-sym-alt, prose-optimal-hermitian, prose-hermitian-dual-basis |  |
| 2211.04758v2 | def-bijumbled, def-m-joined, def-k-fan |  |
| 2108.01302v1 | definition-p1, notation-integrals, definition-p2, definition-p3, definition-p4 |  |
| 2203.07710v1 | def-mahler-measure, def-pisot-salem, def-reciprocal |  |
| 2406.06548v2 | def-good-bad-gram, def-corrupt-gram |  |
| 2410.22607v2 | def-packing-design, def-packing-number, def-directed-packing-design, def-directed-packing-number, def-pd-lambda-v |  |
| 2506.09840v1 | prose-capillary-hypersurface, prose-capillary-convex-body, prose-capillary-radii, prose-capillary-entropy-point |  |
| 2304.07398v4 | prose-def-baez-crans, prose-def-2group-hom, example-2.9.1, example-2.14.1, example-4.2.2, example-coadjoint, prose-def-opposite-2alg, prose-def-module-2cat | head-1 |
| 2210.17066v1 | prose-def-isomorphism-manin |  |
| 2407.05730v2 | definition-multicolouring, definition-kneser |  |
| 2412.12141v1 | def-prose-cayley, def-prose-weyl-groupoid, def-prose-corners, def-prose-shuffles, def-prose-odd-reflection, def-prose-pseudo-corner, def-prose-half-baked, def-prose-affinization |  |
| 2212.02556v1 | def-hyperlog | head-1, head-2, head-5 |
| 2204.05019v1 | prose-hhhf, prose-character-herglotz |  |
| 2209.01576v2 | def-locally-compact, def-compact-operator, def-finite-rank, def-approximable, def-rosenthal, def-asplund-set, def-asplund-space, def-rnp, def-rn-operator |  |
| 2502.04323v2 | def-tessellation, def-mondrian-tessellation, def-urm-kernel, def-rotated-mondrian-tessellation |  |
| 2210.12291v2 | definition-rainbow, definition-rainbow-k-connected |  |
| 2104.04145v1 | def-gen-hyperharmonic, def-linear-euler-sums, def-quadratic-euler-sums |  |
| 2511.17751v1 | definition-f |  |
| 2501.18744v2 | def-partition, def-rq |  |
| 2110.11143v2 | claim-A |  |
| 2205.15365v1 | notation, def-upper-density, def-q-algebra, def-density, def-asymptotic-density, def-adf, def-ud-mod1, def-weak-adf, def-stat-indep, def-vector-adf, def-ud-in-M, def-regular, def-p-continuity, def-algebra-of-sets, def-weak-nu-df, def-nu-df, def-nu-indep, def-natural-measure, def-natural-metric, def-naturally-continuous, def-mean-value, def-dispersion, def-common-natural-metric, def-correlation, def-strong-positive |  |
| 2606.23841v1 | definition-p1 |  |
| 2104.12015v2 | def-projective-prime |  |
| 2208.14274v2 | definition-positive-charge |  |
| 2405.05684v1 |  | head-1, head-2, head-3, head-4 |
| 2512.22986v1 | def-dynamic-regret, def-smoothed-cvar, def-dynamic-regret-0 | head-2, head-4 |
| 2601.04559v2 | def-prose-nerve, def-prose-maximal-dowker, def-prose-induced-subgraph, def-prose-consistently-oriented, def-prose-contraction, def-prose-quotient-graph |  |
| 2111.14699v4 | def-prose-dirichlet, def-prose-nodal-set, def-prose-nodal-domains, def-prose-incompressible, def-prose-admissible |  |
| 2411.05198v1 | def-strongly-monotone, def-strongly-convex, def-dp, adj-x1-head-1 | head-1 |
| 2201.04174v2 | def-prose-lamella, def-prose-variation, def-prose-discrete-flow, def-prose-hausdorff | head-9 |
| 2110.11783v1 | prose-rank-k-cone, prose-monotone-flow |  |
| 2204.07961v1 | definition-prose-1 |  |
| 2601.10958v2 | definition-prose-cf, definition-prose-discord |  |
| 2608.23797v1 | prose-def-very-special, prose-def-S2-fibration |  |
| 2312.06581v2 | definition-1, definition-2 |  |
| 2512.24812v2 | prose-trajectory, prose-time-interval-existence, prose-b-to-b-mapping, prose-quasi-periodic, notation-123, prose-feasibility-inequalities, prose-lyapunov-exponent | head-2 |
| 2203.15223v1 | def-norm-euclidean, def-s-norm, def-s-norm-euclidean, def-fundamental-domain |  |
| 2202.10920v1 | def-bott-tower, problem-crp, def-height, def-realizable, def-q-trivial |  |
| 2207.05628v2 | def-prose-stft, def-prose-standard-symplectic-matrix, def-prose-lattice, def-prose-special-lattices, def-prose-fundamental-domain, def-prose-shift-invariant-space, def-prose-defining-sequence, def-prose-lambda-periodic |  |
| 2204.00813v1 | def-prose-1 |  |
| 2202.02831v3 | definition-anti-pgd, definition-widening-valley, observation-empirical |  |
| 2111.00496v4 | prose-def-mutual-info, prose-def-fredholm |  |
| 2204.04317v2 | prose-inf-hilbertian, prose-geodesic, prose-almost-continuous | head-1, head-2 |
| 2609.11301v1 | def-prose-holder, def-prose-assouad, def-prose-packing-measure, def-prose-profile-set, def-prose-fbm |  |
| 2410.06788v2 | def-riesz, def-truncation |  |
| 2609.03601v2 | prose-strong-beth-companion, prose-po-comm-monoid, prose-perfect-regular-ring |  |
| 2204.04820v2 | def-prose-realizable, def-prose-sphere-twist |  |
| 2605.10911v1 | def-modularity-score, def-sbm |  |
| 2109.00080v1 | def-slater-condition, def-immobile-indices, def-face, def-minimal-face, algorithm-waki-muramatsu, algorithm-reg-lcop, iteration-0, iteration-m |  |
| 2211.13105v1 | def-superposition |  |
| 2306.16411v2 | def-rwps, def-k-sieved-rwps, def-sieved-askey-wilson, def-sieved-averaging |  |
| 2109.06079v3 | def-generic, def-1-iterable, def-rank-into-rank, def-virtual-vopenka |  |
| 2109.08858v1 | definition-gqc, definition-coord |  |
| 2211.16099v1 | def-globular-set, def-precategory, def-prefunctor, def-polygraph, def-context, def-conduche, def-concrete-category, def-concrete-equivalence, def-category-of-elements, def-support, def-polyplex, def-plex, def-generic, def-equivalence, def-decalage | head-1 |
| 2110.12380v1 | prose-def-graded, prose-def-fourier, prose-def-sobolev |  |
| 2103.12669v2 | prose-rank-canonical-divisor, prose-singular-locus, claim-3.9a, prose-semistable-reduction |  |
| 2210.11778v1 | def-prose-adjacent, def-prose-dpr, def-prose-stdpr, def-prose-bandwidth | head-1, head-2 |
| 2404.00077v2 | definition-1 |  |
| 2210.04075v1 | def-weight, def-quasi-additive, def-generalized-function, def-generalized-quasi-additive, def-weakly-amenable, def-strict-topology, def-vanish-infinity, def-IN-group |  |
| 2104.00162v5 | prose-essentially-propositional, prose-localic, prose-place |  |
| 2101.07846v1 | prose-quadrature-rule |  |
| 2208.07490v2 | def-moebius-deformable, def-flat, def-splitting-tensor, def-elliptic |  |
| 2505.10801v1 | prose-def-1, prose-def-2, prose-def-3, prose-def-4, prose-def-5, prose-def-6, prose-def-7, prose-def-8 |  |
| 2203.16333v1 | example-1.2, examples-3.0.1 |  |
| 2210.06318v1 | def-obstacle |  |
| 2401.02768v1 | definition-gcf, definition-holder |  |
| 2509.10268v2 | definition-monotone |  |
| 2301.04933v2 | def-prose-rfold, def-prose-ratparam, def-prose-proper, def-prose-paramfield, def-prose-degenerates |  |
| 2305.18021v1 | def-prose-smooth-rds |  |
| 2610.20178v1 | def-boolean-independence, def-boolean-convolution, def-boolean-entropy, def-boolean-fisher, def-relative-entropy-fisher, def-fractional-partition |  |
| 2403.08723v1 | def-majorant, def-weakKO, def-removable, def-wentropy, def-wsparse, def-holbanach |  |
| 2208.04502v2 | def-prose-weighted-delaunay, def-prose-regular |  |
| 2510.07095v1 | prose-strong-rost-nilpotence, prose-artin-tate |  |
| 2111.00832v3 | def-identifiable, def-induces-monotonicity, def-rooted-ordered-tree, def-supercritical-malthusian |  |
| 2304.02722v2 | prose-def-irreducible, prose-def-pointwise-lip, prose-def-minimizing-sequence, prose-def-min-max-sequence, prose-def-almost-minimizing, adj-x1-head-10 | head-10 |
| 2602.15812v2 | def-sigma-complete, def-sufficiently-many-states, def-joint-spectrum, exercise-5.3.3, def-sigma1n-formulas, convention-5.5.4, proof-17 | proofof-1 |
| 2409.00806v3 | def-prose-fvdc, def-prose-folner, def-prose-amenable, def-prose-posdef, def-prose-cyclic, def-prose-gnstriple, def-prose-wap, def-prose-vdc-rodriguez |  |
| 2410.22045v1 | def-inner-product |  |
| 2106.06387v3 | remark-4.5 | pkt-40 |
| 2104.05191v2 | def-ricci-flow, def-super-ricci-flow, def-ancient, def-admissible, def-muller-trace-harnack, def-L-length, def-L-distance-reduced-distance, def-minimal-L-geodesic, def-K-super-ricci-flow |  |
| 2108.06308v2 | def-prose-continuum, def-prose-cwexpansive, def-prose-topdim, def-prose-widim, def-prose-mdim, def-prose-dirmdim |  |
| 2404.05451v2 | def-besov-classes, def-Bq1-norm, def-step-hyperbolic-cross, def-step-hyperbolic-fourier-sum, def-best-approximation, def-kolmogorov-width, def-linear-width, def-epsilon-entropy, def-entropy-numbers |  |
| 2208.13855v4 | prose-k2r-configuration, prose-k2r-closure, prose-closure-sequence, prose-pd-distance, prose-g-compatible, prose-tau-spanning, prose-monotone-path |  |
| 2205.15106v2 | definition-cuntz-subequivalence, definition-purely-positive |  |
| 2601.01076v1 | definition-RSOA, definition-TKFL, definition-KRS |  |
| 2408.03317v2 | def-nest, def-nest-algebra, def-atom, def-order-isomorphism, def-preserves-dimension, def-nest-distance, def-algebra-distance |  |
| 2311.01874v3 | def-projectivization, def-C-good-interval, def-cohomologically-tame, def-newton-polyhedron |  |
| 2209.07892v3 | def-prose-1, def-prose-2, def-prose-3, def-prose-4, def-prose-5 |  |
| 2108.00412v2 | prose-diffeological-group, prose-right-kan-extension, prose-indexed-limit |  |
| 2601.15403v2 | prose-bei, prose-graph-constructions, prose-comparability, notation-6.1, prose-unmixed |  |
| 2103.02468v3 | definition-canonical-purification |  |
| 2409.03461v1 | definition-accessible |  |
| 2204.01073v1 | definition-rel-hyp-bundle |  |
| 2604.07243v3 | prose-locally-inner, prose-sha-rigid, remark-earlier-work |  |
| 2211.10178v1 | def-chern-class-map, def-roots |  |
| 2105.03252v3 | def-initial-algebra, def-plump |  |
| 2209.08186v2 | def-solid-harmonic, def-jacobi-cone, def-admissible-cutoff |  |
| 2405.14678v2 | prose-def-1, prose-def-2, prose-def-3 |  |
| 2109.09268v2 | def-prose-induced-subgraph, def-prose-induced-matching, def-prose-edge-ideal, def-prose-cone, def-prose-link, def-prose-regularity, def-prose-restriction, def-prose-degree-in-ideal, def-prose-symbolic-power, def-prose-radical-power, def-prose-order |  |
| 2206.14762v2 | def-liouville, def-modular-state, def-operator-system, def-nc-torus, def-growth-sequence |  |
| 2212.06621v2 | def-inc-invariant-chain, def-stability-index, def-saturated-chain, def-regularity, def-edge-ideal, def-anticycle, def-chordal-cochordal, def-induced-matching-number, def-weakly-chordal |  |
| 2112.10058v1 | definition-prose-schwartz, definition-prose-fourier |  |
| 2108.09796v1 | definition-prose-1, definition-prose-2, definition-prose-3, definition-prose-4, definition-prose-5, claim-2 |  |
| 2411.16022v1 | definition-pochhammer |  |
| 1803.10042v2 | def-hidden-choice, def-visible-choice, def-leakage-game |  |
| 0804.2115v2 | def-prose-monomial-order, def-prose-compositions-free, def-prose-trivial-free, def-prose-gsb-free, def-prose-compositions-tensor, def-prose-trivial-tensor, def-prose-gsb-tensor, def-prose-lex-splitting, def-prose-compositions-comm, def-prose-gsb-comm |  |
| 1204.1664v3 | def-mmd, def-submodular, def-approx-submodular |  |
| 2504.14383v2 | prose-def-1, prose-def-2 |  |
| 1909.03896v2 | claim-invariant-I |  |
| 2206.11809v1 | def-isotropic, def-datum, def-extremizable, def-independent-subspace, def-dependent-subspace, def-critical-decomposition, case-necessity-i, case-necessity-ii, def-drift, def-standard-bm |  |
| 2601.18223v1 | def-quasi-adjacent-graph, def-edge-distance, def-edge-set-distance, def-quasi-pendant, def-clique-block |  |
| 2507.13548v1 | def-primitive-root, def-cyclic-code, def-reed-muller, def-punctured-rm, def-circulant-matrix, def-t-circulant, def-weldon-wozencraft |  |
| 2401.11433v1 | def-standard-type, def-F-conjugate |  |
| 2312.14319v2 | def-adjointable, def-frame-operators |  |
| 2609.27495v2 | def-degree-stationary, def-certificate, def-exact-certificate |  |
| 2503.22636v2 | def-rational-fan, def-star-fan, def-polytope-algebra, def-ehrhart-function, def-K-ring, def-holomorphic-euler, def-balanced, def-bergman-fan |  |
| 2506.21337v2 | def-cartesian-product, def-prime-graph, def-relatively-prime, def-hamilton-compression, def-edge-orbit, def-truncation |  |
| 2304.08231v2 | def-convexity-range, def-standard-level, def-ap-range | head-1, head-2 |
| 2211.14629v1 | def-finite-survival, def-ultimate-survival, def-net-profit, def-displaced-poisson |  |
| 2608.17785v1 | def-prose-intersecting, def-prose-nonvanishing, def-prose-zero-detecting, def-prose-star-in-C |  |
| 2412.20238v1 | def-carnot-group |  |
| 2508.19709v1 | def-eventually-constant, def-evaluations, def-additive, def-1-concave |  |
| 2609.33953v1 | def-partition, def-young-tableau, def-conjugate-frobenius, def-hook, def-specialisation, def-convex-polytope |  |
| 2306.12846v2 | definition-associated-graph, definition-associated-character |  |
| 2606.02312v1 | def-lipschitz, def-trig-poly, def-rational |  |
| 2604.02249v2 | definition-prose-1 |  |
| 2504.19468v1 | prose-pjs, prose-signature |  |
| 2206.05392v3 | def-rooted-chromatic |  |
| 2211.01586v2 | definition-prose-1, definition-prose-2 |  |
| 2501.17276v3 | definition-prose-1 |  |
| 2412.14956v3 | prose-special-bernstein, prose-potential-measure, prose-C0-Csol |  |
| 2206.02330v3 | prose-sum-rank-weight, prose-msrd |  |
| 2310.17520v2 | def-normalized-adjacency, def-edge-expansion |  |
| 2105.03715v6 | def-prose-1, def-prose-2, def-prose-3, def-prose-4 |  |
| 1508.01731v1 | prose-rwa |  |
| 2502.09121v1 | definition-carleson, definition-trapezoid |  |
| 2407.07642v1 | prose-gauge-equivalent, prose-alternative-lagrangian, prose-gauge-equivalent-cont, prose-alternative-lagrangian-cont |  |
| 1806.05002v2 | rado-criterion, definition-rado-number, bergelson-leibman | rado-1, bl-1 |
| 2603.23072v1 | definition-rademacher |  |
| 2410.10337v4 | prose-nb-irreducible, prose-universal-cover, prose-suspended-path, prose-nb-cycle |  |
| 2111.14143v1 | def-prose-order |  |
| 2302.06189v1 | def-category |  |
| 2512.11346v1 | definition-1, definition-2 |  |
| 2212.00617v1 | definition-weight-module |  |
| 2411.01837v1 | def-bohr-radius-class, def-kqc, def-class-F |  |
| 2506.08233v1 |  | head-1 |
| 2310.19073v1 | def-prose-eps-flat |  |
| 2409.01237v1 | def-br-number, def-milnor-omega, def-relative-br-intro, def-relative-br, def-milnor-foliation, def-invariant-separatrix, def-tangency-order, def-dicritical-blowup, def-reduced-singularity, def-generalized-curve |  |
| 2602.19452v1 | notation-unit-roundoff |  |
| 2404.06445v3 | def-halin-tree, def-isojoin, def-bicontraction, def-partial-retract, def-2cut-decomposition, def-2edge-splicing, def-bisplitting, def-restricted-bisplitting, def-k-extendable |  |
| 2308.07021v2 | def-szego, def-garabedian, def-Q, def-weighted-bergman, def-reduced-bergman, def-classes-AB |  |
| 2602.14912v1 | def-nonsingular |  |
| 2401.00191v1 | prose-svtcp, prose-merit-function |  |
| 2405.09294v1 | def-prelim-1, def-prelim-2, def-prelim-3, def-prelim-4 |  |
| 2505.04063v1 | definition-skinny-tsvd |  |
| 2201.12479v2 | def-weak-pinning, def-weak-basis, def-oscillatory, def-standard-element |  |
| 2508.02432v1 | def-signed, def-canonical, def-cyclic, def-descent |  |
| 2609.35632v1 | def-cc, def-nondegenerate, def-selfstress, def-dziobekfn |  |
| 2602.07485v1 | prose-besov, prose-mazya, prose-dtn |  |
| 2610.00291v1 | def-symmetric-experiment |  |
| 2208.06310v1 | def-nondegenerate, def-essential |  |
| 2403.04887v1 | def-rli, def-caputo, def-mittag-leffler |  |
| 2610.03559v1 | def-zero-inventory, def-regeneration-interval, def-partially-utilized, def-boundary-sum-set, def-positive-grid, def-negative-grid, def-period-grid, def-global-grid, def-boundary-resource-profile |  |
| 2406.19866v3 | prose-ziegler-restriction, prose-locally-free-along, prose-generic, prose-totally-non-free, prose-local-property |  |
| 2006.12475v4 | def-coherence-rank |  |
| 2407.06927v2 | def-symmetry, def-hills-region, def-contact-type | head-1 |
| 2112.05010v4 |  | head-1, head-4, head-5, head-6, head-7, head-10, head-11, head-12 |
| 2508.01642v1 | def-prose-1, def-prose-2 |  |
| 2609.36090v1 |  | head-1, head-2 |
| 2402.08625v1 | def-pairing-matrix, def-mealy-automaton, def-invertible-bireversible, def-helix-graph |  |
| 2509.21444v7 | def-trivial-algebra, def-hopf-module |  |
| 2510.12502v2 | prose-def-1 |  |
