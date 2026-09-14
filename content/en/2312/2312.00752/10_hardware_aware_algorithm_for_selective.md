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
section: 10
section_title: Hardware-aware Algorithm For Selective SSMs
kind: appendix
lang: en
tag: MRBX
local_id: sd
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 3
equations: 0
figures: []
tables: []
statements: []
code_blocks: 0
content_sha256: 3d7a398936a4db00341ac2129367cf01714d912c14a55a6e01d42917d14bc00a
edited: false
---

Without input-dependent selectivity, SSMs can be efficiently implemented as a convolution ([Gu et al., 2022](#bib.bibx37); [Dao et al., 2023](#bib.bibx21)), which leverages the fast Fourier transform (FFT) as primitive. With selectivity, SSMs are no-longer equivalent to convolution, but we leverage the parallel associative scan. While SSM scans are theoretically efficient ($O(BLDN)$ FLOPs, scaling linear in $L$), training foundation models with selective SSMs requires them to be efficient on modern hardware (GPUs) as well. We describe how we use *kernel fusion* and *recomputation* to make SSM scan fast and memory-efficient. We evaluate the speed of our scan implementation compared to convolution and attention in [Section 4.5](#s4-5), showing that it is up to 7$\times$ times faster than attention at sequence length 32K, and is as memory-efficient as the best attention implementation (FlashAttention).

## Speed. {#su10-1 .section tag=RUEY}

On modern hardware accelerators (GPUs) most operations (except matrix multiply) are bounded by memory-bandwidth ([Williams et al., 2009](#bib.bibx110); [Ivanov et al., 2021](#bib.bibx55); [Dao et al., 2022](#bib.bibx20)). This the case with our scan operation, and we use kernel fusion to reduce the amount of memory IOs, leading to significant speedup compared to a standard implementation.

The standard way to implement the scan algorithm in [Section 3.2](#s3-2) is to prepare the scan input $\overline{\bm{A}},\overline{\bm{B}}$ of size $(B,L,D,N)$ in GPU HBM (high-bandwidth memory, commonly referred to as GPU memory), call a parallel associative scan implementation to write the scan output of size $(B,L,D,N)$ to GPU HBM, then multiply that scan output with $\bm{C}$ to produce an output of size $(B,L,D)$. However, this requires the number of memory reads/writes on the order of $O(BLDN)$. We can instead fuse the discretization step, the scan, and the multiplication with $\bm{C}$ into one kernel:

1. We read in $O(BLD+DN)$ bytes of memory ($\Delta,\bm{A},\bm{B},\bm{C}$) from slow HBM to fast SRAM.
2. We discretize to produce $\overline{\bm{A}},\overline{\bm{B}}$ of size $(B,L,D,N)$ in SRAM.
3. We perform a parallel associative scan, yielding intermediate states of size $(B,L,D,N)$ in SRAM.
4. We multiply and sum with $\bm{C}$, producing outputs of size $(B,L,D)$ and write it to HBM.

This way, we reduce IOs by a factor of $O(N)$ (the state dimension), which in practice speeds up the operation by 20-40 times ([Section 4.5](#s4-5)).

For sequence length $L$ too long where we cannot fit the sequence in SRAM (which is much smaller than HBM), we split the sequences into chunks and perform the fused scan on each chunk. As long as we have the intermediate scan states, we can continue the scan with the next chunk.

## Memory. {#su10-2 .section tag=2XDU}

We describe how we use the classical technique of *recomputation* to reduce the total amount of memory required to train selective SSM layers.

From the way we fuse the forward pass, we do not save the intermediate states of size $(B,L,D,N)$ to avoid memory blowup. However, these intermediate states are necessary for the backward pass to compute gradients. We instead recompute those intermediate states in the backward pass. Since the inputs $\Delta,\bm{A},\bm{B},\bm{C}$ and output gradient read from HBM to SRAM are of size $O(BLN+DN)$, and the input gradients are also of size $O(BLN+DN)$, recomputation avoids the cost of reading $O(BLND)$ elements from HBM. This means that recomputation of the SSM states in the backward pass speeds up the computation compared to storing them and reading them from HBM.

Beyond optimizing for the memory requirement of just the scan operation, we also use recomputation to optimize the memory requirement of the entire selective SSM block (input projection, convolution, activation, scan, output projection). In particular, we do not save intermediate activations that take a lot of memory but are fast to recompute (e.g. output of activation function or short convolution). As a result, the selective SSM layer has the same memory requirement as an optimized Transformer implementation with FlashAttention. In particular, each attention layer (FlashAttention) stores around 12 bytes of activations per token, an each MLP layer stores around 20 bytes of activations per token, for a total of 32 bytes ((assuming mixed-precision training in FP16 or BF16)). Each selective SSM stores around 16 bytes of activations per token. Hence two layers of selective SSMs have around the same activation memory as an attention layer and an MLP layer.
