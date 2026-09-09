import TensorCore.Gemm.Regression.Gemm
import Lean

/-! Run the demo: `lake env lean --run examples/Gemm.lean`.
Pass a JSONL file to simulate arbitrary dimensions. Each object contains model
(v100/ampere/hopper), m, n, k and flat row-major decimal word arrays a, b, c.
Inputs a/b are FP16 words; c is FP32. The operation is A*B+C (alpha=beta=1).
-/

open TensorCore Lean

private def ratText (q : ℚ) : String := s!"{q.num}/{q.den}"

private def cellJson : Except ModelError GemmCell → Json
  | .error e => Json.mkObj [("error", toJson (reprStr e))]
  | .ok c => Json.mkObj [
      ("bits", toJson c.output.bits.toNat),
      ("value", toJson (ratText c.output.value)),
      ("initial", toJson c.initial.bits.toNat),
      ("instructions", toJson (c.instructions.map fun ts => ts.map fun t => t.output.bits.toNat)),
      ("error_budget", toJson (ratText c.errorBudget))]

private def matrixWords (width rows cols : ℕ) (words : Array ℕ) :
    Except String (DenseMatrix (BitVec width) rows cols) :=
  if words.size != rows * cols then .error "Matrix shape does not match its word count"
  else if words.any (· ≥ 2 ^ width) then .error "Operand word exceeds its format width"
  else .ok (DenseMatrix.ofFn fun i j => BitVec.ofNat width words[i.val * cols + j.val]!)

private def parseModel : String → Except String WmmaGemmModel
  | "v100" => .ok .v100
  | "ampere" => .ok .ampere
  | "hopper" => .ok .hopper
  | _ => .error "Expected model v100, ampere, or hopper"

private def evaluate (input : Json) : Except String Json := do
  let model ← parseModel (← input.getObjValAs? String "model")
  let m ← input.getObjValAs? ℕ "m"
  let n ← input.getObjValAs? ℕ "n"
  let k ← input.getObjValAs? ℕ "k"
  let A ← matrixWords 16 m k (← input.getObjValAs? (Array ℕ) "a")
  let B ← matrixWords 16 k n (← input.getObjValAs? (Array ℕ) "b")
  let C ← matrixWords 32 m n (← input.getObjValAs? (Array ℕ) "c")
  let result := gemm model A B C
  let ideal := gemmIdeal A B C
  return Json.mkObj [
    ("rows", toJson (result.toArray.map fun row => row.toArray.map cellJson)),
    ("ideal", toJson (ideal.toArray.map fun row => row.toArray.map fun q => q.map ratText)),
    ("tile_instructions", toJson (gemmTileSchedule m n k).length)]

private def printMatrix (matrix : DenseMatrix (Except ModelError GemmCell) m n) : IO Unit := do
  for row in matrix.toArray do
    let values := row.toArray.map fun cell => match cell with
      | .error e => reprStr e
      | .ok c => toString c.output.value
    IO.println ("[" ++ String.intercalate ", " values.toList ++ "]")

def main (args : List String) : IO Unit := do
  match args with
  | [] =>
    IO.println "WMMA m16n16k16; FP16 A/B, FP32 C; A*B+C"
    for model in [WmmaGemmModel.v100, .ampere, .hopper] do
      IO.println s!"\n{repr model}: (2x5) * (5x3) + (2x3)"
      printMatrix (gemm model Regression.gemmA Regression.gemmB Regression.gemmC)
      IO.println "17 tiny products plus 1 (two WMMA instructions):"
      printMatrix (gemm model Regression.gemmTinyA Regression.gemmTinyB Regression.gemmOne)
  | [path] =>
    for line in (← IO.FS.readFile path).splitOn "\n" do
      unless line.isEmpty do
        match Json.parse line >>= evaluate with
        | .error e => throw (IO.userError e)
        | .ok out => IO.println out.compress
  | _ => throw (IO.userError "Usage: lean --run examples/Gemm.lean [cases.jsonl]")
