# TensorCore.Gemm.InputBounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2fa90183da38c041"></a>

<details>
<summary><code>TensorCore.sourceGemmPairs</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L11)

```lean
/-- The original row/column operands, before any input conversion or padding. -/
def sourceGemmPairs (source : Format) (A : DenseMatrix (BitVec source.width) m k)
    (B : DenseMatrix (BitVec source.width) k n) (i : Fin m) (j : Fin n) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceCertificate_acceptance](InputBounds.md#decl-65084421def64cb7), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

</details>

</details>

<a id="decl-143ccf0aa454df6c"></a>

<details>
<summary><code>TensorCore.sourceGemmProducts</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L16)

```lean
/-- Independent original-bit dot product: decode and sum, with no conversion. -/
def sourceGemmProducts (source : Format) : List (BitVec source.width × BitVec source.width) → Option ℚ
  | [] => some 0
  | (a, b) :: rest => do
    let av ← binaryValue source a
    let bv ← binaryValue source b
    let tail ← sourceGemmProducts source rest
    return av * bv + tail
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b), [TensorCore.sourceGemmCellIdeal](InputBounds.md#decl-24f836f23596682e), [TensorCore.sourceGemmProducts_eq_idealProducts](InputBounds.md#decl-1c676a2d69d32e7d)

</details>

</details>

<a id="decl-24f836f23596682e"></a>

<details>
<summary><code>TensorCore.sourceGemmCellIdeal</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L24)

```lean
def sourceGemmCellIdeal (source : Format) (alpha beta c : F32)
    (pairs : List (BitVec source.width × BitVec source.width)) : Option ℚ := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let p ← sourceGemmProducts source pairs
  return a * p + b * cv
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.source_input_loss_matters](Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

</details>

</details>

<a id="decl-f22289384470bd38"></a>

<details>
<summary><code>TensorCore.sourceGemmIdeal</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L32)

```lean
def sourceGemmIdeal (source : Format) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => sourceGemmCellIdeal source alpha beta C[i.val][j.val]
    (sourceGemmPairs source A B i j)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.sourceGemmCellIdeal](InputBounds.md#decl-24f836f23596682e), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.convertedAnalysisCheck_matrix_error](ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

</details>

</details>

<a id="decl-8b1ea358e6bcaa87"></a>

<details>
<summary><code>TensorCore.GemmInputDatum</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L38)

```lean
structure GemmInputDatum where
  value : ℚ
  converted : ℚ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.GemmInputDatum.error](InputBounds.md#decl-8d5afe3c429da546), [TensorCore.Regression.input_modes_and_signs](Regression/GemmInputConversion.md#decl-2eff5e907eb91aa6), [TensorCore.Regression.input_range_and_special_rejections](Regression/GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.subnormal_cross_term](Regression/GemmInputConversion.md#decl-cea5bdaa327d80b0), [TensorCore.gemmInputDatum](InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputDatum_error_le](InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputDatum_of_conversion](InputBounds.md#decl-63322710811f0233), [TensorCore.gemmInputPairError](InputBounds.md#decl-85a247fb58310475), [TensorCore.gemmInputPairError_bound](InputBounds.md#decl-0b206d7ac67403b7), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83), [TensorCore.gemmInputPairTightError_bound](TightInputBounds.md#decl-251c676d4c121cd6), [TensorCore.gemmInputPairTightError_le](TightInputBounds.md#decl-8ffbd0992c010ee1), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.inputDatumTo](MatrixConversion.md#decl-79dff1e7ec8731f0), [TensorCore.inputDatumTo_of_conversion](MatrixConversion.md#decl-d34ea96a86529b47), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b)

</details>

</details>

<a id="decl-8d5afe3c429da546"></a>

<details>
<summary><code>TensorCore.GemmInputDatum.error</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L43)

```lean
def GemmInputDatum.error (d : GemmInputDatum) : ℚ := absQ (d.value - d.converted)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

