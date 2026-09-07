import TensorCore.Programs.GemmTightInputBounds
import TensorCore.Cli.PipelineAnalysis
import Lean

namespace TensorCore.Cli.Gemm

open Lean

private def ratText (q : Rat) : String := s!"{q.num}/{q.den}"

private def cellJson : Except ModelError GemmCell → Json
  | .error e => Json.mkObj [("error", toJson (reprStr e))]
  | .ok c => Json.mkObj [
      ("bits", toJson c.output.bits.toNat),
      ("value", toJson (ratText c.output.value)),
      ("initial", toJson c.initial.bits.toNat),
      ("instructions", toJson (c.instructions.map fun ts => ts.map fun t => t.output.bits.toNat)),
      ("error_budget", toJson (ratText c.errorBudget))]

private def words (width rows cols : Nat) (xs : Array Nat) :
    Except String (DenseMatrix (BitVec width) rows cols) :=
  if xs.size != rows * cols then .error "Matrix shape does not match its word count"
  else if xs.any (· ≥ 2 ^ width) then .error "Operand word exceeds its format width"
  else .ok (DenseMatrix.ofFn fun i j => BitVec.ofNat width xs[i.val * cols + j.val]!)

private def scalar (input : Json) (key : String) : Except String F32 := do
  let n ← input.getObjValAs? Nat key
  if n ≥ 2 ^ 32 then .error "Scalar word exceeds FP32 width" else .ok (BitVec.ofNat 32 n)

private def mode : String → Except String BinaryRoundingMode
  | "rne" => .ok .nearestEven | "rtz" => .ok .towardZero
  | "rdn" => .ok .towardNegative | "rup" => .ok .towardPositive
  | _ => .error "Expected rounding mode rne, rtz, rdn, or rup"

private def format : String → Except String TensorCore.Format
  | "fp16" => .ok fp16 | "fp32" => .ok fp32
  | "bf16" => .ok bf16 | "fp64" => .ok fp64
  | _ => .error "Expected format fp16, fp32, bf16, or fp64"

private def model : String → Except String WmmaGemmModel
  | "v100" => .ok .v100 | "ampere" => .ok .ampere | "hopper" => .ok .hopper
  | _ => .error "Expected model v100, ampere, or hopper"

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

