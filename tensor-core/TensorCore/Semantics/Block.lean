import TensorCore.Semantics.RawProduct
import TensorCore.Foundations.Rounding

namespace TensorCore

structure BlockInput where
  products : List (F16 × F16)
  c : F32
  deriving Repr, DecidableEq

structure PreparedBlock where
  products : List (Decoded × Decoded)
  c : Decoded
  deriving Repr, DecidableEq

def prepareProducts (ps : List (F16 × F16)) : Option (List (Decoded × Decoded)) :=
  ps.mapM fun (a, b) => do
    return (← decode16 a, ← decode16 b)

def prepare (x : BlockInput) : Option PreparedBlock :=
  match decode32 x.c, prepareProducts x.products with
  | some c, some ps => some ⟨ps, c⟩
  | _, _ => none

/-- Ideal sum from decoded operands, without raw multiplication, alignment, or correction. -/
def PreparedBlock.exactProducts (b : PreparedBlock) : Rat :=
  sumQ (b.products.map fun (a, b) => a.value * b.value)

def PreparedBlock.exactDot (b : PreparedBlock) : Rat := b.c.value + b.exactProducts

def exactDot (x : BlockInput) : Option Rat := (prepare x).map PreparedBlock.exactDot

def PreparedBlock.terms (b : PreparedBlock) : List RawProduct :=
  ⟨b.c.significand, b.c.rawScale, b.c.fractionalBits⟩ ::
    b.products.map fun (a, b) => rawMul a b

/-- A nonempty maximum ignores zero terms; none explicitly represents an all-zero block. -/
def alignmentScale (ts : List RawProduct) : Option Int :=
  (ts.filterMap fun t => if t.significand = 0 then none else some t.rawScale).foldl
    (fun acc e => some (match acc with | none => e | some v => max v e)) none

/-- V100 has 23 fractional alignment bits. In an all-zero block any grid is equivalent. -/
def PreparedBlock.quantumExponent (b : PreparedBlock) : Int :=
  (alignmentScale b.terms).getD 0 - 23

def PreparedBlock.coefficients (b : PreparedBlock) : List Int :=
  b.terms.map fun t => truncCoeff t.value b.quantumExponent

def PreparedBlock.accumulator (b : PreparedBlock) : Rat :=
  (sumZ b.coefficients : Rat) * pow2 b.quantumExponent

def PreparedBlock.alignmentResiduals (b : PreparedBlock) : List Rat :=
  b.terms.map fun t => t.value - truncGrid t.value b.quantumExponent

/-- Exact stage extractor for any supplied numerical output. No conformance assumption. -/
def PreparedBlock.extractReference (b : PreparedBlock) (d : Rat) : Rat :=
  (b.accumulator - d) + sumQ b.alignmentResiduals

structure Finite32 where
  bits : F32
  decoded : Decoded
  valid : decode32 bits = some decoded
  deriving Repr

def finite32 (bits : F32) : Option Finite32 :=
  match h : decode32 bits with
  | none => none
  | some d => some ⟨bits, d, h⟩

def Finite32.value (x : Finite32) : Rat := x.decoded.value

/-- All trace fields except the accepted input/output are derived by definitions. -/
structure BlockTrace where
  block : PreparedBlock
  output : Finite32
  deriving Repr

def BlockTrace.residual (t : BlockTrace) : Rat := t.block.extractReference t.output.value
def BlockTrace.outputResidual (t : BlockTrace) : Rat := t.block.accumulator - t.output.value
def BlockTrace.recovered (t : BlockTrace) : Rat := t.output.value + t.residual
def BlockTrace.corrected (t : BlockTrace) : Option F32 := round32 .nearestEven t.recovered

inductive ModelError where
  | wrongProductCount
  | nonfiniteInput
  | accumulatorOutOfRange
  | nonfiniteOutput
  deriving Repr, DecidableEq

def evalPrepared (b : PreparedBlock) : Except ModelError BlockTrace :=
  match round32 .towardZero b.accumulator with
  | none => .error .accumulatorOutOfRange
  | some bits => match finite32 bits with
    | none => .error .nonfiniteOutput
    | some d => .ok ⟨b, d⟩

/-- One V100 normalization group, not a complete PTX tile or GEMM. -/
def evalV100 (x : BlockInput) : Except ModelError BlockTrace :=
  if x.products.length != 4 then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => evalPrepared b

end TensorCore
