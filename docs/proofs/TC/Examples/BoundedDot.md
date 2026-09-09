# TensorCore.TC.Examples.BoundedDot

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-1171c93b23baca97"></a>

<details>
<summary><code>TensorCore.Program.ofGroups</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L9)

```lean
/-- Build an inspectable AST from an ordered list of typed groups. -/
def Program.ofGroups {p : Profile} : List (BlockOperands p) → Program p
  | [] => .skip
  | g :: rest => .seq (.block ⟨{label := "ordered dot group"}, g⟩) (.ofGroups rest)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e)

<details>
<summary>Used by</summary>

[TensorCore.Program.inputs_ofGroups](BoundedDot.md#decl-160ee76bbb8869c5), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1)

</details>

</details>

<a id="decl-160ee76bbb8869c5"></a>

<details>
<summary><code>TensorCore.Program.inputs_ofGroups</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L13)

```lean
theorem Program.inputs_ofGroups {p : Profile} (gs : List (BlockOperands p)) :
    (Program.ofGroups gs).inputs = gs.map BlockOperands.values := by
  induction gs with
  | nil => rfl
  | cons g gs ih => simpa [Program.ofGroups, Program.inputs, Program.blocks] using congrArg (g.values :: ·) ih
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.LocatedBlock](../Program/Defs.md#decl-36cafa797c1bf521), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.blocks](../Program/Defs.md#decl-e6562fd402604610), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.ofGroups](BoundedDot.md#decl-1171c93b23baca97), [TensorCore.SourceSite](../Program/Defs.md#decl-4b38eaa245ee464e)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_inputs](BoundedDot.md#decl-2b3fe7bf5d27756f)

</details>

</details>

<a id="decl-78fed1d70f5dfbd1"></a>

<details>
<summary><code>TensorCore.boundedDot</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L20)

```lean
/-- One row-column contribution: ordered groups of four, with zero padding only at the tail. -/
def boundedDot (xs : List (F16 × F16)) : Program v100F16F32 :=
  Program.ofGroups (canonicalPartition 4 0 none (by decide) xs).groups
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](../Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.ofGroups](BoundedDot.md#decl-1171c93b23baca97), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.boundedDotCheck_sound](BoundedDot.md#decl-bee6a2a1f0c3f285), [TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.boundedDot_accurate_of_bits](BoundedDot.md#decl-feec6cddd4e6942c), [TensorCore.boundedDot_count](BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_group_limit](BoundedDot.md#decl-1753bf8bca4d3679), [TensorCore.boundedDot_ideal](BoundedDot.md#decl-d51d031070373d01), [TensorCore.boundedDot_inputs](BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.boundedDot_run](BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.boundedDot_scales](BoundedDot.md#decl-d931c783bf455abe)

</details>

</details>

<a id="decl-2b3fe7bf5d27756f"></a>

<details>
<summary><code>TensorCore.boundedDot_inputs</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L23)

```lean
theorem boundedDot_inputs (xs : List (F16 × F16)) :
    (boundedDot xs).inputs = (canonicalPartition 4 0 none (by decide) xs).inputs :=
  Program.inputs_ofGroups _
```

**Supporting proofs:** [TensorCore.Program.inputs_ofGroups](BoundedDot.md#decl-160ee76bbb8869c5)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](../Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_count](BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_ideal](BoundedDot.md#decl-d51d031070373d01), [TensorCore.boundedDot_run](BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.boundedDot_scales](BoundedDot.md#decl-d931c783bf455abe)

</details>

</details>

<a id="decl-6434984f6678b1a1"></a>

<details>
<summary><code>TensorCore.boundedDot_count</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L27)

```lean
theorem boundedDot_count (xs : List (F16 × F16)) :
    (boundedDot xs).inputs.length = groupCount 4 xs.length := by
  rw [boundedDot_inputs]
  exact (List.length_map _).trans (canonicalPartition_count 4 0 none (by decide) xs)
```

**Supporting proofs:** [TensorCore.boundedDot_inputs](BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.canonicalPartition_count](../Program/Partition.md#decl-1992fedc2c2443e2)

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](../Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.groupCount](../Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_group_limit](BoundedDot.md#decl-1753bf8bca4d3679)

</details>

</details>

<a id="decl-d51d031070373d01"></a>

<details>
<summary><code>TensorCore.boundedDot_ideal</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L32)

```lean
theorem boundedDot_ideal (xs : List (F16 × F16)) (c : F32) :
    (boundedDot xs).ideal c = (do return (← value32 c) + (← idealProducts v100F16F32 xs)) := by
  unfold Program.ideal
  rw [boundedDot_inputs]
  have hi := canonicalPartition_ideal 4 0 none (by decide) xs
  change idealContributions v100F16F32 _ = idealProducts v100F16F32 xs at hi
  rw [hi]
