# Public theorem index

Choose the theorem by the contract you need, then read its hypotheses in the linked Lean source. Each entry lists the module to import and the result's scope.

## Numerical foundation

| Declaration | Import | Contract |
| --- | --- | --- |
| `roundBinary_correct` | [Numerics.Binary.RoundingContract](Numerics/Binary/RoundingContract.lean) | Correct rounding for a well-formed finite binary format, mode, and in-range rational input |
| `roundBinary_isSome_iff` | [Numerics.Binary.RoundingContract](Numerics/Binary/RoundingContract.lean) | Exact finite-domain success criterion |
| `signedFiniteBinaryBijection` | [Numerics.Binary.SignedBijection](Numerics/Binary/SignedBijection.lean) | Finite words correspond to representable values with a zero sign |
| `naiveSumBinary_exact_of_bitSpan` | [Numerics.Binary.ScalarSum](Numerics/Binary/ScalarSum.lean) | Bit-span and range assumptions suffice for exact scalar summation |

## Tensor-core model and non-monotonicity

| Declaration | Import | Contract |
| --- | --- | --- |
| `profile_contract` | [TC.CanonicalFormats](TC/CanonicalFormats.lean) | Arithmetic and adequate-width refinement under the profile's explicit premises |
| `evalBlock_success_iff` | [TC.AcceptedDomain](TC/AcceptedDomain.lean) | Shape, finite decoding, and accumulator range characterize acceptance |
| `evalBlock_residual_identity` | [TC.StageResiduals](TC/StageResiduals.lean) | Successful evaluation connects the original ideal to output plus residual |
| `evalBlock_error_bound` | [TC.ErrorBounds](TC/ErrorBounds.lean) | Alignment loss plus final conversion loss bounds model error |
| `evalBlock_machinePrefix` | [TC.AlignmentScale](TC/AlignmentScale.lean) | Fixed-width prefixes agree with exact accumulation under capacity premises |
| `PaperSpec.supported_eq_paper` | [TC.Specification.Supported](TC/Specification/Supported.lean) | Encoded output/rejection equality with the independent paper specification |
| `flowback_necessary`, `flowback_sufficient` | [TC.Flowback](TC/Flowback.lean) | C-perturbation criteria including output conversion and representability premises |
| `nonmonotone_encoded` | [TC.Monotonicity](TC/Monotonicity.lean) | Realizable K/p construction has the `3·2^p` output-increase threshold |
| `nonmonotone_range_encoded` | [TC.MonotonicityRange](TC/MonotonicityRange.lean) | General j perturbations, witness range, and maximal output within that family |

## TC-EFT and execution kernels

| Declaration | Import | Contract |
| --- | --- | --- |
| `overlap_recovery` | [EFT.Extraction](EFT/Extraction.lean) | Exact original sum equals D minus overlap plus low parts |
| `scalarCorrected_correct` | [EFT.Extraction](EFT/Extraction.lean) | Scalar predicate entails nearest-even correction |
| `ExtractionGrid.eq20_scalarPredicate` | [EFT.ExtractionGrid](EFT/ExtractionGrid.lean) | Chosen-grid input-budget condition establishes sufficient scalar premises |
| `algorithm1Encoded_correct` | [EFT.Encoded](EFT/Encoded.lean) | Any returned encoded reference EFT result correctly rounds the original ideal |
| `EFMachine.algorithm1_success` | [Kernels.EFT.Correctness](Kernels/EFT/Correctness.lean) | Supported, finite, shape-correct inputs and in-range ideal give a bounded result |
| `EFMachine.algorithm1_range_iff` | [Kernels.EFT.Correctness](Kernels/EFT/Correctness.lean) | Bounded result exists exactly when the finite ideal is in range |
| `EFMachine.algorithm1_agrees` | [Kernels.EFT.Refinement](Kernels/EFT/Refinement.lean) | Bounded and reference result bits agree under the theorem's premises |
| `EFMachine.algorithm1WithLean_eq` | [Kernels.EFT.Native](Kernels/EFT/Native.lean) | Native scalar additions preserve the entire bounded result |

The following checked block keeps the main index entries connected to the actual API:

```lean
import TensorCore

open TensorCore

#check roundBinary_correct
#check signedFiniteBinaryBijection
#check naiveSumBinary_exact_of_bitSpan
#check profile_contract
#check evalBlock_success_iff
#check evalBlock_residual_identity
#check evalBlock_error_bound
#check evalBlock_machinePrefix
#check PaperSpec.supported_eq_paper
#check flowback_necessary
#check flowback_sufficient
#check nonmonotone_encoded
#check nonmonotone_range_encoded
#check overlap_recovery
#check scalarCorrected_correct
#check ExtractionGrid.eq20_scalarPredicate
#check algorithm1Encoded_correct
#check EFMachine.algorithm1_success
#check EFMachine.algorithm1_range_iff
#check EFMachine.algorithm1_agrees
#check EFMachine.algorithm1WithLean_eq
```

The [FloatLib correspondence](../floatlib-port/COMPARISON.md) maps the independent implementation and paper statements to its universal equivalence theorems. See the linked Lean files for complete statements and proofs.
