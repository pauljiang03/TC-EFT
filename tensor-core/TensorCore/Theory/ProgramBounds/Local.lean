import TensorCore.Theory.StaticBudget
import TensorCore.Theory.ExactAlignment

namespace TensorCore

def rawAlignmentBudget (t : RawProduct) (q : Int) : Rat :=
  if truncGrid t.value q = t.value then 0 else pow2 q

theorem rawAlignmentBudget_zero (t : RawProduct) (q : Int) (hv : t.value = 0) :
    rawAlignmentBudget t q = 0 := by simp [rawAlignmentBudget, hv, truncGrid_zero]

theorem rawAlignmentBudget_nonneg (t : RawProduct) (q : Int) :
    0 ≤ rawAlignmentBudget t q := by
  unfold rawAlignmentBudget
  split
  · exact Rat.le_refl
  · exact Rat.le_of_lt (pow2_pos q)

theorem rawAlignmentBudget_le (t : RawProduct) (q : Int) :
    rawAlignmentBudget t q ≤ pow2 q := by
  unfold rawAlignmentBudget
  split
  · exact Rat.le_of_lt (pow2_pos q)
  · exact Rat.le_refl

theorem rawAlignmentBudget_sound (b : PreparedBlock) (E : Int)
    (hs : ScaleBounded b.terms E) (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E)
    (t : RawProduct) (ht : t ∈ b.terms) :
    absQ (t.value - truncGrid t.value b.quantumExponent) ≤
      rawAlignmentBudget t (E - b.profile.alignFraction) := by
  by_cases hz : t.significand = 0
  · have hv : t.value = 0 := by simp [RawProduct.value, hz]
    rw [rawAlignmentBudget_zero t _ hv, hv, truncGrid_zero, Rat.sub_self]
    decide +kernel
  · have hq := quantumExponent_le b E hs hfl t ht hz
    unfold rawAlignmentBudget
    split
    · rename_i he
      have hv : t.value = (truncCoeff t.value (E - b.profile.alignFraction) : Rat) *
          pow2 (E - b.profile.alignFraction) := he.symm
      have hexact := truncGrid_exact_of_grid (truncCoeff t.value (E - b.profile.alignFraction))
        (E - b.profile.alignFraction) b.quantumExponent hq
      rw [← hv] at hexact
      rw [hexact]
      rw [Rat.sub_self]
      decide +kernel
    · exact Rat.le_trans (Rat.le_of_lt (alignment_residual t.value b.quantumExponent).2)
        (pow2_le_of_le hq)

theorem sumQ_map_mono (xs : List α) (f g : α → Rat)
    (h : ∀ x ∈ xs, f x ≤ g x) : sumQ (xs.map f) ≤ sumQ (xs.map g) := by
  induction xs with
  | nil => exact Rat.le_refl
  | cons x xs ih =>
    have hx := h x (by simp)
    have ht := ih (fun y hy => h y (by simp [hy]))
    simp only [List.map_cons, sumQ]
    grind

theorem accumulator_abs_le_mass (b : PreparedBlock) :
    absQ b.accumulator ≤ sumQ (b.terms.map fun t => absQ t.value) := by
  rw [accumulator_value]
  have h := absQ_sumQ_le (b.terms.map fun t => truncGrid t.value b.quantumExponent)
  simp only [List.map_map, Function.comp_def] at h
  exact Rat.le_trans h (sumQ_map_abs_truncGrid_le b.terms b.quantumExponent)

theorem round32_rtz_truncGrid (x : Rat) (d : Finite32)
    (h : round32 .towardZero x = some d.bits) :
    d.value = truncGrid x (convExp (absQ x) - 23) := by
  have hd : value32 d.bits = some d.value := by simp [value32, d.valid, Finite32.value]
  by_cases hz : x = 0
  · subst x
    have h0 : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [h0] at h
    have hv : value32 0 = some 0 := by decide +kernel
    rw [← Option.some.inj h, hv] at hd
    rw [← Option.some.inj hd, truncGrid_zero]
  · obtain ⟨bits, hb, hv, _, _⟩ := round32_nonzero_spec .towardZero x hz (round32_range h)
    rw [h] at hb
    cases Option.some.inj hb
    rw [hd] at hv
    rw [Option.some.inj hv]
    unfold signedRounded magnitudeRounded convCoeff roundCoefficient truncGrid truncCoeff
    by_cases hn : x < 0
    · simp [hn, absQ_of_neg hn, Rat.intCast_neg, Rat.neg_mul]
    · simp [hn, absQ_of_nonneg (show 0 ≤ x by grind)]

theorem round32_rtz_abs_le (x : Rat) (d : Finite32)
    (h : round32 .towardZero x = some d.bits) : absQ d.value ≤ absQ x := by
  rw [round32_rtz_truncGrid x d h]
  exact truncGrid_abs_le x _

theorem round32_rtz_error_of_scale (x : Rat) (d : Finite32) (R : Int)
    (hR : -126 ≤ R) (hx : absQ x < pow2 (R + 1))
    (h : round32 .towardZero x = some d.bits) :
    absQ (x - d.value) ≤ pow2 (R - 23) := by
  by_cases hz : x = 0
  · have hd := round32_rtz_abs_le x d h
    have hn := absQ_nonneg d.value
    subst x
    have ha : absQ (0 - d.value) = absQ d.value := by
      rw [show 0 - d.value = -d.value by grind, absQ_neg]
    rw [ha]
    have h0 : absQ 0 = 0 := by decide +kernel
    rw [h0] at hd
    have := pow2_pos (R - 23)
    grind
  · have hc := convExp_le_of_lt (absQ x) (absQ_pos_of_ne_zero x hz) R hx
    have hq := pow2_le_of_le (show convExp (absQ x) - 23 ≤ R - 23 by omega)
    rw [round32_rtz_truncGrid x d h]
    exact Rat.le_trans (Rat.le_of_lt (alignment_residual x _).2) hq

theorem block_local_error (b : PreparedBlock) (d : Finite32) (E R : Int)
    (hs : ScaleBounded b.terms E) (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E)
    (hR : -126 ≤ R) (hm : absQ b.accumulator < pow2 (R + 1))
    (hout : round32 .towardZero b.accumulator = some d.bits) :
    absQ (b.exactDot - d.value) ≤
      sumQ (b.terms.map fun t => rawAlignmentBudget t (E - b.profile.alignFraction)) +
        pow2 (R - 23) := by
  have ha := absQ_sumQ_le b.alignmentResiduals
  have hb := sumQ_map_mono b.terms
    (fun t => absQ (t.value - truncGrid t.value b.quantumExponent))
    (fun t => rawAlignmentBudget t (E - b.profile.alignFraction))
    (fun t ht => rawAlignmentBudget_sound b E hs hfl t ht)
  simp only [PreparedBlock.alignmentResiduals, List.map_map, Function.comp_def] at ha
  have halign : absQ (sumQ b.alignmentResiduals) ≤
      sumQ (b.terms.map fun t => rawAlignmentBudget t (E - b.profile.alignFraction)) :=
    Rat.le_trans ha hb
  have ho := round32_rtz_error_of_scale b.accumulator d R hR hm hout
  have hi := block_residual_identity b d.value
  unfold PreparedBlock.extractReference at hi
  have ht := absQ_add_le (b.accumulator - d.value) (sumQ b.alignmentResiduals)
  have he : b.exactDot - d.value = (b.accumulator - d.value) + sumQ b.alignmentResiduals := by grind
  rw [he]
  grind

end TensorCore
