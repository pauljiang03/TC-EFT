# Tensor-core theory reference

The main [README](../README.md) explains the two implementations and validation commands.
The [guide](README.md), [theorem index](../TensorCore/THEOREMS.md), and [test walkthrough](../tests/README.md) provide the reading path.

## Executable interfaces

```sh
./tc doctor --json
./tc build
./tc audit
./tc check
./tc trace 3e00 3d00 3e00 3d00 3e00 3d00 3e00 3d00 3f7fffff
./tc eft data/examples/eft.txt
```

`tc_trace` accepts eight FP16 hexadecimal words and one FP32 accumulator word, without `0x` prefixes. `--file FILE` reads one block per line; `--round-file FILE` reads rational numerator/denominator pairs.

`tc_features --file FILE` reads commands such as `canonical K EXTRA FLOOR a0 b0 ... c`, `bf16 K EXTRA FLOOR ...`, `tf32 K EXTRA FLOOR ...`, `block PROFILE ...`, `decode FORMAT WORD`, and `round FORMAT NUM DEN`. Words are unsigned decimal encodings. Feature TF32 inputs are 32-bit register words with thirteen zero low bits.

`tc_eft_paper FILE` reads `block FORMAT K EXTRA FLOOR a0 b0 ... c D`, `round NUM DEN`, and `family p K j`. FORMAT is `fp16`, `bf16`, or packed 19-bit `tf32`; FLOOR is an integer or `none`.

`tc_bounded_eft FILE` reads `block PROFILE a0 b0 ... c D` or `round SIGNED_COEFFICIENT`. Profiles are `v100-fp16`, `a100-fp16`, `h100-fp16`, `a100-bf16`, `h100-bf16`, `a100-tf32`, `h100-tf32-wmma`, and `h100-tf32-mma`. The integer rounding command uses the bounded backend's `2^-272` grid.

`tc_lean_eft_check` reads JSON Lines on stdin. `{"acc":0,"terms":[1065353216]}` compares the bounded scalar fold with native Lean FP32 addition. A block request has `profile`, operand arrays `a` and `b`, and encoded `c` and `D`. It compares both complete bounded EFT execution paths.

## Proof contracts