<details>
<summary>Used by</summary>

[TensorCore.gemmInputDatum_error_le](InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputPairError](InputBounds.md#decl-85a247fb58310475), [TensorCore.gemmInputPairError_bound](InputBounds.md#decl-0b206d7ac67403b7), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83), [TensorCore.gemmInputPairTightError_bound](TightInputBounds.md#decl-251c676d4c121cd6), [TensorCore.gemmInputPairTightError_le](TightInputBounds.md#decl-8ffbd0992c010ee1)

</details>

</details>

<a id="decl-228cfe81593bf2a2"></a>

<details>
<summary><code>TensorCore.gemmInputDatum</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L46)

```lean
/-- Input-only information; a failed conversion remains a rejection. -/
def gemmInputDatum (source : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) : Option GemmInputDatum := do
  let x ← binaryValue source bits
  let y ← (ConversionStage.mk fp16 mode).convert x
  return ⟨x, y.value⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd)

<details>
<summary>Used by</summary>

[TensorCore.Regression.input_modes_and_signs](Regression/GemmInputConversion.md#decl-2eff5e907eb91aa6), [TensorCore.Regression.input_range_and_special_rejections](Regression/GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.subnormal_cross_term](Regression/GemmInputConversion.md#decl-cea5bdaa327d80b0), [TensorCore.gemmInputDatum_error_le](InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputDatum_of_conversion](InputBounds.md#decl-63322710811f0233), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2)

</details>

</details>

<a id="decl-85a247fb58310475"></a>

<details>
<summary><code>TensorCore.gemmInputPairError</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L53)

```lean
/-- Both operand perturbations and their cross term are required. -/
def gemmInputPairError (a b : GemmInputDatum) : ℚ :=
  absQ a.value * b.error + absQ b.value * a.error + a.error * b.error
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.GemmInputDatum.error](InputBounds.md#decl-8d5afe3c429da546), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

<details>
<summary>Used by</summary>

[TensorCore.gemmInputPairError_bound](InputBounds.md#decl-0b206d7ac67403b7), [TensorCore.gemmInputPairTightError_le](TightInputBounds.md#decl-8ffbd0992c010ee1), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4)

</details>

</details>

<a id="decl-44a67c4ea7aef5c8"></a>

<details>
<summary><code>TensorCore.gemmInputProductError</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L56)

```lean
def gemmInputProductError (source : Format) (mode : BinaryRoundingMode) :
    List (BitVec source.width × BitVec source.width) → Option ℚ
  | [] => some 0
  | (a, b) :: rest => do
    let av ← gemmInputDatum source mode a
    let bv ← gemmInputDatum source mode b
    let tail ← gemmInputProductError source mode rest
    return gemmInputPairError av bv + tail
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.gemmInputDatum](InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputPairError](InputBounds.md#decl-85a247fb58310475), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Regression.exact_conversion_and_zero_loss](Regression/GemmInputConversion.md#decl-8a42b37a2ff8769e), [TensorCore.Regression.source_empty_dimensions](Regression/GemmInputConversion.md#decl-3bbb9c3194b7241f), [TensorCore.Regression.subnormal_cross_term](Regression/GemmInputConversion.md#decl-cea5bdaa327d80b0), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertedGemmCellSourceError](InputBounds.md#decl-c6688c492e9e6923), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4)

</details>

</details>

<a id="decl-c6688c492e9e6923"></a>

<details>
<summary><code>TensorCore.convertedGemmCellSourceError</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L67)

```lean
/-- Add original-input conversion loss to the existing complete pipeline budget.
This function never computes the original or converted exact dot product. -/
def convertedGemmCellSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (pairs : List (BitVec source.width × BitVec source.width)) : Option ℚ := do
  let a ← value32 alpha
  let inputError ← gemmInputProductError source mode pairs
  return scaledGemmStaticError model cfg b alpha pairs.length + absQ a * inputError
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.negative_alpha_source_bound](Regression/GemmInputConversion.md#decl-8ffd66ebf0b6eae9), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4)

</details>

</details>

<a id="decl-b36e79035e2aa2b4"></a>

<details>
<summary><code>TensorCore.convertedGemmSourceError</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L74)

