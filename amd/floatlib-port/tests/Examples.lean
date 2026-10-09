import MCFloat

/-! # Worked examples

The FloatLib implementation evaluated on a few of the paper's inputs (the equivalence theorems
cover every input; these document the executable). -/

open MCFloat
open FloatLib.Floats.Formats.BinaryInterchange

def observed (w : Option F32) : String :=
  match w with
  | none => "X"
  | some w =>
    if Model.isNaN w then "N"
    else if Model.isInf w then (if Model.signBit w then "I-" else "I+")
    else s!"F {bits w}"

-- Four fp16 products `1 · 1` with `c = 0` on CDNA 1: the binary32 word of `4`.
#guard observed (block cdna1F16 (List.replicate 4 0x3C00) (List.replicate 4 0x3C00) 0) =
  s!"F {0x40800000}"

-- `c = −∞` with an overflowing positive product (CDNA 3 bf16, `2^127 · 2^2`) is NaN.
#guard observed (block cdna3BF16 (0x7F00 :: List.replicate 7 0) (0x4080 :: List.replicate 7 0)
  0xFF800000) = "N"

-- The same product alone overflows to `+∞` on CDNA 3 (`|p| ≥ 2^128`).
#guard observed (block cdna3BF16 (0x7F00 :: List.replicate 7 0) (0x4080 :: List.replicate 7 0) 0) =
  "I+"

-- On CDNA 1 the same exact sum `2^129` overflows only at the final rounding.
#guard observed (block cdna1BF16 [0x7F00, 0] [0x4080, 0] 0) = "I+"

-- fp8 E4M3 FNUZ: `0x80` (negative zero) is NaN.
#guard observed (block (cdna3FP8 .e4m3fnuz .e4m3fnuz) (0x80 :: List.replicate 15 0)
  (List.replicate 16 0) 0) = "N"

-- An empty inner product returns `c`.
#guard observed (dot cdna3F16 [] [] 0x7F800000) = "I+"
