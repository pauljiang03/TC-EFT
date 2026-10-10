---
title: Related work and novelty
description: Where the Lean formalization of the Ozaki schemes sits in the literature on GEMM emulation, correctly rounded and reproducible linear algebra, matrix-engine numerics and formal verification, and which of its results are new.
---

This page places the [Ozaki formalization](/TC-EFT/ozaki/) in the literature.
It is based on a review done in October 2026. For each source it notes how
closely it was read: **full** text, **abstract** only, or a **snippet** or
secondary source. Sources not read in full may contain more than is
credited here.

## The literature

### The Ozaki scheme family and GEMM emulation

- **Ozaki, Ogita, Rump and Oishi, NOLTA 2007** (full),
  [*Accurate matrix multiplication with multiple floating-point numbers*](https://www.tuhh.de/ti3/paper/rump/OzOgRuOi07.pdf).
  Faithfully rounded matrix products from error-free transformations; the
  method works adaptively, generating terms until faithful rounding is
  guaranteed.
- **Ozaki, Ogita, Rump and Oishi, NOLTA 2008** (full),
  [*Accurate matrix multiplication by using level 3 BLAS operation*](https://www.tuhh.de/ti3/paper/rump/OzOgRuOi08.pdf).
  The first splitting of matrices so that products of slices are exact in any
  summation order.
- **Ozaki, Ogita, Oishi and Rump, Numerical Algorithms 59 (2012)** (abstract),
  [*Error-free transformations of matrix multiplication by using fast routines of matrix multiplication and its applications*](https://doi.org/10.1007/s11075-011-9478-1).
  The canonical Ozaki scheme (Ozaki-I).
- **Ozaki, Ogita and Oishi, NLAA 2011 and 2016** (title; abstract): tight
  enclosures of matrix products with optimized BLAS, and a posteriori
  validation that detects overflow.
- **Ozaki, SWIM 2018** (full, [slides](https://www.com.uni-rostock.de/storages/uni-rostock/Alle_MSF/COM/Bilder/SWIM/Presentations/ozaki.pdf)),
  and **Lange and Rump** (full, [preprint](https://www.tuhh.de/ti3/paper/rump/MatrixResidualsFinal.pdf)):
  midpoint-radius enclosures of a truncated Ozaki product, and remarks that an
  accurate summation of the slices gives correct rounding.
- **Mukunoki, Ozaki, Ogita and Imamura, ISC 2020** (full, formulas not rendered),
  [*DGEMM using Tensor Cores, and its accurate and reproducible versions*](https://pmc.ncbi.nlm.nih.gov/articles/PMC7295351/).
  FP16 Tensor Core GEMM by Ozaki-I, with a correctly rounded mode that splits
  until every split matrix is zero and sums with a correctly rounded summation,
  about four times slower than its FP64-accuracy mode. It has no rounding test
  and no early exit. **OzBLAS** (abstracts:
  [SC18 workshop](https://sc18.supercomputing.org/proceedings/workshops/workshop_pages/ws_cre104.html),
  [project](https://www.r-ccs.riken.jp/labs/lpnctrt/projects/ozblas)) offers
  reproducible BLAS with tunable accuracy, and an HPC Asia 2021 paper
  (abstract) gives correctly rounded, bitwise reproducible inner products across
  CPU and GPU.
- **Integer engines** (abstracts): Ootomo, Ozaki and Yokota, IJHPCA 2024
  ([ozIMMU](https://arxiv.org/abs/2306.11975)); Uchino, Ozaki and Imamura,
  IJHPCA 2025 ([arXiv:2409.13313](https://arxiv.org/abs/2409.13313)).
- **Ozaki-II** (keyword search of the full text), Ozaki, Uchino and Imamura,
  [arXiv:2504.08009](https://arxiv.org/abs/2504.08009): CRT reconstruction,
  with a rounding-error analysis left to future work. Follow-ups:
  an [error analysis](https://arxiv.org/abs/2602.02549) (full, machine
  extraction) assuming exact INT8 products,
  [FP8 Ozaki-II](https://arxiv.org/abs/2603.10634),
  [complex CRT](https://arxiv.org/abs/2512.08321) and
  [improved scaling](https://arxiv.org/abs/2606.29129) (abstracts), and the
  [GEMMul8](https://github.com/UCHINO-Yuki/GEMMul8) library (README) with CUDA
  and HIP back ends and bitwise-reproducible results.
- **Abdelfattah, Dongarra, Fasi, Mikaitis and Tisseur** (full, machine
  extraction), [arXiv:2506.11277](https://arxiv.org/abs/2506.11277): error
  analysis of Ozaki-I on integer units, a slice-count estimator, and a note that
  −0, Inf and NaN are not handled.
- **ADP and ESC**, Schwarz et al. (full, machine extraction),
  [arXiv:2511.13778](https://arxiv.org/abs/2511.13778): FP64 emulation on INT8
  with an exponent-span estimate and a native fallback. Grade A (a
  componentwise bound linear in `k`) is established by experiment, and the
  coarsening is argued by a short sketch that does not treat zeros. It ships in
  cuBLAS ([NVIDIA blog](https://developer.nvidia.com/blog/unlocking-tensor-core-performance-with-floating-point-emulation-in-cublas/)),
  and CUDA 13.4 adds Ozaki-II.
- **Further emulation work, 2025–26** (abstracts):
  [FP8 Tensor Cores](https://arxiv.org/abs/2508.00441),
  [FP4 limbs](https://arxiv.org/abs/2608.06812),
  [BF16 on Intel AMX](https://arxiv.org/abs/2609.04663),
  [EmuGEMM](https://arxiv.org/abs/2606.25453),
  [*FP8 is all you need*](https://arxiv.org/abs/2606.06510) and
  [*Ozaki 2.5*](https://arxiv.org/abs/2609.09095).
- **Multiword Tensor Core methods**: Markidis et al. 2018
  ([arXiv:1803.04014](https://arxiv.org/abs/1803.04014), abstract), Henry, Tang
  and Heinecke 2019 (snippet), Ootomo and Yokota 2022
  ([arXiv:2203.03341](https://arxiv.org/abs/2203.03341), abstract), which
  traces Markidis's accuracy loss to round-toward-zero accumulation inside the
  Tensor Core.

### Correctly rounded, faithful and reproducible linear algebra

- **Rump, Ogita and Oishi**, SISC 2005 and 2008 (bibliographic): accurate dot
  products, faithful summation (AccSum) with an adaptive stopping criterion, and
  round-to-nearest summation
  ([Part II](https://www.tuhh.de/ti3/paper/rump/RuOgOi07II.pdf)).
- **ExBLAS**, Iakymchuk, Defour, Collange and Graillat (snippet,
  [paper](https://www-pequan.lip6.fr/~graillat/papers/IDCG16.pdf)): GPU GEMM
  with floating-point expansions and a long accumulator, described as correctly
  rounded. **ReproBLAS**, Demmel, Nguyen and Ahrens (snippet): reproducible but
  not correctly rounded. **Kulisch's** long accumulator (snippet).
- **Boldo and Melquiond, IEEE TC 2008** (abstract,
  [HAL](https://hal-ens-lyon.archives-ouvertes.fr/inria-00080427)): correctly
  rounded sums by rounding to odd, proved in Coq.
- **Ziv's rounding test** (Ziv 1991, metadata; de Dinechin, Lauter, Muller and
  Torres 2013, [abstract](https://hal-ens-lyon.archives-ouvertes.fr/ensl-00693317))
  and CORE-MATH (snippet).
- **Cross-vendor reproducibility, 2026** (abstracts):
  [bitwise-equivalence checking across NVIDIA and AMD](https://arxiv.org/abs/2609.11356),
  and [NVIDIA versus AMD logit mismatches](https://arxiv.org/abs/2610.05458).

### Matrix-engine numerics and models

- **Fasi, Higham, Mikaitis and Pranesh**, PeerJ CS 2021 (snippet,
  [paper](https://peerj.com/articles/cs-330)): truncation, unnormalized
  accumulation and the first observation of non-monotonicity. **Blanchard et
  al.**, SISC 2020 (snippet): block-FMA error analysis. **Mikaitis**, IEEE TC 2024
  ([arXiv:2304.01407](https://arxiv.org/abs/2304.01407), snippet): monotonicity
  of multi-term adders.
- **Feature-targeted testing**, Li et al., CCGrid 2024
  ([arXiv:2403.00232](https://arxiv.org/abs/2403.00232), abstract).
- **Valpey, Li, Pai and Gopalakrishnan**, NFM 2025 (full, machine extraction,
  [arXiv:2502.15999](https://arxiv.org/abs/2502.15999)): an SMT model of
  Volta, Turing and Ampere Tensor Cores, and an SMT analysis of the Markidis and
  Ootomo–Yokota correction algorithms; the closest formal work on emulation.
- **Bit-accurate models**: Khattak and Mikaitis for NVIDIA
  ([arXiv:2512.07004](https://arxiv.org/abs/2512.07004)) and Khattak,
  Mikaitis and Graziani for AMD CDNA 1–3
  ([arXiv:2609.14845](https://arxiv.org/abs/2609.14845)), which this
  repository's models follow and which compare multiword emulation across
  vendors by simulation; MMA-Sim for ten architectures
  ([arXiv:2511.10909](https://arxiv.org/abs/2511.10909), abstract).
- **FP8 accumulation**: the DeepSeek-V3 report
  ([arXiv:2412.19437](https://arxiv.org/abs/2412.19437), snippet) observes
  that FP8 accumulation on H800 keeps about 14 bits.
- **Non-monotonicity**: Jiang and Zheng, SC25 poster,
  [*A formal characterization of non-monotonicity in Tensor Cores*](https://sc25.supercomputing.org/proceedings/posters/poster_pages/post148.html)
  (abstract).

### Formal verification of floating point

- **Coq**: Flocq, which proves monotonicity of rounding to nearest from the
  nearest-value property alone (`Rnd_N_pt_monotone`); Gappa; proofs of
  error-free transformations (Boldo, Graillat and Muller, TOMS 2017); and
  double-word arithmetic (Muller and Rideau, TOMS 2022), which found errors in
  published proofs (snippets).
- **Verified linear algebra**: VCFloat2 and
  [LAProof](https://www.cs.princeton.edu/~appel/papers/LAProof.pdf)
  (snippets), machine-checked accuracy bounds for dot and matrix products.
- **Hardware**: HOL Light at Intel and ACL2 (Russinoff), including an ACL2
  proof of the Chinese remainder theorem (snippets).
- **Lean**: FloatLib ([arXiv:2609.19352](https://arxiv.org/abs/2609.19352),
  abstract); FLoPS for P3109 formats
  ([arXiv:2602.15965](https://arxiv.org/abs/2602.15965), abstract), which
  studies ExtractScalar, the σ-split; round-to-odd ExtractScalar
  ([arXiv:2601.17198](https://arxiv.org/abs/2601.17198), abstract).
- **The Ozaki schemes, CRT emulation and ADP**: no machine-checked treatment
  was found beyond SMT models, despite searches combining Coq, Lean, Isabelle,
  SMT and "machine-checked" with Ozaki, CRT, ADP and GEMM emulation.

## What is new here

| Contribution | Verdict | Closest prior work | The difference |
| --- | --- | --- | --- |
| Machine-checked Ozaki-I, Ozaki-II and ADP/ESC for every input | New | SMT models; Valpey et al.; pen-and-paper analyses | All-input proofs in an interactive prover with only standard axioms |
| Engine exactness derived from validated bit-level NVIDIA and AMD models | New as a proof | The exactness condition on paper; the hardware models, which do not treat Ozaki | The schemes' "exact engine" assumption is proved from hardware semantics |
| The `2^24` budget comes from the binary32 output | Known rule | Ozaki's slice-width formula; Mukunoki et al. 2020 | Proved per path; new only relative to an engine that rounds every partial sum |
| Full A100 and H100 groups of `11`-bit products exceed it; bf16 needs `8`-bit slices | Mostly known | The same slice-width formula | Concrete, proved witnesses |
| NVIDIA and AMD give different wrong answers past the budget | Partly new | Cross-vendor studies by testing and simulation | Proved, Ozaki-specific witnesses |
| σ-split remainder exact for every binary32 value and grid; slicing on integer significands for every grid | Modest | ExtractScalar analyses; FLoPS | Machine-checked binary32 statements with explicit ranges |
| Ozaki-I error identity and bounds; Ozaki-II truncation bound; native `γₖ` | New as machine-checked results | Ozaki 2012; Abdelfattah et al. 2025; Uchino et al. 2026 (sharper) | Coarser than the best paper bounds, but proved |
| ADP: coarsening for every block size, Grade A for the whole routine, a subnormal counterexample, a guarded fix | New | Schwarz et al. (experiments, sketch) | First proof of a linear componentwise bound for the routine, and a failure the experiments did not exercise |
| Correctly rounded variants: enclosure check, refinement, exact path on the engine, two-word accumulator, signed zeros | Partly new | Mukunoki et al. 2020 (full split); Ozaki et al. 2007 (adaptive faithful); Ziv's test; SWIM 2018 and Lange–Rump enclosures | An early-exit certificate on truncated Ozaki-I, its extension to Ozaki-II and ADP, and a machine-checked proof on hardware models |
| Identical results on the NVIDIA and AMD models | Partly new | GEMMul8; HPC Asia 2021 (CPU and GPU); ExBLAS | A proved statement over two vendors' matrix-engine models |
| Two passes through `C` recover a full group exactly | New, as far as found | TC-EFT's analysis of alignment | A Tensor-Core-only exact recovery, proved on the model |

### What this work does not claim

- The first correctly rounded or reproducible Ozaki or GEMM, adaptivity as
  such, or the monotonicity of rounding to nearest.
- The budget, slice-width or bf16 rules as discoveries.
- Any performance: there is no GPU implementation yet.
- That real GPUs match the models: the models are validated by measurement,
  not proved.
- That cuBLAS's ADP equals the formalized routine, which follows the paper.

## Open questions

- **Unread primary sources.** The 2012 Numerical Algorithms paper and the 2011
  enclosure paper could contain an enclosure-to-rounding remark; the novelty of
  the early-exit certificate rests on them.
- **Scale.** The cost claims come from small test matrices; realistic sizes,
  ill-conditioned inputs and the frequency of the exact path need measuring.
- **Hardware coverage.** FP8 and FP4 engines, an INT8 instruction model, and
  Blackwell are not modeled.
