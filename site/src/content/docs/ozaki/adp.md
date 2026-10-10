---
title: ADP and ESC
description: NVIDIA's Automatic Dynamic Precision for FP64 emulation on INT8 engines, formalized in Lean - its slice encoding, the exponent span capacity, the Grade-A guarantee for the whole routine, a subnormal counterexample, and a correctly rounded variant.
---

ADP (Schwarz et al., NVIDIA, arXiv:2511.13778) is the scheme behind FP64
emulation in cuBLAS. It runs Ozaki-I on INT8 engines and adds guardrails: it
estimates from the inputs' exponents how many slices full FP64 accuracy needs
(the exponent span capacity, ESC), and falls back to native FP64 when the
inputs contain Inf or NaN or emulation would not pay off. The Lean development
follows a Z3 model of the routine step by step. Every result below uses only
Lean's standard axioms.

## The routine

1. **Scan** for Inf and NaN; if any, use native FP64 ([`adp_nonfinite_iff`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADP.lean#L457)).
2. **ESC.** From the exponents, estimate the span between the largest possible
   product and the largest actual one; a coarsened, blockwise estimate keeps it
   cheap. If it is unbounded, use native FP64.
3. **Width and slices.** Fixed-point width `W = 53 + ESC + 1`, and the fewest
   byte slices that hold `W` bits ([`Ozaki.TC.adpWidth`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADP.lean#L221),
   [`Ozaki.TC.slicesNeeded_spec`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADP.lean#L268)).
4. **Speed heuristic.** If `s²` INT8 products would cost more than native
   FP64, use native FP64.
5. **Emulate.** Convert each row and column to `W`-bit fixed point, cut the
   integers into signed bytes, multiply all `s²` slice pairs on the INT8
   engine, recombine exactly, and round once to binary64.

## The encoding and the engine

| Fact | Lean |
| --- | --- |
| Fixed point: `0 ≤ a 2^s − N < 1` and `N ∈ [−2^W, 2^W)`. | [`fixed_floor`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADPError.lean#L103), [`fixed_range`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADPError.lean#L110) |
| The unsigned-slice remap reconstructs every integer, and its slices are signed bytes exactly on its range; a remapped digit keeps the unsigned digit's bit pattern. | [`remap_value`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L109), [`remap_s8`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L156), [`remap_bit_pattern`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L167) |
| `53`-bit integers need `8` naive signed slices but `7` remapped ones; the remap range is slightly smaller than the prototype's. | [`slices_53`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L190), [`remap_range_smaller`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L171) |
| INT8 × INT8 → INT32 is exact on byte operands; a 16-bit register wraps. | [`int8Dot_bytes`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Int8.lean#L46), [`int8Dot_16_wraps`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Int8.lean#L51) |
| The `s²` slice products, weighted by `256^(t+u)`, add up to the fixed-point product, so the emulated result is one binary64 rounding of it. | [`slice_recombination`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L490), [`int8Ozaki_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Int8.lean#L86) |

The INT8 engine here is a 32-bit wrapping register (TC-EFT's fixed-width
accumulator) over exact integer products, not a model of an INT8 Tensor Core
instruction.

## ESC and accuracy

| Fact | Lean |
| --- | --- |
| The coarsened estimate never exceeds the exact one when zeros have exponent `−∞`, for any block size; skipping zeros, or giving them the subnormal exponent, can break it. | [`coarseEst_le`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L364), [`skipZeros_unsafe`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L387), [`field0_unsafe`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L394) |
| The coarsened ESC is at least the exact ESC, and the matrix ESC at least every entry's. | [`escCoarse_ge`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADPError.lean#L387), [`Ozaki.TC.matrixEsc_ge`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADP.lean#L308) |
| Full fidelity: with `W = 53 + ESC + 1`, both factors of the largest product convert exactly. | [`full_fidelity`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADP.lean#L402) |
| Each product's fixed-point error is at most `2^(F−52)`, where `F` is the exponent of the largest product. | [`term_bound`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADPError.lean#L197) |
| The fixed-point product is within `k 2^(F−52)` of `x · y`. | [`fixedPoint_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADPError.lean#L289) |

From these, Lean proves the paper's Grade-A guarantee, a componentwise bound
`f(k) u |A||B|` with `f` linear, which the paper establishes by experiment; the
constant `f(k) = 4k + 1` is the Z3 model's ([`emulated_gradeA`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/ADPError.lean#L562)):

```lean
theorem emulated_gradeA {rnd : ℚ → Option ℚ} {η : ℚ} (hr : RoundWithin rnd (2 ^ (-53 : ℤ)) η)
    {n : ℕ} {x y : List ℚ} (hlen : x.length = y.length)
    (hx : ∀ a ∈ x, OnGrid64 a) (hy : ∀ b ∈ y, OnGrid64 b)
    (hnx : ∀ a ∈ x, Normal64 a) (hny : ∀ b ∈ y, Normal64 b) {c W : ℤ}
    (hc : escCoarse n x y = some c) (hW : 54 + c ≤ W) (hk : 2 * (x.length : ℚ) * 2 ^ (-53 : ℤ) ≤ 1)
    {C : ℚ} (hC : rnd (fixedProduct W x y) = some C) :
    Rat.abs (C - dot x y) ≤
      (4 * x.length + 1) * 2 ^ (-53 : ℤ) * ((List.zipWith (· * ·) x y).map Rat.abs).sum + η
```

For the whole routine: whenever it returns values on normal or zero entries
of matching shapes with `k · 2^14 < 2^31`, every entry meets Grade A on the
emulated path and the classical `γₖ` bound on the native path
([`adp_accuracy`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADP.lean#L544), [`nativeEntry_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/ADP.lean#L404)).

## Findings

- **From the Z3 model**, now proved in general: zeros must have exponent `−∞`
  in the coarsened ESC; the remap range is slightly smaller than the unsigned
  range; the `+1` in `W` buys one bit in the funnel; the Inf/NaN scan must come
  before ESC. The coarsening theorem holds for every block size, and the funnel
  bound does not need the Z3 query's assumption `e_a + e_b ≤ F`.
- **Grade A needs no `u²` term:** full fidelity makes the largest product
  exact, so each product's error is half what the Z3 check allows.
- **Subnormal inputs break Grade A.** With `x = [2^-1074, 2^-1023 × 7]` and
  `y = [1, −2^-60 × 7]`, the routine emulates and returns `−2^-1074` for a
  positive exact product. The exponent clamp at `−1022` lets `2^F` exceed the
  largest product by up to `2^52`. The Z3 model of ADP fails its own
  final-rounding check on the same input, and no guardrail catches it.

## Correctly rounded

ADP rounds once, but it rounds the fixed-point product, which differs from
`x · y` where the conversion drops bits. The check of the other schemes
applies: `H` is the exactly recombined fixed-point product, `B` the
fixed-point bound, and if `H ± B` round to the same value, so does `x · y`;
otherwise a wider configuration, then the exact product ([`adpCR_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Correct.lean#L341)). On two
random binary64 test cases the check settles every entry at the slice count
ADP's own ESC rule picks (`8` and `11` slices), so correct rounding costs no
extra INT8 products there. This variant takes the `(s, W)` configurations as
given; it is not the ESC-driven routine with its guardrails, and its last
resort is exact rational arithmetic, not the engine.

## What is checked

On five cases recorded from the Z3 model (uniform and signed inputs, Test 2
with `b = 2` and `b = 64`, and an input with an infinity), the Lean routine
takes the same path and returns the same values, with the same ESC, `W` and
slice count on the emulated cases.

## What the proof assumes

- The INT8 engine is an idealized wrapping register, not a hardware-validated
  INT8 instruction model; there is no AMD INT8 model.
- The routine follows the Z3 model of the paper, not cuBLAS's implementation.
- Grade A is proved for normal or zero entries, with an underflow term; there
  is no theorem that the routine always returns values.
