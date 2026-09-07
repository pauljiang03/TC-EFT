import TensorCore.Programs.ScaledGemmBounds

/-! Mode-sensitive error budgets under the existing finite-domain conversion and
GEMM checks. RNE contributes at most half a spacing, including subnormal grids;
directed modes retain a one-spacing budget. No arithmetic or guard changes. -/

namespace TensorCore

def roundingBudgetFactor : BinaryRoundingMode → Rat
  | .nearestEven => 1 / 2
  | _ => 1

theorem roundingBudgetFactor_pos (mode : BinaryRoundingMode) : 0 < roundingBudgetFactor mode := by
  cases mode <;> decide +kernel

theorem roundingBudgetFactor_le_one (mode : BinaryRoundingMode) : roundingBudgetFactor mode ≤ 1 := by
  cases mode <;> decide +kernel

def gemmConversionModeError (s : ConversionStage) (E : Int) : Rat :=
  roundingBudgetFactor s.mode * gemmConversionError s.format E

theorem gemmConversionModeError_pos (s : ConversionStage) (E : Int) :
    0 < gemmConversionModeError s E :=
  Rat.mul_pos (roundingBudgetFactor_pos s.mode) (pow2_pos _)

theorem gemmConversionModeError_le (s : ConversionStage) (E : Int) :
    gemmConversionModeError s E ≤ gemmConversionError s.format E := by
  have h := Rat.mul_le_mul_of_nonneg_right (roundingBudgetFactor_le_one s.mode)
    (Rat.le_of_lt (pow2_pos (E - s.format.fractionBits)))
  simpa only [Rat.one_mul, gemmConversionModeError, gemmConversionError] using h

private theorem coefficient_error (mode : BinaryRoundingMode) (negative : Bool) (x : Rat) :
    absQ (x - binaryCoefficient mode negative x) ≤ roundingBudgetFactor mode := by
  have hf := Rat.floor_le x
  have hf' := Rat.lt_floor_add_one x
  have hc := Rat.le_ceil (x := x)
  have hc' := Rat.ceil_lt (x := x)
  cases mode with
  | nearestEven =>
    have h := rneInt_dist_le_half x
    change absQ (x - rneInt x) ≤ 1 / 2
    grind
  | towardZero =>
    change absQ (x - x.floor) ≤ 1
    apply (absQ_le_iff _ _).mpr
    constructor <;> grind
  | towardNegative =>
    simp only [binaryCoefficient, roundingBudgetFactor]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind
  | towardPositive =>
    simp only [binaryCoefficient, roundingBudgetFactor]
    split <;> apply (absQ_le_iff _ _).mpr <;> constructor <;> grind

private theorem magnitude_error (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : Rat) :
    absQ (m - binaryMagnitudeRounded f mode negative m) ≤
      roundingBudgetFactor mode * pow2 (binaryConvExp f m - f.fractionBits) := by
  let q := pow2 (binaryConvExp f m - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  have h := Rat.mul_le_mul_of_nonneg_right (coefficient_error mode negative (m / q))
    (Rat.le_of_lt hq)
  rw [← absQ_mul_pos _ q hq] at h
  have he : (m / q - (binaryCoefficient mode negative (m / q) : Rat)) * q =
      m - (binaryCoefficient mode negative (m / q) : Rat) * q := by
    have := Rat.div_mul_cancel (Rat.ne_of_gt hq) (a := m)
    grind
  rw [he] at h
  exact h

private theorem signed_error (f : Format) (mode : BinaryRoundingMode) (x : Rat) :
    absQ (x - binarySignedRounded f mode x) ≤
      roundingBudgetFactor mode * pow2 (binaryConvExp f (absQ x) - f.fractionBits) := by
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

/-- Supplied magnitude scales bound rounding error without inspecting an output. -/
theorem gemmConversion_mode_error (s : ConversionStage) (E : Int) (hE : s.format.emin ≤ E)
    (x : Rat) (hx : absQ x ≤ pow2 E) (d : FiniteBinary s.format)
    (h : s.convert x = some d) : absQ (x - d.value) ≤ gemmConversionModeError s E := by
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
    exact Rat.le_of_lt (gemmConversionModeError_pos s E)
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
    exact Rat.le_trans (signed_error s.format s.mode x)
      (Rat.mul_le_mul_of_nonneg_left hq (Rat.le_of_lt (roundingBudgetFactor_pos s.mode)))


end TensorCore
