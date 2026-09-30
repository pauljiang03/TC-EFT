# TensorCore.Kernels.EFT.Preparation

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2cf39080c6dc39f5"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeFactor_profile</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L12)

```lean
theorem decodeFactor_profile (path : Path) (word : path.profile.Word) :
    (decodeFactor path.kind (word.zeroExtend 32)).map Factor.decoded = path.profile.decode word := by
  rw [decodeFactor_asDecoded]
  cases path <;> rw [BitVec.toNat_setWidth_of_le (by decide)] <;> rfl
```

**Supporting proofs:** [TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a)

**Definitions and types:** [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Factor.decoded](Decode.md#decl-ecc0485e43e051ac), [TensorCore.EFMachine.InputKind.format](DecodeDefs.md#decl-d36240df515f4d1e), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.kind](DecodeDefs.md#decl-7f4877f7cab1b675), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.classifyNat](../../Numerics/Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4)

</details>

</details>

<a id="decl-72fa6f01d649afc4"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeProduct_value</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L17)

```lean
theorem decodeProduct_value (path : Path) (pair : path.profile.Word × path.profile.Word) :
    (decodeProduct path pair).map (fun t => t.word.value) =
      (do let a ← path.profile.decode pair.1
          let b ← path.profile.decode pair.2
          pure (a.value * b.value) : Option ℚ) := by
  rw [← decodeFactor_profile, ← decodeFactor_profile]
  cases ha : decodeFactor path.kind (pair.1.zeroExtend 32) with
  | none => simp [decodeProduct, ha]
  | some a =>
    cases hb : decodeFactor path.kind (pair.2.zeroExtend 32) with
    | none => simp [decodeProduct, ha, hb]
    | some b =>
      simp only [decodeProduct, ha, hb, Option.map_some, pure]
      exact congrArg some ((product_value (decodeFactor_bounds ha)
        (decodeFactor_bounds hb)).trans (rawProduct_value _ _))
```