```

**Supporting proofs:** [TensorCore.boundedDot_inputs](BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.canonicalPartition_ideal](../Program/Partition.md#decl-a4ecaffa5e5880bb)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.ideal](../Program/Defs.md#decl-1eb3ac3acdd9bcff), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.idealContributions](../Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../Program/Defs.md#decl-5d908ac035267580), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9241fb8f8ed9acc6"></a>

<details>
<summary><code>TensorCore.boundedDot_run</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L40)

```lean
theorem boundedDot_run (xs : List (F16 × F16)) (initial : Finite32) :
    (boundedDot xs).run initial.bits = runCanonicalDot 4 0 none (by decide) xs initial.bits := by
  rw [runCanonicalDot_finite]
  simp only [Program.run, OrderedPartition.run, boundedDot_inputs]
  rfl
```

**Supporting proofs:** [TensorCore.boundedDot_inputs](BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.runCanonicalDot_finite](../Program/Partition.md#decl-70d7bcd0619569bf)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.OrderedPartition.run](../Program/DotProduct.md#decl-f44f6497dde77681), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.Program.run](../Program/Defs.md#decl-7a1c9df214179ea0), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.runBlocks](../Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runCanonicalDot](../Program/Partition.md#decl-a632fab4c91f1890), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-af4a8584ae650d2f"></a>

<details>
<summary><code>TensorCore.small16</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L48)

```lean
/-- Executable input bound: finite, and zero or decoded raw exponent at most -5.
Both signs and subnormals are allowed; every accepted magnitude is below 1/16. -/
def small16 (x : F16) : Bool :=
  match decode16 x with
  | none => false
  | some d => decide (d.significand = 0 ∨ d.rawScale ≤ -5)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.decode16](../../Core/Encoding.md#decl-09c456448c5633d0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.at_operand_boundary_refused](../Regression/Application.md#decl-b1aee65536843a4f), [TensorCore.Regression.nan_operand_refused](../Regression/Application.md#decl-c6a6f90552528041), [TensorCore.Regression.signed_zero_allowed](../Regression/Application.md#decl-21e2b5150c115b82), [TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.boundedDotCheck](BoundedDot.md#decl-ec759e24e02a72b7), [TensorCore.boundedDotCheck_sound](BoundedDot.md#decl-bee6a2a1f0c3f285), [TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.boundedDot_accurate_of_bits](BoundedDot.md#decl-feec6cddd4e6942c), [TensorCore.boundedDot_scales](BoundedDot.md#decl-d931c783bf455abe), [TensorCore.small16_group](BoundedDot.md#decl-116dda86b04e3b4e), [TensorCore.small16_of_bits](BoundedDot.md#decl-af1afeeb766d066a), [TensorCore.small16_spec](BoundedDot.md#decl-5c97a0cbf9c76bc3), [TensorCore.small16_value](BoundedDot.md#decl-a57578c06982c772), [TensorCore.small_repeat_accurate](BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>

<a id="decl-af1afeeb766d066a"></a>

<details>
<summary><code>TensorCore.small16_of_bits</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L54)

```lean
/-- A simple encoded interval implies the semantic bound, for either sign. -/
theorem small16_of_bits (x : F16) (h : x.toNat % 32768 < 11264) : small16 x = true := by
  have he : x.toNat / 1024 % 32 ≤ 10 := by omega
  simp only [small16, decode16, classify, classifyNat, fp16, Classification.finite]
  simp only [Nat.reducePow, Nat.reduceAdd, Nat.reduceSub]
  have hx : x.toNat / 1024 % 32 ≠ 31 := by omega
  by_cases hz : x.toNat / 1024 % 32 = 0
  · by_cases hf : x.toNat % 1024 = 0 <;> simp [hz, hf]
  · simp only [hx, hz, ↓reduceIte, decide_eq_true_eq]
    right
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_accurate_of_bits](BoundedDot.md#decl-feec6cddd4e6942c)

</details>

</details>

<a id="decl-5c97a0cbf9c76bc3"></a>

<details>
<summary><code>TensorCore.small16_spec</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L65)

```lean
theorem small16_spec (x : F16) (h : small16 x = true) :
    ∃ d, decode16 x = some d ∧ (d.significand = 0 ∨ d.rawScale ≤ -5) := by
  unfold small16 at h
  split at h
  · contradiction
  · exact ⟨_, ‹decode16 x = _›, of_decide_eq_true h⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.decode16](../../Core/Encoding.md#decl-09c456448c5633d0), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.small16_group](BoundedDot.md#decl-116dda86b04e3b4e), [TensorCore.small16_value](BoundedDot.md#decl-a57578c06982c772)

</details>

</details>

<a id="decl-a57578c06982c772"></a>

<details>
<summary><code>TensorCore.small16_value</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L72)

