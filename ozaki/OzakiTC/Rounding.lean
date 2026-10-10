import OzakiTC.Exactness

/-! # Binary32 rounding in the recombination

Ozaki-I adds its scaled slice products, and Ozaki-II rounds its reconstructed product, in binary32
with round to nearest even. `round32Value` is TC-EFT's binary32 converter as a rounding of values;
`fp32Add` (TC-EFT's correctly rounded addition) is the addition it induces. Both satisfy the
standard model with a subnormal term: `|fl(q) − q| ≤ 2^-24 |q| + 2^-150`
(`round32Value_within`). -/

open TensorCore

namespace Ozaki.TC

/-- Binary32 round to nearest even, as a value; `none` on overflow. -/
def round32Value (q : ℚ) : Option ℚ := (round32 .nearestEven q).bind value32

theorem fp32Add_eq_addOfRound : fp32Add = addOfRound round32Value := by
  funext x y; rfl

/-- Rounding a positive magnitude to nearest even loses at most `2^-24 m + 2^-150`. -/
theorem magnitudeRounded_error {m : ℚ} (hm : 0 < m) (hr : m ≤ maxFinite32) :
    Rat.abs (magnitudeRounded .nearestEven m - m) ≤ 2 ^ (-24 : ℤ) * m + 2 ^ (-150 : ℤ) := by
  obtain ⟨he1, _, _, hlow⟩ := normExp_bounds m hm hr
  generalize hE : normExp m = e at *
  have hg := pow2_pos (e - 23)
  have hdist := rneInt_dist_le_half (m / pow2 (e - 23))
  rw [absQ_eq] at hdist
  have heq : magnitudeRounded .nearestEven m - m =
      ((rneInt (m / pow2 (e - 23)) : ℚ) - m / pow2 (e - 23)) * pow2 (e - 23) := by
    unfold magnitudeRounded roundedSignificand roundSignificand
    rw [hE]
    have : m / pow2 (e - 23) * pow2 (e - 23) = m := Rat.div_mul_cancel (Rat.ne_of_gt hg)
    grind
  rw [heq, abs_mul, abs_of_nonneg (Rat.le_of_lt hg), abs_sub_comm]
  have hhalf : Rat.abs (m / pow2 (e - 23) - rneInt (m / pow2 (e - 23))) * pow2 (e - 23) ≤
      pow2 (e - 24) := by
    have h2 : pow2 (e - 23) = 2 * pow2 (e - 24) := by
      rw [show e - 23 = (e - 24) + 1 by omega, pow2_succ]; grind
    have := Rat.mul_le_mul_of_nonneg_right hdist (Rat.le_of_lt (pow2_pos (e - 24)))
    generalize Rat.abs (m / pow2 (e - 23) - rneInt (m / pow2 (e - 23))) = A at this ⊢
    rw [h2]; grind
  refine Rat.le_trans hhalf ?_
  have hm0 : (0 : ℚ) ≤ 2 ^ (-24 : ℤ) * m :=
    Rat.mul_nonneg (Rat.le_of_lt (two_pow_pos _)) (Rat.le_of_lt hm)
  have h150 : (0 : ℚ) ≤ 2 ^ (-150 : ℤ) := Rat.le_of_lt (two_pow_pos _)
  rcases hlow with hlow | hlow
  · have : pow2 (e - 24) ≤ 2 ^ (-24 : ℤ) * m := by
      rw [show e - 24 = -24 + e by omega, pow2_add]
      exact Rat.mul_le_mul_of_nonneg_left hlow (Rat.le_of_lt (pow2_pos _))
    grind
  · subst hlow
    have : pow2 (-126 - 24) = 2 ^ (-150 : ℤ) := rfl
    rw [this]
    grind

/-- **Binary32 rounding error.** `|fl(q) − q| ≤ 2^-24 |q| + 2^-150` whenever `fl(q)` is finite. -/
theorem round32Value_within : RoundWithin round32Value (2 ^ (-24 : ℤ)) (2 ^ (-150 : ℤ)) := by
  intro q v h
  unfold round32Value at h
  cases hw : round32 .nearestEven q with
  | none => simp [hw] at h
  | some w =>
    simp only [hw, Option.bind_some] at h
    by_cases hq : q = 0
    · subst hq
      have h0 : round32 .nearestEven 0 = some 0 := by decide +kernel
      rw [h0] at hw; cases Option.some.inj hw
      have : value32 0 = some 0 := by decide +kernel
      rw [this] at h; cases Option.some.inj h
      rw [show (0 : ℚ) - 0 = 0 by grind, abs_zero]
      have := two_pow_pos (-150 : ℤ); have := abs_nonneg (0 : ℚ)
      grind
    · have hr := round32_range hw
      obtain ⟨b, hb, hv, _⟩ := round32_nonzero_spec .nearestEven q hq hr
      rw [hw] at hb; cases Option.some.inj hb
      rw [hv] at h; cases Option.some.inj h
      have hpos : 0 < absQ q := by rw [absQ_eq]; exact Rat.abs_pos_iff.mpr hq
      have herr := magnitudeRounded_error hpos hr
      rw [← absQ_eq q] at *
      unfold signedRounded
      split
      · rename_i hneg
        rw [absQ_of_neg hneg] at herr ⊢
        have : -magnitudeRounded .nearestEven (-q) - q =
            -(magnitudeRounded .nearestEven (-q) - -q) := by grind
        rw [this, abs_neg]; exact herr
      · rename_i hnn
        rw [absQ_of_nonneg (by grind)] at herr ⊢
        exact herr

theorem fp32Add_within : AddWithin fp32Add (2 ^ (-24 : ℤ)) (2 ^ (-150 : ℤ)) := by
  rw [fp32Add_eq_addOfRound]; exact addOfRound_within round32Value_within

end Ozaki.TC