```lean
def convertedGemmSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n) :
    DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => convertedGemmCellSourceError source mode model cfg b alpha
    (sourceGemmPairs source A B i j)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmCellSourceError](InputBounds.md#decl-c6688c492e9e6923), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceCertificate_acceptance](InputBounds.md#decl-65084421def64cb7), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6)

</details>

</details>

<a id="decl-1c676a2d69d32e7d"></a>

<details>
<summary><code>TensorCore.sourceGemmProducts_eq_idealProducts</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L81)

```lean
theorem sourceGemmProducts_eq_idealProducts (p : Profile) (xs : List (p.Word × p.Word)) :
    sourceGemmProducts p.input xs = idealProducts p xs := by
  induction xs with
  | nil => rfl
  | cons pair rest ih =>
    obtain ⟨a, b⟩ := pair
    change sourceGemmProducts p.input ((a, b) :: rest) = idealProducts p ([(a, b)] ++ rest)
    rw [idealProducts_append]
    simp only [sourceGemmProducts, ih]
    cases ha : (classify p.input a).finite <;> cases hb : (classify p.input b).finite <;>
      simp [binaryValue, idealProducts, prepareProducts, Profile.decode, ha, hb, sumQ, Rat.add_zero]
```

**Supporting proofs:** [TensorCore.idealProducts_append](../TC/Program/DotProduct.md#decl-623f08595b227aca)

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.prepareProducts](../TC/Block.md#decl-90abac48864edcd2), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkNativeScaledCell_sound](NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c)

</details>

</details>

<a id="decl-63322710811f0233"></a>

<details>
<summary><code>TensorCore.gemmInputDatum_of_conversion</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L93)

```lean
theorem gemmInputDatum_of_conversion (source : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (output : F16)
    (h : convertGemmWord source fp16 mode input = some output) :
    ∃ d, gemmInputDatum source mode input = some d ∧
      binaryValue source input = some d.value ∧ binaryValue fp16 output = some d.converted := by
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, hx, y, hy, he⟩ := h
  cases Option.some.inj he
  refine ⟨⟨x, y.value⟩, by simp [gemmInputDatum, hx, hy], hx, ?_⟩
  simp [binaryValue, y.valid, FiniteBinary.value]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.gemmInputDatum](InputBounds.md#decl-228cfe81593bf2a2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2)

</details>

</details>

<a id="decl-6e5aac7e5b718d88"></a>

<details>
<summary><code>TensorCore.gemmInputDatum_error_le</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L106)

```lean
/-- The data-dependent deviation also satisfies the generic grid-spacing bound
when an original-value magnitude cap is supplied, in all four input modes. -/
theorem gemmInputDatum_error_le (source : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (d : GemmInputDatum)
    (h : gemmInputDatum source mode input = some d) (E : ℤ)
    (hE : fp16.emin ≤ E) (hx : absQ d.value ≤ pow2 E) :
    d.error ≤ gemmConversionError fp16 E := by
  simp only [gemmInputDatum, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, _, y, hy, he⟩ := h
  cases Option.some.inj he
  exact gemmConversion_error ⟨fp16, mode⟩ E hE x hx y hy
```

**Supporting proofs:** [TensorCore.gemmConversion_error](ConversionBounds.md#decl-e310928c2b037b3f)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.GemmInputDatum.error](InputBounds.md#decl-8d5afe3c429da546), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmInputDatum](InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0b206d7ac67403b7"></a>

<details>
<summary><code>TensorCore.gemmInputPairError_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L116)