```lean
theorem small16_value (x : F16) (h : small16 x = true) :
    ∃ d, decode16 x = some d ∧ absQ d.value < 1 / 16 := by
  obtain ⟨d, hd, hz | hs⟩ := small16_spec x h
  · refine ⟨d, hd, ?_⟩
    simp [Decoded.value, hz, absQ]
    decide +kernel
  · refine ⟨d, hd, ?_⟩
    have hb := classifyNat_bounded fp16 x.toNat d hd
    have hp := pow2_le_of_le hs
    have he : 2 * pow2 (-5) = (1 / 16 : ℚ) := by decide +kernel
    change absQ d.value < 2 * pow2 d.rawScale at hb
    rw [← he]
    grind
```

**Supporting proofs:** [TensorCore.classifyNat_bounded](../../Core/FormatProperties.md#decl-210634dc2026dbec), [TensorCore.pow2_le_of_le](../../Core/Exact.md#decl-064be6edf8651285), [TensorCore.small16_spec](BoundedDot.md#decl-5c97a0cbf9c76bc3)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.Bounded](../../Core/Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.decode16](../../Core/Encoding.md#decl-09c456448c5633d0), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-116dda86b04e3b4e"></a>

<details>
<summary><code>TensorCore.small16_group</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L86)

```lean
theorem small16_group (g : List (F16 × F16))
    (h : ∀ pair ∈ g, small16 pair.1 = true ∧ small16 pair.2 = true) :
    GroupScaleBounded v100F16F32 g (-10) := by
  intro pair hp
  obtain ⟨da, ha, hsa⟩ := small16_spec pair.1 (h pair hp).1
  obtain ⟨db, hb, hsb⟩ := small16_spec pair.2 (h pair hp).2
  refine ⟨da, db, ha, hb, ?_⟩
  intro hnz
  change da.significand * db.significand ≠ 0 at hnz
  change da.rawScale + db.rawScale ≤ -10
  rcases hsa with hz | hs
  · simp [hz] at hnz
  rcases hsb with hz | ht
  · simp [hz] at hnz
  omega
```

**Supporting proofs:** [TensorCore.small16_spec](BoundedDot.md#decl-5c97a0cbf9c76bc3)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.GroupScaleBounded](../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.decode16](../../Core/Encoding.md#decl-09c456448c5633d0), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_scales](BoundedDot.md#decl-d931c783bf455abe), [TensorCore.small_repeat_accurate](BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>

<a id="decl-d931c783bf455abe"></a>

<details>
<summary><code>TensorCore.boundedDot_scales</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L102)

```lean
theorem boundedDot_scales (xs : List (F16 × F16))
    (hs : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true) :
    ∀ g ∈ (boundedDot xs).inputs, GroupScaleBounded v100F16F32 g (-10) := by
  intro g hg
  apply small16_group
  intro pair hp
  rw [boundedDot_inputs] at hg
  have hm : pair ∈ (padFp16Pairs 4 xs) := by
    rw [← (canonicalPartition 4 0 none (by decide) xs).covers]
    exact List.mem_flatten.mpr ⟨g, hg, hp⟩
  simp only [padFp16Pairs, List.mem_append] at hm
  rcases hm with hx | hz
  · exact hs pair hx
  · have := (List.mem_replicate.mp hz).2
    subst pair
    decide +kernel
```

**Supporting proofs:** [TensorCore.boundedDot_inputs](BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.small16_group](BoundedDot.md#decl-116dda86b04e3b4e)

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.GroupScaleBounded](../StaticBudget.md#decl-cc059aaa303d9b13), [TensorCore.OrderedPartition](../Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.tailPadding](../Program/Partition.md#decl-139b8e76e9854993), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9)

</details>

</details>

<a id="decl-1753bf8bca4d3679"></a>

<details>
<summary><code>TensorCore.boundedDot_group_limit</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L119)

```lean
theorem boundedDot_group_limit (xs : List (F16 × F16)) (hlen : xs.length ≤ 256) :
    (boundedDot xs).inputs.length ≤ 64 := by
  rw [boundedDot_count]
  unfold groupCount
  split <;> omega
```

