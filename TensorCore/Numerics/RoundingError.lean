import TensorCore.Numerics.CorrectRounding

-- Error bounds for finite FP32 rounding.

namespace TensorCore

/-- The magnitude truncation loss is strictly smaller than the conversion grid. -/
theorem rtz_magnitude_residual (m : ℚ) :
    absQ (m - magnitudeRounded .towardZero m) < pow2 (convExp m - 23) := by
  let q := pow2 (convExp m - 23)
  have hq : 0 < q := pow2_pos _
  have hf := floor_frac_bounds (m / q)
  have he : m - magnitudeRounded .towardZero m = (m / q - (m / q).floor) * q := by
    have h := Rat.div_mul_cancel (a := m) (Rat.ne_of_gt hq)
    unfold magnitudeRounded convCoeff roundCoefficient
    change m - ((m / q).floor : ℚ) * q = _
    grind
  rw [he, absQ_mul_pos _ q hq, absQ_of_nonneg hf.1]
  have h := Rat.mul_lt_mul_of_pos_right hf.2 hq
  simpa using h

theorem rtz_signed_residual (x : ℚ) :
    absQ (x - signedRounded .towardZero x) < pow2 (convExp (absQ x) - 23) := by
  have h := rtz_magnitude_residual (absQ x)
  unfold signedRounded
  by_cases hn : x < 0
  · simp only [hn, ↓reduceIte, absQ_of_neg hn] at h ⊢
    have he : x - -magnitudeRounded .towardZero (-x) =
      -(-x - magnitudeRounded .towardZero (-x)) := by grind
    rw [he, absQ_neg]; exact h
  · have hn' : 0 ≤ x := by grind
    simpa [hn, absQ_of_nonneg hn'] using h

/-- FP32 truncation's strict output loss bound, with its finite-range hypothesis. -/
theorem output_residual_bound (x : ℚ) (b : F32) (d : ℚ)
    (hr : absQ x ≤ maxFinite32) (hb : round32 .towardZero x = some b)
    (hd : value32 b = some d) :
    absQ (x - d) < pow2 (outputQuantumExponent b) := by
  by_cases hx : x = 0
  · subst x
    have hz : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [hz] at hb
    cases Option.some.inj hb
    have hv : value32 0 = some 0 := by decide +kernel
    rw [hv] at hd
    cases Option.some.inj hd
    have ha : absQ (0 - 0) = 0 := by decide +kernel
    rw [ha]; exact pow2_pos _
  · obtain ⟨b', hb', hd', _, he⟩ := round32_nonzero_spec .towardZero x hx hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hd'
    have hvalue := Option.some.inj hd'
    rw [hvalue]
    have hl := rtz_signed_residual x
    have hq := pow2_le_of_le he
    grind

/-- Truncation toward zero loses less than the conversion grid of the input magnitude. -/
theorem rtz_residual_lt (x : ℚ) (b : F32) (d : ℚ) (hr : absQ x ≤ maxFinite32)
    (hb : round32 .towardZero x = some b) (hd : value32 b = some d) :
    absQ (x - d) < pow2 (convExp (absQ x) - 23) := by
  by_cases hx : x = 0
  · subst x
    have hz : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [hz] at hb
    cases Option.some.inj hb
    have hv : value32 0 = some 0 := by decide +kernel
    rw [hv] at hd
    cases Option.some.inj hd
    have ha : absQ (0 - 0) = 0 := by decide +kernel
    rw [ha]; exact pow2_pos _
  · obtain ⟨b', hb', hd', _, _⟩ := round32_nonzero_spec .towardZero x hx hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hd'
    rw [Option.some.inj hd']
    exact rtz_signed_residual x

end TensorCore
