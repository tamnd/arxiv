---
paper: "2312.00752"
version: v2
title: 'Mamba: Linear-Time Sequence Modeling with Selective State Spaces'
authors:
  - Albert Gu
  - Tri Dao
submitted: "2024-05-31"
announced: 2023-12
primary_category: cs.LG
categories:
  - cs.LG
msc_class: ""
acm_class: ""
doi: ""
journal_ref: ""
access: open
licence: CC-BY-4.0
licence_of_source: cc-by
licence_from: abs
section: 8
section_title: Related Work
kind: appendix
lang: en
tag: XVSH
local_id: sb
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 6
equations: 0
figures: []
tables: []
statements: []
code_blocks: 0
content_sha256: 3243b8043e838e7748895ccfc6e59c12ad8b81f3d048ffe53230bfd19e32cc96
edited: false
---

We overview several prior works related to our methods. We mention that some of the most closely related models include recurrent layers such as S4, S5, and quasi-RNNs; as well as end-to-end architectures such as H3, RetNet, and RWKV.

## B.1 S4 Variants and Derivatives {#sb-1 .section tag=D7C6}

We describe a brief overview of some structured SSMs from past work, particularly those that have a relation to our method.

- S4 ([Gu et al., 2021](#bib.bibx40); [Gu et al., 2022](#bib.bibx37)) introduced the first structured SSM, describing diagonal structure and diagonal plus low-rank (DPLR). It focused on efficient convolutional algorithms for DPLR SSMs due to a connection to continuous-time online memorization (HIPPO) ([Gu et al., 2020](#bib.bibx36)).
- DSS ([Gupta et al., 2022](#bib.bibx42)) first discovered the empirical effectiveness of diagonal structured SSMs by approximating the HIPPO initialization. This was expanded on theoretically in S4D ([Gu et al., 2022a](#bib.bibx39)).
- S5 ([Smith et al., 2023](#bib.bibx98)) independently discovered the diagonal SSM approximation, and is the first S4 model to be computed recurrently with the parallel scan. However, this required lowering the effective state dimension, which they accomplished by switching the SSM dimensions from a SISO (single-input single-output) to MIMO (multi-input multi-output) formulation. Our proposed S6 shares the scan, but differs by (i) keeping the SISO dimensions, which provides a larger effective recurrent state, (ii) using a hardware-aware algorithm to overcome the computation issue, (iii) adding the selection mechanism. [Lu et al. (2023)](#bib.bibx68) applied S5 to meta-RL in order to handle resetting the SSM state between episode trajectories. Their mechanism can be viewed as a particular hard-coded instance of a selection mechanism, where $\overline{\bm{A}}$ is manually set to $0$, instead of our learnable mechanism that depends on the input. It would be interesting to apply selective SSMs generically to this setting and probe if the model has learned to automatically reset its state on episode boundaries.
- Mega ([Ma et al., 2023](#bib.bibx70)) introduced a simplification of S4 to be real- instead of complex- valued, giving it an interpretation of being an exponential moving average (EMA). They additionally make an interesting connection of the discretization step of SSMs to an EMA *damping* term. Contrary to findings in the original S4 papers, this was the first model to show that real-valued SSMs are empirically effective in certain settings or when combined with different architectural components.
- Liquid S4 ([Hasani et al., 2023](#bib.bibx46)) is also motivated by augmenting S4 with an input-dependent state transition. From this perspective it shares similarity to selection mechanisms, although in a limited form which is still computed convolutionally and close to LTI.
- SGConv ([Li et al., 2023](#bib.bibx66)), Hyena ([Poli et al., 2023](#bib.bibx84)), LongConv ([Fu et al., 2023](#bib.bibx31)), MultiresConv ([Shi et al., 2023a](#bib.bibx97)), and Toeplitz Neural Network ([Qin et al., 2023](#bib.bibx85)) all focus on the convolutional representation of S4 and create global or long convolution kernels with different parameterizations. However, these methods cannot do fast autoregressive inference directly.

Notably, all of these methods, and all other structured SSMs that we are aware of, have been non-selective and usually strictly LTI (linear time invariant).

## B.2 SSM Architectures {#sb-2 .section tag=UKGH}

We use SSM architectures or state space neural networks (SSNN) to refer to deep neural network architectures incorporating one of the previous SSMs as a black box layer.

- GSS ([Mehta et al., 2023](#bib.bibx73)) was the first gated neural network architecture incorporating SSMs. It is motivated by the gated attention unit (GAU) of [Hua et al. (2022)](#bib.bibx53) and looks quite similar to our block, except with additional projections. Most importantly, its projection *contracts* the model dimension to reduce the state size of the SSM, while ours *expands* the model dimension in order to increase the state size, based on the motivation in [Section 3.1](#s3-1).
- Mega ([Ma et al., 2023](#bib.bibx70)) combined the EMA simplification of S4 described above into a hybrid architecture using an efficient attention approximation.
- H3 ([Dao et al., 2023](#bib.bibx21)) is motivated by combining S4 with linear attention ([Katharopoulos et al., 2020](#bib.bibx58)). It is the first to generalize this formulation of linear attention to more general recurrences, which is also the basis of later architectures.
- Selective S4 ([Wang et al., 2023](#bib.bibx108)) incorporates S4 as a black box to generate a binary mask which is multiplied on the input. While sharing the “selection” name, we consider this an architectural modification that is closer to architectural gating than a selection mechanism ([Appendix A](#sa)). For example, we hypothesize that it would not solve the Selective Copying task because simply masking out the irrelevant inputs does not affect the spacing between the relevant ones (indeed, the Selective Copying task can even be viewed as coming pre-masked if the noise tokens are embedded to 0).
- RetNet ([Sun et al., 2023](#bib.bibx100)) is also based on Linear Attention and very similar to H3, but reduces the inner S4 layer to a special case where the state dimension is $N=1$. Although not framed as such, its recurrence can be viewed as a special case of a linear SSM. Its primary source of improvement is using a linear attention with large *head dimension*, which can be viewed as another method to perform input-dependent state expansion. Using a larger head dimension in the context of linear attention variants was first done by H3, but not extensively used since this requires a proportional amount of extra computation. RetNet avoids this with an alternate way to parallelize the computation with a variant of standard multi-head attention instead of convolutions, made feasible by their particular special case of SSMs which acts as a simple EMA.
- RWKV ([Peng et al., 2023](#bib.bibx82)) is another recent RNN designed for language modeling. It is based on AFT (attention-free Transformer ([Zhai et al., 2021](#bib.bibx113))), another variant of linear attention. Its main “WKV” mechanism involves LTI recurrences and can be seen as the ratio of two SSMs.

We also highlight the gated attention unit (GAU) from [Hua et al. (2022)](#bib.bibx53), which was motivated by combining the Transformer’s MHA and MLP blocks together and was an inspiration for our architecture ([Section 3.4](#s3-4)) combining the H3 and MLP blocks.

## B.3 Relationship to RNNs {#sb-3 .section tag=KLYG}

RNNs and SSMs are broadly related, as they both involve the concepts of *recurrence* on a latent *state*.

Several older RNNs such as the strongly typed RNN ([Balduzzi & Ghifary, 2016](#bib.bibx6)), quasi-RNN (QRNN) ([Bradbury et al., 2016](#bib.bibx11)), and simple recurrent unit (SRU) ([Lei et al., 2017](#bib.bibx64); [Lei, 2021](#bib.bibx63)) involve forms of gated RNNs without time-wise nonlinearities. Because of the connections of gating mechanisms and selection mechanisms, these can be viewed as cases of selective SSMs, and are thus more powerful in a sense than the family of LTI structured SSMs above. The main differences are:

- They do not use state expansion ($N=1$) or selective $\bm{B},\bm{C}$ parameters, both of which are important for performance ([Section 4.6](#s4-6)).
- They use a heuristic gating mechanism, which we generalize as a consequence of the selection mechanism + discretization ([Theorem 1](#thm-1)). The connections to principled SSM theory provides better parameterizations and initializations ([Section 3.6](#s3-6)).

Additionally, older RNNs famously suffered from efficiency issues and the vanishing gradients problem ([Hochreiter, 1991](#bib.bibx49); [Hochreiter et al., 2001](#bib.bibx50); [Pascanu et al., 2013](#bib.bibx81)), both caused by their sequential nature. The former could be solved for some of the above RNNs by leveraging the parallel scan ([Martin & Cundy, 2018](#bib.bibx71)), but the latter was difficult without theory later developed for SSMs. For example, modern structured SSMs differ in more careful parameterization of the recurrent dynamics inspired by classical SSM theory (e.g. through discretization ([Gu et al., 2021](#bib.bibx40); [Gu et al., 2023](#bib.bibx41))), or direct analysis ([Orvieto et al., 2023](#bib.bibx79); [Kaul, 2020](#bib.bibx59); [Gupta et al., 2022a](#bib.bibx43))).

We also note that there is a long line of work on orthogonal RNNs ([Arjovsky et al., 2016](#bib.bibx1); [Henaff et al., 2016](#bib.bibx47); [Mhammedi et al., 2017](#bib.bibx74); [Vorontsov et al., 2017](#bib.bibx107); [Lezcano-Casado & Martínez-Rubio, 2019](#bib.bibx65)) which are motivated by constraining the $\overline{\bm{A}}$ transition matrix to be orthogonal or unitary, in order to control its eigenvalues and prevent the vanishing gradient problem. However, these had other limitations; we believe that these stem from the fact that orthogonal/unitary RNNs are also LTI. For example, they are almost always evaluated on the Copying task which they can solve perfectly, but observed to struggle on the Selective Copying task ([Jing et al., 2019](#bib.bibx56)).

## B.4 Linear Attention {#sb-4 .section tag=NPEM}

The Linear Attention (LA) ([Katharopoulos et al., 2020](#bib.bibx58)) framework is an important result popularizing kernel attention and showing how it relates to recurrent autoregressive models. Many variants have proposed alternative kernels and other modifications. Random Feature Attention (RFA) ([Peng et al., 2021](#bib.bibx83)) chooses the kernel feature map to approximate softmax attention (i.e. the $\exp$ feature map) using the random Fourier feature approximation of Gaussian kernels ([Rahimi & Recht, 2007](#bib.bibx88)). Performer ([Choromanski et al., 2021](#bib.bibx15)) finds an approximation to the exponential kernel involving only positive features, which also allows the softmax normalization term. TransNormer ([Qin et al., 2022](#bib.bibx86)) showed that the LA denominator term can be unstable and proposed replacing it with a LayerNorm. cosFormer ([Qin et al., 2022a](#bib.bibx87)) augments RFA with a cosine reweighting mechanism that incorporates positional information to emphasize locality. Linear Randomized Attention ([Zheng et al., 2022](#bib.bibx115)) generalize RFA from the perspective of importance sampling, and generalize it to provide better estimates of the full softmax kernel (rather than just the $\exp$-transformed numerator).

Aside from kernel attention, many other variants of efficient attention exist; the survey [Tay et al. (2022)](#bib.bibx104) offers an extensive categorization of many of these.

## B.5 Long Context Models {#sb-5 .section tag=VPUL}

Long context has become a popular subject, and several recent models have claimed to scale to longer and longer sequences. However, these are often from a computational standpoint and have not been extensively validated. These include:

- Recurrent Memory Transformer ([Bulatov et al., 2023](#bib.bibx13)), a lightweight wrapper around a Transformer backbone. It showed ability to generalize up to 1M sequences but only on synthetic memorization tasks; their main result is similar to our Induction Heads extrapolation experiment ([Figure 5](#fig-4)).
- LongNet ([Ding et al., 2023](#bib.bibx24)), which claimed to scale to 1B length but only evaluated on length $<100K$ for actual tasks.
- Hyena and HyenaDNA ([Poli et al., 2023](#bib.bibx84); [Nguyen et al., 2023](#bib.bibx76)), which claimed to leverage up to 1M context. However, their experiments trained on proportionally more data at longer contexts, making it hard to conclude if quality improvements at 1M context are due to context length or due to more data and computation.
- Sparse Transformer ([Child et al., 2019](#bib.bibx14)) showed a proof-of-concept of using a strided sparse attention Transformer to model audio waveforms of length $2^{20}=1048576$, although did not discuss performance tradeoffs when controlling for computation and model size.

In contrast, we believe this work presents one of the first approaches to meaningfully demonstrate increasing performance with longer context.
