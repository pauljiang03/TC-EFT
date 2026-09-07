import TensorCore.Programs.ScaledGemm

/-! Input-derived, format-generic conversion bounds for every rounding direction.
The bound is one spacing at a supplied magnitude scale, including subnormals. -/

namespace TensorCore

private theorem coefficient_error (mode : BinaryRoundingMode) (negative : Bool) (x : Rat) :
    absQ (x - binaryCoefficient mode negative x) ≤ 1 := by
  have hf := Rat.floor_le x
  have hf' := Rat.lt_floor_add_one x
  have hc := Rat.le_ceil (x := x)
  have hc' := Rat.ceil_lt (x := x)
  cases mode with
  | nearestEven =>
    have h := rneInt_dist_le_half x
    change absQ (x - rneInt x) ≤ 1
    grind
  | towardZero =>
    apply (absQ_le_iff _ _).mpr
    simp only [binaryCoefficient]
    constructor <;> grind
  | towardNegative =>
    simp only [binaryCoefficient]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind
  | towardPositive =>
    simp only [binaryCoefficient]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind

private theorem magnitude_error (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : Rat) :
    absQ (m - binaryMagnitudeRounded f mode negative m) ≤
      pow2 (binaryConvExp f m - f.fractionBits) := by
  let q := pow2 (binaryConvExp f m - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  have h := Rat.mul_le_mul_of_nonneg_right (coefficient_error mode negative (m / q))
    (Rat.le_of_lt hq)
  rw [← absQ_mul_pos _ q hq, Rat.one_mul] at h
  have he : (m / q - (binaryCoefficient mode negative (m / q) : Rat)) * q =
      m - (binaryCoefficient mode negative (m / q) : Rat) * q := by
    have := Rat.div_mul_cancel (Rat.ne_of_gt hq) (a := m)
    grind
  rw [he] at h
  exact h

private theorem signed_error (f : Format) (mode : BinaryRoundingMode) (x : Rat) :
    absQ (x - binarySignedRounded f mode x) ≤
      pow2 (binaryConvExp f (absQ x) - f.fractionBits) := by
  by_cases hn : x < 0
  · have h := magnitude_error f mode true (absQ x)
    have he : x - -binaryMagnitudeRounded f mode true (absQ x) =
        -(absQ x - binaryMagnitudeRounded f mode true (absQ x)) := by
      rw [absQ_of_neg hn]
      grind
    simpa only [binarySignedRounded, if_pos hn, he, absQ_neg] using h
  · have h := magnitude_error f mode false (absQ x)
    have hx : absQ x = x := absQ_of_nonneg (by grind)
    simpa only [binarySignedRounded, if_neg hn, hx] using h

/-- Finite-domain conversion is total for every supported rounding direction. -/
theorem gemmConversion_total (s : ConversionStage) (hf : s.format.WellFormed)
    (x : Rat) (hr : absQ x ≤ s.format.maxFinite) :
    ∃ d, s.convert x = some d := by
  have hex : ∃ bits y, roundBinary s.format s.mode x = some bits ∧
      binaryValue s.format bits = some y := by
    by_cases hx : x = 0
    · subst x
      refine ⟨0, 0, ?_, binaryValue_zero s.format hf⟩
      simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
      rw [if_neg (by grind)]
    · obtain ⟨bits, hb, hv, _⟩ := roundBinary_nonzero_spec s.format hf s.mode x hx hr
      exact ⟨bits, _, hb, hv⟩
  obtain ⟨bits, y, hb, hv⟩ := hex
  cases hd : (classify s.format bits).finite with
  | none => simp [binaryValue, hd] at hv
  | some d =>
    refine ⟨⟨bits, d, hd⟩, ?_⟩
    simp [ConversionStage.convert, hb, finiteBinary_some hd]

def gemmConversionError (f : Format) (E : Int) : Rat := pow2 (E - f.fractionBits)

/-- Supplied magnitude scales bound rounding error without inspecting an output. -/
theorem gemmConversion_error (s : ConversionStage) (E : Int) (hE : s.format.emin ≤ E)
    (x : Rat) (hx : absQ x ≤ pow2 E) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : absQ (x - d.value) ≤ gemmConversionError s.format E := by
  have hf := (conversionStage_range h).1
  have hr := (conversionStage_range h).2
  have hb := conversionStage_output h
  have hd : binaryValue s.format d.bits = some d.value := by simp [binaryValue, d.valid, FiniteBinary.value]
  by_cases hz : x = 0
  · subst x
    have hb0 : roundBinary s.format s.mode 0 = some 0 := by
      simp only [roundBinary, hf, not_true_eq_false, ↓reduceIte]
      rw [if_neg (by grind)]
    rw [hb0] at hb
    rw [← Option.some.inj hb, binaryValue_zero s.format hf] at hd
    have hv : d.value = 0 := (Option.some.inj hd).symm
    simp only [hv, Rat.sub_self]
    exact Rat.le_of_lt (pow2_pos _)
  · obtain ⟨bits, hb', hv, _⟩ := roundBinary_nonzero_spec s.format hf s.mode x hz hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hv
    have hvalue := Option.some.inj hv
    have he := magnitudeExponent_le_of_lt (absQ x) (absQ_pos_of_ne_zero x hz) E
      (by have := pow2_lt_succ E; grind)
    have hconv : binaryConvExp s.format (absQ x) ≤ E := by
      unfold binaryConvExp
      omega
    have hq := pow2_le_of_le (show binaryConvExp s.format (absQ x) - s.format.fractionBits ≤
      E - s.format.fractionBits by omega)
    rw [hvalue]
    exact Rat.le_trans (signed_error s.format s.mode x) hq

/-- Acceptance, rounding error and an output-magnitude bound derived from a cap. -/
theorem gemmConversion_bounded (s : ConversionStage) (E : Int)
    (hf : s.format.WellFormed) (hE : s.format.emin ≤ E)
    (hmax : pow2 E ≤ s.format.maxFinite) (x : Rat) (hx : absQ x ≤ pow2 E) :
    ∃ d, s.convert x = some d ∧
      absQ (x - d.value) ≤ gemmConversionError s.format E ∧
      absQ d.value ≤ pow2 E + gemmConversionError s.format E := by
  obtain ⟨d, hd⟩ := gemmConversion_total s hf x (Rat.le_trans hx hmax)
  have he := gemmConversion_error s E hE x hx d hd
  have ha := absQ_add_le x (d.value - x)
  rw [absQ_sub_comm d.value x] at ha
  refine ⟨d, hd, he, ?_⟩
  have hid : x + (d.value - x) = d.value := by grind
  rw [hid] at ha
  grind

end TensorCore
