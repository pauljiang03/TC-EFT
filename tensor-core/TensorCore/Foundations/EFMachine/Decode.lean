import TensorCore.Foundations.EFMachine.Word
import TensorCore.Foundations.EFMachine.Split
import TensorCore.Semantics.CanonicalFormats

namespace TensorCore.EFMachine

inductive InputKind where
  | fp16 | bf16 | tf32
  deriving Repr, DecidableEq

def InputKind.format : InputKind → Format
  | .fp16 => TensorCore.fp16
  | .bf16 => TensorCore.bf16
  | .tf32 => TensorCore.tf19

structure Factor where
  negative : Bool
  magnitude : BitVec 11
  /-- Raw exponent biased by 256, with zero's conventional raw exponent 0. -/
  raw : Grid
  fraction : Grid
  deriving Repr, DecidableEq

/-- Finite IEEE-style input decoding, including subnormal fractions and zero.
The input has already been checked for its encoded format width by the typed API. -/
def decodeFactor (kind : InputKind) (bits : F32) : Option Factor :=
  let f := kind.format
  let e := ((bits >>> f.fractionBits) &&& (((1 : F32) <<< f.exponentBits) - 1)).setWidth 10
  let m := (bits &&& (((1 : F32) <<< f.fractionBits) - 1)).setWidth 11
  let negative := (bits >>> (f.fractionBits + f.exponentBits)) != 0
  let bias : Grid := match kind with | .fp16 => 241 | _ => 129
  let top : Grid := match kind with | .fp16 => 31 | _ => 255
  let frac : Grid := match kind with | .bf16 => 7 | _ => 10
  if e == top then none
  else if e == 0 then
    if m == 0 then some ⟨negative, 0, 256, 0⟩
    else some ⟨negative, m, bias + 1, frac⟩
  else some ⟨negative, ((1 : BitVec 11) <<< f.fractionBits) + m, e + bias, frac⟩

structure Term where
  word : Word
  /-- Raw exponent biased by 512. Do not normalize this metadata. -/
  raw : Grid
  /-- Coefficient grid, biased by 272; this may differ for equal real products. -/
  support : Grid
  deriving Repr, DecidableEq

/-- Exact 11-by-11-bit multiplication; conversion to the common dyadic grid
uses a ten-bit shift, which includes the full BF16/TF32 exponent span. -/
def product (a b : Factor) : Term :=
  let raw := a.raw + b.raw
  let grid := raw - (a.fraction + b.fraction) - 240
  let m := (multiplySignificands a.magnitude b.magnitude).zeroExtend 576 <<< grid
  ⟨⟨a.negative != b.negative, m⟩, raw, grid⟩

structure Accumulator where
  negative : Bool
  magnitude : BitVec 24
  raw : Grid
  fraction : Grid
  deriving Repr, DecidableEq

def decode32Fields (bits : F32) : Option Accumulator :=
  let e := ((bits >>> 23).setWidth 8).zeroExtend 10
  let m := (bits &&& 0x007fffff).setWidth 24
  let negative := bits.msb
  if e == 255 then none
  else if e == 0 then
    if m == 0 then some ⟨negative, 0, 256, 0⟩
    else some ⟨negative, m, 130, 23⟩
  else some ⟨negative, 8388608 + m, e + 129, 23⟩

def Accumulator.term (a : Accumulator) : Term :=
  let grid := a.raw + 16 - a.fraction
  ⟨⟨a.negative, a.magnitude.zeroExtend 576 <<< grid⟩, a.raw + 256, grid⟩

/-- FP32 decoding directly into the common grid, without a rational conversion. -/
def decode32Term (bits : F32) : Option Term := (decode32Fields bits).map Accumulator.term

def decode32Word (bits : F32) : Option Word := (decode32Term bits).map Term.word

inductive Path where
  | v100F16 | ampereF16 | hopperF16 | ampereBF16 | hopperBF16
  | ampereTF32 | hopperTF32Wmma | hopperTF32Mma
  deriving Repr, DecidableEq

def Path.kind : Path → InputKind
  | .v100F16 | .ampereF16 | .hopperF16 => .fp16
  | .ampereBF16 | .hopperBF16 => .bf16
  | .ampereTF32 | .hopperTF32Wmma | .hopperTF32Mma => .tf32

def Path.profile : Path → Profile
  | .v100F16 => v100F16F32
  | .ampereF16 => ampereF16F32
  | .hopperF16 => hopperF16F32
  | .ampereBF16 => a100BF16F32
  | .hopperBF16 => hopperBF16F32
  | .ampereTF32 => a100TF32F32
  | .hopperTF32Wmma => hopperTF32WmmaF32
  | .hopperTF32Mma => hopperTF32MmaF32

def Path.alignmentBits : Path → Grid
  | .v100F16 => 23
  | .ampereF16 | .ampereBF16 | .ampereTF32 => 24
  | _ => 25

def Path.floor : Path → Grid
  | .v100F16 => 0
  | .ampereF16 | .ampereBF16 | .ampereTF32 => 380
  | _ => 379

def decodeProduct (path : Path) (pair : path.profile.Word × path.profile.Word) : Option Term := do
  let a ← decodeFactor path.kind (pair.1.zeroExtend 32)
  let b ← decodeFactor path.kind (pair.2.zeroExtend 32)
  return product a b

/-- Finite-range FP32 scalar addition using the same bounded integer converter. -/
def add32 (a b : F32) : Option F32 := do
  let x ← decode32Word a
  let y ← decode32Word b
  let s ← x.add y
  s.round32

end TensorCore.EFMachine
