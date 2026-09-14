-- Opt-in executable for unresolved tensor-core candidates.

import TensorCoreWip.TC.FP8Program
import TensorCoreWip.TC.HalfOutputDefs
import Lean

open TensorCore Lean

private def qText (q : ℚ) : String := s!"{q.num}/{q.den}"

private def getFormat : String → Option TensorCore.Format
  | "e5m2" => some e5m2
  | _ => none

private def getProfile : String → Option InvocationSpec
  | "l40s-e4m3-paper" => some (l40sFP8Invocation .e4m3 .paper)
  | "l40s-e5m2-paper" => some (l40sFP8Invocation .e5m2 .paper)
  | "l40s-e4m3-source13" => some (l40sFP8Invocation .e4m3 .source13)
  | "l40s-e5m2-source13" => some (l40sFP8Invocation .e5m2 .source13)
  | "half-direct-candidate" => some v100HalfDirectCandidate
  | "half-staged-candidate" => some v100HalfStagedCandidate
  | _ => none

private def parsePairs (p : InvocationSpec) : List ℕ → Option (List (p.input.Word × p.input.Word))
  | [] => some []
  | a :: b :: rest => do
    if a ≥ 2 ^ p.input.width || b ≥ 2 ^ p.input.width then none
    else return (BitVec.ofNat _ a, BitVec.ofNat _ b) :: (← parsePairs p rest)
  | _ => none

private def eventJson (e : ConversionEvent) : Json := Json.mkObj [
  ("input", toJson (qText e.input)), ("bits", toJson e.output.bits.toNat),
  ("value", toJson (qText e.output.value)), ("loss", toJson (qText e.loss)),
  ("fractionBits", toJson e.stage.format.fractionBits), ("mode", toJson (reprStr e.stage.mode))]

private def invocationJson (p : InvocationSpec) (ns : List ℕ) : Option Json := do
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

private def fp8RowJson (f : FP8Format) (reading : FP8Reading) (ns : List ℕ) : Option Json := do
  let c ← ns.getLast?
  if c ≥ 2 ^ 32 then none else do
    let ps ← parsePairs (l40sFP8Invocation f reading) ns.dropLast
    let cBits : F32 := BitVec.ofNat 32 c
    return match runL40SFP8 f reading ps cBits with
    | .error e => Json.mkObj [("error", toJson (reprStr e))]
    | .ok t => Json.mkObj [
      ("bits", toJson t.second.output.bits.toNat),
      ("value", toJson (qText t.second.output.value)),
      ("ideal", toJson ((l40sFP8Ideal f ps cBits).map qText)),
      ("outputs", toJson [t.first.output.bits.toNat, t.second.output.bits.toNat]),
      ("accumulated", toJson [qText t.first.accumulation.value, qText t.second.accumulation.value]),
      ("residuals", toJson [qText t.first.residual, qText t.second.residual]),
      ("intermediate", toJson [t.first.intermediate.events.map eventJson,
        t.second.intermediate.events.map eventJson])]

private def command (args : List String) : Option Json := do
  match args with
  | ["round", fmt, n, d] =>
    let f ← getFormat fmt
    let num ← n.toInt?
    let den ← d.toNat?
    if den = 0 then none else
      let x : ℚ := num / (den : ℚ)
      return Json.mkObj (([("rz", .towardZero), ("rne", .nearestEven),
        ("rd", .towardNegative), ("ru", .towardPositive)] : List (String × BinaryRoundingMode)).map
        fun (name, mode) => (name, toJson ((roundBinary f mode x).map BitVec.toNat)))
  | ["decode", fmt, n] =>
    let bits ← n.toNat?
    let s ← if fmt = "e4m3" then some packedE4M3 else (getFormat fmt).map packedIEEE
    if bits ≥ 2 ^ s.width then none else
      return Json.mkObj [("value", toJson ((s.decode (BitVec.ofNat _ bits)).map (qText ∘ Decoded.value)))]
  | "block" :: profile :: words =>
    let p ← getProfile profile
    let ns ← words.mapM String.toNat?
    invocationJson p ns
  | "fp8-row" :: fmt :: policy :: words =>
    let f ← match fmt with
      | "e4m3" => some FP8Format.e4m3 | "e5m2" => some FP8Format.e5m2 | _ => none
    let reading ← match policy with
      | "paper" => some FP8Reading.paper | "source13" => some FP8Reading.source13 | _ => none
    let ns ← words.mapM String.toNat?
    fp8RowJson f reading ns
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
