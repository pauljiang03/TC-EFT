---
title: TC-EFT correction
description: Does TC-EFT work? What it recovers, its fast and exact paths, and what its guarantees do and do not say.
---

TC-EFT is the algorithm of the **TC-EFT paper** (*TC-EFT: Characterizing and
Correcting Tensor Core Arithmetic*), Section IV. It takes the encoded inputs
of one block and a finite FP32 word `D`, normally the Tensor Core's output. It
returns the exact sum `S = C + Σ aᵢ·bᵢ` rounded to the nearest FP32 value
(ties to even).

## Does it work?

**Yes.** Lean proves that whenever TC-EFT returns a value, that value is the
exact sum `S` correctly rounded to FP32. It returns a value exactly when that
rounded sum is a finite FP32 number. The fixed-size 576-bit implementation is
proved to return the same bits.

The caveats below never involve a wrong answer. They concern **which of two
paths** produces the answer (a fast FP32 path or a slower exact path), and
**what the proofs do and do not cover**.

## What it recovers, in bits

The Tensor Core [aligns](/TC-EFT/model/alignment/) every term to the bit
position of the largest exponent and **drops every bit below its lowest kept
bit**. Then it [truncates](/TC-EFT/model/normalization/) the sum to FP32's 24
significant bits. TC-EFT puts those dropped bits back.

1. **Pick a cut-off bit.** This is whichever is higher: the lowest bit the
   Tensor Core kept during alignment, or the lowest bit of `D`.
2. **Split every term at the cut-off** into its *high bits* (at or above it)
   and its *low bits* (below it). The low bits of each term are exactly what
   was lost or is not visible in `D`.
3. **Sum the high bits** to get `H`. `H` and `D` agree except in a small
   window of bits. Their difference is the *overlap* `εₒ = D − H`.
4. **Add the low bits back:** `S = D − εₒ + (sum of all low bits)`, which is
   just `H + (sum of all low bits)`. Then round once to FP32.

```lean
theorem overlap_recovery (t : BlockTrace) : ...   -- S = D − εₒ + Σ low parts
```

The identity in step 4 holds for **any** `D`, because `εₒ` is defined as
`D − H`. On its own it is bookkeeping. The real work is computing the final
sum cheaply without losing bits.

## Two ways to finish

### The fast path: plain FP32 additions

If every intermediate result fits in FP32 without losing a bit, the sum can
be finished with ordinary FP32 additions. Only the last addition rounds.
TC-EFT runs a check first. The fast path is used only if all of these hold:

- **The low bits of all terms fit together within 24 bits.** Measured from
  the lowest low bit present, the low parts need fewer than 24 bits in total,
  so adding them in FP32 never drops a bit.
- **Those bits sit inside FP32's exponent range:** the lowest one is no lower
  than `2^-149` (FP32's smallest subnormal bit), and the window does not
  reach past `2^128`.
- **`D`, the overlap `εₒ`, and `H` each fit in FP32's 24 significant bits.**
- **The final result is within FP32's range.**

```lean
theorem scalarCorrected_correct ...   -- check passes ⇒ fast path returns RNE(S)
```

The key lemma is that adding numbers in FP32 is exact when all their bits fit
within one 24-bit window (`naiveSumBinary_exact_of_bitSpan`).

### The exact path: a wide fixed-point register

If the check fails, TC-EFT adds all the bits in a register wide enough to hold
every bit of every term. The reference version uses exact rationals; the
implementation uses a **576-bit** fixed-point word whose lowest bit is
`2^-272`. It then rounds once to FP32. This path always gives the right
answer, but it is slower.

```lean
theorem tcEftEncoded_correct ...         -- any returned value is RNE(S)
theorem tcEftEncoded_bits_isSome_iff ... -- a value is returned iff RNE(S) is finite
theorem EFMachine.tcEft_success ...      -- the 576-bit word never overflows on supported inputs
theorem EFMachine.tcEft_agrees ...       -- 576-bit and reference versions return the same bits
theorem EFMachine.tcEftWithLean_eq ...   -- using Lean's native Float32 additions changes nothing
```

## The caveats, plainly

**1. The result doesn't depend on `D` being the Tensor Core's output.**
The proofs work for any finite `D`. So TC-EFT's *correctness* does not rely on
the Tensor Core model matching the hardware: the answer is always the
correctly rounded exact sum of the inputs. What a good `D` buys is
*speed*: when `D` is the real Tensor Core output, `H` and `D` overlap in only
a few bits, so the fast path usually applies.

**2. The fast path doesn't always apply.** How often depends on how spread
out the inputs' exponents are:

| Inputs | Fast path taken |
| --- | --- |
| Recorded GPU vectors from *Accurate Models* | 5,000 / 5,000 on each GPU |
| Values near 1 | 1,000 / 1,000 on each GPU |
| Application-like inputs | 58–97% |
| Uniformly random bit patterns (exponents spread over the whole range) | 73 (V100), 13 (A100), 0 (H100) out of 1,000 |

When the fast path is not taken, the exact path gives the answer.

**3. The reference version's check is stricter than it needs to be.** To
judge whether the low bits fit in 24 bits, the reference check uses the
*lowest bit each term could possibly have*, given its format. It even counts
zero terms: a zero `C` is treated as having bits down to `2^0`. The 576-bit
implementation looks at the *lowest bit actually set*. Both are safe, and the
answers are identical. The reference version just takes the slow path more
often. For example, with BF16 inputs and `C = +0` the 576-bit version takes
the fast path while the reference does not.

**4. The fast path is checked at run time, not proved to apply.** In the
576-bit implementation, the fast path's intermediate results are compared
with the exact ones before being accepted. Correctness is proved, but no
theorem shows that passing the check *guarantees* the fast path is taken.

**5. The paper's input-budget condition is only partly connected.** The
TC-EFT paper's inequality (17) bounds the bit span from the inputs alone.
`ExtractionGrid.inputBudget_scalarPredicate` derives two of the fast-path
conditions from it and assumes the other seven, so it says less than its
name suggests.

**6. No answer when the sum is too large for FP32.** If the exact sum rounds
beyond FP32's largest finite value, TC-EFT returns no result rather than
infinity, matching the finite scope of the [model](/TC-EFT/model/scope/).
