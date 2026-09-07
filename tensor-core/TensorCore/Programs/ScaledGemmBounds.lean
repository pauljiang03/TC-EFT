import TensorCore.Programs.GemmConversionBounds

/-! Input-only acceptance and accuracy of the complete scaled GEMM. These
certificates propagate magnitude and rounding-error bounds through the tensor
core, two FP32 multiplications, FP32 addition, and final format conversion. -/

namespace TensorCore

private theorem sum_four_le (a b c d A B C D : Rat)
    (ha : a ≤ A) (hb : b ≤ B) (hc : c ≤ C) (hd : d ≤ D) :
    a + b + c + d ≤ A + B + C + D := by grind

def gemmProductMagnitude (model : WmmaGemmModel) (cfg : GemmBoundConfig) (k : Nat) : Rat :=
  (gemmBlockCount model k : Rat) * ((model.path.products : Rat) * (4 * pow2 cfg.productScale))

theorem gemmCellCheck_product_bound (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (pairs : List (F16 × F16)) (h : gemmCellCheck model cfg pairs 0 = true) :
    ∃ cell p, simulateGemmCell model pairs 0 = .ok cell ∧
      idealProducts v100F16F32 pairs = some p ∧
      absQ (p - cell.output.value) ≤ gemmStaticError model cfg pairs.length ∧
      absQ cell.output.value ≤ gemmProductMagnitude model cfg pairs.length +
        gemmStaticError model cfg pairs.length := by
  obtain ⟨cell, p, hr, hp, hc, he⟩ := gemmCellCheck_sound model cfg pairs 0 h
  have hzero : cell.initial.value = 0 := by
    have hz : value32 0 = some 0 := by decide +kernel
    rw [hz] at hc
    exact (Option.some.inj hc).symm
  simp only [hzero, Rat.zero_add] at he
  have hs : (gemmBlocks model pairs).all (groupScaleCheck model.path.profile cfg.productScale) = true := by
    simp only [gemmCellCheck, Bool.and_eq_true] at h
    exact h.1.2
  have hi : idealContributions model.path.profile (gemmBlocks model pairs) = some p := by
    rwa [gemmBlocks_ideal]
  have hm := idealContributions_abs_le model.path.profile (gemmBlocks model pairs)
    ((model.path.products : Rat) * (4 * pow2 cfg.productScale)) (by
      intro g hg z hz
      have hb := idealProducts_abs_le_of_scale model.path.profile g cfg.productScale
        (groupScaleCheck_sound _ _ _ (List.all_eq_true.mp hs g hg)) z hz
      simpa only [gemmBlocks_shape model pairs g hg] using hb) p hi
  rw [gemmBlocks_count] at hm
  have ha := absQ_add_le p (cell.output.value - p)
  rw [absQ_sub_comm cell.output.value p] at ha
  have hid : p + (cell.output.value - p) = cell.output.value := by grind
  rw [hid] at ha
  refine ⟨cell, p, hr, hp, he, ?_⟩
  unfold gemmProductMagnitude
  grind

structure ScaledGemmBoundConfig where
  raw : GemmBoundConfig
  alphaScale : Int
  betaScale : Int
  sumScale : Int
  outputScale : Int
  deriving Repr, DecidableEq

def ScaledGemmBoundConfig.valid (b : ScaledGemmBoundConfig) (cfg : GemmEpilogue) : Bool :=
  decide (cfg.output.format.WellFormed ∧
    fp32.emin ≤ b.alphaScale ∧ pow2 b.alphaScale ≤ fp32.maxFinite ∧
    fp32.emin ≤ b.betaScale ∧ pow2 b.betaScale ≤ fp32.maxFinite ∧
    fp32.emin ≤ b.sumScale ∧ pow2 b.sumScale ≤ fp32.maxFinite ∧
    cfg.output.format.emin ≤ b.outputScale ∧ pow2 b.outputScale ≤ cfg.output.format.maxFinite)

def scaledGemmScalarBudget (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) : Rat :=
  gemmConversionError fp32 b.alphaScale + gemmConversionError fp32 b.betaScale +
  gemmConversionError fp32 b.sumScale + gemmConversionError cfg.output.format b.outputScale

def scaledGemmStaticError (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha : F32) (k : Nat) : Rat :=
  absQ ((value32 alpha).getD 0) * gemmStaticError model b.raw k + scaledGemmScalarBudget cfg b

def scaledGemmCellCheck (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta c : F32) (pairs : List (F16 × F16)) : Bool :=
  gemmCellCheck model b.raw pairs 0 && b.valid cfg &&
  match value32 alpha, value32 beta, value32 c with
  | some a, some beta, some c => decide (
      absQ a * (gemmProductMagnitude model b.raw pairs.length + gemmStaticError model b.raw pairs.length) ≤ pow2 b.alphaScale ∧
      absQ beta * absQ c ≤ pow2 b.betaScale ∧
      (pow2 b.alphaScale + gemmConversionError fp32 b.alphaScale) +
        (pow2 b.betaScale + gemmConversionError fp32 b.betaScale) ≤ pow2 b.sumScale ∧
      pow2 b.sumScale + gemmConversionError fp32 b.sumScale ≤ pow2 b.outputScale)
  | _, _, _ => false

theorem scaledGemmCellCheck_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta c : F32) (pairs : List (F16 × F16))
    (h : scaledGemmCellCheck model cfg b alpha beta c pairs = true) :
    ∃ product t z, simulateGemmCell model pairs 0 = .ok product ∧
      gemmEpilogue cfg alpha beta c product = some t ∧
      scaledGemmCellIdeal alpha beta c pairs = some z ∧
      absQ (z - t.output.value) ≤ scaledGemmStaticError model cfg b alpha pairs.length := by
  simp only [scaledGemmCellCheck, Bool.and_eq_true] at h
  obtain ⟨⟨hraw, hvalid⟩, hc⟩ := h
  simp only [ScaledGemmBoundConfig.valid, decide_eq_true_eq] at hvalid
  obtain ⟨hf, hAE, hAM, hBE, hBM, hSE, hSM, hOE, hOM⟩ := hvalid
  cases ha : value32 alpha with
  | none => simp [ha] at hc
  | some a =>
    cases hb : value32 beta with
    | none => simp [ha, hb] at hc
    | some betaVal =>
      cases hcv : value32 c with
      | none => simp [ha, hb, hcv] at hc
      | some cv =>
        simp only [ha, hb, hcv, decide_eq_true_eq] at hc
        obtain ⟨ac, hac, _, hav⟩ := finite32_of_value32 alpha a ha
        obtain ⟨bc, hbc, _, hbv⟩ := finite32_of_value32 beta betaVal hb
        obtain ⟨cc, hcc, _, hccv⟩ := finite32_of_value32 c cv hcv
        obtain ⟨product, p, hp, hi, he, hm⟩ := gemmCellCheck_product_bound model b.raw pairs hraw
        have ham : absQ (ac.value * product.output.value) ≤ pow2 b.alphaScale := by
          rw [gemmAbs_mul, hav]
          have ht := Rat.mul_le_mul_of_nonneg_left hm (absQ_nonneg a)
          exact Rat.le_trans ht hc.1
        have hbm : absQ (bc.value * cc.value) ≤ pow2 b.betaScale := by
          simpa [gemmAbs_mul, hbv, hccv] using hc.2.1
        obtain ⟨ad, had, hade, hadm⟩ := gemmConversion_bounded cfg.multiplyStage b.alphaScale
          (by change fp32.WellFormed; decide) hAE hAM _ ham
        obtain ⟨bd, hbd, hbde, hbdm⟩ := gemmConversion_bounded cfg.multiplyStage b.betaScale
          (by change fp32.WellFormed; decide) hBE hBM _ hbm
        have hsm : absQ (ad.value + bd.value) ≤ pow2 b.sumScale := by
          have ht := absQ_add_le ad.value bd.value
          have hh := hc.2.2.1
          change absQ ad.value ≤ pow2 b.alphaScale + gemmConversionError fp32 b.alphaScale at hadm
          change absQ bd.value ≤ pow2 b.betaScale + gemmConversionError fp32 b.betaScale at hbdm
          grind
        obtain ⟨sd, hsd, hsde, hsdm⟩ := gemmConversion_bounded cfg.addStage b.sumScale
          (by change fp32.WellFormed; decide) hSE hSM _ hsm
        have hom : absQ sd.value ≤ pow2 b.outputScale := Rat.le_trans hsdm hc.2.2.2
        obtain ⟨out, hout, houte, _⟩ := gemmConversion_bounded cfg.output b.outputScale hf hOE hOM _ hom
        let t : ScaledGemmCell cfg := ⟨product, ac, bc, cc, ad, bd, sd, out⟩
        have hscalar : t.scalarError ≤ scaledGemmScalarBudget cfg b := by
          change absQ (ac.value * product.output.value - ad.value) ≤ gemmConversionError fp32 b.alphaScale at hade
          change absQ (bc.value * cc.value - bd.value) ≤ gemmConversionError fp32 b.betaScale at hbde
          change absQ (ad.value + bd.value - sd.value) ≤ gemmConversionError fp32 b.sumScale at hsde
          exact sum_four_le _ _ _ _ _ _ _ _ hade hbde hsde houte
        have hfinal := t.propagate p (gemmStaticError model b.raw pairs.length) he
        refine ⟨product, t, a * p + betaVal * cv, hp, ?_, ?_, ?_⟩
        · simp [gemmEpilogue, hac, hbc, hcc, had, hbd, hsd, hout, t]
        · simp [scaledGemmCellIdeal, ha, hb, hcv, hi]
        · have hh : absQ a * gemmStaticError model b.raw pairs.length + t.scalarError ≤
              absQ a * gemmStaticError model b.raw pairs.length + scaledGemmScalarBudget cfg b := by grind
          change absQ (ac.value * p + bc.value * cc.value - out.value) ≤
            absQ ac.value * gemmStaticError model b.raw pairs.length + t.scalarError at hfinal
          rw [hav, hbv, hccv] at hfinal
          have := Rat.le_trans hfinal hh
          simpa [scaledGemmStaticError, ha] using this

