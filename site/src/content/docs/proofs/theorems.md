---
title: What is proved
description: Every headline theorem in plain language, with what it assumes, what it means, and how strong it is.
---

This page lists the main results that Lean has checked. Each entry says, in
plain words, what the result means, what it assumes, and how much it really
establishes. The Lean name and a source link follow each entry for anyone
who wants to read the formal statement.

Every result here is checked by Lean's kernel. It relies only on Lean's three
standard axioms (`propext`, `Classical.choice`, `Quot.sound`), with no
`sorry` and no custom axioms. See the [trust boundary](/TC-EFT/proofs/trust/)
for what is tested rather than proved.

**How much does each result tell you?** Every entry is marked with one of
three labels:

- **Real result**: a genuine fact about the model. It could have turned out
  false, and the proof shows it doesn't.
- **True by definition**: holds because of how the terms are defined. It is
  useful bookkeeping, but tells you little on its own.
- **Partial**: assumes much of what it concludes, so it proves less than its
  name suggests.

## The Tensor Core model

### Does the Lean model match the published model?

**Yes, for every possible input.** The executable model and an independently
written transcription of *Accurate Models* produce the same output bits, or
both reject the input. This holds on all eight supported GPU paths.

- **Assumes:** nothing beyond the input being one of the eight supported paths.
- **How much it tells you:** Real result. The transcription is mechanically checked not to reuse
  any model code, and a companion result shows it isn't vacuous.
