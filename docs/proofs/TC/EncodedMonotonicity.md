# TensorCore.TC.EncodedMonotonicity

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-8001d30e1d0c2ed8"></a>

<details>
<summary><code>TensorCore.encodedBlockValue</code></summary>

[Lean source](../../../TensorCore/TC/EncodedMonotonicity.lean#L9)

```lean
/-- `val(TC_θ(a,b,c))`, with finite-domain rejection preserved. -/
def encodedBlockValue {p : Profile} (products : List (p.Word × p.Word)) (c : F32) :
    Except ModelError ℚ :=
  (evalBlock (⟨products, c⟩ : BlockInput p)).map fun t => t.output.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58)

<details>
<summary>Used by</summary>

[TensorCore.MonotoneInEncodedAccumulator](EncodedMonotonicity.md#decl-2fe557d3c0f04019), [TensorCore.Regression.encoded_v100_not_monotone](../Tests/EFT/EncodedEFT.md#decl-83fcbe1b52439ce7), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998)

</details>

</details>

<a id="decl-2fe557d3c0f04019"></a>

<details>
<summary><code>TensorCore.MonotoneInEncodedAccumulator</code></summary>

[Lean source](../../../TensorCore/TC/EncodedMonotonicity.lean#L13)

```lean
def MonotoneInEncodedAccumulator (p : Profile) (products : List (p.Word × p.Word)) : Prop :=
  ∀ (c c' : F32) (v v' d d' : ℚ),
    value32 c = some v → value32 c' = some v' →
    encodedBlockValue products c = .ok d → encodedBlockValue products c' = .ok d' →
    v' < v → d' ≤ d
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.encodedBlockValue](EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.encoded_v100_not_monotone](../Tests/EFT/EncodedEFT.md#decl-83fcbe1b52439ce7), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.not_monotoneInAccumulator_of_encoded](EncodedMonotonicity.md#decl-6b04e8218d0c9697)

</details>

</details>

<a id="decl-9eb0a74d8892c998"></a>

<details>
<summary><code>TensorCore.monotoneInAccumulator_encoded</code></summary>

[Lean source](../../../TensorCore/TC/EncodedMonotonicity.lean#L20)

```lean
/-- Decoded accumulator monotonicity transfers to encoded inputs and accepted output values. -/
theorem monotoneInAccumulator_encoded {p : Profile} {ps : List (p.Word × p.Word)}
    {products : List (Decoded × Decoded)} (hp : prepareProducts p ps = some products)
    (hm : MonotoneInAccumulator p products) : MonotoneInEncodedAccumulator p ps := by
  intro c c' v v' d d' hv hv' hd hd' hlt
  cases hc : decode32 c with
  | none => simp [value32, hc] at hv
  | some dc =>
    cases hc' : decode32 c' with
    | none => simp [value32, hc'] at hv'
    | some dc' =>
      simp only [value32, hc, Option.map_some, Option.some.injEq] at hv
      simp only [value32, hc', Option.map_some, Option.some.injEq] at hv'
      cases he : evalBlock (⟨ps, c⟩ : BlockInput p) with
      | error e => simp [encodedBlockValue, he, Except.map] at hd
      | ok t =>
        cases he' : evalBlock (⟨ps, c'⟩ : BlockInput p) with
        | error e => simp [encodedBlockValue, he', Except.map] at hd'
        | ok t' =>
          simp only [encodedBlockValue, he, Except.map, Except.ok.injEq] at hd
          simp only [encodedBlockValue, he', Except.map, Except.ok.injEq] at hd'
          have ht : evalPrepared ⟨p, products, dc⟩ = .ok t := by
            unfold evalBlock at he
            split at he
            · contradiction
            · simpa [prepare, hc, hp] using he
          have ht' : evalPrepared ⟨p, products, dc'⟩ = .ok t' := by
            unfold evalBlock at he'
            split at he'
            · contradiction
            · simpa [prepare, hc', hp] using he'
          rw [← hd, ← hd']
          exact hm dc dc' t t' ht ht' (by rw [hv, hv']; exact hlt)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.MonotoneInAccumulator](Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.MonotoneInEncodedAccumulator](EncodedMonotonicity.md#decl-2fe557d3c0f04019), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.encodedBlockValue](EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.value32](../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.not_monotoneInAccumulator_of_encoded](EncodedMonotonicity.md#decl-6b04e8218d0c9697)

</details>

</details>

<a id="decl-6b04e8218d0c9697"></a>

<details>
<summary><code>TensorCore.not_monotoneInAccumulator_of_encoded</code></summary>

[Lean source](../../../TensorCore/TC/EncodedMonotonicity.lean#L54)

```lean
/-- A non-monotone encoded witness refutes decoded monotonicity for its fixed products. -/
theorem not_monotoneInAccumulator_of_encoded {p : Profile} {ps : List (p.Word × p.Word)}
    {products : List (Decoded × Decoded)} (hp : prepareProducts p ps = some products)
    (h : ¬ MonotoneInEncodedAccumulator p ps) : ¬ MonotoneInAccumulator p products :=
  fun hm => h (monotoneInAccumulator_encoded hp hm)
```

**Supporting proofs:** [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998)

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.MonotoneInAccumulator](Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.MonotoneInEncodedAccumulator](EncodedMonotonicity.md#decl-2fe557d3c0f04019), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
