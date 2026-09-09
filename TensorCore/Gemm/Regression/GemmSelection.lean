-- Gemm Selection for GEMM.

import TensorCore.Gemm.Selection

namespace TensorCore.Regression

set_option maxRecDepth 32768
set_option maxHeartbeats 64000000

def selectionModels : List GemmCandidate := [{model := .v100}, {model := .ampere}, {model := .hopper}]

def selectionTiny : GemmProblem 1 1 17 :=
  .raw #v[Vector.replicate 17 0x0c00] (Vector.replicate 17 #v[0x0c00]) #v[#v[0x3f800000]]

theorem selection_tolerance_changes_choice :
    selectGemm selectionTiny selectionModels (1 / 100000) = some 0 ∧
    selectGemm selectionTiny selectionModels (1 / 1000000) = some 1 ∧
    selectGemm selectionTiny selectionModels (1 / 2000000) = some 2 ∧
    selectGemm selectionTiny selectionModels 0 = none := by decide +kernel

theorem selection_preference_and_duplicates :
    selectGemm selectionTiny selectionModels.reverse (1 / 100000) = some 0 ∧
    selectGemm selectionTiny [{model := .ampere}, {model := .ampere}] (1 / 1000000) = some 0 ∧
    selectGemm selectionTiny [] 1 = none := by decide +kernel

def selectionSource : GemmProblem 1 1 1 :=
  .scaled fp32 0x3f800000 0 #v[#v[0x3f800001]] #v[#v[0x3f800000]] #v[#v[0]]

def selectionModes : List GemmCandidate :=
  [{model := .hopper, inputMode := .towardPositive}, {model := .hopper}]

theorem selection_source_rounding :
    selectGemm selectionSource selectionModes (1 / 1000000) = some 1 := by decide +kernel

theorem selection_source_accuracy :
    selectionSource.Accurate {model := .hopper} (1 / 1000000) :=
  selectGemm_accuracy selectionSource selectionModes (1 / 1000000) 1 {model := .hopper}
    selection_source_rounding (by decide +kernel)

theorem selection_family :
    selectGemm (.family ⟨1 / 4096, 1 / 4096, 1 / 16⟩ : GemmProblem 2 3 16)
      selectionModels (3 / 5000000) = some 1 := by decide +kernel

theorem selection_signed_zero_subnormal_and_boundary :
    selectGemm (.raw #v[#v[0]] #v[#v[0x8000]] #v[#v[0x80000000]]) selectionModels 0 = some 0 ∧
    selectGemm (.raw #v[#v[0x8001]] #v[#v[1]] #v[#v[0]]) selectionModels (1 / 1000000) = some 0 ∧
    selectGemm (.raw #v[#v[]] #v[] #v[#v[0x7f7fffff]]) selectionModels 0 = some 0 ∧
    selectGemm (.raw #v[#v[0x3c00]] #v[#v[0x3c00]] #v[#v[0x7f7fffff]]) selectionModels 1 = none :=
  by decide +kernel

theorem selection_rejection_policy :
    selectGemm (.raw #v[#v[0x7c00]] #v[#v[0]] #v[#v[0]]) selectionModels 1 = none ∧
    selectGemm (.scaled fp32 0 0 #v[#v[0x7fc00000]] #v[#v[0]] #v[#v[0]]) selectionModels 1 = none ∧
    selectGemm (.scaled fp32 0 0 #v[#v[0x47800000]] #v[#v[0]] #v[#v[0]]) selectionModels 1 = none ∧
    selectGemm selectionTiny selectionModels (-1) = none := by decide +kernel

end TensorCore.Regression
