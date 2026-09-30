import TensorCore.Kernels.EFT.Native
import Lean

/-! Batch adapter for the bounded EFT. -/

open TensorCore Lean

private def getPath : String → Option EFMachine.Path
  | "v100-fp16" => some .v100F16
  | "a100-fp16" => some .ampereF16
  | "h100-fp16" => some .hopperF16
  | "a100-bf16" => some .ampereBF16
  | "h100-bf16" => some .hopperBF16
  | "a100-tf32" => some .ampereTF32
  | "h100-tf32-k4" | "h100-tf32-wmma" => some .hopperTF32Wmma
  | "h100-tf32" | "h100-tf32-mma" => some .hopperTF32Mma
  | _ => none

private def pairs (path : EFMachine.Path) : List ℕ → Option (List (path.profile.Word × path.profile.Word))
  | [] => some []
  | a :: b :: xs => do
    if a ≥ 2 ^ path.profile.input.width || b ≥ 2 ^ path.profile.input.width then none
    else return (BitVec.ofNat _ a, BitVec.ofNat _ b) :: (← pairs path xs)
  | _ => none

private def command (args : List String) : Option Json := do
  match args with
  | "block" :: name :: words =>
    let path ← getPath name
    let ns ← words.mapM String.toNat?
    if ns.length != path.profile.products * 2 + 2 then none else do
      let c := ns[path.profile.products * 2]!
      let D := ns[path.profile.products * 2 + 1]!
      if c ≥ 2 ^ 32 || D ≥ 2 ^ 32 then none else do
        let ps ← pairs path (ns.take (path.profile.products * 2))
        let x : BlockInput path.profile := ⟨ps, BitVec.ofNat _ c⟩
        let d : F32 := BitVec.ofNat _ D
        let result := EFMachine.algorithm1WithLean path x d
        let components := (EFMachine.prepare path x d).toOption.bind EFMachine.extract
        return match result with
        | .error e => Json.mkObj [("error", toJson (reprStr e))]
        | .ok r => Json.mkObj [
            ("bits", toJson (r.bits.map BitVec.toNat)),
            ("branch", toJson (match r with
              | .allZero => "allZero" | .scalar _ => "scalar"
              | .boundedExact _ => "boundedExact" | .outOfRange => "outOfRange")),
            ("grid", toJson (components.map fun z => z.prepared.grid.toNat)),
            ("recovered", toJson (components.map fun z => toString z.recovered.coefficient)),
            ("overlap", toJson (components.map fun z => toString z.overlap.coefficient)),
            ("coarse", toJson (components.map fun z => z.coarse.map fun w => toString w.coefficient)),
            ("low", toJson (components.map fun z => z.low.map fun w => toString w.coefficient)),
            ("guard", toJson (components.map EFMachine.Components.scalarGuard))]
  | ["round", signed] =>
    let n ← signed.toInt?
    if n.natAbs ≥ 2 ^ 576 then none else do
      let x : EFMachine.Word := ⟨decide (n < 0), BitVec.ofNat 576 n.natAbs⟩
      return Json.mkObj [("bits", toJson (x.round32.map BitVec.toNat))]
  | _ => none

def main (args : List String) : IO Unit := do
  let [path] := args | throw (IO.userError "Expected a batch input file")
  let contents ← IO.FS.readFile path
  for line in contents.splitOn "\n" do
    let words := (line.splitOn " ").filter (· != "")
    unless words.isEmpty do
      let some result := command words | throw (IO.userError "Invalid row or encoded width")
      IO.println result.compress
