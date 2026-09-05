import TensorCore.Foundations.Encoding

namespace TensorCore

inductive RoundingMode where
  | towardZero
  | nearestEven
  deriving Repr, DecidableEq

def maxFinite32 : Rat := (2 ^ 24 - 1 : Nat) * pow2 104

/-- Called on positive magnitudes only; the public converter branches on zero first. -/
def magnitudeExponent (x : Rat) : Int :=
  let e : Int := (x.num.natAbs.log2 : Int) - (x.den.log2 : Int)
  if x < pow2 e then e - 1 else e

/-- Quotient/remainder selection, including parity at an exact midpoint. -/
def roundCoefficient (mode : RoundingMode) (x : Rat) : Nat :=
  let n := x.num.natAbs
  let d := x.den
  let k := n / d
  let r := n % d
  match mode with
  | .towardZero => k
  | .nearestEven =>
    if 2 * r > d || (2 * r = d && k % 2 = 1) then k + 1 else k

/-- Finite-range reference converter. Values outside maxFinite32 are rejected.
Exact zero is +0; a negative nonzero value rounded to zero keeps its sign. -/
def round32 (mode : RoundingMode) (x : Rat) : Option F32 :=
  let m := absQ x
  if m > maxFinite32 then none
  else if x = 0 then some 0
  else
    let e := max (magnitudeExponent m) (-126)
    let k := roundCoefficient mode (m / pow2 (e - 23))
    let (e', k') := if k = 2 ^ 24 then (e + 1, k / 2) else (e, k)
    let magnitude := if k' < 2 ^ 23 then k'
      else (e' + 127).toNat * 2 ^ 23 + (k' - 2 ^ 23)
    let sign := if x < 0 then 2 ^ 31 else 0
    some (BitVec.ofNat 32 (sign + magnitude))

end TensorCore
