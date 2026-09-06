import Lean
import TensorCore.Programs.Instruction

/-! `tc_instruction "name"` resolves a pinned instruction path and prints its parameters,
grouping, and evidence. Unknown names are refused: a path without a numerical source is not
given semantics by naming it. -/

open Lean Elab Command

namespace TensorCore.Meta

/-- Pinned instruction paths by short name. -/
def instructionPaths : List (String × Name) :=
  [("v100-wmma-k16", ``TensorCore.v100Wmma16),
   ("ampere-wmma-k16", ``TensorCore.ampereWmma16),
   ("hopper-wmma-k16", ``TensorCore.hopperWmma16)]

syntax "tc_instruction" str : command

elab_rules : command
  | `(tc_instruction $s:str) => do
    match instructionPaths.lookup s.getString with
    | some n =>
      elabCommand (← `(#eval TensorCore.InstructionPath.describe $(mkIdent n)))
    | none =>
      throwErrorAt s "unsourced instruction path '{s.getString}'; pinned paths: {instructionPaths.map (·.1)}"

end TensorCore.Meta