**Supporting proofs:** [TensorCore.boundedDot_count](BoundedDot.md#decl-6434984f6678b1a1)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.groupCount](../Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9)

</details>

</details>

<a id="decl-a0a6954ceca26f79"></a>

<details>
<summary><code>TensorCore.boundedDot_budget</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L125)

```lean
theorem boundedDot_budget : staticBudget 5 23 1 3 = (21 / 4194304 : ℚ) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.small_schedule_tolerance](BoundedDot.md#decl-c193d14d0a9b59e9)

</details>

</details>

<a id="decl-30fd3ad0d5d57034"></a>

<details>
<summary><code>TensorCore.small_schedule_room</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L128)

```lean
private theorem small_schedule_room (m : ℕ) (hm : m ≤ 64) :
    (1 : ℚ) + (m : ℚ) * (4 * (4 * pow2 (-10)) + staticBudget 5 23 1 3) < pow2 (1 + 1) := by
  have hmq : (m : ℚ) ≤ 64 := Rat.natCast_le_natCast.mpr hm
  have hp : 4 * (4 * pow2 (-10)) + staticBudget 5 23 1 3 = (65557 / 4194304 : ℚ) := by decide +kernel
  rw [hp]
  change _ < (4 : ℚ)
  grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.small_repeat_accurate](BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>

<a id="decl-c193d14d0a9b59e9"></a>

<details>
<summary><code>TensorCore.small_schedule_tolerance</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L136)

```lean
private theorem small_schedule_tolerance (m : ℕ) (hm : m ≤ 64) :
    (m : ℚ) * staticBudget 5 23 1 3 ≤ (1 / 2048 : ℚ) := by
  have hmq : (m : ℚ) ≤ 64 := Rat.natCast_le_natCast.mpr hm
  rw [boundedDot_budget]
  grind
```

