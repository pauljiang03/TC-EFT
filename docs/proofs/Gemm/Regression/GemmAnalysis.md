# TensorCore.Gemm.Regression.GemmAnalysis

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2d30ddfb433644fd"></a>

<details>
<summary><code>TensorCore.Regression.tinyAnalysis</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L11)

```lean
def tinyAnalysis (model : WmmaGemmModel) : Option CellAnalysis :=
  analyzeGemmCell model (List.replicate 17 (0x0c00, 0x0c00)) 0x3f800000
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemmCell](../Analysis.md#decl-6eee488b36c50d94)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_improves_existing_certificate](GemmAnalysis.md#decl-a1392f6a35ba7d56), [TensorCore.Regression.analysis_improves_minimal_static](GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.analysis_tiny_bounds](GemmAnalysis.md#decl-613947919eca8929), [TensorCore.Regression.tinyWitness](GemmAnalysis.md#decl-d68e82c966d519d3)

</details>

</details>

<a id="decl-613947919eca8929"></a>

<details>
<summary><code>TensorCore.Regression.analysis_tiny_bounds</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L14)

```lean
theorem analysis_tiny_bounds :
    (tinyAnalysis .v100).map (fun a => a.bound.error) = some (33 / 8388608) ∧
    (tinyAnalysis .ampere).map (fun a => a.bound.error) = some (3 / 4194304) ∧
    (tinyAnalysis .hopper).map (fun a => a.bound.error) = some (5 / 16777216) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound.error](../../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.Regression.tinyAnalysis](GemmAnalysis.md#decl-2d30ddfb433644fd), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a1392f6a35ba7d56"></a>

<details>
<summary><code>TensorCore.Regression.analysis_improves_existing_certificate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L19)

```lean
theorem analysis_improves_existing_certificate (model : WmmaGemmModel) :
    ((tinyAnalysis model).map fun a => decide
      (a.bound.error < gemmStaticError model smallGemmBounds 17)).getD false = true := by
  cases model <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound.error](../../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.Regression.smallGemmBounds](GemmExtensions.md#decl-9f16c29325b246ad), [TensorCore.Regression.tinyAnalysis](GemmAnalysis.md#decl-2d30ddfb433644fd), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmStaticError](../Bounds.md#decl-f2b1a703f1fc6bcf)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-09d5251e48e6effa"></a>

<details>
<summary><code>TensorCore.Regression.minimalTinyBounds</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L24)

```lean
def minimalTinyBounds (model : WmmaGemmModel) : GemmBoundConfig :=
  ⟨0, -24, (match model with | .v100 => 3 | .ampere => 4 | .hopper => 5), 1⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_improves_minimal_static](GemmAnalysis.md#decl-d029cb1810977fd7)

</details>

</details>

<a id="decl-d029cb1810977fd7"></a>

<details>
<summary><code>TensorCore.Regression.analysis_improves_minimal_static</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L27)

```lean
theorem analysis_improves_minimal_static (model : WmmaGemmModel) :
    gemmCheck model (minimalTinyBounds model) gemmTinyA gemmTinyB gemmOne = true ∧
    ((tinyAnalysis model).map fun a => decide
      (a.bound.error < gemmStaticError model (minimalTinyBounds model) 17)).getD false = true := by
  cases model <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound.error](../../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.minimalTinyBounds](GemmAnalysis.md#decl-09d5251e48e6effa), [TensorCore.Regression.tinyAnalysis](GemmAnalysis.md#decl-2d30ddfb433644fd), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmCheck](../Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmStaticError](../Bounds.md#decl-f2b1a703f1fc6bcf)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d68e82c966d519d3"></a>

<details>
<summary><code>TensorCore.Regression.tinyWitness</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L33)

```lean
def tinyWitness (model : WmmaGemmModel) : DenseMatrix (List GroupWitness) 1 1 :=
  #v[#v[((tinyAnalysis model).map (·.witness)).getD []]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Regression.tinyAnalysis](GemmAnalysis.md#decl-2d30ddfb433644fd), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_tolerance_certified](GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.Regression.analysis_tolerance_inconclusive](GemmAnalysis.md#decl-9f010dd9c59fddca)

</details>

</details>

<a id="decl-7c66d2624d546e50"></a>

<details>
<summary><code>TensorCore.Regression.analysis_tolerance_certified</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L36)

```lean
theorem analysis_tolerance_certified (model : WmmaGemmModel) :
    GemmAccurate model gemmTinyA gemmTinyB gemmOne (1 / 100000) := by
  apply gemmAnalysisCheck_sound model gemmTinyA gemmTinyB gemmOne (tinyWitness model)
  cases model <;> decide +kernel
```

