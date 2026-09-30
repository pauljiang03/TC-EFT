# TensorCore.TC.AlignmentScale

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e73e45e17ae1b59c"></a>

<details>
<summary><code>TensorCore.maxStep</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L10)

```lean
private def maxStep (acc : Option ℤ) (e : ℤ) : Option ℤ :=
  some (match acc with | none => e | some v => max v e)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.fold_max_member](AlignmentScale.md#decl-1c6eaa01587ccffa), [TensorCore.fold_max_preserves](AlignmentScale.md#decl-3d41421af520bd64), [TensorCore.fold_max_upper](AlignmentScale.md#decl-e8217749aaf0c131)

</details>

</details>

<a id="decl-3d41421af520bd64"></a>

<details>
<summary><code>TensorCore.fold_max_preserves</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L13)

```lean
private theorem fold_max_preserves (es : List ℤ) (e lower : ℤ) (h : lower ≤ e) :
    ∃ eta, es.foldl maxStep (some e) = some eta ∧ lower ≤ eta := by
  induction es generalizing e with
  | nil => exact ⟨e, rfl, h⟩
  | cons x xs ih =>
    apply ih (max e x)
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.maxStep](AlignmentScale.md#decl-e73e45e17ae1b59c)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.fold_max_member](AlignmentScale.md#decl-1c6eaa01587ccffa)

</details>

</details>

<a id="decl-1c6eaa01587ccffa"></a>

<details>
<summary><code>TensorCore.fold_max_member</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L21)

```lean
private theorem fold_max_member (es : List ℤ) (acc : Option ℤ) (e : ℤ)
    (h : e ∈ es) : ∃ eta, es.foldl maxStep acc = some eta ∧ e ≤ eta := by
  induction es generalizing acc with
  | nil => simp at h
  | cons x xs ih =>
    simp only [List.mem_cons] at h
    rcases h with h | h
    · subst x
      cases acc with
      | none => exact fold_max_preserves xs e e (by omega)
      | some v => exact fold_max_preserves xs (max v e) e (by omega)
    · exact ih (maxStep acc x) h
```

