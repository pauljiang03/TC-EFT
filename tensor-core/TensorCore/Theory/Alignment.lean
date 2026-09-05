import TensorCore.Foundations.Exact

namespace TensorCore

theorem alignment_value (x : Rat) (e : Int) :
    truncGrid x e = (truncCoeff x e : Rat) * pow2 e := rfl

/-- Strict signed bounds, valid for every positive binary grid and either input sign. -/
theorem alignment_residual_bounds (x : Rat) (e : Int) :
    -pow2 e < x - truncGrid x e ∧ x - truncGrid x e < pow2 e := by
  have hq := pow2_pos e
  have hq0 : 0 ≤ pow2 e := by grind
  have hqn : pow2 e ≠ 0 := by grind
  unfold truncGrid truncCoeff
  split
  · have lo := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (-x / pow2 e)) hq0
    rw [Rat.div_mul_cancel hqn] at lo
    have hi := (Rat.div_lt_iff hq).mp (Rat.lt_floor_add_one (-x / pow2 e))
    simp only [Rat.intCast_neg, Rat.intCast_add] at *
    grind
  · have lo := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (x / pow2 e)) hq0
    rw [Rat.div_mul_cancel hqn] at lo
    have hi := (Rat.div_lt_iff hq).mp (Rat.lt_floor_add_one (x / pow2 e))
    simp only [Rat.intCast_add] at *
    grind

theorem alignment_residual (x : Rat) (e : Int) :
    x = truncGrid x e + (x - truncGrid x e) ∧
    absQ (x - truncGrid x e) < pow2 e := by
  have h := alignment_residual_bounds x e
  unfold absQ
  split <;> grind

end TensorCore
