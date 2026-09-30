-- Format for the arithmetic core.

import TensorCore.Numerics.Encoding

namespace TensorCore

inductive SpecialEncoding where
  | ieee
  /-- The top exponent is finite except for its all-one fraction, which is NaN. -/
  | finiteTopNaN
  deriving Repr, DecidableEq

structure ValueFormat where
  layout : Format
  special : SpecialEncoding := .ieee
  deriving Repr, DecidableEq

def ValueFormat.classifyNat (f : ValueFormat) (n : ℕ) : Classification :=
  match f.special with
  | .ieee => TensorCore.classifyNat f.layout n
  | .finiteTopNaN =>
    let fraction := n % 2 ^ f.layout.fractionBits
    let exponent := n / 2 ^ f.layout.fractionBits % 2 ^ f.layout.exponentBits
    let negative := n / 2 ^ (f.layout.fractionBits + f.layout.exponentBits) != 0
    if exponent = 2 ^ f.layout.exponentBits - 1 then
      if fraction = 2 ^ f.layout.fractionBits - 1 then .nan
      else .normal ⟨if negative then -((2 ^ f.layout.fractionBits + fraction : ℕ) : ℤ)
        else ((2 ^ f.layout.fractionBits + fraction : ℕ) : ℤ),
        (exponent : ℤ) - f.layout.bias, f.layout.fractionBits⟩
    else TensorCore.classifyNat f.layout n

def ValueFormat.decode (f : ValueFormat) (bits : BitVec f.layout.width) : Option Decoded :=
  (f.classifyNat bits.toNat).finite

/-- A value word with required zero low padding. Padding checks are not input rounding. -/
structure OperandEncoding where
  valueFormat : ValueFormat
  lowPadding : ℕ := 0
  deriving Repr, DecidableEq

@[implicit_reducible] def OperandEncoding.width (s : OperandEncoding) : ℕ :=
  s.valueFormat.layout.width + s.lowPadding
abbrev OperandEncoding.Word (s : OperandEncoding) := BitVec s.width

def OperandEncoding.decode (s : OperandEncoding) (bits : s.Word) : Option Decoded :=
  if bits.toNat % 2 ^ s.lowPadding != 0 then none
  else (s.valueFormat.classifyNat (bits.toNat / 2 ^ s.lowPadding)).finite

@[implicit_reducible] def packedIEEE (f : Format) : OperandEncoding := ⟨⟨f, .ieee⟩, 0⟩
/-- TF32 values carried in FP32-sized words; the thirteen low bits must be zero. -/
def tf32Register : OperandEncoding := ⟨⟨tf19, .ieee⟩, 13⟩

theorem packedIEEE_decode (f : Format) (bits : BitVec f.width) :
    (packedIEEE f).decode bits = (classify f bits).finite := by
  simp only [OperandEncoding.decode, packedIEEE, ValueFormat.classifyNat, classify,
    Nat.pow_zero, Nat.mod_one, Nat.div_one, bne_self_eq_false, Bool.false_eq_true,
    ↓reduceIte, OperandEncoding.width, Nat.add_zero]

theorem padded_decode_requires_zero {s : OperandEncoding} {bits : s.Word} {d : Decoded}
    (h : s.decode bits = some d) : bits.toNat % 2 ^ s.lowPadding = 0 := by
  unfold OperandEncoding.decode at h
  split at h <;> simp_all

theorem padded_decode_value {s : OperandEncoding} {bits : s.Word} {d : Decoded}
    (h : s.decode bits = some d) :
    (s.valueFormat.classifyNat (bits.toNat / 2 ^ s.lowPadding)).finite = some d := by
  unfold OperandEncoding.decode at h
  split at h <;> simp_all

end TensorCore
