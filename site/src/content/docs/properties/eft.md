---
title: TC-EFT correction
description: The error-free transformation that recovers what alignment discarded and returns the correctly rounded FP32 sum.
---

TC-EFT is the algorithm of the **TC-EFT paper** (*TC-EFT: Characterizing and
Correcting Tensor Core Arithmetic*), Section IV. It takes the **encoded inputs** of a block and **any finite FP32 word D**
(normally the Tensor Core's output). It reconstructs the exact sum and
returns its correctly rounded (nearest-even) FP32 value.

## The overlap identity

This is Theorem IV.5 of the TC-EFT paper. Fix an extraction grid no finer
than the alignment grid. Split each term into
a coarse part `hᵢ` on that grid and a low part `εᵢ`. Let `H = Σ hᵢ` and
`εₒ = D − H`. Then

```text
S = D − εₒ + Σ εᵢ
```

```lean
theorem overlap_recovery (t : BlockTrace) : ...   -- TensorCore/EFT/Extraction.lean
```

Since `εₒ` is defined as `D − H`, this identity is just a telescoping sum. It
is true for **any** `D`. The substance lies in *computing* it cheaply and
exactly.

## The scalar fast path

The scalar procedure adds the low parts in FP32, computes `D − εₒ` in FP32,
and performs one final nearest-even addition. A checkable predicate,
`scalarPredicate`, ensures every intermediate FP32 operation is exact:

- the support-grid exponent is between −149 and 104;
- the low-part coefficients are integers whose absolute sum is below `2^24`;
- `D`, `εₒ`, and `H` are representable in FP32;
- the final sum is in FP32 range.

```lean
theorem scalarCorrected_correct ...   -- predicate ⇒ result is RNE(S)
```

The core of this result is a proof that naive FP32 summation is exact under a
bit-span bound (`naiveSumBinary_exact_of_bitSpan`).
`ExtractionGrid.inputBudget_scalarPredicate` relates the TC-EFT paper's input-budget
inequality (17) to that predicate.

## Algorithm 1 of the TC-EFT paper: always returns an answer

```lean
def tcEftEncoded {p : Profile} (x : BlockInput p) (D : F32) : ...
theorem tcEftEncoded_correct ...       -- any returned bits are RNE(S)
theorem tcEftEncoded_bits_isSome_iff ... -- bits are returned iff |S| ≤ maxFinite32
```

If the scalar predicate fails, the reference algorithm falls back to exact
rational consolidation followed by one RNE conversion. Together the two
theorems give total correctness on the finite range.

## Bounded execution

[`EFMachine.tcEft`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Defs.lean)
runs in a fixed **576-bit** fixed-point workspace (bias `2^-272`), the size a
real implementation would use:

- `tcEft_success`, `tcEft_range_iff`: on supported, finite,
  correctly shaped inputs, a result exists exactly when the exact sum is in
  range. The workspace never overflows.
- `tcEft_agrees`: its output bits equal the reference algorithm's.
- `tcEftWithLean_eq`: replacing the scalar additions with Lean's native
  FP32 `Float32.add`, as specified by Lean's float model, gives the same
  complete result.

## Reading the guarantees carefully

- **D can be any finite word.** The correctness theorems do not use the fact
  that `D` came from the Tensor Core. Choosing `D` = the TC output is what
  makes the scalar path **likely to apply**, not what makes the result
  correct.
- **The scalar path is self-checking.** In the bounded kernel, the FP32 fast
  path is accepted only after intermediates are compared against exact
  values. No theorem yet shows that the predicate *forces* the fast path to
  be taken.
- **How often the scalar path applies depends on the inputs.** On the
  *Accurate Models* GPU vectors and the near-one cohort it is taken 5,000/5,000 and
  1,000/1,000 times on each GPU. On application-like inputs it is taken in
  58–97% of cases. On uniformly random bit patterns, whose exponents spread
  widely, it is taken 73, 13, and 0 times out of 1,000 (V100, A100, H100).
  The exact fallback then supplies the answer.
- **The reference fast-path check is stricter than it needs to be.** The
  fast path is safe only if all the low parts fit within 24 bits of each
  other. The reference check estimates their span from each term's *format*,
  meaning the finest bit the term could possibly have, and it even counts
  zero terms (a zero `C` is treated as having bits down to `2^0`). The
  576-bit implementation measures the bits the low parts *actually* use.
  Both always return the correct answer, but the reference falls back to
  the slower exact path more often. For example, with BF16 inputs and
  `C = +0` the 576-bit version takes the fast path while the reference
  rejects it.
