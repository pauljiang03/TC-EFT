-- Decision Extensions for GEMM.

import TensorCore.Gemm.CostSelection
import TensorCore.Gemm.Specification.NativeGemmEquivalence

namespace TensorCore.Regression

set_option maxRecDepth 32768
set_option maxHeartbeats 16000000

theorem exact_scalar_budgets (mode : BinaryRoundingMode) :
    checkFiniteMultiply mode 1 fp32.maxFinite (-999) = some ⟨fp32.maxFinite, 0⟩ ∧
    checkFiniteMultiply mode (-1) (pow2 (-149)) (-999) = some ⟨pow2 (-149), 0⟩ ∧
    checkFiniteAdd mode 0 fp32.maxFinite (-999) = some ⟨fp32.maxFinite, 0⟩ := by
  cases mode <;> decide +kernel

theorem identity_epilogue_tight (mode : BinaryRoundingMode) :
    (analyzeScaledCell .ampere ⟨mode, mode, ⟨fp32, mode⟩⟩ 0x3f800000 0 0 [(0xbc00, 0x3c00)]).map
      (fun a => a.bound.alphaRounding + a.bound.betaRounding + a.bound.addRounding + a.bound.outputRounding) = some 0 := by
  cases mode <;> decide +kernel

theorem native_empty_domain (model : NativeGemmModel p) :
    (nativeGemmCell model [] 0x80000000).map (fun c => c.output.bits) = some 0x80000000 ∧
    (nativeGemmCell model [] 0x7f7fffff).map (fun c => c.output.bits) = some 0x7f7fffff ∧
    nativeGemmCell model [] 0x7f800000 = none := by
  cases p <;> cases model <;> decide +kernel

theorem native_bf16_cases (model : NativeGemmModel .bf16) :
    (nativeGemmCell model [(0xbf80, 0x4000)] 0).map (fun c => c.output.bits) = some 0xc0000000 ∧
    (nativeGemmCell model [(0x8001, 0x3f80)] 0).map (fun c => c.output.bits) = some 0x80010000 ∧
    (nativeGemmCell model (List.replicate 17 (0x3f80, 0x3f80)) 0).map (fun c => c.output.bits) = some 0x41880000 ∧
    nativeGemmCell model [(0x7f7f, 0x7f7f)] 0 = none ∧
    nativeGemmCell model [(0x7fc0, 0)] 0 = none := by
  cases model <;> decide +kernel

theorem native_tf32_cases (model : NativeGemmModel .tf32) :
    (nativeGemmCell model [(0x5fc00, 0x20000)] 0).map (fun c => c.output.bits) = some 0xc0000000 ∧
    (nativeGemmCell model [(0x40001, 0x1fc00)] 0).map (fun c => c.output.bits) = some 0x80002000 ∧
    (nativeGemmCell model (List.replicate 9 (0x1fc00, 0x1fc00)) 0).map (fun c => c.output.bits) = some 0x41100000 ∧
    nativeGemmCell model [(0x3fc00, 0)] 0 = none := by
  cases model <;> decide +kernel

def costProblem : GemmProblem 1 1 17 :=
  .raw #v[Vector.replicate 17 0x0c00] (Vector.replicate 17 #v[0x0c00]) #v[#v[0x3f800000]]

def pricedModels : List CostedCandidate :=
  [⟨{model := .v100}, 0, 0⟩, ⟨{model := .ampere}, 3, 1⟩, ⟨{model := .hopper}, 2, 2⟩]

theorem minimum_cost_skips_uncertified :
    (selectGemmCost costProblem pricedModels (1 / 1000000)).map (·.index) = some 2 ∧
    selectGemmCost costProblem pricedModels 0 = none := by decide +kernel

theorem minimum_cost_ties :
    (selectGemmCost costProblem [⟨{model := .hopper}, 2, 7⟩, ⟨{model := .ampere}, 2, 9⟩]
      (1 / 1000000)).map (·.index) = some 7 := by decide +kernel

def variedFamily : EntryFamily 2 2 1 :=
  ⟨#v[#v[1], #v[1 / 4096]], #v[#v[1, 1 / 4096]], #v[#v[1, 0], #v[0, 0]]⟩

theorem varied_family_certifies :
    candidateCertified (.entryFamily variedFamily) (1 / 1000) {model := .hopper} = true := by decide +kernel

theorem varied_family_universal : EntryFamilyAccurate .hopper variedFamily (1 / 1000) :=
  candidateCertified_sound (.entryFamily variedFamily) (1 / 1000) {model := .hopper} varied_family_certifies

theorem native_selection_certifies :
    candidateCertified (.native .bf16 #v[#v[0xbf80]] #v[#v[0x4000]] #v[#v[0]])
      (1 / 1000) {model := .ampere} = true ∧
    candidateCertified (.native .tf32 #v[#v[0x5fc00]] #v[#v[0x20000]] #v[#v[0]])
      (1 / 1000) {model := .hopper, nativeMma := true} = true := by decide +kernel

end TensorCore.Regression
