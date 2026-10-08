---
title: Theorem index
description: The headline Lean theorems, where they live, and an honest reading of what each one establishes.
---

Every theorem below is kernel-checked and depends only on Lean's three
standard axioms: `propext`, `Classical.choice`, and `Quot.sound`. The
*Reading* column reflects an independent review of each statement. It says
whether the theorem carries real content or holds largely by construction.

## Tensor Core model

| Theorem | What it states | Reading |
| --- | --- | --- |
| [`IndependentSpec.supported_eq_spec`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Specification/Supported.lean#L25) | `evalBlock` and an independently written specification give the same bits or rejection on every input of all 8 paths | Substantive. The specification is audited for independence and the result is not vacuous (`supported_valid_success`) |
| [`evalBlock_success_iff`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/AcceptedDomain.lean#L33) | Exact accepted domain: shape, finite operands, in-range accumulator | Substantive |
| [`evalBlock_residual_identity`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/StageResiduals.lean#L90) | Exact input sum = output + named residual | Substantive. Ties the model to the original-input sum |
| [`evalBlock_error_bound`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/ErrorBounds.lean#L78) | Error < (K+1)·2^(η−F) + ulp(D) | Substantive. A tight two-part bound |
| [`evalBlockMachine_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/MachineRefinement.lean#L13) | w-bit wrapping accumulator = exact model at adequate width | Substantive |
| [`evalBlock_machinePrefix`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/AlignmentScale.lean#L184) | Every accumulation prefix is exact at the derived width | Substantive |
| [`profile_contract`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/CanonicalFormats.lean#L9) | Bundled arithmetic and width guarantees for any profile | Substantive (a bundle of the results above) |
| [`nonmonotone_encoded`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Monotonicity.lean#L272) | Output increase iff K ≥ 3·2^p for the constructed family | Substantive. An exact threshold, with witnesses per GPU |
| [`nonmonotone_range_encoded`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/MonotonicityRange.lean#L264) | General j perturbations: exact range and maximal output | Substantive |
| [`flowback_necessary`, `flowback_sufficient`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Flowback.lean#L200) | ω > ΔA is necessary for an increase, and sufficient when representable | Substantive |
| [`runBlocks_residual_ledger`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Composition.lean#L93) | Loss ledger across chained groups | Substantive |

## Numerics

| Theorem | What it states | Reading |
| --- | --- | --- |
| [`roundBinary_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Binary/RoundingContract.lean#L16) | Correct rounding for any well-formed binary format and mode | Substantive |
| [`round32_nearestEven_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/CorrectRounding.lean#L153) | FP32 RNE meets the independent `NearestEven32` contract | Substantive. The contract does not fix the sign of zero |
| [`signedFiniteBinaryBijection`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Binary/SignedBijection.lean#L130) | Finite encodings ↔ representable values with a zero sign | Substantive |
| `naiveSumBinary_exact_of_bitSpan` | Naive FP summation is exact under a bit-span bound | Substantive. The key lemma behind the scalar EFT |

## TC-EFT

| Theorem | What it states | Reading |
| --- | --- | --- |
| [`overlap_recovery`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/Extraction.lean#L20) | S = D − εₒ + Σ εᵢ | True by construction, since εₒ is defined as D − H. A bookkeeping identity |
| [`scalarCorrected_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/Extraction.lean#L144) | Scalar predicate ⇒ FP32 pipeline returns RNE(S) | Partly substantive. Exact FP32 summation is the real content |
| [`ExtractionGrid.inputBudget_scalarPredicate`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/ExtractionGrid.lean#L174) | Input-budget inequality ⇒ scalar predicate | Partly circular. 7 of the 9 predicate conjuncts are hypotheses, and no instance in the repository satisfies them all |
| [`tcEftEncoded_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/Encoded.lean#L114) | Any returned bits are RNE of the exact sum, for any finite D | Substantive. Partial correctness; with `tcEftEncoded_bits_isSome_iff` it becomes total |
| [`EFMachine.tcEft_success` / `_range_iff`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Correctness.lean#L91) | 576-bit kernel succeeds exactly when the sum is in range | Substantive |
| [`EFMachine.tcEft_agrees`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Refinement.lean#L7) | Bounded and reference bits agree | Substantive refinement |
| [`EFMachine.tcEftWithLean_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Native.lean#L108) | Native Float32 additions preserve the whole result | Substantive, relative to Lean's `Float` model |

## What is not in the proofs

- No theorem is a `decide` over finite cases presented as a general result.
  `decide +kernel` appears only in concrete regression witnesses and small
  side lemmas.
- None of the escape hatches occur anywhere in the sources: `sorry`,
  `admit`, user `axiom`s, `native_decide`, `implemented_by`,
  `@[extern]`, or `unsafe`.
- Hardware correspondence is **not** a theorem. See [hardware
  validation](/TC-EFT/model/validation/).