```lean
theorem gemmInputPairError_bound (a b : GemmInputDatum) :
    absQ (a.value * b.value - a.converted * b.converted) ≤ gemmInputPairError a b := by
  have h1 := absQ_add_le (a.value * (b.value - b.converted))
    (b.value * (a.value - a.converted))
  have h2 := absQ_add_le
    (a.value * (b.value - b.converted) + b.value * (a.value - a.converted))
    (-((a.value - a.converted) * (b.value - b.converted)))
  rw [absQ_neg, gemmAbs_mul] at h2
  rw [gemmAbs_mul, gemmAbs_mul] at h1
  unfold gemmInputPairError GemmInputDatum.error
  grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.gemmAbs_mul](ScaledGemm.md#decl-be05cc60206155ae)

**Definitions and types:** [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.GemmInputDatum.error](InputBounds.md#decl-8d5afe3c429da546), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmInputPairError](InputBounds.md#decl-85a247fb58310475)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4)

</details>

</details>

<a id="decl-5c6d092f063552e4"></a>

<details>
<summary><code>TensorCore.gemmInputProductError_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L130)

```lean
/-- Conversion perturbations compose over the actual ordered operands; the source
ideal remains independent of the conversions used to derive the bound. -/
theorem gemmInputProductError_bound (source : Format) (mode : BinaryRoundingMode)
    (xs : List ι) (input : ι → BitVec source.width × BitVec source.width)
    (output : ι → F16 × F16)
    (h : ∀ x ∈ xs,
      convertGemmWord source fp16 mode (input x).1 = some (output x).1 ∧
      convertGemmWord source fp16 mode (input x).2 = some (output x).2) :
    ∃ s p e, sourceGemmProducts source (xs.map input) = some s ∧
      sourceGemmProducts fp16 (xs.map output) = some p ∧
      gemmInputProductError source mode (xs.map input) = some e ∧ absQ (s - p) ≤ e := by
  induction xs with
  | nil => exact ⟨0, 0, 0, rfl, rfl, rfl, by decide +kernel⟩
  | cons x xs ih =>
    obtain ⟨ha, hb⟩ := h x (by simp)
    obtain ⟨a, had, hav, hac⟩ := gemmInputDatum_of_conversion source mode _ _ ha
    obtain ⟨b, hbd, hbv, hbc⟩ := gemmInputDatum_of_conversion source mode _ _ hb
    obtain ⟨s, p, e, hs, hp, he, hbnd⟩ := ih (by intro y hy; exact h y (by simp [hy]))
    refine ⟨a.value * b.value + s, a.converted * b.converted + p,
      gemmInputPairError a b + e, ?_, ?_, ?_, ?_⟩
    · simp [sourceGemmProducts, hav, hbv, hs]
    · simp [sourceGemmProducts, hac, hbc, hp]
    · simp [gemmInputProductError, had, hbd, he]
    · have ht := absQ_add_le (a.value * b.value - a.converted * b.converted) (s - p)
      have hx := gemmInputPairError_bound a b
      grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.gemmInputDatum_of_conversion](InputBounds.md#decl-63322710811f0233), [TensorCore.gemmInputPairError_bound](InputBounds.md#decl-0b206d7ac67403b7)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.gemmInputDatum](InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputPairError](InputBounds.md#decl-85a247fb58310475), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25)

</details>

</details>

<a id="decl-16fc2b35730daa25"></a>

<details>
<summary><code>TensorCore.convertGemmInput_products_error</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L155)

