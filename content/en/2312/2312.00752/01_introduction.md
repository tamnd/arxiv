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
section: 1
section_title: Introduction
kind: section
lang: en
tag: C9NQ
local_id: s1
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 5
equations: 0
figures:
  - fig-1
tables: []
statements: []
code_blocks: 0
content_sha256: 9b29c8684367aaf9c95555b0f886efffc3958de9aefd2342cd9b3036e56abf53
edited: false
---

Foundation models (FMs), or large models pretrained on massive data then adapted for downstream tasks, have emerged as an effective paradigm in modern machine learning. The backbone of these FMs are often *sequence models*, operating on arbitrary sequences of inputs from a wide variety of domains such as language, images, speech, audio, time series, and genomics ([Sutskever et al., 2014](#bib.bibx101); [Dosovitskiy et al., 2020](#bib.bibx26); [Oord et al., 2016](#bib.bibx78); [Brown et al., 2020](#bib.bibx12); [Ismail et al., 2019](#bib.bibx54); [Poli et al., 2023](#bib.bibx84)). While this concept is agnostic to a particular choice of model architecture, modern FMs are predominantly based on a single type of sequence model: the Transformer ([Vaswani et al., 2017](#bib.bibx106)) and its core attention layer ([Bahdanau et al., 2015](#bib.bibx5)) The efficacy of self-attention is attributed to its ability to route information densely within a context window, allowing it to model complex data. However, this property brings fundamental drawbacks: an inability to model anything outside of a finite window, and quadratic scaling with respect to the window length. An enormous body of research has appeared on more efficient variants of attention to overcome these drawbacks ([Tay et al., 2022](#bib.bibx104)), but often at the expense of the very properties that makes it effective. As of yet, none of these variants have been shown to be empirically effective at scale across domains.

Recently, structured state space sequence models (SSMs) ([Gu et al., 2021](#bib.bibx40); [Gu et al., 2022](#bib.bibx37)) have emerged as a promising class of architectures for sequence modeling. These models can be interpreted as a combination of recurrent neural networks (RNNs) and convolutional neural networks (CNNs), with inspiration from classical state space models ([Kalman, 1960](#bib.bibx57)). This class of models can be computed very efficiently as either a recurrence or convolution, with linear or near-linear scaling in sequence length. Additionally, they have principled mechanisms for modeling long-range dependencies ([Gu et al., 2020](#bib.bibx36)) in certain data modalities, and have dominated benchmarks such as the Long Range Arena ([Tay et al., 2021](#bib.bibx103)). Many flavors of SSMs ([Gu et al., 2022](#bib.bibx37); [Gupta et al., 2022](#bib.bibx42); [Gu et al., 2022a](#bib.bibx39); [Li et al., 2023](#bib.bibx66); [Ma et al., 2023](#bib.bibx70); [Smith et al., 2023](#bib.bibx98); [Orvieto et al., 2023](#bib.bibx79)) have been successful in domains involving continuous signal data such as audio and vision ([Goel et al., 2022](#bib.bibx35); [Saon et al., 2023](#bib.bibx92); [Nguyen et al., 2022](#bib.bibx75)). However, they have been less effective at modeling discrete and information-dense data such as text.

We propose a new class of **selective state space models**, that improves on prior work on several axes to achieve the modeling power of Transformers while scaling linearly in sequence length.

## Selection Mechanism. {#su1-1 .section tag=OJFV}

First, we identify a key limitation of prior models: the ability to efficiently *select* data in an input-dependent manner (i.e. focus on or ignore particular inputs). Building on intuition based on important synthetic tasks such as selective copy and induction heads, we design a simple selection mechanism by parameterizing the SSM parameters based on the input. This allows the model to filter out irrelevant information and remember relevant information indefinitely.

## Hardware-aware Algorithm. {#su1-2 .section tag=K19C}

This simple change poses a technical challenge for the computation of the model; in fact, all prior SSMs models must be time- and input-invariant in order to be computationally efficient. We overcome this with a hardware-aware algorithm that computes the model recurrently with a scan instead of convolution, but does not materialize the expanded state in order to avoid IO access between different levels of the GPU memory hierarchy. The resulting implementation is faster than previous methods both in theory (scaling linearly in sequence length, compared to pseudo-linear for all convolution-based SSMs) and on modern hardware (up to 3$\times$ faster on A100 GPUs).

## Architecture. {#su1-3 .section tag=5SJV}

We simplify prior deep sequence model architectures by combining the design of prior SSM architectures ([Dao et al., 2023](#bib.bibx21)) with the MLP block of Transformers into a single block, leading to a simple and homogenous architecture design (**Mamba**) incorporating selective state spaces.

Selective SSMs, and by extension the Mamba architecture, are fully recurrent models with key properties that make them suitable as the backbone of general foundation models operating on sequences. High quality: selectivity brings strong performance on dense modalities such as language and genomics. Fast training and inference: computation and memory scales linearly in sequence length during training, and unrolling the model autoregressively during inference requires only constant time per step since it does not require a cache of previous elements. Long context: the quality and efficiency together yield performance improvements on real data up to sequence length 1M.

We empirically validate Mamba’s potential as a general sequence FM backbone, in both pretraining quality and domain-specific task performance, on several types of modalities and settings:

- **Synthetics.** On important synthetic tasks such as copying and induction heads that have been proposed as being key to large language models, Mamba not only solves them easily but can *extrapolate solutions indefinitely long* ($>$1M tokens).
- **Audio and Genomics.** Mamba out-performs prior state-of-the-art models such as SaShiMi, Hyena, and Transformers on modeling audio waveforms and DNA sequences, both in pretraining quality and downstream metrics (e.g. reducing FID on a challenging speech generation dataset by more than half). In both settings, its *performance improves with longer context up to million-length sequences*.
- **Language Modeling.** Mamba is the first *linear-time sequence model that truly achieves Transformer-quality performance*, both in pretraining perplexity and downstream evaluations. With scaling laws up to 1B parameters, we show that Mamba exceeds the performance of a large range of baselines, including very strong modern Transformer training recipes based on LLaMa ([Touvron et al., 2023](#bib.bibx105)). Our Mamba language model has 5$\times$ generation throughput compared to Transformers of similar size, and Mamba-3B’s quality matches that of Transformers twice its size (e.g. 4 points higher avg. on common sense reasoning compared to Pythia-3B and even exceeding Pythia-7B).

Model code and pre-trained checkpoints are open-sourced at [https://github.com/state-spaces/mamba](https://github.com/state-spaces/mamba).

**Figure 1** {#fig-1 .figure tag=2TPF}

*The image is withheld because it covers 100 per cent of a page at the 27.66 by 10.31 inches the file states, and the cap is 75 per cent. It is in the paper on arXiv at https://arxiv.org/html/2312.00752v2/selection.svg.*

(**Overview**.) Structured SSMs independently map each channel (e.g. $D=5$) of an input $x$ to output $y$ through a higher dimensional latent state $h$ (e.g. $N=4$). Prior SSMs avoid materializing this large effective state ($DN$, times batch size $B$ and sequence length $L$) through clever alternate computation paths requiring time-invariance: the $(\Delta,\bm{A},\bm{B},\bm{C})$ parameters are constant across time. Our selection mechanism adds back input-dependent dynamics, which also requires a careful hardware-aware algorithm to only materialize the expanded states in more efficient levels of the GPU memory hierarchy.