- **Lean:** [`IndependentSpec.supported_eq_spec`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Specification/Supported.lean#L25)

### Which inputs does the model accept?

**Exactly those with the right number of products, no NaN or infinity, and a
sum that fits in FP32.** Anything else is rejected with a named error.

- **Assumes:** nothing.
- **How much it tells you:** Real result. It is an exact "if and only if".
- **Lean:** [`evalBlock_success_iff`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/AcceptedDomain.lean#L33)

### Is all the lost precision accounted for?

**Yes.** The exact sum of the inputs equals the model's output plus the parts
dropped by alignment and by the final rounding.

- **Assumes:** the model accepted the input.
- **How much it tells you:** Real result. The exact sum is computed from the original input
  words, not from the model's own intermediate values.
- **Lean:** [`evalBlock_residual_identity`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/StageResiduals.lean#L90)

### How large can the error be?

**Less than (number of terms) × (alignment grid step) + (one unit in the last
place of the output).** The first part is the alignment loss and the second
is the rounding loss.

- **Assumes:** the model accepted the input.
- **How much it tells you:** Real result.
- **Lean:** [`evalBlock_error_bound`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/ErrorBounds.lean#L78)

### Does modeling the adder as exact hide anything?

**No.** A model with a fixed-width, wrapping two's-complement register gives
the same output for every input, as long as the register is wide enough:
29, 31 and 33 bits for the V100, A100 and H100 FP16 profiles. Every partial
sum is exact too, whatever the order of additions.

- **Assumes:** a register at least that wide.
- **How much it tells you:** Real result.
- **Lean:** [`evalBlockMachine_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/MachineRefinement.lean#L13), [`evalBlock_machinePrefix`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/AlignmentExponent.lean#L184)

### Chained groups

**For instructions made of several groups, the same loss accounting holds
across the whole chain.**

- **Assumes:** each group's output is passed on as the next group's `C`.
- **How much it tells you:** Real result.
- **Lean:** [`runBlocks_residual_ledger`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Composition.lean#L93)

## Non-monotonicity

### Can a smaller C give a larger result?

**Yes, and exactly when the group has at least 3·2^p products.** Here p is
the GPU's number of extra alignment bits. The proof uses a specific family:
K equal tiny products, with `C` lowered from 1 to the next FP32 value below 1.

- **Assumes:** that construction (products of exactly `2^-(24+p)`) and a
  floor at most −1.
- **How much it tells you:** Real result. It is an exact threshold, and every GPU profile has
  a checked concrete example.
- **Lean:** [`nonmonotone_encoded`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Monotonicity.lean#L272)

### How large can the effect be?

**The result gives the exact range of perturbations that raise the output, a
formula for the output, and its maximum,** for `C = 1 − j·2^-24`.

- **Assumes:** the same construction, with `1 ≤ j ≤ 2^23`.
- **How much it tells you:** Real result.
- **Lean:** [`nonmonotone_range_encoded`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/MonotonicityRange.lean#L264)

### When does it happen in general?

**For any inputs, the output can rise only if the products recovered by the
finer grid outweigh the change in `C`.** That condition is also sufficient
when both sums are exactly representable in FP32.

- **Assumes:** both evaluations succeed; FP32 representability for the
  "sufficient" direction.
- **How much it tells you:** Real result.
- **Lean:** [`flowback_necessary`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Flowback.lean#L200), [`flowback_sufficient`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Flowback.lean#L219)

## TC-EFT correction

### Is the corrected result right?

**Yes. Whatever TC-EFT returns is the exact sum rounded to the nearest FP32
value, ties to even.** It returns a value exactly when that rounded sum is
finite.

- **Assumes:** nothing about `D`, which can be any finite FP32 word.
- **How much it tells you:** Real result. Note that the result doesn't depend on `D`
  being the real Tensor Core output.
- **Lean:** [`tcEftEncoded_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/Encoded.lean#L114), [`tcEftEncoded_bits_isSome_iff`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/Encoded.lean#L128)

### Does the fast FP32 path give the right answer?

**Yes, whenever its safety check passes.** The check ensures every
intermediate FP32 operation is exact, so only the final rounding remains.

- **Assumes:** the scalar safety check holds.
- **How much it tells you:** Real result. The core is a proof that naive FP32 summation is
  exact within a 24-bit budget.
- **Lean:** [`scalarCorrected_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/Extraction.lean#L144), [`naiveSumBinary_exact_of_bitSpan`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Binary/ScalarSum.lean#L165)

### Recovering the exact sum from D

**The exact sum equals `D` minus the overlap plus the low parts.**

- **How much it tells you:** True by definition. The overlap is *defined* as `D` minus the
  retained part, so the identity is a rearrangement.
- **Lean:** [`overlap_recovery`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/Extraction.lean#L20)

### Does the paper's input-budget condition imply the safety check?

**Partly.** It derives two of the check's conditions; the other seven are
assumed.

- **How much it tells you:** Partial. No example in the repository satisfies
  all of its assumptions at once.
- **Lean:** [`ExtractionGrid.inputBudget_scalarPredicate`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/EFT/ExtractionGrid.lean#L174)

### Does the fixed-size implementation agree?

**Yes.** The 576-bit implementation never overflows on supported inputs,
returns a result exactly when the rounded sum is finite, and returns the
same bits as the reference version. Swapping in Lean's native `Float32`
additions changes nothing.

- **Assumes:** supported, finite, correctly shaped inputs.
- **How much it tells you:** Real result. The native-float part holds relative to Lean's
  specification of `Float32`.
- **Lean:** [`EFMachine.tcEft_success`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Correctness.lean#L91), [`EFMachine.tcEft_range_iff`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Correctness.lean#L101), [`EFMachine.tcEft_agrees`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Refinement.lean#L7), [`EFMachine.tcEftWithLean_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Native.lean#L108)

## Number formats and rounding

### Is FP32 rounding implemented correctly?

**Yes.** The converter returns the nearest FP32 value, ties to even, for every
input in range. This also holds for any binary format and any rounding
direction.

- **How much it tells you:** Real result. One gap: the specification doesn't fix the sign of a
  zero result.
- **Lean:** [`round32_nearestEven_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/CorrectRounding.lean#L153), [`roundBinary_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Binary/RoundingContract.lean#L16)

### Is decoding of bit patterns consistent?

**Yes.** Finite bit patterns and representable values correspond one to one,
including subnormals and both zeros.

- **How much it tells you:** Real result.
- **Lean:** [`signedFiniteBinaryBijection`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Binary/SignedBijection.lean#L130)

## What is not proved

- **That real GPUs behave like the model.** That rests on replaying recorded
  measurements. See [hardware validation](/TC-EFT/model/validation/).
- **That the fast path is taken whenever the safety check passes.** The
  bounded implementation checks this at run time instead.
- **No theorem here is a finite list of cases dressed up as a general result.**
  Concrete `decide` checks are used only for worked examples and regression
  witnesses.
