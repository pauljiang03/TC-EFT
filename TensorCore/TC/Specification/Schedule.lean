import TensorCore.TC.Specification.Defs

/-! Ordered group composition. -/

namespace TensorCore.PaperSpec

noncomputable def runGroups (p : Parameters) : BitVec 32 →
    List (List (BitVec p.input.width × BitVec p.input.width)) → Option (List (BitVec 32))
  | _, [] => some []
  | c, group :: rest => do
    let d ← bits p ⟨group, c⟩
    let tail ← runGroups p d rest
    return d :: tail

noncomputable def lastBits (p : Parameters) (c : BitVec 32)
    (groups : List (List (BitVec p.input.width × BitVec p.input.width))) : Option (BitVec 32) :=
  (runGroups p c groups).map fun ds => ds.getLast?.getD c

end TensorCore.PaperSpec
