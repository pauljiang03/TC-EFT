import TensorCore.Theory.CanonicalFloor
import TensorCore.Theory.ExactAlignment
import TensorCore.Theory.AcceptedDomain

namespace TensorCore

/-- Uniform finite FP16-product/FP32-c metadata bounds. They include subnormals. -/
theorem prepare_fp16_term_metadata (K extra : Nat) (floor : Option Int)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (h : prepare x = some b) :
    ∀ t ∈ b.terms, t.significand ≠ 0 →
      -149 ≤ t.rawScale - t.fractionalBits ∧ t.rawScale ≤ 127 := by
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
        have hm := classifyNat_metadata fp32 (by decide) x.c.toNat c hc hnz
        change c.fractionalBits = 23 ∧ -126 ≤ c.rawScale ∧ c.rawScale ≤ 127 at hm
        change -149 ≤ c.rawScale - c.fractionalBits ∧ c.rawScale ≤ 127
        omega
      · subst t
        obtain ⟨w, _, ha, hb⟩ := prepareProducts_origin _ _ _ hp pair hpair
        have hnza : pair.1.significand ≠ 0 := by
          intro hz; apply hnz; simp [rawMul, hz]
        have hnzb : pair.2.significand ≠ 0 := by
          intro hz; apply hnz; simp [rawMul, hz]
        have hma := classifyNat_metadata fp16 (by decide) w.1.toNat pair.1 ha hnza
        have hmb := classifyNat_metadata fp16 (by decide) w.2.toNat pair.2 hb hnzb
        change pair.1.fractionalBits = 10 ∧ -14 ≤ pair.1.rawScale ∧ pair.1.rawScale ≤ 15 at hma
        change pair.2.fractionalBits = 10 ∧ -14 ≤ pair.2.rawScale ∧ pair.2.rawScale ≤ 15 at hmb
        change -149 ≤ (pair.1.rawScale + pair.2.rawScale) -
          (pair.1.fractionalBits + pair.2.fractionalBits) ∧
          pair.1.rawScale + pair.2.rawScale ≤ 127
        omega

private theorem fold_max_upper (es : List Int) (acc : Option Int) (upper : Int)
    (ha : ∀ e ∈ acc, e ≤ upper) (hs : ∀ e ∈ es, e ≤ upper) :
    ∀ e ∈ es.foldl (fun acc x => some (match acc with
      | none => x | some a => max a x)) acc, e ≤ upper := by
  induction es generalizing acc with
  | nil => exact ha
  | cons x xs ih =>
    apply ih
    · intro e he
      have hx := hs x (by simp)
      cases acc with
      | none => simp at he; omega
      | some a =>
        have hb := ha a (by simp)
        simp at he
        omega
    · intro e he
      exact hs e (by simp [he])

theorem alignmentScale_upper (ts : List RawProduct) (upper : Int)
    (h : ∀ t ∈ ts, t.significand ≠ 0 → t.rawScale ≤ upper) :
    ∀ e ∈ alignmentScale ts, e ≤ upper := by
  apply fold_max_upper
  · simp
  · intro e he
    obtain ⟨t, ht, he⟩ := List.mem_filterMap.mp he
    by_cases hz : t.significand = 0
    · simp [hz] at he
    · simp [hz] at he
      subst e
      exact h t ht hz

theorem eta_upper (b : PreparedBlock) (upper : Int)
    (hf : ∀ f ∈ b.profile.alignFloor, f ≤ upper)
    (ht : ∀ t ∈ b.terms, t.significand ≠ 0 → t.rawScale ≤ upper) :
    ∀ e ∈ b.eta, e ≤ upper := by
  have hu := alignmentScale_upper b.terms upper ht
  intro eta he
  unfold PreparedBlock.eta Profile.applyFloor at he
  cases hs : alignmentScale b.terms with
  | none => simp [hs] at he
  | some e =>
    have hemax := hu e (by simp [hs])
    cases hfloor : b.profile.alignFloor with
    | none => simp [hs, hfloor] at he; omega
    | some f =>
      have hf' := hf f (by simp [hfloor])
      simp [hs, hfloor] at he
      omega

