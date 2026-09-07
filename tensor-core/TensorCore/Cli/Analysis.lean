import TensorCore.Programs.GemmAnalysis
import Lean

namespace TensorCore.Cli.Analysis

open Lean

def ratText (q : Rat) : String := s!"{q.num}/{q.den}"

def tolerance (input : Json) : Except String Rat := do
  let text ← input.getObjValAs? String "absolute_tolerance"
  match text.splitOn "/" with
  | [numerator, denominator] =>
    match numerator.toInt?, denominator.toNat? with
    | some n, some d =>
      if n < 0 || d == 0 then .error "Tolerance must be a nonnegative rational with positive denominator"
      else .ok ((n : Rat) / (d : Rat))
    | _, _ => .error "Expected absolute_tolerance as numerator/denominator"
  | _ => .error "Expected absolute_tolerance as numerator/denominator"

def witnessJson (w : GroupWitness) : Json := Json.mkObj [
  ("scale", toJson w.scale), ("output_scale", toJson w.outputScale)]

def cellJson : Option CellAnalysis → Json
  | none => Json.null
  | some a => Json.mkObj [
      ("error_bound", toJson (ratText a.bound.error)),
      ("magnitude_bound", toJson (ratText a.bound.magnitude)),
      ("alignment_bound", toJson (ratText a.bound.alignment)),
      ("rounding_bound", toJson (ratText a.bound.rounding)),
      ("witness", toJson (a.witness.map witnessJson))]

def report (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) (tol : Rat) : Json :=
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

end TensorCore.Cli.Analysis
