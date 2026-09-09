# TensorCore.Gemm.Regression.GemmSelection

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-892e059b2f3fccab"></a>

<details>
<summary><code>TensorCore.Regression.selectionModels</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L10)

```lean
def selectionModels : List GemmCandidate := [{model := .v100}, {model := .ampere}, {model := .hopper}]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.selection_family](GemmSelection.md#decl-dfcf9fc60b19226e), [TensorCore.Regression.selection_preference_and_duplicates](GemmSelection.md#decl-904c1ea57c4ea668), [TensorCore.Regression.selection_rejection_policy](GemmSelection.md#decl-6bec8bea89cb74e8), [TensorCore.Regression.selection_signed_zero_subnormal_and_boundary](GemmSelection.md#decl-eb5d3b0bfd127365), [TensorCore.Regression.selection_tolerance_changes_choice](GemmSelection.md#decl-f9fe8538a74a65ec)

</details>

</details>

<a id="decl-3a56fc0e834e875f"></a>

<details>
<summary><code>TensorCore.Regression.selectionTiny</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L12)

```lean
def selectionTiny : GemmProblem 1 1 17 :=
  .raw #v[Vector.replicate 17 0x0c00] (Vector.replicate 17 #v[0x0c00]) #v[#v[0x3f800000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.selection_preference_and_duplicates](GemmSelection.md#decl-904c1ea57c4ea668), [TensorCore.Regression.selection_rejection_policy](GemmSelection.md#decl-6bec8bea89cb74e8), [TensorCore.Regression.selection_tolerance_changes_choice](GemmSelection.md#decl-f9fe8538a74a65ec)

</details>

</details>

<a id="decl-f9fe8538a74a65ec"></a>

<details>
<summary><code>TensorCore.Regression.selection_tolerance_changes_choice</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L15)

```lean
theorem selection_tolerance_changes_choice :
    selectGemm selectionTiny selectionModels (1 / 100000) = some 0 ∧
    selectGemm selectionTiny selectionModels (1 / 1000000) = some 1 ∧
    selectGemm selectionTiny selectionModels (1 / 2000000) = some 2 ∧
    selectGemm selectionTiny selectionModels 0 = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Regression.selectionModels](GemmSelection.md#decl-892e059b2f3fccab), [TensorCore.Regression.selectionTiny](GemmSelection.md#decl-3a56fc0e834e875f), [TensorCore.selectGemm](../Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-904c1ea57c4ea668"></a>

<details>
<summary><code>TensorCore.Regression.selection_preference_and_duplicates</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L21)

```lean
theorem selection_preference_and_duplicates :
    selectGemm selectionTiny selectionModels.reverse (1 / 100000) = some 0 ∧
    selectGemm selectionTiny [{model := .ampere}, {model := .ampere}] (1 / 1000000) = some 0 ∧
    selectGemm selectionTiny [] 1 = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.Regression.selectionModels](GemmSelection.md#decl-892e059b2f3fccab), [TensorCore.Regression.selectionTiny](GemmSelection.md#decl-3a56fc0e834e875f), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.selectGemm](../Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ed8f5ad53159d062"></a>

<details>
<summary><code>TensorCore.Regression.selectionSource</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L26)

```lean
def selectionSource : GemmProblem 1 1 1 :=
  .scaled fp32 0x3f800000 0 #v[#v[0x3f800001]] #v[#v[0x3f800000]] #v[#v[0]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.selection_source_accuracy](GemmSelection.md#decl-04a6c70aaf01cddf), [TensorCore.Regression.selection_source_rounding](GemmSelection.md#decl-0dd610d44068927b)

</details>

</details>

<a id="decl-c6149ee3773e3071"></a>

<details>
<summary><code>TensorCore.Regression.selectionModes</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L29)

```lean
def selectionModes : List GemmCandidate :=
  [{model := .hopper, inputMode := .towardPositive}, {model := .hopper}]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.selection_source_accuracy](GemmSelection.md#decl-04a6c70aaf01cddf), [TensorCore.Regression.selection_source_rounding](GemmSelection.md#decl-0dd610d44068927b)

</details>

</details>

<a id="decl-0dd610d44068927b"></a>

<details>
<summary><code>TensorCore.Regression.selection_source_rounding</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L32)

