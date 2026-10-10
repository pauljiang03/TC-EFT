---
title: Correct rounding
description: How Ozaki-I, Ozaki-II and ADP-style slicing return the correctly rounded product for every input - a proved check with an exact fallback on the matrix engine, fixed-width integer arithmetic with one theorem bounding every register, IEEE special values, and the same results on NVIDIA and AMD.
---

The Ozaki schemes guarantee an error bound, not the correctly rounded result.
Each has a correctly rounded variant here: for every input on which the
matrix engine is exact, it returns the IEEE round to nearest even of the
exact product `x · y`, the same value on the NVIDIA and AMD models. Every
claim on this page is a Lean theorem using only Lean's standard axioms.

## The method: a check, then an exact fallback

Each scheme holds an exact value `H` before its last rounding and a proved
bound `B ≥ |x · y − H|`:

- **Ozaki-I:** `H` is the sum of the slice products computed so far, and `B`
  bounds what the omitted slice pairs would add.
- **Ozaki-II:** `H` is the reconstructed integer product, and `B` the
  truncation bound.
- **ADP-style slicing:** `H` is the recombined fixed-point product, and `B`
  the fixed-point bound.

Then for each entry:

1. **Check.** If `H − B` and `H + B` round to the same float, so does `x · y`,
   which lies between them. Rounding to nearest is monotone; Lean proves it
   from the nearest-value property alone ([`round_monotone`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L56),
   [`round_eq_of_enclosure`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L72)).
