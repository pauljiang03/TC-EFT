import TensorCore.Programs.GemmBounds
import TensorCore.Theory.Binary.Conversion
import TensorCore.Semantics.Conversion

/-! Explicit finite-value alpha*A*B + beta*C pipeline. Tensor-core accumulation
starts at +0. Two separately rounded FP32 multiplications precede an FP32 add;
a final conversion can change the output format. No FMA contraction or EFT is
implicit. The existing conversion contract canonicalizes exact zero to +0 and
rejects exact intermediates outside the destination's finite reference domain. -/

namespace TensorCore

structure GemmEpilogue where
  multiplyMode : BinaryRoundingMode := .nearestEven
  addMode : BinaryRoundingMode := .nearestEven
  output : ConversionStage := ⟨fp32, .nearestEven⟩
  deriving Repr, DecidableEq

def GemmEpilogue.multiplyStage (cfg : GemmEpilogue) : ConversionStage :=
  ⟨fp32, cfg.multiplyMode⟩

def GemmEpilogue.addStage (cfg : GemmEpilogue) : ConversionStage :=
  ⟨fp32, cfg.addMode⟩

structure ScaledGemmCell (cfg : GemmEpilogue) where
  product : GemmCell
  alpha : Finite32
  beta : Finite32
  c : Finite32
  scaledProduct : FiniteBinary fp32
  scaledC : FiniteBinary fp32
  sum : FiniteBinary fp32
  output : FiniteBinary cfg.output.format
  deriving Repr, DecidableEq

/-- Every scalar stage consumes the decoded encoding returned by its predecessor. -/
def gemmEpilogue (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell) :
    Option (ScaledGemmCell cfg) := do
  let a ← finite32 alpha
  let b ← finite32 beta
  let c ← finite32 c
  let ad ← cfg.multiplyStage.convert (a.value * product.output.value)
  let bc ← cfg.multiplyStage.convert (b.value * c.value)
  let sum ← cfg.addStage.convert (ad.value + bc.value)
  let out ← cfg.output.convert sum.value
  return ⟨product, a, b, c, ad, bc, sum, out⟩

