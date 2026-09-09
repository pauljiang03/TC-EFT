# TensorCore.TC.FP8

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b1dde6489ea0dcce"></a>

<details>
<summary><code>TensorCore.l40sFP8_valid</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L10)

```lean
theorem l40sFP8_valid (f : FP8Format) (reading : FP8Reading) :
    (l40sFP8Invocation f reading).Valid := by cases f <;> cases reading <;> decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b8243d18187847d4"></a>

<details>
<summary><code>TensorCore.fp8Products_append</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L13)

```lean
theorem fp8Products_append (f : FP8Format) (xs ys : List (f.encoding.Word × f.encoding.Word)) :
    fp8Products f (xs ++ ys) = (do return (← fp8Products f xs) + (← fp8Products f ys)) := by
  have hp : prepareFP8Products f (xs ++ ys) =
      (do return (← prepareFP8Products f xs) ++ (← prepareFP8Products f ys)) := by
    simp [prepareFP8Products]
  unfold fp8Products
  rw [hp]
  cases hx : prepareFP8Products f xs <;> cases hy : prepareFP8Products f ys <;>
    simp [List.map_append, sumQ_append]
```

**Supporting proofs:** [TensorCore.sumQ_append](Program/Loops.md#decl-474827c336526185)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.fp8Products](FP8Program.md#decl-5a8d724cdc17e186), [TensorCore.prepareFP8Products](FP8Program.md#decl-8f8d0a2bfbbd03df), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350)

</details>

</details>

<a id="decl-93fd1bf0e5a1115e"></a>

<details>
<summary><code>TensorCore.l40sFP8_partition</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L24)

```lean
/-- The two groups preserve every original pair, its order, and multiplicity. -/
theorem l40sFP8_partition (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word)) :
    ps.take 16 ++ ps.drop 16 = ps := List.take_append_drop 16 ps
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350)

</details>

</details>

<a id="decl-43f0b7c463d8816d"></a>

<details>
<summary><code>TensorCore.fp8_prepared_decoding</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L27)

```lean
theorem fp8_prepared_decoding {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {b : PreparedInvocation (l40sFP8Invocation f reading)}
    (h : prepareInvocation x = some b) :
    decode32 x.c = some b.c ∧ prepareFP8Products f x.products = some b.products := by
  change (do
    let c ← decode32 x.c
    let ps ← prepareFP8Products f x.products
    return (⟨ps, c⟩ : PreparedInvocation (l40sFP8Invocation f reading))) = some b at h
  cases hc : decode32 x.c with
  | none => simp only [hc] at h; contradiction
  | some c =>
    simp only [hc] at h
    cases hp : prepareFP8Products f x.products with
    | none => simp [hp] at h
    | some ps =>
      simp [hp] at h
      subst b
      exact ⟨rfl, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.prepareFP8Products](FP8Program.md#decl-8f8d0a2bfbbd03df), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.fp8_prepared](FP8.md#decl-00c973e643ed24e8), [TensorCore.l40sFP8_floor_inactive](FP8.md#decl-6a5e1a3ab5a4a57a)

</details>

</details>

<a id="decl-00c973e643ed24e8"></a>

<details>
<summary><code>TensorCore.fp8_prepared</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L47)

```lean
theorem fp8_prepared {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {b : PreparedInvocation (l40sFP8Invocation f reading)}
    (h : prepareInvocation x = some b) :
    decode32 x.c = some b.c ∧ fp8Products f x.products = some b.exactProducts := by
  obtain ⟨hc, hp⟩ := fp8_prepared_decoding h
  exact ⟨hc, by simp [fp8Products, hp, PreparedInvocation.exactProducts]⟩
```

**Supporting proofs:** [TensorCore.fp8_prepared_decoding](FP8.md#decl-43f0b7c463d8816d)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.exactProducts](Invocation.md#decl-f08483de5406c0c5), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp8Products](FP8Program.md#decl-5a8d724cdc17e186), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.prepareFP8Products](FP8Program.md#decl-8f8d0a2bfbbd03df), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350)

</details>

</details>

<a id="decl-9c397a6123b7b235"></a>

<details>
<summary><code>TensorCore.fp8_decode_scale_lower</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L56)

```lean
/-- Exhaustive kernel proof over the two finite 8-bit encoding domains. -/
theorem fp8_decode_scale_lower (f : FP8Format) (w : f.encoding.Word) (d : Decoded)
    (h : f.encoding.decode w = some d) : -14 ≤ d.rawScale := by
  have hall : ∀ w : f.encoding.Word,
      (f.encoding.decode w).all (fun d => decide (-14 ≤ d.rawScale)) = true := by
    cases f <;> decide +kernel
  have hw := hall w
  rw [h] at hw
  simpa using hw
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](../Core/Format.md#decl-0e24771a882ef6eb)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.prepareFP8Products_scale_lower](FP8.md#decl-ffabd823616a9c18)

</details>

</details>

<a id="decl-ffabd823616a9c18"></a>

<details>
<summary><code>TensorCore.prepareFP8Products_scale_lower</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L65)

