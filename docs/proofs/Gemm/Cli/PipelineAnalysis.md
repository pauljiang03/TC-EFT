# TensorCore.Gemm.Cli.PipelineAnalysis

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-83d29b5f944a2b20"></a>

<details>
<summary><code>TensorCore.Cli.PipelineAnalysis.rational</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/PipelineAnalysis.lean#L11)

```lean
def rational (input : Json) (key : String) : Except String ℚ := do
  let value ← input.getObjValAs? String key
  tolerance (Json.mkObj [("absolute_tolerance", toJson value)])
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.tolerance](Analysis.md#decl-1f136b0f7b3b213b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-a1f4cd43d75b82d6"></a>

<details>
<summary><code>TensorCore.Cli.PipelineAnalysis.scaledWitnessJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/PipelineAnalysis.lean#L15)

```lean
def scaledWitnessJson (w : ScaledWitness) : Json := Json.mkObj [
  ("groups", toJson (w.groups.map witnessJson)),
  ("alpha_scale", toJson w.epilogue.alphaScale), ("beta_scale", toJson w.epilogue.betaScale),
  ("sum_scale", toJson w.epilogue.sumScale), ("output_scale", toJson w.epilogue.outputScale)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.witnessJson](Analysis.md#decl-4b44e07e32d5394e), [TensorCore.EpilogueWitness](../ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.ScaledWitness](../ScaledGemmAnalysis.md#decl-689b6d14860c84bb)

<details>
<summary>Used by</summary>

[TensorCore.Cli.PipelineAnalysis.scaledCellJson](PipelineAnalysis.md#decl-1aed0be8e56c2ba3)

</details>

</details>

<a id="decl-1aed0be8e56c2ba3"></a>

<details>
<summary><code>TensorCore.Cli.PipelineAnalysis.scaledCellJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/PipelineAnalysis.lean#L20)

```lean
def scaledCellJson : Option ScaledAnalysis → Json
  | none => Json.null
  | some a => Json.mkObj [
      ("error_bound", toJson (ratText a.bound.error)),
      ("magnitude_bound", toJson (ratText a.bound.magnitude)),
      ("alignment_bound", toJson (ratText a.bound.alignment)),
      ("rounding_bound", toJson (ratText a.bound.rounding)),
      ("alpha_rounding_bound", toJson (ratText a.bound.alphaRounding)),
      ("beta_rounding_bound", toJson (ratText a.bound.betaRounding)),
      ("add_rounding_bound", toJson (ratText a.bound.addRounding)),
      ("output_rounding_bound", toJson (ratText a.bound.outputRounding)),
      ("input_conversion_bound", toJson (ratText a.bound.inputConversion)),
      ("witness", scaledWitnessJson a.witness)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.PipelineAnalysis.scaledWitnessJson](PipelineAnalysis.md#decl-a1f4cd43d75b82d6), [TensorCore.PipelineBound](../ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.PipelineBound.error](../ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.report](NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.report](PipelineAnalysis.md#decl-9efe788a4da8437d)

</details>

</details>

<a id="decl-9efe788a4da8437d"></a>

<details>
<summary><code>TensorCore.Cli.PipelineAnalysis.report</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/PipelineAnalysis.lean#L34)

```lean
def report (source : Format) (mode : BinaryRoundingMode) (model : WmmaGemmModel)
    (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : ℚ) : Json :=
  let result := analyzeConvertedGemm source mode model cfg alpha beta A B C
  let cells := result.getD (DenseMatrix.ofFn fun _ _ => none)
  let witnesses := cells.map fun row => row.map fun a =>
    (a.map (·.witness)).getD ⟨[], ⟨0, 0, 0, 0⟩⟩
  let complete := result.isSome && cells.toArray.all fun row => row.toArray.all Option.isSome
  let bounds := cells.toArray.toList.flatMap fun row => row.toArray.toList.map fun a =>
    (a.map fun c => c.bound.error).getD 0
  let accepted := complete && convertedAnalysisCheck source mode model cfg alpha beta A B C witnesses tol
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
    ("rows", if result.isSome then toJson (cells.toArray.map fun row => row.toArray.map scaledCellJson) else Json.null)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.PipelineAnalysis.scaledCellJson](PipelineAnalysis.md#decl-1aed0be8e56c2ba3), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.EpilogueWitness](../ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.PipelineBound.error](../ScaledGemmAnalysis.md#decl-7e75458ed410184c), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](../ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeConvertedGemm](../ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.convertedAnalysisCheck](../ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.matrixAbsSum](../Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.pipelineEntryBounds](../ConvertedGemmAnalysis.md#decl-2800a71c520f2518)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Selection.analysis](GemmSelection.md#decl-d9ed69e91d255373)

</details>

</details>

<a id="decl-096a223468dfacfb"></a>

<details>
<summary><code>TensorCore.Cli.PipelineAnalysis.familyWitnessJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/PipelineAnalysis.lean#L58)

```lean
def familyWitnessJson (cfg : GemmBoundConfig) : Json := Json.mkObj [
  ("accumulator_scale", toJson cfg.accumulatorScale), ("product_scale", toJson cfg.productScale),
  ("carry_bits", toJson cfg.carryBits), ("initial_bound", toJson (ratText cfg.initialBound))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.entryReport](ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.PipelineAnalysis.familyReport](PipelineAnalysis.md#decl-984f12645fbbbd44)

</details>

</details>

<a id="decl-984f12645fbbbd44"></a>

<details>
<summary><code>TensorCore.Cli.PipelineAnalysis.familyReport</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/PipelineAnalysis.lean#L62)

```lean
def familyReport (model : WmmaGemmModel) (m n k : ℕ) (f : GemmFamily) (tol : ℚ) : Json :=
  let witness := inferFamily model k f
  let bound := witness.map (familyError model k)
  let accepted := (witness.map fun w => familyCheck model k f w tol).getD false
  Json.mkObj [
    ("status", toJson (if accepted then "certified" else "inconclusive")),
    ("accepted", toJson accepted), ("bounds_valid", toJson witness.isSome),
    ("error_reference", toJson "raw_ab_plus_c_for_all_finite_inputs_within_bounds"),
    ("reason", toJson (if accepted then "tolerance_met" else if witness.isSome then "bound_exceeds_tolerance"
      else "uniform_headroom_condition_not_established")),
    ("absolute_tolerance", toJson (ratText tol)),
    ("entry_bound", toJson (bound.map ratText)),
    ("matrix_bound", toJson (bound.map fun b => ratText ((m : ℚ) * (n : ℚ) * b))),
    ("witness", toJson (witness.map familyWitnessJson))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.PipelineAnalysis.familyWitnessJson](PipelineAnalysis.md#decl-096a223468dfacfb), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyCheck](../Family.md#decl-43a043749bf35c52), [TensorCore.familyError](../Family.md#decl-966b1b857128f203), [TensorCore.inferFamily](../Family.md#decl-868633a6b6bbc848)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Selection.analysis](GemmSelection.md#decl-d9ed69e91d255373)

</details>

</details>
