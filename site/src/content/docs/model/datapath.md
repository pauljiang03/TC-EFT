---
title: 9. Bitvector datapath
description: A second implementation of the model in fixed-width bitvector registers, and the proof that it returns the same output word as evalBlock on every input.
---

`evalBlock` works on exact integers and rationals. That makes it a clear
definition to prove things about, but it does not say how wide the hardware's
registers need to be. The bitvector datapath, `Datapath.evalBlock`,
computes the same group with **bitvector operations only**, in registers
whose widths come from the profile. Lean proves it returns the same FP32
word as `evalBlock`, or the same error, for **every** input on all eight
supported GPU paths.

The integer model is still the definition that all other theorems are about.
The datapath is a second implementation next to it.

## Register widths

The widths follow from the profile: the 23 FP32 mantissa bits, the `p` extra
alignment bits, and the number of products `K`.

| Register | Width | Why |
| --- | --- | --- |
| Product significand | 24 bits | an 11-bit × 11-bit product is below `2^22` |
| Exponents | 10 bits, biased by 512; 12 bits during normalization | every unnormalized exponent is between −252 and 254 |
| Aligned term | `F + 2 = 25 + p` bits | `F = 23 + p` bits after the binary point, and 2 integer bits because products are below 4 |
| Accumulator | `F + 2 + c + 1` bits, two's complement | `c = ⌊log₂ K⌋ + 1` carry bits, so the `K + 1` terms cannot overflow, plus a sign bit |

| Path | `F` | `K` | Accumulator |
| --- | --- | --- | --- |
| V100 FP16 | 23 | 4 | 29 bits |
| A100 FP16, BF16 | 24 | 8 | 31 bits |
| A100 TF32 | 24 | 4 | 30 bits |
| H100 FP16, BF16 | 25 | 16 | 33 bits |
| H100 TF32 (wmma) | 25 | 4 | 31 bits |
| H100 TF32 (mma) | 25 | 8 | 32 bits |

## The stages

[`TensorCore/Kernels/Datapath/Defs.lean`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Defs.lean)
follows the same five steps as the model:

1. **Decode.** Bit-field extraction gives the sign, the significand with its
   hidden bit, and a biased exponent. Zeros and subnormals are handled by the
   field values; an all-ones exponent field rejects the input.
2. **Multiply.** The significands are multiplied in a 24-bit register and the
   biased exponents are added. Nothing is normalized.
3. **Align.** A fold keeps the largest exponent of a nonzero term, starting
   from the profile floor. Each significand is shifted left to put `F` bits
   after the binary point, then right by the gap to the largest exponent. The
   right shift drops the bits below the grid, which is the truncation.
4. **Accumulate.** The aligned terms are negated where needed and added in the
   two's complement accumulator.
5. **Normalize and truncate.** A leading-zero count gives the exponent of the
   leading one. The FP32 exponent field is that exponent, or 1 for a
   subnormal. A shift by the difference keeps the top 24 bits and drops the
   rest. The result is out of range when the exponent field reaches 255, or
   when it is 254 with all 24 kept bits set and some dropped bit nonzero.
   Otherwise the sign, exponent field and mantissa are packed into the
   output word.

```lean
def evalBlock (path : Path) (x : BlockInput path.profile) : Except ModelError F32 := do
  if x.products.length != path.profile.products then throw .wrongProductCount
  let some c := decode32Fields x.c | throw .nonfiniteInput
  let some ps := x.products.mapM (decodeTerm path) | throw .nonfiniteInput
  let ts := cTerm c :: ps
  let e := alignExp path ts
  let some bits := normalize (accumulate path e ts) e path.alignmentBits
    | throw .accumulatorOutOfRange
  return bits
```

## The equality theorem

```lean
theorem evalBlock_eq (path : Path) (x : BlockInput path.profile) :
    Datapath.evalBlock path x = (TensorCore.evalBlock x).map (·.output.bits)
```

This holds for every input, including every rejection. The proof follows
the stages:

| Stage | Lean result | What it shows |
| --- | --- | --- |
| Decode and multiply | [`Datapath.product_spec`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Correctness.lean#L74), [`Datapath.cTerm_spec`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Correctness.lean#L105) | each bitvector term denotes the model's term exactly |
| Alignment exponent | [`Datapath.alignFold_spec`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Align.lean#L141) | the fold is the floor-raised maximum over nonzero terms |
| Align | [`Datapath.Term.truncBits_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Align.lean#L49) | each aligned register holds the model's `truncBits` |
| Accumulate | [`Datapath.accumulate_toInt`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Align.lean#L126), [`Datapath.accumulator_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Correctness.lean#L166) | the accumulator's signed value is the model's exact sum; it never overflows |
| Normalize and truncate | [`Datapath.normalize_eq`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Normalize.lean#L182) | the bitvector normalizer is `round32 .truncate`, bit for bit |

[`Normalize.lean`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Kernels/Datapath/Normalize.lean)
proves `normalize_eq` for any accumulator width from 24 to 64 bits, so it
does not depend on the profile.

## What the equality covers

- **Every output bit and every error.** The sign of zero, subnormal outputs,
  out-of-range sums, and which error is reported all match.
- **The output word, not the trace.** `evalBlock` also returns intermediate
  values such as the aligned bits and residuals; the datapath returns only
  the word. Each stage is still proved to match internally.
- **The eight supported paths.** `evalBlock` is defined for any profile; the
  datapath covers V100 FP16, A100 FP16/BF16/TF32 and H100 FP16/BF16/TF32
  (both TF32 modes). The FP64 DMMA path has no datapath.
- **The definitions are bitvectors; the proof is not.** The equivalence is
  proved by reading registers as integers (`toNat`, `toInt`), so one proof
  covers every input and every register width.

Because the output words are equal, every theorem about `evalBlock`'s output
(the error bound, non-monotonicity, the accepted inputs, agreement with the
independent specification) holds for the datapath too.

## Comparison with the SMT model of Valpey et al.

Valpey et al., [*An SMT Formalization of Mixed-Precision Matrix
Multiplication: Modeling Three Generations of Tensor
Cores*](https://arxiv.org/abs/2502.15999), model the same pipeline in SMT
bitvectors: exact products, alignment to the largest exponent with the
shifted-out bits discarded, carry bits for the sum, no intermediate
normalization, and a final truncation.

| | SMT model | This datapath |
| --- | --- | --- |
| Products | exact, in the SMT floating-point theory | exact, bitvector multiplication |
| Extra alignment bits | none on Volta/Turing, one on Ampere | `p` = 0, 1, 2 on V100, A100, H100 |
| Carry bits | ⌈log₂ N⌉ for N terms | ⌊log₂ K⌋ + 1 for K products and C: 3, 4, 5 |
| Use | solver queries for discriminating inputs, then GPU runs | executable definition with proofs over every input |
| Coverage | FP16 inputs on Volta, Turing, Ampere, including FP16 output | FP16, BF16, TF32 inputs with FP32 output on V100, A100, H100, including floors and subnormals |

The SMT model answers one query at a time and some queries time out (the
Ampere carry-bit query ran for 6 hours). Here the carry-bit width is proved
sufficient for every input. The datapath could also be used for solver
queries on one fixed profile, through Lean's `bv_decide`.

## Tests

[`tests/TensorCoreTests/TC/Datapath.lean`](https://github.com/pauljiang03/TC-EFT/blob/main/tests/TensorCoreTests/TC/Datapath.lean)
checks concrete words with the kernel: four products of one, products lost
below the grid, an out-of-range sum, a subnormal output, a negative sum that
truncates to −0, and both input errors.
