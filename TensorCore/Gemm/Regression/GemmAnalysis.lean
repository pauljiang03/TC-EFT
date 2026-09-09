-- Gemm Analysis for GEMM.

import TensorCore.Gemm.Analysis
import TensorCore.Gemm.Regression.GemmExtensions

namespace TensorCore.Regression

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

def tinyAnalysis (model : WmmaGemmModel) : Option CellAnalysis :=
  analyzeGemmCell model (List.replicate 17 (0x0c00, 0x0c00)) 0x3f800000

theorem analysis_tiny_bounds :
    (tinyAnalysis .v100).map (fun a => a.bound.error) = some (33 / 8388608) ∧
    (tinyAnalysis .ampere).map (fun a => a.bound.error) = some (3 / 4194304) ∧
    (tinyAnalysis .hopper).map (fun a => a.bound.error) = some (5 / 16777216) := by decide +kernel

theorem analysis_improves_existing_certificate (model : WmmaGemmModel) :
    ((tinyAnalysis model).map fun a => decide
      (a.bound.error < gemmStaticError model smallGemmBounds 17)).getD false = true := by
  cases model <;> decide +kernel

def minimalTinyBounds (model : WmmaGemmModel) : GemmBoundConfig :=
  ⟨0, -24, (match model with | .v100 => 3 | .ampere => 4 | .hopper => 5), 1⟩

theorem analysis_improves_minimal_static (model : WmmaGemmModel) :
    gemmCheck model (minimalTinyBounds model) gemmTinyA gemmTinyB gemmOne = true ∧
    ((tinyAnalysis model).map fun a => decide
      (a.bound.error < gemmStaticError model (minimalTinyBounds model) 17)).getD false = true := by
  cases model <;> decide +kernel

def tinyWitness (model : WmmaGemmModel) : DenseMatrix (List GroupWitness) 1 1 :=
  #v[#v[((tinyAnalysis model).map (·.witness)).getD []]]

theorem analysis_tolerance_certified (model : WmmaGemmModel) :
    GemmAccurate model gemmTinyA gemmTinyB gemmOne (1 / 100000) := by
  apply gemmAnalysisCheck_sound model gemmTinyA gemmTinyB gemmOne (tinyWitness model)
  cases model <;> decide +kernel

theorem analysis_tolerance_inconclusive :
    gemmAnalysisCheck .v100 gemmTinyA gemmTinyB gemmOne (tinyWitness .v100) 0 = false := by decide +kernel

theorem analysis_signed_zero_and_empty :
    (analyzeGemmCell .v100 [] 0x80000000).map (fun a => a.bound.error) = some 0 ∧
    (analyzeGemmCell .hopper [(0, 0x8000)] 0x80000000).map (fun a => a.bound.error) = some 0 ∧
    (analyzeGemmCell .ampere [] 0x7f7fffff).map (fun a => a.bound.error) = some 0 := by decide +kernel

theorem analysis_finite_boundary :
    (analyzeGemmCell .v100 [(0, 0)] 0x7f7fffff).isSome = true ∧
    (analyzeGemmCell .hopper [(0, 0)] 0xff7fffff).isSome = true ∧
    (analyzeGemmCell .ampere [(0x3c00, 0x3c00)] 0x7f7fffff).isSome = false := by decide +kernel

theorem analysis_nonfinite_rejected :
    (analyzeGemmCell .v100 [(0x7c00, 0)] 0).isSome = false ∧
    (analyzeGemmCell .hopper [] 0x7fc00000).isSome = false := by decide +kernel

theorem analysis_negative_subnormal :
    (analyzeGemmCell .v100 [(0x8001, 1)] 0).isSome = true ∧
    (analyzeGemmCell .ampere [(0x8001, 1)] 0).isSome = true ∧
    (analyzeGemmCell .hopper [(0x8001, 1)] 0).isSome = true := by decide +kernel

theorem analysis_exact_product_alignment :
    rawAlignmentBudget (rawMul ⟨-1024, 0, 10⟩ ⟨1024, 1, 10⟩) (-22) = 0 ∧
    rawAlignmentBudget (rawMul ⟨1024, -12, 10⟩ ⟨1024, -12, 10⟩) (-24) = 0 ∧
    rawAlignmentBudget (rawMul ⟨1024, -12, 10⟩ ⟨1024, -12, 10⟩) (-23) = pow2 (-23) := by decide +kernel

theorem analysis_witness_rejects_mutations :
    checkGemmCell .v100 [(0x3c00, 0x4000)] 0 [] = none ∧
    checkGemmCell .v100 [(0x3c00, 0x4000)] 0 (List.replicate 4 ⟨-126, 0⟩) = none ∧
    checkGemmCell .v100 [(0x3c00, 0x4000)] 0 (List.replicate 4 ⟨1, -126⟩) = none ∧
    checkGemmCell .hopper [(0x3c00, 0x4000)] 0 (List.replicate 2 ⟨1, 1⟩) = none := by decide +kernel

end TensorCore.Regression