**Supporting proofs:** [TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.rawProduct_value](../../Numerics/RawProduct.md#decl-f5273efeebd6d86f)

**Definitions and types:** [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Factor.decoded](Decode.md#decl-ecc0485e43e051ac), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.kind](DecodeDefs.md#decl-7f4877f7cab1b675), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4)

</details>

</details>

<a id="decl-257008ca3f331f86"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeProduct_magnitude</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L33)

```lean
theorem decodeProduct_magnitude {path : Path} {pair : path.profile.Word × path.profile.Word}
    {t : Term} (h : decodeProduct path pair = some t) : t.word.magnitude.toNat < 2 ^ 550 := by
  cases ha : decodeFactor path.kind (pair.1.zeroExtend 32) with
  | none => simp [decodeProduct, ha] at h
  | some a =>
    cases hb : decodeFactor path.kind (pair.2.zeroExtend 32) with
    | none => simp [decodeProduct, ha, hb] at h
    | some b =>
      simp [decodeProduct, ha, hb] at h
      rw [← h]
      exact product_magnitude (decodeFactor_bounds ha) (decodeFactor_bounds hb)
```

**Supporting proofs:** [TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8)

**Definitions and types:** [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.kind](DecodeDefs.md#decl-7f4877f7cab1b675), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-2d14a8f344337eaf"></a>

<details>
<summary><code>TensorCore.EFMachine.mapM_project_eq</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L45)

```lean
theorem mapM_project_eq {f : α → Option β} {g : α → Option γ} {v : β → δ} {w : γ → δ}
    (h : ∀ x, (f x).map v = (g x).map w) (xs : List α) :
    (xs.mapM f).map (List.map v) = (xs.mapM g).map (List.map w) := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    have hh := h x
    cases hf : f x <;> cases hg : g x <;>
      cases hfs : xs.mapM f <;> cases hgs : xs.mapM g <;>
      simp_all [List.mapM_cons]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4)

</details>

</details>

<a id="decl-527b64204fe2294d"></a>

<details>
<summary><code>TensorCore.EFMachine.mapM_bounds</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L56)

```lean
theorem mapM_bounds {f : α → Option β} {P : β → Prop}
    (hf : ∀ x y, f x = some y → P y) {xs : List α} {ys : List β}
    (h : xs.mapM f = some ys) : ys.length = xs.length ∧ ∀ y ∈ ys, P y := by
  induction xs generalizing ys with
  | nil => simp at h; subst ys; simp
  | cons x xs ih =>
    cases hh : f x with
    | none => simp [List.mapM_cons, hh] at h
    | some y =>
      cases ht : xs.mapM f with
      | none => simp [List.mapM_cons, hh, ht] at h
      | some zs =>
        simp [List.mapM_cons, hh, ht] at h
        subst ys
        obtain ⟨hlen, hP⟩ := ih ht
        refine ⟨by simp [hlen], ?_⟩
        intro z hz
        rcases List.mem_cons.mp hz with rfl | hz
        · exact hf x z hh
        · exact hP z hz
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-db0d4ea753e99da4"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeProducts_values</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L77)

```lean
theorem decodeProducts_values (path : Path) (ps : List (path.profile.Word × path.profile.Word)) :
    (ps.mapM (decodeProduct path)).map (fun ts => ts.map fun t => t.word.value) =
      (TensorCore.prepareProducts path.profile ps).map
        (fun ds => ds.map fun (a, b) => a.value * b.value) := by
  apply mapM_project_eq
  intro pair
  rw [decodeProduct_value]
  rcases pair with ⟨a, b⟩
  dsimp only
  cases path.profile.decode a <;> cases path.profile.decode b <;> rfl
```

**Supporting proofs:** [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.mapM_project_eq](Preparation.md#decl-2d14a8f344337eaf)

**Definitions and types:** [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.prepareProducts](../../TC/Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-be7f298d110d502f"></a>

<details>
<summary><code>TensorCore.EFMachine.Prepared.ideal</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L88)

```lean
def Prepared.ideal (p : Prepared) : ℚ := sumQ (p.terms.map fun t => t.word.value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.sumQ](../../Numerics/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-41c187a873ee477f"></a>

<details>
<summary><code>TensorCore.EFMachine.prepare_spec</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L90)

```lean
theorem prepare_spec {path : Path} {x : BlockInput path.profile} {D : F32} {p : Prepared}
    (h : prepare path x D = .ok p) :
    x.products.length = path.profile.products ∧
      TensorCore.exactDot x = some p.ideal ∧
      TensorCore.value32 D = some p.output.value ∧
      p.terms.length = path.profile.products + 1 ∧
      (∀ t ∈ p.terms, t.word.magnitude.toNat < 2 ^ 550) ∧
      p.output.magnitude.toNat < 2 ^ 424 := by
  unfold prepare at h
  dsimp only at h
  split at h
  · contradiction
  · rename_i hlen
    have hlen' : x.products.length = path.profile.products := by simpa using hlen
    cases hc : decode32Term x.c with
    | none => simp [hc] at h
    | some c =>
      cases hps : x.products.mapM (decodeProduct path) with
      | none => simp [hc, hps] at h
      | some ps =>
        cases hd : decode32Word D with
        | none => simp [hc, hps, hd] at h
        | some d =>
          simp [hc, hps, hd, pure, Except.pure] at h
          subst p
          have hdc : decode32Word x.c = some c.word := by simp [decode32Word, hc]
          have hvc : TensorCore.value32 x.c = some c.word.value := by
            rw [← decode32Word_value, hdc]; rfl
          have hvd : TensorCore.value32 D = some d.value := by
            rw [← decode32Word_value, hd]; rfl
          have hvs := decodeProducts_values path x.products
          rw [hps] at hvs
          cases hp : TensorCore.prepareProducts path.profile x.products with
          | none => simp [hp] at hvs
          | some ds =>
            simp only [hp, Option.map_some, Option.some.injEq] at hvs
            have hb := mapM_bounds (fun a b h => decodeProduct_magnitude h) hps
            have hmb := decode32Word_magnitude hdc
            refine ⟨hlen', ?_, hvd, by simp [← hlen', hb.1], ?_, decode32Word_magnitude hd⟩
            · cases hcc : decode32 x.c with
              | none => simp [TensorCore.value32, hcc] at hvc
              | some dc =>
                simp only [TensorCore.value32, hcc, Option.map_some, Option.some.injEq] at hvc
                simp only [TensorCore.exactDot, TensorCore.prepare, hcc, hp, Option.map_some,
                  PreparedBlock.exactDot, PreparedBlock.exactProducts, Prepared.ideal,
                  List.map_cons, sumQ]
                rw [hvc, ← hvs]
            · intro t ht
              rcases List.mem_cons.mp ht with rfl | ht
              · omega
              · exact hb.2 t ht
```

**Supporting proofs:** [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4), [TensorCore.EFMachine.mapM_bounds](Preparation.md#decl-527b64204fe2294d)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.decodeProduct](DecodeDefs.md#decl-393a0d8562dca5f4), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.selectedGrid](Defs.md#decl-026f0e297cb0d39a), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.decode32](../../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.prepare](../../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](../../TC/Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604)

</details>

</details>

<a id="decl-5c86c03a8739e02a"></a>

<details>
<summary><code>TensorCore.EFMachine.path_count</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L142)

```lean
theorem path_count (path : Path) : path.profile.products ≤ 16 := by cases path <;> decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604)

</details>

</details>

<a id="decl-57c6f2c3bcad2604"></a>

<details>
<summary><code>TensorCore.EFMachine.prepare_capacity</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Preparation.lean#L144)

```lean
theorem prepare_capacity {path : Path} {x : BlockInput path.profile} {D : F32} {p : Prepared}
    (h : prepare path x D = .ok p) :
    wordBudget (p.terms.map Term.word) < 2 ^ 555 ∧ p.output.magnitude.toNat < 2 ^ 424 := by
  obtain ⟨_, _, _, hlen, ht, hd⟩ := prepare_spec h
  have hc := path_count path
  have hb : wordBudget (p.terms.map Term.word) ≤ p.terms.length * (2 ^ 550 - 1) := by
    suffices ∀ ts : List Term, (∀ t ∈ ts, t.word.magnitude.toNat < 2 ^ 550) →
        wordBudget (ts.map Term.word) ≤ ts.length * (2 ^ 550 - 1) from this p.terms ht
    intro ts ht
    induction ts with
    | nil => simp [wordBudget]
    | cons t ts ih =>
      have hm := ht t (by simp)
      have hh := ih (by intro u hu; exact ht u (by simp [hu]))
      simp only [List.map_cons, wordBudget, List.sum_cons, List.length_cons]
      simp only [wordBudget, List.map_map] at hh
      simp only [List.map_map]
      omega
  exact ⟨by omega, hd⟩
```

**Supporting proofs:** [TensorCore.EFMachine.path_count](Preparation.md#decl-5c86c03a8739e02a), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.wordBudget](Word.md#decl-0632d0aa311c3d92), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94)

</details>

</details>