```lean
theorem prepareFP8Products_scale_lower (f : FP8Format)
    (xs : List (f.encoding.Word × f.encoding.Word)) (ds : List (Decoded × Decoded))
    (h : prepareFP8Products f xs = some ds) :
    ∀ pair ∈ ds, -14 ≤ pair.1.rawScale ∧ -14 ≤ pair.2.rawScale := by
  induction xs generalizing ds with
  | nil => simp [prepareFP8Products] at h; subst ds; simp
  | cons w xs ih =>
    cases ha : f.encoding.decode w.1 with
    | none => simp [prepareFP8Products, List.mapM_cons, ha] at h
    | some a =>
      cases hb : f.encoding.decode w.2 with
      | none => simp [prepareFP8Products, List.mapM_cons, ha, hb] at h
      | some b =>
        cases ht : prepareFP8Products f xs with
        | none => simp [prepareFP8Products, List.mapM_cons, ha, hb] at h ht; rw [ht] at h; contradiction
        | some rest =>
          have he : prepareFP8Products f (w :: xs) = some ((a, b) :: rest) := by
            have ht' := ht
            simp [prepareFP8Products] at ht'
            simp [prepareFP8Products, List.mapM_cons, ha, hb, ht']
          rw [he] at h
          cases Option.some.inj h
          intro pair hm
          rcases List.mem_cons.mp hm with rfl | hm
          · exact ⟨fp8_decode_scale_lower f w.1 a ha, fp8_decode_scale_lower f w.2 b hb⟩
          · exact ih rest ht pair hm
```

**Supporting proofs:** [TensorCore.fp8_decode_scale_lower](FP8.md#decl-9c397a6123b7b235)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.prepareFP8Products](FP8Program.md#decl-8f8d0a2bfbbd03df)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.l40sFP8_floor_inactive](FP8.md#decl-6a5e1a3ab5a4a57a)

</details>

</details>

<a id="decl-6a5e1a3ab5a4a57a"></a>

<details>
<summary><code>TensorCore.l40sFP8_floor_inactive</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L94)

```lean
/-- The v0.5 floor -132 is inactive for finite FP8 factors and FP32 c. This justifies
the Table 3 descriptor's absent floor even for zero and subnormal inputs. -/
theorem l40sFP8_floor_inactive {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {b : PreparedInvocation (l40sFP8Invocation f reading)}
    (h : prepareInvocation x = some b) :
    (b.alignedBlock 13 (some (-132)) true).eta = (b.alignedBlock 13 none true).eta := by
  obtain ⟨hc, hp⟩ := fp8_prepared_decoding h
  have hl : ∀ t ∈ (b.alignedBlock 13 none true).terms,
      t.significand ≠ 0 → -126 ≤ t.rawScale := by
    intro t ht hnz
    change t ∈ (⟨b.c.significand, b.c.rawScale, b.c.fractionalBits⟩ ::
      b.products.map fun (a, b) => rawMul a b) at ht
    rcases List.mem_cons.mp ht with rfl | ht
    · exact classifyNat_scale_lower fp32 x.c.toNat b.c hc hnz
    · obtain ⟨pair, hm, rfl⟩ := List.mem_map.mp ht
      obtain ⟨ha, hb⟩ := prepareFP8Products_scale_lower f x.products b.products hp pair hm
      change -126 ≤ pair.1.rawScale + pair.2.rawScale
      omega
  have ht : (b.alignedBlock 13 (some (-132)) true).terms =
      (b.alignedBlock 13 none true).terms := rfl
  unfold PreparedBlock.eta
  rw [ht]
  cases he : alignmentScale (b.alignedBlock 13 none true).terms with
  | none => rfl
  | some e =>
    have hmin := alignmentScale_lower _ (-126) e hl he
    change some (max e (-132)) = some e
    congr 1
    omega
```

**Supporting proofs:** [TensorCore.alignmentScale_lower](CanonicalFloor.md#decl-e1b8106c4610681f), [TensorCore.classifyNat_scale_lower](../Core/FormatProperties.md#decl-f92353957f44c1cf), [TensorCore.fp8_prepared_decoding](FP8.md#decl-43f0b7c463d8816d), [TensorCore.prepareFP8Products_scale_lower](FP8.md#decl-ffabd823616a9c18)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.prepareFP8Products](FP8Program.md#decl-8f8d0a2bfbbd03df), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2554ef9de5987089"></a>

<details>
<summary><code>TensorCore.runL40SFP8_spec</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L123)

