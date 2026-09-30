-- Flowback for TC-EFT.

import TensorCore.TC.Flowback
import TensorCore.EFT.Algorithm1
import TensorCoreTests.EFT.EFT
import TensorCoreTests.TC.Monotonicity

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

/-- The V100 Table III witness in Definition III.3's terms: `c = 1`, `c' = 1 − 2^-24`, four
products `2^-24`. Every product flows back (`ω = 4·2^-24`), the accumulator input loses
`ΔA = 2^-24`, and the output rises from `3f800000` to `3f800001`. -/
theorem v100_witness_flowback :
    flowback v100F16F32 (List.replicate 4 (halfDecoded (-12), halfDecoded (-12)))
      oneDecoded belowOneDecoded = 4 / 16777216 ∧
    accumulatorShift v100F16F32 (List.replicate 4 (halfDecoded (-12), halfDecoded (-12)))
      oneDecoded belowOneDecoded = 1 / 16777216 ∧
    (evalPrepared ⟨v100F16F32, List.replicate 4 (halfDecoded (-12), halfDecoded (-12)),
      oneDecoded⟩).map (fun t => t.output.bits.toNat) = .ok 0x3f800000 ∧
    (evalPrepared ⟨v100F16F32, List.replicate 4 (halfDecoded (-12), halfDecoded (-12)),
      belowOneDecoded⟩).map (fun t => t.output.bits.toNat) = .ok 0x3f800001 := by
  decide +kernel

/-- Necessity is not sufficiency: with two products `ω = 2·2^-24` still exceeds
`ΔA = 2^-24`, but the perturbed accumulator `1 + 2^-24` is not representable and truncates
back to `1`, so the output does not rise. -/
theorem flowback_without_increase :
    flowback (fp16Fp32Profile 2 0 none) (List.replicate 2 (halfDecoded (-12), halfDecoded (-12)))
      oneDecoded belowOneDecoded = 2 / 16777216 ∧
    accumulatorShift (fp16Fp32Profile 2 0 none)
      (List.replicate 2 (halfDecoded (-12), halfDecoded (-12))) oneDecoded belowOneDecoded =
      1 / 16777216 ∧
    (evalPrepared ⟨fp16Fp32Profile 2 0 none,
      List.replicate 2 (halfDecoded (-12), halfDecoded (-12)), belowOneDecoded⟩).map
      (fun t => (t.output.bits.toNat, t.block.accumulator)) =
      .ok (0x3f800000, 16777217 / 16777216) := by
  decide +kernel

/-- Theorem III.4 as a failure of Definition III.2 on the V100 family with `K = 4`. -/
theorem v100_products_not_monotone :
    ¬ MonotoneInAccumulator v100F16F32 (List.replicate 4 (halfDecoded (-12), halfDecoded (-12))) :=
  construction_not_monotone v100F16F32 0 4 (halfDecoded (-12)) (halfDecoded (-12)) rfl
    (by simp [v100F16F32]) (by decide +kernel) (by decide +kernel)
    (by decide) (by decide)

/-- Algorithm 1 on the EFT cases: R3 takes the scalar branch, the coefficient-budget and
subnormal-accumulator cases take the exact reference branch. R3's overlap window is
`τ = 3` (extraction grid `2^-20` over alignment grid `2^-23`). -/
theorem algorithm1_cases :
    (evalBlock r3).map (fun t => (t.algorithm1, t.extractionExponent - t.block.quantumExponent)) =
      .ok (.scalar 0x41080000, 3) ∧
    (evalBlock supportOverflow).map (fun t => t.algorithm1) = .ok (.exactReference 0x4e800003) ∧
    (evalBlock subnormalAccumulator).map (fun t => t.algorithm1) =
      .ok (.exactReference 0x3f800001) := by
  decide +kernel

/-- TC-EFT Table V for `K = 4` (`n = 5` terms), and the implemented scalar
consolidation's `n + 2` operations, including its initial addition to zero. -/
theorem table_v_ledger :
    referenceLedger 4 = ⟨10, 5, 4, 5, 4, 1, 4, 2, 1⟩ ∧ scalarBranchOperations 4 = 7 := by
  decide

end TensorCore.Regression
