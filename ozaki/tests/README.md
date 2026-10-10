# Tests

`lake build` builds both test libraries, so every check below runs on every build. Each check is
an `example` proved by kernel evaluation (`decide +kernel`) of the definitions the theorems are
about.

## The Z3 models' outputs

The Z3 models of the schemes emulate a binary32
`4 × 4` GEMM on two test cases drawn with `random.Random(2026)`: exponents in `[2^-1, 2^1]`
("narrow") and in `[2^-6, 2^6]` ("wide"). [`scripts/z3_reference.py`](../scripts/z3_reference.py)
imports the two models from an unmodified clone (commit `dfe24cf`), regenerates both cases as their
`main()` does, runs `ozaki1_gemm` with four slices and `ozaki2_gemm` with four moduli, and records
every input and output as a binary32 word in
[`data/z3-reference.json`](../data/z3-reference.json).

[OzakiTCTests/Z3Matrices.lean](OzakiTCTests/Z3Matrices.lean) checks that the Lean pipelines on the
V100 Tensor Core model return the same words: Ozaki-I with four `11`-bit slices (ten V100 slice
products per entry) and Ozaki-II with moduli `{4096, 4095, 4093, 4091}` and `P = 22`, on both
cases. Every engine call in these pipelines is exact (`Ozaki.TC.v100_exactOn`), so agreement with
the Z3 models, whose engine rounds every addition, is expected; the test checks it on the actual
words, including the binary32 recombination order. The same file checks that the slices computed
with binary32 σ-trick operations, as the Z3 model computes them, equal the exact slices of the
scheme library on every row of `A` and column of `B`.

[OzakiMCTests/Z3Matrices.lean](OzakiMCTests/Z3Matrices.lean) runs the same comparison on the AMD
models: the binary32 SFMA, CDNA 1, 2 and 3 fp16, and CDNA 3 XF32 return the Z3 models' words for
both schemes on both cases (twenty checks), and a bf16 path, which cannot encode `11`-bit slices,
returns `none`.

## All eight GPU paths

[OzakiTCTests/AllPaths.lean](OzakiTCTests/AllPaths.lean) runs the Z3 cases on every Tensor Core
path. The A100 and H100 fp16 paths and the three tf32 paths return the Z3 models' words for both
schemes and both cases. The two bf16 paths return `none` with `11`-bit slices; with `8`-bit slices
(and moduli `{512, 511, 509, 503}`, `P = 16` for Ozaki-II) they return the exact-engine result.

## Accuracy

[OzakiTCTests/Accuracy.lean](OzakiTCTests/Accuracy.lean) (V100) and
[OzakiMCTests/Accuracy.lean](OzakiMCTests/Accuracy.lean) (CDNA 3 fp16) check the Z3 models' measured
comparisons on their matrices: four slices are at least as accurate as one (`I:[M.2]`), four
moduli at least as accurate as one (`II:[M.3]`), and every componentwise and normwise error the Z3
models print in their `output.txt` is reproduced to within `±0.0005`. These are facts about the
test matrices, not theorems: more slices need not help on every input.

## ADP against the Z3 model

[`scripts/z3_adp_reference.py`](../scripts/z3_adp_reference.py) imports the Z3 ADP model
(`ozaki-NVIDIA/adp.py`) from the unmodified clone, runs five cases (uniform and signed inputs, Test 2
with `b = 2` and `b = 64`, and an input with an infinity) and records inputs, outputs, path, ESC, `W` and
slice count in [`data/z3-adp-reference.json`](../data/z3-adp-reference.json).
[OzakiTCTests/ADPMatrices.lean](OzakiTCTests/ADPMatrices.lean) checks that `Ozaki.TC.adp` takes the
same path and returns the same values in every case, with the same ESC, `W` and slice count on the
three emulated ones. The values are compared as rationals, so the sign of a zero is not checked.

## Correct rounding against exact arithmetic

[`scripts/correct_reference.py`](../scripts/correct_reference.py) computes correctly rounded
products with exact fractions and its own round to nearest even, sharing no code with Lean, and
records them in [`data/correct-reference.json`](../data/correct-reference.json): the two Z3 cases,
a product with heavy cancellation (`x · y = 2^-40` with `max|x| = 1`), a product exactly halfway
between two binary32 values, and two random binary64 `4 × 8` by `8 × 4` products.

