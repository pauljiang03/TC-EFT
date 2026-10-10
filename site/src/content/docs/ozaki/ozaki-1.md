---
title: Ozaki-I, proved end to end
description: The complete Lean proof of Ozaki-I on the Tensor Core and AMD matrix-core models, from exact slicing to the binary32 or binary64 result, for dot products of any length, and a variant that is always correctly rounded.
---

Ozaki-I (Ozaki, Ogita, Oishi and Rump, 2012) computes a high-precision matrix
product on a low-precision matrix engine. It cuts every input into a few
slices of small integers, multiplies slices on the engine, where products of
small integers are exact, and adds the scaled products. This page follows the
whole proof, from the slicing of the inputs to the value the hardware returns.
Every step is a Lean theorem in the [`ozaki/`](https://github.com/pauljiang03/TC-EFT/tree/main/ozaki)
project, which depends on the Tensor Core model of this repository and on the
AMD matrix-core model in `amd/`. Lean checks all of it with only its standard
axioms.

The project follows a set of bit-precise Z3 models of the schemes. A Z3 runtime
assertion checks one fact on its test matrices; the Lean theorem states it for
every input. Each Z3 label (`[S1.13]`, `[M.3]`, …) maps to a Lean theorem or a
kernel-checked test in
[`ozaki/THEOREMS.md`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/THEOREMS.md),
which also lists what is not proved.

## The algorithm for one output entry

Every entry of `C = AB` is a dot product `x · y` of a row of `A` and a column
of `B`, with `k` terms, and Ozaki-I treats each entry separately. It has two
parameters: `b`, the bits per slice, and `s`, the number of slices.

1. **Split** `x` into `s` slices on decreasing power-of-two grids,
   `x = Σₜ 2^gₜ qₜ + r`, where every `qₜ` is a vector of integers of magnitude
   at most `2^b` and `r` is what is left. Split `y` the same way into `2^hᵤ pᵤ`.
2. **Multiply** the `s (s + 1) / 2` slice pairs with `t + u < s` on the engine:
   the integer dot products `qₜ · pᵤ`.
3. **Add** the products, each scaled by `2^(gₜ + hᵤ)`, in binary32 (or binary64
   for FP64 emulation), smallest first.

The Z3 models use `k = 4`, `b = 11` and `s = 4`: ten engine products per entry.

## Step 1: the slicing is exact

Slice `t` rounds what the previous slices left to the nearest multiple of
`2^gₜ`, where `gₜ = ⌈log₂ max|·|⌉ − b`. Four facts carry the rest of the proof:

| Fact | Lean |
| --- | --- |
| The slices and the residual add up to `x` exactly, as a statement about every dot product `x · y`. | [`split_dot`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Split.lean#L250) |
| Every slice coefficient is an integer of magnitude at most `2^b`. | [`split_coeff_bound`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Split.lean#L254) |
| Slice `t` lies at least `t (b + 1)` bits below the first: every slice gains `b + 1` bits. | [`split_grid_le`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Split.lean#L257) |
| The residual after `s` slices is at most `2^(E − s(b+1))`, with `E = ⌈log₂ max\|x\|⌉`. | [`split_residual_le`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Split.lean#L264), [`splitExp_spec`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Split.lean#L238) |

```lean
theorem split_dot (b s : ℕ) (x y : List ℚ) :
    dot x y = ((split b s x).1.map fun sl => 2 ^ sl.grid * dot (ofInts sl.coeffs) y).sum +
      dot (split b s x).2 y
```

The proofs slice in exact arithmetic. On binary32 hardware the rounding to a
grid is the σ-trick `hi = fl(fl(a + σ) − σ)` with `σ = 3 · 2^(g+22)`, and the
remainder `fl(a − hi)`. Lean proves that this computes exactly the slice above
for every binary32 `a` with `|a| ≤ 2^(g+b)`, `b ≤ 21` and every grid
`−149 ≤ g ≤ 104` ([`sigma_split`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Split32.lean#L169)); that the remainder needs no range condition
at all ([`finiteValue32_sub_round`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Split32.lean#L90)); and that a whole split computed with
binary32 operations is the split of the proof when every grid is in that range
([`splitFrom32_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Split32.lean#L261)). The Z3 lemma covers `|a| ≤ 1`.

## Step 2: every slice product is exact on the hardware

An `Engine` is a function from two integer vectors to the value the hardware
returns. `Engine.ExactOn b budget` says it returns `Σ xᵢyᵢ` exactly when every
entry has magnitude at most `2^b` and the products total at most `budget`.

On the Tensor Core model, the engine encodes the integers as fp16, bf16 or
tf32 words, pads them to groups, and chains the groups through `C`, starting
from zero. Integer operands lose nothing in alignment when `2b ≤ F` (`F = 23`
on V100, `24` on A100, `25` on H100), and the binary32 output holds every
integer up to `2^24`:

| Fact | Lean |
| --- | --- |
| A block of integer operands with `\|c\| + Σ\|aᵢbᵢ\| ≤ 2^24` returns `c + Σ aᵢbᵢ` exactly. | [`Ozaki.TC.evalBlock_int`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Exactness.lean#L184) |
| So does a chain of blocks. | [`Ozaki.TC.runBlocks_int`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Exactness.lean#L335) |
| The engine is exact on `b`-bit vectors whose products total at most `2^24`, on any path with `2b ≤ F` whose input format holds `b`-bit integers. | [`tcEngine_exactOn`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Engine.lean#L193) |
| This holds on all eight GPU paths, with `b = 11` for fp16 and tf32 and `b = 8` for bf16. | [`v100_exactOn`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Profiles.lean#L31) and seven more |

```lean
theorem tcEngine_exactOn {p : Profile} {b : ℕ} (hp : IntExact p b) (hh : HoldsInts p b)
    (hK : 0 < p.products) : (tcEngine p).ExactOn b (2 ^ 24)
```

The same holds on the AMD model for the binary32 SFMA, CDNA 1, 2 and 3 fp16,
CDNA 3 XF32 and the bf16 paths ([`mcEngine_exactOn`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiMC/Engine.lean#L326)).

**What the hardware models add.** That a slice product must fit the binary32
output is the familiar slice-width rule of the Ozaki literature. The models
prove it on each path and show why it is the output, not the accumulator, that
sets it: a Tensor Core adds a whole group exactly and rounds once, so an A100
block is exact on products whose binary32 running sum is not
([`a100_exact_where_binary32_is_not`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Limits.lean#L62)), while the Z3 engine rounds every
partial sum. The models also show where the budget bites: a full A100 or H100
group of `11`-bit products can exceed it, and seven products `2047²` already
lose a bit ([`a100_full_group`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Limits.lean#L51)).

## Step 3: what the slicing leaves out, exactly

With exact slice products, the only error before the additions is the slice
pairs Ozaki-I skips and the residuals. Lean proves an exact identity for it:
pairing slice `t` of `x` with the residual of `y` after `s − t` slices accounts
for every skipped pair at once ([`dot_eq_exactTerms_add`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Ozaki1.lean#L194)):

```text
x · y − Σ_{t+u<s} 2^(gₜ+hᵤ) (qₜ · pᵤ) = r · y + Σₜ 2^gₜ (qₜ · r'ₛ₋ₜ)
```

Bounding each piece with Step 1 gives the slicing error
([`exactTerms_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Ozaki1.lean#L230), [`exactTerms_error_normwise`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Ozaki1.lean#L297)):

```text
|x · y − Σ terms| ≤ (s + 1) k 2^(E + F − s(b+1)) ≤ 4 (s + 1) k max|x| max|y| 2^(−s(b+1))
```

## Step 4: the additions

The scaled products are added left to right. Binary32 round to nearest returns
`q` up to `2^-24 |q| + 2^-150` ([`Ozaki.TC.round32Value_within`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Rounding.lean#L58)), and `n` such
additions lose at most `((1 + u)^n − 1) Σ|tⱼ| + n (1 + u)^n η`
([`sumWith_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Summation.lean#L116)). Every scaled slice product is itself a binary32 value when
its exponent is in range, so the scaling is exact
([`Ozaki.TC.scaled_slice_product_exact`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Scaling.lean#L57)).

## Step 5: the whole scheme

| Fact | Lean |
| --- | --- |
| Ozaki-I adds exactly the scaled exact slice products. | [`ozaki1_eq_sumWith`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Ozaki1.lean#L168), [`tcOzaki1_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Schemes.lean#L49) |
| The result is within the addition bound plus the slicing bound of `x · y`. | [`ozaki1_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Ozaki1.lean#L367), [`tcOzaki1_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Schemes.lean#L56), [`mcOzaki1_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiMC/Schemes.lean#L56) |
| The result is never Inf or NaN when the inputs are within a stated range. | [`ozaki1_isSome`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Success.lean#L112), [`tcOzaki1_isSome`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Success.lean#L37) |
| The Z3 configuration runs exactly on V100. | [`v100_ozaki1_z3`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/Schemes.lean#L105) |

```lean
theorem tcOzaki1_error {p : Profile} {b : ℕ} (hp : IntExact p b) (hh : HoldsInts p b)
    (hK : 0 < p.products) (s : ℕ) {x y : List ℚ} (hlen : x.length = y.length)
    (hk : x.length * (2 ^ b * 2 ^ b) ≤ 2 ^ 24) {v : ℚ} (hv : tcOzaki1 p b s x y = some v) :
    Rat.abs (v - dot x y) ≤
      ((1 + 2 ^ (-24 : ℤ)) ^ (trianglePairs s).length - 1) *
          ((trianglePairs s).length * (x.length * 2 ^ (splitExp b x + splitExp b y))) +
        (trianglePairs s).length * (1 + 2 ^ (-24 : ℤ)) ^ (trianglePairs s).length *
          2 ^ (-150 : ℤ) +
        ((s + 1 : ℕ) : ℚ) * x.length * 2 ^ (splitExp b x + splitExp b y - s * (b + 1))
```

## Dot products of any length, and FP64

The condition `k · 2^(2b) ≤ 2^24` above allows only four terms of `11`-bit
slices. Split-K removes it: cut the inner dimension into chunks of
`2^(24 − 2b)` terms, run each chunk on the engine, and add the integer chunk
results exactly. This is exact for every length ([`chunked_exactOn`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/SplitK.lean#L130),
[`tcSplitK_exactOn`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/LongDot.lean#L42)), and on the Tensor Core model the chunk results can be
added in TC-EFT's fixed-width register, exact while the products total less
than `2^63` in a 64-bit register ([`tcSplitKReg_exactOn`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/LongDot.lean#L74)). On A100 and H100 a
second TC-EFT technique recovers a full group of `11`-bit products exactly: run
it once from `c = 0`, then again from `c = −D1`; because `c` takes part in
alignment, the second pass returns exactly what the first truncated
([`twoPass_exact`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/TwoPass.lean#L254)). With split-K:

- Ozaki-I's error bound holds for every `k` ([`tcOzaki1L_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/LongDot.lean#L114)).
- **FP64 emulation.** With binary64 recombination the same bound holds with
  `u = 2^-53` ([`tcOzaki1D_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/LongDot.lean#L188), [`mcOzaki1D_error`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiMC/LongDot.lean#L96)), on fp16, bf16 and
  tf32 Tensor Cores and on AMD matrix cores.

## Correctly rounded Ozaki-I

Ozaki-I as above guarantees an error bound, not correct rounding. A small
addition makes it return the correctly rounded `x · y` for every input on which
the engine is exact. It follows TC-EFT's guarded fast path with an exact
fallback; the check itself is Ziv's rounding test.

1. **Keep the slice products exact.** Add them exactly instead of in binary32.
   The sum `H` is then exact, and Step 3 bounds `|x · y − H|` by `B`.
2. **Check.** If `H − B` and `H + B` round to the same word, so does `x · y`,
   which lies between them: rounding to nearest is monotone (a classical fact,
   Flocq's `Rnd_N_pt_monotone`; proved here from the nearest-value property,
   [`round_monotone`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L56), [`round_eq_of_enclosure`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L72)).
3. **Otherwise refine, then take the exact path.** Try more slices; if no
   slice count settles it, compute `x · y` exactly, also on the engine: with
   all `s²` slice products and enough slices that nothing is left over, Ozaki-I
   is exact ([`ozaki1Full_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L470)). Binary32 inputs are multiples of `2^-149`, so
   `24` slices of `11` bits always suffice; binary64 inputs need `175`
   ([`split_residual_zero`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L415)).

```lean
theorem tcOzaki1CRD_eq {p : Profile} {b : ℕ} (heng : (tcEngine p).ExactOn b (2 ^ 24))
    (hb : 2 * b ≤ 24) (ss : List ℕ) {smax : ℕ} (hsmax : 2098 < smax * (b + 1)) {x y : List ℚ}
    (hx : ∀ a ∈ x, Binary64Value a) (hy : ∀ a ∈ y, Binary64Value a)
    (hlen : x.length = y.length) :
    tcOzaki1CRD p b ss smax x y = rne64 (dot x y)
```

This is correctly rounded FP64 GEMM on fp16, bf16 or tf32 Tensor Cores for
binary64 inputs of any length ([`tcOzaki1CRD_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/LongDot.lean#L214)), and the same holds on AMD
matrix cores ([`mcOzaki1CRD_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiMC/LongDot.lean#L120)) and for binary32 ([`tcOzaki1CRL_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/LongDot.lean#L155)). These
theorems use `rne64` and `rne32Q`, a hardware-independent IEEE round to nearest
even proved for any binary format ([`roundRNE_nearest`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Binary.lean#L448)), so both vendors'
results are the same function of `x · y`.

What runs where:

- **On the hardware model:** every slice product, including those of the exact
  path.
- **In a small integer register:** the check. Correct rounding only has to
  decide on which side of the nearest rounding boundary `x · y` lies, so the
  slice products need not be added exactly: rounded down to a window of `W`
  bits and added, they need `W + log₂ (s(s+1)/2 · (k + 1)) + 1` bits whatever
  the inputs' exponents; with `W = 96`, under two 64-bit words
  ([`ozaki1CRW_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Window.lean#L135), [`ozaki1Window_register`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Window.lean#L149), [`tcOzaki1CRDW_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/OzakiTC/LongDot.lean#L266)). Only the
  exact path, for entries the check cannot settle, adds slice products
  exactly, which for inputs spanning the whole exponent range takes a wide
  register ([`exactTerms_sum_register32`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Exact64.lean#L69)).
- **Never on a Tensor Core:** the check. A Tensor Core's output is not monotone
  in its inputs ([non-monotonicity](/TC-EFT/properties/non-monotonicity/)).

How often the fast path suffices is a theorem too: the enclosure settles an
entry whenever `x · y` lies at least `2B` from every rounding boundary
([`ozaki1Enclosure_settles`](https://github.com/pauljiang03/TC-EFT/blob/main/ozaki/Ozaki/Correct.lean#L340)). On the Z3 test matrices four slices settle
every entry and three settle all but two, so correct rounding costs no extra
engine products in the Z3 configuration. These are 4 × 4 test matrices;
realistic sizes and ill-conditioned inputs, where entries reach the exact path,
are not measured.

Correctly rounded Ozaki GEMM itself goes back to Mukunoki, Ozaki, Ogita and
Imamura (ISC 2020), whose correct-rounding mode splits completely and sums with
a correctly rounded summation. What is new here is the early-exit check on a
truncated Ozaki-I, its extension to Ozaki-II and ADP, and a machine-checked
proof of all of it on models of real matrix engines.

## What is checked

- **Against the Z3 models.** On their two test cases the Lean pipelines return
  the same binary32 words as the unmodified Z3 models on the V100, A100 and
  H100 fp16 and all tf32 paths, and on the AMD SFMA, CDNA 1, 2 and 3 fp16 and
  CDNA 3 XF32 paths, by kernel evaluation.
- **Against exact arithmetic.** The correctly rounded variants return the words
  an independent Python script computes with exact fractions: on the Z3
  matrices, a product with heavy cancellation, a product exactly halfway
  between two binary32 values, and random binary64 products with `k = 8`
  (FP64 emulation with split-K) on V100 and CDNA 3.
- **Accuracy.** Four slices are at least as accurate as one on the Z3 matrices
  (`[M.2]`), and every error the Z3 models print is reproduced.
- **Axioms.** An audit confirms every theorem uses only `propext`,
  `Classical.choice` and `Quot.sound`.

## What the proof assumes

- **The hardware models.** The theorems are about the Tensor Core and
  matrix-core models; that GPUs behave like them rests on the models'
  [validation](/TC-EFT/model/validation/).
- **The engine's conditions.** Slices fit the input format (`b ≤ 11` for fp16
  and tf32, `b ≤ 8` for bf16) and `2b ≤ F`; with split-K, chunks of
  `2^(24 − 2b)` terms.
- **Exact arithmetic off the engine.** The slicing, the exact sum and the
  rounding check are exact arithmetic in the proofs; the binary32 σ-trick is
  proved only for grids in `[2^-149, 2^104]`.
- **TensorCore's rounding.** The variants that use TensorCore's binary32
  rounding fail above the largest finite value, where IEEE rounds values below
  `2^128 − 2^103` down to it; the any-length variants use the IEEE `rne32Q`
  and `rne64`.
- **Not covered.** FP8 paths, signed zeros, and the dispatch heuristics of
  production libraries.
