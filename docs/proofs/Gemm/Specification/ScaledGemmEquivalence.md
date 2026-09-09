# TensorCore.Gemm.Specification.ScaledGemmEquivalence

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0d7d7612b2b29253"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarStageOf</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L10)

```lean
@[implicit_reducible] def scalarStageOf (s : ConversionStage) : ScalarStage := ⟨layoutOf s.format, scalarModeOf s.mode⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

</details>

</details>

<a id="decl-1e5f134635c2454c"></a>

<details>
<summary><code>TensorCore.PaperSpec.epilogueOf</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L11)

```lean
@[implicit_reducible] def epilogueOf (cfg : GemmEpilogue) : ScalarEpilogue :=
  ⟨scalarModeOf cfg.multiplyMode, scalarModeOf cfg.addMode, scalarStageOf cfg.output⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarStageOf](ScaledGemmEquivalence.md#decl-0d7d7612b2b29253)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-f61ab03b10876eb6"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarConvert_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L14)

```lean
theorem scalarConvert_eq (s : ConversionStage) (x : ℚ) :
    scalarConvert (scalarStageOf s) x = (s.convert x).map (fun d => (d.bits, d.value)) := by
  simp only [scalarConvert, scalarStageOf, scalarRound_eq, bind, pure]
  simp only [scalarValue_eq]
  cases hr : roundBinary s.format s.mode x with
  | none => simp [ConversionStage.convert, hr, Option.bind_none]
  | some bits =>
    cases hd : (classify s.format bits).finite with
    | none => simp [ConversionStage.convert, hr, binaryValue, hd, finiteBinary_none hd, Option.bind_some]
    | some d => simp [ConversionStage.convert, hr, binaryValue, hd, finiteBinary_some hd, FiniteBinary.value, Option.bind_some]
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarRound_eq](ScalarRounding.md#decl-dac12f3fa291169b), [TensorCore.PaperSpec.scalarValue_eq](ScalarRounding.md#decl-5f6e455aabd909c4), [TensorCore.finiteBinary_none](../../Core/Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](../../Core/Conversion.md#decl-66e4132ec74cac83)

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarConvert](Scalar.md#decl-7cff21b148b8dfab), [TensorCore.PaperSpec.scalarRound](Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.PaperSpec.scalarStageOf](ScaledGemmEquivalence.md#decl-0d7d7612b2b29253), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](../../Core/Conversion.md#decl-4947fce7ecea0c20), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

</details>

</details>

<a id="decl-13632aec059d0b49"></a>

<details>
<summary><code>TensorCore.PaperSpec.conversionStage_bits_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L25)

```lean
theorem conversionStage_bits_eq (s : ConversionStage) (x : ℚ) :
    (s.convert x).map FiniteBinary.bits = roundBinary s.format s.mode x := by
  cases hr : roundBinary s.format s.mode x with
  | none => simp [ConversionStage.convert, hr]
  | some bits =>
    obtain ⟨hf, hx⟩ := roundBinary_range hr
    obtain ⟨bits', hb, hc⟩ := roundBinary_correct s.format hf s.mode x hx
    rw [hr] at hb
    cases Option.some.inj hb
    obtain ⟨d, hd⟩ := hc.finite
    simp [ConversionStage.convert, hr, finiteBinary_some hd]
```

**Supporting proofs:** [TensorCore.BinaryRoundSpec.finite](../../Core/Binary/RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.finiteBinary_some](../../Core/Conversion.md#decl-66e4132ec74cac83), [TensorCore.roundBinary_correct](../../Core/Binary/RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_range](../../Core/Binary/RoundOp.md#decl-0877ce0e6eb40a61)

**Definitions and types:** [TensorCore.BinaryRoundSpec](../../Core/Binary/RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](../../Core/Conversion.md#decl-4947fce7ecea0c20), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57)

</details>

</details>

<a id="decl-a319b456fbf50ad5"></a>

<details>
<summary><code>TensorCore.PaperSpec.scaledCellObservation</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L37)

```lean
def scaledCellObservation (t : ScaledGemmCell cfg) : ScaledMatrixCell (layoutOf cfg.output.format) :=
  ⟨gemmCellObservation t.product, t.scaledProduct.bits, t.scaledC.bits, t.sum.bits, t.output.bits⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-13d680b591b379ba"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarValue32_finite</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L40)

```lean
theorem scalarValue32_finite (b : F32) :
    scalarValue binary32 b = (finite32 b).map Finite32.value := matrix_value32_finite b
```

**Supporting proofs:** [TensorCore.PaperSpec.matrix_value32_finite](GemmEquivalence.md#decl-9ce8d5ea689e94d1)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PaperSpec.binary32](../../TC/Specification/Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

</details>

</details>

<a id="decl-4bd57b05007ab0d1"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarValue32_of_finite</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L43)

```lean
theorem scalarValue32_of_finite (d : Finite32) : scalarValue binary32 d.bits = some d.value := by
  change value32 d.bits = some d.value
  rw [matrix_value32_eq]
  simp [TensorCore.value32, d.valid, Finite32.value]
```

**Supporting proofs:** [TensorCore.PaperSpec.matrix_value32_eq](GemmEquivalence.md#decl-83c15244052766f4)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PaperSpec.binary32](../../TC/Specification/Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

</details>

</details>

<a id="decl-80f754dc80ca34eb"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarEpilogue_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L48)

```lean
theorem scalarEpilogue_eq (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell) :
    scalarEpilogue (epilogueOf cfg) alpha beta c (gemmCellObservation product) =
      (gemmEpilogue cfg alpha beta c product).map scaledCellObservation := by
  simp only [scalarEpilogue, gemmCellObservation_output, scalarValue32_of_finite]
  rw [scalarValue32_finite, scalarValue32_finite, scalarValue32_finite]
  change (do
    let a ← (finite32 alpha).map Finite32.value
    let b ← (finite32 beta).map Finite32.value
    let c ← (finite32 c).map Finite32.value
    let p ← some product.output.value
    let ad ← scalarConvert (scalarStageOf cfg.multiplyStage) (a * p)
    let bc ← scalarConvert (scalarStageOf cfg.multiplyStage) (b * c)
    let sum ← scalarConvert (scalarStageOf cfg.addStage) (ad.2 + bc.2)
    let out ← scalarConvert (scalarStageOf cfg.output) sum.2
    pure (ScaledMatrixCell.mk (gemmCellObservation product) ad.1 bc.1 sum.1 out.1)) = _
  simp only [scalarConvert_eq, gemmEpilogue]
  cases ha : finite32 alpha <;> cases hb : finite32 beta <;> cases hc : finite32 c <;>
    simp [bind, pure, Option.bind_map, Option.map_bind, Option.bind_some, Option.bind_none, Function.comp_def, scaledCellObservation] <;> rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmCellObservation_output](GemmEquivalence.md#decl-4e01e4b2fe2487ea), [TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarValue32_finite](ScaledGemmEquivalence.md#decl-13d680b591b379ba), [TensorCore.PaperSpec.scalarValue32_of_finite](ScaledGemmEquivalence.md#decl-4bd57b05007ab0d1)

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](../ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](../ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.MatrixCell.output](Matrix.md#decl-2e5dc86c7c48029c), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.binary32](../../TC/Specification/Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarConvert](Scalar.md#decl-7cff21b148b8dfab), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scalarStageOf](ScaledGemmEquivalence.md#decl-0d7d7612b2b29253), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmEpilogue](../ScaledGemm.md#decl-830c6be1cd273929)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028)

</details>

</details>

<a id="decl-fcea418441d43028"></a>

<details>
<summary><code>TensorCore.PaperSpec.scaledGemm_eq_independent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L69)

```lean
/-- Every encoded product and scalar boundary agrees, for all input matrices.
No certificate, execution-success, range, or stage-correctness premise. -/
theorem scaledGemm_eq_independent (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) :
    (scaledGemm model cfg alpha beta A B C).map (fun row => row.map fun cell =>
      cell.map scaledCellObservation) = scaledMatrix (wmmaModel model) (epilogueOf cfg) alpha beta A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [Vector.getElem_map]
  have hm := congrArg (fun D => D[i][j]) (gemm_eq_paper model A B (DenseMatrix.ofFn fun _ _ => 0))
  simp only [Vector.getElem_map] at hm
  simp only [scaledGemm, scaledMatrix, DenseMatrix.ofFn, Vector.getElem_ofFn]
  change ((gemm model A B (DenseMatrix.ofFn fun _ _ => 0))[i][j].toOption.bind
    (gemmEpilogue cfg alpha beta C[i][j])).map scaledCellObservation =
    ((wmmaGemm (wmmaModel model) A B (DenseMatrix.ofFn fun _ _ => 0))[i][j].bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
  rw [← hm]
  cases hp : (gemm model A B (DenseMatrix.ofFn fun _ _ => 0))[i][j] with
  | error e => rfl
  | ok product => exact (scalarEpilogue_eq cfg alpha beta C[i][j] product).symm
```

**Supporting proofs:** [TensorCore.PaperSpec.gemm_eq_paper](GemmEquivalence.md#decl-5c9e12476c94c50c), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmEpilogue](../ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58)

</details>

</details>

<a id="decl-92020721ef951c58"></a>

<details>
<summary><code>TensorCore.PaperSpec.scaledGemmBits_eq_independent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L91)

```lean
theorem scaledGemmBits_eq_independent (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) :
    scaledGemmBits model cfg alpha beta A B C =
      (scaledMatrix (wmmaModel model) (epilogueOf cfg) alpha beta A B C).map
        (fun row => row.map fun cell => cell.map ScaledMatrixCell.output) := by
  rw [← scaledGemm_eq_independent]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [scaledGemmBits, Vector.getElem_map, Option.map_map]
  rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028)

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmBits](../ScaledGemm.md#decl-54ef760c8311c4d0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939)

</details>

</details>

<a id="decl-b298d005dd377d57"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarConvertWord_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L105)

