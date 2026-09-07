import TensorCore.Foundations.BinaryRounding
import TensorCore.Semantics.CanonicalFormats

open TensorCore

private def modeOf : String → BinaryRoundingMode
  | "rz" => .towardZero
  | "rn" => .nearestEven
  | "rd" => .towardNegative
  | _ => .towardPositive

private def profileOf : String → Profile
  | "v100" => v100F16F32
  | "ampere" => ampereF16F32
  | "hopper" => hopperF16F32
  | "ampere_bf16" => a100BF16F32
  | "hopper_bf16" => hopperBF16F32
  | "ampere_tf32" => a100TF32F32
  | "hopper_tf32_wmma" => hopperTF32WmmaF32
  | _ => hopperTF32MmaF32

private def pairs (f : Format) : List String → List (BitVec f.width × BitVec f.width)
  | a :: b :: rest => (BitVec.ofNat _ a.toNat!, BitVec.ofNat _ b.toNat!) :: pairs f rest
  | _ => []

private def response (line : String) : String := Id.run do
  let fields := line.trimAscii.toString.splitOn " "
  match fields with
  | ["round", p, e, b, mode, n, d] =>
    let f : Format := ⟨p.toNat!, e.toNat!, b.toInt!⟩
    let x : Rat := (n.toInt! : Rat) / (d.toNat! : Rat)
    return match roundBinary f (modeOf mode) x with
      | none => "none"
      | some bits => toString bits.toNat
  | ["decode", p, e, b, word] =>
    let f : Format := ⟨p.toNat!, e.toNat!, b.toInt!⟩
    return match binaryValue f (BitVec.ofNat _ word.toNat!) with
      | none => "none"
      | some q => s!"{q.num}/{q.den}"
  | "block" :: model :: c :: ps =>
    let p := profileOf model
    let x : BlockInput p := ⟨pairs p.input ps, BitVec.ofNat _ c.toNat!⟩
    return match evalBlock x with
      | .ok t => toString t.output.bits.toNat
      | .error .wrongProductCount => "shape"
      | .error .nonfiniteInput => "nonfinite"
      | .error .accumulatorOutOfRange => "range"
      | .error .nonfiniteOutput => "output"
  | _ => return "bad-request"

def main : IO Unit := do
  let input ← IO.getStdin
  let output ← IO.getStdout
  repeat
    let line ← input.getLine
    if line.isEmpty then break
    output.putStrLn (response line)
