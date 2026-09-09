# TensorCore.Gemm.Regression.PipelineAnalysis

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-747a27e8d73c97ce"></a>

<details>
<summary><code>TensorCore.Regression.sourceAnalysisA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L10)

```lean
def sourceAnalysisA : DenseMatrix (BitVec fp32.width) 1 1 := #v[#v[0xbf801000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scaled_analysis_source_accuracy](PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.sourceWitness](PipelineAnalysis.md#decl-ecc471cc02f088b1)

</details>

</details>

<a id="decl-ccd0904d2b4257e2"></a>

<details>
<summary><code>TensorCore.Regression.sourceAnalysisB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L11)

```lean
def sourceAnalysisB : DenseMatrix (BitVec fp32.width) 1 1 := #v[#v[0x3f801000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scaled_analysis_source_accuracy](PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.sourceWitness](PipelineAnalysis.md#decl-ecc471cc02f088b1)

</details>

</details>

<a id="decl-fbc4574a9c90079d"></a>

<details>
<summary><code>TensorCore.Regression.sourceAnalysisC</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L12)

```lean
def sourceAnalysisC : DenseMatrix F32 1 1 := #v[#v[0]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scaled_analysis_source_accuracy](PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.sourceWitness](PipelineAnalysis.md#decl-ecc471cc02f088b1)

</details>

</details>

<a id="decl-5ff48bc22675dcf3"></a>

<details>
<summary><code>TensorCore.Regression.analysisEpilogue</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L13)

```lean
def analysisEpilogue (mode : BinaryRoundingMode) : GemmEpilogue := ⟨mode, mode, ⟨fp32, mode⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scaled_analysis_empty_output_still_converts](PipelineAnalysis.md#decl-f9edf42bc23be958), [TensorCore.Regression.scaled_analysis_finite_rejection](PipelineAnalysis.md#decl-c163cf5fae20f854), [TensorCore.Regression.scaled_analysis_fp32_output_exact](PipelineAnalysis.md#decl-11515fce5906431f), [TensorCore.Regression.scaled_analysis_source_accuracy](PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.Regression.scaled_analysis_subnormal](PipelineAnalysis.md#decl-909c54c1801f1bd8), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](PipelineAnalysis.md#decl-d4de6903f5bc1896), [TensorCore.Regression.scaled_analysis_zero](PipelineAnalysis.md#decl-110688352cbe87bb), [TensorCore.Regression.sourceWitness](PipelineAnalysis.md#decl-ecc471cc02f088b1)

</details>

</details>

<a id="decl-ecc471cc02f088b1"></a>

<details>
<summary><code>TensorCore.Regression.sourceWitness</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L15)

```lean
def sourceWitness (model : WmmaGemmModel) (mode : BinaryRoundingMode) : DenseMatrix ScaledWitness 1 1 :=
  let cells := (analyzeConvertedGemm fp32 mode model (analysisEpilogue mode) 0x3f800000 0
    sourceAnalysisA sourceAnalysisB sourceAnalysisC).getD #v[#v[none]]
  cells.map fun row => row.map fun a => (a.map (·.witness)).getD ⟨[], ⟨0, 0, 0, 0⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EpilogueWitness](../ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.Regression.sourceAnalysisA](PipelineAnalysis.md#decl-747a27e8d73c97ce), [TensorCore.Regression.sourceAnalysisB](PipelineAnalysis.md#decl-ccd0904d2b4257e2), [TensorCore.Regression.sourceAnalysisC](PipelineAnalysis.md#decl-fbc4574a9c90079d), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](../ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeConvertedGemm](../ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scaled_analysis_source_accuracy](PipelineAnalysis.md#decl-9a63f184d49e2c7e), [TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls](PipelineAnalysis.md#decl-d4de6903f5bc1896)

</details>

</details>

<a id="decl-9a63f184d49e2c7e"></a>

<details>
<summary><code>TensorCore.Regression.scaled_analysis_source_accuracy</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L20)

```lean
theorem scaled_analysis_source_accuracy (model : WmmaGemmModel) (mode : BinaryRoundingMode) :
    ConvertedGemmAccurate fp32 mode model (analysisEpilogue mode) 0x3f800000 0
      sourceAnalysisA sourceAnalysisB sourceAnalysisC (1 / 100) := by
  apply convertedAnalysisCheck_sound fp32 mode model (analysisEpilogue mode) 0x3f800000 0
    sourceAnalysisA sourceAnalysisB sourceAnalysisC (sourceWitness model mode)
  cases model <;> cases mode <;> decide +kernel