```lean
theorem scalarConvertWord_eq (source target : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) :
    scalarConvertWord (layoutOf source) (layoutOf target) (scalarModeOf mode) bits =
      convertGemmWord source target mode bits := by
  simp only [scalarConvertWord, scalarValue_eq, scalarRound_eq, convertGemmWord]
  cases hd : binaryValue source bits with
  | none => rfl
  | some x =>
    change roundBinary target mode x = (ConversionStage.convert ⟨target, mode⟩ x).bind (fun y => some y.bits)
    rw [← conversionStage_bits_eq (ConversionStage.mk target mode) x]
    cases (ConversionStage.convert ⟨target, mode⟩ x) <;> rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.conversionStage_bits_eq](ScaledGemmEquivalence.md#decl-13632aec059d0b49), [TensorCore.PaperSpec.scalarRound_eq](ScalarRounding.md#decl-dac12f3fa291169b), [TensorCore.PaperSpec.scalarValue_eq](ScalarRounding.md#decl-5f6e455aabd909c4)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarRound](Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.convertGemmWord](../ScaledGemm.md#decl-90caef944befb68d), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrixToLayout_eq](NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.convertMatrix_eq](ScaledGemmEquivalence.md#decl-6abc23999fbbbae3)

</details>

</details>

<a id="decl-6abc23999fbbbae3"></a>

<details>
<summary><code>TensorCore.PaperSpec.convertMatrix_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L117)

```lean
theorem convertMatrix_eq (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) :
    convertMatrix (layoutOf source) (scalarModeOf mode) A = convertGemmInput source mode A := by
  classical
  unfold convertMatrix convertGemmInput
  change (if ∀ i : Fin m, ∀ j : Fin n,
      (scalarConvertWord (layoutOf source) (layoutOf fp16) (scalarModeOf mode) A[i.val][j.val]).isSome then
    some (DenseMatrix.ofFn fun i j =>
      (scalarConvertWord (layoutOf source) (layoutOf fp16) (scalarModeOf mode) A[i.val][j.val]).getD 0)
    else none) = _
  simp only [scalarConvertWord_eq]
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.convertMatrix](Scalar.md#decl-c0712e73fc64ca5f), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertGemmWord](../ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25)

</details>

</details>

<a id="decl-cf7e09c03287eb25"></a>

<details>
<summary><code>TensorCore.PaperSpec.convertedGemm_eq_independent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/ScaledGemmEquivalence.lean#L131)

```lean
/-- Complete source-format pipeline equality, including whole-input-conversion
failure and per-entry scalar/tensor-core failure. Empty dimensions remain explicit. -/
theorem convertedGemm_eq_independent (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemm source inputMode model cfg alpha beta A B C).map
      (fun D => D.map fun row => row.map fun cell => cell.map scaledCellObservation) =
      convertedMatrix (layoutOf source) (scalarModeOf inputMode) (wmmaModel model)
        (epilogueOf cfg) alpha beta A B C := by
  simp only [convertedGemm, convertedMatrix, convertMatrix_eq]
  cases ha : convertGemmInput source inputMode A <;> cases hb : convertGemmInput source inputMode B <;>
    simp [bind, pure, scaledGemm_eq_independent] <;> rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.convertMatrix_eq](ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.convertMatrix](Scalar.md#decl-c0712e73fc64ca5f), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](../ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39)

</details>

</details>