**Supporting proofs:** [TensorCore.fold_max_preserves](AlignmentScale.md#decl-3d41421af520bd64)

**Definitions and types:** [TensorCore.maxStep](AlignmentScale.md#decl-e73e45e17ae1b59c)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6)

</details>

</details>

<a id="decl-b69cdabe679ea4e6"></a>

<details>
<summary><code>TensorCore.alignmentScale_term</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L34)

```lean
theorem alignmentScale_term (ts : List RawProduct) (t : RawProduct)
    (hmem : t ∈ ts) (hnz : t.significand ≠ 0) :
    ∃ eta, alignmentScale ts = some eta ∧ t.rawScale ≤ eta := by
  apply fold_max_member
  apply List.mem_filterMap.mpr
  exact ⟨t, hmem, by simp [hnz]⟩
```

**Supporting proofs:** [TensorCore.fold_max_member](AlignmentScale.md#decl-1c6eaa01587ccffa)

**Definitions and types:** [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.alignmentScale_lower](CanonicalFloor.md#decl-e1b8106c4610681f), [TensorCore.alignmentScale_none](AlignmentScale.md#decl-7a39bdbbb3758c27), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032)

</details>

</details>

<a id="decl-7a39bdbbb3758c27"></a>

<details>
<summary><code>TensorCore.alignmentScale_none</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L41)

```lean
theorem alignmentScale_none (ts : List RawProduct) :
    alignmentScale ts = none ↔ ∀ t ∈ ts, t.significand = 0 := by
  constructor
  · intro h t ht
    by_cases hnz : t.significand = 0
    · exact hnz
    · obtain ⟨eta, he, _⟩ := alignmentScale_term ts t ht hnz
      rw [h] at he
      contradiction
  · intro h
    have hf : (ts.filterMap fun t => if t.significand = 0 then none else some t.rawScale) = [] := by
      apply List.filterMap_eq_nil_iff.mpr
      intro t ht
      simp [h t ht]
    simp [alignmentScale, hf]
```

**Supporting proofs:** [TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6)

**Definitions and types:** [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.alignmentScale_lower](CanonicalFloor.md#decl-e1b8106c4610681f)

</details>

</details>

<a id="decl-0312f3eb05a1fc6b"></a>

<details>
<summary><code>TensorCore.eta_term</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L57)

```lean
theorem eta_term (b : PreparedBlock) (t : RawProduct) (ht : t ∈ b.terms)
    (hnz : t.significand ≠ 0) :
    ∃ eta, b.eta = some eta ∧ t.rawScale ≤ eta := by
  obtain ⟨e, he, hle⟩ := alignmentScale_term b.terms t ht hnz
  cases hf : b.profile.alignFloor with
  | none => exact ⟨e, by simp [PreparedBlock.eta, Profile.applyFloor, he, hf], hle⟩
  | some f => exact ⟨max e f, by simp [PreparedBlock.eta, Profile.applyFloor, he, hf], by omega⟩
```

**Supporting proofs:** [TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8)

</details>

</details>

<a id="decl-5d30bccb64b9e9ad"></a>

<details>
<summary><code>TensorCore.aligned_term_coefficient_bound</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L65)

```lean
theorem aligned_term_coefficient_bound (t : RawProduct) (eta : ℤ) (F : ℕ)
    (ht : t.Bounded) (he : t.rawScale ≤ eta) :
    (truncCoeff t.value (eta - F)).natAbs < 2 ^ (F + 2) := by
  have hq := pow2_pos (eta - F)
  have hp := pow2_le_of_le he
  have hs := truncCoeff_abs_le t.value (eta - F)
  have hb : absQ t.value < 4 * pow2 eta := by unfold RawProduct.Bounded at ht; grind
  have heq : ((2 ^ (F + 2) : ℕ) : ℚ) * pow2 (eta - F) = 4 * pow2 eta := by
    rw [← pow2_natCast, ← pow2_add]
    have he' : ((F + 2 : ℕ) : ℤ) + (eta - F) = eta + 2 := by omega
    rw [he', pow2_add]
    have htwo : pow2 2 = 4 := by decide
    rw [htwo, Rat.mul_comm]
  have hb' : absQ t.value / pow2 (eta - F) < ((2 ^ (F + 2) : ℕ) : ℚ) := by
    apply (Rat.div_lt_iff hq).mpr
    rwa [heq]
  apply Rat.natCast_lt_natCast.mp
  grind
```

**Supporting proofs:** [TensorCore.pow2_add](../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_le_of_le](../Numerics/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_natCast](../Numerics/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120), [TensorCore.truncCoeff_abs_le](../Numerics/Truncation.md#decl-fc0fb5f55225cc0e)

**Definitions and types:** [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Numerics/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](../Numerics/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8)

</details>

</details>

<a id="decl-24fca5acfef90681"></a>

<details>
<summary><code>TensorCore.prepareProducts_bounds</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L84)

```lean
theorem prepareProducts_bounds (p : Profile) (ps : List (p.Word × p.Word))
    (qs : List (Decoded × Decoded)) (h : prepareProducts p ps = some qs) :
    qs.length = ps.length ∧ ∀ q ∈ qs, q.1.Bounded ∧ q.2.Bounded := by
  induction ps generalizing qs with
  | nil =>
    simp [prepareProducts] at h
    subst qs
    simp
  | cons pair ps ih =>
    rcases pair with ⟨a, b⟩
    cases ha : p.decode a with
    | none => simp [prepareProducts, List.mapM_cons, ha] at h
    | some da =>
      cases hb : p.decode b with
      | none => simp [prepareProducts, List.mapM_cons, ha, hb] at h
      | some db =>
        cases ht : prepareProducts p ps with
        | none =>
          simp [prepareProducts] at ht
          simp [prepareProducts, List.mapM_cons, ha, hb, ht] at h
        | some ds =>
          have hcons : qs = (da, db) :: ds := by
            have ht' := ht
            simp [prepareProducts] at ht'
            simpa [prepareProducts, List.mapM_cons, ha, hb, ht'] using h.symm
          subst qs
          have hi := ih ds ht
          constructor
          · simpa using hi.1
          · intro q hq
            simp only [List.mem_cons] at hq
            rcases hq with hq | hq
            · subst q
              exact ⟨classifyNat_bounded p.input a.toNat da ha,
                classifyNat_bounded p.input b.toNat db hb⟩
            · exact hi.2 q hq
```

**Supporting proofs:** [TensorCore.classifyNat_bounded](../Numerics/FormatProperties.md#decl-210634dc2026dbec)

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](../Numerics/Defs.md#decl-716025aa0e922bfd), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c)

</details>

</details>

<a id="decl-73a22edb6efb821c"></a>

<details>
<summary><code>TensorCore.prepare_terms_bounded</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L121)

```lean
theorem prepare_terms_bounded {p : Profile} {x : BlockInput p} {b : PreparedBlock}
    (h : prepare x = some b) :
    b.terms.length = x.products.length + 1 ∧ ∀ t ∈ b.terms, t.Bounded := by
  unfold prepare at h
  cases hc : decode32 x.c with
  | none => simp [hc] at h
  | some c =>
    cases hp : prepareProducts p x.products with
    | none => simp [hc, hp] at h
    | some ps =>
      simp [hc, hp] at h
      subst b
      have hps := prepareProducts_bounds p x.products ps hp
      constructor
      · simpa [PreparedBlock.terms] using hps.1
      · intro t ht
        simp only [PreparedBlock.terms, List.mem_cons, List.mem_map] at ht
        rcases ht with ht | ⟨q, hq, ht⟩
        · subst t
          exact c_term_bounded c (classifyNat_bounded fp32 x.c.toNat c hc)
        · subst t
          exact rawMul_bounded q.1 q.2 (hps.2 q hq).1 (hps.2 q hq).2
```

**Supporting proofs:** [TensorCore.c_term_bounded](../Numerics/RawProduct.md#decl-a5b1dc2326008483), [TensorCore.classifyNat_bounded](../Numerics/FormatProperties.md#decl-210634dc2026dbec), [TensorCore.prepareProducts_bounds](AlignmentScale.md#decl-24fca5acfef90681), [TensorCore.rawMul_bounded](../Numerics/RawProduct.md#decl-8b1220a1d4a27018)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](../Numerics/Defs.md#decl-716025aa0e922bfd), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Numerics/RawProduct.md#decl-3e529071d4e652db), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

</details>

</details>

<a id="decl-929725522df30cf8"></a>

<details>
<summary><code>TensorCore.prepared_coefficient_bound</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L144)

```lean
theorem prepared_coefficient_bound (b : PreparedBlock) (F : ℕ)
    (hF : b.profile.alignFraction = F) (ht : ∀ t ∈ b.terms, t.Bounded) :
    ∀ z ∈ b.coefficients, z.natAbs < 2 ^ (F + 2) := by
  intro z hz
  obtain ⟨t, hmem, rfl⟩ := List.mem_map.mp hz
  by_cases hzero : t.significand = 0
  · simp [RawProduct.value, hzero, truncCoeff, Rat.div_def]
    exact Nat.two_pow_pos _
  · obtain ⟨eta, he, hle⟩ := eta_term b t hmem hzero
    have hq : b.quantumExponent = eta - F := by
      simp [PreparedBlock.quantumExponent, he, hF]
    rw [hq]
    exact aligned_term_coefficient_bound t eta F (ht t hmem) hle
```

**Supporting proofs:** [TensorCore.aligned_term_coefficient_bound](AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Numerics/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](../Numerics/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682)

</details>

</details>

<a id="decl-c04538f02bc7d682"></a>

<details>
<summary><code>TensorCore.prepare_coefficient_capacity</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L159)

