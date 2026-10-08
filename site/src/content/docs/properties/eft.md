---
title: TC-EFT correction
description: The error-free transformation that recovers what alignment discarded and returns the correctly rounded FP32 sum.
---

TC-EFT takes the **encoded inputs** of a block and **any finite FP32 word D**
(normally the Tensor Core's output). It reconstructs the exact sum and
returns its correctly rounded (nearest-even) FP32 value.

## The overlap identity

Fix an extraction grid no finer than the alignment grid. Split each term into
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
`ExtractionGrid.eq20_scalarPredicate` relates the manuscript's input-budget
inequality to that predicate.

## Algorithm 1: always returns an answer

```lean
def algorithm1Encoded {p : Profile} (x : BlockInput p) (D : F32) : ...
theorem algorithm1Encoded_correct ...       -- any returned bits are RNE(S)
theorem algorithm1Encoded_bits_isSome_iff ... -- bits are returned iff |S| ≤ maxFinite32
```

If the scalar predicate fails, the reference algorithm falls back to exact
rational consolidation followed by one RNE conversion. Together the two
theorems give total correctness on the finite range.

## Bounded execution

[`EFMachine.algorithm1`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/EFT/Defs.lean)
runs in a fixed **576-bit** fixed-point workspace (bias `2^-272`), the size a
real implementation would use:

- `algorithm1_success`, `algorithm1_range_iff`: on supported, finite,
  correctly shaped inputs, a result exists exactly when the exact sum is in
  range. The workspace never overflows.
- `algorithm1_agrees`: its output bits equal the reference algorithm's.
- `algorithm1WithLean_eq`: replacing the scalar additions with Lean's native
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
- **The scalar path rarely applies on random inputs.** The recorded coverage
  runs accept it for 73/1000 (V100), 13/1000 (A100), and 0/1000 (H100)
  random finite-bit blocks. Correctness then comes from the exact fallback.
