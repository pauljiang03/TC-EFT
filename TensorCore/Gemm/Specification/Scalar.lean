import TensorCore.Gemm.Specification.Matrix

/-! Independent finite scalar rounding and the project's explicit scaled-GEMM
pipeline. No implementation definitions are imported. The binade is specified
by inequalities, not by the converter's exponent search or encoding algorithm.
Selection is mathematical; proofs establish existence and unique encoded bits.
This scalar sequence is a project specification, not an extra rule attributed
to Accurate Models. Rejections are observed as none, including input conversion. -/

namespace TensorCore.PaperSpec

inductive ScalarMode where
  | towardZero | nearestEven | towardNegative | towardPositive
  deriving Repr, DecidableEq

def Layout.scalarValid (f : Layout) : Prop := 0 < f.fraction ∧ 1 < f.exponent
def Layout.minimumExponent (f : Layout) : ℤ := 1 - f.bias
def Layout.maximumExponent (f : Layout) : ℤ := ((2 ^ f.exponent - 2 : ℕ) : ℤ) - f.bias
def Layout.maximumFinite (f : Layout) : ℚ :=
  ((2 ^ (f.fraction + 1) - 1 : ℕ) : ℚ) * (2 : ℚ) ^ (f.maximumExponent - f.fraction)

def scalarValue (f : Layout) (b : BitVec f.width) : Option ℚ :=
  (decode f b.toNat).map Term.value

def scalarSign (f : Layout) (b : BitVec f.width) : Bool :=
  b.toNat / 2 ^ (f.fraction + f.exponent) != 0

def ScalarExponent (f : Layout) (m : ℚ) (e : ℤ) : Prop :=
  f.minimumExponent ≤ e ∧ e ≤ f.maximumExponent ∧
    m < (2 : ℚ) ^ (e + 1) ∧ ((2 : ℚ) ^ e ≤ m ∨ e = f.minimumExponent)

/-- Integer rounding on a nonnegative grid coordinate, with signed directions. -/
def scalarCoefficient (mode : ScalarMode) (negative : Bool) (x : ℚ) : ℤ :=
  match mode with
  | .towardZero => x.floor
  | .towardNegative => if negative then x.ceil else x.floor
  | .towardPositive => if negative then x.floor else x.ceil
  | .nearestEven =>
    if 1 < 2 * (x - x.floor) ∨ (2 * (x - x.floor) = 1 ∧ x.floor % 2 = 1)
    then x.floor + 1 else x.floor

def scalarGridValue (f : Layout) (mode : ScalarMode) (x : ℚ) (e : ℤ) : ℚ :=
  let q := (2 : ℚ) ^ (e - f.fraction)
  let v := (scalarCoefficient mode (decide (x < 0)) (magnitude x / q) : ℚ) * q
  if x < 0 then -v else v

def ScalarResult (f : Layout) (mode : ScalarMode) (x : ℚ) (b : BitVec f.width) : Prop :=
  f.scalarValid ∧ magnitude x ≤ f.maximumFinite ∧ scalarSign f b = decide (x < 0) ∧
    if x = 0 then scalarValue f b = some 0
    else ∃ e, ScalarExponent f (magnitude x) e ∧ scalarValue f b = some (scalarGridValue f mode x e)

noncomputable def scalarRound (f : Layout) (mode : ScalarMode) (x : ℚ) : Option (BitVec f.width) := by
  classical
  exact if h : ∃ b, ScalarResult f mode x b then some (Classical.choose h) else none

structure ScalarStage where
  format : Layout
  mode : ScalarMode
  deriving Repr, DecidableEq

noncomputable def scalarConvert (stage : ScalarStage) (x : ℚ) :
    Option (BitVec stage.format.width × ℚ) := do
  let bits ← scalarRound stage.format stage.mode x
  let value ← scalarValue stage.format bits
  return (bits, value)

structure ScalarEpilogue where
  multiplyMode : ScalarMode
  addMode : ScalarMode
  output : ScalarStage
  deriving Repr, DecidableEq

structure ScaledMatrixCell (output : Layout) where
  product : MatrixCell
  scaledProduct : BitVec 32
  scaledC : BitVec 32
  sum : BitVec 32
  output : BitVec output.width
  deriving Repr, DecidableEq

noncomputable def scalarEpilogue (cfg : ScalarEpilogue) (alpha beta c : BitVec 32)
    (product : MatrixCell) : Option (ScaledMatrixCell cfg.output.format) := do
  let a ← scalarValue binary32 alpha
  let b ← scalarValue binary32 beta
  let c ← scalarValue binary32 c
  let p ← scalarValue binary32 product.output
  let ad ← scalarConvert ⟨binary32, cfg.multiplyMode⟩ (a * p)
  let bc ← scalarConvert ⟨binary32, cfg.multiplyMode⟩ (b * c)
  let sum ← scalarConvert ⟨binary32, cfg.addMode⟩ (ad.2 + bc.2)
  let out ← scalarConvert cfg.output sum.2
  return ⟨product, ad.1, bc.1, sum.1, out.1⟩

noncomputable def scaledMatrix (model : WmmaModel) (cfg : ScalarEpilogue)
    (alpha beta : BitVec 32) (A : Matrix (BitVec 16) m k) (B : Matrix (BitVec 16) k n)
    (C : Matrix (BitVec 32) m n) : Matrix (Option (ScaledMatrixCell cfg.output.format)) m n :=
  let products := wmmaGemm model A B (Vector.ofFn fun _ => Vector.ofFn fun _ => 0)
  Vector.ofFn fun i => Vector.ofFn fun j => do
    let product ← products[i.val][j.val]
    scalarEpilogue cfg alpha beta C[i.val][j.val] product

noncomputable def scalarConvertWord (source target : Layout) (mode : ScalarMode)
    (word : BitVec source.width) : Option (BitVec target.width) := do
  let x ← scalarValue source word
  scalarRound target mode x

noncomputable def convertMatrix (source : Layout) (mode : ScalarMode)
    (A : Matrix (BitVec source.width) m n) : Option (Matrix (BitVec 16) m n) := by
  classical
  exact if ∀ i : Fin m, ∀ j : Fin n, (scalarConvertWord source ⟨10, 5, 15⟩ mode A[i.val][j.val]).isSome then
    some (Vector.ofFn fun i => Vector.ofFn fun j =>
      (scalarConvertWord source ⟨10, 5, 15⟩ mode A[i.val][j.val]).getD 0)
  else none

noncomputable def convertedMatrix (source : Layout) (inputMode : ScalarMode)
    (model : WmmaModel) (cfg : ScalarEpilogue) (alpha beta : BitVec 32)
    (A : Matrix (BitVec source.width) m k) (B : Matrix (BitVec source.width) k n)
    (C : Matrix (BitVec 32) m n) : Option (Matrix (Option (ScaledMatrixCell cfg.output.format)) m n) := do
  let a ← convertMatrix source inputMode A
  let b ← convertMatrix source inputMode B
  return scaledMatrix model cfg alpha beta a b C

end TensorCore.PaperSpec