**Supporting proofs:** [TensorCore.boundedDot_budget](BoundedDot.md#decl-a0a6954ceca26f79)

**Definitions and types:** [TensorCore.staticBudget](../StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.small_repeat_accurate](BoundedDot.md#decl-13ea2e2e9f51acd8)

</details>

</details>

<a id="decl-5f4a54e532e0f3b9"></a>

<details>
<summary><code>TensorCore.boundedDot_accurate</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L145)

```lean
/-- For up to 256 arbitrary signed small operand pairs and |c| ≤ 1, the actual
ordered FP32 result exists and differs from the original-input ideal by at most 2^-11.
No execution result, exact prefix, or final error is assumed. -/
theorem boundedDot_accurate (xs : List (F16 × F16)) (initial : Finite32)
    (hlen : xs.length ≤ 256)
    (hs : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true)
    (hc : absQ initial.value ≤ 1) :
    (boundedDot xs).Accurate initial.bits (1 / 2048) := by
  apply Program.accurate_of_scales (boundedDot xs) 1 (-10) 3
    (by decide) (by decide) (by simp [v100F16F32]) (by decide) (by decide)
    (boundedDot_scales xs hs) initial 1 _ hc
  · exact small_schedule_room _ (boundedDot_group_limit xs hlen)
  · exact small_schedule_tolerance _ (boundedDot_group_limit xs hlen)
```

**Supporting proofs:** [TensorCore.Program.accurate_of_scales](../Program/Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.boundedDot_group_limit](BoundedDot.md#decl-1753bf8bca4d3679), [TensorCore.boundedDot_scales](BoundedDot.md#decl-d931c783bf455abe), [TensorCore.small_schedule_room](BoundedDot.md#decl-30fd3ad0d5d57034), [TensorCore.small_schedule_tolerance](BoundedDot.md#decl-c193d14d0a9b59e9)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program.Accurate](../Program/CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDotCheck_sound](BoundedDot.md#decl-bee6a2a1f0c3f285), [TensorCore.boundedDot_accurate_of_bits](BoundedDot.md#decl-feec6cddd4e6942c)

</details>

</details>

<a id="decl-feec6cddd4e6942c"></a>

<details>
<summary><code>TensorCore.boundedDot_accurate_of_bits</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L156)

```lean
theorem boundedDot_accurate_of_bits (xs : List (F16 × F16)) (initial : Finite32)
    (hlen : xs.length ≤ 256)
    (hs : ∀ pair ∈ xs, pair.1.toNat % 32768 < 11264 ∧ pair.2.toNat % 32768 < 11264)
    (hc : absQ initial.value ≤ 1) : (boundedDot xs).Accurate initial.bits (1 / 2048) :=
  boundedDot_accurate xs initial hlen
    (fun pair hp => ⟨small16_of_bits _ (hs pair hp).1, small16_of_bits _ (hs pair hp).2⟩) hc
```

**Supporting proofs:** [TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.small16_of_bits](BoundedDot.md#decl-af1afeeb766d066a)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Program.Accurate](../Program/CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ec759e24e02a72b7"></a>

<details>
<summary><code>TensorCore.boundedDotCheck</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L164)

```lean
/-- Family membership check: decode each input once, without a model run or ideal prefixes. -/
def boundedDotCheck (xs : List (F16 × F16)) (c : F32) : Bool :=
  decide (xs.length ≤ 256) && xs.all (fun (a, b) => small16 a && small16 b) &&
    match value32 c with
    | none => false
    | some v => decide (absQ v ≤ 1)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.initial_outside_family_refused](../Regression/Application.md#decl-1bef74ebd70979a1), [TensorCore.Regression.partial_tail_signed_accepted](../Regression/Application.md#decl-a4d99b23e0557695), [TensorCore.Regression.too_long_refused](../Regression/Application.md#decl-75eec7aac97709f8), [TensorCore.boundedDotCheck_sound](BoundedDot.md#decl-bee6a2a1f0c3f285)

</details>

</details>

<a id="decl-bee6a2a1f0c3f285"></a>

<details>
<summary><code>TensorCore.boundedDotCheck_sound</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L170)

```lean
theorem boundedDotCheck_sound (xs : List (F16 × F16)) (c : F32)
    (h : boundedDotCheck xs c = true) : (boundedDot xs).Accurate c (1 / 2048) := by
  simp only [boundedDotCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨hlen, hs⟩, hc⟩ := h
  cases hv : value32 c with
  | none => simp [hv] at hc
  | some v =>
    obtain ⟨initial, _, hb, hi⟩ := finite32_of_value32 c v hv
    have hs' : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true := by
      intro pair hp
      simpa only [Bool.and_eq_true] using List.all_eq_true.mp hs pair hp
    have hcv : absQ initial.value ≤ 1 := by simpa [hv, hi] using hc
    simpa [hb] using boundedDot_accurate xs initial hlen hs' hcv
```

**Supporting proofs:** [TensorCore.boundedDot_accurate](BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.finite32_of_value32](../../Core/Encoding.md#decl-e85cafbe6e246ed5)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Program.Accurate](../Program/CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.boundedDot](BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.boundedDotCheck](BoundedDot.md#decl-ec759e24e02a72b7), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-13ea2e2e9f51acd8"></a>

<details>
<summary><code>TensorCore.small_repeat_accurate</code></summary>

[Lean source](../../../../TensorCore/TC/Examples/BoundedDot.lean#L186)

```lean
/-- A symbolic number of changing-state iterations. The body may contain arbitrary
small operands; the total invocation count, not a fixed point, controls accumulated error. -/
theorem small_repeat_accurate (body : Program v100F16F32) (n : ℕ) (initial : Finite32)
    (hcount : n * body.inputs.length ≤ 64)
    (hs : ∀ g ∈ body.inputs, ∀ pair ∈ g, small16 pair.1 = true ∧ small16 pair.2 = true)
    (hc : absQ initial.value ≤ 1) :
    (Program.repeat n body).Accurate initial.bits (1 / 2048) := by
  apply Program.repeat_accurate_of_scales body n 1 (-10) 3
    (by decide) (by decide) (by simp [v100F16F32]) (by decide) (by decide)
    (fun g hg => small16_group g (hs g hg)) initial 1 _ hc
  · exact small_schedule_room _ hcount
  · exact small_schedule_tolerance _ hcount
```

**Supporting proofs:** [TensorCore.Program.repeat_accurate_of_scales](../Program/Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.small16_group](BoundedDot.md#decl-116dda86b04e3b4e), [TensorCore.small_schedule_room](BoundedDot.md#decl-30fd3ad0d5d57034), [TensorCore.small_schedule_tolerance](BoundedDot.md#decl-c193d14d0a9b59e9)

**Definitions and types:** [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Program](../Program/Defs.md#decl-181bc2fc467c7372), [TensorCore.Program.Accurate](../Program/CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.inputs](../Program/Defs.md#decl-bd3749a183ce7223), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.small16](BoundedDot.md#decl-af4a8584ae650d2f), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.symbolic_changing_loop](../Regression/Application.md#decl-d4a47d36d3054d89)

</details>

</details>