```

**Supporting proofs:** [TensorCore.convertedAnalysisCheck_sound](../ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConvertedGemmAccurate](../ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.Regression.sourceAnalysisA](PipelineAnalysis.md#decl-747a27e8d73c97ce), [TensorCore.Regression.sourceAnalysisB](PipelineAnalysis.md#decl-ccd0904d2b4257e2), [TensorCore.Regression.sourceAnalysisC](PipelineAnalysis.md#decl-fbc4574a9c90079d), [TensorCore.Regression.sourceWitness](PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedAnalysisCheck](../ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d4de6903f5bc1896"></a>

<details>
<summary><code>TensorCore.Regression.scaled_analysis_tolerance_and_witness_controls</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L27)

```lean
theorem scaled_analysis_tolerance_and_witness_controls :
    convertedAnalysisCheck fp32 .nearestEven .v100 (analysisEpilogue .nearestEven) 0x3f800000 0
      sourceAnalysisA sourceAnalysisB sourceAnalysisC (sourceWitness .v100 .nearestEven) 0 = false ∧
    convertedAnalysisCheck fp32 .nearestEven .v100 (analysisEpilogue .nearestEven) 0x3f800000 0
      sourceAnalysisA sourceAnalysisB sourceAnalysisC #v[#v[⟨[], ⟨1, -126, 1, 1⟩⟩]] 1 = false := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.EpilogueWitness](../ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.Regression.sourceAnalysisA](PipelineAnalysis.md#decl-747a27e8d73c97ce), [TensorCore.Regression.sourceAnalysisB](PipelineAnalysis.md#decl-ccd0904d2b4257e2), [TensorCore.Regression.sourceAnalysisC](PipelineAnalysis.md#decl-fbc4574a9c90079d), [TensorCore.Regression.sourceWitness](PipelineAnalysis.md#decl-ecc471cc02f088b1), [TensorCore.ScaledWitness](../ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedAnalysisCheck](../ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-110688352cbe87bb"></a>

<details>
<summary><code>TensorCore.Regression.scaled_analysis_zero</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L34)

```lean
theorem scaled_analysis_zero (mode : BinaryRoundingMode) :
    (analyzeScaledCell .hopper (analysisEpilogue mode) 0x3f800000 0x80000000 0x80000000
      [(0x8000, 0)]).map (fun a => a.bound.error) = some 0 := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PipelineBound.error](../ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeScaledCell](../ScaledGemmAnalysis.md#decl-41a297c61c8a49d2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-909c54c1801f1bd8"></a>

<details>
<summary><code>TensorCore.Regression.scaled_analysis_subnormal</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L39)

```lean
theorem scaled_analysis_subnormal (mode : BinaryRoundingMode) :
    (analyzeScaledCell .ampere (analysisEpilogue mode) 0x3f800000 0 0 [(0x8001, 1)]).isSome = true := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeScaledCell](../ScaledGemmAnalysis.md#decl-41a297c61c8a49d2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-11515fce5906431f"></a>

<details>
<summary><code>TensorCore.Regression.scaled_analysis_fp32_output_exact</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L43)

```lean
theorem scaled_analysis_fp32_output_exact (mode : BinaryRoundingMode) :
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x3f800000 0x3f800000 0xff7fffff []).map
      (fun a => a.bound.outputRounding) = some 0 := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PipelineBound](../ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeScaledCell](../ScaledGemmAnalysis.md#decl-41a297c61c8a49d2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c163cf5fae20f854"></a>

<details>
<summary><code>TensorCore.Regression.scaled_analysis_finite_rejection</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L48)

```lean
theorem scaled_analysis_finite_rejection (mode : BinaryRoundingMode) :
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x40000000 0 0 [(0x7bff, 0x7bff)]).isSome = true ∧
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x7f7fffff 0 0 [(0x4000, 0x3c00)]).isSome = false ∧
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0x7f800000 0 0 []).isSome = false ∧
    (analyzeScaledCell .v100 (analysisEpilogue mode) 0 0 0x7fc00000 []).isSome = false := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeScaledCell](../ScaledGemmAnalysis.md#decl-41a297c61c8a49d2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f9edf42bc23be958"></a>

<details>
<summary><code>TensorCore.Regression.scaled_analysis_empty_output_still_converts</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L55)

```lean
theorem scaled_analysis_empty_output_still_converts :
    (analyzeConvertedGemm fp32 .towardZero .v100 (analysisEpilogue .nearestEven) 0 0
      (#v[#v[0x7fc00000]] : DenseMatrix (BitVec fp32.width) 1 1)
      (#v[#v[]] : DenseMatrix (BitVec fp32.width) 1 0)
      (#v[#v[]] : DenseMatrix F32 1 0)).isSome = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Regression.analysisEpilogue](PipelineAnalysis.md#decl-5ff48bc22675dcf3), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeConvertedGemm](../ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-314a8146be1eee9e"></a>

<details>
<summary><code>TensorCore.Regression.scalar_analysis_range_boundary</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/PipelineAnalysis.lean#L61)

```lean
theorem scalar_analysis_range_boundary :
    (checkScalar ⟨fp32, .towardZero⟩ fp32.maxFinite 128).isSome = true ∧
    (checkScalar ⟨fp32, .towardZero⟩ (fp32.maxFinite + 1) 128).isSome = false ∧
    (checkScalar ⟨fp32, .nearestEven⟩ 1 (-126)).isSome = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.ScalarBound](../ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.checkScalar](../ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