**Supporting proofs:** [TensorCore.gemmAnalysisCheck_sound](../Analysis.md#decl-9853d7ce970a5d1d)

**Definitions and types:** [TensorCore.GemmAccurate](../Analysis.md#decl-3560e57078a6df2b), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.tinyWitness](GemmAnalysis.md#decl-d68e82c966d519d3), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmAnalysisCheck](../Analysis.md#decl-6640feb1a0c523f2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9f010dd9c59fddca"></a>

<details>
<summary><code>TensorCore.Regression.analysis_tolerance_inconclusive</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L41)

```lean
theorem analysis_tolerance_inconclusive :
    gemmAnalysisCheck .v100 gemmTinyA gemmTinyB gemmOne (tinyWitness .v100) 0 = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.tinyWitness](GemmAnalysis.md#decl-d68e82c966d519d3), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmAnalysisCheck](../Analysis.md#decl-6640feb1a0c523f2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4f1d63703ef328c3"></a>

<details>
<summary><code>TensorCore.Regression.analysis_signed_zero_and_empty</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L44)

```lean
theorem analysis_signed_zero_and_empty :
    (analyzeGemmCell .v100 [] 0x80000000).map (fun a => a.bound.error) = some 0 ∧
    (analyzeGemmCell .hopper [(0, 0x8000)] 0x80000000).map (fun a => a.bound.error) = some 0 ∧
    (analyzeGemmCell .ampere [] 0x7f7fffff).map (fun a => a.bound.error) = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound.error](../../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemmCell](../Analysis.md#decl-6eee488b36c50d94)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8904b8e4b9caf447"></a>

<details>
<summary><code>TensorCore.Regression.analysis_finite_boundary</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L49)

```lean
theorem analysis_finite_boundary :
    (analyzeGemmCell .v100 [(0, 0)] 0x7f7fffff).isSome = true ∧
    (analyzeGemmCell .hopper [(0, 0)] 0xff7fffff).isSome = true ∧
    (analyzeGemmCell .ampere [(0x3c00, 0x3c00)] 0x7f7fffff).isSome = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemmCell](../Analysis.md#decl-6eee488b36c50d94)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f472b6e439a11eeb"></a>

<details>
<summary><code>TensorCore.Regression.analysis_nonfinite_rejected</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L54)

```lean
theorem analysis_nonfinite_rejected :
    (analyzeGemmCell .v100 [(0x7c00, 0)] 0).isSome = false ∧
    (analyzeGemmCell .hopper [] 0x7fc00000).isSome = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemmCell](../Analysis.md#decl-6eee488b36c50d94)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0aab10efcd43b268"></a>

<details>
<summary><code>TensorCore.Regression.analysis_negative_subnormal</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L58)

```lean
theorem analysis_negative_subnormal :
    (analyzeGemmCell .v100 [(0x8001, 1)] 0).isSome = true ∧
    (analyzeGemmCell .ampere [(0x8001, 1)] 0).isSome = true ∧
    (analyzeGemmCell .hopper [(0x8001, 1)] 0).isSome = true := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeGemmCell](../Analysis.md#decl-6eee488b36c50d94)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e517a47b8f995a4f"></a>

<details>
<summary><code>TensorCore.Regression.analysis_exact_product_alignment</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L63)

```lean
theorem analysis_exact_product_alignment :
    rawAlignmentBudget (rawMul ⟨-1024, 0, 10⟩ ⟨1024, 1, 10⟩) (-22) = 0 ∧
    rawAlignmentBudget (rawMul ⟨1024, -12, 10⟩ ⟨1024, -12, 10⟩) (-24) = 0 ∧
    rawAlignmentBudget (rawMul ⟨1024, -12, 10⟩ ⟨1024, -12, 10⟩) (-23) = pow2 (-23) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawAlignmentBudget](../../TC/Program/Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-18dc193709d671fa"></a>

<details>
<summary><code>TensorCore.Regression.analysis_witness_rejects_mutations</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmAnalysis.lean#L68)

```lean
theorem analysis_witness_rejects_mutations :
    checkGemmCell .v100 [(0x3c00, 0x4000)] 0 [] = none ∧
    checkGemmCell .v100 [(0x3c00, 0x4000)] 0 (List.replicate 4 ⟨-126, 0⟩) = none ∧
    checkGemmCell .v100 [(0x3c00, 0x4000)] 0 (List.replicate 4 ⟨1, -126⟩) = none ∧
    checkGemmCell .hopper [(0x3c00, 0x4000)] 0 (List.replicate 2 ⟨1, 1⟩) = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.checkGemmCell](../Analysis.md#decl-b2d9a6ca1b8ee691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
