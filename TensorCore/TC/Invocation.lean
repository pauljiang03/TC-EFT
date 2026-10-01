import TensorCore.Numerics.Conversion
import TensorCore.TC.Block

namespace TensorCore

inductive CPlacement where
  | inGroup
  /-- Convert the product accumulator through these stages, then add c exactly. -/
  | afterProducts (stages : List ConversionStage)
  deriving Repr, DecidableEq

inductive AccumulationKind where
  | aligned (fraction : ℕ) (floor : Option ℤ) (cPlacement : CPlacement)
  /-- An exact single-product FMA, with no lossy alignment stage. -/
  | fused
  deriving Repr, DecidableEq

structure InvocationSpec where
  input : OperandEncoding
  cFormat : Format
  products : ℕ
  accumulation : AccumulationKind
  intermediate : List ConversionStage := []
  output : ConversionStage
  deriving Repr, DecidableEq

def stagesValid (ss : List ConversionStage) : Bool := ss.all fun s => decide s.format.WellFormed

def InvocationSpec.Valid (p : InvocationSpec) : Prop :=
  p.input.valueFormat.layout.WellFormed ∧ p.cFormat.WellFormed ∧
  stagesValid p.intermediate = true ∧ p.output.format.WellFormed ∧
  match p.accumulation with
  | .fused => p.products = 1
  | .aligned _ _ .inGroup => True
  | .aligned _ _ (.afterProducts ss) => stagesValid ss = true

instance (p : InvocationSpec) : Decidable p.Valid := by
  unfold InvocationSpec.Valid
  cases p.accumulation with
  | fused => infer_instance
  | aligned _ _ cp => cases cp <;> infer_instance

structure InvocationInput (p : InvocationSpec) where
  products : List (p.input.Word × p.input.Word)
  c : BitVec p.cFormat.width
  deriving Repr, DecidableEq

structure PreparedInvocation (p : InvocationSpec) where
  products : List (Decoded × Decoded)
  c : Decoded
  deriving Repr, DecidableEq

def prepareInvocation {p : InvocationSpec} (x : InvocationInput p) : Option (PreparedInvocation p) := do
  let c ← (classify p.cFormat x.c).finite
  let ps ← x.products.mapM fun (a, b) => do return (← p.input.decode a, ← p.input.decode b)
  return ⟨ps, c⟩

def PreparedInvocation.exactProducts {p : InvocationSpec} (b : PreparedInvocation p) : ℚ :=
  sumQ (b.products.map fun (a, b) => a.value * b.value)

def PreparedInvocation.exactDot {p : InvocationSpec} (b : PreparedInvocation p) : ℚ :=
  b.c.value + b.exactProducts

/-- Original-bit ideal. -/
def invocationIdeal {p : InvocationSpec} (x : InvocationInput p) : Option ℚ :=
  (prepareInvocation x).map PreparedInvocation.exactDot

/-- Reuse the proved raw-product/grid primitive. -/
def PreparedInvocation.alignedBlock {p : InvocationSpec} (b : PreparedInvocation p)
    (F : ℕ) (floor : Option ℤ) (includeC : Bool) : PreparedBlock :=
  ⟨⟨p.input.valueFormat.layout, p.products, F, floor⟩, b.products,
    if includeC then b.c else ⟨0, 0, 0⟩⟩

structure LocalAccumulation where
  value : ℚ
  alignmentLoss : ℚ
  conversions : List ConversionEvent
  deriving Repr, DecidableEq

def LocalAccumulation.loss (r : LocalAccumulation) : ℚ :=
  r.alignmentLoss + sumQ (r.conversions.map ConversionEvent.loss)

def accumulateInvocation {p : InvocationSpec} (b : PreparedInvocation p) : Option LocalAccumulation :=
  match p.accumulation with
  | .fused => some ⟨b.exactDot, 0, []⟩
  | .aligned F floor cp =>
    match cp with
    | .inGroup =>
      let a := b.alignedBlock F floor true
      some ⟨a.accumulator, sumQ a.alignmentResiduals, []⟩
    | .afterProducts stages => do
      let a := b.alignedBlock F floor false
      let r ← runConversions stages a.accumulator
      return ⟨r.value + b.c.value, sumQ a.alignmentResiduals, r.events⟩

structure InvocationTrace (p : InvocationSpec) where
  prepared : PreparedInvocation p
  accumulation : LocalAccumulation
  intermediate : ConversionRun
  output : FiniteBinary p.output.format
  deriving Repr, DecidableEq

def InvocationTrace.residual {p : InvocationSpec} (t : InvocationTrace p) : ℚ :=
  t.accumulation.loss + t.intermediate.loss + (t.intermediate.value - t.output.value)

inductive InvocationError where
  | invalidSpec
  | wrongProductCount
  | nonfiniteOrInvalidEncoding
  | localConversionFailed
  | intermediateConversionFailed
  | outputConversionFailed
  deriving Repr, DecidableEq

def evalInvocationPrepared {p : InvocationSpec} (b : PreparedInvocation p) :
    Except InvocationError (InvocationTrace p) :=
  match accumulateInvocation b with
  | none => .error .localConversionFailed
  | some a => match runConversions p.intermediate a.value with
    | none => .error .intermediateConversionFailed
    | some r => match p.output.convert r.value with
      | none => .error .outputConversionFailed
      | some d => .ok ⟨b, a, r, d⟩

def evalInvocation {p : InvocationSpec} (x : InvocationInput p) :
    Except InvocationError (InvocationTrace p) :=
  if ¬ p.Valid then .error .invalidSpec
  else if x.products.length != p.products then .error .wrongProductCount
  else match prepareInvocation x with
    | none => .error .nonfiniteOrInvalidEncoding
    | some b => evalInvocationPrepared b

/-- Embed a block profile as an aligned invocation with FP32 toward-zero output. -/
@[implicit_reducible] def Profile.toInvocation (p : Profile) (F : ℕ) : InvocationSpec :=
  ⟨packedIEEE p.input, fp32, p.products, .aligned F p.alignFloor .inGroup,
    [], ⟨fp32, .towardZero⟩⟩

def v100Invocation : InvocationSpec := v100F16F32.toInvocation 23

/-- Numerical observation includes rejection as `none`; error constructors are API-specific. -/
def invocationBits {p : InvocationSpec} (x : InvocationInput p) : Option (BitVec p.output.format.width) :=
  (evalInvocation x).toOption.map fun t => t.output.bits

end TensorCore
