# TensorCore.Gemm.Cli.ExtendedAnalysis

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-070682d91fce08b6"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.precision</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L12)

```lean
def precision : String → Except String NativePrecision
  | "bf16" => .ok .bf16 | "tf32" => .ok .tf32
  | _ => .error "Native precision must be bf16 or tf32 (packed 19-bit words)"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1), [TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-f07e458a7c9f11ef"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.nativeModel</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L16)

```lean
def nativeModel (p : NativePrecision) (name : String) : Except String (NativeGemmModel p) :=
  match p, name with
  | _, "ampere" => .ok .ampere
  | _, "hopper" => .ok .hopper
  | .tf32, "hopper_mma" => .ok .hopperMma
  | _, _ => .error "Unsupported native model and precision combination"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.NativePipeline.evaluate](NativePipeline.md#decl-97378125f3827cc1)

</details>

</details>

<a id="decl-c854babef8a124dd"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.caps</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L23)

```lean
def caps (input : Json) (key : String) (m n : ℕ) : Except String (DenseMatrix ℚ m n) := do
  let values ← input.getObjValAs? (Array String) key
  if values.size != m * n then throw s!"Wrong {key} shape"
  let values ← values.mapM fun value => tolerance (Json.mkObj [("absolute_tolerance", toJson value)])
  return DenseMatrix.ofFn fun i j => values[i.val * n + j.val]!
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.tolerance](Analysis.md#decl-1f136b0f7b3b213b), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.entryFamily](ExtendedAnalysis.md#decl-984f320bce724d96)

</details>

</details>

<a id="decl-984f320bce724d96"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.entryFamily</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L29)

```lean
def entryFamily (input : Json) (m n k : ℕ) : Except String (EntryFamily m n k) := do
  return ⟨← caps input "a_bounds" m k, ← caps input "b_bounds" k n, ← caps input "c_bounds" m n⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.ExtendedAnalysis.caps](ExtendedAnalysis.md#decl-c854babef8a124dd), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-c1a2fb433c69cc2d"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.entryReport</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L32)

```lean
def entryReport (model : WmmaGemmModel) (f : EntryFamily m n k) (tol : ℚ) : Json :=
  let ws := inferEntryFamily model f
  let accepted := (ws.map fun w => entryFamilyCheck model f w tol).getD false
  let bounds := ws.map fun w => w.map fun row => row.map (familyError model k)
  Json.mkObj [
    ("status", toJson (if accepted then "certified" else "inconclusive")),
    ("accepted", toJson accepted), ("bounds_valid", toJson ws.isSome),
    ("error_reference", toJson "raw_ab_plus_c_for_all_finite_inputs_within_entry_bounds"),
    ("absolute_tolerance", toJson (ratText tol)),
    ("entry_bounds", toJson (bounds.map fun b => b.toArray.map fun row => row.toArray.map ratText)),
    ("matrix_bound", toJson (bounds.map fun b => ratText (matrixAbsSum b))),
    ("witness", toJson (ws.map fun w => w.toArray.map fun row => row.toArray.map PipelineAnalysis.familyWitnessJson))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.PipelineAnalysis.familyWitnessJson](PipelineAnalysis.md#decl-096a223468dfacfb), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.entryFamilyCheck](../EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.familyError](../Family.md#decl-966b1b857128f203), [TensorCore.inferEntryFamily](../EntryFamily.md#decl-5e36ba2c223b5587), [TensorCore.matrixAbsSum](../Bounds.md#decl-3500b8a4ffeefc9e)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Selection.analysis](GemmSelection.md#decl-d9ed69e91d255373)

</details>

</details>

<a id="decl-f2295e1f16de52c7"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.nativeReport</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L45)

```lean
def nativeReport (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) (tol : ℚ) : Json :=
  let cells := analyzeNativeGemm model A B C
  let ws := cells.map fun row => row.map fun a => (a.map (·.witness)).getD []
  let complete := cells.toArray.all fun row => row.toArray.all Option.isSome
  let bounds := cells.toArray.toList.flatMap fun row => row.toArray.toList.map fun a =>
    (a.map fun c => c.bound.error).getD 0
  let accepted := complete && nativeAnalysisCheck model A B C ws tol
  Json.mkObj [
    ("status", toJson (if accepted then "certified" else "inconclusive")),
    ("accepted", toJson accepted), ("bounds_valid", toJson complete),
    ("error_reference", toJson "encoded_native_ab_plus_c"),
    ("absolute_tolerance", toJson (ratText tol)),
    ("max_entry_bound", if complete then toJson (ratText (bounds.foldl max 0)) else Json.null),
    ("matrix_bound", if complete then toJson (ratText (matrixAbsSum (analysisEntryBounds cells))) else Json.null),
    ("rows", toJson (cells.toArray.map fun row => row.toArray.map cellJson))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AnalysisBound.error](../../TC/Program/GroupAnalysis.md#decl-51f6228293fd16fa), [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.Cli.Analysis.cellJson](Analysis.md#decl-5a93ba5d1362fd0c), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.analysisEntryBounds](../Analysis.md#decl-d1b4af0b27a0d0ba), [TensorCore.analyzeNativeGemm](../NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.matrixAbsSum](../Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.nativeAnalysisCheck](../NativeGemm.md#decl-10bee9068a09e5e3)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Selection.analysis](GemmSelection.md#decl-d9ed69e91d255373)

</details>

</details>

<a id="decl-4c0e68b9ad67fac0"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.nativeExecution</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L62)

```lean
def nativeExecution (model : NativeGemmModel p) (A : DenseMatrix (NativeWord p) m k)
    (B : DenseMatrix (NativeWord p) k n) (C : DenseMatrix F32 m n) : Json :=
  let cells := nativeGemm model A B C
  Json.mkObj [
    ("rows", toJson (cells.toArray.map fun row => row.toArray.map fun cell => match cell with
      | none => Json.null
      | some c => Json.mkObj [
        ("bits", toJson c.output.bits.toNat), ("value", toJson (ratText c.output.value)),
        ("initial", toJson c.initial.bits.toNat),
        ("instructions", toJson ((chunks (p.inner / model.products) (groupCount p.inner k) c.blocks).map
          fun (gs : List TensorCore.BlockTrace) => gs.map fun (t : TensorCore.BlockTrace) => t.output.bits.toNat))])),
    ("ideal", toJson ((nativeGemmIdeal model A B C).toArray.map fun row => row.toArray.map fun z => toJson (z.map ratText))),
    ("tile_instructions", toJson (groupCount 16 m * groupCount model.columns n * groupCount p.inner k))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](../NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.columns](../NativeGemm.md#decl-bd8f696cbf181bd5), [TensorCore.NativeGemmModel.products](../NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](../NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.chunks](../../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.groupCount](../../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.nativeGemm](../NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmIdeal](../NativeGemm.md#decl-b9b24fce99a6a8c6)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.evaluate](ExtendedAnalysis.md#decl-efc26fc65c10f113)

</details>

</details>

<a id="decl-efc26fc65c10f113"></a>

<details>
<summary><code>TensorCore.Cli.ExtendedAnalysis.evaluate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/ExtendedAnalysis.lean#L76)

```lean
def evaluate (input : Json) : Except String Json := do
  let operation ← input.getObjValAs? String "operation"
  let m ← input.getObjValAs? ℕ "m"
  let n ← input.getObjValAs? ℕ "n"
  let k ← input.getObjValAs? ℕ "k"
  if operation == "analyze_entry_family" then
    return entryReport (← model (← input.getObjValAs? String "model"))
      (← entryFamily input m n k) (← tolerance input)
  let p ← precision (← input.getObjValAs? String "precision")
  let model ← nativeModel p (← input.getObjValAs? String "model")
  let A ← words p.format.width m k (← input.getObjValAs? (Array ℕ) "a")
  let B ← words p.format.width k n (← input.getObjValAs? (Array ℕ) "b")
  let C ← words 32 m n (← input.getObjValAs? (Array ℕ) "c")
  if operation == "native" then return nativeExecution model A B C
  else if operation == "analyze_native" then return nativeReport model A B C (← tolerance input)
  else throw "Expected native, analyze_native, or analyze_entry_family"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.tolerance](Analysis.md#decl-1f136b0f7b3b213b), [TensorCore.Cli.ExtendedAnalysis.entryFamily](ExtendedAnalysis.md#decl-984f320bce724d96), [TensorCore.Cli.ExtendedAnalysis.entryReport](ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.ExtendedAnalysis.nativeExecution](ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.ExtendedAnalysis.nativeModel](ExtendedAnalysis.md#decl-f07e458a7c9f11ef), [TensorCore.Cli.ExtendedAnalysis.nativeReport](ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.ExtendedAnalysis.precision](ExtendedAnalysis.md#decl-070682d91fce08b6), [TensorCore.Cli.GemmInput.model](GemmInput.md#decl-fc8688802cab1a09), [TensorCore.Cli.GemmInput.words](GemmInput.md#decl-28dd181dd1f5acb4), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479)

</details>

</details>
