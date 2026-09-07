import TensorCore.Programs.ConvertedGemmAnalysis

namespace TensorCore.Regression

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

def sourceAnalysisA : DenseMatrix (BitVec fp32.width) 1 1 := #v[#v[0xbf801000]]
def sourceAnalysisB : DenseMatrix (BitVec fp32.width) 1 1 := #v[#v[0x3f801000]]
def sourceAnalysisC : DenseMatrix F32 1 1 := #v[#v[0]]
def analysisEpilogue (mode : BinaryRoundingMode) : GemmEpilogue := ⟨mode, mode, ⟨fp32, mode⟩⟩

def sourceWitness (model : WmmaGemmModel) (mode : BinaryRoundingMode) : DenseMatrix ScaledWitness 1 1 :=
  let cells := (analyzeConvertedGemm fp32 mode model (analysisEpilogue mode) 0x3f800000 0
    sourceAnalysisA sourceAnalysisB sourceAnalysisC).getD #v[#v[none]]
  cells.map fun row => row.map fun a => (a.map (·.witness)).getD ⟨[], ⟨0, 0, 0, 0⟩⟩

theorem scaled_analysis_source_accuracy (model : WmmaGemmModel) (mode : BinaryRoundingMode) :
    ConvertedGemmAccurate fp32 mode model (analysisEpilogue mode) 0x3f800000 0
      sourceAnalysisA sourceAnalysisB sourceAnalysisC (1 / 100) := by
  apply convertedAnalysisCheck_sound fp32 mode model (analysisEpilogue mode) 0x3f800000 0
    sourceAnalysisA sourceAnalysisB sourceAnalysisC (sourceWitness model mode)
  cases model <;> cases mode <;> decide +kernel

theorem scaled_analysis_tolerance_and_witness_controls :
    convertedAnalysisCheck fp32 .nearestEven .v100 (analysisEpilogue .nearestEven) 0x3f800000 0
      sourceAnalysisA sourceAnalysisB sourceAnalysisC (sourceWitness .v100 .nearestEven) 0 = false ∧
    convertedAnalysisCheck fp32 .nearestEven .v100 (analysisEpilogue .nearestEven) 0x3f800000 0
      sourceAnalysisA sourceAnalysisB sourceAnalysisC #v[#v[⟨[], ⟨1, -126, 1, 1⟩⟩]] 1 = false := by
  decide +kernel

theorem scaled_analysis_zero (mode : BinaryRoundingMode) :
    (analyzeScaledCell .hopper (analysisEpilogue mode) 0x3f800000 0x80000000 0x80000000
      [(0x8000, 0)]).map (fun a => a.bound.error) = some 0 := by
  cases mode <;> decide +kernel

theorem scaled_analysis_subnormal (mode : BinaryRoundingMode) :
    (analyzeScaledCell .ampere (analysisEpilogue mode) 0x3f800000 0 0 [(0x8001, 1)]).isSome = true := by
  cases mode <;> decide +kernel

theorem scaled_analysis_fp32_output_exact (mode : BinaryRoundingMode) :
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x3f800000 0x3f800000 0xff7fffff []).map
      (fun a => a.bound.outputRounding) = some 0 := by
  cases mode <;> decide +kernel

theorem scaled_analysis_finite_rejection (mode : BinaryRoundingMode) :
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x40000000 0 0 [(0x7bff, 0x7bff)]).isSome = true ∧
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x7f7fffff 0 0 [(0x4000, 0x3c00)]).isSome = false ∧
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x7f800000 0 0 []).isSome = false ∧
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0 0 0x7fc00000 []).isSome = false := by
  cases mode <;> decide +kernel

theorem scaled_analysis_empty_output_still_converts :
    (analyzeConvertedGemm fp32 .towardZero .v100 (analysisEpilogue .nearestEven) 0 0
      (#v[#v[0x7fc00000]] : DenseMatrix (BitVec fp32.width) 1 1)
      (#v[#v[]] : DenseMatrix (BitVec fp32.width) 1 0)
      (#v[#v[]] : DenseMatrix F32 1 0)).isSome = false := by decide +kernel

theorem scalar_analysis_range_boundary :
    (checkScalar ⟨fp32, .towardZero⟩ fp32.maxFinite 128).isSome = true ∧
    (checkScalar ⟨fp32, .towardZero⟩ (fp32.maxFinite + 1) 128).isSome = false ∧
    (checkScalar ⟨fp32, .nearestEven⟩ 1 (-126)).isSome = false := by decide +kernel

end TensorCore.Regression
