# TensorCore.TC.Program.Bounds.Scales

[Index](../../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-8ac3fa4265b04b8a"></a>

<details>
<summary><code>TensorCore.idealProducts_abs_le_of_scale</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Scales.lean#L8)

```lean
/-- Bound the ideal of a group from its decoded raw-product scales. -/
theorem idealProducts_abs_le_of_scale (p : Profile) (g : List (p.Word × p.Word)) (P : ℤ)
    (hs : GroupScaleBounded p g P) (v : ℚ) (hv : idealProducts p g = some v) :
    absQ v ≤ (g.length : ℚ) * (4 * pow2 P) := by
  cases hp : prepareProducts p g with
  | none => simp [idealProducts, hp] at hv
  | some qs =>
    simp only [idealProducts, hp, Option.map_some, Option.some.injEq] at hv
    rw [← hv]
    have hb := prepareProducts_bounds p g qs hp
    have hterms : ∀ q ∈ qs, absQ (q.1.value * q.2.value) ≤ 4 * pow2 P := by
      intro q hq
      obtain ⟨pair, hpair, ha, hc⟩ := prepareProducts_origin p g qs hp q hq
      obtain ⟨da, db, hda, hdb, hscale⟩ := hs pair hpair
      rw [ha] at hda
      rw [hc] at hdb
      cases Option.some.inj hda
      cases Option.some.inj hdb
      rw [← rawProduct_value]
      exact Rat.le_of_lt (term_abs_lt (rawMul q.1 q.2) P
        (rawMul_bounded q.1 q.2 (hb.2 q hq).1 (hb.2 q hq).2) hscale)
    have hsum := absQ_sumQ_le (qs.map fun q => q.1.value * q.2.value)
    have hbound := sumQ_map_le qs (fun q => absQ (q.1.value * q.2.value)) (4 * pow2 P) hterms
    simp only [List.map_map, Function.comp_def] at hsum
    rw [hb.1] at hbound
    exact Rat.le_trans hsum hbound
```

**Supporting proofs:** [TensorCore.absQ_sumQ_le](../../../Core/Sum.md#decl-9728c1755d91fb0d), [TensorCore.prepareProducts_bounds](../../AlignmentScale.md#decl-24fca5acfef90681), [TensorCore.prepareProducts_origin](../../CanonicalFloor.md#decl-11f8a3777df18b50), [TensorCore.rawMul_bounded](../../../Core/RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawProduct_value](../../../Core/RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.sumQ_map_le](../../../Core/Sum.md#decl-02931053452cdfec), [TensorCore.term_abs_lt](../../StaticBudget.md#decl-eb7aab7cbcc8d87a)

**Definitions and types:** [TensorCore.Decoded](../../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](../../../Core/Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](../../../Core/Defs.md#decl-c988858af545448a), [TensorCore.GroupScaleBounded](../../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealProducts](../Defs.md#decl-5d908ac035267580), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepareProducts](../../Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmCellCheck_product_bound](../../../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.runBlocks_of_scale_bound](Scales.md#decl-c2c004c589ff0bb6)

</details>

</details>

<a id="decl-d642c7a05f1cb663"></a>

<details>
<summary><code>TensorCore.idealContributions_abs_le</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Scales.lean#L35)

```lean
/-- This induction bounds all ideal sums without computing any input-dependent prefix. -/
theorem idealContributions_abs_le (p : Profile) (ps : List (List (p.Word × p.Word)))
    (G : ℚ) (hgroups : ∀ g ∈ ps, ∀ v, idealProducts p g = some v → absQ v ≤ G)
    (v : ℚ) (hv : idealContributions p ps = some v) :
    absQ v ≤ (ps.length : ℚ) * G := by
  induction ps generalizing v with
  | nil =>
    simp only [idealContributions, Option.some.injEq] at hv
    subst v
    simp [absQ]
  | cons g rest ih =>
    obtain ⟨a, b, ha, hb, rfl⟩ := idealContributions_cons_some p g rest v hv
    have hga := hgroups g (by simp) a ha
    have hrest := ih (fun q hq => hgroups q (by simp [hq])) b hb
    have hab := absQ_add_le a b
    have hlen : ((g :: rest).length : ℚ) = 1 + (rest.length : ℚ) := by
      simp only [List.length_cons, Rat.natCast_add]
      change (rest.length : ℚ) + 1 = 1 + (rest.length : ℚ)
      grind
    rw [hlen]
    grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../../../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.idealContributions_cons_some](../StaticCertificate.md#decl-e1771047163e04a5)

**Definitions and types:** [TensorCore.Format.width](../../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](../Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../Defs.md#decl-5d908ac035267580)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmCellCheck_product_bound](../../../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.runBlocks_of_scale_bound](Scales.md#decl-c2c004c589ff0bb6)

</details>

</details>

<a id="decl-52e870bce380a2a2"></a>

<details>
<summary><code>TensorCore.staticBudget_positive</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Scales.lean#L56)

```lean
theorem staticBudget_positive (n : ℕ) (F E : ℤ) (L : ℕ) : 0 < staticBudget n F E L := by
  have h1 := pow2_pos (E - F)
  have h2 := pow2_pos (max (E + 1 + L) (-126) - 23)
  have h3 : (0 : ℚ) ≤ n := Rat.natCast_nonneg
  have := Rat.mul_nonneg h3 (Rat.le_of_lt h1)
  unfold staticBudget
  grind
```

**Supporting proofs:** [TensorCore.pow2_pos](../../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.staticBudget](../../StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.familyError_nonneg](../../../Gemm/Family.md#decl-810b5bd68276af9d), [TensorCore.runBlocks_of_scale_bound](Scales.md#decl-c2c004c589ff0bb6)

</details>

</details>

<a id="decl-403621a23388d188"></a>

<details>
<summary><code>TensorCore.GroupScaleBounded.mono</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Scales.lean#L64)

```lean
theorem GroupScaleBounded.mono {p : Profile} {g : List (p.Word × p.Word)} {P E : ℤ}
    (hs : GroupScaleBounded p g P) (hPE : P ≤ E) : GroupScaleBounded p g E := by
  intro pair hpair
  obtain ⟨da, db, ha, hb, hscale⟩ := hs pair hpair
  exact ⟨da, db, ha, hb, fun hnz => Int.le_trans (hscale hnz) hPE⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.GroupScaleBounded](../../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.rawMul](../../../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_of_scale_bound](Scales.md#decl-c2c004c589ff0bb6)

</details>

</details>

<a id="decl-c2c004c589ff0bb6"></a>

<details>
<summary><code>TensorCore.runBlocks_of_scale_bound</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Scales.lean#L72)

```lean
/-- Input-derived acceptance and error for any schedule. Operand scale bounds and length
control ideal prefixes and the changing rounded state; exact prefixes are never evaluated. -/
theorem runBlocks_of_scale_bound (p : Profile) (E P : ℤ) (L : ℕ)
    (hE : -126 ≤ E) (hPE : P ≤ E) (hfl : ∀ f ∈ p.alignFloor, f ≤ E)
    (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (ps : List (List (p.Word × p.Word))) (hshape : ∀ g ∈ ps, g.length = p.products)
    (hscale : ∀ g ∈ ps, GroupScaleBounded p g P) (initial : Finite32) (C : ℚ)
    (hC : absQ initial.value ≤ C)
    (hroom : C + (ps.length : ℚ) *
      ((p.products : ℚ) * (4 * pow2 P) + staticBudget (p.products + 1) p.alignFraction E L) <
      pow2 (E + 1)) :
    ∃ ts products, runBlocks p initial.bits ps = .ok ts ∧
      idealContributions p ps = some products ∧
      absQ (initial.value + products - (lastOutput initial ts).value) ≤
        (ps.length : ℚ) * staticBudget (p.products + 1) p.alignFraction E L := by
  apply runBlocks_static p E L hE hfl hL hrange ps hshape
    (fun g hg => (hscale g hg).mono hPE) initial
  intro n hn v hv
  have hbound := idealContributions_abs_le p (ps.take n)
    ((p.products : ℚ) * (4 * pow2 P)) (by
      intro g hg x hx
      have hg' : g ∈ ps := List.mem_of_mem_take hg
      have := idealProducts_abs_le_of_scale p g P (hscale g hg') x hx
      simpa [hshape g hg'] using this) v hv
  rw [List.length_take, Nat.min_eq_left hn] at hbound
  have hsum := absQ_add_le initial.value v
  have hn' : (n : ℚ) ≤ (ps.length : ℚ) := Rat.natCast_le_natCast.mpr hn
  have hnonneg : (0 : ℚ) ≤ (p.products : ℚ) * (4 * pow2 P) +
      staticBudget (p.products + 1) p.alignFraction E L := by
    have hq := pow2_pos P
    have hk : (0 : ℚ) ≤ p.products := Rat.natCast_nonneg
    have hg := Rat.mul_nonneg hk (show 0 ≤ 4 * pow2 P by grind)
    have hb := staticBudget_positive (p.products + 1) p.alignFraction E L
    grind
  have hm := Rat.mul_le_mul_of_nonneg_right hn' hnonneg
  grind
```

**Supporting proofs:** [TensorCore.GroupScaleBounded.mono](Scales.md#decl-403621a23388d188), [TensorCore.absQ_add_le](../../../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.idealContributions_abs_le](Scales.md#decl-d642c7a05f1cb663), [TensorCore.idealProducts_abs_le_of_scale](Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.pow2_pos](../../../Core/Exact.md#decl-8f231b6648575120), [TensorCore.runBlocks_static](../../StaticBudget.md#decl-31af1b208da9e431), [TensorCore.staticBudget_positive](Scales.md#decl-52e870bce380a2a2)

**Definitions and types:** [TensorCore.BlockTrace](../../Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GroupScaleBounded](../../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.ModelError](../../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](../Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](../Composition.md#decl-59a9e0884980f32b), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.runBlocks](../Composition.md#decl-d4b070b6697e01f0), [TensorCore.staticBudget](../../StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Program.accurate_of_scales](Loops.md#decl-1a60f53bc1fc3642), [TensorCore.gemmCellCheck_sound](../../../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd)

</details>

</details>