```lean
theorem runL40SFP8_spec {f : FP8Format} {reading : FP8Reading}
    {ps : List (f.encoding.Word × f.encoding.Word)} {c : F32} {t : L40SFP8Trace f reading}
    (h : runL40SFP8 f reading ps c = .ok t) :
    ps.length = 32 ∧
    evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.take 16, c⟩ = .ok t.first ∧
    evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.drop 16, t.first.output.bits⟩ =
      .ok t.second := by
  unfold runL40SFP8 at h
  split at h
  · simp at h
  · rename_i hs
    cases h1 : evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.take 16, c⟩ with
    | error e => simp [h1] at h
    | ok first =>
      cases h2 : evalInvocation (p := l40sFP8Invocation f reading)
          ⟨ps.drop 16, first.output.bits⟩ with
      | error e => simp [h1, h2] at h
      | ok second =>
        simp [h1, h2] at h
        subst t
        exact ⟨by simpa using hs, rfl, h2⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.L40SFP8Trace](FP8Program.md#decl-d69c3bd866542897), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.runL40SFP8](FP8Program.md#decl-e991942d01778b03)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runL40SFP8_recovery](FP8.md#decl-dde9ab033428f350)

</details>

</details>

<a id="decl-dde9ab033428f350"></a>

<details>
<summary><code>TensorCore.runL40SFP8_recovery</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L147)

```lean
/-- Exact loss accounting for either reading, across the *encoded* group boundary,
against the independent ideal of all 32 original operand pairs. -/
theorem runL40SFP8_recovery {f : FP8Format} {reading : FP8Reading}
    {ps : List (f.encoding.Word × f.encoding.Word)} {c : F32} {t : L40SFP8Trace f reading}
    (h : runL40SFP8 f reading ps c = .ok t) :
    l40sFP8Ideal f ps c = some (t.second.output.value + t.first.residual + t.second.residual) := by
  obtain ⟨_, h1, h2⟩ := runL40SFP8_spec h
  have hs1 := evalInvocation_spec h1
  have hs2 := evalInvocation_spec h2
  obtain ⟨hc, hp1⟩ := fp8_prepared hs1.2.2.1
  obtain ⟨hb, hp2⟩ := fp8_prepared hs2.2.2.1
  have hb' : t.second.prepared.c = t.first.output.decoded := by
    have hv : decode32 t.first.output.bits = some t.first.output.decoded := t.first.output.valid
    rw [hv] at hb
    exact (Option.some.inj hb).symm
  have hr1 := evalInvocation_recovery h1
  have hr2 := evalInvocation_recovery h2
  simp only [invocationIdeal, hs1.2.2.1, Option.map_some, Option.some.injEq] at hr1
  simp only [invocationIdeal, hs2.2.2.1, Option.map_some, Option.some.injEq] at hr2
  have hp : fp8Products f ps = some (t.first.prepared.exactProducts + t.second.prepared.exactProducts) := by
    rw [← l40sFP8_partition f ps, fp8Products_append, hp1, hp2]
    rfl
  simp only [l40sFP8Ideal, hc, hp]
  change some (t.first.prepared.c.value +
    (t.first.prepared.exactProducts + t.second.prepared.exactProducts)) = _
  unfold PreparedInvocation.exactDot at hr1 hr2
  rw [hb'] at hr2
  change t.first.output.value + _ = _ at hr2
  congr 1
  grind
```

**Supporting proofs:** [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.fp8Products_append](FP8.md#decl-b8243d18187847d4), [TensorCore.fp8_prepared](FP8.md#decl-00c973e643ed24e8), [TensorCore.l40sFP8_partition](FP8.md#decl-93fd1bf0e5a1115e), [TensorCore.runL40SFP8_spec](FP8.md#decl-2554ef9de5987089)

**Definitions and types:** [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.InvocationTrace.residual](Invocation.md#decl-c97ce73fb104bc58), [TensorCore.L40SFP8Trace](FP8Program.md#decl-d69c3bd866542897), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.PreparedInvocation.exactProducts](Invocation.md#decl-f08483de5406c0c5), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp8Products](FP8Program.md#decl-5a8d724cdc17e186), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.l40sFP8Ideal](FP8Program.md#decl-2edcb7111d5346e0), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3), [TensorCore.runL40SFP8](FP8Program.md#decl-e991942d01778b03)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0c85684a50a21181"></a>

<details>
<summary><code>TensorCore.l40sFP8_output_towardZero</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L178)

```lean
/-- Final FP32 conversion is toward zero for both readings. In `source13`, the
intermediate precision reduction is a separate event with its own rounding theorem. -/
theorem l40sFP8_output_towardZero {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {t : InvocationTrace (l40sFP8Invocation f reading)} (h : evalInvocation x = .ok t) :
    TowardZero fp32 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardZero h rfl
```

**Supporting proofs:** [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.TowardZero](../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.l40sFP8_paper_towardZero_accumulation](FP8.md#decl-b1b414c8fa00ce08)

</details>

</details>

<a id="decl-289dcc55b6b1f28b"></a>

<details>
<summary><code>TensorCore.l40sFP8_source13_towardZero</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L184)

```lean
theorem l40sFP8_source13_towardZero {f : FP8Format}
    {x : InvocationInput (l40sFP8Invocation f .source13)}
    {t : InvocationTrace (l40sFP8Invocation f .source13)} (h : evalInvocation x = .ok t) :
    ∀ e ∈ t.intermediate.events, TowardZero e.stage.format e.input e.output.bits := by
  have hr := (evalInvocation_spec h).2.2.2.2.1
  obtain ⟨hs, he⟩ := runConversions_events _ _ _ hr
  intro e hm
  have hm' : e.stage ∈ t.intermediate.events.map ConversionEvent.stage := List.mem_map_of_mem hm
  rw [hs] at hm'
  have heq : e.stage = ⟨fp32With13FractionBits, .towardZero⟩ := by simpa [l40sFP8Invocation] using hm'
  apply conversionStage_towardZero_correct e.stage
  · rw [heq]; decide
  · rw [heq]
  · exact he e hm
```

**Supporting proofs:** [TensorCore.conversionStage_towardZero_correct](Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.runConversions_events](../Core/Conversion.md#decl-ee15bd4271d1b71d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.TowardZero](../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp32With13FractionBits](FP8Defs.md#decl-0d06616c12063adf), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9472354441f51e82"></a>

<details>
<summary><code>TensorCore.l40sFP8_readings_same_accumulation</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L201)

```lean
/-- On the same decoded inputs, the readings have identical accumulation,
including alignment loss. Only their subsequent conversions differ. -/
theorem l40sFP8_readings_same_accumulation (f : FP8Format)
    (ps : List (Decoded × Decoded)) (c : Decoded) :
    accumulateInvocation (p := l40sFP8Invocation f .paper) ⟨ps, c⟩ =
      accumulateInvocation (p := l40sFP8Invocation f .source13) ⟨ps, c⟩ := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b1b414c8fa00ce08"></a>

<details>
<summary><code>TensorCore.l40sFP8_paper_towardZero_accumulation</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L207)

```lean
/-- The direct-FP32 candidate rounds the accumulated value itself. -/
theorem l40sFP8_paper_towardZero_accumulation {f : FP8Format}
    {x : InvocationInput (l40sFP8Invocation f .paper)}
    {t : InvocationTrace (l40sFP8Invocation f .paper)} (h : evalInvocation x = .ok t) :
    TowardZero fp32 t.accumulation.value t.output.bits := by
  have hr := (evalInvocation_spec h).2.2.2.2.1
  have hi : t.intermediate = ⟨[], t.accumulation.value⟩ := by
    simpa [l40sFP8Invocation, runConversions] using hr.symm
  have ho := l40sFP8_output_towardZero h
  simpa [hi] using ho
```

**Supporting proofs:** [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.l40sFP8_output_towardZero](FP8.md#decl-0c85684a50a21181)

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.TowardZero](../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7b2640435fca348a"></a>

<details>
<summary><code>TensorCore.l40sFP8_source13_boundary</code></summary>

[Lean source](../../../TensorCore/TC/FP8.lean#L219)

```lean
/-- Source13 has exactly one reduced-precision event on the accumulated value.
This proves the explicit source model's boundary, not paper/device conformance. -/
theorem l40sFP8_source13_boundary {f : FP8Format}
    {x : InvocationInput (l40sFP8Invocation f .source13)}
    {t : InvocationTrace (l40sFP8Invocation f .source13)} (h : evalInvocation x = .ok t) :
    ∃ d : FiniteBinary fp32With13FractionBits,
      t.intermediate = ⟨[⟨⟨fp32With13FractionBits, .towardZero⟩,
        t.accumulation.value, d⟩], d.value⟩ ∧
      TowardZero fp32With13FractionBits t.accumulation.value d.bits := by
  have hr := (evalInvocation_spec h).2.2.2.2.1
  let s : ConversionStage := ⟨fp32With13FractionBits, .towardZero⟩
  change runConversions [s] t.accumulation.value = some t.intermediate at hr
  cases hd : s.convert t.accumulation.value with
  | none => simp [runConversions, hd] at hr
  | some d =>
    refine ⟨d, ?_, conversionStage_towardZero_correct s (by decide) rfl _ _ hd⟩
    simpa [runConversions, hd] using hr.symm
```

**Supporting proofs:** [TensorCore.conversionStage_towardZero_correct](Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FP8Format](FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.TowardZero](../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.fp32With13FractionBits](FP8Defs.md#decl-0d06616c12063adf), [TensorCore.l40sFP8Invocation](FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
