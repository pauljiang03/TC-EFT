-- Application for the tensor-core model.

import TensorCore.TC.Examples.BoundedDot
import TensorCore.TC.Regression.Certification

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

def one32 : Finite32 := ⟨0x3f800000, ⟨8388608, 0, 23⟩, by decide +kernel⟩

def smallBody : Program v100F16F32 := tc%{
  block "changing state" [(0x2bff, 0x2bff), (0x2bff, 0x2bff),
    (0x2bff, 0x2bff), (0x2bff, 0x2bff)];
}

theorem symbolic_changing_loop (n : ℕ) (hn : n ≤ 64) :
    (Program.repeat n smallBody).Accurate one32.bits (1 / 2048) := by
  apply small_repeat_accurate smallBody n one32
  · simpa [smallBody, Program.inputs, Program.blocks] using hn
  · intro g hg pair hp
    have hg' : g = [(0x2bff, 0x2bff), (0x2bff, 0x2bff), (0x2bff, 0x2bff), (0x2bff, 0x2bff)] := by
      simpa [smallBody, Program.inputs, Program.blocks, BlockOperands.ofNats] using hg
    rw [hg'] at hp
    have hp' : pair = (0x2bff, 0x2bff) := by simpa using hp
    rw [hp']
    decide +kernel
  · decide +kernel

theorem changing_loop_has_rounding_error :
    (match lossyProgram.run one32.bits with
      | .error _ => false
      | .ok ts => (lastOutput one32 ts).bits != one32.bits &&
          decide ((lossyProgram.ideal one32.bits).getD 0 ≠ (lastOutput one32 ts).value)) = true := by
  decide +kernel

theorem partial_tail_signed_accepted :
    boundedDotCheck [(0x2bff, 0x2bff), (0xabff, 0x2bff), (0x0001, 0x8001)] one32.bits = true := by
  decide +kernel

theorem at_operand_boundary_refused : small16 0x2c00 = false := by decide +kernel
theorem nan_operand_refused : small16 0x7e00 = false := by decide +kernel
theorem signed_zero_allowed : small16 0x8000 = true := by decide +kernel
theorem too_long_refused : boundedDotCheck (List.replicate 257 (0, 0)) 0 = false := by decide +kernel
theorem initial_outside_family_refused : boundedDotCheck [] 0x40000000 = false := by decide +kernel

end TensorCore.Regression
