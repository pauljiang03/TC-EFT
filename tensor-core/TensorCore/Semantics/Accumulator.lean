import TensorCore.Semantics.Block

namespace TensorCore

/-- Actual modular signed-word additions, starting from a supplied register. -/
def machineAccumulate (w : Nat) (acc : BitVec w) : List Int → BitVec w
  | [] => acc
  | z :: zs => machineAccumulate w (acc + BitVec.ofInt w z) zs

/-- Interpret the signed machine sum at the reference alignment quantum. -/
def PreparedBlock.machineAccumulator (b : PreparedBlock) (w : Nat) : Rat :=
  ((machineAccumulate w 0 b.coefficients).toInt : Rat) * pow2 b.quantumExponent

/-- Execute accumulation with w-bit additions, then the ordinary FP32 conversion.
The trace retains the reference preparation. Equality to its reference accumulator
requires a sufficient-width proof; it is not part of this definition. -/
def evalPreparedMachine (w : Nat) (b : PreparedBlock) : Except ModelError BlockTrace :=
  match round32 .towardZero (b.machineAccumulator w) with
  | none => .error .accumulatorOutOfRange
  | some bits => match finite32 bits with
    | none => .error .nonfiniteOutput
    | some d => .ok ⟨b, d⟩

def evalBlockMachine (w : Nat) {p : Profile} (x : BlockInput p) :
    Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => evalPreparedMachine w b

end TensorCore
