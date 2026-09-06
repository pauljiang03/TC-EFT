import TensorCore.Theory.StaticBudget
import TensorCore.Theory.Monotonicity

/-! A decidable certificate for `runBlocks_static`. `staticCheck` inspects the operands and the
ideal partial sums of a schedule; when it returns `true`, `staticCheck_sound` gives acceptance
of the whole run and the input-derived error bound. The model is never executed by the check. -/

namespace TensorCore

/-- Every pair decodes and every nonzero raw product has raw scale at most `E`. -/
def groupScaleCheck (p : Profile) (E : Int) (g : List (p.Word × p.Word)) : Bool :=
  g.all fun (a, b) =>
    match p.decode a, p.decode b with
    | some da, some db => (rawMul da db).significand == 0 || decide ((rawMul da db).rawScale ≤ E)
    | _, _ => false

theorem groupScaleCheck_sound (p : Profile) (E : Int) (g : List (p.Word × p.Word))
    (h : groupScaleCheck p E g = true) : GroupScaleBounded p g E := by
  intro pair hpair
  rcases pair with ⟨a, b⟩
  have hp := List.all_eq_true.mp h (a, b) hpair
  simp only at hp
  cases ha : p.decode a with
  | none => simp [ha] at hp
  | some da =>
    cases hb : p.decode b with
    | none => simp [ha, hb] at hp
    | some db =>
      refine ⟨da, db, rfl, rfl, ?_⟩
      intro hnz
      rw [ha, hb] at hp
      simp only [Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq] at hp
      rcases hp with hp | hp
      · exact absurd hp hnz
      · exact hp

/-- Every ideal partial sum, offset by the accumulated budget, stays below `2^(E+1)`. -/
def partialSumsCheck (p : Profile) (E : Int) (B c : Rat) :
    List (List (p.Word × p.Word)) → Nat → Rat → Bool
  | [], n, acc => decide (absQ (c + acc) + (n : Rat) * B < pow2 (E + 1))
  | g :: rest, n, acc =>
    decide (absQ (c + acc) + (n : Rat) * B < pow2 (E + 1)) &&
      match idealProducts p g with
      | some v => partialSumsCheck p E B c rest (n + 1) (acc + v)
      | none => false

theorem idealContributions_cons_some (p : Profile) (g : List (p.Word × p.Word))
    (rest : List (List (p.Word × p.Word))) (v : Rat)
    (h : idealContributions p (g :: rest) = some v) :
    ∃ a b, idealProducts p g = some a ∧ idealContributions p rest = some b ∧ v = a + b := by
  cases ha : idealProducts p g with
  | none => simp [idealContributions, ha] at h
  | some a =>
    cases hb : idealContributions p rest with
    | none => simp [idealContributions, ha, hb] at h
    | some b =>
      refine ⟨a, b, rfl, rfl, ?_⟩
      rw [idealContributions_cons p g rest a b ha hb] at h
      exact (Option.some.inj h).symm

theorem partialSumsCheck_sound (p : Profile) (E : Int) (B c : Rat)
    (ps : List (List (p.Word × p.Word))) (k : Nat) (acc : Rat)
    (h : partialSumsCheck p E B c ps k acc = true) :
    ∀ n ≤ ps.length, ∀ v, idealContributions p (ps.take n) = some v →
      absQ (c + (acc + v)) + ((k + n : Nat) : Rat) * B < pow2 (E + 1) := by
  induction ps generalizing k acc with
  | nil =>
    intro n hn v hv
    have hn0 : n = 0 := by simpa using hn
    subst hn0
    simp only [List.take_nil, idealContributions, Option.some.injEq] at hv
    subst hv
    simp only [partialSumsCheck, decide_eq_true_eq] at h
    simp only [Nat.add_zero, Rat.add_zero]
    exact h
  | cons g rest ih =>
    intro n hn v hv
    simp only [partialSumsCheck, Bool.and_eq_true, decide_eq_true_eq] at h
    obtain ⟨h0, hrest⟩ := h
    cases n with
    | zero =>
      simp only [List.take_zero, idealContributions, Option.some.injEq] at hv
      subst hv
      simp only [Nat.add_zero, Rat.add_zero]
      exact h0
    | succ n =>
      cases hg : idealProducts p g with
      | none => simp [hg] at hrest
      | some vg =>
        rw [hg] at hrest
        rw [List.take_succ_cons] at hv
        obtain ⟨a, v', ha, hr, rfl⟩ := idealContributions_cons_some p g _ v hv
        rw [hg] at ha
        cases Option.some.inj ha
        have := ih (k + 1) (acc + vg) hrest n (by simpa using hn) v' hr
        have hk : ((k + 1 + n : Nat) : Rat) = ((k + (n + 1) : Nat) : Rat) := by
          congr 1
          omega
        rw [hk] at this
        have he : c + (acc + vg + v') = c + (acc + (vg + v')) := by grind
        rw [he] at this
        exact this

