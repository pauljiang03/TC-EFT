import TensorCore.Programs.CostSelection

namespace TensorCore.Examples.NativeScaled

set_option maxRecDepth 32768

def problem : GemmProblem 1 1 1 :=
  .nativeScaled .bf16 fp32 .nearestEven 0x3f800000 0
    #v[#v[0x3f800001]] #v[#v[0x3f800000]] #v[#v[0]]

def candidates : List GemmCandidate :=
  [{model := .ampere, inputMode := .towardPositive}, {model := .hopper}]

theorem decision : selectGemm problem candidates (1 / 1000000) = some 1 := by
  decide +kernel

theorem original_input_accuracy : problem.Accurate {model := .hopper} (1 / 1000000) :=
  selectGemm_accuracy problem candidates (1 / 1000000) 1 {model := .hopper} decision (by decide +kernel)

#check TensorCore.PaperSpec.nativeConvertedGemm_eq_independent
#check TensorCore.nativeConvertedAnalysisCheck_paper
#check TensorCore.analyzeNativeConvertedGemm_matrix_error

end TensorCore.Examples.NativeScaled