/-- FP16 products have much narrower scale/grid support than FP32 c. -/
theorem prepare_fp16_products_metadata (K extra : Nat) (floor : Option Int)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (h : prepare x = some b) :
    ∀ t ∈ b.products.map (fun (a, b) => rawMul a b), t.significand ≠ 0 →
      -48 ≤ t.rawScale - t.fractionalBits ∧ t.rawScale ≤ 30 := by
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
      obtain ⟨pair, hpair, rfl⟩ := List.mem_map.mp ht
      obtain ⟨w, _, ha, hb⟩ := prepareProducts_origin _ _ _ hp pair hpair
      have hnza : pair.1.significand ≠ 0 := by
        intro hz; apply hnz; simp [rawMul, hz]
      have hnzb : pair.2.significand ≠ 0 := by
        intro hz; apply hnz; simp [rawMul, hz]
      have hma := classifyNat_metadata fp16 (by decide) w.1.toNat pair.1 ha hnza
      have hmb := classifyNat_metadata fp16 (by decide) w.2.toNat pair.2 hb hnzb
      change pair.1.fractionalBits = 10 ∧ -14 ≤ pair.1.rawScale ∧ pair.1.rawScale ≤ 15 at hma
      change pair.2.fractionalBits = 10 ∧ -14 ≤ pair.2.rawScale ∧ pair.2.rawScale ≤ 15 at hmb
      change -48 ≤ (pair.1.rawScale + pair.2.rawScale) -
        (pair.1.fractionalBits + pair.2.fractionalBits) ∧
        pair.1.rawScale + pair.2.rawScale ≤ 30
      omega

