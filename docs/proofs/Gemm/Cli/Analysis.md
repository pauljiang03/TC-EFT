# TensorCore.Gemm.Cli.Analysis

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-37884758ff4f6366"></a>

<details>
<summary><code>TensorCore.Cli.Analysis.ratText</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Analysis.lean#L10)

```lean
def ratText (q : ℚ) : String := s!"{q.num}/{q.den}"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.cellJson](Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Cli.Analysis.report](Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.entryReport](ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.ExtendedAnalysis.nativeExecution](ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.ExtendedAnalysis.nativeReport](ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.NativePipeline.execution](NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.Cli.NativePipeline.report](NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.NativePipeline.scaledCellJson](NativePipeline.md#decl-fdd57e2a6f8c81f1), [TensorCore.Cli.PipelineAnalysis.familyReport](PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.Cli.PipelineAnalysis.familyWitnessJson](PipelineAnalysis.md#decl-096a223468dfacfb), [TensorCore.Cli.PipelineAnalysis.report](PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.Cli.PipelineAnalysis.scaledCellJson](PipelineAnalysis.md#decl-1aed0be8e56c2ba3), [TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae)

</details>

</details>

<a id="decl-1f136b0f7b3b213b"></a>

<details>
<summary><code>TensorCore.Cli.Analysis.tolerance</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Analysis.lean#L12)

```lean
def tolerance (input : Json) : Except String ℚ := do
  let text ← input.getObjValAs? String "absolute_tolerance"
  match text.splitOn "/" with
  | [numerator, denominator] =>
    match numerator.toInt?, denominator.toNat? with
    | some n, some d =>
      if n < 0 || d == 0 then .error "Tolerance must be a nonnegative rational with positive denominator"
      else .ok ((n : ℚ) / (d : ℚ))
    | _, _ => .error "Expected absolute_tolerance as numerator/denominator"
  | _ => .error "Expected absolute_tolerance as numerator/denominator"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.caps](ExtendedAnalysis.md#decl-c854babef8a124dd), [TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.PipelineAnalysis.rational](PipelineAnalysis.md#decl-83d29b5f944a2b20), [TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae)

</details>

</details>

<a id="decl-4b44e07e32d5394e"></a>

<details>
<summary><code>TensorCore.Cli.Analysis.witnessJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Analysis.lean#L23)

```lean
def witnessJson (w : GroupWitness) : Json := Json.mkObj [
  ("scale", toJson w.scale), ("output_scale", toJson w.outputScale)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.cellJson](Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Cli.PipelineAnalysis.scaledWitnessJson](PipelineAnalysis.md#decl-a1f4cd43d75b82d6)

</details>

</details>

<a id="decl-5a93ba5d1362fd0c"></a>

<details>
<summary><code>TensorCore.Cli.Analysis.cellJson</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Analysis.lean#L26)

```lean
def cellJson : Option CellAnalysis → Json
  | none => Json.null
  | some a => Json.mkObj [
      ("error_bound", toJson (ratText a.bound.error)),
      ("magnitude_bound", toJson (ratText a.bound.magnitude)),
      ("alignment_bound", toJson (ratText a.bound.alignment)),
      ("rounding_bound", toJson (ratText a.bound.rounding)),
      ("witness", toJson (a.witness.map witnessJson))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound](../../TC/Program/GroupAnalysis.md#decl-b8d00c6cb811c77e), [TensorCore.AnalysisBound.error](../../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.Analysis.witnessJson](Analysis.md#decl-4b44e07e32d5394e), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Analysis.report](Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.nativeReport](ExtendedAnalysis.md#decl-f2295e1f16de52c7)

</details>

</details>

<a id="decl-fe1abe7d61ee46e3"></a>

<details>
<summary><code>TensorCore.Cli.Analysis.report</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/Analysis.lean#L35)

```lean
def report (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) (tol : ℚ) : Json :=
  let cells := analyzeGemm model A B C
  let witnesses := cells.map fun row => row.map fun a => a.map (·.witness) |>.getD []
  let complete := cells.toArray.all fun row => row.toArray.all Option.isSome
  let bounds := cells.toArray.toList.flatMap fun row => row.toArray.toList.map fun a =>
    (a.map fun c => c.bound.error).getD 0
  let accepted := complete && gemmAnalysisCheck model A B C witnesses tol
  Json.mkObj [
    ("status", toJson (if accepted then "certified" else "inconclusive")),
    ("accepted", toJson accepted), ("bounds_valid", toJson complete),
    ("reason", toJson (if accepted then "tolerance_met" else if complete then "bound_exceeds_tolerance"
      else "finite_input_or_magnitude_condition_not_established")),
    ("absolute_tolerance", toJson (ratText tol)),
    ("max_entry_bound", if complete then toJson (ratText (bounds.foldl max 0)) else Json.null),
    ("matrix_bound", if complete then toJson (ratText (matrixAbsSum (analysisEntryBounds cells))) else Json.null),
    ("rows", toJson (cells.toArray.map fun row => row.toArray.map cellJson))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound.error](../../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.Cli.Analysis.cellJson](Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analysisEntryBounds](../Analysis.md#decl-d1b4af0b27a0d0ba), [TensorCore.analyzeGemm](../Analysis.md#decl-8b640af4e4509e78), [TensorCore.gemmAnalysisCheck](../Analysis.md#decl-6640feb1a0c523f2), [TensorCore.matrixAbsSum](../Bounds.md#decl-3500b8a4ffeefc9e)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.Selection.analysis](GemmSelection.md#decl-d9ed69e91d255373)

</details>

</details>
