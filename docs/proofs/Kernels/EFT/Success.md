# TensorCore.Kernels.EFT.Success

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4cb1d90c8b7bff20"></a>

<details>
<summary><code>TensorCore.EFMachine.unit_product</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Success.lean#L8)

```lean
private theorem unit_product (a b : ℚ) (ha : absQ a ≤ 1) (hb : absQ b ≤ 1) :
    absQ (a * b) ≤ 1 := by
  have ha' := (absQ_le_iff _ _).mp ha
  have hb' := (absQ_le_iff _ _).mp hb
  apply (absQ_le_iff _ _).mpr
  by_cases ha0 : 0 ≤ a <;> by_cases hb0 : 0 ≤ b
  · have h1 := Rat.mul_le_mul_of_nonneg_left hb'.2 ha0
    have h2 := Rat.mul_nonneg ha0 hb0
    grind
  · have h1 := Rat.mul_le_mul_of_nonneg_left hb'.1 ha0
    have h2 := Rat.mul_le_mul_of_nonneg_left (show b ≤ 0 by grind) ha0
    grind
  · have h1 := Rat.mul_le_mul_of_nonneg_right ha'.1 hb0
    have h2 := Rat.mul_le_mul_of_nonneg_right (show a ≤ 0 by grind) hb0
    grind
  · have hn1 : 0 ≤ -a := by grind
    have hn2 : 0 ≤ -b := by grind
    have h1 := Rat.mul_le_mul_of_nonneg_left (show -b ≤ 1 by grind) hn1
    have h2 := Rat.mul_nonneg hn1 hn2
    grind
```

**Supporting proofs:** [TensorCore.absQ_le_iff](../../Numerics/Exact.md#decl-3513a75c8e3035b2)

**Definitions and types:** [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](Success.md#decl-5145abbc51875848)

</details>

</details>

<a id="decl-5145abbc51875848"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1_unitInputs_success</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Success.lean#L33)

```lean
/-- A concrete input-only success family, requiring no bound on the ideal:
all decoded input operands and c have magnitude at most one. Arbitrary finite D
is permitted, and every returned encoding is nearest-even to the original dot.
The derived ideal bound is K+1 ≤ 17. -/
theorem algorithm1_unitInputs_success {path : Path} {x : BlockInput path.profile} {D : F32}
    {b : PreparedBlock} {d : ℚ}
    (shape : x.products.length = path.profile.products)
    (inputs : TensorCore.prepare x = some b)
    (hc : absQ b.c.value ≤ 1)
    (hp : ∀ ab ∈ b.products, absQ ab.1.value ≤ 1 ∧ absQ ab.2.value ≤ 1)
    (hD : TensorCore.value32 D = some d) :
    absQ b.exactDot ≤ 17 ∧
      ∃ r bits, algorithm1 path x D = .ok r ∧ r.bits = some bits ∧ NearestEven32 b.exactDot bits := by
  have hlen : b.products.length = path.profile.products := by
    unfold TensorCore.prepare at inputs
    cases hd : TensorCore.decode32 x.c <;>
      cases hs : TensorCore.prepareProducts path.profile x.products <;>
      simp only [hd, hs, Option.some.injEq] at inputs
    · contradiction
    · contradiction
    · contradiction
    · subst b
      have h := mapM_bounds (P := fun _ => True) (fun _ _ _ => trivial) hs
      exact h.1.trans shape
  have hp' : ∀ ab ∈ b.products, absQ (ab.1.value * ab.2.value) ≤ 1 := by
    intro ab hab
    exact unit_product _ _ (hp ab hab).1 (hp ab hab).2
  have hs := absQ_sumQ_le (b.products.map fun ab => ab.1.value * ab.2.value)
  have hb := sumQ_map_le b.products (fun ab => absQ (ab.1.value * ab.2.value)) 1 hp'
  simp only [List.map_map, Function.comp_def] at hs
  have ha := absQ_add_le b.c.value b.exactProducts
  have hn : (b.products.length : ℚ) ≤ 16 :=
    Rat.natCast_le_natCast.mpr (by rw [hlen]; exact path_count path)
  have hbound : absQ b.exactDot ≤ 17 := by
    dsimp only [PreparedBlock.exactProducts] at ha
    dsimp only [PreparedBlock.exactDot, PreparedBlock.exactProducts]
    grind
  refine ⟨hbound, algorithm1_success shape ?_ hD ?_⟩
  · simp [TensorCore.exactDot, inputs]
  · have hmax : (17 : ℚ) ≤ maxFinite32 := by decide +kernel
    exact Rat.le_trans hbound hmax
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1_success](Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.mapM_bounds](Preparation.md#decl-527b64204fe2294d), [TensorCore.EFMachine.path_count](Preparation.md#decl-5c86c03a8739e02a), [TensorCore.absQ_add_le](../../Numerics/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_sumQ_le](../../Numerics/Sum.md#decl-9728c1755d91fb0d), [TensorCore.sumQ_map_le](../../Numerics/Sum.md#decl-02931053452cdfec), [TensorCore.EFMachine.unit_product](Success.md#decl-4cb1d90c8b7bff20)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Error](Defs.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](Defs.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Defs.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../../TC/Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](../../TC/Block.md#decl-1f40b290e956d863), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.decode32](../../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.maxFinite32](../../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.prepare](../../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](../../TC/Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.value32](../../Numerics/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
