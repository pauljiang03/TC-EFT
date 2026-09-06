import TensorCore.Semantics.Profiles
import TensorCore.Semantics.Canonical
import TensorCore.Programs.Partition
import TensorCore.Applications.BoundedDot
import TensorCore.Semantics.CanonicalFormats
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

private def parseFp16Pairs : List Nat → Option (List (F16 × F16))
  | [] => some []
  | a :: b :: rest => do
    if a ≥ 65536 || b ≥ 65536 then none
    else return (BitVec.ofNat 16 a, BitVec.ofNat 16 b) :: (← parseFp16Pairs rest)
  | _ => none

private def dotJson (K extra : Nat) (floor : Option Int) (ns : List Nat) : Option Json := do
  if hK : 0 < K then
    let c ← ns.getLast?
    if c ≥ 2 ^ 32 then none else do
      let ps ← parseFp16Pairs ns.dropLast
      let p := fp16Fp32Profile K extra floor
      let cBits : F32 := BitVec.ofNat 32 c
      let failure (e : ModelError) := Json.mkObj [("error", toJson (reprStr e))]
      match finite32 cBits with
      | some initial =>
        return match runCanonicalDot K extra floor hK ps cBits with
        | .error e => failure e
        | .ok ts =>
          match idealProducts p ps with
          | none => failure .nonfiniteInput
          | some products =>
            let result := lastOutput initial ts
            Json.mkObj [
              ("bits", toJson result.bits.toNat), ("value", toJson (qText result.value)),
              ("ideal", toJson (qText (initial.value + products))),
              ("groups", toJson ts.length), ("tailPadding", toJson (tailPadding K ps.length)),
              ("outputs", toJson (ts.map fun t => t.output.bits.toNat)),
              ("errorBudget", toJson (qText (sumQ (ts.map BlockTrace.errorBudget)))),
              ("absoluteError", toJson (qText (absQ (initial.value + products - result.value))))]
      | none => return failure .nonfiniteInput
  else none

private def parseProfilePairs (p : Profile) : List Nat → Option (List (p.Word × p.Word))
  | [] => some []
  | a :: b :: rest => do
    if a ≥ 2 ^ p.input.width || b ≥ 2 ^ p.input.width then none
    else return (BitVec.ofNat _ a, BitVec.ofNat _ b) :: (← parseProfilePairs p rest)
  | _ => none

/-- Evaluate one block through a proved profile rather than through a descriptor. -/
private def profileJson (p : Profile) (ps : List (p.Word × p.Word)) (c : Nat) : Json :=
  let x : BlockInput p := ⟨ps, BitVec.ofNat 32 c⟩
  match evalBlock x with
  | .error e => Json.mkObj [("error", toJson (reprStr e))]
  | .ok t => Json.mkObj [
    ("bits", toJson t.output.bits.toNat), ("value", toJson (qText t.output.value)),
    ("ideal", toJson (qText t.block.exactDot)), ("residual", toJson (qText t.residual)),
    ("accumulated", toJson (qText t.block.accumulator))]

private def bf16Json (K extra : Nat) (floor : Option Int) (ns : List Nat) : Option Json := do
  let c ← ns.getLast?
  if c ≥ 2 ^ 32 then none else do
    let ps ← parseProfilePairs (bf16Fp32Profile K extra floor) ns.dropLast
    return profileJson (bf16Fp32Profile K extra floor) ps c

/-- TF32 register words: the thirteen low bits must be zero, then the value word is used. -/
private def tf32Json (K extra : Nat) (floor : Option Int) (ns : List Nat) : Option Json := do
  let c ← ns.getLast?
  if c ≥ 2 ^ 32 then none else do
    let words ← parseFp32Words ns.dropLast
    if words.any (fun w => !tf32Padded w) then
      return Json.mkObj [("error", toJson "invalidPadding")]
    else
      let ps := tf32UnpackPairs (pairUp words)
      return profileJson (tf19Fp32Profile K extra floor) ps c
where
  parseFp32Words : List Nat → Option (List tf32Register.Word)
    | [] => some []
    | w :: rest => do
      if w ≥ 2 ^ 32 then none else return (BitVec.ofNat _ w) :: (← parseFp32Words rest)
  pairUp : List tf32Register.Word → List (tf32Register.Word × tf32Register.Word)
    | a :: b :: rest => (a, b) :: pairUp rest
    | _ => []

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
  | "canonical" :: k :: extra :: floorText :: words =>
    let K ← k.toNat?
    let E ← extra.toNat?
    let floor ← if floorText = "none" then some none else floorText.toInt? |>.map some
    let ns ← words.mapM String.toNat?
    invocationJson (fp16Fp32Invocation K E floor) ns
  | "bf16" :: k :: extra :: floorText :: words =>
    let K ← k.toNat?
    let E ← extra.toNat?
    let floor ← if floorText = "none" then some none else floorText.toInt? |>.map some
    let ns ← words.mapM String.toNat?
    bf16Json K E floor ns
  | "tf32" :: k :: extra :: floorText :: words =>
    let K ← k.toNat?
    let E ← extra.toNat?
    let floor ← if floorText = "none" then some none else floorText.toInt? |>.map some
    let ns ← words.mapM String.toNat?
    if ns.dropLast.length % 2 != 0 then none else tf32Json K E floor ns
  | "dot" :: k :: extra :: floorText :: words =>
    let K ← k.toNat?
    let E ← extra.toNat?
    let floor ← if floorText = "none" then some none else floorText.toInt? |>.map some
    let ns ← words.mapM String.toNat?
    dotJson K E floor ns
  | "certificate" :: kind :: words =>
    let ns ← words.mapM String.toNat?
    let c ← ns.getLast?
    if c ≥ 2 ^ 32 then none else do
      let ps ← parseFp16Pairs ns.dropLast
      let bits : F32 := BitVec.ofNat 32 c
      let groups := groupCount 4 ps.length
      let budget := (groups : Rat) * staticBudget 5 23 1 3
      if kind = "family" then
        return Json.mkObj [
          ("accepted", toJson (boundedDotCheck ps bits)),
          ("lengthPass", toJson (decide (ps.length ≤ 256))),
          ("operandsPass", toJson (ps.all fun (a, b) => small16 a && small16 b)),
          ("initialPass", toJson (match value32 bits with
            | none => false | some v => decide (absQ v ≤ 1))),
          ("groups", toJson groups), ("budget", toJson (qText budget)),
          ("tolerance", toJson (qText (1 / 2048)))]
      else if kind = "concrete" then
        let r := (boundedDot ps).certificateReport 1 3 bits (1 / 2048)
        return Json.mkObj [
          ("accepted", toJson (r.inputConditionsPass && r.tolerancePass)),
          ("inputConditionsPass", toJson r.inputConditionsPass),
          ("tolerancePass", toJson r.tolerancePass),
          ("groups", toJson r.groups), ("budget", toJson (qText r.budget)),
          ("tolerance", toJson (qText r.tolerance))]
      else none
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