```lean
theorem convertGemmInput_products_error (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (a : DenseMatrix F16 m k) (b : DenseMatrix F16 k n)
    (ha : convertGemmInput source mode A = some a) (hb : convertGemmInput source mode B = some b)
    (i : Fin m) (j : Fin n) :
    ∃ s p e, sourceGemmProducts source (sourceGemmPairs source A B i j) = some s ∧
      idealProducts v100F16F32 (gemmPairs a b i j) = some p ∧
      gemmInputProductError source mode (sourceGemmPairs source A B i j) = some e ∧
      absQ (s - p) ≤ e := by
  have h := gemmInputProductError_bound source mode (List.finRange k)
    (fun l : Fin k => (A[i.val][l.val], B[l.val][j.val]))
    (fun l : Fin k => (a[i.val][l.val], b[l.val][j.val]))
    (by intro l _; exact ⟨convertGemmInput_entry source mode A a ha i l,
      convertGemmInput_entry source mode B b hb l j⟩)
  obtain ⟨s, p, e, hs, hp, he, hbound⟩ := h
  refine ⟨s, p, e, ?_, ?_, ?_, hbound⟩
  · simpa [List.finRange, List.map_ofFn, Function.comp_def, sourceGemmPairs] using hs
  · have hp' : sourceGemmProducts fp16 (gemmPairs a b i j) = some p := by
      simpa [List.finRange, List.map_ofFn, Function.comp_def, gemmPairs] using hp
    exact (sourceGemmProducts_eq_idealProducts v100F16F32 _).symm.trans hp'
  · simpa [List.finRange, List.map_ofFn, Function.comp_def, sourceGemmPairs] using he
```

**Supporting proofs:** [TensorCore.convertGemmInput_entry](ScaledGemm.md#decl-fa0fab71bf8fc712), [TensorCore.gemmInputProductError_bound](InputBounds.md#decl-5c6d092f063552e4), [TensorCore.sourceGemmProducts_eq_idealProducts](InputBounds.md#decl-1c676a2d69d32e7d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514)

</details>

</details>

<a id="decl-7a3b7a6efc84a1d7"></a>

<details>
<summary><code>TensorCore.gemmSourceError_propagate</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L179)

