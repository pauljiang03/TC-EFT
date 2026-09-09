import TensorCore.IEEE.LeanRounding

/-! Binary64 specialization of exponent and carry alignment. The rational
rounding, shift, and exact-value lemmas are shared with binary32. -/

namespace TensorCore.IEEE.LeanBridge

open Float.Model.UnpackedFloat

theorem targetExponent64_eq (m : ℕ) (e : ℤ) (hm : 0 < m) :
    Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e) =
      binaryConvExp fp64 ((m : ℚ) * pow2 e) - fp64.fractionBits := by
  rw [binaryConvExp, magnitudeExponent_dyadic m e hm]
  simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
    Float.Model.Format.mantissaBits,
    Float.Model.Format.minExponent, fp64, Format.emin]
  omega

theorem secondPass64 (k : ℕ) (e : ℤ) (hk : k ≤ 2 ^ 53) (he : -1074 ≤ e) :
    shiftToTargetExponent Float.Model.Format.binary64 k e .exact =
      if k = 2 ^ 53 then (⟨2 ^ 52, false, false⟩, e + 1)
      else (⟨k, false, false⟩, e) := by
  by_cases hc : k = 2 ^ 53
  · subst k
    have ht : Float.Model.Format.binary64.targetExponent
        (Float.Model.totalExponent (2 ^ 53) e) = e + 1 := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Nat.log2_two_pow, Float.Model.Format.mantissaBits,
        Float.Model.Format.minExponent]
      omega
    simp only [shiftToTargetExponent, ht, shiftToExponent, show e + 1 - e = 1 from by omega,
      show (1 : ℤ).toNat = 1 from rfl, HShiftRight.hShiftRight, Nat.repeat,
      ExtendedMantissa.ofMantissaAndAccuracy, ExtendedMantissa.shiftRightOne,
      ↓reduceIte]
    rfl
  · have hl : k.log2 ≤ 52 := by
      by_cases hz : k = 0
      · simp [hz]
      · have := (Nat.log2_lt hz).mpr (show k < 2 ^ 53 by omega)
        omega
    have ht : Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent k e) ≤ e := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Float.Model.Format.mantissaBits, Float.Model.Format.minExponent]
      omega
    have hn : (Float.Model.Format.binary64.targetExponent
        (Float.Model.totalExponent k e) - e).toNat = 0 := by omega
    simp [shiftToTargetExponent, shiftToExponent, hn, hc, HShiftRight.hShiftRight,
      Nat.repeat, ExtendedMantissa.ofMantissaAndAccuracy]

theorem firstPass64 (m : ℕ) (e : ℤ) (hm : 0 < m) :
    let q := Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)
    let d := decreaseExponent m e q
    let first := shiftToTargetExponent Float.Model.Format.binary64 d.1 d.2 .exact
    first.2 = q ∧ (first.1.roundedMantissa : ℤ) =
      rneInt ((m : ℚ) * pow2 e / pow2 q) := by
  intro q d first
  have hd : 0 < d.1 := by
    dsimp [d, decreaseExponent]
    rw [Nat.shiftLeft_eq]
    exact Nat.mul_pos hm (Nat.two_pow_pos _)
  have hv := decreaseExponent_value m e q
  have hq : Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent d.1 d.2) = q := by
    rw [targetExponent64_eq d.1 d.2 hd, hv]
    exact (targetExponent64_eq m e hm).symm
  have he : d.2 ≤ q := by dsimp [d, decreaseExponent]; omega
  have hs : first = shiftToExponent d.1 d.2 .exact q := by
    dsimp only [first, shiftToTargetExponent]
    rw [hq]
  rw [hs]
  constructor
  · dsimp [shiftToExponent]; omega
  · rw [shiftToExponent_round_eq _ _ _ he, hv]

end TensorCore.IEEE.LeanBridge
