# TensorCore.Gemm.Cli.Gemm

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2bb759910c4c6bcd"></a>

<details>
<summary><code>TensorCore.Cli.Gemm.ratText</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Gemm.lean#L12)

```lean
private def ratText (q : ℚ) : String := s!"{q.num}/{q.den}"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Gemm.scaledCellJson](Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.Gemm.cellJson](Gemm.md#decl-5aa1c2dea45f7f03)

</details>

</details>

<a id="decl-5aa1c2dea45f7f03"></a>

<details>
<summary><code>TensorCore.Cli.Gemm.cellJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Gemm.lean#L14)

```lean
private def cellJson : Except ModelError GemmCell → Json
  | .error e => Json.mkObj [("error", toJson (reprStr e))]
  | .ok c => Json.mkObj [
      ("bits", toJson c.output.bits.toNat),
      ("value", toJson (ratText c.output.value)),
      ("initial", toJson c.initial.bits.toNat),
      ("instructions", toJson (c.instructions.map fun ts => ts.map fun t => t.output.bits.toNat)),
      ("error_budget", toJson (ratText c.errorBudget))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.errorBudget](../Defs.md#decl-77bf8f0088e678b8), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Cli.Gemm.ratText](Gemm.md#decl-2bb759910c4c6bcd)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479)

</details>

</details>

<a id="decl-16bce941c08002a5"></a>

<details>
<summary><code>TensorCore.Cli.Gemm.matrixJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Gemm.lean#L23)

```lean
def matrixJson (A : DenseMatrix α m n) (f : α → Json) : Json :=
  toJson (A.toArray.map fun row => row.toArray.map f)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479)

</details>

</details>

<a id="decl-f0ea83e550eeb016"></a>

<details>
<summary><code>TensorCore.Cli.Gemm.scaledCellJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Gemm.lean#L26)

```lean
def scaledCellJson : Option (ScaledGemmCell cfg) → Json
  | none => Json.null
  | some t => Json.mkObj [
      ("bits", toJson t.output.bits.toNat), ("value", toJson (ratText t.output.value)),
      ("product_bits", toJson t.product.output.bits.toNat),
      ("stages", toJson [t.scaledProduct.bits.toNat, t.scaledC.bits.toNat, t.sum.bits.toNat]),
      ("instructions", toJson (t.product.instructions.map fun ts => ts.map (·.output.bits.toNat))),
      ("error_budget", toJson (ratText t.errorBudget))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.errorBudget](../ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.Cli.Gemm.ratText](Gemm.md#decl-2bb759910c4c6bcd)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479)

</details>

</details>

<a id="decl-a984a36184ce8479"></a>

<details>
<summary><code>TensorCore.Cli.Gemm.evaluate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Gemm.lean#L35)

```lean
def evaluate (input : Json) : Except String Json := do
  if (← input.getObjValAs? String "operation") == "select" then
    return ← Selection.evaluate input
  if ["native", "analyze_native", "analyze_entry_family"].contains (← input.getObjValAs? String "operation") then
    return ← ExtendedAnalysis.evaluate input
  if ["native_scaled", "analyze_native_scaled"].contains (← input.getObjValAs? String "operation") then
    return ← NativePipeline.evaluate input
  let architecture ← model (← input.getObjValAs? String "model")
  let m ← input.getObjValAs? ℕ "m"
  let n ← input.getObjValAs? ℕ "n"
  let k ← input.getObjValAs? ℕ "k"
  let operation ← input.getObjValAs? String "operation"
  if operation == "analyze_family" then
    let a ← PipelineAnalysis.rational input "a_bound"
    let b ← PipelineAnalysis.rational input "b_bound"
    let c ← PipelineAnalysis.rational input "c_bound"
    return PipelineAnalysis.familyReport architecture m n k ⟨a, b, c⟩ (← Analysis.tolerance input)
  let C ← words 32 m n (← input.getObjValAs? (Array ℕ) "c")
  match operation with
  | "analyze" =>
    let A ← words 16 m k (← input.getObjValAs? (Array ℕ) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array ℕ) "b")
    return Analysis.report architecture A B C (← Analysis.tolerance input)
  | "raw" =>
    let A ← words 16 m k (← input.getObjValAs? (Array ℕ) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array ℕ) "b")
    return Json.mkObj [
      ("rows", matrixJson (gemm architecture A B C) cellJson),
      ("ideal", matrixJson (gemmIdeal A B C) fun q => toJson (q.map ratText)),
      ("tile_instructions", toJson (gemmTileSchedule m n k).length)]
  | "certify" =>
    let A ← words 16 m k (← input.getObjValAs? (Array ℕ) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array ℕ) "b")
    let E ← input.getObjValAs? ℤ "accumulator_scale"
    let P ← input.getObjValAs? ℤ "product_scale"
    let L ← input.getObjValAs? ℕ "carry_bits"
    let cBound ← input.getObjValAs? ℤ "initial_bound"
    let cfg : GemmBoundConfig := ⟨E, P, L, cBound⟩
    let bound := gemmStaticError architecture cfg k
    return Json.mkObj [("accepted", toJson (gemmCheck architecture cfg A B C)),
      ("entry_bound", toJson (ratText bound)),
      ("matrix_bound", toJson (ratText ((m : ℚ) * (n : ℚ) * bound)))]
  | "scaled" | "certify_scaled" | "analyze_scaled" =>
    let source ← format (← input.getObjValAs? String "input_format")
    let target ← format (← input.getObjValAs? String "output_format")
    let im ← mode (← input.getObjValAs? String "input_mode")
    let mm ← mode (← input.getObjValAs? String "multiply_mode")
    let am ← mode (← input.getObjValAs? String "add_mode")
    let om ← mode (← input.getObjValAs? String "output_mode")
    let alpha ← scalar input "alpha"
    let beta ← scalar input "beta"
    let a ← words source.width m k (← input.getObjValAs? (Array ℕ) "a")
    let b ← words source.width k n (← input.getObjValAs? (Array ℕ) "b")
    let cfg : GemmEpilogue := ⟨mm, am, ⟨target, om⟩⟩
    if operation == "analyze_scaled" then
      return PipelineAnalysis.report source im architecture cfg alpha beta a b C (← Analysis.tolerance input)
    match convertGemmInput source im a, convertGemmInput source im b with
    | some A, some B =>
      if operation == "certify_scaled" then
        let E ← input.getObjValAs? ℤ "accumulator_scale"
        let P ← input.getObjValAs? ℤ "product_scale"
        let L ← input.getObjValAs? ℕ "carry_bits"
        let cBound ← input.getObjValAs? ℤ "initial_bound"
        let aScale ← input.getObjValAs? ℤ "alpha_scale"
        let bScale ← input.getObjValAs? ℤ "beta_scale"
        let sScale ← input.getObjValAs? ℤ "sum_scale"
        let oScale ← input.getObjValAs? ℤ "output_scale"
        let bounds : ScaledGemmBoundConfig := ⟨⟨E, P, L, cBound⟩, aScale, bScale, sScale, oScale⟩
        let error := scaledGemmStaticError architecture cfg bounds alpha k
        let sourceCertificate := convertedGemmSourceCertificate source im architecture cfg bounds
          alpha beta a b C
        let tightError := scaledGemmTightError architecture cfg bounds alpha k
        let tightCertificate := convertedGemmTightSourceCertificate source im architecture cfg bounds
          alpha beta a b C
        return Json.mkObj [("accepted", toJson (scaledGemmCheck architecture cfg bounds alpha beta A B C)),
          ("entry_bound", toJson (ratText error)),
          ("matrix_bound", toJson (ratText ((m : ℚ) * (n : ℚ) * error))),
          ("source_entry_bounds", toJson (sourceCertificate.map fun E => matrixJson E (toJson ∘ ratText))),
          ("source_matrix_bound", toJson (sourceCertificate.map fun E => ratText (matrixAbsSum E))),
          ("tight_entry_bound", toJson (ratText tightError)),
          ("tight_matrix_bound", toJson (ratText ((m : ℚ) * (n : ℚ) * tightError))),
          ("tight_source_entry_bounds", toJson (tightCertificate.map fun E => matrixJson E (toJson ∘ ratText))),
          ("tight_source_matrix_bound", toJson (tightCertificate.map fun E => ratText (matrixAbsSum E)))]
      else
        return Json.mkObj [
          ("rows", matrixJson (scaledGemm architecture cfg alpha beta A B C) scaledCellJson),
          ("ideal", matrixJson (scaledGemmIdeal alpha beta A B C) fun v => toJson (v.map ratText)),
          ("source_ideal", matrixJson (sourceGemmIdeal source alpha beta a b C) fun v => toJson (v.map ratText)),
          ("input_product_bound", matrixJson (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) =>
            gemmInputProductError source im (sourceGemmPairs source a b i j)) fun v => toJson (v.map ratText)),
          ("converted_a", matrixJson A fun x => toJson x.toNat),
          ("converted_b", matrixJson B fun x => toJson x.toNat)]
    | _, _ =>
      return Json.mkObj (("input_conversion_rejected", toJson true) ::
        if operation == "certify_scaled" then [("accepted", toJson false)] else [])
  | _ => .error "Expected operation raw, certify, scaled, certify_scaled, analyze, analyze_scaled, or analyze_family"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.Analysis.report](Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.Analysis.tolerance](Analysis.md#decl-1f136b0f7b3b213b), [TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Gemm.matrixJson](Gemm.md#decl-16bce941c08002a5), [TensorCore.Cli.Gemm.scaledCellJson](Gemm.md#decl-f0ea83e550eeb016), [TensorCore.Cli.GemmInput.format](GemmInput.md#decl-de05af7e33d3efef), [TensorCore.Cli.GemmInput.mode](GemmInput.md#decl-537adc255c27ce81), [TensorCore.Cli.GemmInput.model](GemmInput.md#decl-fc8688802cab1a09), [TensorCore.Cli.GemmInput.scalar](GemmInput.md#decl-dea3790eaa6416ad), [TensorCore.Cli.GemmInput.words](GemmInput.md#decl-28dd181dd1f5acb4), [TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.PipelineAnalysis.familyReport](PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.Cli.PipelineAnalysis.rational](PipelineAnalysis.md#decl-83d29b5f944a2b20), [TensorCore.Cli.PipelineAnalysis.report](PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmBoundConfig](../ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemmSourceCertificate](../InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmTightSourceCertificate](../TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmCheck](../Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](../Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmInputProductError](../InputBounds.md#decl-44a67c4ea7aef5c8), [TensorCore.gemmStaticError](../Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.gemmTileSchedule](../Defs.md#decl-0f85cf51aeea8448), [TensorCore.matrixAbsSum](../Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck](../ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](../ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmStaticError](../ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError](../TightBounds.md#decl-4ac591737d634082), [TensorCore.sourceGemmIdeal](../InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](../InputBounds.md#decl-2fa90183da38c041), [TensorCore.Cli.Gemm.cellJson](Gemm.md#decl-5aa1c2dea45f7f03), [TensorCore.Cli.Gemm.ratText](Gemm.md#decl-2bb759910c4c6bcd)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
