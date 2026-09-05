import TensorCore.Theory.Canonical

namespace TensorCore

private theorem mapM_origin (f : α → Option β) (xs : List α) (ys : List β)
    (h : xs.mapM f = some ys) : ∀ y ∈ ys, ∃ x ∈ xs, f x = some y := by
  induction xs generalizing ys with
  | nil => simp at h; subst ys; simp
  | cons x xs ih =>
    cases hf : f x with
    | none => simp [List.mapM_cons, hf] at h
    | some y =>
      cases ht : xs.mapM f with
      | none => simp [List.mapM_cons, hf, ht] at h
      | some zs =>
        simp [List.mapM_cons, hf, ht] at h
        subst ys
        intro z hz
        simp only [List.mem_cons] at hz
        rcases hz with hz | hz
        · subst z; exact ⟨x, by simp, hf⟩
        · obtain ⟨a, ha, hd⟩ := ih zs ht z hz
          exact ⟨a, by simp [ha], hd⟩

/-- Every prepared factor pair comes from an original encoded pair. -/
theorem prepareProducts_origin (p : Profile) (xs : List (p.Word × p.Word))
    (ys : List (Decoded × Decoded)) (h : prepareProducts p xs = some ys) :
    ∀ y ∈ ys, ∃ x ∈ xs, p.decode x.1 = some y.1 ∧ p.decode x.2 = some y.2 := by
  intro y hy
  obtain ⟨x, hx, hd⟩ := mapM_origin _ xs ys h y hy
  refine ⟨x, hx, ?_⟩
  cases ha : p.decode x.1 with
  | none => simp [ha] at hd
  | some a =>
    cases hb : p.decode x.2 with
    | none => simp [ha, hb] at hd
    | some b =>
      simp [ha, hb] at hd
      subst y
      exact ⟨rfl, rfl⟩

theorem prepare_fp16_terms_lower (K extra : Nat) (floor : Option Int)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (h : prepare x = some b) :
    ∀ t ∈ b.terms, t.significand ≠ 0 → -126 ≤ t.rawScale := by
  unfold prepare at h
  cases hc : decode32 x.c with
  | none => simp [hc] at h
  | some c =>
    cases hp : prepareProducts (fp16Fp32Profile K extra floor) x.products with
    | none => simp [hc, hp] at h
    | some ps =>
      simp [hc, hp] at h
      subst b
      intro t ht hnz
      simp only [PreparedBlock.terms, List.mem_cons, List.mem_map] at ht
      rcases ht with ht | ⟨pair, hpair, ht⟩
      · subst t
        exact classifyNat_scale_lower fp32 x.c.toNat c hc hnz
      · subst t
        obtain ⟨w, _, ha, hb⟩ := prepareProducts_origin _ _ _ hp pair hpair
        have hnza : pair.1.significand ≠ 0 := by
          intro hz; apply hnz; simp [rawMul, hz]
        have hnzb : pair.2.significand ≠ 0 := by
          intro hz; apply hnz; simp [rawMul, hz]
        have hla := classifyNat_scale_lower fp16 w.1.toNat pair.1 ha hnza
        have hlb := classifyNat_scale_lower fp16 w.2.toNat pair.2 hb hnzb
        change -14 ≤ pair.1.rawScale at hla
        change -14 ≤ pair.2.rawScale at hlb
        change -126 ≤ pair.1.rawScale + pair.2.rawScale
        omega

theorem alignmentScale_lower (ts : List RawProduct) (lower e : Int)
    (h : ∀ t ∈ ts, t.significand ≠ 0 → lower ≤ t.rawScale)
    (he : alignmentScale ts = some e) : lower ≤ e := by
  have hex : ∃ t ∈ ts, t.significand ≠ 0 := by
    by_cases hz : ∀ t ∈ ts, t.significand = 0
    · have hn := (alignmentScale_none ts).mpr hz
      rw [he] at hn
      contradiction
    · grind
  obtain ⟨t, ht, hnz⟩ := hex
  obtain ⟨eta, he', hle⟩ := alignmentScale_term ts t ht hnz
  rw [he] at he'
  have heq := Option.some.inj he'
  have hl := h t ht hnz
  omega

/-- Any floor at most -126 is inactive on a prepared canonical invocation.
All-zero is included: the maximum and eta both remain `none`. -/
theorem canonical_eta_floor_inactive (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ -126)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (h : prepare x = some b) : b.eta = alignmentScale b.terms := by
  have hprof : b.profile = fp16Fp32Profile K extra floor := by
    unfold prepare at h
    cases hc : decode32 x.c with
    | none => simp [hc] at h
    | some c =>
      cases hp : prepareProducts (fp16Fp32Profile K extra floor) x.products with
      | none => simp [hc, hp] at h
      | some ps => simp [hc, hp] at h; subst b; rfl
  have hl := prepare_fp16_terms_lower K extra floor x b h
  unfold PreparedBlock.eta
  rw [hprof]
  cases he : alignmentScale b.terms with
  | none => rfl
  | some e =>
    have hemin := alignmentScale_lower b.terms (-126) e hl he
    cases floor with
    | none => rfl
    | some f =>
      have hf' := hf f (by simp)
      change some (max e f) = some e
      congr 1
      omega

end TensorCore
