import TensorCore.Programs.GemmSelection
import TensorCore.Cli.GemmInput
import TensorCore.Cli.PipelineAnalysis

namespace TensorCore.Cli.Selection

open Lean GemmInput

def allowedKeys (input : Json) (allowed : List String) : Except String Unit := do
  let obj ← input.getObj?
  for (key, _) in obj.toList do
    if !allowed.contains key then throw s!"Unexpected selection field: {key}"

def candidate (kind : String) (input : Json) : Except String GemmCandidate := do
  if kind == "scaled" then
    allowedKeys input ["model", "input_mode", "multiply_mode", "add_mode"]
    return ⟨← model (← input.getObjValAs? String "model"),
      ← mode (← input.getObjValAs? String "input_mode"),
      ← mode (← input.getObjValAs? String "multiply_mode"),
      ← mode (← input.getObjValAs? String "add_mode")⟩
  else
    allowedKeys input ["model"]
    return { model := ← model (← input.getObjValAs? String "model") }

def problem (input : Json) (m n k : Nat) : Except String (GemmProblem m n k) := do
  let kind ← input.getObjValAs? String "operation"
  let base := ["operation", "m", "n", "k"]
  if kind == "family" then
    allowedKeys input (base ++ ["a_bound", "b_bound", "c_bound"])
    return .family ⟨← PipelineAnalysis.rational input "a_bound",
      ← PipelineAnalysis.rational input "b_bound", ← PipelineAnalysis.rational input "c_bound"⟩
  else if kind == "raw" then
    allowedKeys input (base ++ ["a", "b", "c"])
    return .raw (← words 16 m k (← input.getObjValAs? (Array Nat) "a"))
      (← words 16 k n (← input.getObjValAs? (Array Nat) "b"))
      (← words 32 m n (← input.getObjValAs? (Array Nat) "c"))
  else if kind == "scaled" then
    allowedKeys input (base ++ ["a", "b", "c", "input_format", "output_format", "alpha", "beta"])
    if (← input.getObjValAs? String "output_format") != "fp32" then
      throw "Selection requires FP32 output"
    let source ← format (← input.getObjValAs? String "input_format")
    return .scaled source (← scalar input "alpha") (← scalar input "beta")
      (← words source.width m k (← input.getObjValAs? (Array Nat) "a"))
      (← words source.width k n (← input.getObjValAs? (Array Nat) "b"))
      (← words 32 m n (← input.getObjValAs? (Array Nat) "c"))
  else throw "Expected selection workload operation raw, scaled, or family"

def analysis (p : GemmProblem m n k) (c : GemmCandidate) (tol : Rat) : Json :=
  match p with
  | .raw A B C => Analysis.report c.model A B C tol
  | .scaled source alpha beta A B C =>
    PipelineAnalysis.report source c.inputMode c.model c.epilogue alpha beta A B C tol
  | .family f => PipelineAnalysis.familyReport c.model m n k f tol

def executionRequest (workload config : Json) : Except String Json := do
  let kind ← workload.getObjValAs? String "operation"
  let fields := (← workload.getObj?).toList.filter fun (key, _) => key != "operation"
  let fields := fields ++ (← config.getObj?).toList
  return Json.mkObj (("operation", toJson (if kind == "family" then "analyze_family" else kind)) ::
    fields ++ if kind == "scaled" then [("output_mode", toJson "rne")] else [])

def evaluate (input : Json) : Except String Json := do
  allowedKeys input ["operation", "name", "workload", "candidates", "absolute_tolerance"]
  if (input.getObjVal? "name").isOk then
    let _ ← input.getObjValAs? String "name"
    pure ()
  let workload ← input.getObjVal? "workload"
  let kind ← workload.getObjValAs? String "operation"
  let m ← workload.getObjValAs? Nat "m"
  let n ← workload.getObjValAs? Nat "n"
  let k ← workload.getObjValAs? Nat "k"
  let p ← problem workload m n k
  let configs ← input.getObjValAs? (Array Json) "candidates"
  if configs.isEmpty then throw "Selection requires at least one candidate"
  let candidates ← configs.toList.mapM (candidate kind)
  let tol ← Analysis.tolerance input
  let selected := selectGemm p candidates tol
  let reports := candidates.map fun c => analysis p c tol
  let request ← match selected with
    | none => pure Json.null
    | some i => do
      let request ← executionRequest workload configs[i]!
      let fields := (← request.getObj?).toList
      pure (Json.mkObj (fields ++ if kind == "family" then
        [("absolute_tolerance", toJson (Analysis.ratText tol))] else []))
  return Json.mkObj [
    ("status", toJson (if selected.isSome then "selected" else "inconclusive")),
    ("accepted", toJson selected.isSome),
    ("name", (input.getObjVal? "name").toOption.getD Json.null),
    ("policy", toJson "first_certified_in_preference_order"),
    ("reason", toJson (if selected.isSome then "tolerance_met" else "no_candidate_certified")),
    ("absolute_tolerance", toJson (Analysis.ratText tol)),
    ("selected_index", toJson selected),
    ("selected_candidate", toJson (selected.map fun i => configs[i]!)),
    ("selected_request", request),
    ("candidates", toJson (reports.zipIdx.map fun (r, i) => Json.mkObj [
      ("index", toJson i), ("configuration", configs[i]!), ("analysis", r)]))]

end TensorCore.Cli.Selection
