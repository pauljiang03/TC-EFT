import Lean
import TensorCore.Regression.CutlassWmma

/-! Run: lake env lean --run examples/CutlassWmma.lean
The JSON is compared to an independent rational oracle by check_cutlass.py.
On a V100/CUDA system, compare it with the pinned C++ fixture's JSON as well. -/

open TensorCore TensorCore.Regression Lean

def main : IO Unit := do
  let outputs := gemmBits .v100 cutlassA cutlassB cutlassC
  let bits := outputs.toArray.flatMap fun row => row.toArray.map fun cell =>
    cell.toOption.map BitVec.toNat
  IO.println (Json.compress (Json.mkObj [
    ("m", toJson (65 : Nat)), ("n", toJson (67 : Nat)), ("k", toJson (32 : Nat)),
    ("bits", toJson bits)]))
