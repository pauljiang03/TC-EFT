# TensorCore.TC.Padding

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-c6cfd5be70ed4ce2"></a>

<details>
<summary><code>TensorCore.prepare_fp16_term_metadata</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L10)

```lean
/-- Uniform finite FP16-product/FP32-c metadata bounds. They include subnormals. -/
theorem prepare_fp16_term_metadata (K extra : ℕ) (floor : Option ℤ)
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
```

**Supporting proofs:** [TensorCore.classifyNat_metadata](../Core/FormatProperties.md#decl-939dd915424f2515), [TensorCore.prepareProducts_origin](CanonicalFloor.md#decl-11f8a3777df18b50)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8)

</details>

</details>

<a id="decl-0b52caf572f15b9e"></a>

<details>
<summary><code>TensorCore.prepare_fp16_products_metadata</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L48)

```lean
/-- FP16 products have much narrower scale/grid support than FP32 c. -/
theorem prepare_fp16_products_metadata (K extra : ℕ) (floor : Option ℤ)
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
```

**Supporting proofs:** [TensorCore.classifyNat_metadata](../Core/FormatProperties.md#decl-939dd915424f2515), [TensorCore.prepareProducts_origin](CanonicalFloor.md#decl-11f8a3777df18b50)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8)

</details>

</details>

<a id="decl-9c7b63268cdf83a8"></a>

<details>
<summary><code>TensorCore.canonical_source_padding_exact</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L80)

```lean
/-- A sharper sufficient threshold for floors at most 30, including all source
canonical profiles. FP16 products and FP32 c need different scale bounds. -/
theorem canonical_source_padding_exact (K extra : ℕ) (floor : Option ℤ)
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
  have hq : b.quantumExponent = eta - (23 + extra : ℕ) := by
    simp [PreparedBlock.quantumExponent, he, hprof, fp16Fp32Profile]
  rw [hq]
  simp only [PreparedBlock.terms, List.mem_cons] at ht
  rcases ht with ht | ht
  · subst t
    have hc := classifyNat_metadata fp32 (by decide) x.c.toNat b.c (prepare_c hp) hnz
    change b.c.fractionalBits = 23 ∧ -126 ≤ b.c.rawScale ∧ b.c.rawScale ≤ 127 at hc
    change eta - (23 + extra : ℕ) ≤ b.c.rawScale - b.c.fractionalBits
    omega
  · have hpt := (hpm t ht hnz).1
    omega
```

**Supporting proofs:** [TensorCore.classifyNat_metadata](../Core/FormatProperties.md#decl-939dd915424f2515), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.eta_upper](AlignmentScale.md#decl-e33a1ecf006bdb03), [TensorCore.prepare_c](StageResiduals.md#decl-49dbce3f95e00cef), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.AlignmentExact](ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9)

</details>

</details>

<a id="decl-134b78c51d70ac7b"></a>

<details>
<summary><code>TensorCore.canonical_source_padding_accumulator</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L120)

```lean
theorem canonical_source_padding_accumulator (K extra : ℕ) (floor : Option ℤ)
    (hf : ∀ f ∈ floor, f ≤ 30) (hextra : 156 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (hp : prepare x = some b) : b.accumulator = b.exactDot :=
  exact_alignment_accumulator b (canonical_source_padding_exact K extra floor hf hextra x b hp)
```

**Supporting proofs:** [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2)

</details>

</details>

<a id="decl-5bdc8050550eb3f9"></a>

<details>
<summary><code>TensorCore.canonical_source_padding_output</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L126)

```lean
theorem canonical_source_padding_output (K extra : ℕ) (floor : Option ℤ)
    (hf : ∀ f ∈ floor, f ≤ 30) (hextra : 156 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (t : BlockTrace)
    (he : evalBlock x = .ok t) :
    round32 .towardZero t.block.exactDot = some t.output.bits :=
  (evalBlock_exact_alignment he (canonical_source_padding_exact K extra floor hf hextra x
    t.block (evalBlock_prepared he))).2
```

**Supporting proofs:** [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ca6987fa7885e6c2"></a>

<details>
<summary><code>TensorCore.canonical_source_padding_success_iff</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L134)

```lean
theorem canonical_source_padding_success_iff (K extra : ℕ) (floor : Option ℤ)
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
```

**Supporting proofs:** [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-29f3596b590b969d"></a>

<details>
<summary><code>TensorCore.canonical_padding_exact</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L150)

```lean
/-- A conservative uniform padding threshold. It is sufficient, not asserted minimal.
Floors at most 127 include all currently instantiated canonical source paths. -/
theorem canonical_padding_exact (K extra : ℕ) (floor : Option ℤ)
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
```

**Supporting proofs:** [TensorCore.alignmentScale_upper](AlignmentScale.md#decl-4c48f1374c92ea89), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.AlignmentExact](ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9)

</details>

</details>

<a id="decl-f91954987380658d"></a>

<details>
<summary><code>TensorCore.canonical_padding_accumulator</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L177)

```lean
theorem canonical_padding_accumulator (K extra : ℕ) (floor : Option ℤ)
    (hf : ∀ f ∈ floor, f ≤ 127) (hextra : 253 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (b : PreparedBlock)
    (hp : prepare x = some b) : b.accumulator = b.exactDot :=
  exact_alignment_accumulator b (canonical_padding_exact K extra floor hf hextra x b hp)
```

**Supporting proofs:** [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42)

</details>

</details>

<a id="decl-2108e38788477de9"></a>

<details>
<summary><code>TensorCore.canonical_padding_output</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L183)

```lean
theorem canonical_padding_output (K extra : ℕ) (floor : Option ℤ)
    (hf : ∀ f ∈ floor, f ≤ 127) (hextra : 253 ≤ extra)
    (x : BlockInput (fp16Fp32Profile K extra floor)) (t : BlockTrace)
    (he : evalBlock x = .ok t) :
    round32 .towardZero t.block.exactDot = some t.output.bits :=
  (evalBlock_exact_alignment he (canonical_padding_exact K extra floor hf hextra x
    t.block (evalBlock_prepared he))).2
```

**Supporting proofs:** [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2df711842ed5ef42"></a>

<details>
<summary><code>TensorCore.canonical_padding_success_iff</code></summary>

[Lean source](../../../TensorCore/TC/Padding.lean#L192)

```lean
/-- At sufficient padding, acceptance depends on the ideal sum's range directly. -/
theorem canonical_padding_success_iff (K extra : ℕ) (floor : Option ℤ)
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
```

**Supporting proofs:** [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
