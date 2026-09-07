import TensorCore.Theory.EFMachine.Correctness
import TensorCore.Theory.EFMachine.Grid

namespace TensorCore.EFMachine

/-! Source-level operation budgets, not processor cycles. An operation on Magnitude
has width 576 (nine 64-bit limbs in a limb implementation). The leading/trailing
support searches make at most ten probes each; bitScan_probe_budget checks the
probe count and proves every prefix word has width at most 576. The current Lean
backend represents BitVec using its standard runtime,
so these budgets do not assert a particular limb layout, allocation cost, or GPU speed.

For N=K+1, extract performs N splits, 2N sumWords additions, and 3 signed
additions/subtractions. A scalar attempt performs at most N+2 encoded additions:
N residual additions (initial +0 included), D-overlap, and the final addition.
There are at most N+4 exact32 checks (2 in the guard, N residuals, D, -overlap),
each doing one conversion, plus N+2 conversions in add32, plus one if the attempt
fails and the exact branch executes. Guard coefficient accumulation adds N unsigned
words. Preprocessing decodes 2K input factors and two FP32 words, multiplies K pairs,
and scans N raw exponents. No scalar operation budget excludes the failed-attempt
work. Each exact32 check and each add32 also has one and two FP32 decodes respectively.
-/

structure OperationBudget where
  inputDecodes : Nat
  products : Nat
  rawScan : Nat
  splits : Nat
  extractionAdds : Nat
  scalarAdds : Nat
  exactChecks : Nat
  conversions : Nat
  guardCoefficientAdds : Nat
  residualBitScans : Nat
  scalarDecodes : Nat
  deriving Repr, DecidableEq

def operationBudget (K : Nat) : OperationBudget :=
  let N := K + 1
  ⟨2 * K + 2, K, N, N, 2 * N + 3, N + 2, N + 4,
    2 * N + 7, N, N, (N + 4) + 2 * (N + 2) + 2⟩

/-- Concrete maxima for every supported normalization group, including failed scalar attempts. -/
theorem operationBudget_bounds (path : Path) :
    let b := operationBudget path.profile.products
    b.inputDecodes ≤ 34 ∧ b.products ≤ 16 ∧ b.rawScan ≤ 17 ∧ b.splits ≤ 17 ∧
    b.extractionAdds ≤ 37 ∧ b.scalarAdds ≤ 19 ∧ b.exactChecks ≤ 21 ∧
    b.conversions ≤ 41 ∧ b.guardCoefficientAdds ≤ 17 ∧ b.residualBitScans ≤ 17 ∧
    b.scalarDecodes ≤ 61 := by cases path <;> decide

/-- Each direct conversion needs at most one leading scan; each nonzero residual
needs at most one trailing scan. This includes the failed scalar attempt and exact
fallback. A probe is a bounded shift/prefix operation and comparison, not a CPU cycle. -/
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

/-- Under the execution preconditions each sumWords call executes exactly one
checked addition per list element. It starts at zero; no floating additions are hidden. -/
def sumWordsAdds : List Word → Nat
  | [] => 0
  | _ :: xs => sumWordsAdds xs + 1

theorem sumWordsAdds_eq (xs : List Word) : sumWordsAdds xs = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [sumWordsAdds, ih]

end TensorCore.EFMachine