```lean
/-- Propagate conversion error through alpha and add the already certified
tensor-core/epilogue budget. Beta*C is unchanged by A/B input conversion. -/
theorem gemmSourceError_propagate (alpha beta c source converted output inputError E : ℚ)
    (hi : absQ (source - converted) ≤ inputError)
    (he : absQ (alpha * converted + beta * c - output) ≤ E) :
    absQ (alpha * source + beta * c - output) ≤ E + absQ alpha * inputError := by
  have hm := Rat.mul_le_mul_of_nonneg_left hi (absQ_nonneg alpha)
  rw [← gemmAbs_mul] at hm
  have ht := absQ_add_le (alpha * (source - converted))
    (alpha * converted + beta * c - output)
  grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.gemmAbs_mul](ScaledGemm.md#decl-be05cc60206155ae)

**Definitions and types:** [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58)

</details>

</details>

<a id="decl-82c7f6139915a514"></a>

<details>
<summary><code>TensorCore.convertedGemmCheck_source_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L192)

```lean
/-- An unchanged accepted input certificate proves every output exists and bounds
its error against alpha*A*B+beta*C decoded from the original source-format words.
No successful run, exact-sum bound, or conversion-error bound is a premise. -/
theorem convertedGemmCheck_source_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n)
    (h : convertedGemmCheck source mode model cfg b alpha beta A B C = true) :
    ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z E,
        D[i.val][j.val] = some t ∧ (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E ∧
        absQ (z - t.output.value) ≤ E := by
  obtain ⟨a, b', ha, hb, hr, entries⟩ := convertedGemmCheck_sound source mode model cfg b alpha beta A B C h
  refine ⟨scaledGemm model cfg alpha beta a b' C, hr, ?_⟩
  intro i j
  obtain ⟨t, z, ht, hz, he⟩ := entries i j
  obtain ⟨s, p, e, hs, hp, herr, hbound⟩ := convertGemmInput_products_error source mode A B a b' ha hb i j
  simp only [scaledGemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, scaledGemmCellIdeal,
    bind, pure, Option.bind_eq_some_iff] at hz
  obtain ⟨av, hav, bv, hbv, cv, hcv, p', hp', hz⟩ := hz
  rw [hp] at hp'
  cases Option.some.inj hp'
  cases Option.some.inj hz
  refine ⟨t, av * s + bv * cv, scaledGemmStaticError model cfg b alpha k + absQ av * e,
    ht, ?_, ?_, ?_⟩
  · simp [sourceGemmIdeal, DenseMatrix.ofFn, sourceGemmCellIdeal, hav, hbv, hcv, hs]
  · simp only [convertedGemmSourceError, DenseMatrix.ofFn, Vector.getElem_ofFn]
    simp only [convertedGemmCellSourceError, hav, bind, pure, Option.bind_some, herr]
    simp [sourceGemmPairs]
  · exact gemmSourceError_propagate av bv cv s p t.output.value e _ hbound he
```

**Supporting proofs:** [TensorCore.convertGemmInput_products_error](InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.gemmSourceError_propagate](InputBounds.md#decl-7a3b7a6efc84a1d7)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCellSourceError](InputBounds.md#decl-c6688c492e9e6923), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.gemmInputProductError](InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.sourceGemmCellIdeal](InputBounds.md#decl-24f836f23596682e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6)

</details>

</details>

<a id="decl-f68879ebd2a77165"></a>

<details>
<summary><code>TensorCore.convertedGemmSourceCertificate</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L224)

```lean
/-- Return source-relative entry bounds exactly when the existing checker accepts.
The soundness theorem proves every selected bound is present, so getD's default
is unreachable at an accepted logical entry. No arithmetic output is substituted. -/
def convertedGemmSourceCertificate (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix ℚ m n) :=
  if convertedGemmCheck source mode model cfg b alpha beta A B C then
    some (DenseMatrix.ofFn fun i j =>
      ((convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val]).getD 0)
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Regression.input_range_and_special_rejections](Regression/GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.source_empty_dimensions](Regression/GemmInputConversion.md#decl-3bbb9c3194b7241f), [TensorCore.Regression.source_input_loss_matters](Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.tight_source_budget](../Regression/FoundationCompletion.md#decl-24341707319a2042), [TensorCore.convertedGemmSourceCertificate_acceptance](InputBounds.md#decl-65084421def64cb7), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6)

</details>

</details>

<a id="decl-65084421def64cb7"></a>

<details>
<summary><code>TensorCore.convertedGemmSourceCertificate_acceptance</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L233)

```lean
theorem convertedGemmSourceCertificate_acceptance (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemmSourceCertificate source mode model cfg b alpha beta A B C).isSome =
      convertedGemmCheck source mode model cfg b alpha beta A B C := by
  cases h : convertedGemmCheck source mode model cfg b alpha beta A B C <;>
    simp [convertedGemmSourceCertificate, h]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-07b8c70e183a7fd6"></a>

<details>
<summary><code>TensorCore.convertedGemmSourceCertificate_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L242)

```lean
theorem convertedGemmSourceCertificate_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix ℚ m n)
    (h : convertedGemmSourceCertificate source mode model cfg b alpha beta A B C = some E) :
    ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z,
        D[i.val][j.val] = some t ∧ (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E[i.val][j.val] ∧
        absQ (z - t.output.value) ≤ E[i.val][j.val] := by
  cases hc : convertedGemmCheck source mode model cfg b alpha beta A B C with
  | false => simp [convertedGemmSourceCertificate, hc] at h
  | true =>
    simp only [convertedGemmSourceCertificate, hc, ↓reduceIte] at h
    cases Option.some.inj h
    obtain ⟨D, hr, entries⟩ := convertedGemmCheck_source_sound source mode model cfg b alpha beta A B C hc
    refine ⟨D, hr, ?_⟩
    intro i j
    obtain ⟨t, z, e, ht, hz, he, hbound⟩ := entries i j
    refine ⟨t, z, ht, hz, ?_, ?_⟩
    · simp only [DenseMatrix.ofFn, Vector.getElem_ofFn, he, Option.getD_some]
    · simpa only [DenseMatrix.ofFn, Vector.getElem_ofFn, he, Option.getD_some] using hbound
```

**Supporting proofs:** [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384)

</details>

</details>

<a id="decl-da38b637ee97bcc3"></a>

<details>
<summary><code>TensorCore.input_sum_mono</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L265)

```lean
private theorem input_sum_mono (xs : List ι) (f g : ι → ℚ)
    (h : ∀ x ∈ xs, f x ≤ g x) : sumQ (xs.map f) ≤ sumQ (xs.map g) := by
  induction xs with
  | nil => exact Rat.le_refl
  | cons x xs ih =>
    have hh := h x (by simp)
    have ht := ih (by intro y hy; exact h y (by simp [hy]))
    simp only [List.map_cons, sumQ]
    grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.input_sumFn_mono](InputBounds.md#decl-dc26ce7dbc7b97a5)

</details>

</details>

<a id="decl-dc26ce7dbc7b97a5"></a>

<details>
<summary><code>TensorCore.input_sumFn_mono</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L275)

