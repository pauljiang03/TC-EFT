import TensorCore.Cli.ExtendedAnalysis
import TensorCore.Programs.NativeConvertedAnalysis

namespace TensorCore.Cli.NativePipeline

open Lean GemmInput Analysis PipelineAnalysis

def sourceFormat (name : String) : Except String Format :=
  if name == "tf32" then .ok tf19 else format name

def matrixJson (A : DenseMatrix α m n) (f : α → Json) : Json :=
  toJson (A.toArray.map fun row => row.toArray.map f)

def scaledCellJson : Option (ScaledGemmCell cfg) → Json
  | none => Json.null
  | some t => Json.mkObj [
      ("bits", toJson t.output.bits.toNat), ("value", toJson (ratText t.output.value)),
      ("product_bits", toJson t.product.output.bits.toNat),
      ("stages", toJson [t.scaledProduct.bits.toNat, t.scaledC.bits.toNat, t.sum.bits.toNat]),
      ("instructions", toJson (t.product.instructions.map fun ts => ts.map (·.output.bits.toNat))),
      ("error_budget", toJson (ratText t.errorBudget))]

def report (source : Format) (mode : BinaryRoundingMode) (model : NativeGemmModel p)
    (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : Rat) : Json :=
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
  let m ← input.getObjValAs? Nat "m"
  let n ← input.getObjValAs? Nat "n"
  let k ← input.getObjValAs? Nat "k"
  let A ← words source.width m k (← input.getObjValAs? (Array Nat) "a")
  let B ← words source.width k n (← input.getObjValAs? (Array Nat) "b")
  let C ← words 32 m n (← input.getObjValAs? (Array Nat) "c")
  let alpha ← scalar input "alpha"
  let beta ← scalar input "beta"
  if operation == "native_scaled" then return execution source im model cfg alpha beta A B C
  else if operation == "analyze_native_scaled" then return report source im model cfg alpha beta A B C (← tolerance input)
  else throw "Expected native_scaled or analyze_native_scaled"

end TensorCore.Cli.NativePipeline