[OzakiTCTests/Correct.lean](OzakiTCTests/Correct.lean) checks that the correctly rounded schemes
return exactly these words: Ozaki-I (three, then four slices) and Ozaki-II (five, then six moduli)
on V100, ADP on the INT8 engine (`7`, `8`, then `9` slices), and Ozaki-I with its exact path on V100
blocks, including a run where every entry takes the exact path. It also counts how often the check
settles an entry without the exact path: Ozaki-I settles every Z3 entry with four slices and all
but two with three; Ozaki-II settles none with the Z3 models' four moduli (`P = 22`), 12 and 9 of 16
with five, all with six; ADP settles every entry of both binary64 cases at the configuration its own
ESC rule picks (`8` slices of width `56`, `11` of width `81`), and 5 and 11 of 16 on `wide64` with
`8` and `9` slices. These counts are what the fast path achieves; the theorems hold regardless,
because the last resort is exact.
[OzakiMCTests/Correct.lean](OzakiMCTests/Correct.lean) checks the same words on the SFMA, CDNA 1, 2
and 3 fp16 and CDNA 3 XF32 paths.

## Long dot products and FP64

[OzakiTCTests/LongFP64.lean](OzakiTCTests/LongFP64.lean) checks FP64 emulation on V100 fp16 blocks
against the binary64 oracle cases (`k = 8`, so split-K runs two chunks of four per slice product):
correctly rounded Ozaki-I (five, then six slices, then the exact path on V100 blocks) on both
cases, correctly rounded Ozaki-II with twelve moduli at most `4096` (`P = 69`), and plain Ozaki-I
with binary64 recombination and six slices within `2^-50 Σ|xᵢyᵢ|` of the exact product. The
correctly rounded Ozaki-I results are also checked with the check running on a `96`-bit window
sum instead of the exact sum (`tcOzaki1CRDW`).
[OzakiMCTests/LongFP64.lean](OzakiMCTests/LongFP64.lean) checks correctly rounded Ozaki-I on CDNA 3
fp16 against the same oracle values; `MatrixCore` has no binary64 decoding, so the test decodes the
words itself.

## Bounded registers

[OzakiTCTests/Bounded.lean](OzakiTCTests/Bounded.lean) (V100 fp16) and
[OzakiMCTests/Bounded.lean](OzakiMCTests/Bounded.lean) (CDNA 3 fp16) run correctly rounded FP64
Ozaki-I with its check, exact path and final rounding in bounded integer registers
(`tcOzaki1CRBD`, `mcOzaki1CRBD`) on both binary64 oracle cases and return the oracle's words: once
with the check settling entries (five, then six slices, a `96`-bit window), and once with no check
(`ss = []`), so that every entry goes through the bounded exact path. The library files carry their
own kernel checks of the integer pieces: a register that wraps mid-sum, ties, binary32 normal,
subnormal and overflowing results, heavy cancellation, a tie after cancellation, and an end-to-end
binary32 tie through the exact path.

## Signed zeros

[OzakiTCTests/Signed.lean](OzakiTCTests/Signed.lean) (V100) and
[OzakiMCTests/Signed.lean](OzakiMCTests/Signed.lean) (CDNA 3 fp16) run correctly rounded FP64
Ozaki-I with signed zeros (`tcOzaki1CRDS`, `mcOzaki1CRDS`) on three inputs whose result is zero, and
check each against the specification `crSigned` and the expected IEEE result: products that are all
`−0` give `−0`, products that cancel exactly give `+0`, and a negative product that underflows
(`2^-540 · (−2^-540)`) gives `−0`.

## ADP's guardrail and the INT8 exact path

[OzakiTC/ADPFix.lean](../OzakiTC/ADPFix.lean) carries its own kernel checks: on the subnormal
counterexample `adp` returns `−2^-1074` for a positive product, `adpSafe` takes the native path and
returns the correctly rounded `2^-1074`, and `adpCRE` returns `2^-1074` through its exact path on the
INT8 engine after the enclosure of `8` slices fails to settle it; on the five recorded Z3 cases
`adpSafe` returns what `adp` returns.

## Axiom audits

[OzakiTCTests/Audit.lean](OzakiTCTests/Audit.lean) and [OzakiMCTests/Audit.lean](OzakiMCTests/Audit.lean)
check that every theorem in the `Ozaki` namespace, of the scheme library and of the respective
instantiation, depends only on `propext`, `Classical.choice` and `Quot.sound`.
