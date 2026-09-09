import TensorCore.IEEE.Precision
import Init.Data.Float.Model.Unpacked.Round

/-! Bridges from Lean's rounding metadata to the existing rational reference.
The reference remains independent of the implementation being compared. -/

namespace TensorCore.IEEE.LeanBridge

open Float.Model.UnpackedFloat

/-- Meaning of Lean's accuracy metadata relative to an exact rational input. -/
def AccuracyRepresents (a : Accuracy) (t : Rat) (m : Nat) : Prop :=
  t.floor = (m : Int) ∧ match a with
  | .exact => t = (m : Rat)
  | .inexact .lt => 0 < t - (m : Rat) ∧ 2 * (t - (m : Rat)) < 1
  | .inexact .eq => 2 * (t - (m : Rat)) = 1
  | .inexact .gt => 1 < 2 * (t - (m : Rat))

/-- Lean's rounding decision agrees with the rational nearest-even reference
whenever the supplied metadata describes the exact input. -/
theorem accuracy_round_eq_rne (a : Accuracy) (t : Rat) (m : Nat)
    (h : AccuracyRepresents a t m) :
    (a.roundToNearestEven m : Int) = rneInt t := by
  obtain ⟨hf, ha⟩ := h
  cases a with
  | exact =>
    simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
    simp [ha, Rat.sub_self]
    grind
  | inexact o =>
    cases o with
    | lt =>
      simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
      rw [if_neg (by grind)]
    | eq =>
      simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
      rw [ha]
      simp only [Rat.lt_irrefl, false_or, true_and, Int.natCast_add]
      split <;> omega
    | gt =>
      simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
      rw [if_pos (Or.inl ha)]
      omega

/-- One shift preserves the meaning of the retained mantissa and residual bits. -/
theorem shiftRightOne_represents (em : ExtendedMantissa) (t : Rat)
    (h : AccuracyRepresents em.accuracy t em.mantissa) :
    AccuracyRepresents em.shiftRightOne.accuracy (t / 2) em.shiftRightOne.mantissa := by
  obtain ⟨hf, ha⟩ := h
  have hb := floor_frac_bounds t
  rw [hf] at hb
  simp only [Rat.intCast_natCast] at hb
  have hm : (em.mantissa : Rat) =
      2 * ((em.mantissa / 2 : Nat) : Rat) + ((em.mantissa % 2 : Nat) : Rat) := by
    have he := Nat.div_add_mod em.mantissa 2
    have hc := congrArg (fun n : Nat => (n : Rat)) he
    simpa only [Rat.natCast_add, Rat.natCast_mul, Rat.natCast_ofNat] using hc.symm
  have hmod : em.mantissa % 2 = 0 ∨ em.mantissa % 2 = 1 := by omega
  have hq : (t / 2).floor = ((em.mantissa / 2 : Nat) : Int) := by
    apply Int.le_antisymm
    · have hu : t / 2 < (((em.mantissa / 2 : Nat) : Int) : Rat) + 1 := by
        simp only [Rat.intCast_natCast]
        apply (Rat.div_lt_iff (by decide : (0 : Rat) < 2)).mpr
        rcases hmod with he | he <;> rw [he] at hm <;> simp only [Rat.natCast_ofNat] at hm
        all_goals grind
      have := Rat.floor_le (t / 2)
      have hc : ((t / 2).floor : Rat) < (((em.mantissa / 2 : Nat) : Int) + 1 : Int) := by
        simp only [Rat.intCast_add, Rat.intCast_one]
        grind
      have := Rat.intCast_lt_intCast.mp hc
      omega
    · apply Rat.le_floor_iff.mpr
      simp only [Rat.intCast_natCast]
      apply le_div_of_mul_le _ _ _ (by decide : (0 : Rat) < 2)
      rcases hmod with he | he <;> rw [he] at hm <;> simp only [Rat.natCast_ofNat] at hm
      all_goals grind
  refine ⟨hq, ?_⟩
  have ht : t / 2 * 2 = t := Rat.div_mul_cancel (by decide)
  rcases em with ⟨m, r, s⟩
  dsimp at *
  cases r <;> cases s <;>
    simp only [ExtendedMantissa.accuracy] at ha <;>
    rcases hmod with he | he <;>
    simp [ExtendedMantissa.shiftRightOne, he, ExtendedMantissa.accuracy] <;>
    rw [he] at hm <;> simp only [Rat.natCast_ofNat] at hm
  all_goals grind

