-- IEEE for the executable examples.

import TensorCore.IEEE.NativeOperations
import Lean

namespace TensorCore.Cli.IEEE
open Lean TensorCore.IEEE

def format : String → Except String BinaryFormat
  | "fp16" => .ok .binary16
  | "fp32" => .ok .binary32
  | "fp64" => .ok .binary64
  | _ => .error "Expected IEEE format fp16, fp32, or fp64"

def mode : String → Except String BinaryRoundingMode
  | "rne" => .ok .nearestEven
  | "rtz" => .ok .towardZero
  | "rdn" => .ok .towardNegative
  | "rup" => .ok .towardPositive
  | _ => .error "Expected rounding mode rne, rtz, rdn, or rup"

def tininess : String → Except String Tininess
  | "before" => .ok .beforeRounding
  | "after" => .ok .afterRounding
  | _ => .error "Expected tininess before or after"

def word (f : BinaryFormat) (j : Json) (key : String) : Except String (Word f) := do
  let n ← j.getObjValAs? ℕ key
  if n < 2 ^ f.layout.width then return BitVec.ofNat _ n
  else .error s!"{key}: word exceeds format width"

def flagsJson (f : Flags) : Json := Json.mkObj [
  ("invalid", toJson f.invalid), ("divide_by_zero", toJson f.divideByZero),
  ("overflow", toJson f.overflow), ("underflow", toJson f.underflow), ("inexact", toJson f.inexact)]

def evaluate (j : Json) : Except String Json := do
  let operation ← j.getObjValAs? String "operation"
  let f ← j.getObjValAs? String "format" >>= format
  let rounding ← j.getObjValAs? String "mode" >>= mode
  let tinyMode ← match j.getObjVal? "tininess" with
    | .error _ => pure Tininess.afterRounding
    | .ok value => value.getStr? >>= tininess
  let cfg : Context := ⟨rounding, tinyMode⟩
  let a ← word f j "a"
  let output ← match operation with
    | "convert" => do
        let target ← j.getObjValAs? String "target" >>= format
        let r := convert f target cfg a
        pure (r.bits.toNat, r.flags)
    | "add" | "sub" | "mul" | "fma" => do
        let b ← word f j "b"
        let r : Result f ← match operation with
          | "add" => pure (addWithLean f cfg a b)
          | "sub" => pure (subWithLean f cfg a b)
          | "mul" => pure (mulWithLean f cfg a b)
          | _ => do
              let c ← word f j "c"
              pure (fma f cfg a b c)
        pure (r.bits.toNat, r.flags)
    | _ => .error "Expected operation convert, add, sub, mul, or fma"
  return Json.mkObj [("bits", toJson output.1), ("flags", flagsJson output.2)]

end TensorCore.Cli.IEEE
