# TensorCore.TC.Regression.DotProduct

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5e99e7be18050b0d"></a>

<details>
<summary><code>TensorCore.Regression.negativeGroup</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L8)

```lean
private def negativeGroup : BlockOperands v100F16F32 :=
  ⟨[(0xbc00, 0x3c00), (0, 0), (0, 0), (0, 0)], rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.partition_order_changes_output](DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.Regression.partition_original_order](DotProduct.md#decl-3e07931106d2b633), [TensorCore.Regression.orderedDot](DotProduct.md#decl-2d5428af12680101), [TensorCore.Regression.originalPairs](DotProduct.md#decl-aab28c957a084cba)

</details>

</details>

<a id="decl-9388f5b4a9ce0d5b"></a>

<details>
<summary><code>TensorCore.Regression.tinyGroup</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L11)

```lean
private def tinyGroup : BlockOperands v100F16F32 :=
  ⟨[(0xc00, 0xc00), (0, 0), (0, 0), (0, 0)], rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.partition_order_changes_output](DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.Regression.partition_original_order](DotProduct.md#decl-3e07931106d2b633), [TensorCore.Regression.orderedDot](DotProduct.md#decl-2d5428af12680101), [TensorCore.Regression.originalPairs](DotProduct.md#decl-aab28c957a084cba)

</details>

</details>

<a id="decl-aab28c957a084cba"></a>

<details>
<summary><code>TensorCore.Regression.originalPairs</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L14)

```lean
private def originalPairs : List (F16 × F16) := negativeGroup.values ++ tinyGroup.values
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0), [TensorCore.Regression.negativeGroup](DotProduct.md#decl-5e99e7be18050b0d), [TensorCore.Regression.tinyGroup](DotProduct.md#decl-9388f5b4a9ce0d5b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.partition_error_contract](DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.partition_order_changes_output](DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.Regression.partition_original_order](DotProduct.md#decl-3e07931106d2b633), [TensorCore.Regression.orderedDot](DotProduct.md#decl-2d5428af12680101)

</details>

</details>

<a id="decl-2d5428af12680101"></a>

<details>
<summary><code>TensorCore.Regression.orderedDot</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L16)

```lean
private def orderedDot : OrderedPartition v100F16F32 originalPairs :=
  ⟨[negativeGroup, tinyGroup], by simp [originalPairs]⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](../Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0), [TensorCore.Regression.negativeGroup](DotProduct.md#decl-5e99e7be18050b0d), [TensorCore.Regression.originalPairs](DotProduct.md#decl-aab28c957a084cba), [TensorCore.Regression.tinyGroup](DotProduct.md#decl-9388f5b4a9ce0d5b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.partition_error_contract](DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.partition_order_changes_output](DotProduct.md#decl-aebe4ccf38b86fea), [TensorCore.Regression.partition_original_order](DotProduct.md#decl-3e07931106d2b633)

</details>

</details>

<a id="decl-e0249d408b8518a3"></a>

<details>
<summary><code>TensorCore.Regression.initialOne</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L19)

```lean
private def initialOne : Finite32 := ⟨0x3f800000, ⟨8388608, 0, 23⟩, by decide⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.partition_error_contract](DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.partition_order_changes_output](DotProduct.md#decl-aebe4ccf38b86fea)

</details>

</details>

<a id="decl-3e07931106d2b633"></a>

<details>
<summary><code>TensorCore.Regression.partition_original_order</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L21)

```lean
theorem partition_original_order : orderedDot.inputs = [negativeGroup.values, tinyGroup.values] ∧
    originalPairs.length = 8 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0), [TensorCore.Regression.negativeGroup](DotProduct.md#decl-5e99e7be18050b0d), [TensorCore.Regression.orderedDot](DotProduct.md#decl-2d5428af12680101), [TensorCore.Regression.originalPairs](DotProduct.md#decl-aab28c957a084cba), [TensorCore.Regression.tinyGroup](DotProduct.md#decl-9388f5b4a9ce0d5b)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-aebe4ccf38b86fea"></a>

<details>
<summary><code>TensorCore.Regression.partition_order_changes_output</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L26)

