---
title: 1. Formats and decoding
description: How encoded FP16, BF16, TF32, and FP32 words become exact values with raw exponent metadata.
---

The model starts from bit patterns, not real numbers. Decoding has two jobs:
classify the word as zero, subnormal, normal, infinity, or NaN, and keep the
**raw scale** (exponent) that the hardware uses for alignment.

## Formats

A [`Format`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Defs.lean#L7)
is a triple of stored fraction bits, exponent bits, and bias:

```lean
structure Format where
  fractionBits : ℕ
  exponentBits : ℕ
  bias : ℤ

def fp16 : Format := ⟨10, 5, 15⟩
def bf16 : Format := ⟨7, 8, 127⟩
def tf19 : Format := ⟨10, 8, 127⟩    -- TF32's 19 value bits
def fp32 : Format := ⟨23, 8, 127⟩
def fp64 : Format := ⟨52, 11, 1023⟩
```

The width is `1 + exponentBits + fractionBits`, so a word of format `f` has
type `BitVec f.width`.

## Decoded values keep their raw scale

```lean
structure Decoded where
  significand : ℤ       -- signed integer significand, hidden bit included
  rawScale : ℤ          -- unbiased exponent as stored in the word
  fractionalBits : ℤ    -- position of the binary point in `significand`

def Decoded.value (x : Decoded) : ℚ :=
  (x.significand : ℚ) * pow2 (x.rawScale - x.fractionalBits)
```

A `Decoded` stores the value as **significand, exponent, binary-point
position**, not as a single rational. `value` recovers the rational exactly,
and alignment reads `rawScale`.

[`classifyNat`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Encoding.lean#L6)
implements standard IEEE field extraction:

```lean
def classifyNat (f : Format) (n : ℕ) : Classification :=
  let fraction := n % 2 ^ f.fractionBits
  let exponent := n / 2 ^ f.fractionBits % 2 ^ f.exponentBits
  let negative := n / 2 ^ (f.fractionBits + f.exponentBits) != 0
  let signed (m : ℕ) : ℤ := if negative then -(m : ℤ) else m
  if exponent = 2 ^ f.exponentBits - 1 then
    if fraction = 0 then .infinity negative else .nan
  else if exponent = 0 then
    if fraction = 0 then .zero negative
    else .subnormal ⟨signed fraction, 1 - f.bias, f.fractionBits⟩
  else .normal ⟨signed (2 ^ f.fractionBits + fraction),
    (exponent : ℤ) - f.bias, f.fractionBits⟩
```

Points to note:

- **Subnormals** get raw scale `1 − bias`, the minimum normal exponent, and no
  hidden bit. A subnormal therefore aligns as the hardware treats it: at the
  format's minimum exponent, with a small significand.
- **Zero** decodes to `⟨0, 0, 0⟩`. Its sign is discarded on input. Because the
  significand is zero, zero never takes part in choosing the
  [alignment exponent](/TC-EFT/model/alignment/).
- **Infinity and NaN** map to `none` through
  [`Classification.finite`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Encoding.lean#L21),
  and the block is rejected with `ModelError.nonfiniteInput`. The model covers
  finite arithmetic only.

## Preparing a block

`prepare` decodes `C` as FP32 and every operand in the profile's format. If
any of them is nonfinite, it returns `none`:

```lean
def prepareProducts (p : Profile) (ps : List (p.Word × p.Word)) :
    Option (List (Decoded × Decoded)) :=
  ps.mapM fun (a, b) => do
    return (← p.decode a, ← p.decode b)

def prepare {p : Profile} (x : BlockInput p) : Option PreparedBlock :=
  match decode32 x.c, prepareProducts p x.products with
  | some c, some ps => some ⟨p, ps, c⟩
  | _, _ => none
```

The result, a `PreparedBlock`, records the profile, the decoded pairs, and the
decoded `C`. Every later stage is a function of a `PreparedBlock`.

## TF32: register words and packed values

On the GPU, a TF32 operand sits in a 32-bit register whose low 13 bits are
ignored. The model separates the two concerns:

- `tf19 : Format` is the 19-bit value format (1 sign, 8 exponent, 10 fraction
  bits) that the block model uses.
- [`tf32Register`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Format.lean#L49)
  is an `OperandEncoding` whose 32-bit words must have 13 zero low bits.
  `tf32Unpack` extracts the 19 value bits.

The theorem
[`tf32_eq_paper`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/TC/Specification/Supported.lean#L45)
proves that, on correctly padded register words, the register-level
invocation gives the same bits as the *Accurate Models* specification (`PaperSpec`). Words whose low
bits are not zero are rejected rather than silently masked.

## Proved properties of the encoding layer

- [`signedFiniteBinaryBijection`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Binary/SignedBijection.lean#L130):
  finite encodings correspond one to one with representable values paired
  with a zero sign. Subnormals and both zeros are included, and both inverse
  laws are proved.
- `Decoded.Bounded`: every decoded significand, subnormal or not, is less
  than 2 in magnitude relative to its raw scale. The accumulator-width proofs
  use this bound.