```lean
/-- Capacity follows from finite decoded inputs and shape, before any output-range check. -/
theorem prepare_coefficient_capacity {p : Profile} {x : BlockInput p} {b : PreparedBlock}
    (hp : prepare x = some b) (hshape : x.products.length = p.products) (F carryBits : ℕ)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits) :
    magnitudeSum b.coefficients < 2 ^ ((F + 2 + carryBits + 1) - 1) := by
  have hb := prepare_terms_bounded hp
  have hprof := prepare_profile hp
  apply coefficient_width_sufficient
  · exact prepared_coefficient_bound b F (by rw [hprof, hF]) hb.2
  · simpa [PreparedBlock.coefficients, hb.1, hshape] using hcount
```

**Supporting proofs:** [TensorCore.coefficient_width_sufficient](../Numerics/Sum.md#decl-50e5b749a17f1c03), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.Bounded](../Numerics/RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.truncCoeff](../Numerics/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b)

</details>

</details>

<a id="decl-7692a0e5a779d42b"></a>

<details>
<summary><code>TensorCore.evalBlock_coefficient_capacity</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L170)

```lean
/-- Width derived from decoded inputs, with c included in the member count. -/
theorem evalBlock_coefficient_capacity {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) (F carryBits : ℕ)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits) :
    magnitudeSum t.block.coefficients < 2 ^ ((F + 2 + carryBits + 1) - 1) := by
  have hshape : x.products.length = p.products := by
    unfold evalBlock at h
    split at h <;> simp_all
  exact prepare_coefficient_capacity (evalBlock_prepared h) hshape F carryBits hF hcount
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733)

</details>

</details>

<a id="decl-33be1c6d56f7d2cd"></a>

<details>
<summary><code>TensorCore.evalBlock_machineAccumulator</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L179)

```lean
theorem evalBlock_machineAccumulator {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) (F carryBits : ℕ)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits) :
    t.block.machineAccumulator (F + 2 + carryBits + 1) = t.block.accumulator :=
  machineAccumulator_eq _ _ (by omega) (evalBlock_coefficient_capacity h F carryBits hF hcount)
