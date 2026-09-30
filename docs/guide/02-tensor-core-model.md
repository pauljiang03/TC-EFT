# The tensor-core block model

The model evaluates K exact products plus an FP32 accumulator input C. The named architecture profiles select K, extra alignment bits p, and an optional alignment floor. They keep FP32 output, while choosing FP16, BF16, or packed TF32 inputs.

## Follow one block

| Stage | Executable definitions | Mathematical role |
| --- | --- | --- |
| Decode | `prepare`, `prepareProducts`, `Profile.decode` | Decode finite words and preserve raw exponent/fraction metadata |
| Multiply | `rawMul`, `PreparedBlock.terms` | Form exact products without normalizing their raw exponent sums |
| Select grid | `PreparedBlock.eta`, `quantumExponent` | Take the nonzero raw-scale maximum, apply the profile floor, and subtract alignment precision |
| Align | `truncCoeff`, `PreparedBlock.coefficients` | Truncate signed terms toward zero onto the common grid |
| Accumulate | `PreparedBlock.accumulator` | Sum retained integer coefficients exactly |
| Convert | `evalPrepared`, `round32 .towardZero` | Convert the exact accumulator to finite FP32 |
| Explain loss | `alignmentResiduals`, `BlockTrace.residual` | Account for alignment loss and final conversion loss |

Start with [Block.lean](../../TensorCore/TC/Block.lean), then follow [StageResiduals.lean](../../TensorCore/TC/StageResiduals.lean) and [ErrorBounds.lean](../../TensorCore/TC/ErrorBounds.lean). The [independent specification](../../TensorCore/TC/Specification/Defs.lean) uses separate mathematical definitions; its bridge proves equality of encoded results.

The raw scale matters even when two factorizations have the same product value. Replacing exact raw products with normalized products can change the alignment grid and the answer. Zero terms do not choose the raw maximum; nonzero subnormal inputs retain their format's raw subnormal scale.

For FP32 output, alignment precision is `F = 23 + p`. The selected profiles are:

| Path | K | p | Floor |
| --- | ---: | ---: | ---: |
| V100 FP16 | 4 | 0 | none |
| A100 FP16 / BF16 | 8 | 1 | -132 |
| H100 FP16 / BF16 | 16 | 2 | -133 |
| A100 TF32 | 4 | 1 | -132 |
| H100 TF32 WMMA | 4 | 2 | -133 |
| H100 TF32 MMA | 8 | 2 | -133 |

The generic profile constructors also permit other K/p/floor parameters. The profile contract states its width, range, and format premises explicitly; choosing a parameter does not establish physical GPU correspondence.

## Read the contracts

```lean
import TensorCore.TC

open TensorCore

#check evalBlock_success_iff
#check profile_contract
#check evalBlock_machinePrefix
#check evalBlock_error_bound
#check PaperSpec.supported_eq_paper
```

`evalBlock_success_iff` characterizes the accepted domain. `profile_contract` bundles arithmetic and width facts under its stated hypotheses. `evalBlock_machinePrefix` relates fixed-width accumulation to exact accumulation when the capacity assumptions hold. `evalBlock_error_bound` includes final FP32 conversion loss, in addition to alignment loss. `supported_eq_paper` equates all encoded inputs of each supported path, including rejection, with the independent specification.

The finite model rejects nonfinite operands, wrong group sizes, and exact accumulators larger in magnitude than `maxFinite32`. Exact zero is canonicalized to +0; negative nonzero underflow may produce -0. The `tc_features` interface accepts TF32 register words with thirteen zero low bits; the paper EFT interface accepts packed 19-bit TF32 words.

[CanonicalInvocation.lean](../../examples/CanonicalInvocation.lean) combines a concrete Hopper calculation with a symbolic width/refinement example. Recorded-vector checks compare this software model with archived measured outputs; they take no new hardware measurements.

Next: [execute non-monotonicity](03-non-monotonicity.md).