```lean
private theorem input_sumFn_mono (f g : Fin k → ℚ) (h : ∀ i, f i ≤ g i) :
    sumQ (List.ofFn f) ≤ sumQ (List.ofFn g) := by
  have hs := input_sum_mono (List.finRange k) f g (fun i _ => h i)
  simpa [List.finRange, List.map_ofFn, Function.comp_def] using hs
```

**Supporting proofs:** [TensorCore.input_sum_mono](InputBounds.md#decl-da38b637ee97bcc3)

**Definitions and types:** [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

</details>

</details>

<a id="decl-46e7ff540915c07d"></a>

<details>
<summary><code>TensorCore.matrixAbsSum_le_entry_bounds</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L281)

```lean
/-- Sum varying entry budgets, rather than multiplying by a worst-case entry. -/
theorem matrixAbsSum_le_entry_bounds (X E : DenseMatrix ℚ m n)
    (h : ∀ i : Fin m, ∀ j : Fin n, absQ X[i.val][j.val] ≤ E[i.val][j.val]) :
    matrixAbsSum X ≤ matrixAbsSum E := by
  apply input_sumFn_mono
  intro i
  apply input_sumFn_mono
  intro j
  have he : E[i.val][j.val] ≤ absQ E[i.val][j.val] :=
    ((absQ_le_iff _ _).mp Rat.le_refl).2
  exact Rat.le_trans (h i j) he
```

**Supporting proofs:** [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.input_sumFn_mono](InputBounds.md#decl-dc26ce7dbc7b97a5)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.analyzeConvertedGemm_matrix_error](ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeGemm_matrix_error](Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeGemm_matrix_error](NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544)

</details>

</details>

<a id="decl-7954eea10de74384"></a>

<details>
<summary><code>TensorCore.convertedGemmSourceCertificate_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/InputBounds.lean#L295)

```lean
/-- Input-only acceptance proves the entrywise 1-norm guarantee against the
original source ideal. The projection premises merely identify decoded matrices;
neither successful execution nor an accuracy bound is assumed. -/
theorem convertedGemmSourceCertificate_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix ℚ m n)
    (h : convertedGemmSourceCertificate source mode model cfg b alpha beta A B C = some E)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum E := by
  obtain ⟨out, hr, entries⟩ := convertedGemmSourceCertificate_sound source mode model cfg b alpha beta A B C E h
  apply matrixAbsSum_le_entry_bounds
  intro i j
  obtain ⟨t, z, ht, hi, _, he⟩ := entries i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa only [DenseMatrix.ofFn, Vector.getElem_ofFn, hd out hr i j t ht] using he
```

**Supporting proofs:** [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
