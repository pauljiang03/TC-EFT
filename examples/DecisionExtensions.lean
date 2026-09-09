-- Decision Extensions for the executable examples.

import TensorCore.Gemm.CostSelection
import TensorCore.Gemm.Specification.NativeGemmEquivalence

namespace TensorCore.Examples.DecisionExtensions

set_option maxRecDepth 32768

def nativeProblem : GemmProblem 1 1 1 :=
  .native .tf32 #v[#v[0x1fc00]] #v[#v[0x1fc00]] #v[#v[0]]

def candidates : List CostedCandidate :=
  [⟨{model := .ampere}, 3, 0⟩, ⟨{model := .hopper}, 2, 1⟩,
   ⟨{model := .hopper, nativeMma := true}, 1, 2⟩]

def chosen : CostedCandidate := ⟨{model := .hopper, nativeMma := true}, 1, 2⟩

theorem decision : selectGemmCost nativeProblem candidates (1 / 1000) = some chosen := by
  decide +kernel

theorem accuracy_and_minimum : chosen ∈ candidates ∧
    nativeProblem.Accurate chosen.configuration (1 / 1000) ∧
    ∀ c ∈ candidates, candidateCertified nativeProblem (1 / 1000) c.configuration = true → chosen.cost ≤ c.cost :=
  selectGemmCost_sound nativeProblem candidates (1 / 1000) chosen decision

def family : EntryFamily 2 2 1 :=
  ⟨#v[#v[1], #v[1 / 4096]], #v[#v[1, 1 / 4096]], #v[#v[1, 0], #v[0, 0]]⟩

theorem all_family_members : EntryFamilyAccurate .hopper family (1 / 1000) :=
  candidateCertified_sound (.entryFamily family) (1 / 1000) {model := .hopper} (by decide +kernel)

end TensorCore.Examples.DecisionExtensions
