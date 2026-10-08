import TensorCore.TC.Block

namespace TensorCore

/-- Actual modular signed-word additions, starting from a supplied register. -/
def machineAccumulate (w : ℕ) (acc : BitVec w) : List ℤ → BitVec w
  | [] => acc
  | z :: zs => machineAccumulate w (acc + BitVec.ofInt w z) zs

/-- Interpret the signed machine sum at the reference alignment quantum. -/
def PreparedBlock.machineAccumulator (b : PreparedBlock) (w : ℕ) : ℚ :=
  ((machineAccumulate w 0 b.coefficients).toInt : ℚ) * pow2 b.alignGridExponent

/-- Execute accumulation with w-bit additions, then the ordinary FP32 conversion. -/
def evalPreparedMachine (w : ℕ) (b : PreparedBlock) : Except ModelError BlockTrace :=
  match round32 .towardZero (b.machineAccumulator w) with
  | none => .error .accumulatorOutOfRange
  | some bits => match finite32 bits with
    | none => .error .nonfiniteOutput
    | some d => .ok ⟨b, d⟩

def evalBlockMachine (w : ℕ) {p : Profile} (x : BlockInput p) :
    Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => evalPreparedMachine w b

end TensorCore
