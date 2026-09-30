-- Defs for the tensor-core model.

import TensorCore.Numerics.Encoding

namespace TensorCore

/-- Explicit parameters of one globally aligned FP32-output normalization group:
input format, products per group `K`, fractional alignment bits `F` below `2^eta`,
and an alignment-exponent floor applied after the nonzero maximum (Accurate Models
v4 Table 3). Fields without established semantics for a device are not added. -/
structure Profile where
  input : Format
  products : ℕ
  alignFraction : ℤ
  alignFloor : Option ℤ
  deriving Repr, DecidableEq

/-- V100 FP16 -> FP32: `K = 4`, `(2, 23, 0)` alignment, no relevant floor.
The canonical Ampere/Hopper instances are defined in TC.CanonicalDefs. -/
def v100F16F32 : Profile := ⟨fp16, 4, 23, none⟩

/-- The floor only raises a nonempty maximum; an all-zero block stays `none`. -/
def Profile.applyFloor (p : Profile) : Option ℤ → Option ℤ
  | none => none
  | some e => some (match p.alignFloor with | none => e | some f => max e f)

abbrev Profile.Word (p : Profile) := BitVec p.input.width

def Profile.decode (p : Profile) (x : p.Word) : Option Decoded := (classify p.input x).finite

end TensorCore
