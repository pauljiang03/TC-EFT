import TensorCore.EFT.Encoded
import TensorCore.TC.EncodedMonotonicity
import TensorCoreTests.EFT.EFT

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

theorem encoded_eft_branches :
    algorithm1Encoded r3 0x4107ffff = .ok (.consolidated (.scalar 0x41080000)) ∧
    algorithm1Encoded subnormalAccumulator 0x3f800000 =
      .ok (.consolidated (.exactReference 0x3f800001)) ∧
    algorithm1Encoded supportOverflow 0x4e800000 =
      .ok (.consolidated (.exactReference 0x4e800003)) := by decide +kernel

/-- Signed zero and even an unrelated finite supplied D take the paper's +0 shortcut. -/
theorem encoded_eft_all_zero :
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0x80000000⟩ : V100Input) 0x80000000 =
      .ok .allZero ∧
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0⟩ : V100Input) 0x7f7fffff =
      .ok .allZero ∧
    EncodedEFTResult.allZero.bits = some 0 := by decide +kernel

/-- The accumulator is included in the all-zero test; arbitrary finite D is permitted. -/
theorem encoded_eft_nonzero_c :
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0x3f800000⟩ : V100Input) 0x40000000 =
      .ok (.consolidated (.scalar 0x3f800000)) := by decide +kernel

/-- Nonzero terms cancelling to zero still execute consolidation. -/
theorem encoded_eft_cancellation :
    algorithm1Encoded (⟨[(0x3c00, 0x3c00), (0xbc00, 0x3c00), (0, 0), (0, 0)], 0⟩ :
      V100Input) 0 = .ok (.consolidated (.scalar 0)) := by decide +kernel

theorem encoded_eft_rejections :
    algorithm1Encoded (⟨[], 0⟩ : V100Input) 0 = .error .wrongProductCount ∧
    algorithm1Encoded (⟨List.replicate 4 (0x7c00, 0), 0⟩ : V100Input) 0 = .error .nonfiniteInput ∧
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0x7fc00000⟩ : V100Input) 0 =
      .error .nonfiniteInput ∧
    algorithm1Encoded (⟨List.replicate 4 (0, 0), 0⟩ : V100Input) 0x7f800000 =
      .error .nonfiniteOutput ∧
    algorithm1Encoded (⟨[(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)], 0x7f7fffff⟩ :
      V100Input) 0 = .ok (.consolidated .outOfRange) := by decide +kernel

/-- Definition III.2 on actual FP32 words: decreasing c raises the V100 output. -/
theorem encoded_v100_not_monotone :
    ¬ MonotoneInEncodedAccumulator v100F16F32 (List.replicate 4 (0x0c00, 0x0c00)) := by
  intro h
  have hbad := h 0x3f800000 0x3f7fffff 1 (1 - pow2 (-24)) 1 (1 + pow2 (-23))
    (by decide +kernel) (by decide +kernel) (by decide +kernel) (by decide +kernel)
    (by decide +kernel)
  have hn : ¬ (1 + pow2 (-23) : ℚ) ≤ 1 := by decide +kernel
  exact hn hbad

end TensorCore.Regression
