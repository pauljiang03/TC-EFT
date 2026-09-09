-- Gemm for GEMM.

import TensorCore.Gemm.TightInputBounds
import TensorCore.Gemm.Cli.PipelineAnalysis
import TensorCore.Gemm.Cli.GemmSelection
import Lean

namespace TensorCore.Cli.Gemm

open Lean GemmInput

private def ratText (q : ℚ) : String := s!"{q.num}/{q.den}"

private def cellJson : Except ModelError GemmCell → Json
  | .error e => Json.mkObj [("error", toJson (reprStr e))]
  | .ok c => Json.mkObj [
      ("bits", toJson c.output.bits.toNat),
      ("value", toJson (ratText c.output.value)),
      ("initial", toJson c.initial.bits.toNat),
      ("instructions", toJson (c.instructions.map fun ts => ts.map fun t => t.output.bits.toNat)),
      ("error_budget", toJson (ratText c.errorBudget))]

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
  if (← input.getObjValAs? String "operation") == "select" then
    return ← Selection.evaluate input
  if ["native", "analyze_native", "analyze_entry_family"].contains (← input.getObjValAs? String "operation") then
    return ← ExtendedAnalysis.evaluate input
  if ["native_scaled", "analyze_native_scaled"].contains (← input.getObjValAs? String "operation") then
    return ← NativePipeline.evaluate input
  let architecture ← model (← input.getObjValAs? String "model")
  let m ← input.getObjValAs? ℕ "m"
  let n ← input.getObjValAs? ℕ "n"
  let k ← input.getObjValAs? ℕ "k"
  let operation ← input.getObjValAs? String "operation"
  if operation == "analyze_family" then
    let a ← PipelineAnalysis.rational input "a_bound"
    let b ← PipelineAnalysis.rational input "b_bound"
    let c ← PipelineAnalysis.rational input "c_bound"
    return PipelineAnalysis.familyReport architecture m n k ⟨a, b, c⟩ (← Analysis.tolerance input)
  let C ← words 32 m n (← input.getObjValAs? (Array ℕ) "c")
  match operation with
  | "analyze" =>
    let A ← words 16 m k (← input.getObjValAs? (Array ℕ) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array ℕ) "b")
    return Analysis.report architecture A B C (← Analysis.tolerance input)
  | "raw" =>
    let A ← words 16 m k (← input.getObjValAs? (Array ℕ) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array ℕ) "b")
    return Json.mkObj [
      ("rows", matrixJson (gemm architecture A B C) cellJson),
      ("ideal", matrixJson (gemmIdeal A B C) fun q => toJson (q.map ratText)),
      ("tile_instructions", toJson (gemmTileSchedule m n k).length)]
  | "certify" =>
    let A ← words 16 m k (← input.getObjValAs? (Array ℕ) "a")
    let B ← words 16 k n (← input.getObjValAs? (Array ℕ) "b")
    let E ← input.getObjValAs? ℤ "accumulator_scale"
    let P ← input.getObjValAs? ℤ "product_scale"
    let L ← input.getObjValAs? ℕ "carry_bits"
    let cBound ← input.getObjValAs? ℤ "initial_bound"
    let cfg : GemmBoundConfig := ⟨E, P, L, cBound⟩
    let bound := gemmStaticError architecture cfg k
    return Json.mkObj [("accepted", toJson (gemmCheck architecture cfg A B C)),
      ("entry_bound", toJson (ratText bound)),
      ("matrix_bound", toJson (ratText ((m : ℚ) * (n : ℚ) * bound)))]
  | "scaled" | "certify_scaled" | "analyze_scaled" =>
    let source ← format (← input.getObjValAs? String "input_format")
    let target ← format (← input.getObjValAs? String "output_format")
    let im ← mode (← input.getObjValAs? String "input_mode")
    let mm ← mode (← input.getObjValAs? String "multiply_mode")
    let am ← mode (← input.getObjValAs? String "add_mode")
    let om ← mode (← input.getObjValAs? String "output_mode")
    let alpha ← scalar input "alpha"
    let beta ← scalar input "beta"
    let a ← words source.width m k (← input.getObjValAs? (Array ℕ) "a")
    let b ← words source.width k n (← input.getObjValAs? (Array ℕ) "b")
    let cfg : GemmEpilogue := ⟨mm, am, ⟨target, om⟩⟩
    if operation == "analyze_scaled" then
      return PipelineAnalysis.report source im architecture cfg alpha beta a b C (← Analysis.tolerance input)
    match convertGemmInput source im a, convertGemmInput source im b with
    | some A, some B =>
      if operation == "certify_scaled" then
        let E ← input.getObjValAs? ℤ "accumulator_scale"
        let P ← input.getObjValAs? ℤ "product_scale"
        let L ← input.getObjValAs? ℕ "carry_bits"
        let cBound ← input.getObjValAs? ℤ "initial_bound"
        let aScale ← input.getObjValAs? ℤ "alpha_scale"
        let bScale ← input.getObjValAs? ℤ "beta_scale"
        let sScale ← input.getObjValAs? ℤ "sum_scale"
        let oScale ← input.getObjValAs? ℤ "output_scale"
        let bounds : ScaledGemmBoundConfig := ⟨⟨E, P, L, cBound⟩, aScale, bScale, sScale, oScale⟩
        let error := scaledGemmStaticError architecture cfg bounds alpha k
        let sourceCertificate := convertedGemmSourceCertificate source im architecture cfg bounds
          alpha beta a b C
        let tightError := scaledGemmTightError architecture cfg bounds alpha k
        let tightCertificate := convertedGemmTightSourceCertificate source im architecture cfg bounds
          alpha beta a b C
        return Json.mkObj [("accepted", toJson (scaledGemmCheck architecture cfg bounds alpha beta A B C)),
          ("entry_bound", toJson (ratText error)),
          ("matrix_bound", toJson (ratText ((m : ℚ) * (n : ℚ) * error))),
          ("source_entry_bounds", toJson (sourceCertificate.map fun E => matrixJson E (toJson ∘ ratText))),
          ("source_matrix_bound", toJson (sourceCertificate.map fun E => ratText (matrixAbsSum E))),
          ("tight_entry_bound", toJson (ratText tightError)),
          ("tight_matrix_bound", toJson (ratText ((m : ℚ) * (n : ℚ) * tightError))),
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
