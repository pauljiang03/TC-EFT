# Specification

## Sources

| Source | Pin | Path |
| --- | --- | --- |
| Khattak and Mikaitis, *Accurate Models of NVIDIA Tensor Cores* | arXiv:2512.07004v4, 11 June 2026 | `../2512.07004v4.pdf` |
| *TC-EFT: Characterizing and Correcting Tensor Core Arithmetic* | revised 15-page artifact | `../tc-eft-corrected.pdf` |
| MATLAB Tensor Core | v0.5, commit `bbcf00a273868172494eaacaa8d6128ab0fb8704` | `vendor/matlab-tensor-core-v0.5/` |

```text
20c0594f2f91b8df7618e6d6bd00a04ee0b7bf557a5ce19d08927241f78fdee4  2512.07004v4.pdf
e9b19e9766974d64dad081ea1107bb6d54c6aff8a1fd0620ce9fb13dbd497b3e  tc-eft-corrected.pdf
```

Accurate Models v4 is the numerical authority. The v0.5 source resolves subnormal decoding
and the composition rule of its GEMM driver. TC-EFT supplies the arithmetic contracts.
`vendor/SOURCES.json` hashes the vendored subset, including the V100 device vectors and
their readers. MATLAB was read, not executed; nothing here claims equivalence with the full
MATLAB GEMM implementation.

## V100 FP16 → FP32

| Decision | Definition and evidence |
| --- | --- |
| Group | Four FP16 products and one FP32 c (Accurate Models §4.1.1, Fig. 2). A normalization group, not a tile. |
| Inputs | `BitVec 16` and `BitVec 32`. Normal, subnormal, and both zero signs are classified; infinity and NaN are rejected. |
| Multiplication | Signed integer significand product, scale sum, fractional-width sum. Raw metadata is never normalized. |
| Subnormals | Explicit fraction with scale `emin = 1 − bias`. `Generic_BFMA_TC.m` lines 101–105 clamp operand scales before forming significands; `AlignSignficand` pins subnormal c to −126. |
| Alignment exponent | Maximum raw scale over nonzero terms, including c; zero terms are ignored. `F = 23`. |
| Floor | None relevant for V100; the source's −1024 sentinel is below every finite FP16 product scale. |
| All-zero group | `alignmentScale = none`. A dummy grid is used only for exact zero arithmetic; no logarithm of zero is taken. |
| Truncation | Sign times floor of the magnitude divided by the quantum. |
| Accumulation | Exact signed `Int` coefficients on one grid. No wrap, no intermediate normalization. |
| Output | Normalize and truncate toward zero to FP32 with minimum quantum 2^-149. |
| Range | `abs(Aacc) > maxFinite32` is rejected. No saturation or overflow rule is asserted. |
| Zero | Exact cancellation and all-zero groups give +0. A negative nonzero value that truncates to zero keeps its sign. No device signed-zero claim. |
| Correction | Per-term alignment residuals and the output residual are exact rationals. |
| Final rounding | Quotient, remainder, and parity conversion; `abs(S) > maxFinite32` is rejected. Nearest-value selection and even ties are proved for every rational in range. |
| Invocation boundary | The actual output encoding is decoded before it becomes the next c. |

Trace conventions: c is term zero, followed by the products. `rawScales` lists products
only; a zero product shows scale 0 and never selects the alignment exponent. The ideal sum
multiplies decoded operand values directly and does not call the raw-product, alignment,
output, or correction code.

## Profile

`Profile` fixes the input format, product count `K`, fractional alignment precision `F`, and
an optional floor. `evalBlock` and `runBlocks` are generic over it; `evalV100` and `runV100`
abbreviate the only instantiated profile. c and the output are FP32, c joins the common
alignment, and the output is one truncation. Parameterization does not validate another
architecture; the target feature universe is in [FEATURE_COVERAGE.md](FEATURE_COVERAGE.md).

## Conversion

`round32` is the public converter and keeps the range guard. `round32Core` factors out the
bounded encoding for the proofs; its behavior outside the public domain is not an overflow
specification. Corrected block and schedule theorems require the final exact sum to be in
range as a separate premise from successful intermediate calls.

## Other paths, recorded and not instantiated

| Path | K | F | Notes |
| --- | ---: | ---: | --- |
| V100 FP16 → FP16 | 4 | 23 | Final FP16 RNE; stage order to be settled (FEATURE_COVERAGE.md) |
| A100/Ada FP16/BF16 → FP32 | 8 | 24 | Floor −132 for tiny BF16 products |
| A100/Ada TF32 → FP32 | 4 | 24 | Floor −132 |
| Hopper/Blackwell FP16/BF16 → FP32 | 16 | 25 | Floor −133 |
| Hopper/Blackwell TF32, mma.sync m16n8k8 → FP32 | 8 | 25 | Floor −133; WMMA path uses K = 4 |

Rows follow Accurate Models §4.1.2, §4.1.6, and Tables 3–4. FP8 paths, late-c paths, FP16
outputs, and Turing are not implemented. Turing is not characterized by the controlling
paper and needs another source.

## Lean and libraries

Lean 4.33.1, commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`, with no packages:
`Init.Data.Rat` for exact arithmetic, `grind` and `omega` for algebraic and integer goals,
and `decide +kernel` for concrete cases. `Init.Data.Float.Model` exists but native `Float`
is not a tensor-core model and is not used. Mathlib and solvers are not required; a
dependency should be added only for a concrete proof obligation, with a resolved revision.
