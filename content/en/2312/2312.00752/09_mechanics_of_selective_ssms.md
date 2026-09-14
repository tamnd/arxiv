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
section: 9
section_title: Mechanics of Selective SSMs
kind: appendix
lang: en
tag: YVGA
local_id: sc
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 12
equations: 10
figures: []
tables: []
statements: []
code_blocks: 0
content_sha256: 2f8e6315236c7191f89f9d01a9aa593f4d8d5dc528092de7a43a340d1451f719
edited: false
---

**Proof of [Theorem 1](#thm-1)** {#proof-u1 .proof tag=O3RU}

Consider a selective SSM ([Algorithm 2](#lst-2)) with $N=1,\bm{A}=-1,\bm{B}=1,s_{\Delta}=\mathsf{Linear}(x),\tau_{\Delta}=\mathsf{softplus}$. The corresponding continuous-time SSM ([1](#eq-1a)) is

$$
h(t)=-h(t)+x(t)
$$

which is also called a *leaky integrator*.

The discretization step size is

$$
\Delta_{t} =\tau_{\Delta}(\mathsf{Parameter}+s_{\Delta}(x_{t}))
$$

$$
=\mathsf{softplus}(\mathsf{Parameter}+\mathsf{Linear}(x_{t}))
$$

$$
=\mathsf{softplus}(\mathsf{Linear}(x_{t}))
$$

where we observe that the parameter can be viewed as a learnable bias and folded into the linear projection.

Now applying the zero-order hold (ZOH) discretization formulas:

$$
\overline{\bm{A}}_{t} =\exp(\Delta\bm{A})=\frac{1}{1+\exp(\mathsf{Linear}(x_{t}))}=\sigma(-\mathsf{Linear}(x_{t}))
$$

$$
=1-\sigma(\mathsf{Linear}(x_{t}))
$$

$$
\overline{\bm{B}}_{t} =(\Delta\bm{A})^{-1}(\exp(\Delta\bm{A})-\bm{I})\cdot\Delta\bm{B}=-(\exp(\Delta\bm{A})-\bm{I})=1-\overline{\bm{A}}
$$

$$
=\sigma(\mathsf{Linear}(x_{t})).
$$

Thus the final discrete recurrence ([2a](#eq-2a)) is

$$
g_{t} =\sigma(\mathsf{Linear}(x_{t}))
$$

$$
h_{t} =(1-g_{t})h_{t-1}+g_{t}x_{t}
$$

as desired. ∎
