import TensorCore.Foundations.Encoding

namespace TensorCore

inductive RoundingMode where
  | towardZero
  | nearestEven
  deriving Repr, DecidableEq

def emin32 : Int := -126
def maxFinite32 : Rat := (2 ^ 24 - 1 : Nat) * pow2 104

/-- Nearest integer with ties to even: floor, then a doubled-remainder comparison. -/
def rneInt (t : Rat) : Int :=
  if 1 < 2 * (t - t.floor) ∨ (2 * (t - t.floor) = 1 ∧ t.floor % 2 = 1) then t.floor + 1
  else t.floor

/-- Integer coefficient selected on a nonnegative scaled magnitude. -/
def roundCoefficient : RoundingMode → Rat → Int
  | .towardZero, t => t.floor
  | .nearestEven, t => rneInt t

/-- Called on positive magnitudes only; the public converter branches on zero first. -/
def magnitudeExponent (x : Rat) : Int :=
  let e : Int := (x.num.natAbs.log2 : Int) - (x.den.log2 : Int)
  if x < pow2 e then e - 1 else e

/-- Bit pattern for sign, exponent `e`, and coefficient `k` on `2^(e-23)`. A coefficient
below `2^23` is the subnormal or zero range and requires `e = -126`. -/
def encode32 (negative : Bool) (e k : Int) : F32 :=
  BitVec.ofNat 32 ((if negative then 2 ^ 31 else 0) +
    (if k < 2 ^ 23 then k.toNat else (e + 127).toNat * 2 ^ 23 + (k - 2 ^ 23).toNat))

/-- Exponent selected for a positive magnitude, clamped to the subnormal range. -/
def convExp (m : Rat) : Int := max (magnitudeExponent m) emin32

/-- Coefficient selected on the grid `2^(convExp m - 23)`. -/
def convCoeff (mode : RoundingMode) (m : Rat) : Int :=
  roundCoefficient mode (m / pow2 (convExp m - 23))

/-- A coefficient of `2^24` carries into the next binade. -/
def carry (e k : Int) : Int × Int := if k = 2 ^ 24 then (e + 1, k / 2) else (e, k)

/-- Conversion core. Exponent overflow is rejected; this is not a complete IEEE
exception/overflow policy. Use `round32` for the public finite-range contract. -/
def round32Core (mode : RoundingMode) (x : Rat) : Option F32 :=
  if x = 0 then some 0
  else
    let (e', k') := carry (convExp (absQ x)) (convCoeff mode (absQ x))
    if e' > 127 then none else some (encode32 (decide (x < 0)) e' k')

/-- Finite-range reference conversion. Magnitudes above `maxFinite32` are rejected
before conversion. Exact zero is +0; negative nonzero values rounded to zero keep
their sign. Extending the accepted range requires a separate overflow contract. -/
def round32 (mode : RoundingMode) (x : Rat) : Option F32 :=
  if absQ x > maxFinite32 then none else round32Core mode x

/-- Exponent of the quantum of an encoded output: `E - 150` for a normal encoding with
exponent field `E`, and `-149` for a subnormal or zero encoding. -/
def outputQuantumExponent (b : F32) : Int :=
  max (((b.toNat / 2 ^ 23 % 2 ^ 8 : Nat) : Int) - 127) emin32 - 23

end TensorCore
