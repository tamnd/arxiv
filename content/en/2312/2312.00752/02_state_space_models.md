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
section: 2
section_title: State Space Models
kind: section
lang: en
tag: TRGM
local_id: s2
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 14
equations: 7
figures: []
tables: []
statements: []
code_blocks: 0
content_sha256: dd26bccb63416e638d6860e21a01335efe2b75f9477ec1cb95f9eedd34ba51cc
edited: false
---

Structured state space sequence models (S4) are a recent class of sequence models for deep learning that are broadly related to RNNs, and CNNs, and classical state space models. They are inspired by a particular continuous system ([1](#eq-1a)) that maps a 1-dimensional function or sequence $x(t)\in\mathbb{R}\mapsto y(t)\in\mathbb{R}$ through an implicit latent state $h(t)\in\mathbb{R}^{N}$.

Concretely, S4 models are defined with four parameters $(\Delta,\bm{A},\bm{B},\bm{C})$, which define a sequence-to-sequence transformation in two stages.

$$
h^{\prime}(t) =\bm{A}h(t)+\bm{B}x(t)
$$
{#eq-1a .equation tag=24EY}

$$
y(t) =\bm{C}h(t)
$$
{#eq-1b .equation tag=28YY}

$$
h_{t} =\overline{\bm{A}}h_{t-1}+\overline{\bm{B}}x_{t}
$$
{#eq-2a .equation tag=9G2R}

$$
y_{t} =\bm{C}h_{t}
$$
{#eq-2b .equation tag=1FXP}

$$
\bm{\overline{K}} =(\bm{C}\bm{\overline{B}},\bm{C}\bm{\overline{A}}\bm{\overline{B}},\dots,\bm{C}\bm{\overline{A}}^{k}\bm{\overline{B}},\dots)
$$
{#eq-3a .equation tag=3DOW}

$$
y =x\ast\bm{\overline{K}}
$$
{#eq-3b .equation tag=46GZ}

## Discretization. {#su2-1 .section tag=DILO}

The first stage transforms the “continuous parameters” $(\Delta,\bm{A},\bm{B})$ to “discrete parameters” $(\overline{\bm{A}},\overline{\bm{B}})$ through fixed formulas $\overline{\bm{A}}=f_{A}(\Delta,\bm{A})$ and $\overline{\bm{B}}=f_{B}(\Delta,\bm{A},\bm{B})$, where the pair $(f_{A},f_{B})$ is called a *discretization rule*. Various rules can be used such as the zero-order hold (ZOH) defined in equation ([4](#eq-4)).

$$
\overline{\bm{A}}=\exp(\Delta\bm{A})\qquad\overline{\bm{B}}=(\Delta\bm{A})^{-1}(\exp(\Delta\bm{A})-\bm{I})\cdot\Delta\bm{B}
$$
{#eq-4 .equation tag=51FQ}

Discretization has deep connections to continuous-time systems which can endow them with additional properties such as resolution invariance ([Nguyen et al., 2022](#bib.bibx75)) and automatically ensuring that the model is properly normalized ([Gu et al., 2023](#bib.bibx41); [Orvieto et al., 2023](#bib.bibx79)). It also has connections to gating mechanisms of RNNs ([Tallec & Ollivier, 2018](#bib.bibx102); [Gu et al., 2020a](#bib.bibx38)) which we will revisit in [Section 3.5](#s3-5). However, from a mechanical point of view discretization can simply be viewed as the first step of the computation graph in the forward pass of an SSM. Alternate flavors of SSMs can bypass the discretization step and parameterize $(\overline{\bm{A}},\overline{\bm{B}})$ directly instead ([Zhang et al., 2023](#bib.bibx114)), which may be easier to reason about.

## Computation. {#su2-2 .section tag=NCDQ}

After the parameters have been transformed from $(\Delta,\bm{A},\bm{B},\bm{C})\mapsto(\overline{\bm{A}},\overline{\bm{B}},\bm{C})$, the model can be computed in two ways, either as a **linear recurrence** ([2](#eq-2a)) or a **global convolution** ([3](#eq-3a)).

Commonly, the model uses the convolutional mode ([3](#eq-3a)) for efficient parallelizable training (where the whole input sequence is seen ahead of time), and switched into recurrent mode ([2](#eq-2a)) for efficient autoregressive inference (where the inputs are seen one timestep at a time).

## Linear Time Invariance (LTI). {#su2-3 .section tag=4O7M}

An important property of equations ([1](#eq-1a)) to ([3](#eq-3a)) is that the model’s dynamics are constant through time. In other words $(\Delta,\bm{A},\bm{B},\bm{C})$, and consequently $(\overline{\bm{A}},\overline{\bm{B}})$ as well, are fixed for all time-steps. This property is called *linear time invariance (LTI)*, which is deeply connected to recurrence and convolutions. Informally, we think of LTI SSMs as being equivalent to any linear recurrence ([2a](#eq-2a)) or convolution ([3b](#eq-3b)), and use LTI as an umbrella term for these classes of models.

Thus far, all structured SSMs have been LTI (e.g. computed as convolutions) because of fundamental efficiency constraints, discussed in [Section 3.3](#s3-3). However, a core insight of this work is that LTI models have fundamental limitations in modeling certain types of data, and our technical contributions involve removing the LTI constraint while overcoming the efficiency bottlenecks.

## Structure and Dimensions. {#su2-4 .section tag=3LCM}

Finally, we note that structured SSMs are so named because computing them efficiently also requires imposing structure on the $\bm{A}$ matrix. The most popular form of structure is diagonal ([Gupta et al., 2022](#bib.bibx42); [Gu et al., 2022a](#bib.bibx39); [Smith et al., 2023](#bib.bibx98)), which we also use.

In this case, the $\bm{A}\in\mathbb{R}^{N\times N},\bm{B}\in\mathbb{R}^{N\times 1},\bm{C}\in\mathbb{R}^{1\times N}$ matrices can all be represented by $N$ numbers. To operate over an input sequence $x$ of batch size $B$ and length $L$ with $D$ channels, the SSM is applied independently to each channel. Note that in this case, the total hidden state has dimension $DN$ per input, and computing it over the sequence length requires $O(BLDN)$ time and memory; this is the root of the fundamental efficiency bottleneck addressed in [Section 3.3](#s3-3).

## General State Space Models. {#su2-5 .section tag=KQMT}

We note that the term *state space model* has a very broad meaning which simply represents the notion of any recurrent process with a latent state. It has been used to refer to many disparate concepts in different disciplines, including Markov decision processes (MDP) (reinforcement learning ([Hafner et al., 2020](#bib.bibx45))), dynamic causal modeling (DCM) (computational neuroscience ([Friston et al., 2003](#bib.bibx30))), Kalman filters (controls ([Kalman, 1960](#bib.bibx57))), hidden Markov models (HMM) and linear dynamical systems (LDS) (machine learning), and recurrent (and sometimes convolutional) models at large (deep learning).

Throughout this entire paper we use the term “SSM” to refer exclusively to the class of structured SSMs or S4 models ([Gu et al., 2022](#bib.bibx37); [Gupta et al., 2022](#bib.bibx42); [Gu et al., 2022a](#bib.bibx39); [Ma et al., 2023](#bib.bibx70); [Smith et al., 2023](#bib.bibx98); [Hasani et al., 2023](#bib.bibx46)) and use these terms interchangeably. For convenience we may also include derivatives of such models, such as those focusing on either the linear-recurrence or global-convolution viewpoints ([Orvieto et al., 2023](#bib.bibx79); [Li et al., 2023](#bib.bibx66); [Poli et al., 2023](#bib.bibx84)), and clarify nuances when necessary.

## SSM Architectures. {#su2-6 .section tag=OZ9R}

SSMs are standalone sequence transformations that can be incorporated into end-to-end neural network architectures. (We also sometimes call SSM architectures SSNNs, which are to SSM layers as CNNs are to linear convolution layers.) We discuss some of the most well-known SSM architectures, many of which will also serve as our primary baselines.

- Linear attention ([Katharopoulos et al., 2020](#bib.bibx58)) is an approximation of self-attention involving a recurrence which can be viewed as a degenerate linear SSM.
- H3 ([Dao et al., 2023](#bib.bibx21)) generalized this recurrence to use S4; it can be viewed as an architecture with an SSM sandwiched by two gated connections ([Figure 3](#fig-3)). H3 also inserts a standard local convolution, which they frame as a shift-SSM, before the main SSM layer.
- Hyena ([Poli et al., 2023](#bib.bibx84)) uses the same architecture as H3 but replaces the S4 layer with an MLP-parameterized global convolution ([Romero et al., 2021](#bib.bibx90)).
- RetNet ([Sun et al., 2023](#bib.bibx100)) adds an additional gate to the architecture and uses a simpler SSM, allowing an alternative parallelizable computation path, using a variant of multi-head attention (MHA) instead of convolutions.
- RWKV ([Peng et al., 2023](#bib.bibx82)) is a recent RNN designed for language modeling based on another linear attention approximation, the attention-free Transformer ([Zhai et al., 2021](#bib.bibx113)). Its main “WKV” mechanism involves LTI recurrences and can be viewed as the ratio of two SSMs.

Other closely related SSMs and architectures are discussed further in an extended related work ([Appendix B](#sb)). We highlight in particular S5 ([Smith et al., 2023](#bib.bibx98)), QRNN ([Bradbury et al., 2016](#bib.bibx11)), and SRU ([Lei et al., 2017](#bib.bibx64)), which we view as the most closely related methods to our core selective SSM.
