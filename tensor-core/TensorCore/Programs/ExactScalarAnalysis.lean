import TensorCore.Programs.ScalarAnalysis

namespace TensorCore

def checkFiniteMultiply (mode : BinaryRoundingMode) (a M : Rat) (E : Int) : Option ScalarBound :=
  if a = 1 ∨ a = -1 then some ⟨M, 0⟩ else checkScalar ⟨fp32, mode⟩ (absQ a * M) E

theorem checkFiniteMultiply_sound (mode : BinaryRoundingMode) (a M : Rat) (E : Int)
    (b : ScalarBound) (h : checkFiniteMultiply mode a M E = some b)
    (x : Rat) (hf : fp32.FiniteValue x) (hx : absQ x ≤ M) :
    ∃ d, (ConversionStage.mk fp32 mode).convert (a * x) = some d ∧
      absQ d.value ≤ b.magnitude ∧ absQ (a * x - d.value) ≤ b.error := by
  unfold checkFiniteMultiply at h
  split at h
  next ha =>
    cases Option.some.inj h
    have hfinite : fp32.FiniteValue (a * x) := by
      rcases ha with rfl | rfl
      · simpa using hf
      · simpa [Rat.neg_mul] using fp32.finiteValue_neg hf
    obtain ⟨d, hd, hv⟩ := conversion_exact_value ⟨fp32, mode⟩ (by change fp32.WellFormed; decide) (a * x) hfinite
    refine ⟨d, hd, ?_, by simp [hv, Rat.sub_self, absQ]⟩
    rw [hv]
    rcases ha with rfl | rfl <;> simpa [Rat.neg_mul, absQ_neg] using hx
  next _ =>
    exact checkScalar_sound _ _ _ b h (a * x) (by
      rw [gemmAbs_mul]
      exact Rat.mul_le_mul_of_nonneg_left hx (absQ_nonneg a))

def checkFiniteAdd (mode : BinaryRoundingMode) (A B : Rat) (E : Int) : Option ScalarBound :=
  if A = 0 ∨ B = 0 then some ⟨A + B, 0⟩ else checkScalar ⟨fp32, mode⟩ (A + B) E

theorem checkFiniteAdd_sound (mode : BinaryRoundingMode) (A B : Rat) (E : Int)
    (b : ScalarBound) (h : checkFiniteAdd mode A B E = some b)
    (x y : FiniteBinary fp32) (hx : absQ x.value ≤ A) (hy : absQ y.value ≤ B) :
    ∃ d, (ConversionStage.mk fp32 mode).convert (x.value + y.value) = some d ∧
      absQ d.value ≤ b.magnitude ∧ absQ (x.value + y.value - d.value) ≤ b.error := by
  have hm : absQ (x.value + y.value) ≤ A + B := by
    have := absQ_add_le x.value y.value
    grind
  unfold checkFiniteAdd at h
  split at h
  next hz =>
    cases Option.some.inj h
    have hf : fp32.FiniteValue (x.value + y.value) := by
      rcases hz with hz | hz
      · have hx0 : x.value = 0 := by have := (absQ_le_iff _ _).mp hx; grind
        rw [hx0, Rat.zero_add]
        exact classifyNat_finiteValue fp32 (by decide) y.bits.toNat y.decoded y.valid
      · have hy0 : y.value = 0 := by have := (absQ_le_iff _ _).mp hy; grind
        rw [hy0, Rat.add_zero]
        exact classifyNat_finiteValue fp32 (by decide) x.bits.toNat x.decoded x.valid
    obtain ⟨d, hd, hv⟩ := conversion_exact_value ⟨fp32, mode⟩ (by change fp32.WellFormed; decide) _ hf
    exact ⟨d, hd, by simpa [hv] using hm, by simp [hv, Rat.sub_self, absQ]⟩
  next _ => exact checkScalar_sound _ _ _ b h _ hm

end TensorCore
