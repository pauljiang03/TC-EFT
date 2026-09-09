-- Extended Analysis for GEMM.

import TensorCore.Gemm.Cli.PipelineAnalysis
import TensorCore.Gemm.Cli.GemmInput
import TensorCore.Gemm.EntryFamily
import TensorCore.Gemm.Specification.NativeGemmEquivalence

namespace TensorCore.Cli.ExtendedAnalysis

open Lean Analysis GemmInput

def precision : String → Except String NativePrecision
  | "bf16" => .ok .bf16 | "tf32" => .ok .tf32
  | _ => .error "Native precision must be bf16 or tf32 (packed 19-bit words)"

def nativeModel (p : NativePrecision) (name : String) : Except String (NativeGemmModel p) :=
  match p, name with
  | _, "ampere" => .ok .ampere
  | _, "hopper" => .ok .hopper
  | .tf32, "hopper_mma" => .ok .hopperMma
  | _, _ => .error "Unsupported native model and precision combination"

def caps (input : Json) (key : String) (m n : ℕ) : Except String (DenseMatrix ℚ m n) := do
  let values ← input.getObjValAs? (Array String) key
  if values.size != m * n then throw s!"Wrong {key} shape"
  let values ← values.mapM fun value => tolerance (Json.mkObj [("absolute_tolerance", toJson value)])
  return DenseMatrix.ofFn fun i j => values[i.val * n + j.val]!

def entryFamily (input : Json) (m n k : ℕ) : Except String (EntryFamily m n k) := do
  return ⟨← caps input "a_bounds" m k, ← caps input "b_bounds" k n, ← caps input "c_bounds" m n⟩

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

end TensorCore.Cli.ExtendedAnalysis