2. **Refine.** Otherwise try more slices, or more moduli, which shrinks `B`.
3. **Fall back.** Otherwise compute `x · y` exactly, also on the engine. Ozaki-I
   with all `s²` slice products and enough slices that nothing is left over is
   exact ([`ozaki1Full_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L470)). Floats lie on a finite grid, so this always
   ends: at most `24` slices of `11` bits for binary32 inputs and `175` for
   binary64 ([`split_residual_zero`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L415)).

The result is correctly rounded whichever step settles it ([`certify_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L123),
[`ozaki1CRE_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L521), [`ozaki2CRE_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L538), [`adpCRE_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADPFix.lean#L223)). The fallback is part of
the method, not a failure: it is slower and never wrong.

The test in step 1 is Ziv's rounding test, classical in correctly rounded
math libraries. What is new is using it as an early-exit certificate on Ozaki
matrix products, with refinement and a proved exact fallback on the engine,
for all three schemes, machine-checked. See
[Related work and novelty](/TC-EFT/ozaki/literature/) for the prior work
closest to it.

## How often the check settles an entry

The check settles an entry whenever `x · y` lies at least `2B` from every
rounding boundary ([`roundEnclosure_of_margin`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L319),
[`ozaki1Enclosure_settles`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L340)). Each extra slice of `11` bits divides `B` by
about `2^12`. The fallback is needed for:

- **exact ties**, results exactly halfway between two floats, which no
  enclosure can settle;
- **results very close to a boundary**, mostly products with heavy
  cancellation, where `B` is large compared with the result's spacing.

**Exact zeros settle at once.** The bound counts only the positions where
both entries are nonzero ([`exactTerms_error_overlap`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ZeroCheck.lean#L195)), so an entry whose
products are all zero, such as sparse rows and columns with no shared
nonzero, settles on the first check with `0` and its IEEE sign
([`supportOverlap_eq_zero_iff`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ZeroCheck.lean#L124), [`ozaki1CREZ_zero`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ZeroCheck.lean#L525),
[`ozaki1CRWSZ_zero`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ZeroCheck.lean#L817)). The count costs one extra engine dot product per entry.

On the test matrices:

- Ozaki-I settles every Z3 entry with four slices and all but two with three.
- Ozaki-II with the Z3 models' four moduli (`P = 22`) settles none, five
  moduli settle 21 of 32, six settle all; it carries no margin at `P = 22`.
- ADP settles every entry of both binary64 cases at the configuration its own
  exponent-span rule picks.

These are small matrices. How often realistic sizes and ill-conditioned
inputs reach the fallback has not been measured.

## Fixed-width integer arithmetic

Everything after the engine can run in integer registers whose widths do not
depend on the inputs' exponents.

- **Slicing** works on significands and exponents with shifts, a
  round-half-even division and comparisons. It equals the slicing of the
  proofs for every grid ([`splitInt_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/SliceInt.lean#L582), [`splitInt_width`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/SliceInt.lean#L605)).
- **The check** adds each scaled slice product, rounded down to a window of
  `W` bits, in a register that never wraps ([`ozaki1Window_register`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Window.lean#L149),
  [`ozaki1CRW_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Window.lean#L135)). The final round to nearest even is a few integer
  comparisons ([`roundExact_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Bounded.lean#L635)).
- **The fallback** decides the rounding of a sum of terms `v · 2^e` by a
  top-down descent over windows. It adds the parts of the terms in a window,
  carries the sum down only when cancellation has made it small, and jumps
  over empty gaps ([`roundSumJ_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Descent.lean#L508)). It visits at most
  `n · bitlen(max |v|) + 1` windows, whatever the exponents
  ([`windowsJ_le`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Descent.lean#L436)).
- **The whole pipeline**, from `(significand, exponent)` inputs to the rounded
  result, is one integer function proved correctly rounded: for Ozaki-I
  ([`ozaki1CRI_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/BoundedInt.lean#L185)), Ozaki-II ([`ozaki2CRJ_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/BoundedOzaki2J.lean#L111)) and ADP-style slicing
  ([`adpCRJ_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADPIntJ.lean#L33)), on both vendors (ADP on the Tensor Core side), with
  signed-zero versions ([`ozaki1CRIS_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/BoundedInt.lean#L330), [`ozaki2CRJS_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/BoundedOzaki2J.lean#L173),
  [`adpCRJS_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADPIntJ.lean#L59)).

**One theorem bounds every register.** A checked copy of each pipeline guards
every integer it computes: data against `2^R`, exponents and counters
against `2^X`. Under explicit formulas for `R` and `X`, the checked copy
returns exactly what the unchecked one returns, so no register ever
overflows ([`ozaki1CRIC_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/BoundedChecked.lean#L2122), [`ozaki2CRJC_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/BoundedChecked2.lean#L634), [`adpCRJC_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADPChecked.lean#L420)):

| Pipeline | Data bits `R` | Exponent and counter bits `X` |
| --- | --- | --- |
| Ozaki-I, FP64 (`11`-bit slices, up to `175`, `k ≤ 2^20`) | 332 | 24 |
| Ozaki-I, binary32 (up to `24` slices) | 303 | 17 |
| Ozaki-II, FP64 (twelve moduli up to `4096`, `P ≤ 69`) | 264 | 24 |
| Ozaki-II, binary32 (six moduli) | 161 | 17 |
| ADP-style, FP64 (up to `11` slices of width up to `81`) | 264 | 25 |

Kernel-checked tests show the guards are real: at narrower widths the checked
copies fail. The widths are generous, not tight, and the theorems leave a few
things unguarded: comparisons, signs, bit lengths and small counters, and the
engines' internal arithmetic, of which only the outputs are guarded.

## IEEE special values

On IEEE data the specification is the exact dot product rounded once
([`dotIEEE`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/IEEEDot.lean#L55)):

- NaN for a NaN input, a product `Inf · 0`, or opposite infinities;
- `±Inf` for an infinite product or an overflowing sum;
- otherwise the rounded sum, with IEEE's zero sign: a nonzero sum that rounds
  to zero keeps its sign, and an exact zero is `−0` only when every product
  is `−0`.

IEEE 754 leaves a dot product's order and precision to the implementation;
this is the "exact, then round once" reading. A wrapper handles the special
inputs and takes the sign of an overflowing sum from the exact path's integer
terms; with it every correctly rounded variant, rational or integer, meets the
specification for every input ([`crIEEE_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/IEEEDot.lean#L148), [`crIEEEI_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/IEEEInt.lean#L105),
[`tcOzaki1CRDI_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/IEEESchemes.lean#L60), [`mcOzaki1CRDI_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiMC/IEEESchemes.lean#L43)). Kernel tests cover the table of
cases on both vendors.

## The same result on NVIDIA and AMD

Every variant rounds with a hardware-independent IEEE round to nearest even,
proved for any binary format ([`roundRNE_nearest`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Binary.lean#L448)). The hardware libraries'
own roundings compute the same values: TensorCore's up to the largest finite
value, where it returns nothing above it ([`round32ValueTC_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Rounding.lean#L136),
[`fp64RoundTC_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/IEEE.lean#L33)), and MatrixCore's on every input
([`round32Value_eq_rne32Q`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiMC/IEEE.lean#L38)). So on the two vendors' models the correctly
rounded variants return the same value for the same inputs, even though the
engines underneath differ: the Tensor Core truncates and CDNA 3 rounds.

## What runs where

- **On the matrix engine:** every slice and residue product, including the
  fallback's.
- **In fixed-width integer registers:** slicing, the check, the fallback's
  descent and the final rounding.
- **Never on a Tensor Core:** the check. A Tensor Core's output is not
  monotone in its inputs ([non-monotonicity](/TC-EFT/properties/non-monotonicity/)),
  and the check relies on monotone rounding.

## What is not covered

- A GPU implementation and measurements: the cost claims come from the model
  and small test matrices.
- The engine's exactness rests on the hardware models, which are validated
  against GPUs by measurement, not proved. ADP runs on an idealized INT8
  engine ([issue #2](https://github.com/pauljiang03/TC-EFT/issues/2)).
- NaN payloads and signalling NaNs.
