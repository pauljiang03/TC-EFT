# TensorCore.TC.Specification.Stages

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-04255acd1d57f3f3"></a>

<details>
<summary><code>TensorCore.PaperSpec.layoutOf</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L10)

```lean
@[implicit_reducible] def layoutOf (f : Format) : Layout := ⟨f.fractionBits, f.exponentBits, f.bias⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50)

</details>

</details>

<a id="decl-91b93bf798baf8df"></a>

<details>
<summary><code>TensorCore.PaperSpec.parametersOf</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L11)

```lean
def parametersOf (p : Profile) : Parameters :=
  ⟨layoutOf p.input, p.products, p.alignFraction, p.alignFloor⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.layoutOf](Stages.md#decl-04255acd1d57f3f3), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.group_reversal_detected](../../Tests/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.invocation_eq_paper](Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.runBlocks_eq_paper](Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.schedule_last_eq_paper](Composition.md#decl-551846c5cac8f668), [TensorCore.PaperSpec.supported_parameters](Supported.md#decl-3ff58df4e66fac41), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

</details>

</details>

<a id="decl-d730ee2b6b6f92ab"></a>

<details>
<summary><code>TensorCore.PaperSpec.inputOf</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L13)

```lean
def inputOf {p : Profile} (x : BlockInput p) : Input (parametersOf p) := ⟨x.products, x.c⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.implementation_eq_paper](Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.invocation_eq_paper](Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.runBlocks_eq_paper](Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.tf32_eq_paper](Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

</details>

</details>

<a id="decl-5d5575e19169b785"></a>

<details>
<summary><code>TensorCore.PaperSpec.termOf</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L14)

```lean
def termOf (d : Decoded) : Term := ⟨d.value, d.rawScale⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.product_eq](Stages.md#decl-f6a180380cb5f7be), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50)

</details>

</details>

<a id="decl-13c9fb45465eeb83"></a>

<details>
<summary><code>TensorCore.PaperSpec.rawTermOf</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L15)

```lean
def rawTermOf (t : RawProduct) : Term := ⟨t.value, t.rawScale⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.largestExponent_eq](Stages.md#decl-03502dce6de5b53e), [TensorCore.PaperSpec.product_eq](Stages.md#decl-f6a180380cb5f7be), [TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-16342b2304718371"></a>

<details>
<summary><code>TensorCore.PaperSpec.decode_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L17)

```lean
theorem decode_eq (f : Format) (n : ℕ) :
    decode (layoutOf f) n = ((classifyNat f n).finite).map termOf := by
  unfold decode layoutOf classifyNat
  dsimp only
  by_cases ht : n / 2 ^ f.fractionBits % 2 ^ f.exponentBits = 2 ^ f.exponentBits - 1
  · simp only [ht, ↓reduceIte]
    split <;> rfl
  · simp only [ht, ↓reduceIte]
    by_cases he : n / 2 ^ f.fractionBits % 2 ^ f.exponentBits = 0
    · by_cases hm : n % 2 ^ f.fractionBits = 0
      · simp [he, hm, Classification.finite, termOf, Decoded.value]
      · by_cases hs : n / 2 ^ (f.fractionBits + f.exponentBits) = 0
        all_goals simp only [he, hm, hs, bne_iff_ne, ne_eq, ↓reduceIte, not_false_eq_true, not_true_eq_false,
          and_false,
          Classification.finite, Option.map_some, termOf, Decoded.value,
          Rat.intCast_neg, Rat.intCast_natCast, Rat.intCast_one, Rat.one_mul, Rat.neg_mul, pow2]
    · by_cases hs : n / 2 ^ (f.fractionBits + f.exponentBits) = 0
      all_goals simp only [he, hs, bne_iff_ne, ne_eq, ↓reduceIte, not_false_eq_true, not_true_eq_false,
        false_and,
        Classification.finite, Option.map_some, termOf, Decoded.value,
        Rat.intCast_neg, Rat.intCast_natCast, Rat.intCast_one, Rat.one_mul, Rat.neg_mul, pow2]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../../Numerics/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.Format](../../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.PaperSpec.Layout](Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.layoutOf](Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.termOf](Stages.md#decl-5d5575e19169b785), [TensorCore.classifyNat](../../Numerics/Encoding.md#decl-52d401d7433cac5a), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.value32_eq](Rounding.md#decl-4158336941743c50)

</details>

</details>

<a id="decl-f6a180380cb5f7be"></a>

<details>
<summary><code>TensorCore.PaperSpec.product_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L39)