def evaluate (input : Json) : Except String Json := do
  let architecture ← model (← input.getObjValAs? String "model")
  let m ← input.getObjValAs? Nat "m"
  let n ← input.getObjValAs? Nat "n"
  let k ← input.getObjValAs? Nat "k"
  let operation ← input.getObjValAs? String "operation"
  if operation == "analyze_family" then
    let a ← PipelineAnalysis.rational input "a_bound"
    let b ← PipelineAnalysis.rational input "b_bound"
    let c ← PipelineAnalysis.rational input "c_bound"
    return PipelineAnalysis.familyReport architecture m n k ⟨a, b, c⟩ (← Analysis.tolerance input)
  let C ← words 32 m n (← input.getObjValAs? (Array Nat) "c")
  match operation with
  | "analyze" =>
    let A ← words 16 m k (← input.getObjValAs? (Array Nat) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array Nat) "b")
    return Analysis.report architecture A B C (← Analysis.tolerance input)
  | "raw" =>
    let A ← words 16 m k (← input.getObjValAs? (Array Nat) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array Nat) "b")
    return Json.mkObj [
      ("rows", matrixJson (gemm architecture A B C) cellJson),
      ("ideal", matrixJson (gemmIdeal A B C) fun q => toJson (q.map ratText)),
      ("tile_instructions", toJson (gemmTileSchedule m n k).length)]
  | "certify" =>
    let A ← words 16 m k (← input.getObjValAs? (Array Nat) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array Nat) "b")
    let E ← input.getObjValAs? Int "accumulator_scale"
    let P ← input.getObjValAs? Int "product_scale"
    let L ← input.getObjValAs? Nat "carry_bits"
    let cBound ← input.getObjValAs? Int "initial_bound"
    let cfg : GemmBoundConfig := ⟨E, P, L, cBound⟩
    let bound := gemmStaticError architecture cfg k
    return Json.mkObj [("accepted", toJson (gemmCheck architecture cfg A B C)),
      ("entry_bound", toJson (ratText bound)),
      ("matrix_bound", toJson (ratText ((m : Rat) * (n : Rat) * bound)))]
  | "scaled" | "certify_scaled" | "analyze_scaled" =>
    let source ← format (← input.getObjValAs? String "input_format")
    let target ← format (← input.getObjValAs? String "output_format")
    let im ← mode (← input.getObjValAs? String "input_mode")
    let mm ← mode (← input.getObjValAs? String "multiply_mode")
    let am ← mode (← input.getObjValAs? String "add_mode")
    let om ← mode (← input.getObjValAs? String "output_mode")
    let alpha ← scalar input "alpha"
    let beta ← scalar input "beta"
    let a ← words source.width m k (← input.getObjValAs? (Array Nat) "a")
    let b ← words source.width k n (← input.getObjValAs? (Array Nat) "b")
    let cfg : GemmEpilogue := ⟨mm, am, ⟨target, om⟩⟩
    if operation == "analyze_scaled" then
      return PipelineAnalysis.report source im architecture cfg alpha beta a b C (← Analysis.tolerance input)
    match convertGemmInput source im a, convertGemmInput source im b with
    | some A, some B =>
      if operation == "certify_scaled" then
        let E ← input.getObjValAs? Int "accumulator_scale"
        let P ← input.getObjValAs? Int "product_scale"
        let L ← input.getObjValAs? Nat "carry_bits"
        let cBound ← input.getObjValAs? Int "initial_bound"
        let aScale ← input.getObjValAs? Int "alpha_scale"
        let bScale ← input.getObjValAs? Int "beta_scale"
        let sScale ← input.getObjValAs? Int "sum_scale"
        let oScale ← input.getObjValAs? Int "output_scale"
        let bounds : ScaledGemmBoundConfig := ⟨⟨E, P, L, cBound⟩, aScale, bScale, sScale, oScale⟩
        let error := scaledGemmStaticError architecture cfg bounds alpha k
        let sourceCertificate := convertedGemmSourceCertificate source im architecture cfg bounds
          alpha beta a b C
        let tightError := scaledGemmTightError architecture cfg bounds alpha k
        let tightCertificate := convertedGemmTightSourceCertificate source im architecture cfg bounds
          alpha beta a b C
        return Json.mkObj [("accepted", toJson (scaledGemmCheck architecture cfg bounds alpha beta A B C)),
          ("entry_bound", toJson (ratText error)),
          ("matrix_bound", toJson (ratText ((m : Rat) * (n : Rat) * error))),
          ("source_entry_bounds", toJson (sourceCertificate.map fun E => matrixJson E (toJson ∘ ratText))),
          ("source_matrix_bound", toJson (sourceCertificate.map fun E => ratText (matrixAbsSum E))),
          ("tight_entry_bound", toJson (ratText tightError)),
          ("tight_matrix_bound", toJson (ratText ((m : Rat) * (n : Rat) * tightError))),
          ("tight_source_entry_bounds", toJson (tightCertificate.map fun E => matrixJson E (toJson ∘ ratText))),
          ("tight_source_matrix_bound", toJson (tightCertificate.map fun E => ratText (matrixAbsSum E)))]
      else
        return Json.mkObj [
          ("rows", matrixJson (scaledGemm architecture cfg alpha beta A B C) scaledCellJson),
          ("ideal", matrixJson (scaledGemmIdeal alpha beta A B C) fun v => toJson (v.map ratText)),
          ("source_ideal", matrixJson (sourceGemmIdeal source alpha beta a b C) fun v => toJson (v.map ratText)),
          ("input_product_bound", matrixJson (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) =>
            gemmInputProductError source im (sourceGemmPairs source a b i j)) fun v => toJson (v.map ratText)),
          ("converted_a", matrixJson A fun x => toJson x.toNat),
          ("converted_b", matrixJson B fun x => toJson x.toNat)]
    | _, _ =>
      return Json.mkObj (("input_conversion_rejected", toJson true) ::
        if operation == "certify_scaled" then [("accepted", toJson false)] else [])
  | _ => .error "Expected operation raw, certify, scaled, certify_scaled, analyze, analyze_scaled, or analyze_family"


end TensorCore.Cli.Gemm
