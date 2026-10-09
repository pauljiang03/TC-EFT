import TensorCore.Numerics.Binary.RoundingContract
import TensorCore.TC.FinalRounding

/-! Correct rounding and IEEE signed zero for fused FP64 invocations. -/

namespace TensorCore

/-- Accepted FP64 DMMA arithmetic is correctly rounded in each of the four modes, with the original-input ideal and the output sign made explicit. -/
theorem binary64Fma_correct {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) :
    invocationIdeal x = some t.intermediate.value ∧
    BinaryRoundSpec fp64 mode t.intermediate.value t.output.bits ∧
    binarySign fp64 t.output.bits = decide (t.intermediate.value < 0) := by
  have hout := evalInvocation_output h
  obtain ⟨b, hb, hc⟩ := roundBinary_correct fp64 (by decide) mode t.intermediate.value hout.2
  have heq := Option.some.inj (hb.symm.trans hout.1)
  rw [heq] at hc
  exact ⟨binary64Fma_exact_input h, hc, roundBinary_sign fp64 mode _ _ hout.1⟩

/-- FP64 DMMA succeeds whenever its exact result is in range. -/
theorem binary64Fma_success (mode : BinaryRoundingMode) (x : InvocationInput (binary64Fma mode))
    (b : PreparedInvocation (binary64Fma mode)) (hp : prepareInvocation x = some b)
    (hn : x.products.length = 1) (hr : absQ b.exactDot ≤ fp64.maxFinite) :
    ∃ t, evalInvocation x = .ok t := by
  unfold binary64Fma at *
  obtain ⟨bits, hb, hc⟩ := roundBinary_correct fp64 (by decide) mode b.exactDot hr
  obtain ⟨d, hd⟩ := hc.finite
  have hconv : (RoundingStage.mk fp64 mode).roundValue b.exactDot =
      some ⟨bits, d, hd⟩ := by
    simp only [RoundingStage.roundValue, hb]
    exact finiteBinary_some hd
  have hv : (binary64Fma mode).Valid := by cases mode <;> decide +kernel
  unfold evalInvocation
  rw [if_neg (fun h => h hv), if_neg (by simp [hn]), hp]
  simp only [evalInvocationPrepared, accumulateInvocation, runRoundings]
  rw [hconv]
  exact ⟨_, rfl⟩

/-- IEEE 754 sign of an exact zero sum: `+0`, or `−0` toward negative, unless both addends share a sign. -/
def fusedZeroNegative (mode : BinaryRoundingMode) (productNegative cNegative : Bool) : Bool :=
  if productNegative == cNegative then productNegative else decide (mode = .towardNegative)

/-- FP64 DMMA output bits with IEEE 754 signed zero for an exactly zero `a·b + c`. -/
def binary64FmaBits {mode : BinaryRoundingMode} (x : InvocationInput (binary64Fma mode)) :
    Option (BitVec fp64.width) :=
  match evalInvocation x, x.products with
  | .ok t, [(a, b)] =>
    if t.intermediate.value = 0 then
      some (if fusedZeroNegative mode (a.msb != b.msb) x.c.msb then BitVec.ofNat _ (2 ^ 63) else 0)
    else some t.output.bits
  | _, _ => none

theorem binary64Fma_single {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) : ∃ a b, x.products = [(a, b)] := by
  have hn : x.products.length = 1 := by
    unfold evalInvocation at h
    split at h
    · simp at h
    · split at h
      · simp at h
      · rename_i hlen; simpa [binary64Fma] using hlen
  obtain ⟨⟨a, b⟩, hp⟩ := List.length_eq_one_iff.mp hn
  exact ⟨a, b, hp⟩

/-- A nonzero exact result keeps the correctly rounded bits of `evalInvocation`. -/
theorem binary64FmaBits_of_ne_zero {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) (hz : t.intermediate.value ≠ 0) :
    binary64FmaBits x = some t.output.bits := by
  obtain ⟨a, b, hp⟩ := binary64Fma_single h
  unfold binary64FmaBits
  rw [h, hp]
  exact if_neg hz

/-- An exactly zero result is `±0` with the IEEE 754 sign. -/
theorem binary64FmaBits_of_eq_zero {mode : BinaryRoundingMode}
    {x : InvocationInput (binary64Fma mode)} {t : InvocationTrace (binary64Fma mode)}
    (h : evalInvocation x = .ok t) (hz : t.intermediate.value = 0) :
    ∃ a b, x.products = [(a, b)] ∧ binary64FmaBits x =
      some (if fusedZeroNegative mode (a.msb != b.msb) x.c.msb then BitVec.ofNat _ (2 ^ 63) else 0) := by
  obtain ⟨a, b, hp⟩ := binary64Fma_single h
  refine ⟨a, b, hp, ?_⟩
  unfold binary64FmaBits
  rw [h, hp]
  exact if_pos hz

end TensorCore
