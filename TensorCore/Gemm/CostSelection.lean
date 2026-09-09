-- Cost Selection for GEMM.

import TensorCore.Gemm.Selection
import Init.Data.List.MinMaxOn

namespace TensorCore

def selectMinimumCost (check : α → Bool) (cost : α → ℚ) (candidates : List α) : Option α :=
  (candidates.filter check).minOn? cost

theorem selectMinimumCost_sound (check : α → Bool) (cost : α → ℚ) (candidates : List α)
    (chosen : α) (h : selectMinimumCost check cost candidates = some chosen) :
    chosen ∈ candidates ∧ check chosen = true ∧
      ∀ c ∈ candidates, check c = true → cost chosen ≤ cost c := by
  have hm := List.minOn?_mem h
  have hc := List.mem_filter.mp hm
  refine ⟨hc.1, hc.2, ?_⟩
  intro c hmem hcheck
  have hh := List.apply_get_minOn?_le_of_mem (f := cost) (List.mem_filter.mpr ⟨hmem, hcheck⟩)
  change (candidates.filter check).minOn? cost = some chosen at h
  simpa [h] using hh

structure CostedCandidate where
  configuration : GemmCandidate
  cost : ℚ
  index : ℕ
  deriving Repr, DecidableEq

def selectGemmCost (p : GemmProblem m n k) (candidates : List CostedCandidate) (tol : ℚ) :
    Option CostedCandidate :=
  selectMinimumCost (fun c => candidateCertified p tol c.configuration) (·.cost) candidates

theorem selectGemmCost_sound (p : GemmProblem m n k) (candidates : List CostedCandidate)
    (tol : ℚ) (chosen : CostedCandidate) (h : selectGemmCost p candidates tol = some chosen) :
    chosen ∈ candidates ∧ p.Accurate chosen.configuration tol ∧
      ∀ c ∈ candidates, candidateCertified p tol c.configuration = true → chosen.cost ≤ c.cost := by
  obtain ⟨hm, hc, hmin⟩ := selectMinimumCost_sound _ _ candidates chosen h
  exact ⟨hm, candidateCertified_sound p tol chosen.configuration hc, hmin⟩

end TensorCore
