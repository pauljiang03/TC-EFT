import TensorCore.TC.Conversion
import TensorCoreWip.TC.HalfOutputDefs

namespace TensorCore

/-- FP16-output candidates: the final FP16 word is the nearest-even FP16 value of the value
entering the output stage, whichever candidate stage order is chosen. -/
theorem halfDirect_output_nearestEven {x : InvocationInput v100HalfDirectCandidate}
    {t : InvocationTrace v100HalfDirectCandidate} (h : evalInvocation x = .ok t) :
    NearestEven fp16 t.intermediate.value t.output.bits :=
  evalInvocation_output_nearestEven h rfl

theorem halfStaged_output_nearestEven {x : InvocationInput v100HalfStagedCandidate}
    {t : InvocationTrace v100HalfStagedCandidate} (h : evalInvocation x = .ok t) :
    NearestEven fp16 t.intermediate.value t.output.bits :=
  evalInvocation_output_nearestEven h rfl

end TensorCore
