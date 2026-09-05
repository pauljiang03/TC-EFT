import TensorCore.Meta.Syntax
import TensorCore.Regression.Composition
import TensorCore.Programs.Loops

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 2000000

def cancellationProgram : Program v100F16F32 := tc%{
  block "R3" [(0x3e00, 0x3d00), (0x3e00, 0x3d00),
    (0x3e00, 0x3d00), (0x3e00, 0x3d00)];
  block "subtract 8.5" [(0xc000, 0x4400), (0xb800, 0x3c00), (0, 0), (0, 0)];
}

/-- Inspect the elaborated operand order as well as checking the generated theorem. -/
theorem cancellation_program_inputs : cancellationProgram.inputs =
    [r3.products, cancelEightAndHalf] := by decide +kernel

tc_verify cancellation_program_correct : cancellationProgram from 0x3f7fffff

theorem cancellation_program_report :
    (cancellationProgram.report 0x3f7fffff).map (fun r =>
      (r.outputBits, r.ideal, r.recovered, r.correctedBits)) =
    .ok ([0x4107ffff, 0xb5800000], some (-1 / 16777216), -1 / 16777216, some 0xb3800000) := by
  decide +kernel

def repeatedProgram : Program v100F16F32 := tc%{
  repeat (3) {
    block "add 1" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  }
}

tc_verify repeated_program_correct : repeatedProgram from 0

theorem repeated_program_report :
    (repeatedProgram.report 0).map (fun r => (r.outputBits, r.ideal, r.correctedBits)) =
    .ok ([0x3f800000, 0x40000000, 0x40400000], some 3, some 0x40400000) := by
  decide +kernel

def nestedProgram : Program v100F16F32 := tc%{
  repeat (2) {
    repeat (2) {
      block "inner add" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
    }
    block "outer subtract" [(0xbc00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  }
}

theorem nested_program_order :
    nestedProgram.blocks.map (fun c => c.site.label) =
      ["inner add", "inner add", "outer subtract", "inner add", "inner add", "outer subtract"] ∧
    (nestedProgram.report 0).map (fun r => (r.outputBits, r.ideal, r.correctedBits)) =
      .ok ([0x3f800000, 0x40000000, 0x3f800000, 0x40000000, 0x40400000, 0x40000000],
        some 2, some 0x40000000) := by decide +kernel

def rejectedProgram : Program v100F16F32 := tc%{
  block "finite call" [(0, 0), (0, 0), (0, 0), (0, 0)];
  repeat (2) {
    block "nonfinite operand" [(0x7c00, 0), (0, 0), (0, 0), (0, 0)];
  }
}

theorem rejected_program_vc : ¬rejectedProgram.VC 0 := by decide +kernel

theorem rejected_program_location :
    (match rejectedProgram.report 0 with
      | .error (.call e) => some (e.site.label, e.invocation, e.reason)
      | _ => none) = some ("nonfinite operand", 1, .nonfiniteInput) := by decide +kernel

def rangeProgram : Program v100F16F32 := tc%{
  block "add 1 at maximum" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
}

/-- The model call succeeds, but its ideal sum is outside the correction domain. -/
theorem final_range_rejected :
    (rangeProgram.run 0x7f7fffff).isOk = true ∧
    ¬rangeProgram.VC 0x7f7fffff ∧
    rangeProgram.report 0x7f7fffff = .error (.finalSumOutOfRange (maxFinite32 + 1)) := by
  decide +kernel

def unexecutedProgram : Program v100F16F32 := tc%{
  repeat (0) {
    block "unexecuted NaN" [(0x7e00, 0), (0, 0), (0, 0), (0, 0)];
  }
}

tc_verify zero_iterations_correct : unexecutedProgram from 0

theorem nonfinite_initial_rejected :
    ¬unexecutedProgram.VC 0x7f800000 ∧
    unexecutedProgram.report 0x7f800000 = .error .initialNonfinite := by decide +kernel

def cycleBody : Program v100F16F32 := tc%{
  block "add 1" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  block "subtract 1" [(0xbc00, 0x3c00), (0, 0), (0, 0), (0, 0)];
}

def zeroFinite : Finite32 := ⟨0, ⟨0, 0, 0⟩, rfl⟩
def oneFinite : Finite32 := ⟨0x3f800000, ⟨8388608, 0, 23⟩, rfl⟩

def cycleTraces : List BlockTrace :=
  [⟨⟨v100F16F32,
      (⟨1024, 0, 10⟩, ⟨1024, 0, 10⟩) :: List.replicate 3 (⟨0, 0, 0⟩, ⟨0, 0, 0⟩),
      zeroFinite.decoded⟩, oneFinite⟩,
   ⟨⟨v100F16F32,
      (⟨-1024, 0, 10⟩, ⟨1024, 0, 10⟩) :: List.replicate 3 (⟨0, 0, 0⟩, ⟨0, 0, 0⟩),
      oneFinite.decoded⟩, zeroFinite⟩]

theorem cycle_execution : cycleBody.run zeroFinite.bits = .ok cycleTraces := by decide +kernel

/-- This VC is proved for a symbolic iteration count by the encoded-state invariant. -/
theorem symbolic_cycle_vc (n : Nat) : (Program.repeat n cycleBody).VC 0 := by
  apply Program.repeat_vc_of_cycle cycleBody zeroFinite cycleTraces
  · rfl
  · exact cycle_execution
  · rfl
  · decide +kernel
  · decide +kernel

section
variable (n : Nat)
tc_verify symbolic_cycle_correct : (Program.repeat n cycleBody) from 0 using (symbolic_cycle_vc n)
end

def symbolicSyntax (n : Nat) : Program v100F16F32 := tc%{
  repeat (n) {
    call "typed call" (BlockOperands.ofNats [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)]
      (by decide) (by decide));
  }
}

theorem symbolic_syntax_inputs (n : Nat) : (symbolicSyntax n).inputs =
    List.replicate n [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)] := by
  induction n with
  | zero => rfl
  | succ n ih =>
    change ([(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)] :: (symbolicSyntax n).inputs) = _
    rw [ih]; rfl

end TensorCore.Regression
