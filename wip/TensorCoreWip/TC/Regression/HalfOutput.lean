import TensorCoreWip.TC.HalfOutput
import TensorCore.TC.Regression.Cases

/-! The V100 FP16-output path. The first published `V100/fp16` row with FP16 output
(`d_V100_fp16.txt`, c rounded to FP16 as the CUDA harness does) is reproduced by both
candidate stage orders, and a constructed input separates them: with the exact sum
`2 + 2^-10 + 2^-23`, one nearest-even rounding to FP16 (the reference source, `frmode = rne`)
rounds up to `4001`, while an FP32 truncation followed by FP16 rounding (the paper's figure)
lands on the midpoint and rounds to even, `4000`. -/

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

def halfRow : List (F16 × F16) := [(0x3bd5, 0x38ca), (0x3c3e, 0xb935), (0xb534, 0x36bf), (0x3df8, 0x34ec)]

/-- Published V100 FP16-output row 1: device output `3cdc` from both candidates. -/
theorem half_published_row :
    (invocationBits (p := v100HalfDirectCandidate) ⟨halfRow, 0x3bfa⟩).map BitVec.toNat =
      some 0x3cdc ∧
    (invocationBits (p := v100HalfStagedCandidate) ⟨halfRow, 0x3bfa⟩).map BitVec.toNat =
      some 0x3cdc := by decide +kernel

/-- A double-rounding input on which the two stage orders differ. -/
def halfSplitter : List (F16 × F16) := [(0x3c00, 0x3c00), (0x2800, 0x2800), (0x0c00, 0x1000), (0, 0)]

theorem half_output_stage_order :
    (invocationBits (p := v100HalfDirectCandidate) ⟨halfSplitter, 0x3c00⟩).map BitVec.toNat =
      some 0x4001 ∧
    (invocationBits (p := v100HalfStagedCandidate) ⟨halfSplitter, 0x3c00⟩).map BitVec.toNat =
      some 0x4000 ∧
    invocationIdeal (p := v100HalfDirectCandidate) ⟨halfSplitter, 0x3c00⟩ =
      some (2 + 1 / 1024 + 1 / 8388608) := by decide +kernel

end TensorCore.Regression
