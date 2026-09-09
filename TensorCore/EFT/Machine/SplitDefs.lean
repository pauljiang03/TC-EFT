import TensorCore.Core.Encoding

/-! Bounded unsigned significand splitting. FP16 raw products need at most 22 bits;
FP32 significands need at most 24. The exponent gap is an unsigned 8-bit count.
All executable data and arithmetic here are bitvectors. Signed interpretation and
binary scales belong to the separate specification. This primitive does not decode
operands, compute overlap, check the scalar predicate, or consolidate a correction. -/

namespace TensorCore.EFMachine

structure SplitMagnitude where
  coarse : BitVec 24
  low : BitVec 24
  deriving Repr, DecidableEq

/-- Split a magnitude at `gap` low bits. The explicit large-gap branch avoids
platform-dependent masked shifts. On the other branch the shift count is below 24. -/
def splitMagnitude (m : BitVec 24) (gap : BitVec 8) : SplitMagnitude :=
  if gap ≥ 24 then ⟨0, m⟩
  else
    let coarse := (m >>> gap) <<< gap
    ⟨coarse, m - coarse⟩

/-- Multiply two unsigned FP16 significands after widening, so every product fits. -/
def multiplySignificands (a b : BitVec 11) : BitVec 24 :=
  a.zeroExtend 24 * b.zeroExtend 24

end TensorCore.EFMachine
