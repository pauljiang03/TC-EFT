import TensorCore.Programs.Instruction
import Lean

/-! Model-only expectations for the pinned instruction paths, with all 16 positions.
Input: profile, 32 decimal interleaved FP16 words, decimal FP32 accumulator. -/
open TensorCore Lean

private def pairs : List Nat → List (F16 × F16)
  | a :: b :: xs => (BitVec.ofNat 16 a, BitVec.ofNat 16 b) :: pairs xs
  | _ => []

def main (args : List String) : IO Unit := do
  let [file] := args | throw (IO.userError "Expected vector file")
  for line in (← IO.FS.readFile file).splitOn "\n" do
    let words := (line.splitOn " ").filter (· != "")
    unless words.isEmpty do
      let profile :: words := words | throw (IO.userError "Missing profile")
      let path ← match profile with
        | "V100" => pure v100Wmma16
        | "A100" => pure ampereWmma16
        | "H100" => pure hopperWmma16
        | _ => throw (IO.userError "Unknown profile")
      let some words := words.mapM String.toNat? | throw (IO.userError "Invalid word")
      unless words.length = 33 && (words.take 32).all (· < 65536) &&
          words.getLast! < 4294967296 do throw (IO.userError "Invalid shape or width")
      IO.println (toJson ((path.output (BitVec.ofNat 32 words.getLast!)
        (pairs (words.take 32))).map BitVec.toNat)).compress
