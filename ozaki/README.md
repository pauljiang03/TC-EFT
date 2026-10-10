# Ozaki schemes on TC-EFT's Tensor Core and Matrix-Core models

This Lean project formalizes the Ozaki schemes for emulating a high-precision matrix product on a
low-precision matrix engine, following a set of bit-precise Z3 models of the schemes (the "Z3
models" below):

* **Ozaki-I** (Ozaki, Ogita, Oishi and Rump, 2012): error-free slicing into small integers, exact
  slice products on the engine, and recombination;
* **Ozaki-II** (Ozaki, Uchino and Imamura, 2025): scaling to integers, one engine product per
  modulus, and Chinese-remainder reconstruction;
* **ADP and ESC** (Schwarz et al., NVIDIA, arXiv:2511.13778): Ozaki-I on INT8 engines, with the
  unsigned slice encoding and the exponent span capacity.

The Z3 models take the engine to be fp16 inputs with binary32 round-to-nearest additions. Here
the engine is the hardware model of this repository: the NVIDIA Tensor Core model of
[`TensorCore`](../README.md) and the AMD matrix-core model of [`MatrixCore`](../amd/README.md).
The scheme itself is proved once, for any engine, and each hardware model is shown to satisfy
what the scheme needs. Every labelled check of the three Z3 models has a Lean theorem or a
kernel-checked test, except the ones listed under [what is not proved](THEOREMS.md#not-proved).

Beyond the Z3 models:

* **Long dot products.** Split-K (chunks of the inner dimension, each an exact engine call, added
  exactly) lifts the engine's limit `k · 2^(2b) ≤ 2^24`, so every result holds for every `k`.
* **FP64 emulation** on fp16, bf16 and tf32 Tensor Cores and on AMD matrix cores: Ozaki-I and
  Ozaki-II on binary64 inputs, with binary64 error bounds and correctly rounded binary64 results.
* **Correct rounding.** All three schemes have a variant that returns the round to nearest even of
  the exact product for every input on which the engine is exact ([below](#correct-rounding)).

[What is proven](THEOREMS.md) · [Tests](tests/README.md) · [Examples](examples/README.md)

## Build and run

`ozaki/` is a standalone Lake project that requires the two models by path (`..` and `../amd`);
all three use Lean 4.33.1. From this directory:

```sh
lake build
lake env lean examples/TensorCore.lean
lake env lean examples/MatrixCore.lean
python3 scripts/check.py
```

`lake build` builds the three libraries and the two test libraries, which check the Z3 models'
recorded outputs and an exact-arithmetic oracle by kernel evaluation, and audit the axioms.
`scripts/check.py` also checks the examples and every Lean block in the documentation.

## Layout

| Import / directory | What belongs here |
| --- | --- |
| [`Ozaki`](Ozaki.lean) | The schemes for any engine: slicing, recombination and its error, CRT reconstruction, Ozaki-II and its error, ADP's slice encoding, ESC, fixed point and Grade-A bound, native GEMM's bound, when each scheme returns a value, split-K, correct rounding with an exact or a two-word window accumulator, a hardware-independent IEEE round to nearest for any binary format, and the Z3 models' parameters. It imports only Lean's standard library. |
| [`OzakiTC`](OzakiTC.lean) | The NVIDIA instantiation: exact integer blocks and chains on the Tensor Core model, the engine on all eight GPU paths, split-K, the two-pass recovery of full groups, binary32 and binary64 rounding, the binary32 σ-trick, both schemes in binary32 and FP64, the INT8 engine and the full ADP routine, the correctly rounded schemes, and witnesses of where the conditions bind. |
| [`OzakiMC`](OzakiMC.lean) | The AMD instantiation: exact integer blocks, chains and inner products on the CDNA 1, 2 and 3 models, the engine on the SFMA, fp16, bf16 and XF32 paths, split-K, binary32 rounding, both schemes in binary32 and FP64 and their correctly rounded variants, and witnesses of where the conditions bind. |
| [`tests/`](tests/README.md) | Regression tests against the Z3 models' outputs and an exact-fraction oracle, and the axiom audits. |
| [`examples/`](examples/README.md) | Worked examples. |
| [`data/`](data/) | The Z3 models' inputs and outputs, and correctly rounded reference products, as binary32 and binary64 words. |
| [`scripts/`](scripts/) | `check.py` (validation); `z3_reference.py`, `z3_adp_reference.py` and `correct_reference.py` (record `data/`). |

`TensorCore` and `MatrixCore` cannot be imported into the same file: both declare the `ℕ ℤ ℚ`
notation and their own arithmetic. `Ozaki` therefore uses Lean's types directly, so it can be
imported beside either, and `OzakiTC` and `OzakiMC` are separate libraries.

## The scheme for one output entry

Every entry of `C = AB` is a dot product `x · y` of a row of `A` and a column of `B`, and the
schemes treat each entry separately. An `Engine` is a function from two integer vectors to the
value the hardware returns; `Engine.ExactOn b budget` says it returns `Σ xᵢyᵢ` exactly for entries
of magnitude at most `2^b` whose products total at most `budget`.

* Ozaki-I splits `x` into `s` slices `2^gₜ qₜ` of integers with `|qₜ,ᵢ| ≤ 2^b`, multiplies the
  `s(s+1)/2` pairs with `t + u < s`, and adds the scaled products. With an exact engine the error
  is exactly `r · y + Σₜ 2^gₜ (qₜ · r'ₛ₋ₜ)`, which gives `|x · y − C| ≤ (s + 1) k 2^(E + F − s(b+1))`
  before the additions (`Ozaki.exactTerms_error`).
* Ozaki-II truncates `x` and `y` to `P`-bit integers `a` and `c`, computes `a · c` modulo each
  modulus on the engine, reconstructs it exactly when `2 k 2^(2P) < M` (`Ozaki.crt_eq`), and
  rounds once. The only approximation is the truncation (`Ozaki.truncProduct_error`).
* ADP converts each row and column to `W`-bit fixed point (`W = 53 + ESC + 1`), cuts the integers
  into byte slices, multiplies all `s²` slice pairs on an INT8 engine, recombines exactly and rounds
  once to binary64. For normal or zero entries, with full fidelity on the largest product, the
  result meets the paper's Grade-A bound `|C − x · y| ≤ (4k + 1) 2^-53 Σ|xᵢyᵢ|` plus an underflow
  term (`Ozaki.ADP.emulated_gradeA`). Subnormal entries can break it (see the findings).

## Long dot products and FP64

An engine call is exact while its products total at most `2^24`, which allows only four terms of
`11`-bit slices. Split-K cuts the inner dimension into chunks of `2^(24 − 2b)` terms (four for
`11`-bit slices, `256` for `8`-bit), runs each chunk on the engine, and adds the integer chunk
results exactly; it is exact for every length (`Ozaki.chunked_exactOn`). On the Tensor Core model
the chunk results can be accumulated in TC-EFT's fixed-width register, exact while the products
total less than `2^63` in a 64-bit register (`Ozaki.TC.tcSplitKReg_exactOn`).

With split-K:

* Ozaki-I's binary32 error bound holds for every `k` (`Ozaki.TC.tcOzaki1L_error`,
  `Ozaki.MC.mcOzaki1L_error`);
* **FP64 emulation**: Ozaki-I with binary64 recombination has the same bound with `u = 2^-53`
  (`Ozaki.TC.tcOzaki1D_error`, `Ozaki.MC.mcOzaki1D_error`), and Ozaki-I and Ozaki-II return the
  correctly rounded binary64 product for binary64 inputs of any length on every exact path
  (`Ozaki.TC.tcOzaki1CRD_eq`, `Ozaki.TC.tcOzaki2CRD_eq`, `Ozaki.MC.mcOzaki1CRD_eq`,
  `Ozaki.MC.mcOzaki2CRD_eq`), for example on V100 fp16 with `11`-bit slices and on A100 bf16 with
  `8`-bit slices (`Ozaki.TC.v100_fp64CR`, `Ozaki.TC.a100BF16_fp64CR`).

`MatrixCore` has no binary64 arithmetic, so FP64 results use `Ozaki.rne64`, a hardware-independent
IEEE round to nearest even proved for any binary format (`Ozaki.roundRNE_nearest`), with IEEE
overflow: values that round to at most the largest finite value succeed.

## Correct rounding

Each scheme holds an exact value `H` before its last rounding (the slice products added exactly,
the reconstructed product, the recombined fixed-point product) and a proved bound
`B ≥ |x · y − H|`. If `H − B` and `H + B` round to the same value, so does `x · y`, which lies
between them: rounding to nearest is monotone, which Lean proves from the nearest-value property
alone (`Ozaki.round_monotone`). Otherwise the next configuration is tried, more slices or moduli,
and then an exact path (`Ozaki.certify_eq`). The structure is TC-EFT's guarded fast path with an
exact fallback; the check itself is Ziv's rounding test.

There are two kinds of variants, and the difference matters:

* `Ozaki.ozaki1CR_eq`, `Ozaki.ozaki2CR_eq`, `Ozaki.TC.adpCR_eq` fall back to the exact rational
  `x · y`, computed off the engine. Their theorems would hold for a scheme that never calls the
  engine; their content is that the engine's enclosures are sound.
* `Ozaki.ozaki1CRE_eq`, `Ozaki.ozaki2CRE_eq` and their hardware instances (`*CRE`, `*CRL`, `*CRD`)
  take the exact path on the engine: Ozaki-I with all `s²` slice products is exact once nothing is
  left over (`Ozaki.ozaki1Full_eq`), and inputs on a grid `2^m` leave nothing over after enough
  slices (`Ozaki.split_residual_zero`): `24` slices of `11` bits for binary32, `175` for binary64.
  Every engine product, including the exact path's, then runs on Tensor Core or matrix-core
  blocks. The slicing and the check are exact arithmetic in the proofs.

**The check needs only a small accumulator.** Correct rounding has to decide only on which side of
the nearest rounding boundary `x · y` lies, so the sum of the slice products need not be exact:
round each scaled product down to a window of `W` bits below the largest possible product, add
them exactly, and add the window's loss to `B` (`Ozaki.ozaki1CRW_eq`). The window sum needs
`W + log₂ (s(s+1)/2 · (k + 1)) + 1` bits whatever the inputs' exponents
(`Ozaki.ozaki1Window_register`): with `W = 96`, up to seven `11`-bit slices and `k ≤ 2^14`, under
two 64-bit words, for binary32 and FP64 alike (`Ozaki.TC.tcOzaki1CRDW_eq`,
`Ozaki.MC.mcOzaki1CRDW_eq`, `Ozaki.TC.v100_fp64CRW`). Only the exact path, taken by entries the check
cannot settle, adds slice products exactly; for inputs spanning the whole exponent range that sum
is wide (about `580` bits for binary32, `Ozaki.exactTerms_sum_register32`).

What the check itself achieves is a separate theorem: the engine's enclosure settles an entry
whenever `x · y` lies at least `2B` from every rounding boundary (`Ozaki.roundEnclosure_of_margin`,
`Ozaki.ozaki1Enclosure_settles`). On the test matrices:

* Ozaki-I settles every Z3 entry with four slices and all but two with three;
* Ozaki-II with the Z3 models' four moduli (`P = 22`) settles none, five moduli settle 21 of 32,
  six settle all;
* ADP settles every entry at the configuration its own ESC rule picks for the two random binary64
  cases (`8` and `11` slices), and fewer with fewer slices.

The binary32 and binary64 roundings differ between the variants. The Z3-configuration variants
(`tcOzaki1CR`, `tcOzaki1CRE`, `mcOzaki1CRE`, …) use each library's rounding. TensorCore's fails
above the largest finite value, where IEEE rounds values below `2^128 − 2^103` down to it, so on
that band the Tensor Core variants return `none` and the AMD ones a value. The any-`k` variants
(`*CRL`, `*CRD`) use `Ozaki.rne32Q` and `Ozaki.rne64`, the same IEEE rounding on both vendors, so
for the same inputs they return the same value. In every case the check runs on exact values,
never on a Tensor Core, whose output is not monotone in its inputs (TC-EFT's non-monotonicity
theorems).

## On the Tensor Core model

The Tensor Core aligns every product to the group's largest exponent, keeps `F` bits below it
(`F = 23` on V100, `24` on A100, `25` on H100), adds exactly, and truncates to binary32. For
integer operands this loses nothing when `2b ≤ F` and `|c| + Σ|aᵢbᵢ| ≤ 2^24`
(`Ozaki.TC.evalBlock_int`), also across chained groups (`Ozaki.TC.runBlocks_int`). With fp16 or
tf32 operands `b = 11`, with bf16 `b = 8`, and every path satisfies `2b ≤ F`
(`Ozaki.TC.v100_exactOn` and seven more). The Z3 models' `4 × 4` configuration therefore runs
exactly on V100: four `11`-bit slices for Ozaki-I, moduli `{4096, 4095, 4093, 4091}` with `P = 22`
for Ozaki-II (`Ozaki.TC.v100_ozaki1_z3`, `Ozaki.TC.v100_ozaki2_z3`). On the Z3 models' own test
matrices the Lean pipelines return the same binary32 words as the Z3 models on all six fp16 and
tf32 paths ([tests](tests/README.md)).

What changes from the Z3 models:

* **The budget comes from the output, not the accumulator.** The Z3 engine rounds every partial
  sum to binary32; the Tensor Core adds a group exactly and rounds once. On the Tensor Core only
  the final sum must fit binary32: an A100 group is exact on products whose binary32 running sum
  is not (`Ozaki.TC.a100_exact_where_binary32_is_not`).
* **Full groups on A100 and H100 exceed the budget.** With `11`-bit slices, `k · 2^22 ≤ 2^24`
  allows four products; A100 and H100 groups take eight and sixteen, and seven products `2047²`
  already lose a bit (`Ozaki.TC.a100_full_group`). Split-K with chunks of four, `10`-bit slices,
  or at most four nonzero products per group restore exactness.
* **Two passes recover a full group exactly (a TC-EFT technique).** Run the group once from
  `c = 0`, giving `D1`, the truncation of the exact sum `S`; run it again from `c = −D1`. Because
  `c` takes part in alignment (the mechanism behind TC-EFT's non-monotonicity), the second pass is
  exact as long as `|D1| ≤ 2^(F+1)`, and it returns `S − D1`, so `D1 + D2 = S`
  (`Ozaki.TC.twoPass_exact`). `F` grows by one bit each time the group size doubles, so a full
  group of `11`-bit products always fits: `8 · 2^22 = 2^25` on A100, `16 · 2^22 = 2^26` on H100.
  The two-pass engine is exact for every length on both (`Ozaki.TC.a100F16_exactOn2`,
  `Ozaki.TC.h100F16_exactOn2`); on H100 it needs half the Tensor Core calls of split-K with chunks
  of four.
* **The σ-trick.** For a binary32 `a` with `|a| ≤ 2^(g+b)`, `b ≤ 21` and `−149 ≤ g ≤ 104`,
  `fl(fl(a + σ) − σ)` is `a` rounded to the grid `2^g` and `fl(a − hi)` is exact
  (`Ozaki.TC.sigma_split`); the remainder is exact for every grid
  (`Ozaki.TC.finiteValue32_sub_round`). The Z3 lemma covers `|a| ≤ 1`. A split computed with
  binary32 operations equals the scheme's split when every grid lies in `[−149, 104]`
  (`Ozaki.TC.splitFrom32_eq`). Outside that range (σ overflows above about `2^115`, and the long
  exact paths reach grids far below `2^-149`), the proofs' slicing is exact arithmetic, not the
  σ-trick.
* **INT8 engines as fixed-width registers.** ADP's engine is a 32-bit wrapping accumulator
  (TC-EFT's `machineAccumulate 32`) over exact integer products, not a model of an INT8 Tensor
  Core instruction. It is exact on byte operands within `2^31` and wraps at 16 bits
  (`Ozaki.TC.int8Dot_bytes`, `Ozaki.TC.int8Dot_16_wraps`), and Ozaki-I on it is one binary64
  rounding of the exact fixed-point product (`Ozaki.TC.int8Ozaki_eq`).
* **The whole ADP routine.** `Ozaki.TC.adp` follows the Z3 model `adp.py` step by step: scan for
  non-finite inputs, matrix ESC, width, slice count, the speed heuristic, then emulation or native
  binary64. Whenever it returns values on normal or zero entries of matching shapes with
  `k · 2^14 < 2^31`, every entry meets Grade A on the emulated path and the native `γₖ` bound
  otherwise (`Ozaki.TC.adp_accuracy`). On the five cases recorded from the Z3 model it takes the
  same path and returns the same values. `adpCR` is correctly rounded fixed-point Ozaki-I on the
  INT8 engine with given `(s, W)`, not the ADP routine with its ESC and guardrails.

## On the matrix-core model

A CDNA block computes `S_acc` by one of three configurations and rounds it once to binary32 with
round to nearest: CDNA 1 sums exactly, CDNA 2 rounds a pairwise tree of binary32 products and
flushes subnormals, and CDNA 3 aligns the products to `24` fractional bits and adds `c` late with
two rounding-down steps. For integer operands and an integer `c` with `|c| + Σ|aᵢbᵢ| ≤ 2^24`, all
three return `c + Σ aᵢbᵢ` exactly (`Ozaki.MC.evalBlock_int`), across chained blocks and inner
products of any length (`Ozaki.MC.runBlocks_int`, `Ozaki.MC.dotBits_int`). The engine is exact on
the binary32 SFMA (`b ≤ 24`), CDNA 1, 2 and 3 fp16 and CDNA 3 XF32 (`b ≤ 11`), and the bf16 paths
(`b ≤ 8`) (`Ozaki.MC.cdna3F16_exactEngine` and the others in
[`OzakiMC/Profiles.lean`](OzakiMC/Profiles.lean)); CDNA 3's fp8 paths are not covered.

On the Z3 models' test matrices, every path with `11`-bit slices returns the Z3 models' binary32
words for both schemes ([tests](tests/README.md)). The binary32 SFMA, which rounds after every
product, is the Z3 models' engine: binary32 products accumulated with round to nearest.

What the model shows:

* **The same budget as on the Tensor Core.** Alignment never loses bits of integer products within
  `2^24`; the bound is set by the binary32 output.
* **bf16 paths need `8`-bit slices**: bf16 holds `256` but not `2047`
  (`Ozaki.MC.bfloat16_holds_256`).
* **A full CDNA 3 group of `11`-bit products exceeds the budget**: seven products `2047²` total
  `29331463`, which the final round to nearest returns as `29331464`, where the Tensor Core,
  which truncates, returns `29331462` (`Ozaki.MC.cdna3F16_full_group`).
* **The fp16 paths are exact where the SFMA is not**: products `5 × 2047², 1, −2 × 2047²` give the
  exact `12570628` on CDNA 1, 2 and 3 fp16, and `12570626` on the SFMA
  (`Ozaki.MC.fp16_exact_where_sfma_is_not`).
* **CDNA 2 does not round inside an Ozaki block.** Four products of `11`-bit integers total at
  most `2^24`, so every node of the pairwise tree is exact (`Ozaki.MC.pairTree_int`).

## Findings from formalizing

* The Ozaki-I error has a closed form: pairing slice `t` of `x` with the residual of `y` after
  `s − t` slices gives the exact identity behind the bound above, without enumerating the omitted
  slice pairs.
* At `P = 23` the Z3 counterexample to CRT reconstruction is `c = M` itself, whose residues are
  all zero (`Ozaki.crt_fails_at_23`).
* The ESC coarsening theorem holds for every block size, and its funnel bound does not need the
  Z3 query's assumption `e_a + e_b ≤ F` (`Ozaki.ADP.coarseEst_le`, `Ozaki.ADP.funnel`).
* Grade A needs no `u²` term: full fidelity makes the largest product exact, so each product's
  fixed-point error is at most `2^(F−52)`, half what the Z3 check allows (`Ozaki.ADP.term_bound`).
* **ADP's guarantee needs normal inputs.** With a subnormal entry, `x = [2^-1074, 2^-1023 × 7]`
  and `y = [1, −2^-60 × 7]`, the Lean model of ADP takes its emulated path and returns `−2^-1074`
  for a positive exact product, breaking Grade A even with its underflow term; the exponent clamp
  at `−1022` lets `2^F` exceed the dominant product by up to `2^52`. The unmodified Z3 model fails
  its own final-rounding check `[R.2]` on the same input. No guardrail of the routine catches it.
* Correct rounding is cheap where a scheme already carries margin: the Z3 configuration's fourth
  Ozaki-I slice, which adds nothing at binary32 output precision, lets the check settle every
  entry, and ADP's own ESC choice settles every entry of the random binary64 tests. Ozaki-II with
  `P = 22` carries no margin: none of its results on the Z3 matrices is correctly rounded.

## Scope

The proofs concern the models. That GPUs behave like them rests on the validation of `TensorCore`
and `MatrixCore`. As in the Z3 models, the CRT residues and reconstruction are exact integer
arithmetic; Ozaki-I's power-of-two rescaling is proved exact when its exponent is in range
(`Ozaki.TC.scaled_slice_product_exact`). Not covered: FP8 paths, an INT8 Tensor Core instruction
model, and signed zeros. [THEOREMS.md](THEOREMS.md#not-proved) lists the rest.