/-- The decidable certificate: `E ≥ −126`, the floor at most `E`, `n ≤ 2^L`,
`E + 2 + L ≤ 127`, every group of the right width and scale-bounded, a finite accumulator
input, and bounded ideal partial sums. -/
def staticCheck (p : Profile) (E : Int) (L : Nat) (c : F32)
    (ps : List (List (p.Word × p.Word))) : Bool :=
  decide (-126 ≤ E) &&
  (match p.alignFloor with | none => true | some f => decide (f ≤ E)) &&
  decide (p.products + 1 ≤ 2 ^ L) && decide (E + 2 + L ≤ 127) &&
  ps.all (fun g => g.length == p.products && groupScaleCheck p E g) &&
  match value32 c with
  | some cv => partialSumsCheck p E (staticBudget (p.products + 1) p.alignFraction E L) cv ps 0 0
  | none => false

/-- A passing certificate gives acceptance of the run and the input-derived error bound. -/
theorem staticCheck_sound (p : Profile) (E : Int) (L : Nat) (c : F32)
    (ps : List (List (p.Word × p.Word))) (h : staticCheck p E L c ps = true) :
    ∃ f : Finite32, f.bits = c ∧ ∃ ts products, runBlocks p c ps = .ok ts ∧
      idealContributions p ps = some products ∧
      absQ (f.value + products - (lastOutput f ts).value) ≤
        (ps.length : Rat) * staticBudget (p.products + 1) p.alignFraction E L := by
  unfold staticCheck at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨⟨⟨⟨hE, hfl⟩, hL⟩, hrange⟩, hgroups⟩, hpartial⟩ := h
  cases hc : value32 c with
  | none => simp [hc] at hpartial
  | some cv =>
    rw [hc] at hpartial
    simp only at hpartial
    obtain ⟨f, _, hfb, hfv⟩ := finite32_of_value32 c cv hc
    have hfl' : ∀ x ∈ p.alignFloor, x ≤ E := by
      intro x hx
      cases hf : p.alignFloor with
      | none => rw [hf] at hx; simp at hx
      | some y =>
        rw [hf] at hx hfl
        simp only [Option.mem_def, Option.some.injEq] at hx
        subst hx
        simpa using hfl
    have hshape : ∀ g ∈ ps, g.length = p.products := by
      intro g hg
      have := List.all_eq_true.mp hgroups g hg
      simp only [Bool.and_eq_true, beq_iff_eq] at this
      exact this.1
    have hscale : ∀ g ∈ ps, GroupScaleBounded p g E := by
      intro g hg
      have := List.all_eq_true.mp hgroups g hg
      simp only [Bool.and_eq_true, beq_iff_eq] at this
      exact groupScaleCheck_sound p E g this.2
    have hps := partialSumsCheck_sound p E _ cv ps 0 0 hpartial
    have hpartial' : ∀ n ≤ ps.length, ∀ v, idealContributions p (ps.take n) = some v →
        absQ (f.value + v) + (n : Rat) * staticBudget (p.products + 1) p.alignFraction E L <
          pow2 (E + 1) := by
      intro n hn v hv
      have := hps n hn v hv
      rw [Rat.zero_add, Nat.zero_add] at this
      rw [hfv]
      exact this
    obtain ⟨ts, products, hrun, hi, hbound⟩ :=
      runBlocks_static p E L hE hfl' hL hrange ps hshape hscale f hpartial'
    rw [hfb] at hrun
    exact ⟨f, hfb, ts, products, hrun, hi, hbound⟩

end TensorCore
