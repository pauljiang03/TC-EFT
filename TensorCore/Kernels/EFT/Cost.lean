import TensorCore.Kernels.EFT.Correctness
import TensorCore.Kernels.EFT.Grid

/-! Operation budgets of the 576-bit TC-EFT. -/

namespace TensorCore.EFMachine

/-! Source-level operation budgets, not processor cycles. -/

structure OperationBudget where
  inputDecodes : ℕ
  products : ℕ
  exponentScan : ℕ
  splits : ℕ
  extractionAdds : ℕ
  scalarAdds : ℕ
  conversions : ℕ
  guardCoefficientAdds : ℕ
  residualBitScans : ℕ
  scalarDecodes : ℕ
  deriving Repr, DecidableEq

def operationBudget (K : ℕ) : OperationBudget :=
  let N := K + 1
  ⟨2 * K + 2, K, N, N, 2 * N + 3, N + 2,
    2 * N + 7, N, N, 2 * (N + 2)⟩

/-- Concrete maxima for every supported normalization group, including failed scalar attempts. -/
theorem operationBudget_bounds (path : Path) :
    let b := operationBudget path.profile.products
    b.inputDecodes ≤ 34 ∧ b.products ≤ 16 ∧ b.exponentScan ≤ 17 ∧ b.splits ≤ 17 ∧
    b.extractionAdds ≤ 37 ∧ b.scalarAdds ≤ 19 ∧
    b.conversions ≤ 41 ∧ b.guardCoefficientAdds ≤ 17 ∧ b.residualBitScans ≤ 17 ∧
    b.scalarDecodes ≤ 38 := by cases path <;> decide

/-- Each direct conversion needs at most one leading scan; each nonzero residual needs at most one trailing scan. -/
theorem bitScan_total_budget (path : Path) :
    10 * ((operationBudget path.profile.products).conversions +
      (operationBudget path.profile.products).residualBitScans) ≤ 580 := by
  cases path <;> decide

/-- The actual decoded and extracted list lengths discharge the loop budgets. -/
theorem extraction_loop_bounds {path : Path} {x : BlockInput path.profile} {D : F32}
    {p : Prepared} {c : Components} (hp : prepare path x D = .ok p) (hc : extract p = some c) :
    p.terms.length ≤ 17 ∧ c.coarse.length = path.profile.products + 1 ∧
      c.low.length = path.profile.products + 1 := by
  have hlen := (prepare_spec hp).2.2.2.1
  have hs := extract_spec hc
  rw [hs.2.1, hs.2.2.1]
  simp only [List.length_map, hlen]
  exact ⟨by have h := path_count path; omega, trivial, trivial⟩

/-- Under the execution preconditions each sumWords call executes exactly one checked addition per list element. -/
def sumWordsAdds : List Word → ℕ
  | [] => 0
  | _ :: xs => sumWordsAdds xs + 1

theorem sumWordsAdds_eq (xs : List Word) : sumWordsAdds xs = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [sumWordsAdds, ih]

end TensorCore.EFMachine
