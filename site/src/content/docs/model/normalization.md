---
title: 5. Normalization and final rounding
description: The aligned sum is normalized and then truncated to an FP32 word (the final rounding mode is round toward zero), with explicit range and signed-zero behavior.
---

*Accurate Models* describes the last step as **normalization followed by the
final rounding mode**: "the rounding mode at both the alignment and
post-normalization stages is truncation", and on Hopper "upon normalization,
results are truncated rather than rounded". In its MATLAB code this is
`norm_helper` (the "Normalisation Helper Function") with the final rounding
mode `frmode = 'rz'`.

The step has two parts:

1. **Normalization** shifts the aligned sum so that its leading 1
   becomes the top bit of the significand, and adjusts the exponent to match.
   This loses nothing.
2. **Final rounding** keeps FP32's 24 significant bits and drops the rest.
   This is **truncation**, which IEEE 754 calls *round toward zero* (RZ); the
   code uses that name, `.towardZero`. Dropping bits shrinks the magnitude,
   so the result moves toward zero for both signs. For a negative number it
   is not rounding down (floor). This is the second lossy step of the model,
   after alignment.

Because the model keeps the sum as an exact rational, both parts are done by
one function, `round32`. It finds the exponent of the sum (normalization) and
truncates the significand to 24 bits (final rounding):

```lean
def evalPrepared (b : PreparedBlock) : Except ModelError BlockTrace :=
  match round32 .towardZero b.accumulator with
  | none => .error .accumulatorOutOfRange
  | some bits => match finite32 bits with
    | none => .error .nonfiniteOutput
    | some d => .ok ⟨b, d⟩
```

## `round32`: normalize and round an exact rational to FP32

[`round32`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/RoundOp.lean#L53)
supports two modes, `towardZero` and `nearestEven`. EFT uses the second. The
algorithm is:

1. If `x = 0`, return `+0`.
2. **Normalize:** find the binary exponent `e` of `|x|` (`magnitudeExponent`), clamped below
   at `−126` so that subnormals use the fixed grid `2^-149` (`normExp`).
3. **Final rounding:** scale `|x|` onto the grid `2^(e−23)` and keep 24 bits:
   `floor` for toward-zero, `rneInt` for nearest-even (`roundedCoeff`).
4. If rounding produced `2^24`, carry into the next binade (`carry`).
5. If the exponent passes 127, fail. Otherwise assemble sign, exponent, and
   mantissa bits (`encode32`).

```lean
def round32Core (mode : RoundingMode) (x : ℚ) : Option F32 :=
  if x = 0 then some 0
  else
    let (e', k') := carry (normExp (absQ x)) (roundedCoeff mode (absQ x))
    if e' > 127 then none else some (encode32 (decide (x < 0)) e' k')

def round32 (mode : RoundingMode) (x : ℚ) : Option F32 :=
  if absQ x > maxFinite32 then none else round32Core mode x
```

## Range: the model is finite-only

An accumulator larger in magnitude than `maxFinite32 = (2^24 − 1)·2^104`
**rejects** the block with `accumulatorOutOfRange`. The model does not
produce infinity. This is a deliberate restriction of scope: the *Accurate Models*
model and the validation data cover finite outputs. The accepted domain is
stated exactly:

```lean
theorem evalBlock_success_iff (p : Profile) (x : BlockInput p) :
    (∃ t, evalBlock x = .ok t) ↔
      x.products.length = p.products ∧
        ∃ b, prepare x = some b ∧ absQ b.accumulator ≤ maxFinite32
```

## Signed zero

- An accumulator that is exactly zero produces `+0`. Input zeros were already
  unsigned on decoding.
- A negative nonzero accumulator that truncates to zero produces `−0`
  (`encode32` keeps the sign bit with all significand bits zero).

The independent specification states the sign bit explicitly, and the
equality proof covers it bit for bit.

## How the rounding is specified

`round32` is an algorithm. Its correctness is proved against
specifications that do not mention it:

- **Toward zero:** the [independent
  specification](/TC-EFT/model/specification/) describes RZ by ordering:
  the result is the finite FP32 value with the largest magnitude lying
  between 0 and `x`. `supported_eq_spec` proves `round32 .towardZero` meets
  this on every supported input.
- **Nearest even:** `NearestEven32 x b` says that `b` decodes to a finite
  value at least as close to `x` as any finite FP32 value, and that `b` has
  an even final bit whenever a different value is equally close.
  [`round32_nearestEven_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/CorrectRounding.lean#L153)
  proves `round32 .nearestEven` meets it on the whole finite range.
- **Any binary format:**
  [`roundBinary_correct`](https://github.com/pauljiang03/TC-EFT/blob/main/TensorCore/Numerics/Binary/RoundingContract.lean#L16)
  gives the same contract for well-formed formats and modes in general. FP64
  (DMMA) and multi-stage rounding use it.
