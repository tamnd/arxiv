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
section: 5
section_title: Discussion
kind: section
lang: en
tag: GHCU
local_id: s5
path: render
source_url: https://arxiv.org/html/2312.00752v2
source_sha256: db9c91f06ddc2159326fc945f7ea0c1f72e850263fef977b7c47d2281669c8e0
source_pages: ""
extraction_model: ""
prompt_sha256: ""
objects: 5
equations: 0
figures: []
tables: []
statements: []
code_blocks: 0
content_sha256: 9ae7bbb002b72b9e045074408bd8f0f05d5dd057e4f899a04f44f0b07aa01dd3
edited: false
---

We discuss related work, limitations, and some future directions.

## Related Work. {#su5-1 .section tag=LWDR}

[Appendix A](#sa) discusses how the selection mechanism relates to similar concepts. [Appendix B](#sb) has an extended related work of SSMs and other related models.

## No Free Lunch: Continuous-Discrete Spectrum. {#su5-2 .section tag=EXK2}

Structured SSMs were originally defined as discretizations of continuous systems ([1](#eq-1a)), and have had a strong inductive bias toward continuous-time data modalities such as perceptual signals (e.g. audio, video). As discussed in [Sections 3.1](#s3-1) and [3.5](#s3-5), the selection mechanism overcomes their weaknesses on discrete modalities such as text and DNA; but this conversely can impede their performance on data that LTI SSMs excel on. Our ablations on audio waveforms examine this tradeoff in more detail.

## Downstream Affordances. {#su5-3 .section tag=U3UA}

Transformer-based foundation models (particularly LLMs) have a rich ecosystem of properties and modes of interaction with pretrained models, such as fine-tuning, adaptation, prompting, in-context learning, instruction tuning, RLHF, quantization, and so on. We are particularly interested in whether Transformer alternatives such as SSMs have similar properties and affordances.

## Scaling. {#su5-4 .section tag=0HFC}

Our empirical evaluation is limited to small model sizes, below the threshold of most strong open source LLMs (e.g. Llama ([Touvron et al., 2023](#bib.bibx105))) as well as other recurrent models such as RWKV ([Peng et al., 2023](#bib.bibx82)) and RetNet ([Sun et al., 2023](#bib.bibx100)), which have been evaluated at the 7B parameter scale and beyond. It remains to assess whether Mamba still compares favorably at these larger sizes. We also note that scaling SSMs may involve further engineering challenges and adjustments to the model that are not discussed in this paper.