```

**Supporting proofs:** [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalV100_machineAccumulator](AlignmentScale.md#decl-0fba10fcc54a6a0b), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

</details>

</details>

<a id="decl-503fa36f9568f733"></a>

<details>
<summary><code>TensorCore.evalBlock_machinePrefix</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L186)

```lean
/-- Every prefix of a successful encoded invocation is safe at the derived width. -/
theorem evalBlock_machinePrefix {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) (F carryBits : ℕ)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits)
    (xs ys : List ℤ) (hsplit : t.block.coefficients = xs ++ ys) :
    (machineAccumulate (F + 2 + carryBits + 1) 0 xs).toInt = sumZ xs := by
  apply machineAccumulate_prefix_exact _ xs ys (by omega)
  rw [← hsplit]
  exact evalBlock_coefficient_capacity h F carryBits hF hcount
```

**Supporting proofs:** [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.machineAccumulate_prefix_exact](AccumulatorWidth.md#decl-9b23fe9fc6ec5adf)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.machineAccumulate](Accumulator.md#decl-5ea736d0760d39b4), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.sumZ](../Numerics/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0fba10fcc54a6a0b"></a>

<details>
<summary><code>TensorCore.evalV100_machineAccumulator</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L197)

```lean
/-- The conservative V100 bound is 29 signed bits: 25 magnitude bits per term,
three carry bits for five terms, and one sign bit. This is not a device register claim. -/
theorem evalV100_machineAccumulator {x : BlockInput v100F16F32} {t : BlockTrace}
    (h : evalV100 x = .ok t) : t.block.machineAccumulator 29 = t.block.accumulator :=
  evalBlock_machineAccumulator h 23 3 rfl (by decide)
```

**Supporting proofs:** [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalV100](Block.md#decl-9844fa72eb15e59b), [TensorCore.v100F16F32](Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e8217749aaf0c131"></a>

<details>
<summary><code>TensorCore.fold_max_upper</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L201)

```lean
private theorem fold_max_upper (es : List ℤ) (acc : Option ℤ) (upper : ℤ)
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
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.maxStep](AlignmentScale.md#decl-e73e45e17ae1b59c)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.alignmentScale_upper](AlignmentScale.md#decl-4c48f1374c92ea89)

</details>

</details>

<a id="decl-4c48f1374c92ea89"></a>

<details>
<summary><code>TensorCore.alignmentScale_upper</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L220)

```lean
theorem alignmentScale_upper (ts : List RawProduct) (upper : ℤ)
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
```

**Supporting proofs:** [TensorCore.fold_max_upper](AlignmentScale.md#decl-e8217749aaf0c131)

**Definitions and types:** [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.eta_upper](AlignmentScale.md#decl-e33a1ecf006bdb03), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032)

</details>

</details>

<a id="decl-e33a1ecf006bdb03"></a>

<details>
<summary><code>TensorCore.eta_upper</code></summary>

[Lean source](../../../TensorCore/TC/AlignmentScale.lean#L233)

```lean
theorem eta_upper (b : PreparedBlock) (upper : ℤ)
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
```

**Supporting proofs:** [TensorCore.alignmentScale_upper](AlignmentScale.md#decl-4c48f1374c92ea89)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8)

</details>

</details>
