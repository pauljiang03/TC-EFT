import TensorCore.Numerics.Encoding

namespace TensorCore


structure Profile where
  input : Format
  products : ℕ
  alignSigBits : ℤ
  alignFloor : Option ℤ
  deriving Repr, DecidableEq

/-- V100 FP16 -> FP32: `K = 4`, `(2, 23, 0)` alignment, no relevant floor. -/
def v100F16F32 : Profile := ⟨fp16, 4, 23, none⟩

/-- The floor only raises a nonempty maximum; an all-zero block stays `none`. -/
def Profile.applyFloor (p : Profile) : Option ℤ → Option ℤ
  | none => none
  | some e => some (match p.alignFloor with | none => e | some f => max e f)

abbrev Profile.Word (p : Profile) := BitVec p.input.width

def Profile.decode (p : Profile) (x : p.Word) : Option Decoded := (classify p.input x).finite

end TensorCore
