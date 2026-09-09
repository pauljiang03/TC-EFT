# TensorCore.Gemm.Cli.GemmSelection

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e1097a8a93ee5d64"></a>

<details>
<summary><code>TensorCore.Cli.Selection.allowedKeys</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmSelection.lean#L12)

```lean
def allowedKeys (input : Json) (allowed : List String) : Except String Unit := do
  let obj ← input.getObj?
  for (key, _) in obj.toList do
    if !allowed.contains key then throw s!"Unexpected selection field: {key}"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.candidate](GemmSelection.md#decl-0ce6164bf816c3c9), [TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.Cli.Selection.executionRequest](GemmSelection.md#decl-9c94d65d36739b3d), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112)

</details>

</details>

<a id="decl-0ce6164bf816c3c9"></a>

<details>
<summary><code>TensorCore.Cli.Selection.candidate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmSelection.lean#L17)

```lean
def candidate (kind : String) (input : Json) : Except String GemmCandidate := do
  let scaled := kind == "scaled" || kind == "native_scaled"
  let native := kind == "native" || kind == "native_scaled"
  allowedKeys input (["model"] ++ if scaled then ["input_mode", "multiply_mode", "add_mode"] else [])
  let name ← input.getObjValAs? String "model"
  let architecture ← if native && name == "hopper_mma" then pure WmmaGemmModel.hopper else model name
  let im ← if scaled then mode (← input.getObjValAs? String "input_mode") else pure .nearestEven
  let mm ← if scaled then mode (← input.getObjValAs? String "multiply_mode") else pure .nearestEven
  let am ← if scaled then mode (← input.getObjValAs? String "add_mode") else pure .nearestEven
  return ⟨architecture, im, mm, am, native && name == "hopper_mma"⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.GemmInput.mode](GemmInput.md#decl-537adc255c27ce81), [TensorCore.Cli.GemmInput.model](GemmInput.md#decl-fc8688802cab1a09), [TensorCore.Cli.Selection.allowedKeys](GemmSelection.md#decl-e1097a8a93ee5d64), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae)

</details>

</details>

<a id="decl-2fb1639c2044a112"></a>

<details>
<summary><code>TensorCore.Cli.Selection.problem</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmSelection.lean#L28)

```lean
def problem (input : Json) (m n k : ℕ) : Except String (GemmProblem m n k) := do
  let kind ← input.getObjValAs? String "operation"
  let base := ["operation", "m", "n", "k"]
  if kind == "family" then
    allowedKeys input (base ++ ["a_bound", "b_bound", "c_bound"])
    return .family ⟨← PipelineAnalysis.rational input "a_bound",
      ← PipelineAnalysis.rational input "b_bound", ← PipelineAnalysis.rational input "c_bound"⟩
  else if kind == "entry_family" then
    allowedKeys input (base ++ ["a_bounds", "b_bounds", "c_bounds"])
    return .entryFamily (← ExtendedAnalysis.entryFamily input m n k)
  else if kind == "native" then
    allowedKeys input (base ++ ["precision", "a", "b", "c"])
    let p ← ExtendedAnalysis.precision (← input.getObjValAs? String "precision")
    return .native p (← words p.format.width m k (← input.getObjValAs? (Array ℕ) "a"))
      (← words p.format.width k n (← input.getObjValAs? (Array ℕ) "b"))
      (← words 32 m n (← input.getObjValAs? (Array ℕ) "c"))
  else if kind == "native_scaled" then
    allowedKeys input (base ++ ["precision", "a", "b", "c", "input_format", "output_format", "output_mode", "alpha", "beta"])
    if (← input.getObjValAs? String "output_format") != "fp32" then throw "Native selection requires FP32 output"
    let precision ← ExtendedAnalysis.precision (← input.getObjValAs? String "precision")
    let source ← NativePipeline.sourceFormat (← input.getObjValAs? String "input_format")
    return .nativeScaled precision source (← mode (← input.getObjValAs? String "output_mode"))
      (← scalar input "alpha") (← scalar input "beta")
      (← words source.width m k (← input.getObjValAs? (Array ℕ) "a"))
      (← words source.width k n (← input.getObjValAs? (Array ℕ) "b"))
      (← words 32 m n (← input.getObjValAs? (Array ℕ) "c"))
  else if kind == "raw" then
    allowedKeys input (base ++ ["a", "b", "c"])
    return .raw (← words 16 m k (← input.getObjValAs? (Array ℕ) "a"))
      (← words 16 k n (← input.getObjValAs? (Array ℕ) "b"))
      (← words 32 m n (← input.getObjValAs? (Array ℕ) "c"))
  else if kind == "scaled" then
    allowedKeys input (base ++ ["a", "b", "c", "input_format", "output_format", "alpha", "beta"])
    if (← input.getObjValAs? String "output_format") != "fp32" then
      throw "Selection requires FP32 output"
    let source ← format (← input.getObjValAs? String "input_format")
    return .scaled source (← scalar input "alpha") (← scalar input "beta")
      (← words source.width m k (← input.getObjValAs? (Array ℕ) "a"))
      (← words source.width k n (← input.getObjValAs? (Array ℕ) "b"))
      (← words 32 m n (← input.getObjValAs? (Array ℕ) "c"))
  else throw "Expected selection workload operation raw, scaled, family, entry_family, native, or native_scaled"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.ExtendedAnalysis.entryFamily](ExtendedAnalysis.md#decl-984f320bce724d96), [TensorCore.Cli.ExtendedAnalysis.precision](ExtendedAnalysis.md#decl-070682d91fce08b6), [TensorCore.Cli.GemmInput.format](GemmInput.md#decl-de05af7e33d3efef), [TensorCore.Cli.GemmInput.mode](GemmInput.md#decl-537adc255c27ce81), [TensorCore.Cli.GemmInput.scalar](GemmInput.md#decl-dea3790eaa6416ad), [TensorCore.Cli.GemmInput.words](GemmInput.md#decl-28dd181dd1f5acb4), [TensorCore.Cli.NativePipeline.sourceFormat](NativePipeline.md#decl-e6098145378277af), [TensorCore.Cli.PipelineAnalysis.rational](PipelineAnalysis.md#decl-83d29b5f944a2b20), [TensorCore.Cli.Selection.allowedKeys](GemmSelection.md#decl-e1097a8a93ee5d64), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae)

</details>

</details>

<a id="decl-d9ed69e91d255373"></a>

<details>
<summary><code>TensorCore.Cli.Selection.analysis</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmSelection.lean#L70)

```lean
def analysis (p : GemmProblem m n k) (c : GemmCandidate) (tol : ℚ) : Json :=
  match p with
  | .raw A B C => Analysis.report c.model A B C tol
  | .scaled source alpha beta A B C =>
    PipelineAnalysis.report source c.inputMode c.model c.epilogue alpha beta A B C tol
  | .family f => PipelineAnalysis.familyReport c.model m n k f tol
  | .entryFamily f => ExtendedAnalysis.entryReport c.model f tol
  | .native precision A B C => match c.nativeModel precision with
    | some model => ExtendedAnalysis.nativeReport model A B C tol
    | none => Json.mkObj [("accepted", toJson false), ("reason", toJson "unsupported_native_model")]
  | .nativeScaled precision source outputMode alpha beta A B C => match c.nativeModel precision with
    | some model => NativePipeline.report source c.inputMode model (c.nativeEpilogue outputMode) alpha beta A B C tol
    | none => Json.mkObj [("accepted", toJson false), ("reason", toJson "unsupported_native_model")]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Cli.Analysis.report](Analysis.md#decl-fe1abe7d61ee46e3), [TensorCore.Cli.ExtendedAnalysis.entryReport](ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.ExtendedAnalysis.nativeReport](ExtendedAnalysis.md#decl-f2295e1f16de52c7), [TensorCore.Cli.NativePipeline.report](NativePipeline.md#decl-15052b6ec6a59317), [TensorCore.Cli.PipelineAnalysis.familyReport](PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.Cli.PipelineAnalysis.report](PipelineAnalysis.md#decl-9efe788a4da8437d), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.GemmCandidate.epilogue](../Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](../Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmCandidate.nativeModel](../Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmFamily](../Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae)

</details>

</details>

<a id="decl-9c94d65d36739b3d"></a>

<details>
<summary><code>TensorCore.Cli.Selection.executionRequest</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmSelection.lean#L84)

```lean
def executionRequest (workload config : Json) : Except String Json := do
  let kind ← workload.getObjValAs? String "operation"
  let fields := (← workload.getObj?).toList.filter fun (key, _) => key != "operation"
  let fields := fields ++ (← config.getObj?).toList
  return Json.mkObj (("operation", toJson (if kind == "family" then "analyze_family" else if kind == "entry_family" then "analyze_entry_family" else kind)) ::
    fields ++ if kind == "scaled" then [("output_mode", toJson "rne")] else [])
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Selection.allowedKeys](GemmSelection.md#decl-e1097a8a93ee5d64)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.evaluate](GemmSelection.md#decl-aa21b3bd9b0a9fae)

</details>

</details>

<a id="decl-aa21b3bd9b0a9fae"></a>

<details>
<summary><code>TensorCore.Cli.Selection.evaluate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Cli/GemmSelection.lean#L91)

```lean
def evaluate (input : Json) : Except String Json := do
  allowedKeys input ["operation", "name", "workload", "candidates", "absolute_tolerance", "policy", "costs"]
  if (input.getObjVal? "name").isOk then
    let _ ← input.getObjValAs? String "name"
    pure ()
  let workload ← input.getObjVal? "workload"
  let kind ← workload.getObjValAs? String "operation"
  let m ← workload.getObjValAs? ℕ "m"
  let n ← workload.getObjValAs? ℕ "n"
  let k ← workload.getObjValAs? ℕ "k"
  let p ← problem workload m n k
  let configs ← input.getObjValAs? (Array Json) "candidates"
  if configs.isEmpty then throw "Selection requires at least one candidate"
  let candidates ← configs.toList.mapM (candidate kind)
  let tol ← Analysis.tolerance input
  if kind == "native" || kind == "native_scaled" then
    let precision ← ExtendedAnalysis.precision (← workload.getObjValAs? String "precision")
    for c in candidates do
      if (c.nativeModel precision).isNone then throw "Unsupported native candidate"
  let policy ← if (input.getObjVal? "policy").isOk then input.getObjValAs? String "policy" else pure "preference"
  if policy != "preference" && policy != "minimum_cost" then throw "Policy must be preference or minimum_cost"
  let costs ← if policy == "minimum_cost" then do
      let values ← input.getObjValAs? (Array String) "costs"
      if values.size != configs.size then throw "One cost is required per candidate"
      values.toList.mapM fun value => Analysis.tolerance (Json.mkObj [("absolute_tolerance", toJson value)])
    else do
      if (input.getObjVal? "costs").isOk then throw "Costs require minimum_cost policy"
      pure []
  let costed := (candidates.zip costs).zipIdx.map fun ((c, cost), i) => (⟨c, cost, i⟩ : CostedCandidate)
  let chosenCost := selectGemmCost p costed tol
  let selected := if policy == "minimum_cost" then chosenCost.map (·.index) else selectGemm p candidates tol
  let reports := candidates.map fun c => analysis p c tol
  let request ← match selected with
    | none => pure Json.null
    | some i => do
      let request ← executionRequest workload configs[i]!
      let fields := (← request.getObj?).toList
      pure (Json.mkObj (fields ++ if kind == "family" || kind == "entry_family" then
        [("absolute_tolerance", toJson (Analysis.ratText tol))] else []))
  return Json.mkObj [
    ("status", toJson (if selected.isSome then "selected" else "inconclusive")),
    ("accepted", toJson selected.isSome),
    ("name", (input.getObjVal? "name").toOption.getD Json.null),
    ("policy", toJson (if policy == "minimum_cost" then "minimum_supplied_cost_among_certified" else "first_certified_in_preference_order")),
    ("selected_cost", if policy == "minimum_cost" then toJson (chosenCost.map fun c => Analysis.ratText c.cost) else Json.null),
    ("reason", toJson (if selected.isSome then "tolerance_met" else "no_candidate_certified")),
    ("absolute_tolerance", toJson (Analysis.ratText tol)),
    ("selected_index", toJson selected),
    ("selected_candidate", toJson (selected.map fun i => configs[i]!)),
    ("selected_request", request),
    ("candidates", toJson (reports.zipIdx.map fun (r, i) => Json.mkObj [
      ("index", toJson i), ("configuration", configs[i]!), ("analysis", r)]))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Cli.Analysis.ratText](Analysis.md#decl-37884758ff4f6366), [TensorCore.Cli.Analysis.tolerance](Analysis.md#decl-1f136b0f7b3b213b), [TensorCore.Cli.ExtendedAnalysis.precision](ExtendedAnalysis.md#decl-070682d91fce08b6), [TensorCore.Cli.Selection.allowedKeys](GemmSelection.md#decl-e1097a8a93ee5d64), [TensorCore.Cli.Selection.analysis](GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.candidate](GemmSelection.md#decl-0ce6164bf816c3c9), [TensorCore.Cli.Selection.executionRequest](GemmSelection.md#decl-9c94d65d36739b3d), [TensorCore.Cli.Selection.problem](GemmSelection.md#decl-2fb1639c2044a112), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.GemmCandidate.nativeModel](../Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.selectGemm](../Selection.md#decl-ac87128da56c0502), [TensorCore.selectGemmCost](../CostSelection.md#decl-11498eca158bf117)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Gemm.md#decl-a984a36184ce8479)

</details>

</details>
