# TensorCore.Gemm.Cli.NativePipeline

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e6098145378277af"></a>

<details>
<summary><code>TensorCore.Cli.NativePipeline.sourceFormat</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/NativePipeline.lean#L10)

```lean
def sourceFormat (name : String) : Except String Format :=
  if name == "tf32" then .ok tf19 else format name
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.GemmInput.format](GemmInput.md#decl-de05af7e33d3efef), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-49bc14758993819b"></a>

<details>
<summary><code>TensorCore.Cli.NativePipeline.matrixJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/NativePipeline.lean#L13)

```lean
def matrixJson (A : DenseMatrix α m n) (f : α → Json) : Json :=
  toJson (A.toArray.map fun row => row.toArray.map f)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.execution](NativePipeline.md#decl-414b6224be4a4b0a)

</details>

</details>

<a id="decl-fdd57e2a6f8c81f1"></a>

<details>
<summary><code>TensorCore.Cli.NativePipeline.scaledCellJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/NativePipeline.lean#L16)

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

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.errorBudget](../ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.execution](NativePipeline.md#decl-414b6224be4a4b0a)

</details>

</details>

<a id="decl-15052b6ec6a59317"></a>

<details>
<summary><code>TensorCore.Cli.NativePipeline.report</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/NativePipeline.lean#L25)

```lean
def report (source : Format) (mode : BinaryRoundingMode) (model : NativeGemmModel p)
    (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : ℚ) : Json :=
  let result := analyzeNativeConvertedGemm source mode model cfg alpha beta A B C
  let cells := result.getD (DenseMatrix.ofFn fun _ _ => none)
  let witnesses := cells.map fun row => row.map fun a =>
    (a.map (·.witness)).getD ⟨[], ⟨0, 0, 0, 0⟩⟩
  let complete := result.isSome && cells.toArray.all fun row => row.toArray.all Option.isSome
  let bounds := cells.toArray.toList.flatMap fun row => row.toArray.toList.map fun a =>
    (a.map fun c => c.bound.error).getD 0
  let accepted := complete && nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C witnesses tol
  Json.mkObj [
    ("status", toJson (if accepted then "certified" else "inconclusive")),
    ("accepted", toJson accepted), ("bounds_valid", toJson complete),
    ("error_reference", toJson "source_alpha_ab_plus_beta_c"),
    ("input_conversion_rejected", toJson result.isNone),
    ("reason", toJson (if accepted then "tolerance_met" else if complete then "bound_exceeds_tolerance"
      else if result.isNone then "input_conversion_rejected" else "finite_input_or_magnitude_condition_not_established")),
    ("absolute_tolerance", toJson (ratText tol)),
    ("max_entry_bound", if complete then toJson (ratText (bounds.foldl max 0)) else Json.null),
    ("matrix_bound", if complete then toJson (ratText (matrixAbsSum (pipelineEntryBounds cells))) else Json.null),
    ("rows", if result.isSome then toJson (cells.toArray.map fun row => row.toArray.map PipelineAnalysis.scaledCellJson) else Json.null)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.PipelineAnalysis.scaledCellJson](PipelineAnalysis.md#decl-1aed0be8e56c2ba3), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.EpilogueWitness](../ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.PipelineBound.error](../ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](../ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.analyzeNativeConvertedGemm](../NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.matrixAbsSum](../Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.nativeConvertedAnalysisCheck](../NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.pipelineEntryBounds](../ConvertedGemmAnalysis.md#decl-2800a71c520f2518)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.Selection.analysis](GemmSelection.md#decl-d9ed69e91d255373)

</details>

</details>

<a id="decl-414b6224be4a4b0a"></a>

<details>
<summary><code>TensorCore.Cli.NativePipeline.execution</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/NativePipeline.lean#L49)

```lean
def execution (source : Format) (mode : BinaryRoundingMode) (model : NativeGemmModel p)
    (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Json :=
  match convertMatrixTo source p.format mode A, convertMatrixTo source p.format mode B with
  | some a, some b => Json.mkObj [
      ("rows", matrixJson (nativeScaledGemm model cfg alpha beta a b C) scaledCellJson),
      ("ideal", matrixJson (sourceGemmIdeal p.format alpha beta a b C) fun v => toJson (v.map ratText)),
      ("source_ideal", matrixJson (sourceGemmIdeal source alpha beta A B C) fun v => toJson (v.map ratText)),
      ("input_product_bound", matrixJson (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) =>
        inputProductErrorTo source p.format mode (sourceGemmPairs source A B i j)) fun v => toJson (v.map ratText)),
      ("converted_a", matrixJson a fun x => toJson x.toNat),
      ("converted_b", matrixJson b fun x => toJson x.toNat),
      ("tile_instructions", toJson (groupCount 16 m * groupCount model.columns n * groupCount p.inner k))]
  | _, _ => Json.mkObj [("input_conversion_rejected", toJson true)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.NativePipeline.matrixJson](NativePipeline.md#decl-49bc14758993819b), [TensorCore.Cli.NativePipeline.scaledCellJson](NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.columns](../NativeGemm.md#decl-bd8f696cbf181bd5), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativePrecision.inner](../NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.convertMatrixTo](../MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.groupCount](../../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.inputProductErrorTo](../MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.nativeScaledGemm](../NativeScaledGemm.md#decl-727eddedc05f8257), [TensorCore.sourceGemmIdeal](../InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](../InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1)

</details>

</details>

<a id="decl-97378125f3827cc1"></a>

<details>
<summary><code>TensorCore.Cli.NativePipeline.evaluate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/NativePipeline.lean#L65)

```lean
def evaluate (input : Json) : Except String Json := do
  let operation ← input.getObjValAs? String "operation"
  let p ← ExtendedAnalysis.precision (← input.getObjValAs? String "precision")
  let model ← ExtendedAnalysis.nativeModel p (← input.getObjValAs? String "model")
  let source ← sourceFormat (← input.getObjValAs? String "input_format")
  if (← input.getObjValAs? String "output_format") != "fp32" then throw "Native scaled GEMM requires FP32 output"
  let im ← mode (← input.getObjValAs? String "input_mode")
  let mm ← mode (← input.getObjValAs? String "multiply_mode")
  let am ← mode (← input.getObjValAs? String "add_mode")
  let om ← mode (← input.getObjValAs? String "output_mode")
  let cfg : GemmEpilogue := ⟨mm, am, ⟨fp32, om⟩⟩
  let m ← input.getObjValAs? ℕ "m"
  let n ← input.getObjValAs? ℕ "n"
  let k ← input.getObjValAs? ℕ "k"
  let A ← words source.width m k (← input.getObjValAs? (Array ℕ) "a")
  let B ← words source.width k n (← input.getObjValAs? (Array ℕ) "b")
  let C ← words 32 m n (← input.getObjValAs? (Array ℕ) "c")
  let alpha ← scalar input "alpha"
  let beta ← scalar input "beta"
  if operation == "native_scaled" then return execution source im model cfg alpha beta A B C
  else if operation == "analyze_native_scaled" then return report source im model cfg alpha beta A B C (← tolerance input)
  else throw "Expected native_scaled or analyze_native_scaled"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.Analysis.tolerance](Analysis.md#decl-1f136b0f7b3b213b), [TensorCore.Cli.ExtendedAnalysis.nativeModel](ExtendedAnalysis.md#decl-f07e458a7c9f11ef), [TensorCore.Cli.ExtendedAnalysis.precision](ExtendedAnalysis.md#decl-070682d91fce08b6), [TensorCore.Cli.GemmInput.mode](GemmInput.md#decl-537adc255c27ce81), [TensorCore.Cli.GemmInput.scalar](GemmInput.md#decl-dea3790eaa6416ad), [TensorCore.Cli.GemmInput.words](GemmInput.md#decl-28dd181dd1f5acb4), [TensorCore.Cli.NativePipeline.execution](NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.Cli.NativePipeline.report](NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.NativePipeline.sourceFormat](NativePipeline.md#decl-e6098145378277af), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479)

</details>

</details>
