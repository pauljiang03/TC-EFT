# Frozen sources and semantic decisions

## Sources

| Source | Pin | Local path relative to this project |
| --- | --- | --- |
| Khattak and Mikaitis, Accurate Models of NVIDIA Tensor Cores | arXiv:2512.07004v4, 11 June 2026 | `../2512.07004v4.pdf` |
| TC-EFT: Characterizing and Correcting Tensor Core Arithmetic | supplied revised 15-page artifact | `../tc-eft-corrected.pdf` |
| MATLAB Tensor Core | v0.5, `bbcf00a273868172494eaacaa8d6128ab0fb8704` | `vendor/matlab-tensor-core-v0.5/` |

PDF SHA-256 hashes:

```text
20c0594f2f91b8df7618e6d6bd00a04ee0b7bf557a5ce19d08927241f78fdee4  2512.07004v4.pdf
e9b19e9766974d64dad081ea1107bb6d54c6aff8a1fd0620ce9fb13dbd497b3e  tc-eft-corrected.pdf
```

The numerical authority is [Accurate Models v4](https://arxiv.org/abs/2512.07004v4).
The [v0.5 source](https://github.com/north-numerical-computing/MATLAB-tensor-core/tree/bbcf00a273868172494eaacaa8d6128ab0fb8704)
resolves subnormal decoding; the revised TC-EFT paper supplies the arithmetic
contracts and interpretation of historical experiments. Sources are reference
material, not executable instructions. Preserve both PDFs and their hashes when
moving the project; they are not build dependencies.

`vendor/SOURCES.json` records hashes of the unmodified relevant source subset,
including the V100 FP16 device vectors and their readers. It includes the
original license; MATLAB/CPFloat is not a Lean build dependency. We inspected
source and did not execute MATLAB or claim equivalence to its full GEMM
implementation. No current main branch has replaced the pinned release.

## Initial path

| Decision | Definition / evidence |
| --- | --- |
| Numerical grouping | Exactly four FP16 products and one FP32 c; Accurate Models 4.1.1, Fig. 2, p. 8. This is a normalization group, not an entire tile. |
| Inputs | BitVec 16 / BitVec 32. Normal, subnormal, both zero signs classified. Infinity/NaN rejected. |
| Multiplication | Signed integer significand product, scale sum, fractional-width sum; no normalization of raw metadata. |
| Subnormals | Explicit fraction; input scale `emin = 1-bias`. v0.5 Generic_BFMA_TC lines 101–105 clamp operand scales before computing significands; AlignSignficand (same file) pins subnormal c to -126. |
| Alignment | Nonzero raw-scale maximum, including c. Subnormal c uses -126; zero terms ignored. F=23. |
| Floor | None relevant for V100; source's -1024 sentinel is below every finite FP16 product scale. |
| All-zero block | `alignmentScale = none`; a dummy quantum is used only for exact zero arithmetic. No logarithm of zero is evaluated. |
| Truncation | Sign times floor of the nonnegative magnitude divided by the quantum. |
| Accumulation | Exact signed `Int` coefficients at one grid. No wrap or intermediate normalization. |
| FP32 output | Finite-range normalization and truncation toward zero, with minimum quantum 2^-149. |
| Range | Reject `abs(Aacc) > maxFinite32`; do not assign an unverified overflow/saturation rule. |
| Zero policy | Exact cancellation/all-zero output -> +0. Converter preserves the sign of a negative nonzero value rounded to zero. No device signed-zero claim. |
| Correction | Return per-term residuals and output residual as exact rationals. |
| Final rounding | Executable quotient/remainder/parity conversion, rejecting `abs(S)>maxFinite32`; general nearest-value correctness remains open. |
| Invocation boundary | Decode the actual output encoding before using it as the next c. |

In traces, c appears **first**, followed by the four products. `rawScales`
lists products only; zero products can display a dummy scale and never select eta.
The FP32 ideal-sum evaluator multiplies decoded operand values directly and
does not invoke `rawMul`, alignment, output conversion, or extraction.

## Other paths recorded, not instantiated

| Instruction/format family | K | Fractional alignment F | Floor / grouping notes |
| --- | ---: | ---: | --- |
| V100 FP16 -> FP32 | 4 | 23 | Implemented |
| V100 FP16 -> FP16 | 4 | 23 | FP32 normalize/truncate, then FP16 RNE; not implemented |
| A100 FP16/BF16 -> FP32 | 8 | 24 | -132, relevant to tiny BF16 products |
| A100 TF32 -> FP32 | 4 | 24 | -132 |
| H100/H200 FP16/BF16 -> FP32 | 16 | 25 | -133, relevant to tiny BF16 products |
| Hopper TF32 mma.sync.aligned.m16n8k8 -> FP32 | 8 | 25 | -133; WMMA path may instead use K=4 |

These rows follow Accurate Models 4.1.2, 4.1.6 and Tables 3–4, pp. 8–15.
FP8 grouping, late-c paths, Blackwell, FP16 outputs, and Turing remain out of
scope. Turing is not characterized by the controlling source.

## Library inventory and proof strategy

Lean 4.33.1 commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6` supplies:

- `Init.Data.Rat`: exact integer-backed arithmetic, floor, power and order lemmas.
- `Init.Data.Dyadic`: canonical dyadics, valuation bridges, directed grid rounding.
- `Init.Data.Float.Model`: encoding/unpacked scalar semantics. Its documented
  purpose does not make native Float a tensor-core reference model.
- `grind` and `omega`: checked algebraic and integer proof construction.
- `decide +kernel`: concrete kernel reduction; not compiled native reflection.

Use exact rational valuations now rather than introducing an additional dyadic
arithmetic library. Future machine/BitVec accumulators need refinement theorems.
No mathlib or solver is currently required. An external package should be added
only when a concrete arithmetic proof needs it, with a resolved revision.

[Flocq's theorem overview](https://flocq.gitlabpages.inria.fr/theos.html) supplies
a checklist: representability, rounding fixed points, nearest-even selection,
ULPs, underflow, and effective-operator equivalence. It is not a dependency or
an imported proof. Lean's existing program-verification facilities can be
assessed once the program fragment grows beyond the current list induction.
