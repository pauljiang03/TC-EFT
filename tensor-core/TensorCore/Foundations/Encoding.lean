import TensorCore.Foundations.Exact

namespace TensorCore

structure Format where
  fractionBits : Nat
  exponentBits : Nat
  bias : Int
  deriving Repr, DecidableEq

@[implicit_reducible] def fp16 : Format := ⟨10, 5, 15⟩
@[implicit_reducible] def fp32 : Format := ⟨23, 8, 127⟩
@[implicit_reducible] def Format.width (f : Format) : Nat := 1 + f.exponentBits + f.fractionBits
abbrev F16 := BitVec 16
abbrev F32 := BitVec 32

/-- The integer significand is signed; scale remains the unnormalized input scale. -/
structure Decoded where
  significand : Int
  rawScale : Int
  fractionalBits : Int
  deriving Repr, DecidableEq

def Decoded.value (x : Decoded) : Rat :=
  (x.significand : Rat) * pow2 (x.rawScale - x.fractionalBits)

inductive Classification where
  | zero (negative : Bool)
  | subnormal (value : Decoded)
  | normal (value : Decoded)
  | infinity (negative : Bool)
  | nan
  deriving Repr, DecidableEq

/-- Classification of a bit pattern given as a natural number below `2 ^ f.width`. -/
def classifyNat (f : Format) (n : Nat) : Classification :=
  let fraction := n % 2 ^ f.fractionBits
  let exponent := n / 2 ^ f.fractionBits % 2 ^ f.exponentBits
  let negative := n / 2 ^ (f.fractionBits + f.exponentBits) != 0
  let signed (m : Nat) : Int := if negative then -(m : Int) else m
  if exponent = 2 ^ f.exponentBits - 1 then
    if fraction = 0 then .infinity negative else .nan
  else if exponent = 0 then
    if fraction = 0 then .zero negative
    else .subnormal ⟨signed fraction, 1 - f.bias, f.fractionBits⟩
  else .normal ⟨signed (2 ^ f.fractionBits + fraction),
    (exponent : Int) - f.bias, f.fractionBits⟩

def classify (f : Format) (bits : BitVec f.width) : Classification := classifyNat f bits.toNat

def Classification.finite : Classification → Option Decoded
  | .zero _ => some ⟨0, 0, 0⟩
  | .subnormal x | .normal x => some x
  | .infinity _ | .nan => none

@[implicit_reducible] def decode16 (x : F16) : Option Decoded := (classify fp16 x).finite
@[implicit_reducible] def decode32 (x : F32) : Option Decoded := (classify fp32 x).finite

/-- Width-free restatement used by the encoding proofs. -/
theorem decode32_eq (x : F32) : decode32 x = (classifyNat fp32 x.toNat).finite := rfl

/-- Numerical projection for encoded boundaries. Special encodings have no value. -/
def value32 (x : F32) : Option Rat := (decode32 x).map Decoded.value

end TensorCore