```lean
theorem product_eq (a b : Decoded) :
    product (termOf a) (termOf b) = rawTermOf (rawMul a b) := by
  change Term.mk (a.value * b.value) (a.rawScale + b.rawScale) =
    Term.mk (rawMul a b).value (rawMul a b).rawScale
  rw [rawProduct_value]
  rfl
```

**Supporting proofs:** [TensorCore.rawProduct_value](../../Numerics/RawProduct.md#decl-f5273efeebd6d86f)

**Definitions and types:** [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.product](Defs.md#decl-1201e49c68444b0b), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.termOf](Stages.md#decl-5d5575e19169b785), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4)

</details>

</details>

<a id="decl-cee1625271ace0f4"></a>

<details>
<summary><code>TensorCore.PaperSpec.decode_products_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L46)

```lean
theorem decode_products_eq (p : Profile) (ps : List (p.Word × p.Word)) :
    (ps.mapM fun (a, b) => do
      return product (← decode (layoutOf p.input) a.toNat)
        (← decode (layoutOf p.input) b.toNat)) =
      (prepareProducts p ps).map (fun ds => ds.map fun (a, b) => rawTermOf (rawMul a b)) := by
  induction ps with
  | nil => rfl
  | cons ab rest ih =>
    rcases ab with ⟨a, b⟩
    simp only [prepareProducts, List.mapM_cons, decode_eq] at *
    cases ha : p.decode a <;> cases hb : p.decode b <;>
      cases hr : prepareProducts p rest <;>
      simp_all [Profile.decode, classify, prepareProducts, product_eq]
```

**Supporting proofs:** [TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.product_eq](Stages.md#decl-f6a180380cb5f7be)

**Definitions and types:** [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.layoutOf](Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.product](Defs.md#decl-1201e49c68444b0b), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.termOf](Stages.md#decl-5d5575e19169b785), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../Defs.md#decl-178599198b2d538e), [TensorCore.classifyNat](../../Numerics/Encoding.md#decl-52d401d7433cac5a), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831)

</details>

</details>

<a id="decl-f5a7848753cbc831"></a>

<details>
<summary><code>TensorCore.PaperSpec.terms_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L60)

```lean
theorem terms_eq {p : Profile} (x : BlockInput p) :
    terms (parametersOf p) (inputOf x) =
      (prepare x).map (fun b => b.terms.map rawTermOf) := by
  unfold terms inputOf parametersOf
  change (do
    let c ← decode (layoutOf fp32) x.c.toNat
    let ps ← x.products.mapM fun (pair : p.Word × p.Word) => do
      return product (← decode (layoutOf p.input) pair.1.toNat)
        (← decode (layoutOf p.input) pair.2.toNat)
    return c :: ps) = _
  rw [decode_eq, decode_products_eq]
  change (do
    let c ← (decode32 x.c).map termOf
    let ps ← (prepareProducts p x.products).map
      (fun (ds : List (Decoded × Decoded)) => ds.map fun (a, b) => rawTermOf (rawMul a b))
    return c :: ps) = _
  unfold prepare
  cases decode32 x.c <;> cases prepareProducts p x.products <;>
    simp [PreparedBlock.terms, List.map_map, termOf, rawTermOf, RawProduct.value, Decoded.value]
```

**Supporting proofs:** [TensorCore.PaperSpec.decode_eq](Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.decode_products_eq](Stages.md#decl-cee1625271ace0f4)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.binary32](Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.decode](Defs.md#decl-1951e6871669c329), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.layoutOf](Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.product](Defs.md#decl-1201e49c68444b0b), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.termOf](Stages.md#decl-5d5575e19169b785), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](../Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.classifyNat](../../Numerics/Encoding.md#decl-52d401d7433cac5a), [TensorCore.decode32](../../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](../../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](../Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-1b686554b9d985d5"></a>

<details>
<summary><code>TensorCore.PaperSpec.raw_value_zero</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L80)

```lean
theorem raw_value_zero (t : RawProduct) : t.value = 0 ↔ t.significand = 0 := by
  unfold RawProduct.value
  have hp := pow2_pos (t.rawScale - t.fractionalBits)
  constructor
  · intro h
    have hcast : (t.significand : ℚ) = 0 := by grind
    exact Rat.intCast_inj.mp (by simpa using hcast)
  · intro h; simp [h]
```

**Supporting proofs:** [TensorCore.pow2_pos](../../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.largestExponent_eq](Stages.md#decl-03502dce6de5b53e)

</details>

</details>

<a id="decl-0d41e118e10ff7b0"></a>

<details>
<summary><code>TensorCore.PaperSpec.join_assoc</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L89)

```lean
private theorem join_assoc (a b c : Option ℤ) :
    joinExponent (joinExponent a b) c = joinExponent a (joinExponent b c) := by
  cases a <;> cases b <;> cases c <;> simp [joinExponent] <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.joinExponent](Defs.md#decl-9285371dfe76f831)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.fold_max](Stages.md#decl-db683c920e12967c)

</details>

</details>

<a id="decl-69d207c2cc7f5d46"></a>

<details>
<summary><code>TensorCore.PaperSpec.join_none</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L93)

```lean
private theorem join_none (a : Option ℤ) : joinExponent a none = a := by
  cases a <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.joinExponent](Defs.md#decl-9285371dfe76f831)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.fold_max](Stages.md#decl-db683c920e12967c)

</details>

</details>

<a id="decl-db683c920e12967c"></a>

<details>
<summary><code>TensorCore.PaperSpec.fold_max</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L96)

```lean
private theorem fold_max (es : List ℤ) (acc : Option ℤ) :
    es.foldl (fun a e => some (match a with | none => e | some v => max v e)) acc =
      joinExponent acc (es.foldr (fun e a => joinExponent (some e) a) none) := by
  induction es generalizing acc with
  | nil => exact (join_none acc).symm
  | cons e es ih =>
    simp only [List.foldl_cons, List.foldr_cons]
    rw [ih]
    have he : some (match acc with | none => e | some v => max v e) =
        joinExponent acc (some e) := by cases acc <;> rfl
    rw [he, join_assoc]
```

**Supporting proofs:** [TensorCore.PaperSpec.join_assoc](Stages.md#decl-0d41e118e10ff7b0), [TensorCore.PaperSpec.join_none](Stages.md#decl-69d207c2cc7f5d46)

**Definitions and types:** [TensorCore.PaperSpec.joinExponent](Defs.md#decl-9285371dfe76f831)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.largestExponent_eq](Stages.md#decl-03502dce6de5b53e)

</details>

</details>

<a id="decl-03502dce6de5b53e"></a>

<details>
<summary><code>TensorCore.PaperSpec.largestExponent_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L108)

```lean
theorem largestExponent_eq (ts : List RawProduct) :
    largestExponent (ts.map rawTermOf) = alignmentScale ts := by
  unfold alignmentScale
  have hf := fold_max (ts.filterMap fun t => if t.significand = 0 then none else some t.rawScale) none
  refine Eq.trans ?_ hf.symm
  clear hf
  change largestExponent (ts.map rawTermOf) =
    (ts.filterMap fun t => if t.significand = 0 then none else some t.rawScale).foldr
      (fun e a => joinExponent (some e) a) none
  induction ts with
  | nil => rfl
  | cons t ts ih =>
    by_cases hz : t.significand = 0
    · have hv := (raw_value_zero t).mpr hz
      simpa [largestExponent, rawTermOf, hz, hv] using ih
    · have hv : t.value ≠ 0 := fun h => hz ((raw_value_zero t).mp h)
      simpa [largestExponent, rawTermOf, hz, hv] using congrArg (joinExponent (some t.rawScale)) ih
```

**Supporting proofs:** [TensorCore.PaperSpec.raw_value_zero](Stages.md#decl-1b686554b9d985d5), [TensorCore.PaperSpec.fold_max](Stages.md#decl-db683c920e12967c)

**Definitions and types:** [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.joinExponent](Defs.md#decl-9285371dfe76f831), [TensorCore.PaperSpec.largestExponent](Defs.md#decl-d5edbc4859fa8eba), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.alignmentScale](../Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7)

</details>

</details>

<a id="decl-9cd77a7095185dd7"></a>

<details>
<summary><code>TensorCore.PaperSpec.exponent_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L126)

```lean
theorem exponent_eq (b : PreparedBlock) :
    exponent (parametersOf b.profile) (b.terms.map rawTermOf) = b.eta := by
  unfold exponent PreparedBlock.eta
  rw [largestExponent_eq]
  cases alignmentScale b.terms <;> rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.largestExponent_eq](Stages.md#decl-03502dce6de5b53e)

**Definitions and types:** [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.exponent](Defs.md#decl-509ef1a10e0bf861), [TensorCore.PaperSpec.largestExponent](Defs.md#decl-d5edbc4859fa8eba), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](../Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.terms](../Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile.applyFloor](../Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](../Block.md#decl-2785502e5e4cba7a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200)

</details>

</details>

<a id="decl-2eed3165d7f83748"></a>

<details>
<summary><code>TensorCore.PaperSpec.coefficient_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L132)

```lean
theorem coefficient_eq (v : ℚ) (e : ℤ) :
    coefficient v ((2 : ℚ) ^ e) = truncCoeff v e := by
  unfold coefficient magnitude truncCoeff pow2
  split <;> simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.coefficient](Defs.md#decl-a8a11a789f8fa9da), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](../../Numerics/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200)

</details>

</details>

<a id="decl-4c3add47ac2ab200"></a>

<details>
<summary><code>TensorCore.PaperSpec.accumulated_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L137)

```lean
theorem accumulated_eq (b : PreparedBlock) :
    accumulated (parametersOf b.profile) (b.terms.map rawTermOf) = b.accumulator := by
  unfold accumulated
  rw [exponent_eq]
  change ((b.terms.map rawTermOf).foldr (fun t z =>
      coefficient t.value ((2 : ℚ) ^ b.quantumExponent) + z) 0 : ℤ) *
      (2 : ℚ) ^ b.quantumExponent = _
  unfold PreparedBlock.accumulator PreparedBlock.coefficients
  apply congrArg (fun z : ℤ => (z : ℚ) * pow2 b.quantumExponent)
  induction b.terms with
  | nil => rfl
  | cons t ts ih => simpa [rawTermOf, coefficient_eq, sumZ] using congrArg (truncCoeff t.value b.quantumExponent + ·) ih
```

**Supporting proofs:** [TensorCore.PaperSpec.coefficient_eq](Stages.md#decl-2eed3165d7f83748), [TensorCore.PaperSpec.exponent_eq](Stages.md#decl-9cd77a7095185dd7)

**Definitions and types:** [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.coefficient](Defs.md#decl-a8a11a789f8fa9da), [TensorCore.PaperSpec.exponent](Defs.md#decl-509ef1a10e0bf861), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](../Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](../Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](../Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](../Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../../Numerics/Exact.md#decl-eba77bb372c3b3ff), [TensorCore.truncCoeff](../../Numerics/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_of_eval](Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.valid_iff](Stages.md#decl-82012b713a8f17aa)

</details>

</details>

<a id="decl-82012b713a8f17aa"></a>

<details>
<summary><code>TensorCore.PaperSpec.valid_iff</code></summary>

[Lean source](../../../../TensorCore/TC/Specification/Stages.lean#L150)

```lean
theorem valid_iff {p : Profile} (x : BlockInput p) :
    Valid (parametersOf p) (inputOf x) ↔ ∃ t, evalBlock x = .ok t := by
  rw [evalBlock_success_iff]
  unfold Valid
  change (x.products.length = p.products ∧ _) ↔ _
  rw [terms_eq]
  cases hp : prepare x with
  | none => simp
  | some b =>
    have hprof := prepare_profile hp
    simp only [Option.map_some, Option.some.injEq, exists_eq_left']
    have ha := accumulated_eq b
    rw [hprof] at ha
    rw [ha]
    rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.accumulated_eq](Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.terms_eq](Stages.md#decl-f5a7848753cbc831), [TensorCore.evalBlock_success_iff](../AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.prepare_profile](../StageResiduals.md#decl-b234945333f4196c)

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Input](Defs.md#decl-ed9c358406f498b4), [TensorCore.PaperSpec.Layout.width](Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Parameters](Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.Term](Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.Valid](Defs.md#decl-a2fc50b4e52fc5f1), [TensorCore.PaperSpec.accumulated](Defs.md#decl-255cad7848a74b4e), [TensorCore.PaperSpec.inputOf](Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.magnitude](Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.maxFinite](Defs.md#decl-c44e0d2d27bec6df), [TensorCore.PaperSpec.parametersOf](Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.rawTermOf](Stages.md#decl-13c9fb45465eeb83), [TensorCore.PaperSpec.terms](Defs.md#decl-56cdff4895ab7ed6), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.terms](../Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.maxFinite32](../../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](../Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_iff_eval](Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.valid_success](Equivalence.md#decl-882143aa8462feae)

</details>

</details>
