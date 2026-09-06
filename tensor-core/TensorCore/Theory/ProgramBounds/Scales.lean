import TensorCore.Programs.CertifiedProgram

namespace TensorCore

/-- Bound the ideal of a group from its decoded raw-product scales. -/
theorem idealProducts_abs_le_of_scale (p : Profile) (g : List (p.Word × p.Word)) (P : Int)
    (hs : GroupScaleBounded p g P) (v : Rat) (hv : idealProducts p g = some v) :
    absQ v ≤ (g.length : Rat) * (4 * pow2 P) := by
  cases hp : prepareProducts p g with
  | none => simp [idealProducts, hp] at hv
  | some qs =>
    simp only [idealProducts, hp, Option.map_some, Option.some.injEq] at hv
    rw [← hv]
    have hb := prepareProducts_bounds p g qs hp
    have hterms : ∀ q ∈ qs, absQ (q.1.value * q.2.value) ≤ 4 * pow2 P := by
      intro q hq
      obtain ⟨pair, hpair, ha, hc⟩ := prepareProducts_origin p g qs hp q hq
      obtain ⟨da, db, hda, hdb, hscale⟩ := hs pair hpair
      rw [ha] at hda
      rw [hc] at hdb
      cases Option.some.inj hda
      cases Option.some.inj hdb
      rw [← rawProduct_value]
      exact Rat.le_of_lt (term_abs_lt (rawMul q.1 q.2) P
        (rawMul_bounded q.1 q.2 (hb.2 q hq).1 (hb.2 q hq).2) hscale)
    have hsum := absQ_sumQ_le (qs.map fun q => q.1.value * q.2.value)
    have hbound := sumQ_map_le qs (fun q => absQ (q.1.value * q.2.value)) (4 * pow2 P) hterms
    simp only [List.map_map, Function.comp_def] at hsum
    rw [hb.1] at hbound
    exact Rat.le_trans hsum hbound

/-- This induction bounds all ideal sums without computing any input-dependent prefix. -/
theorem idealContributions_abs_le (p : Profile) (ps : List (List (p.Word × p.Word)))
    (G : Rat) (hgroups : ∀ g ∈ ps, ∀ v, idealProducts p g = some v → absQ v ≤ G)
    (v : Rat) (hv : idealContributions p ps = some v) :
    absQ v ≤ (ps.length : Rat) * G := by
  induction ps generalizing v with
  | nil =>
    simp only [idealContributions, Option.some.injEq] at hv
    subst v
    simp [absQ]
  | cons g rest ih =>
    obtain ⟨a, b, ha, hb, rfl⟩ := idealContributions_cons_some p g rest v hv
    have hga := hgroups g (by simp) a ha
    have hrest := ih (fun q hq => hgroups q (by simp [hq])) b hb
    have hab := absQ_add_le a b
    have hlen : ((g :: rest).length : Rat) = 1 + (rest.length : Rat) := by
      simp only [List.length_cons, Rat.natCast_add]
      change (rest.length : Rat) + 1 = 1 + (rest.length : Rat)
      grind
    rw [hlen]
    grind

theorem staticBudget_positive (n : Nat) (F E : Int) (L : Nat) : 0 < staticBudget n F E L := by
  have h1 := pow2_pos (E - F)
  have h2 := pow2_pos (max (E + 1 + L) (-126) - 23)
  have h3 : (0 : Rat) ≤ n := Rat.natCast_nonneg
  have := Rat.mul_nonneg h3 (Rat.le_of_lt h1)
  unfold staticBudget
  grind

theorem GroupScaleBounded.mono {p : Profile} {g : List (p.Word × p.Word)} {P E : Int}
    (hs : GroupScaleBounded p g P) (hPE : P ≤ E) : GroupScaleBounded p g E := by
  intro pair hpair
  obtain ⟨da, db, ha, hb, hscale⟩ := hs pair hpair
  exact ⟨da, db, ha, hb, fun hnz => Int.le_trans (hscale hnz) hPE⟩

/-- Input-derived acceptance and error for any schedule. Operand scale bounds and length
control ideal prefixes and the changing rounded state; exact prefixes are never evaluated. -/
theorem runBlocks_of_scale_bound (p : Profile) (E P : Int) (L : Nat)
    (hE : -126 ≤ E) (hPE : P ≤ E) (hfl : ∀ f ∈ p.alignFloor, f ≤ E)
    (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (ps : List (List (p.Word × p.Word))) (hshape : ∀ g ∈ ps, g.length = p.products)
    (hscale : ∀ g ∈ ps, GroupScaleBounded p g P) (initial : Finite32) (C : Rat)
    (hC : absQ initial.value ≤ C)
    (hroom : C + (ps.length : Rat) *
      ((p.products : Rat) * (4 * pow2 P) + staticBudget (p.products + 1) p.alignFraction E L) <
      pow2 (E + 1)) :
    ∃ ts products, runBlocks p initial.bits ps = .ok ts ∧
      idealContributions p ps = some products ∧
      absQ (initial.value + products - (lastOutput initial ts).value) ≤
        (ps.length : Rat) * staticBudget (p.products + 1) p.alignFraction E L := by
  apply runBlocks_static p E L hE hfl hL hrange ps hshape
    (fun g hg => (hscale g hg).mono hPE) initial
  intro n hn v hv
  have hbound := idealContributions_abs_le p (ps.take n)
    ((p.products : Rat) * (4 * pow2 P)) (by
      intro g hg x hx
      have hg' : g ∈ ps := List.mem_of_mem_take hg
      have := idealProducts_abs_le_of_scale p g P (hscale g hg') x hx
      simpa [hshape g hg'] using this) v hv
  rw [List.length_take, Nat.min_eq_left hn] at hbound
  have hsum := absQ_add_le initial.value v
  have hn' : (n : Rat) ≤ (ps.length : Rat) := Rat.natCast_le_natCast.mpr hn
  have hnonneg : (0 : Rat) ≤ (p.products : Rat) * (4 * pow2 P) +
      staticBudget (p.products + 1) p.alignFraction E L := by
    have hq := pow2_pos P
    have hk : (0 : Rat) ≤ p.products := Rat.natCast_nonneg
    have hg := Rat.mul_nonneg hk (show 0 ≤ 4 * pow2 P by grind)
    have hb := staticBudget_positive (p.products + 1) p.alignFraction E L
    grind
  have hm := Rat.mul_le_mul_of_nonneg_right hn' hnonneg
  grind

end TensorCore
