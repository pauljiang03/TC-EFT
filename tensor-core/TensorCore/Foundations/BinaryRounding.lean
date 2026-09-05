import TensorCore.Foundations.Format
import TensorCore.Foundations.Rounding

namespace TensorCore

def Format.emin (f : Format) : Int := 1 - f.bias
def Format.emax (f : Format) : Int := ((2 ^ f.exponentBits - 2 : Nat) : Int) - f.bias
def Format.maxFinite (f : Format) : Rat :=
  ((2 ^ (f.fractionBits + 1) - 1 : Nat) : Rat) * pow2 (f.emax - f.fractionBits)

inductive BinaryRoundingMode where
  | towardZero
  | nearestEven
  | towardNegative
  | towardPositive
  deriving Repr, DecidableEq

abbrev RoundingMode.toBinary : RoundingMode → BinaryRoundingMode
  | .towardZero => .towardZero
  | .nearestEven => .nearestEven

/-- Direction is applied to a nonnegative magnitude, with the original sign available. -/
def binaryCoefficient (mode : BinaryRoundingMode) (negative : Bool) (m : Rat) : Int :=
  match mode with
  | .towardZero => m.floor
  | .nearestEven => rneInt m
  | .towardNegative => if negative then m.ceil else m.floor
  | .towardPositive => if negative then m.floor else m.ceil

def encodeBinary (f : Format) (negative : Bool) (e k : Int) : BitVec f.width :=
  BitVec.ofNat f.width ((if negative then 2 ^ (f.fractionBits + f.exponentBits) else 0) +
    (if k < (2 ^ f.fractionBits : Nat) then k.toNat
     else (e + f.bias).toNat * 2 ^ f.fractionBits + (k - (2 ^ f.fractionBits : Nat)).toNat))

def binaryConvExp (f : Format) (m : Rat) : Int := max (magnitudeExponent m) f.emin

def binaryCarry (f : Format) (e k : Int) : Int × Int :=
  if k = (2 ^ (f.fractionBits + 1) : Nat) then (e + 1, k / 2) else (e, k)

/-- All formats use the finite reference domain, including every directed mode.
Each conversion boundary decodes these returned bits before further arithmetic. -/
def roundBinary (f : Format) (mode : BinaryRoundingMode) (x : Rat) : Option (BitVec f.width) :=
  if ¬ f.WellFormed then none
  else if absQ x > f.maxFinite then none
  else if x = 0 then some 0
  else
    let negative := decide (x < 0)
    let e := binaryConvExp f (absQ x)
    let k := binaryCoefficient mode negative (absQ x / pow2 (e - f.fractionBits))
    let (e', k') := binaryCarry f e k
    if e' > f.emax then none else some (encodeBinary f negative e' k')

def binaryValue (f : Format) (bits : BitVec f.width) : Option Rat :=
  ((classify f bits).finite).map Decoded.value

theorem encodeBinary_fp32 (negative : Bool) (e k : Int) :
    encodeBinary fp32 negative e k = encode32 negative e k := rfl

set_option maxRecDepth 4096 in
theorem roundBinary_fp32 (mode : RoundingMode) (x : Rat) :
    roundBinary fp32 mode.toBinary x = round32 mode x := by
  cases mode <;> rfl

theorem roundBinary_range {f : Format} {mode : BinaryRoundingMode} {x : Rat}
    {bits : BitVec f.width} (h : roundBinary f mode x = some bits) :
    f.WellFormed ∧ absQ x ≤ f.maxFinite := by
  unfold roundBinary at h
  split at h
  · simp at h
  · split at h
    · simp at h
    · constructor <;> grind

end TensorCore