def scaledGemmCheck (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Bool :=
  decide (∀ i : Fin m, ∀ j : Fin n,
    scaledGemmCellCheck model cfg b alpha beta C[i.val][j.val] (gemmPairs A B i j) = true)

/-- The complete scaled matrix exists and is accurate, from input checks alone. -/
theorem scaledGemmCheck_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : scaledGemmCheck model cfg b alpha beta A B C = true) (i : Fin m) (j : Fin n) :
    ∃ t z, (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t ∧
      (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ scaledGemmStaticError model cfg b alpha k := by
  obtain ⟨product, t, z, hp, ht, hi, he⟩ := scaledGemmCellCheck_sound model cfg b alpha beta _ _
    (of_decide_eq_true h i j)
  refine ⟨t, z, ?_, ?_, ?_⟩
  · simp only [scaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn, gemm_entry]
    change ((simulateGemmCell model (gemmPairs A B i j) (0 : F32)).toOption.bind
      fun product => gemmEpilogue cfg alpha beta C[i.val][j.val] product) = some t
    rw [hp]
    exact ht
  · simpa [scaledGemmIdeal, DenseMatrix.ofFn] using hi
  · simpa using he

theorem scaledGemmCheck_matrix_error (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : scaledGemmCheck model cfg b alpha beta A B C = true) (D Z : DenseMatrix Rat m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ t,
      (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : Rat) * (n : Rat) * scaledGemmStaticError model cfg b alpha k := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨t, z, hr, hi, he⟩ := scaledGemmCheck_sound model cfg b alpha beta A B C h i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j t hr] using he

/-- Input conversions may execute during validation; tensor-core and epilogue
execution do not. The error reference is the resulting encoded FP16 matrices. -/
def convertedGemmCheck (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Bool :=
  match convertGemmInput source inputMode A, convertGemmInput source inputMode B with
  | some a, some b' => scaledGemmCheck model cfg b alpha beta a b' C
  | _, _ => false

theorem convertedGemmCheck_sound (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n)
    (h : convertedGemmCheck source inputMode model cfg b alpha beta A B C = true) :
    ∃ a b', convertGemmInput source inputMode A = some a ∧
      convertGemmInput source inputMode B = some b' ∧
      convertedGemm source inputMode model cfg alpha beta A B C =
        some (scaledGemm model cfg alpha beta a b' C) ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z,
        (scaledGemm model cfg alpha beta a b' C)[i.val][j.val] = some t ∧
        (scaledGemmIdeal alpha beta a b' C)[i.val][j.val] = some z ∧
        absQ (z - t.output.value) ≤ scaledGemmStaticError model cfg b alpha k := by
  cases ha : convertGemmInput source inputMode A with
  | none => simp [convertedGemmCheck, ha] at h
  | some a =>
    cases hb : convertGemmInput source inputMode B with
    | none => simp [convertedGemmCheck, ha, hb] at h
    | some b' =>
      simp only [convertedGemmCheck, ha, hb] at h
      refine ⟨a, b', rfl, rfl, ?_, fun i j => scaledGemmCheck_sound model cfg b alpha beta a b' C h i j⟩
      simp [convertedGemm, ha, hb]

end TensorCore