/-- A sharper sufficient threshold for floors at most 30, including all source
canonical profiles. FP16 products and FP32 c need different scale bounds. -/
theorem canonical_source_padding_exact (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 30) (hextra : 156 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (hp : prepare x = some b) : b.AlignmentExact := by
  have hprof := prepare_profile hp
  have hm := prepare_fp16_term_metadata K extra floor x b hp
  have hpm := prepare_fp16_products_metadata K extra floor x b hp
  have hu := eta_upper b 127 (by
    intro f hmem
    have hf' := hf f (by simpa [hprof, fp16Fp32Profile] using hmem)
    omega) (by intro t ht hnz; exact (hm t ht hnz).2)
  have huc := eta_upper b (max b.c.rawScale 30) (by
    intro f hmem
    have hf' := hf f (by simpa [hprof, fp16Fp32Profile] using hmem)
    omega) (by
      intro t ht hnz
      simp only [PreparedBlock.terms, List.mem_cons] at ht
      rcases ht with ht | ht
      · subst t
        change b.c.rawScale ≤ max b.c.rawScale 30
        omega
      · have hpt := (hpm t ht hnz).2
        omega)
  intro t ht hnz
  obtain ⟨eta, he, _⟩ := eta_term b t ht hnz
  have hemax := hu eta (by simp [he])
  have hec := huc eta (by simp [he])
  have hq : b.quantumExponent = eta - (23 + extra : Nat) := by
    simp [PreparedBlock.quantumExponent, he, hprof, fp16Fp32Profile]
  rw [hq]
  simp only [PreparedBlock.terms, List.mem_cons] at ht
  rcases ht with ht | ht
  · subst t
    have hc := classifyNat_metadata fp32 (by decide) x.c.toNat b.c (prepare_c hp) hnz
    change b.c.fractionalBits = 23 ∧ -126 ≤ b.c.rawScale ∧ b.c.rawScale ≤ 127 at hc
    change eta - (23 + extra : Nat) ≤ b.c.rawScale - b.c.fractionalBits
    omega
  · have hpt := (hpm t ht hnz).1
    omega

theorem canonical_source_padding_accumulator (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 30) (hextra : 156 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (hp : prepare x = some b) : b.accumulator = b.exactDot :=
  exact_alignment_accumulator b (canonical_source_padding_exact K extra floor hf hextra x b hp)

theorem canonical_source_padding_output (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 30) (hextra : 156 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (t : BlockTrace)
    (he : evalBlock x = .ok t) :
    round32 .towardZero t.block.exactDot = some t.output.bits :=
  (evalBlock_exact_alignment he (canonical_source_padding_exact K extra floor hf hextra x
    t.block (evalBlock_prepared he))).2

theorem canonical_source_padding_success_iff (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 30) (hextra : 156 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) :
    (∃ t, evalBlock x = .ok t) ↔ x.products.length = K ∧
      ∃ b, prepare x = some b ∧ absQ b.exactDot ≤ maxFinite32 := by
  rw [evalBlock_success_iff]
  constructor
  · rintro ⟨hs, b, hp, hr⟩
    rw [canonical_source_padding_accumulator K extra floor hf hextra x b hp] at hr
    exact ⟨hs, b, hp, hr⟩
  · rintro ⟨hs, b, hp, hr⟩
    refine ⟨hs, b, hp, ?_⟩
    rwa [canonical_source_padding_accumulator K extra floor hf hextra x b hp]

/-- A conservative uniform padding threshold. It is sufficient, not asserted minimal.
Floors at most 127 include all currently instantiated canonical source paths. -/
theorem canonical_padding_exact (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 127) (hextra : 253 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (hp : prepare x = some b) : b.AlignmentExact := by
  have hm := prepare_fp16_term_metadata K extra floor x b hp
  have hu := alignmentScale_upper b.terms 127 (by intro t ht hnz; exact (hm t ht hnz).2)
  have hprof := prepare_profile hp
  intro t ht hnz
  obtain ⟨eta, he, _⟩ := eta_term b t ht hnz
  have heta : eta ≤ 127 := by
    have he' := he
    simp only [PreparedBlock.eta, hprof, fp16Fp32Profile] at he'
    cases hs : alignmentScale b.terms with
    | none => simp [Profile.applyFloor, hs] at he'
    | some e =>
      have hemax := hu e (by simp [hs])
      cases floor with
      | none => simp [Profile.applyFloor, hs] at he'; omega
      | some f =>
        have hf' := hf f (by simp)
        simp [Profile.applyFloor, hs] at he'
        omega
  have htmin := (hm t ht hnz).1
  simp only [PreparedBlock.quantumExponent, he, Option.getD_some,
    hprof, fp16Fp32Profile]
  omega

theorem canonical_padding_accumulator (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 127) (hextra : 253 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (hp : prepare x = some b) : b.accumulator = b.exactDot :=
  exact_alignment_accumulator b (canonical_padding_exact K extra floor hf hextra x b hp)

theorem canonical_padding_output (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 127) (hextra : 253 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (t : BlockTrace)
    (he : evalBlock x = .ok t) :
    round32 .towardZero t.block.exactDot = some t.output.bits :=
  (evalBlock_exact_alignment he (canonical_padding_exact K extra floor hf hextra x
    t.block (evalBlock_prepared he))).2

/-- At sufficient padding, acceptance depends on the ideal sum's range directly. -/
theorem canonical_padding_success_iff (K extra : Nat) (floor : Option Int)
    (hf : ∀ f ∈ floor, f ≤ 127) (hextra : 253 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) :
    (∃ t, evalBlock x = .ok t) ↔ x.products.length = K ∧
      ∃ b, prepare x = some b ∧ absQ b.exactDot ≤ maxFinite32 := by
  rw [evalBlock_success_iff]
  constructor
  · rintro ⟨hs, b, hp, hr⟩
    rw [canonical_padding_accumulator K extra floor hf hextra x b hp] at hr
    exact ⟨hs, b, hp, hr⟩
  · rintro ⟨hs, b, hp, hr⟩
    refine ⟨hs, b, hp, ?_⟩
    rwa [canonical_padding_accumulator K extra floor hf hextra x b hp]

end TensorCore
