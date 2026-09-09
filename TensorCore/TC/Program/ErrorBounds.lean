-- Error Bounds for the tensor-core model.

import TensorCore.TC.Program.Defs
import TensorCore.TC.ErrorBounds

namespace TensorCore

/-- The local two-stage bound at the grids of an actual returned invocation. -/
def BlockTrace.errorBudget (t : BlockTrace) : ℚ :=
  (t.block.terms.length : ℚ) * pow2 t.block.quantumExponent +
    pow2 (outputQuantumExponent t.output.bits)

theorem evalBlock_residual_bound {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : absQ t.residual < t.errorBudget := by
  have hid := returned_residual_identity t
  have he : t.residual = t.block.exactDot - t.output.value := by grind
  rw [he]
  exact evalBlock_error_bound h

theorem runBlocks_length (p : Profile) (c : F32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p c ps = .ok ts) : ts.length = ps.length := by
  induction ps generalizing c ts with
  | nil => simp [runBlocks] at h; subst ts; rfl
  | cons q ps ih =>
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => simp [runBlocks, he] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits ps with
      | error e => simp [runBlocks, he, hr] at h
      | ok rest =>
        simp [runBlocks, he, hr] at h
        subst ts
        simpa using ih t.output.bits rest hr

/-- Losses may cancel, but the sum of the local budgets always bounds their ledger. -/
theorem runBlocks_residual_budget (p : Profile) (c : F32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (h : runBlocks p c ps = .ok ts) :
    absQ (sumQ (ts.map BlockTrace.residual)) ≤ sumQ (ts.map BlockTrace.errorBudget) ∧
    (ts ≠ [] → absQ (sumQ (ts.map BlockTrace.residual)) < sumQ (ts.map BlockTrace.errorBudget)) := by
  induction ps generalizing c ts with
  | nil =>
    simp [runBlocks] at h
    subst ts
    constructor
    · change absQ 0 ≤ 0
      decide
    · intro hn
      exact False.elim (hn rfl)
  | cons q ps ih =>
    cases he : evalBlock (p := p) ⟨q, c⟩ with
    | error e => simp [runBlocks, he] at h
    | ok t =>
      cases hr : runBlocks p t.output.bits ps with
      | error e => simp [runBlocks, he, hr] at h
      | ok rest =>
        simp [runBlocks, he, hr] at h
        subst ts
        have hx := evalBlock_residual_bound he
        have ht := (ih t.output.bits rest hr).1
        have hadd := absQ_add_le t.residual (sumQ (rest.map BlockTrace.residual))
        simp only [List.map_cons, sumQ]
        constructor <;> grind

/-- Uncorrected output error against original encoded operands, across every FP32
boundary. Only the actual intermediate calls must succeed; no final ideal-range
or correction/extraction condition is needed. -/
theorem runBlocks_uncorrected_error (p : Profile) (initial : Finite32)
    (ps : List (List (p.Word × p.Word))) (ts : List BlockTrace) (products : ℚ)
    (h : runBlocks p initial.bits ps = .ok ts)
    (hi : idealContributions p ps = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) ∧
    (ps ≠ [] → absQ (initial.value + products - (lastOutput initial ts).value) <
      sumQ (ts.map BlockTrace.errorBudget)) := by
  have hid := runBlocks_idealContributions p initial.bits ps ts h
  rw [hi] at hid
  have hproducts := Option.some.inj hid
  have hledger := runBlocks_residual_ledger p initial ps ts h
  have he : initial.value + products - (lastOutput initial ts).value =
      sumQ (ts.map BlockTrace.residual) := by grind
  rw [he]
  have hb := runBlocks_residual_budget p initial.bits ps ts h
  refine ⟨hb.1, ?_⟩
  intro hps
  apply hb.2
  have hlen := runBlocks_length p initial.bits ps ts h
  intro hts
  subst ts
  have hp : ps = [] := List.length_eq_zero_iff.mp hlen.symm
  exact hps hp

theorem Program.uncorrected_error {p : Profile} (pr : Program p) (initial : Finite32)
    (ts : List BlockTrace) (ideal : ℚ) (h : pr.run initial.bits = .ok ts)
    (hi : pr.ideal initial.bits = some ideal) :
    absQ (ideal - (lastOutput initial ts).value) ≤ sumQ (ts.map BlockTrace.errorBudget) := by
  have hid := pr.recovery initial ts h
  rw [hi] at hid
  have hv := Option.some.inj hid
  have he : ideal - (lastOutput initial ts).value = sumQ (ts.map BlockTrace.residual) := by
    unfold recoveredSchedule at hv
    grind
  rw [he]
  exact (runBlocks_residual_budget p initial.bits pr.inputs ts h).1

end TensorCore
