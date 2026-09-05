import TensorCore.Semantics.Profiles
import Lean

open TensorCore Lean

private def qText (q : Rat) : String := s!"{q.num}/{q.den}"

private def getFormat : String → Option TensorCore.Format
  | "fp16" => some fp16
  | "bf16" => some bf16
  | "tf19" => some tf19
  | "fp32" => some fp32
  | "fp64" => some fp64
  | "e5m2" => some e5m2
  | _ => none

private def getProfile : String → Option InvocationSpec
  | "v100" => some v100Invocation
  | "a100-f16" => some a100F16Invocation
  | "a100-bf16" => some a100BF16Invocation
  | "a100-tf32" => some a100TF32Invocation
  | "hopper-f16" => some hopperF16Invocation
  | "hopper-bf16" => some hopperBF16Invocation
  | "hopper-tf32-mma" => some hopperTF32MmaInvocation
  | "hopper-tf32-wmma" => some hopperTF32WmmaInvocation
  | "half-direct-candidate" => some v100HalfDirectCandidate
  | "half-staged-candidate" => some v100HalfStagedCandidate
  | "f64-rne" => some (binary64Fma .nearestEven)
  | "f64-rz" => some (binary64Fma .towardZero)
  | "f64-rd" => some (binary64Fma .towardNegative)
  | "f64-ru" => some (binary64Fma .towardPositive)
  | _ => none

private def parsePairs (p : InvocationSpec) : List Nat → Option (List (p.input.Word × p.input.Word))
  | [] => some []
  | a :: b :: rest => do
    if a ≥ 2 ^ p.input.width || b ≥ 2 ^ p.input.width then none
    else return (BitVec.ofNat _ a, BitVec.ofNat _ b) :: (← parsePairs p rest)
  | _ => none

private def eventJson (e : ConversionEvent) : Json := Json.mkObj [
  ("input", toJson (qText e.input)), ("bits", toJson e.output.bits.toNat),
  ("value", toJson (qText e.output.value)), ("loss", toJson (qText e.loss)),
  ("fractionBits", toJson e.stage.format.fractionBits), ("mode", toJson (reprStr e.stage.mode))]

private def invocationJson (p : InvocationSpec) (ns : List Nat) : Option Json := do
  let c ← ns.getLast?
  if c ≥ 2 ^ p.cFormat.width then none else do
    let ps ← parsePairs p ns.dropLast
    let x : InvocationInput p := ⟨ps, BitVec.ofNat _ c⟩
    return match evalInvocation x with
    | .error e => Json.mkObj [("error", toJson (reprStr e))]
    | .ok t => Json.mkObj [
      ("bits", toJson t.output.bits.toNat), ("value", toJson (qText t.output.value)),
      ("ideal", toJson (qText t.prepared.exactDot)), ("residual", toJson (qText t.residual)),
      ("accumulated", toJson (qText t.accumulation.value)),
      ("alignmentLoss", toJson (qText t.accumulation.alignmentLoss)),
      ("localConversions", toJson (t.accumulation.conversions.map eventJson)),
      ("intermediate", toJson (t.intermediate.events.map eventJson))]

private def command (args : List String) : Option Json := do
  match args with
  | ["round", fmt, n, d] =>
    let f ← getFormat fmt
    let num ← n.toInt?
    let den ← d.toNat?
    if den = 0 then none else
      let x : Rat := num / (den : Rat)
      return Json.mkObj (([("rz", .towardZero), ("rne", .nearestEven),
        ("rd", .towardNegative), ("ru", .towardPositive)] : List (String × BinaryRoundingMode)).map
        fun (name, mode) => (name, toJson ((roundBinary f mode x).map BitVec.toNat)))
  | ["decode", fmt, n] =>
    let bits ← n.toNat?
    let s ← if fmt = "e4m3" then some packedE4M3
      else if fmt = "tf32-register" then some tf32Register else (getFormat fmt).map packedIEEE
    if bits ≥ 2 ^ s.width then none else
      return Json.mkObj [("value", toJson ((s.decode (BitVec.ofNat _ bits)).map (qText ∘ Decoded.value)))]
  | "block" :: profile :: words =>
    let p ← getProfile profile
    let ns ← words.mapM String.toNat?
    invocationJson p ns
  | _ => none

def main (args : List String) : IO Unit := do
  let lines ← match args with
    | ["--file", path] => pure ((← IO.FS.readFile path).splitOn "\n")
    | _ => pure [String.intercalate " " args]
  for line in lines do
    let words := (line.splitOn " ").filter (· != "")
    unless words.isEmpty do
      match command words with
      | none => throw (IO.userError s!"Invalid feature command: {line}")
      | some j => IO.println j.compress
