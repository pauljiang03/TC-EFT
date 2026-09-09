-- Loops for the tensor-core model.

import TensorCore.TC.Program.Bounds.Scales
import TensorCore.TC.Program.Loops

namespace TensorCore

theorem repeatList_length (xs : List α) (n : ℕ) : (repeatList xs n).length = n * xs.length := by
  induction n with
  | zero => simp [repeatList]
  | succ n ih => simp [repeatList, ih, Nat.succ_mul, Nat.add_comm]

theorem mem_of_mem_repeatList (xs : List α) (n : ℕ) (x : α)
    (h : x ∈ repeatList xs n) : x ∈ xs := by
  induction n with
  | zero => simp [repeatList] at h
  | succ n ih =>
    simp only [repeatList, List.mem_append] at h
    exact h.elim id ih

/-- An input-scale certificate for arbitrary programs, without concrete ideal prefixes. -/
theorem Program.accurate_of_scales {p : Profile} (pr : Program p) (E P : ℤ) (L : ℕ)
    (hE : -126 ≤ E) (hPE : P ≤ E) (hfl : ∀ f ∈ p.alignFloor, f ≤ E)
    (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (hscale : ∀ g ∈ pr.inputs, GroupScaleBounded p g P) (initial : Finite32) (C tolerance : ℚ)
    (hC : absQ initial.value ≤ C)
    (hroom : C + (pr.inputs.length : ℚ) *
      ((p.products : ℚ) * (4 * pow2 P) + staticBudget (p.products + 1) p.alignFraction E L) <
      pow2 (E + 1))
    (htol : pr.staticErrorBudget E L ≤ tolerance) : pr.Accurate initial.bits tolerance := by
  have hshape : ∀ g ∈ pr.inputs, g.length = p.products := by
    intro g hg
    obtain ⟨call, _, rfl⟩ := List.mem_map.mp hg
    exact call.operands.shape
  obtain ⟨ts, products, hr, hi, he⟩ := runBlocks_of_scale_bound p E P L hE hPE hfl hL hrange
    pr.inputs hshape hscale initial C hC hroom
  exact pr.accurate_of_run initial ts products tolerance hr hi (Rat.le_trans he htol)

/-- Repetition with a changing rounded accumulator and accumulated error. All iterations
are covered by induction from operand bounds; the body need not restore its initial state. -/
theorem Program.repeat_accurate_of_scales {p : Profile} (body : Program p) (n : ℕ)
    (E P : ℤ) (L : ℕ) (hE : -126 ≤ E) (hPE : P ≤ E)
    (hfl : ∀ f ∈ p.alignFloor, f ≤ E) (hL : p.products + 1 ≤ 2 ^ L)
    (hrange : E + 2 + L ≤ 127) (hscale : ∀ g ∈ body.inputs, GroupScaleBounded p g P)
    (initial : Finite32) (C tolerance : ℚ) (hC : absQ initial.value ≤ C)
    (hroom : C + ((n * body.inputs.length : ℕ) : ℚ) *
      ((p.products : ℚ) * (4 * pow2 P) + staticBudget (p.products + 1) p.alignFraction E L) <
      pow2 (E + 1))
    (htol : ((n * body.inputs.length : ℕ) : ℚ) *
      staticBudget (p.products + 1) p.alignFraction E L ≤ tolerance) :
    (Program.repeat n body).Accurate initial.bits tolerance := by
  apply Program.accurate_of_scales _ E P L hE hPE hfl hL hrange
  · intro g hg
    rw [Program.inputs_repeat] at hg
    exact hscale g (mem_of_mem_repeatList body.inputs n g hg)
  · exact hC
  · simpa only [Program.inputs_repeat, repeatList_length] using hroom
  · simpa only [Program.staticErrorBudget, Program.inputs_repeat, repeatList_length] using htol

end TensorCore
