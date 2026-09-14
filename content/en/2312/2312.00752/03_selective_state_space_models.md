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
section: 3
section_title: Selective State Space Models
kind: section
lang: en
tag: I1FY
local_id: s3
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 28
equations: 2
figures:
  - fig-2
  - fig-3
tables: []
statements:
  - thm-1
code_blocks: 2
content_sha256: 242395ee184aeca43e028593e9923020d86a96eb975dede8cf36fe077529db3e
edited: false
---

We motivate our selection mechanism using intuition from synthetic tasks ([Section 3.1](#s3-1)), then explain how to incorporate this mechanism into state space models ([Section 3.2](#s3-2)). The resulting time-varying SSMs cannot use convolutions, presenting a technical challenge of how to compute them efficiently. We overcome this with a hardware-aware algorithm that exploits the memory hierarchy on modern hardware ([Section 3.3](#s3-3)). We then describe a simple SSM architecture without attention or even MLP blocks ([Section 3.4](#s3-4)). Finally, we discuss some additional properties of selection mechanisms ([Section 3.5](#s3-5)).

## 3.1 Motivation: Selection as a Means of Compression {#s3-1 .section tag=K86M}

We argue that a fundamental problem of sequence modeling is *compressing context into a smaller state*. In fact, we can view the tradeoffs of popular sequence models from this point of view. For example, attention is both effective and inefficient because it explicitly does not compress context at all. This can be seen from the fact that autoregressive inference requires explicitly storing the entire context (i.e. the KV cache), which directly causes the slow linear-time inference and quadratic-time training of Transformers. On the other hand, recurrent models are efficient because they have a finite state, implying constant-time inference and linear-time training. However, their effectiveness is limited by how well this state has compressed the context.

To understand this principle, we focus on two running examples of synthetic tasks ([Figure 2](#fig-2)).

- The **Selective Copying** task modifies the popular Copying task ([Arjovsky et al., 2016](#bib.bibx1)) by varying the position of the tokens to memorize. It requires *content-aware* reasoning to be able to memorize the relevant tokens (*colored*) and filter out the irrelevant ones (*white*).
- The **Induction Heads** task is a well-known mechanism hypothesized to explain the majority of in-context learning abilities of LLMs ([Olsson et al., 2022](#bib.bibx77)). It requires *context-aware* reasoning to know when to produce the correct output in the appropriate context (*black*).

These tasks reveal the failure mode of LTI models. From the recurrent view, their constant dynamics (e.g. the $(\overline{\bm{A}},\overline{\bm{B}})$ transitions in ([2](#eq-2a))) cannot let them select the correct information from their context, or affect the hidden state passed along the sequence in an input-dependent way. From the convolutional view, it is known that global convolutions can solve the vanilla Copying task ([Romero et al., 2021](#bib.bibx90)) because it only requires time-awareness, but that they have difficulty with the Selective Copying task because of lack of content-awareness ([Figure 2](#fig-2)). More concretely, the spacing between inputs-to-outputs is varying and cannot be modeled by static convolution kernels.

In summary, the efficiency vs. effectiveness tradeoff of sequence models is characterized by how well they compress their state: efficient models must have a small state, while effective models must have a state that contains all necessary information from the context. In turn, we propose that a fundamental principle for building sequence models is **selectivity**: or the context-aware ability to focus on or filter out inputs into a sequential state. In particular, a selection mechanism controls how information propagates or interacts along the sequence dimension (see [Section 3.5](#s3-5) for more discussion).

**Figure 2** {#fig-2 .figure tag=WA3H}

*The image is withheld because it covers 77 per cent of a page at the 17.20 by 4.18 inches the file states, and the cap is 75 per cent. It is in the paper on arXiv at https://arxiv.org/html/2312.00752v2/copying.svg.*

(*Left*) The standard version of the Copying task involves constant spacing between input and output elements and is easily solved by time-invariant models such as linear recurrences and global convolutions. (*Right Top*) The Selective Copying task has random spacing in between inputs and requires time-varying models that can *selectively* remember or ignore inputs depending on their content. (*Right Bottom*) The Induction Heads task is an example of associative recall that requires retrieving an answer based on context, a key ability for LLMs.

## 3.2 Improving SSMs with Selection {#s3-2 .section tag=4UMP}

One method of incorporating a selection mechanism into models is by letting their parameters that affect interactions along the sequence (e.g. the recurrent dynamics of an RNN or the convolution kernel of a CNN) be input-dependent.

[Algorithms 1](#lst-1) and [2](#lst-2) illustrates the main selection mechanism that we use. The main difference is simply making several parameters $\Delta,\bm{B},\bm{C}$ functions of the input, along with the associated changes to tensor shapes throughout. In particular, we highlight that these parameters now have a length dimension $L$, meaning that the model has changed from time-invariant to time-varying. (Note that shape annotations were described in [Section 2](#s2).) This loses the equivalence to convolutions ([3](#eq-3a)) with implications for its efficiency, discussed next.

We specifically choose $s_{B}(x)=\mathsf{Linear}_{N}(x)$, $s_{C}(x)=\mathsf{Linear}_{N}(x)$, $s_{\Delta}(x)=\mathsf{Broadcast}_{D}(\mathsf{Linear}_{1}(x))$, and $\tau_{\Delta}=\mathsf{softplus}$, where $\mathsf{Linear}_{d}$ is a parameterized projection to dimension $d$. The choice of $s_{\Delta}$ and $\tau_{\Delta}$ is due to a connection to RNN gating mechanisms explained in [Section 3.5](#s3-5).

**Algorithm 1** {#lst-1 .code tag=CACG}

SSM (S4)

$x:\mathtt{(B,L,D)}$ \
$y:\mathtt{(B,L,D)}$ \
$\bm{A}:\mathtt{(D,N)}\leftarrow\mathsf{Parameter}$ $\triangleright$ Represents structured $N\times N$ matrix \
$\bm{B}:\mathtt{(D,N)}\leftarrow\mathsf{Parameter}$ \
$\bm{C}:\mathtt{(D,N)}\leftarrow\mathsf{Parameter}$ \
$\Delta:\mathtt{(D)}\leftarrow\tau_{\Delta}(\mathsf{Parameter})$ \
$\overline{\bm{A}},\overline{\bm{B}}:\mathtt{(D,N)}\leftarrow\mathsf{discretize}(\Delta,\bm{A},\bm{B})$ \
$y\leftarrow\mathsf{SSM}(\overline{\bm{A}},\overline{\bm{B}},\bm{C})(x)$ $\triangleright$ Time-invariant: recurrence or convolution \
**return** $y$

**Algorithm 2** {#lst-2 .code tag=ZYR5}

SSM + Selection (S6)

$x:\mathtt{(B,L,D)}$ \
$y:\mathtt{(B,L,D)}$ \
$\bm{A}:\mathtt{(D,N)}\leftarrow\mathsf{Parameter}$ $\triangleright$ Represents structured $N\times N$ matrix \
$\bm{B}:{\color[rgb]{0.72,0,0}\mathtt{(B,L,N)}}\leftarrow{\color[rgb]{0.72,0,0}s_{B}(x)}$ \
$\bm{C}:{\color[rgb]{0.72,0,0}\mathtt{(B,L,N)}}\leftarrow{\color[rgb]{0.72,0,0}s_{C}(x)}$ \
$\Delta:{\color[rgb]{0.72,0,0}\mathtt{(B,L,D)}}\leftarrow\tau_{\Delta}(\mathsf{Parameter}{\color[rgb]{0.72,0,0}+s_{\Delta}(x)})$ \
$\overline{\bm{A}},\overline{\bm{B}}:{\color[rgb]{0.72,0,0}\mathtt{(B,L,D,N)}}\leftarrow\mathsf{discretize}(\Delta,\bm{A},\bm{B})$ \
$y\leftarrow\mathsf{SSM}(\overline{\bm{A}},\overline{\bm{B}},\bm{C})(x)$ $\triangleright$ Time-varying: recurrence (*scan*) only \
**return** $y$

## 3.3 Efficient Implementation of Selective SSMs {#s3-3 .section tag=A1RO}

Hardware-friendly primitives such as convolutions ([Krizhevsky et al., 2012](#bib.bibx62)) and attention ([Bahdanau et al., 2015](#bib.bibx5); [Vaswani et al., 2017](#bib.bibx106)) enjoy widespread application. Here we aim to make selective SSMs efficient on modern hardware (GPUs) as well. The selection mechanism is quite natural, and earlier works attempted to incorporate special cases of selection, such as letting $\Delta$ vary over time in recurrent SSMs ([Gu et al., 2020](#bib.bibx36)). However, as previously mentioned a core limitation in the usage of SSMs is their computational efficiency, which was why S4 and all derivatives used LTI (non-selective) models, most commonly in the form of global convolutions.

### 3.3.1 Motivation of Prior Models {#s3-3-1 .section tag=F2G4}

We first revisit this motivation and overview our approach to overcome limitations of prior methods.

- At a high level, recurrent models such as SSMs always balance a tradeoff between expressivity and speed: as discussed in [Section 3.1](#s3-1), models with larger hidden state dimension should be more effective but slower. Thus we want to *maximize hidden state dimension without paying speed and memory costs*.
- Note that the recurrent mode is more flexible than the convolution mode, since the latter ([3](#eq-3a)) is derived from expanding the former ([2](#eq-2a)) ([Gu et al., 2021](#bib.bibx40); [Gu et al., 2022](#bib.bibx37)). However, this would require computing and materializing the latent state $h$ with shape $\mathtt{(B,L,D,N)}$, which is much larger (by a factor of $N$, the SSM state dimension) than the input $x$ and output $y$ of shape $\mathtt{(B,L,D)}$. Thus the more efficient convolution mode was introduced which could bypass the state computation and materializes a convolution kernel ([3a](#eq-3a)) of size only $\mathtt{(B,L,D)}$.
- Prior LTI state space models leverage the dual recurrent-convolutional forms to increase the effective state dimension by a factor of $N$ ($\approx 10-100$), much larger than traditional RNNs, without efficiency penalties.

### 3.3.2 Overview of Selective Scan: Hardware-Aware State Expansion {#s3-3-2 .section tag=5X0E}

The selection mechanism is designed to overcome the limitations of LTI models; at the same time, we therefore need to revisit the computation problem of SSMs. We address this with three classical techniques: kernel fusion, parallel scan, and recomputation. We make two main observations:

- The naive recurrent computation uses $O(BLDN)$ FLOPs while the convolutional computation uses $O(BLD\log(L))$ FLOPs, and the former has a lower constant factor. Thus for long sequences and not-too-large state dimension $N$, the recurrent mode can actually use fewer FLOPs.
- The two challenges are the sequential nature of recurrence, and the large memory usage. To address the latter, just like the convolutional mode, we can attempt to not actually materialize the full state $h$.

The main idea is to leverage properties of modern accelerators (GPUs) to materialize the state $h$ only in more efficient levels of the memory hierarchy. In particular, most operations (except matrix multiplication) are bounded by memory bandwidth ([Williams et al., 2009](#bib.bibx110); [Ivanov et al., 2021](#bib.bibx55); [Dao et al., 2022](#bib.bibx20)). This includes our scan operation, and we use kernel fusion to reduce the amount of memory IOs, leading to a significant speedup compared to a standard implementation.

Concretely, instead of preparing the scan input $(\overline{\bm{A}},\overline{\bm{B}})$ of size $\mathtt{(B,L,D,N)}$ in GPU HBM (high-bandwidth memory), we load the SSM parameters $(\Delta,\bm{A},\bm{B},\bm{C})$ directly from slow HBM to fast SRAM, perform the discretization and recurrence in SRAM, and then write the final outputs of size $(\mathtt{B,L,D})$ back to HBM.

To avoid the sequential recurrence, we observe that despite not being linear it can still be parallelized with a work-efficient parallel scan algorithm ([Blelloch, 1990](#bib.bibx10); [Martin & Cundy, 2018](#bib.bibx71); [Smith et al., 2023](#bib.bibx98)).

Finally, we must also avoid saving the intermediate states, which are necessary for backpropagation. We carefully apply the classic technique of recomputation to reduce the memory requirements: the intermediate states are not stored but recomputed in the backward pass when the inputs are loaded from HBM to SRAM. As a result, the fused selective scan layer has the same memory requirements as an optimized transformer implementation with FlashAttention.

Details of the fused kernel and recomputation are in [Appendix D](#sd). The full Selective SSM layer and algorithm is illustrated in [Figure 1](#fig-1).

## 3.4 A Simplified SSM Architecture {#s3-4 .section tag=F8OP}

As with structured SSMs, selective SSMs are standalone sequence transformations that can be flexibly incorporated into neural networks. The H3 architecture is the basis for the most well-known SSM architectures ([Section 2](#s2)), which are generally comprised of a block inspired by linear attention interleaved with an MLP (multi-layer perceptron) block. We simplify this architecture by combining these two components into one, which is stacked homogenously ([Figure 3](#fig-3)). This is inspired by the gated attention unit (GAU) ([Hua et al., 2022](#bib.bibx53)), which did something similar for attention.

This architecture involves expanding the model dimension $D$ by a controllable expansion factor $E$. For each block, most of the parameters ($3ED^{2}$) are in the linear projections ($2ED^{2}$ for input projections, $ED^{2}$ for output projection) while the inner SSM contributes less. The number of SSM parameters (projections for $\Delta,\bm{B},\bm{C}$, and the matrix $\bm{A}$) are much smaller in comparison. We repeat this block, interleaved with standard normalization and residual connections, to form the Mamba architecture. We always fix to $E=2$ in our experiments and use two stacks of the block to match the $12D^{2}$ parameters of a Transformer’s interleaved MHA (multi-head attention) and MLP blocks. We use the SiLU / Swish activation function ([Hendrycks & Gimpel, 2016](#bib.bibx48); [Ramachandran et al., 2017](#bib.bibx89)), motivated so that the Gated MLP becomes the popular “SwiGLU” variant ([Dauphin et al., 2017](#bib.bibx22); [Shazeer, 2020](#bib.bibx95); [Chowdhery et al., 2023](#bib.bibx16); [Touvron et al., 2023](#bib.bibx105)). Finally, we additionally use an optional normalization layer (we choose LayerNorm ([Ba et al., 2016a](#bib.bibx4))), motivated by RetNet’s usage of a normalization layer in a similar location ([Sun et al., 2023](#bib.bibx100)).

**Figure 3** {#fig-3 .figure tag=SZ7N}

![](/figures/2312/2312.00752/architecture.svg)

(**Architecture**.) Our simplified block design combines the H3 block, which is the basis of most SSM architectures, with the ubiquitous MLP block of modern neural networks. Instead of interleaving these two blocks, we simply repeat the Mamba block homogenously. Compared to the H3 block, Mamba replaces the first multiplicative gate with an activation function. Compared to the MLP block, Mamba adds an SSM to the main branch. For $\sigma$ we use the SiLU / Swish activation ([Hendrycks & Gimpel, 2016](#bib.bibx48); [Ramachandran et al., 2017](#bib.bibx89)).

## 3.5 Properties of Selection Mechanisms {#s3-5 .section tag=BTHY}

The selection mechanism is a broader concept that can be applied in different ways, such as to more traditional RNNs or CNNs, to different parameters (e.g. $\bm{A}$ in [Algorithm 2](#lst-2)), or using different transformations $s(x)$.

### 3.5.1 Connection to Gating Mechanisms {#s3-5-1 .section tag=YJFR}

We highlight the most important connection: the classical gating mechanism of RNNs is an instance of our selection mechanism for SSMs. We note that the connection between RNN gating and the discretization of continuous-time systems is well established ([Funahashi & Nakamura, 1993](#bib.bibx32); [Tallec & Ollivier, 2018](#bib.bibx102)). In fact, [Theorem 1](#thm-1) is an improvement of [Gu et al. (2021, Lemma 3.1)](#bib.bibx40) generalizing to the ZOH discretization and input-dependent gates (proof in [Appendix C](#sc)). More broadly, $\Delta$ in SSMs can be seen to play a generalized role of the RNN gating mechanism. In line with prior work, we adopt the view that *discretization of SSMs is the principled foundation of heuristic gating mechanisms*.

**Theorem 1** {#thm-1 .statement tag=3KH2 env=theorem}

*When $N=1,\bm{A}=-1,\bm{B}=1,s_{\Delta}=\mathsf{Linear}(x)$, and $\tau_{\Delta}=\mathsf{softplus}$, then the selective SSM recurrence ([Algorithm 2](#lst-2)) takes the form*

$$
g_{t} =\sigma(\mathsf{Linear}(x_{t}))
$$
{#eq-5 .equation tag=XDF2}

$$
h_{t} =(1-g_{t})h_{t-1}+g_{t}x_{t}.
$$

As mentioned in [Section 3.2](#s3-2), our specific choices of $s_{\Delta},\tau_{\Delta}$ is from this connection. In particular, note that if a given input $x_{t}$ should be completely ignored (as necessary in the synthetic tasks), all $D$ channels should ignore it, and so we project the input down to $1$ dimension before repeating/broadcasting with $\Delta$.

### 3.5.2 Interpretation of Selection Mechanisms {#s3-5-2 .section tag=MUW3}

We elaborate on three particular mechanistic effects of selection.

#### Variable Spacing. {#su3-5-2-1 .section tag=JZE8}

Selectivity allows filtering out irrelevant noise tokens that may occur between inputs of interest. This is exemplified by the Selective Copying task, but occurs ubiquitously in common data modalities, particularly for discrete data – for example the presence of language fillers such as “um”. This property arises because the model can mechanistically filter out any particular input $x_{t}$, for example in the gated RNN case ([Theorem 1](#thm-1)) when $g_{t}\to 0$.

#### Filtering Context. {#su3-5-2-2 .section tag=8CVO}

It has been empirically observed that many sequence models do not improve with longer context ([Shi et al., 2023](#bib.bibx96)), despite the principle that more context should lead to strictly better performance. An explanation is that many sequence models cannot effectively ignore irrelevant context when necessary; an intuitive example are global convolutions (and general LTI models). On the other hand, selective models can simply reset their state at any time to remove extraneous history, and thus their performance in principle improves monotonicly with context length (e.g. [Section 4.3.2](#s4-3-2)).

#### Boundary Resetting. {#su3-5-2-3 .section tag=G87J}

In settings where multiple independent sequences are stitched together, Transformers can keep them separate by instantiating a particular attention mask, while LTI models will bleed information between the sequences. Selective SSMs can also reset their state at boundaries (e.g. $\Delta_{t}\to\infty$, or [Theorem 1](#thm-1) when $g_{t}\to 1$). These settings may occur artificially (e.g. packing documents together to improve hardware utilization) or naturally (e.g. episode boundaries in reinforcement learning ([Lu et al., 2023](#bib.bibx68))).

Additionally, we elaborate on effects of each selective parameter.

#### Interpretation of $\Delta$. {#su3-5-2-4 .section tag=IUVO}

In general, $\Delta$ controls the balance between how much to focus or ignore the current input $x_{t}$. It generalizes RNN gates (e.g. $g_{t}$ in [Theorem 1](#thm-1)): mechanically, a large $\Delta$ resets the state $h$ and focuses on the current input $x$, while a small $\Delta$ persists the state and ignores the current input. SSMs ([1](#eq-1a))-([2](#eq-2a)) can be interpreted as a continuous system discretized by a timestep $\Delta$, and in this context the intuition is that large $\Delta\to\infty$ represents the system focusing on the current input for longer (thus “selecting” it and forgetting its current state) while a small $\Delta\to 0$ represents a transient input that is ignored.

#### Interpretation of $\bm{A}$. {#su3-5-2-5 .section tag=24V6}

We remark that while the $\bm{A}$ parameter could also be selective, it ultimately affects the model only through its interaction with $\Delta$ via $\overline{\bm{A}}=\exp(\Delta\bm{A})$ (the discretization ([4](#eq-4))). Thus selectivity in $\Delta$ is enough to ensure selectivity in $(\overline{\bm{A}},\overline{\bm{B}})$, and is the main source of improvement. We hypothesize that making $\bm{A}$ selective in addition to (or instead of) $\Delta$ would have similar performance, and leave it out for simplicity.

#### Interpretation of $\bm{B}$ and $\bm{C}$. {#su3-5-2-6 .section tag=I0HY}

As discussed in [Section 3.1](#s3-1), the most important property of selectivity is filtering out irrelevant information so that a sequence model’s context can be compressed into an efficient state. In an SSM, modifying $\bm{B}$ and $\bm{C}$ to be selective allows finer-grained control over whether to let an input $x_{t}$ into the state $h_{t}$, or the state into the output $y_{t}$. These can be interpreted as allowing the model to modulate the recurrent dynamics based on content (input) and context (hidden states) respectively.

## 3.6 Additional Model Details {#s3-6 .section tag=VNSI}

### Real vs. Complex. {#su3-6-1 .section tag=G5HL}

Most prior SSMs use complex numbers in their state $h$, which is necessary for strong performance on many tasks in perceptual modalities ([Gu et al., 2022](#bib.bibx37)). However, it has been empirically observed that completely real-valued SSMs seem to work fine, and possibly even better, in some settings ([Ma et al., 2023](#bib.bibx70)). We use real values as the default, which work well for all but one of our tasks; we hypothesize that the complex-real tradeoff is related to the continuous-discrete spectrum in data modalities, where complex numbers are helpful for continuous modalities (e.g. audio, video) but not discrete (e.g. text, DNA).

### Initialization. {#su3-6-2 .section tag=EFDR}

Most prior SSMs also suggest special initializations, particularly in the complex-valued case, which can help in several settings such as low-data regimes. Our default initialization for the complex case is S4D-Lin and for the real case is S4D-Real ([Gu et al., 2022a](#bib.bibx39)), which is based on the HIPPO theory ([Gu et al., 2020](#bib.bibx36)). These define the $n$-th element of $\bm{A}$ as $-1/2+ni$ and $-(n+1)$ respectively. However, we expect many initializations to work fine, particularly in the large-data and real-valued SSM regimes; some ablations are considered in [Section 4.6](#s4-6).

### Parameterization of $\Delta$. {#su3-6-3 .section tag=IU8R}

We defined the selective adjustment to $\Delta$ as $s_{\Delta}(x)=\mathsf{Broadcast}_{D}(\mathsf{Linear}_{1}(x))$, which was motivated by the mechanics of $\Delta$ ([Section 3.5](#s3-5)). We observe that it can be generalized from dimension $1$ to a larger dimension $\mathtt{R}$. We set this to be a small fraction of $\mathtt{D}$, which uses a negligible number of parameters compared to the main Linear projections in the block. We additionally note that the broadcasting operation can instead be viewed as another Linear projection, initialized to a specific pattern of $1$’s and $0$’s; if this projection is trainable, this leads to the alternative $s_{\Delta}(x)=\mathsf{Linear}_{D}(\mathsf{Linear}_{R}(x))$, which can be viewed as a low-rank projection.

In our experiments, the $\Delta$ parameter (which can be viewed as a bias term) is initialized to $\tau_{\Delta}^{-1}(\mathsf{Uniform}([0.001,0.1]))$, following prior work on SSMs ([Gu et al., 2023](#bib.bibx41)).

**Remark 3.1** {#rem-3-1 .remark tag=NRU8 env=remark}

*For brevity in our experimental results, we sometimes abbreviate selective SSMs as *S6 models*, because they are S4 models with a *selection* mechanism and computed with a *scan*.*
