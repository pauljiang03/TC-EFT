import TensorCore.Semantics.RawProduct
import TensorCore.Semantics.Profile
import TensorCore.Foundations.Rounding

namespace TensorCore

/-- Encoded operands of one normalization group under a profile; `c` is always FP32. -/
structure BlockInput (p : Profile) where
  products : List (p.Word × p.Word)
  c : F32
  deriving Repr, DecidableEq

/-- Decoded operands together with the profile that fixes their alignment semantics. -/
structure PreparedBlock where
  profile : Profile
  products : List (Decoded × Decoded)
  c : Decoded
  deriving Repr, DecidableEq

def prepareProducts (p : Profile) (ps : List (p.Word × p.Word)) :
    Option (List (Decoded × Decoded)) :=
  ps.mapM fun (a, b) => do
    return (← p.decode a, ← p.decode b)

def prepare {p : Profile} (x : BlockInput p) : Option PreparedBlock :=
  match decode32 x.c, prepareProducts p x.products with
  | some c, some ps => some ⟨p, ps, c⟩
  | _, _ => none

/-- Ideal sum from decoded operands, without raw multiplication, alignment, or correction. -/
def PreparedBlock.exactProducts (b : PreparedBlock) : Rat :=
  sumQ (b.products.map fun (a, b) => a.value * b.value)

def PreparedBlock.exactDot (b : PreparedBlock) : Rat := b.c.value + b.exactProducts

def exactDot {p : Profile} (x : BlockInput p) : Option Rat :=
  (prepare x).map PreparedBlock.exactDot

def PreparedBlock.terms (b : PreparedBlock) : List RawProduct :=
  ⟨b.c.significand, b.c.rawScale, b.c.fractionalBits⟩ ::
    b.products.map fun (a, b) => rawMul a b

/-- A nonempty maximum ignores zero terms; none explicitly represents an all-zero block. -/
def alignmentScale (ts : List RawProduct) : Option Int :=
  (ts.filterMap fun t => if t.significand = 0 then none else some t.rawScale).foldl
    (fun acc e => some (match acc with | none => e | some v => max v e)) none

/-- Alignment exponent `eta`: nonzero raw-scale maximum, then the profile floor. -/
def PreparedBlock.eta (b : PreparedBlock) : Option Int :=
  b.profile.applyFloor (alignmentScale b.terms)

/-- Grid exponent `eta - F`. In an all-zero block any grid is equivalent. -/
def PreparedBlock.quantumExponent (b : PreparedBlock) : Int :=
  b.eta.getD 0 - b.profile.alignFraction

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
  deriving Repr, DecidableEq

def finite32 (bits : F32) : Option Finite32 :=
  match h : decode32 bits with
  | none => none
  | some d => some ⟨bits, d, h⟩

def Finite32.value (x : Finite32) : Rat := x.decoded.value

/-- All trace fields except the accepted input/output are derived by definitions. -/
structure BlockTrace where
  block : PreparedBlock
  output : Finite32
  deriving Repr, DecidableEq

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

/-- One normalization group of the profile, not a complete PTX tile or GEMM. -/
def evalBlock {p : Profile} (x : BlockInput p) : Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => evalPrepared b

abbrev evalV100 (x : BlockInput v100F16F32) : Except ModelError BlockTrace := evalBlock x

end TensorCore
