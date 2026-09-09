# TensorCore.TC.CanonicalFloor

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3389eb4df62415eb"></a>

<details>
<summary><code>TensorCore.mapM_origin</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFloor.lean#L7)

```lean
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
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepareProducts_origin](CanonicalFloor.md#decl-11f8a3777df18b50)

</details>

</details>

<a id="decl-11f8a3777df18b50"></a>

<details>
<summary><code>TensorCore.prepareProducts_origin</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFloor.lean#L28)

```lean
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
```

**Supporting proofs:** [TensorCore.mapM_origin](CanonicalFloor.md#decl-3389eb4df62415eb)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.idealProducts_abs_le_of_scale](Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f)

</details>

</details>

<a id="decl-25e55191ad23626f"></a>

<details>
<summary><code>TensorCore.prepare_fp16_terms_lower</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFloor.lean#L44)

```lean
theorem prepare_fp16_terms_lower (K extra : ℕ) (floor : Option ℤ)
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
```

**Supporting proofs:** [TensorCore.classifyNat_scale_lower](../Core/FormatProperties.md#decl-f92353957f44c1cf), [TensorCore.prepareProducts_origin](CanonicalFloor.md#decl-11f8a3777df18b50)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714)

</details>

</details>

<a id="decl-e1b8106c4610681f"></a>

<details>
<summary><code>TensorCore.alignmentScale_lower</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFloor.lean#L75)

```lean
theorem alignmentScale_lower (ts : List RawProduct) (lower e : ℤ)
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
```

**Supporting proofs:** [TensorCore.alignmentScale_none](AlignmentScale.md#decl-7a39bdbbb3758c27), [TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6)

**Definitions and types:** [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.l40sFP8_floor_inactive](FP8.md#decl-6a5e1a3ab5a4a57a)

</details>

</details>

<a id="decl-578fd56536970714"></a>

<details>
<summary><code>TensorCore.canonical_eta_floor_inactive</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFloor.lean#L93)

```lean
/-- Any floor at most -126 is inactive on a prepared canonical invocation.
All-zero is included: the maximum and eta both remain `none`. -/
theorem canonical_eta_floor_inactive (K extra : ℕ) (floor : Option ℤ)
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
```

**Supporting proofs:** [TensorCore.alignmentScale_lower](CanonicalFloor.md#decl-e1b8106c4610681f), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
