import TensorCore.Cli.IEEE
import Init.Data.Float

/-! Differential-test runner. The logical model and the native operation are
evaluated separately. This executable supplies observations, not proofs. -/

open Lean TensorCore.IEEE

private def evaluate (j : Json) : Except String Json := do
  let op ← j.getObjValAs? String "operation"
  unless op == "add" || op == "sub" || op == "mul" do
    throw "Expected add, sub, or mul"
  unless (← j.getObjValAs? String "mode") == "rne" do
    throw "Lean comparison supports only nearest-even"
  let f ← j.getObjValAs? String "format" >>= TensorCore.Cli.IEEE.format
  let a ← TensorCore.Cli.IEEE.word f j "a"
  let b ← TensorCore.Cli.IEEE.word f j "b"
  let (logical, native) ← match f with
    | .binary16 => throw "Lean comparison supports fp32 and fp64"
    | .binary32 =>
      let ma := Float32.Model.ofBits (UInt32.ofNat a.toNat)
      let mb := Float32.Model.ofBits (UInt32.ofNat b.toNat)
      let na := Float32.ofBits (UInt32.ofNat a.toNat)
      let nb := Float32.ofBits (UInt32.ofNat b.toNat)
      let m := if op == "add" then ma + mb else if op == "sub" then ma - mb else ma * mb
      let n := if op == "add" then na + nb else if op == "sub" then na - nb else na * nb
      pure (m.toBits.toNat, n.toBits.toNat)
    | .binary64 =>
      let ma := Float.Model.ofBits (UInt64.ofNat a.toNat)
      let mb := Float.Model.ofBits (UInt64.ofNat b.toNat)
      let na := Float.ofBits (UInt64.ofNat a.toNat)
      let nb := Float.ofBits (UInt64.ofNat b.toNat)
      let m := if op == "add" then ma + mb else if op == "sub" then ma - mb else ma * mb
      let n := if op == "add" then na + nb else if op == "sub" then na - nb else na * nb
      pure (m.toBits.toNat, n.toBits.toNat)
  let tinyMode ← match j.getObjVal? "tininess" with
    | .error _ => pure Tininess.afterRounding
    | .ok value => value.getStr? >>= TensorCore.Cli.IEEE.tininess
  let cfg : Context := ⟨.nearestEven, tinyMode⟩
  let r := if op == "add" then add f cfg a b else if op == "sub" then sub f cfg a b else mul f cfg a b
  let reference := Json.mkObj [("bits", toJson r.bits.toNat), ("flags", TensorCore.Cli.IEEE.flagsJson r.flags)]
  let publicResult ← TensorCore.Cli.IEEE.evaluate j
  pure <| Json.mkObj [("logical_bits", toJson logical),
    ("native_bits", toJson native), ("reference", reference), ("public", publicResult)]

def main : IO UInt32 := do
  let input ← IO.getStdin
  let output ← IO.getStdout
  repeat
    let line ← input.getLine
    if line.isEmpty then return 0
    unless line.trimAscii.toString.isEmpty do
      match Json.parse line >>= evaluate with
      | .ok result => output.putStrLn result.compress
      | .error message =>
        (← IO.getStderr).putStrLn message
        return 2
  return 0