```lean
theorem selection_source_rounding :
    selectGemm selectionSource selectionModes (1 / 1000000) = some 1 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Regression.selectionModes](GemmSelection.md#decl-c6149ee3773e3071), [TensorCore.Regression.selectionSource](GemmSelection.md#decl-ed8f5ad53159d062), [TensorCore.selectGemm](../Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.selection_source_accuracy](GemmSelection.md#decl-04a6c70aaf01cddf)

</details>

</details>

<a id="decl-04a6c70aaf01cddf"></a>

<details>
<summary><code>TensorCore.Regression.selection_source_accuracy</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L35)

```lean
theorem selection_source_accuracy :
    selectionSource.Accurate {model := .hopper} (1 / 1000000) :=
  selectGemm_accuracy selectionSource selectionModes (1 / 1000000) 1 {model := .hopper}
    selection_source_rounding (by decide +kernel)
```

**Supporting proofs:** [TensorCore.Regression.selection_source_rounding](GemmSelection.md#decl-0dd610d44068927b), [TensorCore.selectGemm_accuracy](../Selection.md#decl-b72d2d5f7d629f7e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem.Accurate](../Selection.md#decl-8c9d3458097dac77), [TensorCore.Regression.selectionModes](GemmSelection.md#decl-c6149ee3773e3071), [TensorCore.Regression.selectionSource](GemmSelection.md#decl-ed8f5ad53159d062), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-dfcf9fc60b19226e"></a>

<details>
<summary><code>TensorCore.Regression.selection_family</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L40)

```lean
theorem selection_family :
    selectGemm (.family ⟨1 / 4096, 1 / 4096, 1 / 16⟩ : GemmProblem 2 3 16)
      selectionModels (3 / 5000000) = some 1 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.Regression.selectionModels](GemmSelection.md#decl-892e059b2f3fccab), [TensorCore.selectGemm](../Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-eb5d3b0bfd127365"></a>

<details>
<summary><code>TensorCore.Regression.selection_signed_zero_subnormal_and_boundary</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L44)

```lean
theorem selection_signed_zero_subnormal_and_boundary :
    selectGemm (.raw #v[#v[0]] #v[#v[0x8000]] #v[#v[0x80000000]]) selectionModels 0 = some 0 ∧
    selectGemm (.raw #v[#v[0x8001]] #v[#v[1]] #v[#v[0]]) selectionModels (1 / 1000000) = some 0 ∧
    selectGemm (.raw #v[#v[]] #v[] #v[#v[0x7f7fffff]]) selectionModels 0 = some 0 ∧
    selectGemm (.raw #v[#v[0x3c00]] #v[#v[0x3c00]] #v[#v[0x7f7fffff]]) selectionModels 1 = none :=
  by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.Regression.selectionModels](GemmSelection.md#decl-892e059b2f3fccab), [TensorCore.selectGemm](../Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6bec8bea89cb74e8"></a>

<details>
<summary><code>TensorCore.Regression.selection_rejection_policy</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSelection.lean#L51)

```lean
theorem selection_rejection_policy :
    selectGemm (.raw #v[#v[0x7c00]] #v[#v[0]] #v[#v[0]]) selectionModels 1 = none ∧
    selectGemm (.scaled fp32 0 0 #v[#v[0x7fc00000]] #v[#v[0]] #v[#v[0]]) selectionModels 1 = none ∧
    selectGemm (.scaled fp32 0 0 #v[#v[0x47800000]] #v[#v[0]] #v[#v[0]]) selectionModels 1 = none ∧
    selectGemm selectionTiny selectionModels (-1) = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.Regression.selectionModels](GemmSelection.md#decl-892e059b2f3fccab), [TensorCore.Regression.selectionTiny](GemmSelection.md#decl-3a56fc0e834e875f), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.selectGemm](../Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
