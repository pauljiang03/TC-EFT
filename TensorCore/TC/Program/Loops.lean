-- Loops for the tensor-core model.

import TensorCore.TC.Program.Defs

namespace TensorCore

theorem lastOutput_append (initial : Finite32) (xs ys : List BlockTrace) :
    lastOutput initial (xs ++ ys) = lastOutput (lastOutput initial xs) ys := by
  induction xs generalizing initial with
  | nil => rfl
  | cons t ts ih => exact ih t.output

theorem runBlocks_append (p : Profile) (initial : Finite32)
    (xs ys : List (List (p.Word × p.Word))) (ts us : List BlockTrace)
    (hx : runBlocks p initial.bits xs = .ok ts)
    (hy : runBlocks p (lastOutput initial ts).bits ys = .ok us) :
    runBlocks p initial.bits (xs ++ ys) = .ok (ts ++ us) := by
  induction xs generalizing initial ts with
  | nil => simp [runBlocks] at hx; cases hx; exact hy
  | cons x xs ih =>
    cases he : evalBlock (p := p) ⟨x, initial.bits⟩ with
    | error e => simp [runBlocks, he] at hx
    | ok t =>
      cases hr : runBlocks p t.output.bits xs with
      | error e => simp [runBlocks, he, hr] at hx
      | ok rest =>
        simp [runBlocks, he, hr] at hx
        cases hx
        have hi := ih t.output rest hr hy
        simp [runBlocks, he, hi]

theorem map_repeatList (f : α → β) (xs : List α) (n : ℕ) :
    (repeatList xs n).map f = repeatList (xs.map f) n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [repeatList, ih]

theorem Program.inputs_repeat {p : Profile} (body : Program p) (n : ℕ) :
    (Program.repeat n body).inputs = repeatList body.inputs n :=
  map_repeatList _ _ n

/-- A reusable loop invariant: one body returns the exact same encoded state.
Induction handles arbitrary n; the theorem does not enumerate a chosen bound. -/
theorem runBlocks_repeat_invariant (p : Profile) (initial : Finite32)
    (body : List (List (p.Word × p.Word))) (ts : List BlockTrace)
    (hbody : runBlocks p initial.bits body = .ok ts)
    (hstate : lastOutput initial ts = initial) (n : ℕ) :
    runBlocks p initial.bits (repeatList body n) = .ok (repeatList ts n) ∧
    lastOutput initial (repeatList ts n) = initial := by
  induction n with
  | zero => exact ⟨rfl, rfl⟩
  | succ n ih =>
    constructor
    · exact runBlocks_append p initial body (repeatList body n) ts (repeatList ts n)
        hbody (by simpa [hstate] using ih.1)
    · change lastOutput initial (ts ++ repeatList ts n) = initial
      rw [lastOutput_append, hstate]; exact ih.2

theorem sumQ_append (xs ys : List ℚ) : sumQ (xs ++ ys) = sumQ xs + sumQ ys := by
  induction xs with
  | nil => simp only [List.nil_append, sumQ]; grind
  | cons x xs ih => simp only [List.cons_append, sumQ, ih]; grind

theorem sumQ_repeatList_zero (xs : List ℚ) (hx : sumQ xs = 0) (n : ℕ) :
    sumQ (repeatList xs n) = 0 := by
  induction n with
  | zero => rfl
  | succ n ih => rw [repeatList, sumQ_append, hx, ih]; grind

/-- A checked body with a zero ledger and an unchanged encoded state can be
repeated any finite number of times without new scalar or range assumptions. -/
theorem Program.repeat_vc_of_cycle {p : Profile} (body : Program p) (initial : Finite32)
    (ts : List BlockTrace) (hfinite : finite32 initial.bits = some initial)
    (hbody : body.run initial.bits = .ok ts) (hstate : lastOutput initial ts = initial)
    (hloss : sumQ (ts.map BlockTrace.residual) = 0)
    (hrange : absQ initial.value ≤ maxFinite32) (n : ℕ) :
    (Program.repeat n body).VC initial.bits := by
  have hi := runBlocks_repeat_invariant p initial body.inputs ts hbody hstate n
  have he : (Program.repeat n body).run initial.bits = .ok (repeatList ts n) := by
    simpa [Program.run, Program.inputs_repeat] using hi.1
  have hl : sumQ ((repeatList ts n).map BlockTrace.residual) = 0 := by
    rw [map_repeatList]; exact sumQ_repeatList_zero _ hloss n
  unfold Program.VC
  rw [hfinite, he]
  change absQ ((lastOutput initial (repeatList ts n)).value +
    sumQ ((repeatList ts n).map BlockTrace.residual)) ≤ maxFinite32
  rw [hi.2, hl]
  have hz : initial.value + 0 = initial.value := by grind
  rw [hz]; exact hrange

end TensorCore
