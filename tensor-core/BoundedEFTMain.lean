import TensorCore.Programs.BoundedEFT
import Lean

/-! Batch adapter for the bounded EFT. Parsing checks widths before constructing
words. Integer projections below are diagnostics, outside the execution path. -/

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

private def pairs (path : EFMachine.Path) : List Nat → Option (List (path.profile.Word × path.profile.Word))
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
        let result := EFMachine.algorithm1 path x d
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

private abbrev BenchBlock := (path : EFMachine.Path) × BlockInput path.profile × F32

private def benchBlock (args : List String) : Option BenchBlock := do
  let "block" :: name :: words := args | none
  let path ← getPath name
  let ns ← words.mapM String.toNat?
  if ns.length != path.profile.products * 2 + 2 then none else do
    let c := ns[path.profile.products * 2]!
    let D := ns[path.profile.products * 2 + 1]!
    if c ≥ 2 ^ 32 || D ≥ 2 ^ 32 then none else do
      let ps ← pairs path (ns.take (path.profile.products * 2))
      return ⟨path, ⟨ps, BitVec.ofNat _ c⟩, BitVec.ofNat _ D⟩

-- Keep the same call boundary in baseline and optimized native measurements.
@[noinline] private def benchRun (x : BenchBlock) : UInt64 :=
  match EFMachine.algorithm1 x.1 x.2.1 x.2.2 with
  | .error _ => 0xffffffffffffffff
  | .ok .allZero => 0
  | .ok (.scalar b) => b.toNat.toUInt64 + 0x100000000
  | .ok (.boundedExact b) => b.toNat.toUInt64 + 0x200000000
  | .ok .outOfRange => 0x300000000

private def benchmark (repeats : Nat) (path : String) : IO Unit := do
  let contents ← IO.FS.readFile path
  let mut blocks : Array BenchBlock := #[]
  for line in contents.splitOn "\n" do
    let words := (line.splitOn " ").filter (· != "")
    unless words.isEmpty do
      let some block := benchBlock words | throw (IO.userError "Invalid benchmark block")
      blocks := blocks.push block
  if repeats == 0 || blocks.isEmpty then throw (IO.userError "Benchmark needs blocks and positive repeats")
  let start ← IO.monoNanosNow
  let mut checksum : UInt64 := 0
  for _ in [:repeats] do
    for block in blocks do
      checksum := checksum + benchRun block
  let elapsed := (← IO.monoNanosNow) - start
  IO.println (Json.mkObj [("blocks", toJson blocks.size), ("repeats", toJson repeats),
    ("elapsed_ns", toJson elapsed), ("checksum", toJson checksum.toNat)]).compress

def main (args : List String) : IO Unit := do
  if let ["--benchmark", repeats, path] := args then
    let some n := repeats.toNat? | throw (IO.userError "Invalid repeat count")
    benchmark n path
    return
  let [path] := args | throw (IO.userError "Expected a batch input file")
  let contents ← IO.FS.readFile path
  for line in contents.splitOn "\n" do
    let words := (line.splitOn " ").filter (· != "")
    unless words.isEmpty do
      let some result := command words | throw (IO.userError "Invalid row or encoded width")
      IO.println result.compress
