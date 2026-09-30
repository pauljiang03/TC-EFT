-- Raw Product for the arithmetic core.

import TensorCore.Numerics.FormatProperties

namespace TensorCore

structure RawProduct where
  significand : ℤ
  rawScale : ℤ
  fractionalBits : ℤ
  deriving Repr, DecidableEq

def RawProduct.value (x : RawProduct) : ℚ :=
  (x.significand : ℚ) * pow2 (x.rawScale - x.fractionalBits)

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

/-- A common bound for c (significand below two) and raw products (below four). -/
def RawProduct.Bounded (t : RawProduct) : Prop := absQ t.value < 4 * pow2 t.rawScale

theorem rawMul_bounded (a b : Decoded) (ha : a.Bounded) (hb : b.Bounded) :
    (rawMul a b).Bounded := by
  have hpa := pow2_pos a.rawScale
  have hpb := pow2_pos b.rawScale
  have hna := absQ_nonneg a.value
  have hnb := absQ_nonneg b.value
  have hm : absQ (a.value * b.value) = absQ a.value * absQ b.value := by
    by_cases hz : b.value = 0
    · simp [hz, absQ]
    · by_cases hpos : 0 < b.value
      · rw [absQ_mul_pos _ _ hpos, absQ_of_nonneg (Rat.le_of_lt hpos)]
      · have hneg : b.value < 0 := by grind
        have hm := absQ_mul_pos a.value (-b.value) (by grind)
        rw [Rat.mul_neg, absQ_neg] at hm
        rw [hm, absQ_of_neg hneg]
  change absQ (rawMul a b).value < 4 * pow2 (a.rawScale + b.rawScale)
  rw [rawProduct_value, hm, pow2_add]
  unfold Decoded.Bounded at ha hb
  have h1 := Rat.mul_le_mul_of_nonneg_right (Rat.le_of_lt ha) hnb
  have h2 := Rat.mul_lt_mul_of_pos_left hb (show 0 < 2 * pow2 a.rawScale by grind)
  grind

theorem c_term_bounded (c : Decoded) (hc : c.Bounded) :
    (RawProduct.mk c.significand c.rawScale c.fractionalBits).Bounded := by
  have hp := pow2_pos c.rawScale
  change absQ c.value < 4 * pow2 c.rawScale
  unfold Decoded.Bounded at hc
  grind

end TensorCore