theorem gemmEpilogue_spec (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell)
    (t : ScaledGemmCell cfg) (h : gemmEpilogue cfg alpha beta c product = some t) :
    t.product = product ∧ finite32 alpha = some t.alpha ∧ finite32 beta = some t.beta ∧
      finite32 c = some t.c ∧
      cfg.multiplyStage.convert (t.alpha.value * product.output.value) = some t.scaledProduct ∧
      cfg.multiplyStage.convert (t.beta.value * t.c.value) = some t.scaledC ∧
      cfg.addStage.convert (t.scaledProduct.value + t.scaledC.value) = some t.sum ∧
      cfg.output.convert t.sum.value = some t.output := by
  simp only [gemmEpilogue, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨a, ha, b, hb, c', hc, ad, had, bc, hbc, s, hs, out, ho, he⟩ := h
  cases Option.some.inj he
  exact ⟨rfl, ha, hb, hc, had, hbc, hs, ho⟩

/-- Mathematical rounding relation selected by each scalar/conversion stage. -/
def GemmRounded (stage : ConversionStage) (x : Rat) (bits : BitVec stage.format.width) : Prop :=
  match stage.mode with
  | .nearestEven => NearestEven stage.format x bits
  | .towardZero => TowardZero stage.format x bits
  | .towardNegative => TowardNegative stage.format x bits
  | .towardPositive => TowardPositive stage.format x bits

theorem gemmConversion_correct (stage : ConversionStage) (x : Rat)
    (d : FiniteBinary stage.format) (h : stage.convert x = some d) :
    GemmRounded stage x d.bits := by
  have hf := (conversionStage_range h).1
  cases hm : stage.mode with
  | nearestEven => simpa [GemmRounded, hm] using conversionStage_nearestEven_correct stage hf hm x d h
  | towardZero => simpa [GemmRounded, hm] using conversionStage_towardZero_correct stage hf hm x d h
  | towardNegative => simpa [GemmRounded, hm] using conversionStage_towardNegative_correct stage hf hm x d h
  | towardPositive => simpa [GemmRounded, hm] using conversionStage_towardPositive_correct stage hf hm x d h

/-- All four executed scalar stages satisfy their independent rounding relations. -/
theorem gemmEpilogue_correct (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell)
    (t : ScaledGemmCell cfg) (h : gemmEpilogue cfg alpha beta c product = some t) :
    GemmRounded cfg.multiplyStage (t.alpha.value * product.output.value) t.scaledProduct.bits ∧
    GemmRounded cfg.multiplyStage (t.beta.value * t.c.value) t.scaledC.bits ∧
    GemmRounded cfg.addStage (t.scaledProduct.value + t.scaledC.value) t.sum.bits ∧
    GemmRounded cfg.output t.sum.value t.output.bits := by
  obtain ⟨_, _, _, _, ha, hb, hs, ho⟩ := gemmEpilogue_spec cfg alpha beta c product t h
  exact ⟨gemmConversion_correct _ _ _ ha, gemmConversion_correct _ _ _ hb,
    gemmConversion_correct _ _ _ hs, gemmConversion_correct _ _ _ ho⟩

/-- Explicit epilogue losses, including final output conversion. -/
def ScaledGemmCell.scalarError (t : ScaledGemmCell cfg) : Rat :=
  absQ (t.alpha.value * t.product.output.value - t.scaledProduct.value) +
  absQ (t.beta.value * t.c.value - t.scaledC.value) +
  absQ (t.scaledProduct.value + t.scaledC.value - t.sum.value) +
  absQ (t.sum.value - t.output.value)

def ScaledGemmCell.errorBudget (t : ScaledGemmCell cfg) : Rat :=
  absQ t.alpha.value * t.product.errorBudget + t.scalarError

theorem gemmAbs_mul (x y : Rat) : absQ (x * y) = absQ x * absQ y := by
  by_cases hy : 0 < y
  · rw [absQ_mul_pos x y hy]
    have : absQ y = y := by simp [absQ, Rat.not_lt.mpr (Rat.le_of_lt hy)]
    rw [this]
  · by_cases hz : y = 0
    · simp [hz, absQ]
    · have hn : 0 < -y := by grind
      have he := absQ_mul_pos x (-y) hn
      have hx : x * -y = -(x * y) := by grind
      rw [hx, absQ_neg] at he
      have ha : absQ y = -y := by simp [absQ, show y < 0 by grind]
      rwa [ha]

/-- Scalar rounding losses are added; the preceding tensor-core error is
amplified by |alpha|. This theorem accepts any bound on the product stage. -/
theorem ScaledGemmCell.propagate (t : ScaledGemmCell cfg) (z E : Rat)
    (h : absQ (z - t.product.output.value) ≤ E) :
    absQ (t.alpha.value * z + t.beta.value * t.c.value - t.output.value) ≤
      absQ t.alpha.value * E + t.scalarError := by
  have hm := Rat.mul_le_mul_of_nonneg_left h (absQ_nonneg t.alpha.value)
  rw [← gemmAbs_mul] at hm
  have h1 := absQ_add_le (t.alpha.value * (z - t.product.output.value))
    (t.alpha.value * t.product.output.value - t.scaledProduct.value)
  have h2 := absQ_add_le
    (t.alpha.value * (z - t.product.output.value) +
      (t.alpha.value * t.product.output.value - t.scaledProduct.value))
    (t.beta.value * t.c.value - t.scaledC.value)
  have h3 := absQ_add_le
    (t.alpha.value * (z - t.product.output.value) +
      (t.alpha.value * t.product.output.value - t.scaledProduct.value) +
      (t.beta.value * t.c.value - t.scaledC.value))
    (t.scaledProduct.value + t.scaledC.value - t.sum.value)
  have h4 := absQ_add_le
    (t.alpha.value * (z - t.product.output.value) +
      (t.alpha.value * t.product.output.value - t.scaledProduct.value) +
      (t.beta.value * t.c.value - t.scaledC.value) +
      (t.scaledProduct.value + t.scaledC.value - t.sum.value))
    (t.sum.value - t.output.value)
  unfold scalarError
  grind

/-- None denotes rejection by a finite input or conversion stage. Alpha=0 and
beta=0 do not bypass validation or execution of their respective operands. -/
def scaledGemm (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    DenseMatrix (Option (ScaledGemmCell cfg)) m n :=
  let products := gemm model A B (DenseMatrix.ofFn fun _ _ => 0)
  DenseMatrix.ofFn fun i j => do
    let product ← products[i.val][j.val].toOption
    gemmEpilogue cfg alpha beta C[i.val][j.val] product

def scaledGemmBits (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) :
    DenseMatrix (Option (BitVec cfg.output.format.width)) m n :=
  (scaledGemm model cfg alpha beta A B C).map fun row => row.map fun cell => cell.map (·.output.bits)

def scaledGemmCellIdeal (alpha beta c : F32) (pairs : List (F16 × F16)) : Option Rat := do
    let a ← value32 alpha
    let b ← value32 beta
    let c ← value32 c
    let p ← idealProducts v100F16F32 pairs
    return a * p + b * c

def scaledGemmIdeal (alpha beta : F32) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : DenseMatrix (Option Rat) m n :=
  DenseMatrix.ofFn fun i j => scaledGemmCellIdeal alpha beta C[i.val][j.val] (gemmPairs A B i j)

theorem scaledGemm_entry (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (i : Fin m) (j : Fin n) (t : ScaledGemmCell cfg)
    (h : (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t) :
    ∃ product, simulateGemmCell model (gemmPairs A B i j) 0 = .ok product ∧
      gemmEpilogue cfg alpha beta C[i.val][j.val] product = some t := by
  simp only [scaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn, gemm_entry] at h
  change ((simulateGemmCell model (gemmPairs A B i j) (0 : F32)).toOption.bind
    fun product => gemmEpilogue cfg alpha beta C[i.val][j.val] product) = some t at h
  cases hr : simulateGemmCell model (gemmPairs A B i j) 0 with
  | error e => rw [hr] at h; contradiction
  | ok product =>
    rw [hr] at h
    exact ⟨product, rfl, h⟩

private theorem finite32_value {bits : F32} {d : Finite32}
    (h : finite32 bits = some d) : value32 bits = some d.value := by
  rw [← finite32_bits h]
  simp [value32, d.valid, Finite32.value]

theorem scaledGemm_entry_error (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (i : Fin m) (j : Fin n) (t : ScaledGemmCell cfg) (z : Rat)
    (h : (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t)
    (hi : (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some z) :
    absQ (z - t.output.value) ≤ t.errorBudget := by
  obtain ⟨product, hr, he⟩ := scaledGemm_entry model cfg alpha beta A B C i j t h
  obtain ⟨ht, ha, hb, hc, _⟩ := gemmEpilogue_spec cfg alpha beta _ product t he
  have hv := finite32_value (simulateGemmCell_spec _ _ _ _ hr).1
  have hz : product.initial.value = 0 := by
    have h0 : value32 0 = some 0 := by decide +kernel
    rw [h0] at hv
    exact (Option.some.inj hv).symm
  simp only [scaledGemmIdeal, scaledGemmCellIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, bind, pure,
    finite32_value ha, finite32_value hb, finite32_value hc, Option.bind_some] at hi
  cases hp : idealProducts v100F16F32 (gemmPairs A B i j) with
  | none => simp [hp] at hi
  | some p =>
    have hprod := simulateGemmCell_error _ _ _ _ _ hr hp
    simp only [hz, Rat.zero_add] at hprod
    have hfinal := t.propagate p product.errorBudget (by simpa [ht] using hprod)
    simp only [hp, Option.bind_some, Option.some.injEq] at hi
    rw [← hi]
    simpa [ht, ScaledGemmCell.errorBudget] using hfinal

/-- Explicit input conversion. Exact zero follows the generic +0 convention. -/
def convertGemmWord (source target : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) : Option (BitVec target.width) := do
  let x ← binaryValue source bits
  let y ← (ConversionStage.mk target mode).convert x
  return y.bits

theorem convertGemmWord_correct (source target : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (output : BitVec target.width)
    (h : convertGemmWord source target mode input = some output) :
    ∃ x, binaryValue source input = some x ∧ GemmRounded ⟨target, mode⟩ x output := by
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, hx, y, hy, he⟩ := h
  cases Option.some.inj he
  exact ⟨x, hx, gemmConversion_correct _ _ _ hy⟩

/-- Conversion failure rejects the matrix; it never substitutes a zero operand. -/
def convertGemmInput (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) : Option (DenseMatrix F16 m n) :=
  if ∀ i : Fin m, ∀ j : Fin n, (convertGemmWord source fp16 mode A[i.val][j.val]).isSome then
    some (DenseMatrix.ofFn fun i j => (convertGemmWord source fp16 mode A[i.val][j.val]).getD 0)
  else none

theorem convertGemmInput_entry (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix F16 m n)
    (h : convertGemmInput source mode A = some B) (i : Fin m) (j : Fin n) :
    convertGemmWord source fp16 mode A[i.val][j.val] = some B[i.val][j.val] := by
  unfold convertGemmInput at h
  split at h
  · rename_i hs
    cases Option.some.inj h
    have hi := hs i j
    cases hv : convertGemmWord source fp16 mode A[i.val][j.val] with
    | none => simp [hv] at hi
    | some v => simp [DenseMatrix.ofFn, hv]
  · contradiction

/-- Convenience pipeline for explicitly converted input matrices. The scaledGemm
error theorem concerns the converted operands; source-to-FP16 loss is additional. -/
def convertedGemm (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option (ScaledGemmCell cfg)) m n) := do
  let a ← convertGemmInput source inputMode A
  let b ← convertGemmInput source inputMode B
  return scaledGemm model cfg alpha beta a b C

end TensorCore