/-- Arbitrarily many shifts retain enough information for exact nearest-even
rounding; this is not restricted to any floating-point format. -/
theorem shiftRight_represents (em : ExtendedMantissa) (t : Rat) (n : Nat)
    (h : AccuracyRepresents em.accuracy t em.mantissa) :
    AccuracyRepresents (em >>> n).accuracy (t / pow2 (n : Int)) (em >>> n).mantissa := by
  induction n with
  | zero =>
    simpa [HShiftRight.hShiftRight, Nat.repeat, pow2, Rat.div_def,
      show (1 : Rat)⁻¹ = 1 from by decide +kernel, Rat.mul_one] using h
  | succ n ih =>
    have hs := shiftRightOne_represents (em >>> n) (t / pow2 (n : Int)) ih
    have he : t / pow2 (n : Int) / 2 = t / (pow2 (n : Int) * 2) := by
      have hp := pow2_pos (n : Int)
      have h1 := Rat.div_mul_cancel (a := t) (Rat.ne_of_gt hp)
      have h2 := Rat.div_mul_cancel (a := t / pow2 (n : Int)) (by decide : (2 : Rat) ≠ 0)
      have h3 := Rat.div_mul_cancel (a := t)
        (Rat.ne_of_gt (Rat.mul_pos hp (by decide : (0 : Rat) < 2)))
      grind
    simpa [HShiftRight.hShiftRight, Nat.repeat, pow2_succ, he] using hs

/-- Lean's exact mantissa plus shifts agrees with our rational rounding on
every nonnegative dyadic coefficient. -/
theorem shifted_round_eq_rne (m n : Nat) :
    ((ExtendedMantissa.ofMantissaAndAccuracy m .exact >>> n).roundedMantissa : Int) =
      rneInt ((m : Rat) / pow2 (n : Int)) := by
  apply accuracy_round_eq_rne
  apply shiftRight_represents
  constructor
  · simpa only [Rat.intCast_natCast, ExtendedMantissa.ofMantissaAndAccuracy] using
      Rat.floor_intCast (m : Int)
  · rfl

/-- The binade selected by the rational reference agrees with the integer
logarithm used by Lean's logical model. -/
theorem magnitudeExponent_dyadic (m : Nat) (e : Int) (hm : 0 < m) :
    magnitudeExponent ((m : Rat) * pow2 e) = (m.log2 : Int) + e := by
  apply magnitudeExponent_eq_of_bounds
  · rw [pow2_add, pow2_natCast]
    exact Rat.mul_le_mul_of_nonneg_right
      (Rat.natCast_le_natCast.mpr (Nat.log2_self_le (by omega)))
      (Rat.le_of_lt (pow2_pos e))
  · have he : (m.log2 : Int) + e + 1 = ((m.log2 + 1 : Nat) : Int) + e := by omega
    rw [he, pow2_add, pow2_natCast]
    exact (Rat.mul_lt_mul_right (pow2_pos e)).mpr
      (Rat.natCast_lt_natCast.mpr Nat.lt_log2_self)

/-- Exponent selection agrees, including the gradual-underflow floor. -/
theorem targetExponent32_eq (m : Nat) (e : Int) (hm : 0 < m) :
    Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent m e) =
      binaryConvExp fp32 ((m : Rat) * pow2 e) - fp32.fractionBits := by
  rw [binaryConvExp, magnitudeExponent_dyadic m e hm]
  simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
    Float.Model.Format.mantissaBits,
    Float.Model.Format.minExponent, fp32, Format.emin]
  omega

/-- Left alignment in Lean's model preserves the exact dyadic value. -/
theorem decreaseExponent_value (m : Nat) (e target : Int) :
    ((decreaseExponent m e target).1 : Rat) * pow2 (decreaseExponent m e target).2 =
      (m : Rat) * pow2 e := by
  simp only [decreaseExponent, Nat.shiftLeft_eq, Rat.natCast_mul]
  rw [← pow2_natCast, Rat.mul_assoc, ← pow2_add]
  congr 2
  omega

