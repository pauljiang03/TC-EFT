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

`tc_lean_eft_check` reads JSON Lines on stdin. To compare the bounded scalar fold with native Lean FP32 addition for accumulator `0.0` and a single term `1.0`, send this encoded request:

```json
{"acc":0,"terms":[1065353216]}
```

Both returned results decode to FP32 `1.0`. A block request has `profile`, operand arrays `a` and `b`, and encoded `c` and `D`. It compares both complete bounded EFT execution paths.

## Proof contracts

The [theorem index](../TensorCore/THEOREMS.md) lists the public results and their premises.

Identifiers beginning `inputBudget_` concern the TC-EFT paper's input-budget inequality (17), a sufficient condition for the scalar predicate. The scalar predicate is a conservative executable sufficient condition. Chosen-grid theorems also permit other valid common grids.

The model rejects nonfinite operands, wrong product counts, and exact accumulators whose magnitude exceeds the maximum finite FP32 value. Exact arithmetic zero is +0; negative nonzero underflow retains its sign. EFT extraction accepts any finite D, whether or not it is the TC model's output. The bounded backend returns the same bits as the reference algorithm; its fallback branch tag may differ.

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
| `vendor`, `data` | Pinned paper oracles, recorded hardware inputs/outputs, and regression cases |
| `floatlib-port` | Independent FloatLib model, proofs, and associated tests |

[Theorem index](../TensorCore/THEOREMS.md) · [Trust and style](style.md)
