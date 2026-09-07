import TensorCore.PaperSpec.Definition

/-! Ordered group composition. The order is supplied explicitly, and every group
consumes its predecessor's encoded FP32 result. The empty low-level schedule is
a no-op even for a nonfinite initial word, matching the explicit boundary of this
API; each nonempty group checks its inputs through Result. No grouping, matrix
indexing, instruction mapping, or physical conformance is inferred here. -/

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
