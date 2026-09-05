import TensorCore.Foundations.Encoding

namespace TensorCore

/-- Explicit parameters of one globally aligned FP32-output normalization group:
input format, products per group `K`, fractional alignment bits `F` below `2^eta`,
and an alignment-exponent floor applied after the nonzero maximum (Accurate Models
v4 Table 3). Fields without established semantics for a device are not added. -/
structure Profile where
  input : Format
  products : Nat
  alignFraction : Int
  alignFloor : Option Int
  deriving Repr, DecidableEq

/-- V100 FP16 -> FP32: `K = 4`, `(2, 23, 0)` alignment, no relevant floor. This is the
only profile with regression theorems and device evidence. -/
def v100F16F32 : Profile := ⟨fp16, 4, 23, none⟩

/-- The floor only raises a nonempty maximum; an all-zero block stays `none`. -/
def Profile.applyFloor (p : Profile) : Option Int → Option Int
  | none => none
  | some e => some (match p.alignFloor with | none => e | some f => max e f)

abbrev Profile.Word (p : Profile) := BitVec p.input.width

def Profile.decode (p : Profile) (x : p.Word) : Option Decoded := (classify p.input x).finite

end TensorCore