/-- The first alignment and rounding pass computes the reference coefficient
on any coarser dyadic grid. -/
theorem shiftToExponent_round_eq (m : Nat) (e target : Int) (he : e ≤ target) :
    ((shiftToExponent m e .exact target).1.roundedMantissa : Int) =
      rneInt ((m : Rat) * pow2 e / pow2 target) := by
  simp only [shiftToExponent]
  rw [shifted_round_eq_rne]
  congr 1
  have hn : ((target - e).toNat : Int) = target - e := Int.toNat_of_nonneg (by omega)
  rw [hn]
  have hp : pow2 (target - e) * pow2 e = pow2 target := by
    rw [← pow2_add]; congr 1; omega
  have h1 := Rat.div_mul_cancel (a := (m : Rat)) (Rat.ne_of_gt (pow2_pos (target - e)))
  have h2 := Rat.div_mul_cancel (a := (m : Rat) * pow2 e) (Rat.ne_of_gt (pow2_pos target))
  have hne := Rat.ne_of_gt (pow2_pos target)
  grind

/-- The second pass is exactly the single-bit carry of binary32 precision. -/
theorem secondPass32 (k : Nat) (e : Int) (hk : k ≤ 2 ^ 24) (he : -149 ≤ e) :
    shiftToTargetExponent Float.Model.Format.binary32 k e .exact =
      if k = 2 ^ 24 then (⟨2 ^ 23, false, false⟩, e + 1)
      else (⟨k, false, false⟩, e) := by
  by_cases hc : k = 2 ^ 24
  · subst k
    have ht : Float.Model.Format.binary32.targetExponent
        (Float.Model.totalExponent (2 ^ 24) e) = e + 1 := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Nat.log2_two_pow, Float.Model.Format.mantissaBits,
        Float.Model.Format.minExponent]
      omega
    simp only [shiftToTargetExponent, ht, shiftToExponent, show e + 1 - e = 1 from by omega,
      show (1 : Int).toNat = 1 from rfl, HShiftRight.hShiftRight, Nat.repeat,
      ExtendedMantissa.ofMantissaAndAccuracy, ExtendedMantissa.shiftRightOne,
      ↓reduceIte]
    rfl
  · have hl : k.log2 ≤ 23 := by
      by_cases hz : k = 0
      · simp [hz]
      · have := (Nat.log2_lt hz).mpr (show k < 2 ^ 24 by omega)
        omega
    have ht : Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent k e) ≤ e := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Float.Model.Format.mantissaBits, Float.Model.Format.minExponent]
      omega
    have hn : (Float.Model.Format.binary32.targetExponent
        (Float.Model.totalExponent k e) - e).toNat = 0 := by omega
    simp [shiftToTargetExponent, shiftToExponent, hn, hc, HShiftRight.hShiftRight,
      Nat.repeat, ExtendedMantissa.ofMantissaAndAccuracy]

/-- The first normalization pass selects the same exponent and nearest-even
coefficient as the independent rational reference. -/
theorem firstPass32 (m : Nat) (e : Int) (hm : 0 < m) :
    let q := Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent m e)
    let d := decreaseExponent m e q
    let first := shiftToTargetExponent Float.Model.Format.binary32 d.1 d.2 .exact
    first.2 = q ∧ (first.1.roundedMantissa : Int) =
      rneInt ((m : Rat) * pow2 e / pow2 q) := by
  intro q d first
  have hd : 0 < d.1 := by
    dsimp [d, decreaseExponent]
    rw [Nat.shiftLeft_eq]
    exact Nat.mul_pos hm (Nat.two_pow_pos _)
  have hv := decreaseExponent_value m e q
  have hq : Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent d.1 d.2) = q := by
    rw [targetExponent32_eq d.1 d.2 hd, hv]
    exact (targetExponent32_eq m e hm).symm
  have he : d.2 ≤ q := by dsimp [d, decreaseExponent]; omega
  have hs : first = shiftToExponent d.1 d.2 .exact q := by
    dsimp only [first, shiftToTargetExponent]
    rw [hq]
  rw [hs]
  constructor
  · dsimp [shiftToExponent]; omega
  · rw [shiftToExponent_round_eq _ _ _ he, hv]

end TensorCore.IEEE.LeanBridge