```lean
/-- Reordering groups preserves this ideal sum but changes the uncorrected bits.
Cancelling the initial 1 first lets the tiny product survive its own invocation. -/
theorem partition_order_changes_output :
    idealProducts v100F16F32 originalPairs =
      idealProducts v100F16F32 (tinyGroup.values ++ negativeGroup.values) ∧
    ((orderedDot.run initialOne.bits).toOption.map fun ts =>
      (lastOutput initialOne ts).bits) = some (BitVec.ofNat 32 0x33800000) ∧
    ((runV100 initialOne.bits [tinyGroup.values, negativeGroup.values]).toOption.map fun ts =>
      (lastOutput initialOne ts).bits) = some (BitVec.ofNat 32 0) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](../Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.run](../Program/DotProduct.md#decl-f44f6497dde77681), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.idealProducts](../Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runV100](../Program/Composition.md#decl-db0ac9bfd91eb790), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0), [TensorCore.Regression.initialOne](DotProduct.md#decl-e0249d408b8518a3), [TensorCore.Regression.negativeGroup](DotProduct.md#decl-5e99e7be18050b0d), [TensorCore.Regression.orderedDot](DotProduct.md#decl-2d5428af12680101), [TensorCore.Regression.originalPairs](DotProduct.md#decl-aab28c957a084cba), [TensorCore.Regression.tinyGroup](DotProduct.md#decl-9388f5b4a9ce0d5b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ab9940b7024825ae"></a>

<details>
<summary><code>TensorCore.Regression.partition_error_contract</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L35)

```lean
/-- The public theorem applies to the original pair list without a correction step. -/
theorem partition_error_contract (ts : List BlockTrace)
    (h : orderedDot.run initialOne.bits = .ok ts) :
    absQ (pow2 (-24) - (lastOutput initialOne ts).value) <
      sumQ (ts.map BlockTrace.errorBudget) := by
  have hi : idealProducts v100F16F32 originalPairs = some (-1 + pow2 (-24)) := by decide +kernel
  have hb := (orderedDot.uncorrected_error initialOne ts (-1 + pow2 (-24)) h hi).2 (by decide)
  have he : initialOne.value + (-1 + pow2 (-24)) = pow2 (-24) := by
    have hv : initialOne.value = 1 := by decide +kernel
    rw [hv]
    grind
  rwa [he] at hb
```

**Supporting proofs:** [TensorCore.OrderedPartition.uncorrected_error](../Program/DotProduct.md#decl-ad212c5eb40bffac)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](../Program/ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.OrderedPartition.run](../Program/DotProduct.md#decl-f44f6497dde77681), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealProducts](../Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.v100F16F32](../Defs.md#decl-71711e48d14142e0), [TensorCore.Regression.initialOne](DotProduct.md#decl-e0249d408b8518a3), [TensorCore.Regression.orderedDot](DotProduct.md#decl-2d5428af12680101), [TensorCore.Regression.originalPairs](DotProduct.md#decl-aab28c957a084cba)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8f09a38ac600e233"></a>

<details>
<summary><code>TensorCore.Regression.fivePairs</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L47)

```lean
private def fivePairs : List (F16 × F16) :=
  [(0x3c00, 0x3c00), (0x4000, 0x3c00), (0x4200, 0x3c00), (0x4400, 0x3c00), (0x4500, 0x3c00)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.constructed_partition_tail](DotProduct.md#decl-571ad9339f4b196c)

</details>

</details>

<a id="decl-571ad9339f4b196c"></a>

<details>
<summary><code>TensorCore.Regression.constructed_partition_tail</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L50)

```lean
theorem constructed_partition_tail :
    (canonicalPartition 4 0 none (by decide) fivePairs).inputs =
      [[(0x3c00, 0x3c00), (0x4000, 0x3c00), (0x4200, 0x3c00), (0x4400, 0x3c00)],
       [(0x4500, 0x3c00), (0, 0), (0, 0), (0, 0)]] ∧
    ((runCanonicalDot 4 0 none (by decide) fivePairs 0).toOption.map fun ts =>
      (lastOutput ⟨0, ⟨0, 0, 0⟩, by decide⟩ ts).bits) =
        some (BitVec.ofNat 32 0x41700000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.runCanonicalDot](../Program/Partition.md#decl-a632fab4c91f1890), [TensorCore.Regression.fivePairs](DotProduct.md#decl-8f09a38ac600e233)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ca7d093d7fdf14a1"></a>

<details>
<summary><code>TensorCore.Regression.constructed_partition_boundaries</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DotProduct.lean#L58)

```lean
theorem constructed_partition_boundaries :
    (canonicalPartition 4 0 none (by decide) []).inputs = [] ∧
    runCanonicalDot 4 0 none (by decide) [] 0x3f800000 = .ok [] ∧
    tailPadding 4 8 = 0 ∧ groupCount 4 8 = 2 ∧
    ((runCanonicalDot 16 2 (some (-133)) (by decide)
      (List.replicate 17 (0x3c00, 0x3c00)) 0).toOption.map fun ts =>
        (lastOutput ⟨0, ⟨0, 0, 0⟩, by decide⟩ ts).bits) =
          some (BitVec.ofNat 32 0x41880000) ∧
    runCanonicalDot 4 0 none (by decide) [(0x7c00, 0x3c00)] 0 =
      .error .nonfiniteInput := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](../Program/DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.canonicalPartition](../Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.groupCount](../Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.lastOutput](../Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.padFp16Pairs](../Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.runCanonicalDot](../Program/Partition.md#decl-a632fab4c91f1890), [TensorCore.tailPadding](../Program/Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
