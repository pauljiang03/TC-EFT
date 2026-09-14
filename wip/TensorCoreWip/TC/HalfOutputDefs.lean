import TensorCore.TC.Profiles

namespace TensorCore

/-- Competing interpretations retained for reconciliation; these are not yet device profiles. -/
def v100HalfDirectCandidate : InvocationSpec :=
  { v100Invocation with cFormat := fp16, output := ⟨fp16, .nearestEven⟩ }
def v100HalfStagedCandidate : InvocationSpec :=
  { v100HalfDirectCandidate with intermediate := [⟨fp32, .towardZero⟩] }

end TensorCore
