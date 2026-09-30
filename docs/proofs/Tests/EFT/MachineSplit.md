# TensorCoreTests.EFT.MachineSplit

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-7e2050099cf55f3e"></a>

<details>
<summary><code>TensorCore.Regression.EFMachine.split_boundaries</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/MachineSplit.lean#L9)

```lean
/-- Exercise every shift-count encoding on boundary and patterned magnitudes. -/
theorem split_boundaries :
    ([0, 1, 0x7fffff, 0x800000, 0xaaaaaa, 0xffffff] : List (BitVec 24)).all (fun m =>
      (List.range 256).all fun n =>
        let s := splitMagnitude m (BitVec.ofNat 8 n)
        s.coarse.toNat == m.toNat / 2^n * 2^n && s.low.toNat == m.toNat % 2^n) = true := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](../../Kernels/EFT/SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.splitMagnitude](../../Kernels/EFT/SplitDefs.md#decl-cd5e2ed872b48654)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-da946ed9e47550b4"></a>

<details>
<summary><code>TensorCore.Regression.EFMachine.product_maximum</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/MachineSplit.lean#L16)

```lean
theorem product_maximum :
    (multiplySignificands 2047 2047).toNat = 4190209 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.multiplySignificands](../../Kernels/EFT/SplitDefs.md#decl-fa9d1dd91a2047b7)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f12f3766824311d7"></a>

<details>
<summary><code>TensorCore.Regression.EFMachine.negative_residual</code></summary>

[Lean source](../../../../tests/TensorCoreTests/EFT/MachineSplit.lean#L20)

```lean
/-- A negative residual is preserved by unsigned magnitude splitting plus its sign. -/
theorem negative_residual :
    signedDyadic true (splitMagnitude 0xffffff 23).low.toNat (-149) =
      signedDyadic true 0xffffff (-149) -
        truncGrid (signedDyadic true 0xffffff (-149)) (-126) := by
  exact splitMagnitude_low_residual true 0xffffff 23 (-149)
```

**Supporting proofs:** [TensorCore.EFMachine.splitMagnitude_low_residual](../../Kernels/EFT/Split.md#decl-6d6fe2bc592a6791)

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](../../Kernels/EFT/SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.signedDyadic](../../Kernels/EFT/Split.md#decl-763c208b0e2b895c), [TensorCore.EFMachine.splitMagnitude](../../Kernels/EFT/SplitDefs.md#decl-cd5e2ed872b48654), [TensorCore.truncGrid](../../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
