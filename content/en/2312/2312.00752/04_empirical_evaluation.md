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
section: 4
section_title: Empirical Evaluation
kind: section
lang: en
tag: 6YO1
local_id: s4
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 45
equations: 0
figures:
  - fig-4
  - fig-5
  - fig-6
  - fig-6a
  - fig-6b
  - fig-7
  - fig-7a
  - fig-7b
  - fig-8
  - fig-9
  - fig-10
  - fig-11
  - fig-12
  - fig-12a
  - fig-12b
  - fig-13
  - fig-14
  - fig-15
  - fig-16
tables:
  - tab-1
  - tab-2
statements: []
code_blocks: 0
content_sha256: c373f3529a31852e9e489136cbf282a9e37dd21ee0a2fd621bba072c9becc31a
edited: false
---

In [Section 4.1](#s4-1) we test Mamba’s ability to solve the two synthetic tasks motivated in [Section 3.1](#s3-1). We then evaluate on three domains, each evaluated on autoregressive pretraining as well as downstream tasks.

- [Section 4.2](#s4-2): language model pretraining (scaling laws), and zero-shot downstream evaluation.
- [Section 4.3](#s4-3): DNA sequence pretraining, and fine-tuning on a long-sequence classification task.
- [Section 4.4](#s4-4): audio waveform pretraining, and the quality of autoregressively generated speech clips.

Finally, [Section 4.5](#s4-5) shows Mamba’s computational efficiency at both training and inference time, and [Section 4.6](#s4-6) ablates various components of the architecture and selective SSMs.

## 4.1 Synthetic Tasks {#s4-1 .section tag=NL0I}

Full experiment details for these tasks including task details and training protocol are in [Section E.1](#se-1).

### 4.1.1 Selective Copying {#s4-1-1 .section tag=JRJD}

The Copying task is one of the most well-studied synthetic tasks for sequence modeling, originally designed to test the memorization abilities of recurrent models. As discussed in [Section 3.1](#s3-1), LTI SSMs (linear recurrences and global convolutions) can easily solve this task by only keeping track of time instead of reasoning about the data; for example, by constructing a convolution kernel of exactly the right length ([Figure 2](#fig-2)). This was explicitly validated in earlier work on global convolutions ([Romero et al., 2021](#bib.bibx90)). The Selective Copying task prevents this shortcut by randomizing the spacing between tokens. Note that this task has been introduced before as the Denoising task ([Jing et al., 2019](#bib.bibx56)).

Note that many previous works argue that adding architecture gating (multiplicative interactions) can endow models with “data-dependence” and solve related tasks ([Dao et al., 2023](#bib.bibx21); [Poli et al., 2023](#bib.bibx84)). However, we find this explanation insufficient intuitively because such gating does not interact along the sequence axis, and cannot affect the spacing between tokens. In particular architecture gating is not an instance of a selection mechanism ([Appendix A](#sa)).

[Figure 5](#fig-4) confirms that gated architectures such as H3 and Mamba only partially improve performance, while the selection mechanism (modifying S4 to S6) easily solves this task, particularly when combined with these more powerful architectures.

### 4.1.2 Induction Heads {#s4-1-2 .section tag=5CDI}

Induction heads ([Olsson et al., 2022](#bib.bibx77)) is a simple task from the mechanistic interpretability lens ([Elhage et al., 2021](#bib.bibx27)) that is surprisingly predictive of the in-context learning ability of LLMs. It requires models to perform associative recall and copy: for example, if the model has seen a bigram such as “Harry Potter” in the sequence, then the next time “Harry” appears in the same sequence, the model should be able to predict “Potter” by copying from history.

#### Dataset. {#su4-1-2-1 .section tag=ID96}

We train a 2-layer model on the induction heads task at sequence length $256$, with a vocab size of $16$, which is comparable to prior work on this task ([Dao et al., 2023](#bib.bibx21)) but with longer sequences. We additionally investigate generalization and extrapolation abilities by evaluating on a range of sequence lengths from $2^{6}=64$ up to $2^{20}=1048576$ at test time.

#### Models. {#su4-1-2-2 .section tag=DI8W}

Following established work on induction heads, we use 2 layer models, which allows attention to mechanistically solve the induction heads task ([Olsson et al., 2022](#bib.bibx77)). We test both multi-head attention (8 heads, with various positional encodings) and SSM variants. We use a model dimension $D$ of $64$ for Mamba and $128$ for the other models.

#### Results. {#su4-1-2-3 .section tag=B77R}

[Figure 5](#fig-4) shows that Mamba—or more precisely, its selective SSM layer—has the ability to solve the task perfectly because of its ability to selectively remember the relevant token while ignoring everything else in between. **It generalizes perfectly to million-length sequences, or $4000\times$ longer than it saw during training**, while no other method goes beyond $2\times$.

Out of positional encoding variants for attention models, xPos (which was designed for length extrapolation) is slightly better than the others; also note that all attention models were only tested up to sequence length $2^{14}=16384$ due to memory limitations. Out of other SSMs, H3 and Hyena are similar, contrary to the findings in [Poli et al. (2023)](#bib.bibx84).

**Figure 4** {#fig-4 .figure tag=C5EH}

|  |  |  |  |
| :--- | :--- | :--- | :--- |
| Model | Arch. | Layer | Acc. |
| S4 | No gate | S4 | 18.3 |
| - | No gate | S6 | **97.0** |
| H3 | H3 | S4 | 57.0 |
| Hyena | H3 | Hyena | 30.1 |
| - | H3 | S6 | **99.7** |
| - | Mamba | S4 | 56.4 |
| - | Mamba | Hyena | 28.4 |
| Mamba | Mamba | S6 | **99.8** |

(**Selective Copying**.) Accuracy for combinations of architectures and inner sequence layers.

**Figure 5** {#fig-5 .figure tag=0XLR}

![](/figures/2312/2312.00752/induction.svg)

(**Induction Heads**.) Models are trained on sequence length $2^{8}=256$, and tested on increasing sequence lengths of $2^{6}=64$ up to $2^{20}=1048576$. Full numbers in [Table 3](#tab-3).

## 4.2 Language Modeling {#s4-2 .section tag=WPM6}

We evaluate the Mamba architecture on standard autoregressive language modeling against other architectures, on both pretraining metrics (perplexity) and zero-shot evaluations. We set the model sizes (depth and width) to mirror GPT3 specifications. We use the Pile dataset ([Gao et al., 2020](#bib.bibx33)), and follow the training recipe described in [Brown et al. (2020)](#bib.bibx12). All training details are in [Section E.2](#se-2).

### 4.2.1 Scaling Laws {#s4-2-1 .section tag=IHLF}

For baselines, we compare against the standard Transformer architecture (GPT3 architecture), as well as the strongest Transformer recipe we know of (here referred to as Transformer++), based on the PaLM and LLaMa architectures (e.g. rotary embedding, SwiGLU MLP, RMSNorm instead of LayerNorm, no linear bias, and higher learning rates). We also compare against other recent subquadratic architectures ([Figure 6](#fig-6)). All model details are in [Section E.2](#se-2).

[Figure 6](#fig-6) shows scaling laws under the standard Chinchilla ([Hoffmann et al., 2022](#bib.bibx52)) protocol, on models from $\approx 125M$ to $\approx 1.3B$ parameters. **Mamba is the first attention-free model to match the performance of a very strong Transformer recipe (Transformer++) that has now become standard, particularly as the sequence length grows.** (We note that full results on context length 8k are missing for the RWKV and RetNet baselines, prior strong recurrent models that can also be interpreted as SSMs, because of a lack of efficient implementations leading to out-of-memory or unrealistic computation requirements.)

**Figure 6** {#fig-6 .figure tag=A7WP}

(**Scaling Laws**.) Models of size $\approx 125M$ to $\approx 1.3B$ parameters, trained on the Pile. Mamba scales better than all other attention-free models and is the first to match the performance of a very strong “Transformer++” recipe that has now become standard, particularly as the sequence length grows.

**Figure** {#fig-6a .figure tag=RW43}

![](/figures/2312/2312.00752/pile_2k.svg)

**Figure** {#fig-6b .figure tag=JHBJ}

![](/figures/2312/2312.00752/pile_8k.svg)

### 4.2.2 Downstream Evaluations {#s4-2-2 .section tag=WRSN}

[Table 1](#tab-1) shows the performance of Mamba on a range of popular downstream zero-shot evaluation tasks. We compare against the most well-known open source models at these sizes, most importantly Pythia ([Biderman et al., 2023](#bib.bibx7)) and RWKV ([Peng et al., 2023](#bib.bibx82)) which were trained with the same tokenizer, dataset, and training length (300B tokens) as our models. (Note that Mamba and Pythia are trained with context length 2048, while RWKV was trained with context length 1024.)

**Table 1** {#tab-1 .table tag=KESZ}

|  |  |  |  |  |  |  |  |  |  |  |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Model | Token. | Pile | LAMBADA | LAMBADA | HellaSwag | PIQA | Arc-E | Arc-C | WinoGrande | Average |
|  |  | ppl $\downarrow$ | ppl $\downarrow$ | acc $\uparrow$ | acc $\uparrow$ | acc $\uparrow$ | acc $\uparrow$ | acc $\uparrow$ | acc $\uparrow$ | acc $\uparrow$ |
| Hybrid H3-130M | GPT2 | — | 89.48 | 25.77 | 31.7 | 64.2 | 44.4 | 24.2 | 50.6 | 40.1 |
| Pythia-160M | NeoX | 29.64 | 38.10 | 33.0 | 30.2 | 61.4 | 43.2 | 24.1 | **51.9** | 40.6 |
| **Mamba-130M** | NeoX | **10.56** | **16.07** | **44.3** | **35.3** | **64.5** | **48.0** | **24.3** | **51.9** | **44.7** |
| Hybrid H3-360M | GPT2 | — | 12.58 | 48.0 | 41.5 | 68.1 | 51.4 | 24.7 | 54.1 | 48.0 |
| Pythia-410M | NeoX | 9.95 | 10.84 | 51.4 | 40.6 | 66.9 | 52.1 | 24.6 | 53.8 | 48.2 |
| **Mamba-370M** | NeoX | **8.28** | **8.14** | **55.6** | **46.5** | **69.5** | **55.1** | **28.0** | **55.3** | **50.0** |
| Pythia-1B | NeoX | 7.82 | 7.92 | 56.1 | 47.2 | 70.7 | 57.0 | 27.1 | 53.5 | 51.9 |
| **Mamba-790M** | NeoX | **7.33** | **6.02** | **62.7** | **55.1** | **72.1** | **61.2** | **29.5** | **56.1** | **57.1** |
| GPT-Neo 1.3B | GPT2 | — | 7.50 | 57.2 | 48.9 | 71.1 | 56.2 | 25.9 | 54.9 | 52.4 |
| Hybrid H3-1.3B | GPT2 | — | 11.25 | 49.6 | 52.6 | 71.3 | 59.2 | 28.1 | 56.9 | 53.0 |
| OPT-1.3B | OPT | — | 6.64 | 58.0 | 53.7 | 72.4 | 56.7 | 29.6 | 59.5 | 55.0 |
| Pythia-1.4B | NeoX | 7.51 | 6.08 | 61.7 | 52.1 | 71.0 | 60.5 | 28.5 | 57.2 | 55.2 |
| RWKV-1.5B | NeoX | 7.70 | 7.04 | 56.4 | 52.5 | 72.4 | 60.5 | 29.4 | 54.6 | 54.3 |
| **Mamba-1.4B** | NeoX | **6.80** | **5.04** | **64.9** | **59.1** | **74.2** | **65.5** | **32.8** | **61.5** | **59.7** |
| GPT-Neo 2.7B | GPT2 | — | 5.63 | 62.2 | 55.8 | 72.1 | 61.1 | 30.2 | 57.6 | 56.5 |
| Hybrid H3-2.7B | GPT2 | — | 7.92 | 55.7 | 59.7 | 73.3 | 65.6 | 32.3 | 61.4 | 58.0 |
| OPT-2.7B | OPT | — | 5.12 | 63.6 | 60.6 | 74.8 | 60.8 | 31.3 | 61.0 | 58.7 |
| Pythia-2.8B | NeoX | 6.73 | 5.04 | 64.7 | 59.3 | 74.0 | 64.1 | 32.9 | 59.7 | 59.1 |
| RWKV-3B | NeoX | 7.00 | 5.24 | 63.9 | 59.6 | 73.7 | 67.8 | 33.1 | 59.6 | 59.6 |
| **Mamba-2.8B** | NeoX | **6.22** | **4.23** | **69.2** | **66.1** | **75.2** | **69.7** | **36.3** | **63.5** | **63.3** |
| GPT-J-6B | GPT2 | – | 4.10 | 68.3 | 66.3 | 75.4 | 67.0 | 36.6 | 64.1 | 63.0 |
| OPT-6.7B | OPT | – | 4.25 | 67.7 | 67.2 | 76.3 | 65.6 | 34.9 | 65.5 | 62.9 |
| Pythia-6.9B | NeoX | 6.51 | 4.45 | 67.1 | 64.0 | 75.2 | 67.3 | 35.5 | 61.3 | 61.7 |
| RWKV-7.4B | NeoX | 6.31 | 4.38 | 67.2 | 65.5 | 76.1 | 67.8 | 37.5 | 61.0 | 62.5 |

(**Zero-shot Evaluations**.) Best results for each size in bold. We compare against open source LMs with various tokenizers, trained for up to 300B tokens. Pile refers to the validation split, comparing only against models trained on the same dataset and tokenizer (GPT-NeoX-20B). For each model size, Mamba is best-in-class on every single evaluation result, and generally matches baselines at twice the model size.

## 4.3 DNA Modeling {#s4-3 .section tag=MZZC}

Motivated by the success of large language models, there has been recent exploration into using the foundation model paradigm for genomics. DNA has been likened to language in that it consists of sequences of discrete tokens with a finite vocabulary. It is also known for requiring long-range dependencies to model ([Avsec et al., 2021](#bib.bibx2)). We investigate Mamba as a FM backbone for pretraining and fine-tuning in the same setting as recent works on long-sequence models for DNA ([Nguyen et al., 2023](#bib.bibx76)). In particular, we focus on two explorations of scaling laws across model size and sequence length ([Figure 7](#fig-7)), and a difficult downstream synthetic classification task requiring long context ([Figure 9](#fig-8)).

For pretraining, we largely follow a standard causal language modeling (next token prediction) setup for the training and model details (see also [Section E.2](#se-2)). For the dataset, we largely follow the setup of HyenaDNA ([Nguyen et al., 2023](#bib.bibx76)), which uses the HG38 dataset for pretraining consisting of a single human genome with about 4.5 billion tokens (DNA base pairs) in the training split.

### 4.3.1 Scaling: Model Size {#s4-3-1 .section tag=G111}

In this experiment, we investigate the scaling properties of genomics foundation models with various model backbones ([Figure 7](#fig-7) *Left*).

#### Training. {#su4-3-1-1 .section tag=VVFM}

To advantage the baselines, we train on a short sequence length of $1024$; as shown in [Section 4.3.2](#s4-3-2), we expect results to favor Mamba even more at longer sequence lengths. We fix a global batch size of $1024$, for a total of $2^{20}\approx 1M$ tokens per batch. Models were trained for $10K$ gradient steps for a total of $10B$ tokens.

#### Results. {#su4-3-1-2 .section tag=MN7Q}

[Figure 7](#fig-7) (*Left*) shows that Mamba’s pretraining perplexity improves smoothly with model size, and that Mamba scales better than both HyenaDNA and Transformer++. For example, at the largest model size of $\approx 40M$ parameters, the curve shows that **Mamba can match the Transformer++ and HyenaDNA models with roughly $3\times$ to $4\times$ fewer parameters**.

### 4.3.2 Scaling: Context Length {#s4-3-2 .section tag=DGO7}

In the next DNA experiment, we investigate the scaling properties of models with respect to sequence length. We only compare the HyenaDNA and Mamba models, as quadratic attention becomes prohibitively expensive at longer sequence lengths. We pretrain models on sequence lengths $2^{10}=1024$, $2^{12}=4096$, $2^{14}=16384$, $2^{16}=65536$, $2^{18}=262144$, $2^{20}=1048576$. We fix a model size of 6 layers by width $128$ (about 1.3M-1.4M parameters). Models were trained for $20K$ gradient steps for a total of $\approx 330B$ tokens. The longer sequence lengths used sequence length warmup similar to ([Nguyen et al., 2023](#bib.bibx76)).

#### Results. {#su4-3-2-1 .section tag=OBL6}

[Figure 7](#fig-7) (*Right*) shows that **Mamba is able to make use of longer context even up to extremely long sequences of length 1M**, and its pretraining perplexity improves as the context increases. On the other hand, the HyenaDNA model gets worse with sequence length. This is intuitive from the discussion in [Section 3.5](#s3-5) on properties of the selection mechanism. In particular, LTI models cannot selectively ignore information; from a convolutional perspective, a very long convolution kernel is aggregating all information across a long sequence which may be very noisy. Note that while HyenaDNA claims to improve with longer context, their results do not control for computation time.

### 4.3.3 Synthetic Species Classification {#s4-3-3 .section tag=2DYZ}

We evaluate models on a downstream task of classifying between 5 different species by randomly sampling a contiguous segment of their DNA. This task is adapted from HyenaDNA, which used the species $\{\texttt{human},\texttt{lemur},\texttt{mouse},\texttt{pig},\texttt{hippo}\}$. We modify the task to be significantly more challenging by classifying between the five *great apes* species $\{\texttt{human},\texttt{chimpanzee},\texttt{gorilla},\texttt{orangutan},\texttt{bonobo}\}$, which are known to share 99% of their DNA.

**Figure 7** {#fig-7 .figure tag=WPV3}

(**DNA Scaling Laws**.) Pretraining on the HG38 (human genome) dataset. (*Left*) Fixing short context length $2^{10}=1024$ and increasing size from $\approx 200K$ to $\approx 40M$ parameters, Mamba scales better than baselines. (*Right*) Fixing model size and increasing sequence lengths while keeping tokens/batch and total training tokens fixed. Unlike baselines, the selection mechanism of Mamba facilitates better performance with increasing context length.

**Figure** {#fig-7a .figure tag=OQWJ}

![](/figures/2312/2312.00752/dna_scaling.svg)

**Figure** {#fig-7b .figure tag=U6QN}

![](/figures/2312/2312.00752/dna_length.svg)

**Figure 8** {#fig-8 .figure tag=11PF}

![](/figures/2312/2312.00752/species.svg)

(**Great Apes DNA Classification**.) Accuracy after fine-tuning on sequences of length $2^{10}=1024$ up to $2^{20}=1048576$ using pretrained models of the same context length. Numerical results in [Table 5](#tab-5).

**Figure 9** {#fig-9 .figure tag=2Q5X}

![](/figures/2312/2312.00752/youtubemix.svg)

(**Audio Pretraining**.) Mamba improves performance over prior state-of-the-art (Sashimi) in autoregressive audio modeling, while improving up to minute-long context or million-length sequences (controlling for computation).

## 4.4 Audio Modeling and Generation {#s4-4 .section tag=Y9HO}

For the audio waveform modality, we compare primarily to the SaShiMi architecture and training protocols ([Goel et al., 2022](#bib.bibx35)). This model comprises:

1. a U-Net backbone with two stages of pooling by a factor $p$ that doubles the model dimension $D$ per stage,
2. alternating S4 and MLP blocks in each stage.

We consider replacing the S4+MLP blocks with Mamba blocks. Experiment details are in [Section E.4](#se-4).

### 4.4.1 Long-Context Autoregressive Pretraining {#s4-4-1 .section tag=FTRF}

We evaluate pretraining quality (autoregressive next-sample prediction) on YouTubeMix ([DeepSound, 2017](#bib.bibx23)), a standard piano music dataset used by prior work consisting of $4$ hours of solo piano music, sampled at a rate of 16000 Hz. Pretraining details largely follow the standard language modeling setup ([Section 4.2](#s4-2)). [Figure 9](#fig-8) evaluates the effect of increasing training sequence lengths from $2^{13}=8192$ to $2^{20}\approx 10^{6}$, while keeping computation fixed. (There are some slight edge cases to the way the data is curated, which may lead to kinks in the scaling curves. For example, only minute-long clips were available so the maximum sequence length is actually bounded by $60s\cdot 16000Hz=960000$.)

**Both Mamba and the SaShiMi (S4+MLP) baseline improve consistently with longer context lengths; Mamba is better throughout, and the gap widens at longer lengths.** The main metric is bits per byte (BPB), which is a constant factor $\log(2)$ of the standard negative log-likelihood (NLL) loss for pretraining other modalities.

We note one important detail: this is the only experiment in this paper in which we switched from the real parameterization to complex ([Section 3.6](#s3-6)). We show additional ablations in [Section E.4](#se-4).

### 4.4.2 Autoregressive Speech Generation {#s4-4-2 .section tag=BJDD}

SC09 is a benchmark speech generation dataset ([Warden, 2018](#bib.bibx109); [Donahue et al., 2019](#bib.bibx25)), consisting of $1$-second clips sampled at 16000 Hz of the digits “zero” through “nine” with highly variable characteristics. We largely follow the autoregressive training setup and generation protocol of [Goel et al. (2022)](#bib.bibx35).

[Figure 11](#fig-10) shows automated metrics of the Mamba-UNet model compared to a variety of baselines from [Goel et al. (2022)](#bib.bibx35): WaveNet ([Oord et al., 2016](#bib.bibx78)), SampleRNN ([Mehri et al., 2017](#bib.bibx72)), WaveGAN ([Donahue et al., 2019](#bib.bibx25)), DiffWave ([Kong et al., 2021](#bib.bibx60)), and SaShiMi. **A small Mamba model outperforms the state-of-the-art (and much larger) GAN- and diffusion- based models.** A larger model parameter-matched to the baselines further improves on fidelity metrics dramatically.

[Figure 11](#fig-10) takes the small Mamba model and investigates combinations of different architectures for the outer stages and center stage. It shows that Mamba is consistently better than S4+MLP in the outer blocks, and Mamba $>$ S4+MLP $>$ MHA+MLP in the center blocks.

**Figure 10** {#fig-10 .figure tag=5LM0}

|  |  |  |  |  |  |  |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Model | Params | NLL $\downarrow$ | FID $\downarrow$ | IS $\uparrow$ | mIS $\uparrow$ | AM $\downarrow$ |
| SampleRNN | 35.0M | 2.042 | 8.96 | 1.71 | 3.02 | 1.76 |
| WaveNet | 4.2M | 1.925 | 5.08 | 2.27 | 5.80 | 1.47 |
| SaShiMi | 5.8M | 1.873 | 1.99 | 5.13 | 42.57 | 0.74 |
| WaveGAN | 19.1M | - | 2.03 | 4.90 | 36.10 | 0.80 |
| DiffWave | 24.1M | - | 1.92 | 5.26 | 51.21 | 0.68 |
| + SaShiMi | 23.0M | - | 1.42 | 5.94 | 69.17 | 0.59 |
| **Mamba** | 6.1M | **1.852** | 0.94 | 6.26 | 88.54 | 0.52 |
| **Mamba** | 24.3M | 1.860 | **0.67** | **7.33** | **144.9** | **0.36** |
| Train | - | - | $0.00$ | $8.56$ | $292.5$ | $0.16$ |
| Test | - | - | $0.02$ | $8.33$ | $257.6$ | $0.19$ |

(**SC09**) Automated metrics for unconditional generation on a challenging dataset of fixed-length speech clips. (*Top to Bottom*) Autoregressive baselines, non-autoregressive baselines, Mamba, and dataset metrics.

**Figure 11** {#fig-11 .figure tag=YJRS}

| Outer | Center | NLL $\downarrow$ | FID $\downarrow$ | IS $\uparrow$ | mIS $\uparrow$ | AM $\downarrow$ |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| S4+MLP | MHA+MLP | 1.859 | 1.45 | 5.06 | 47.03 | 0.70 |
| S4+MLP | S4+MLP | 1.867 | 1.43 | 5.42 | 53.54 | 0.65 |
| S4+MLP | Mamba | 1.859 | 1.42 | 5.71 | 56.51 | 0.64 |
| Mamba | MHA+MLP | **1.850** | 1.37 | 5.63 | 58.23 | 0.62 |
| Mamba | S4+MLP | 1.853 | 1.07 | 6.05 | 73.34 | 0.55 |
| Mamba | Mamba | 1.852 | **0.94** | **6.26** | **88.54** | **0.52** |

(**SC09 Model Ablations**) Models with 6M parameters. In SaShiMi’s U-Net backbone, there are 8 center blocks operating on sequence length $1000$, sandwiched on each side by 8 outer blocks on sequence length $4000$, sandwiched by 8 outer blocks on sequence length $16000$ (40 blocks total). The architecture of the 8 center blocks are ablated independently of the rest. Note that Transformers (MHA+MLP) were not tested in the more important outer blocks because of efficiency constraints.

## 4.5 Speed and Memory Benchmarks {#s4-5 .section tag=ZMPB}

We benchmark the speed of the SSM scan operation (state expansion $N=16$), as well as the end-to-end inference throughput of Mamba, in [Figure 12](#fig-12). Our efficient SSM scan is faster than the best attention implementation that we know of (FlashAttention-2 ([Dao, 2024](#bib.bibx19))) beyond sequence length 2K, and up to 20-40$\times$ faster than a standard scan implementation in PyTorch. Mamba achieves 4-5$\times$ higher inference throughput than a Transformer of similar size, since without the KV cache it can use much higher batch sizes. For example, a Mamba-6.9B (untrained) would have higher inference throughput than a $5\times$ smaller Transformer-1.3B. Details in [Section E.5](#se-5), which additionally includes a benchmark of memory consumption.

**Figure 12** {#fig-12 .figure tag=28OA}

(**Efficiency Benchmarks**.) (*Left*) Training: our efficient scan is $40\times$ faster than a standard implementation. (*Right*) Inference: as a recurrent model, Mamba can achieve $5\times$ higher throughput than Transformers.

**Figure** {#fig-12a .figure tag=88V4}

![](/figures/2312/2312.00752/ssm_scan.svg)

**Figure** {#fig-12b .figure tag=TVZV}

![](/figures/2312/2312.00752/mamba_inference.svg)

## 4.6 Model Ablations {#s4-6 .section tag=Q2ZZ}

We perform a series of detailed ablations on components of our model, focusing on the setting of language modeling with size $\approx 350$M models at Chinchilla token counts (same setting as [Figure 6](#fig-6)).

### 4.6.1 Architecture {#s4-6-1 .section tag=9ZBQ}

[Table 2](#tab-2) investigates the effects of the architecture (block) and its inner SSM layer ([Figure 3](#fig-3)). We find that

- Among previous non-selective (LTI) SSMs, which are equivalent to global convolutions, performance is very similar.
- Replacing the complex-valued S4 variant from previous work with a real-valued one does not affect performance much, suggesting that (at least for LM) real-valued SSMs may be a better choice when accounting for hardware efficiency.
- Replacing any of these with a selective SSM (S6) significantly improves performance, validating the motivation of [Section 3](#s3).
- The Mamba architecture performs similarly to the H3 architecture (and seems slightly better when using a selective layer).

We also investigate interleaving the Mamba block with other blocks such as MLP (a traditional architecture) MHA (a hybrid attention architecture) in [Section E.2.2](#se-2-2).

### 4.6.2 Selective SSM {#s4-6-2 .section tag=R7NB}

[Figure 14](#fig-13) ablates the selective SSM layer by considering different combinations of selective $\Delta$, $\bm{B}$, and $\bm{C}$ parameters ([Algorithm 2](#lst-2)), showing that $\Delta$ is the most important parameter due to its connection to RNN gating ([Theorem 1](#thm-1)).

[Figure 14](#fig-13) considers different initializations of the SSM, which have been shown to make a large difference in some data modalities and settings ([Gu et al., 2022](#bib.bibx37); [Gu et al., 2022a](#bib.bibx39)). On language modeling, we find that simpler real-valued diagonal initializations (S4D-Real, row 3) instead of more standard complex-valued parameterizations (S4D-Lin, row 1) perform better. Random initializations also work well, consistent with findings from prior work ([Mehta et al., 2023](#bib.bibx73)).

[Figure 16](#fig-15) and [Figure 16](#fig-15) consider varying the dimension of the $\Delta$ and $(\bm{B},\bm{C})$ projections respectively. Changing them from static to selective provides the most benefit, while increasing the dimensions further generally improves performance modestly with a small increase in parameter count.

**Table 2** {#tab-2 .table tag=F2N0}

| Model | Arch. | SSM Layer | Perplexity |
| :--- | :--- | :--- | :--- |
| Hyena | H3 | Hyena | $10.24$ |
| H3 | H3 | S4 (complex) | $10.30$ |
| - | H3 | S4 (real) | $10.34$ |
| - | H3 | S6 | $\mathbf{8.95}$ |

(**Ablations: Architecture and SSM layer**.) The Mamba block performs similarly to H3 while being simpler. In the inner layer, there is little difference among different parameterizations of LTI models, while selective SSMs (S6) provide a large improvement. More specifically, the S4 (real) variant is S4D-Real and the S4 (complex) variant is S4D-Lin.

**Figure 13** {#fig-13 .figure tag=7MHM}

|  |  |  |  |
| :--- | :--- | :--- | :--- |
| Selective $\Delta$ | Selective $\bm{B}$ | Selective $\bm{C}$ | Perplexity |
| ✗ | ✗ | ✗ | 10.93 |
| ✗ | ✓ | ✗ | 10.15 |
| ✗ | ✗ | ✓ | 9.98 |
| ✓ | ✗ | ✗ | 9.81 |
| ✓ | ✓ | ✓ | 8.71 |

(**Ablations: Selective parameters**.) $\Delta$ is the most important parameter ([Theorem 1](#thm-1)), but using multiple selective parameters together synergizes.

**Figure 14** {#fig-14 .figure tag=IBLK}

| $\bm{A}_{n}$ Initialization | Field | Perplexity |
| :--- | :--- | :--- |
| $\bm{A}_{n}=-\frac{1}{2}+ni$ | Complex | 9.16 |
| $\bm{A}_{n}=-1/2$ | Real | 8.85 |
| $\bm{A}_{n}=-(n+1)$ | Real | 8.71 |
| $\bm{A}_{n}\sim\exp(\mathcal{N}(0,1))$ | Real | 8.71 |

(**Ablations: Parameterization of $\bm{A}$**.) The more standard initializations based on S4D-Lin ([Gu et al., 2022a](#bib.bibx39)) perform worse than S4D-Real or a random initialization, when the SSM is selective.

**Figure 15** {#fig-15 .figure tag=QSHH}

| Size of $\Delta$ proj. | Params (M) | Perplexity |
| :--- | :--- | :--- |
| - | 358.9 | 9.12 |
| $1$ | 359.1 | 8.97 |
| $2$ | 359.3 | 8.97 |
| $4$ | 359.7 | 8.91 |
| $8$ | 360.5 | 8.83 |
| $16$ | 362.1 | 8.84 |
| $32$ | 365.2 | 8.80 |
| $64$ | 371.5 | 8.71 |

(**Ablations: Expressivity of $\Delta$**.) The selection mechanism of $\Delta$ constructs it with a projection of the input. Projecting it even to dim. $1$ provides a large increase in performance; increasing it further provides further improvements at the cost of a modest increase in parameters. State size fixed to $N=16$.

**Figure 16** {#fig-16 .figure tag=7YMM}

| State dimension $N$ | Params (M) | Perplexity |
| :--- | :--- | :--- |
| $1$ | 367.1 | 9.88 |
| $2$ | 367.4 | 9.86 |
| $4$ | 368.0 | 9.82 |
| $8$ | 369.1 | 9.82 |
| $16$ | 371.5 | 9.81 |
| $1$ | 367.1 | 9.73 |
| $2$ | 367.4 | 9.40 |
| $4$ | 368.0 | 9.09 |
| $8$ | 369.1 | 8.84 |
| $16$ | 371.5 | 8.71 |

(**Ablations: SSM state dimension**.) (*Top*) Constant $\bm{B}$ and $\bm{C}$ (*Bottom*) Selective $\bm{B}$ and $\bm{C}$. Increasing the SSM state dimension $N$, which can be viewed as an expansion factor on the dimension of the recurrent state, can significantly improve performance for a negligible cost in parameters/FLOPs, but only when $\bm{B}$ and $\bm{C}$ are also selective. Size of $\Delta$ projection fixed to $64$.

Of particular note is the dramatic improvement of the selective SSM when the state size $N$ is increased, with over a 1.0 perplexity improvement for a cost of only 1% additional parameters. This validates our core motivation in [Sections 3.1](#s3-1) and [3.3](#s3-3).
