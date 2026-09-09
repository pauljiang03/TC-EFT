-- Group Analysis for the tensor-core model.

import TensorCore.TC.Program.Bounds.Local

namespace TensorCore

structure GroupWitness where
  scale : ℤ
  outputScale : ℤ
  deriving Repr, DecidableEq

structure AnalysisBound where
  magnitude : ℚ
  alignment : ℚ
  rounding : ℚ
  deriving Repr, DecidableEq

def AnalysisBound.error (b : AnalysisBound) : ℚ := b.alignment + b.rounding

def productMass (qs : List (Decoded × Decoded)) : ℚ :=
  sumQ (qs.map fun ab => absQ (rawMul ab.1 ab.2).value)

def groupBound (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : AnalysisBound :=
  let M := C + productMass qs
  if M = 0 then ⟨0, 0, 0⟩ else
    ⟨M, (if C = 0 then 0 else pow2 (w.scale - p.alignFraction)) +
      sumQ (qs.map fun ab => rawAlignmentBudget (rawMul ab.1 ab.2) (w.scale - p.alignFraction)),
      pow2 (w.outputScale - 23)⟩

def groupWitnessCheck (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : Bool :=
  decide (qs.length = p.products ∧ 0 ≤ C ∧ -126 ≤ w.scale ∧ -126 ≤ w.outputScale ∧
    (∀ f ∈ p.alignFloor, f ≤ w.scale) ∧ C < pow2 (w.scale + 1) ∧
    C + productMass qs ≤ maxFinite32 ∧ C + productMass qs < pow2 (w.outputScale + 1)) &&
  qs.all (fun ab => (rawMul ab.1 ab.2).significand == 0 ||
    decide ((rawMul ab.1 ab.2).rawScale ≤ w.scale))

def checkGroup (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ)
    (w : GroupWitness) : Option AnalysisBound := do
  let qs ← prepareProducts p g
  if groupWitnessCheck p qs C w then some (groupBound p qs C w) else none

theorem productMass_nonneg (qs : List (Decoded × Decoded)) : 0 ≤ productMass qs := by
  have h := sumQ_map_mono qs (fun _ => 0) (fun ab => absQ (rawMul ab.1 ab.2).value)
    (fun _ _ => absQ_nonneg _)
  simpa only [sumQ_map_zero, productMass] using h

theorem groupBound_magnitude (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : (groupBound p qs C w).magnitude = C + productMass qs := by
  unfold groupBound
  dsimp only
  split <;> simp_all

theorem groupBound_nonneg (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) : 0 ≤ (groupBound p qs C w).error := by
  unfold groupBound
  dsimp only
  split
  · change (0 : ℚ) ≤ 0 + 0
    decide +kernel
  · have hp := pow2_pos (w.scale - p.alignFraction)
    have hr := pow2_pos (w.outputScale - 23)
    have hs := sumQ_map_mono qs (fun _ => 0)
      (fun ab => rawAlignmentBudget (rawMul ab.1 ab.2) (w.scale - p.alignFraction))
      (fun _ _ => rawAlignmentBudget_nonneg _ _)
    rw [sumQ_map_zero] at hs
    change 0 ≤ ((if C = 0 then 0 else pow2 _) + _) + pow2 _
    split <;> grind

theorem checkGroup_sound (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ)
    (w : GroupWitness) (b : AnalysisBound) (h : checkGroup p g C w = some b)
    (c : Finite32) (hc : absQ c.value ≤ C) :
    ∃ t, evalBlock (⟨g, c.bits⟩ : BlockInput p) = .ok t ∧
      idealProducts p g = some t.block.exactProducts ∧
      t.block.exactDot = c.value + t.block.exactProducts ∧
      absQ t.output.value ≤ b.magnitude ∧ absQ (t.block.exactDot - t.output.value) ≤ b.error := by
  cases hqs : prepareProducts p g with
  | none => simp [checkGroup, hqs] at h
  | some qs =>
    simp only [checkGroup, hqs, bind, Option.bind_some] at h
    split at h
    next hw =>
      cases Option.some.inj h
      simp only [groupWitnessCheck, Bool.and_eq_true, decide_eq_true_eq] at hw
      obtain ⟨⟨hshape, hC, hE, hR, hfl, hcm, hrange, houtscale⟩, hscales⟩ := hw
      have hp := prepare_of_decodes g c qs hqs
      have hlength := (prepareProducts_bounds p g qs hqs).1
      have hs : ScaleBounded (PreparedBlock.mk p qs c.decoded).terms w.scale := by
        intro t ht
        simp only [PreparedBlock.terms, List.mem_cons, List.mem_map] at ht
        rcases ht with rfl | ⟨ab, hab, rfl⟩
        · exact finite32_scale_le c w.scale hE (by grind)
        · have ha := List.all_eq_true.mp hscales ab hab
          simp only [Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq] at ha
          intro hnz
          exact ha.resolve_left hnz
      have hm : sumQ ((PreparedBlock.mk p qs c.decoded).terms.map fun t => absQ t.value) ≤
          C + productMass qs := by
        simpa only [PreparedBlock.terms, List.map_cons, List.map_map, Function.comp_def,
          sumQ, productMass, RawProduct.value, Finite32.value, Decoded.value] using
          (Rat.add_le_add_right.mpr hc : absQ c.value + productMass qs ≤ C + productMass qs)
      have hacc := Rat.le_trans (accumulator_abs_le_mass ⟨p, qs, c.decoded⟩) hm
      obtain ⟨t, ht⟩ := (evalBlock_success_iff p ⟨g, c.bits⟩).mpr
        ⟨hlength.symm.trans hshape, _, hp, Rat.le_trans hacc hrange⟩
      have hblock : t.block = ⟨p, qs, c.decoded⟩ := by
        have hh := evalBlock_prepared ht
        rw [hp] at hh
        exact (Option.some.inj hh).symm
      have ho := evalPrepared_output (evalBlock_evalPrepared ht)
      have hmout := round32_rtz_abs_le t.block.accumulator t.output ho
      rw [hblock] at ho hmout
      have hmfinal := Rat.le_trans hmout hacc
      refine ⟨t, ht, ?_, ?_, ?_, ?_⟩
      · rw [hblock]
        exact idealProducts_of_prepareProducts p g qs hqs
      · rw [hblock]; rfl
      · rw [groupBound_magnitude]
        exact hmfinal
      · by_cases hz : C + productMass qs = 0
        · have hid : absQ t.block.exactDot ≤ C + productMass qs := by
            have hh := absQ_sumQ_le (t.block.terms.map RawProduct.value)
            rw [List.map_map] at hh
            rw [terms_value] at hh
            rw [hblock] at hh ⊢
            exact Rat.le_trans hh hm
          have ha := absQ_add_le t.block.exactDot (-t.output.value)
          rw [absQ_neg] at ha
          have hsub : t.block.exactDot - t.output.value = t.block.exactDot + -t.output.value := by grind
          rw [hsub]
          simp only [groupBound, hz, ↓reduceIte, AnalysisBound.error]
          rw [hz] at hid hmfinal
          grind
        · have he := block_local_error ⟨p, qs, c.decoded⟩ t.output w.scale w.outputScale
            hs hfl hR (by grind) ho
          have hb := rawAlignmentBudget_le
            ⟨c.decoded.significand, c.decoded.rawScale, c.decoded.fractionalBits⟩
            (w.scale - p.alignFraction)
          have hcb : rawAlignmentBudget
              ⟨c.decoded.significand, c.decoded.rawScale, c.decoded.fractionalBits⟩
              (w.scale - p.alignFraction) ≤ (if C = 0 then 0 else pow2 (w.scale - p.alignFraction)) := by
            split
            next hzero =>
              have hv : c.value = 0 := by
                have hh := (absQ_le_iff c.value C).mp hc
                rw [hzero] at hh
                grind
              rw [rawAlignmentBudget_zero _ _ (by
                simpa only [RawProduct.value, Finite32.value, Decoded.value] using hv)]
              exact Rat.le_refl
            next _ => exact hb
          rw [hblock]
          simp only [groupBound, hz, ↓reduceIte, AnalysisBound.error]
          simp only [PreparedBlock.terms, List.map_cons, List.map_map, Function.comp_def, sumQ] at he
          grind
    next hn => simp at h

def magnitudeScale (C : ℚ) : ℤ :=
  if C = 0 then -126 else max (-126) (magnitudeExponent C)

theorem magnitudeScale_spec (C : ℚ) (hC : 0 ≤ C) :
    -126 ≤ magnitudeScale C ∧ C < pow2 (magnitudeScale C + 1) := by
  by_cases hz : C = 0
  · simp only [magnitudeScale, hz, ↓reduceIte]
    exact ⟨Int.le_refl _, pow2_pos _⟩
  · have hm := (magnitudeExponent_spec C (show 0 < C by grind)).2
    have he : magnitudeExponent C ≤ max (-126) (magnitudeExponent C) := by omega
    have hp := pow2_le_of_le (show magnitudeExponent C + 1 ≤ max (-126) (magnitudeExponent C) + 1 by omega)
    simp only [magnitudeScale, hz, ↓reduceIte]
    constructor
    · omega
    · grind

def productScaleBound (qs : List (Decoded × Decoded)) (E : ℤ) : ℤ :=
  qs.foldl (fun e ab => if (rawMul ab.1 ab.2).significand = 0 then e
    else max e (rawMul ab.1 ab.2).rawScale) E

theorem productScaleBound_spec (qs : List (Decoded × Decoded)) (E : ℤ) :
    E ≤ productScaleBound qs E ∧
      ∀ ab ∈ qs, (rawMul ab.1 ab.2).significand ≠ 0 →
        (rawMul ab.1 ab.2).rawScale ≤ productScaleBound qs E := by
  induction qs generalizing E with
  | nil => exact ⟨Int.le_refl _, by simp⟩
  | cons ab qs ih =>
    simp only [productScaleBound, List.foldl_cons]
    split
    next hz =>
      obtain ⟨he, hs⟩ := ih E
      refine ⟨he, ?_⟩
      intro x hx hn
      rcases List.mem_cons.mp hx with rfl | hx
      · exact absurd hz hn
      · exact hs x hx hn
    next hn =>
      obtain ⟨he, hs⟩ := ih (max E (rawMul ab.1 ab.2).rawScale)
      simp only [productScaleBound] at he hs
      refine ⟨by omega, ?_⟩
      intro x hx hne
      rcases List.mem_cons.mp hx with rfl | hx
      · omega
      · exact hs x hx hne

def inferGroupWitness (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ) : GroupWitness :=
  let E := productScaleBound qs (max (magnitudeScale C) (p.alignFloor.getD (-126)))
  ⟨E, magnitudeScale (C + productMass qs)⟩

theorem inferGroupWitness_valid (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (hshape : qs.length = p.products) (hC : 0 ≤ C) (hr : C + productMass qs ≤ maxFinite32) :
    groupWitnessCheck p qs C (inferGroupWitness p qs C) = true := by
  obtain ⟨hc1, hc2⟩ := magnitudeScale_spec C hC
  have hM : 0 ≤ C + productMass qs := by have := productMass_nonneg qs; grind
  obtain ⟨hr1, hr2⟩ := magnitudeScale_spec (C + productMass qs) hM
  obtain ⟨hE, hs⟩ := productScaleBound_spec qs (max (magnitudeScale C) (p.alignFloor.getD (-126)))
  have hpow := pow2_le_of_le (show magnitudeScale C + 1 ≤
    productScaleBound qs (max (magnitudeScale C) (p.alignFloor.getD (-126))) + 1 by omega)
  dsimp only [groupWitnessCheck, inferGroupWitness]
  rw [Bool.and_eq_true, decide_eq_true_eq]
  refine ⟨⟨hshape, hC, by omega, hr1, ?_, by grind, hr, hr2⟩, ?_⟩
  · intro f hf
    cases hp : p.alignFloor with
    | none => simp [hp] at hf
    | some a =>
      simp only [hp, Option.mem_def, Option.some.injEq] at hf
      simp only [hp, Option.getD_some] at hE
      simp only [Option.getD_some]
      omega
  · apply List.all_eq_true.mpr
    intro ab hab
    simp only [Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq]
    by_cases hz : (rawMul ab.1 ab.2).significand = 0
    · exact Or.inl hz
    · exact Or.inr (hs ab hab hz)

def inferGroup (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ) :
    Option (GroupWitness × AnalysisBound) := do
  let qs ← prepareProducts p g
  let w := inferGroupWitness p qs C
  let b ← checkGroup p g C w
  return (w, b)

theorem inferGroup_checked (p : Profile) (g : List (p.Word × p.Word)) (C : ℚ)
    (w : GroupWitness) (b : AnalysisBound) (h : inferGroup p g C = some (w, b)) :
    checkGroup p g C w = some b := by
  simp only [inferGroup, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨qs, _, bound, hb, he⟩ := h
  cases he
  exact hb

def checkGroups (p : Profile) : List (List (p.Word × p.Word)) → ℚ → List GroupWitness →
    Option AnalysisBound
  | [], C, [] => some ⟨C, 0, 0⟩
  | g :: gs, C, w :: ws => do
    let b ← checkGroup p g C w
    let rest ← checkGroups p gs b.magnitude ws
    return ⟨rest.magnitude, b.alignment + rest.alignment, b.rounding + rest.rounding⟩
  | _, _, _ => none

theorem checkGroups_sound (p : Profile) (gs : List (List (p.Word × p.Word))) (C : ℚ)
    (ws : List GroupWitness) (b : AnalysisBound) (h : checkGroups p gs C ws = some b)
    (c : Finite32) (hc : absQ c.value ≤ C) :
    ∃ ts products, runBlocks p c.bits gs = .ok ts ∧ idealContributions p gs = some products ∧
      absQ (lastOutput c ts).value ≤ b.magnitude ∧
      absQ (c.value + products - (lastOutput c ts).value) ≤ b.error := by
  induction gs generalizing C ws b c with
  | nil =>
    cases ws with
    | nil =>
      cases Option.some.inj h
      refine ⟨[], 0, rfl, rfl, hc, ?_⟩
      change absQ (c.value + 0 - c.value) ≤ 0 + 0
      rw [Rat.add_zero, Rat.sub_self]
      decide +kernel
    | cons _ _ => simp [checkGroups] at h
  | cons g gs ih =>
    cases ws with
    | nil => simp [checkGroups] at h
    | cons w ws =>
      simp only [checkGroups, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
      obtain ⟨step, hs, tail, ht, he⟩ := h
      cases he
      obtain ⟨t, hr, hp, hd, hm, herr⟩ := checkGroup_sound p g C w step hs c hc
      obtain ⟨ts, products, hrun, hi, hmag, herror⟩ := ih step.magnitude ws tail ht t.output hm
      refine ⟨t :: ts, t.block.exactProducts + products, ?_, ?_, hmag, ?_⟩
      · simp only [runBlocks, hr, hrun]
      · exact idealContributions_cons p g gs _ _ hp hi
      · have ha := absQ_add_le (c.value + t.block.exactProducts - t.output.value)
          (t.output.value + products - (lastOutput t.output ts).value)
        have heq : c.value + t.block.exactProducts - t.output.value +
            (t.output.value + products - (lastOutput t.output ts).value) =
            c.value + (t.block.exactProducts + products) - (lastOutput t.output ts).value := by grind
        rw [heq] at ha
        rw [hd] at herr
        simp only [lastOutput, AnalysisBound.error] at *
        grind

def inferGroups (p : Profile) : List (List (p.Word × p.Word)) → ℚ → Option (List GroupWitness)
  | [], _ => some []
  | g :: gs, C => do
    let (w, b) ← inferGroup p g C
    let rest ← inferGroups p gs b.magnitude
    return w :: rest

theorem inferGroups_checked (p : Profile) (gs : List (List (p.Word × p.Word))) (C : ℚ)
    (ws : List GroupWitness) (h : inferGroups p gs C = some ws) :
    ∃ b, checkGroups p gs C ws = some b := by
  induction gs generalizing C ws with
  | nil =>
    cases Option.some.inj h
    exact ⟨⟨C, 0, 0⟩, rfl⟩
  | cons g gs ih =>
    simp only [inferGroups, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
    obtain ⟨⟨w, b⟩, hg, rest, hr, rfl⟩ := h
    obtain ⟨tail, ht⟩ := ih b.magnitude rest hr
    refine ⟨⟨tail.magnitude, b.alignment + tail.alignment, b.rounding + tail.rounding⟩, ?_⟩
    simp [checkGroups, inferGroup_checked p g C w b hg, ht]

def scheduleMass (p : Profile) : List (List (p.Word × p.Word)) → Option ℚ
  | [] => some 0
  | g :: gs => do
    let qs ← prepareProducts p g
    let rest ← scheduleMass p gs
    return productMass qs + rest

theorem scheduleMass_nonneg (p : Profile) (gs : List (List (p.Word × p.Word)))
    (M : ℚ) (h : scheduleMass p gs = some M) : 0 ≤ M := by
  induction gs generalizing M with
  | nil => cases Option.some.inj h; exact Rat.le_refl
  | cons g gs ih =>
    simp only [scheduleMass, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
    obtain ⟨qs, _, rest, hr, rfl⟩ := h
    have := ih rest hr
    have := productMass_nonneg qs
    grind

/-- Inference succeeds throughout the finite domain certified by the unsigned input mass. -/
theorem inferGroups_complete (p : Profile) (gs : List (List (p.Word × p.Word))) (C M : ℚ)
    (hshape : ∀ g ∈ gs, g.length = p.products) (hC : 0 ≤ C)
    (hm : scheduleMass p gs = some M) (hr : C + M ≤ maxFinite32) :
    ∃ ws, inferGroups p gs C = some ws := by
  induction gs generalizing C M with
  | nil => exact ⟨[], rfl⟩
  | cons g gs ih =>
    simp only [scheduleMass, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hm
    obtain ⟨qs, hqs, rest, hrest, rfl⟩ := hm
    have hn := scheduleMass_nonneg p gs rest hrest
    have hpos := productMass_nonneg qs
    have hw := inferGroupWitness_valid p qs C
      ((prepareProducts_bounds p g qs hqs).1.trans (hshape g (by simp))) hC (by grind)
    let w := inferGroupWitness p qs C
    let b := groupBound p qs C w
    have hg : inferGroup p g C = some (w, b) := by simp [inferGroup, checkGroup, hqs, hw, w, b]
    obtain ⟨ws, hws⟩ := ih (C + productMass qs) rest
      (fun q hq => hshape q (by simp [hq])) (by grind) hrest (by grind)
    refine ⟨w :: ws, ?_⟩
    have hmag : b.magnitude = C + productMass qs := groupBound_magnitude p qs C w
    simp [inferGroups, hg, hmag, hws]

theorem groupBound_le_static (p : Profile) (qs : List (Decoded × Decoded)) (C : ℚ)
    (w : GroupWitness) (E : ℤ) (L : ℕ) (hshape : qs.length = p.products)
    (hE : w.scale ≤ E) (hR : w.outputScale ≤ max (E + 1 + L) (-126)) :
    (groupBound p qs C w).error ≤ staticBudget (p.products + 1) p.alignFraction E L := by
  have hq := pow2_le_of_le (show w.scale - p.alignFraction ≤ E - p.alignFraction by omega)
  have hr := pow2_le_of_le (show w.outputScale - 23 ≤ max (E + 1 + L) (-126) - 23 by omega)
  have hs := sumQ_map_le qs
    (fun ab => rawAlignmentBudget (rawMul ab.1 ab.2) (w.scale - p.alignFraction))
    (pow2 (E - p.alignFraction)) (fun ab _ => Rat.le_trans (rawAlignmentBudget_le _ _) hq)
  rw [hshape] at hs
  have hn : (0 : ℚ) ≤ p.products := Rat.natCast_nonneg
  have hp := pow2_pos (E - p.alignFraction)
  have hprod := Rat.mul_nonneg hn (Rat.le_of_lt hp)
  have hout := pow2_pos (max (E + 1 + L) (-126) - 23)
  unfold groupBound
  dsimp only
  split
  · simp only [AnalysisBound.error, staticBudget, Rat.natCast_add]
    change 0 + 0 ≤ ((p.products : ℚ) + 1) * pow2 _ + pow2 _
    grind
  · simp only [AnalysisBound.error, staticBudget, Rat.natCast_add]
    change (if C = 0 then 0 else pow2 _) + _ + pow2 _ ≤
      ((p.products : ℚ) + 1) * pow2 _ + pow2 _
    split <;> grind

end TensorCore
