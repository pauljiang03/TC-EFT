-- FP8 Program for the tensor-core model.

import TensorCoreWip.TC.FP8Defs

namespace TensorCore

/-- Independently decode original operands, preserving their FP8 raw scales. -/
def prepareFP8Products (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word)) :
    Option (List (Decoded × Decoded)) :=
  ps.mapM fun (a, b) => do return (← f.encoding.decode a, ← f.encoding.decode b)

/-- Original-input ideal; no alignment or evaluator dependency. -/
def fp8Products (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word)) : Option ℚ :=
  (prepareFP8Products f ps).map
    (fun (ds : List (Decoded × Decoded)) =>
      sumQ (ds.map fun (pair : Decoded × Decoded) => pair.1.value * pair.2.value))

def l40sFP8Ideal (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word))
    (c : F32) : Option ℚ := do
  return (← decode32 c).value + (← fp8Products f ps)

structure L40SFP8Trace (f : FP8Format) (reading : FP8Reading) where
  first : InvocationTrace (l40sFP8Invocation f reading)
  second : InvocationTrace (l40sFP8Invocation f reading)
  deriving Repr, DecidableEq

/-- One published 32-product row, in increasing k: two groups of 16, with the first
encoded FP32 result supplied as the second c. Wrong lengths are rejected, not padded. -/
def runL40SFP8 (f : FP8Format) (reading : FP8Reading)
    (ps : List (f.encoding.Word × f.encoding.Word)) (c : F32) :
    Except InvocationError (L40SFP8Trace f reading) :=
  if ps.length != 32 then .error .wrongProductCount
  else match evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.take 16, c⟩ with
  | .error e => .error e
  | .ok first => match evalInvocation (p := l40sFP8Invocation f reading)
      ⟨ps.drop 16, first.output.bits⟩ with
    | .error e => .error e
    | .ok second => .ok ⟨first, second⟩

def l40sFP8Bits (f : FP8Format) (reading : FP8Reading)
    (ps : List (f.encoding.Word × f.encoding.Word)) (c : F32) : Option F32 :=
  (runL40SFP8 f reading ps c).toOption.map fun t => t.second.output.bits

end TensorCore
