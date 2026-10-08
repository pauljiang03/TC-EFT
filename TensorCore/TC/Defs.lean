import TensorCore.Numerics.Encoding

namespace TensorCore


/-- Parameters of one Tensor Core normalization group. -/
structure Profile where
  /-- Operand format (FP16, BF16, or packed TF32). -/
  input : Format
  /-- K, the number of products per group. -/
  products : ℕ
  /-- F = 23 + p: mantissa bits each term keeps after alignment, counted below the alignment
  exponent. FP32's 23 plus p extra alignment bits. -/
  alignMantissaBits : ℤ
  /-- Lower bound on the alignment exponent, if the architecture has one. -/
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
