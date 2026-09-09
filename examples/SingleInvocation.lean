import TensorCore.Meta.Syntax

open TensorCore

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000

/-- One V100 normalization group: four FP16 products plus the incoming FP32 c.
Each product is 1.5 * 1.25; c is 1 - 2^-24. -/
def singleInvocation : Program v100F16F32 := tc%{
  block "one V100 group" [(0x3e00, 0x3d00), (0x3e00, 0x3d00),
    (0x3e00, 0x3d00), (0x3e00, 0x3d00)];
}

theorem exactly_one_invocation : singleInvocation.blocks.length = 1 := by decide +kernel

/-- The uncorrected model returns these FP32 bits. -/
theorem single_model_output :
    (singleInvocation.run 0x3f7fffff).map (fun ts => ts.map (fun t => t.output.bits.toNat)) =
      .ok [0x4107ffff] := by decide +kernel

/-- Both loss stages are included in the exact reference correction. -/
theorem single_reference_result :
    (singleInvocation.report 0x3f7fffff).map (fun r =>
      (r.ideal, r.residual, r.recovered, r.correctedBits)) =
      .ok (some (17 / 2 - pow2 (-24)), 15 * pow2 (-24),
        17 / 2 - pow2 (-24), some 0x41080000) := by decide +kernel

-- Proves successful execution, exact recovery, and nearest-even reference correction.
tc_verify single_correct : singleInvocation from 0x3f7fffff

#print axioms exactly_one_invocation
#print axioms single_model_output
#print axioms single_reference_result

tc_inspect singleInvocation from 0x3f7fffff