| Claim | Scope and preconditions | Main declarations |
| --- | --- | --- |
| C01. Finite rounding | Every well-formed IEEE-style binary format, all four modes, rational inputs within maximum finite magnitude. Out-of-range inputs are rejected even when a directed finite result could exist. | [`TensorCore.roundBinary_correct`](../TensorCore/Numerics/Binary/RoundingContract.lean), [`TensorCore.roundBinary_isSome_iff`](../TensorCore/Numerics/Binary/RoundingContract.lean) |
| C02. Encoding and signed zero | Bijection between finite encoded words and a representable rational value paired with a sign bit. Nonzero signs agree with the value; zero has two representations. Arithmetic exact zero remains +0. | [`TensorCore.signedFiniteBinaryBijection`](../TensorCore/Numerics/Binary/SignedBijection.lean), [`TensorCore.roundBinary_zero`](../TensorCore/Numerics/Binary/RoundingContract.lean) |
| C03. FP64 fused arithmetic | One exact product plus accumulator, one final rounding in each direction; finite decoded inputs and an in-range exact fused result give success. No intermediate product range restriction. | [`TensorCore.binary64Fma_correct`](../TensorCore/TC/FusedRounding.lean), [`TensorCore.binary64Fma_success`](../TensorCore/TC/FusedRounding.lean) |
| C04. Tensor-core arithmetic | The selected FP16/BF16/TF32 profiles model raw subnormal scales, alignment, floors, signed truncation, and final conversion. Fixed-width refinement has explicit width/carry assumptions. | [`TensorCore.profile_contract`](../TensorCore/TC/CanonicalFormats.lean), [`TensorCore.PaperSpec.supported_eq_paper`](../TensorCore/TC/Specification/Supported.lean) |
| C05. Error, recovery, and order | Local error includes final conversion; exact residual recovery composes across encoded accumulators. Nonmonotonicity is proved for the specified realizable input family. Accepted traces and the stated range/profile premises remain explicit. | [`TensorCore.evalBlock_error_bound`](../TensorCore/TC/ErrorBounds.lean), [`TensorCore.runBlocks_residual_ledger`](../TensorCore/TC/Composition.lean), [`TensorCore.nonmonotone_range_encoded`](../TensorCore/TC/MonotonicityRange.lean) |
| C06. Bounded EFT | All eight paths, shape-correct finite inputs and any finite supplied output D. A fixed 576-bit workspace computes the correctly rounded FP32 ideal when that ideal is in range; refinement preserves result bits. | [`TensorCore.EFMachine.algorithm1_success`](../TensorCore/Kernels/EFT/Correctness.lean), [`TensorCore.EFMachine.algorithm1_range_iff`](../TensorCore/Kernels/EFT/Correctness.lean), [`TensorCore.EFMachine.algorithm1_agrees`](../TensorCore/Kernels/EFT/Refinement.lean) |
| C07. Eq.20 and extraction | Every permitted coarse extraction grid; Eq.20 supplies the coefficient budget for exact scalar summation. Minimum grid, finite magnitude, and guarded component representability remain hypotheses. | [`TensorCore.ExtractionGrid.eq20_exact_sum`](../TensorCore/EFT/ExtractionGrid.lean), [`TensorCore.ExtractionGrid.eq20_scalarPredicate`](../TensorCore/EFT/ExtractionGrid.lean), [`TensorCore.ExtractionGrid.recovery`](../TensorCore/EFT/ExtractionGrid.lean) |
| C21. Native EFT scalar execution | Native FP32 scalar additions preserve the complete bounded Algorithm 1 result for every input, including branch tags and errors. All eight supported finite, shape-correct paths retain correct rounding and the exact range/success contract. | [`TensorCore.EFMachine.naiveSum32WithLeanFrom_eq`](../TensorCore/Kernels/EFT/Native.lean), [`TensorCore.EFMachine.algorithm1WithLean_eq`](../TensorCore/Kernels/EFT/Native.lean), [`TensorCore.EFMachine.algorithm1WithLean_correct`](../TensorCore/Kernels/EFT/Native.lean), [`TensorCore.EFMachine.algorithm1WithLean_range_iff`](../TensorCore/Kernels/EFT/Native.lean) |

The paper's input-budget inequality is numbered (17) in the manuscript; historical `eq20` identifiers refer to that same sufficient condition. The scalar predicate is a conservative executable sufficient condition. Chosen-grid theorems also permit other valid common grids.

The model rejects nonfinite operands, wrong product counts, and exact accumulators outside maximum finite FP32 magnitude. Exact arithmetic zero is +0; negative nonzero underflow retains its sign. EFT extraction permits any finite D independently of TC-model conformance. The bounded backend preserves reference result bits; its fallback branch may differ.

## Source layout

| Directory | Contents |
| --- | --- |
| `TensorCore/Numerics` | Bit encodings, exact arithmetic, finite rounding, scalar sums |
| `TensorCore/TC` | Base TC model, profiles, specification, width/refinement, error and non-monotonicity theory |
| `TensorCore/EFT` | Extraction, scalar preconditions, and reference EFT |
| `TensorCore/Kernels/EFT` | Bounded workspace operations and EFT refinement |
| `tests/TensorCoreTests` | Separate regression modules and trust checks |
| `TensorCore/Scalar` | Scalar proof dependencies for native EFT tests |
| `Main`, `examples` | Compiled adapters and executable Lean tests |
| `scripts` | Trust audits and model/EFT validation |
| `vendor`, `data`, `hardware` | Pinned independent oracles, recorded vectors, regression cases, optional TC hardware tests |
| `floatlib-port` | Independent FloatLib model, proofs, and associated tests |

[Generated proof index](proofs/README.md) · [Trust and style](style.md)
