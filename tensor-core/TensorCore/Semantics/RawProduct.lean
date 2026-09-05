import TensorCore.Foundations.Encoding

namespace TensorCore

structure RawProduct where
  significand : Int
  rawScale : Int
  fractionalBits : Int
  deriving Repr, DecidableEq

def RawProduct.value (x : RawProduct) : Rat :=
  (x.significand : Rat) * pow2 (x.rawScale - x.fractionalBits)

def rawMul (a b : Decoded) : RawProduct :=
  ⟨a.significand * b.significand, a.rawScale + b.rawScale,
    a.fractionalBits + b.fractionalBits⟩

theorem rawProduct_value (a b : Decoded) :
    (rawMul a b).value = a.value * b.value := by
  simp only [rawMul, RawProduct.value, Decoded.value, Rat.intCast_mul]
  have h : a.rawScale + b.rawScale - (a.fractionalBits + b.fractionalBits) =
      (a.rawScale - a.fractionalBits) + (b.rawScale - b.fractionalBits) := by omega
  rw [h, pow2_add]
  grind

end TensorCore
