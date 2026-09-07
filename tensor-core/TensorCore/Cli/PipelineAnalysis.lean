import TensorCore.Cli.Analysis
import TensorCore.Programs.ConvertedGemmAnalysis
import TensorCore.Programs.GemmFamily

namespace TensorCore.Cli.PipelineAnalysis

open Lean Analysis

def rational (input : Json) (key : String) : Except String Rat := do
  let value ← input.getObjValAs? String key
  tolerance (Json.mkObj [("absolute_tolerance", toJson value)])

def scaledWitnessJson (w : ScaledWitness) : Json := Json.mkObj [
  ("groups", toJson (w.groups.map witnessJson)),
  ("alpha_scale", toJson w.epilogue.alphaScale), ("beta_scale", toJson w.epilogue.betaScale),
  ("sum_scale", toJson w.epilogue.sumScale), ("output_scale", toJson w.epilogue.outputScale)]

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

def report (source : Format) (mode : BinaryRoundingMode) (model : WmmaGemmModel)
    (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : Rat) : Json :=
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

def familyWitnessJson (cfg : GemmBoundConfig) : Json := Json.mkObj [
  ("accumulator_scale", toJson cfg.accumulatorScale), ("product_scale", toJson cfg.productScale),
  ("carry_bits", toJson cfg.carryBits), ("initial_bound", toJson (ratText cfg.initialBound))]

def familyReport (model : WmmaGemmModel) (m n k : Nat) (f : GemmFamily) (tol : Rat) : Json :=
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
    ("matrix_bound", toJson (bound.map fun b => ratText ((m : Rat) * (n : Rat) * b))),
    ("witness", toJson (witness.map familyWitnessJson))]

end TensorCore.Cli.PipelineAnalysis
