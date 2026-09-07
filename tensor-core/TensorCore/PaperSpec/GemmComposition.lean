import TensorCore.PaperSpec.GemmEquivalence
import TensorCore.Programs.GemmInputBounds
import TensorCore.Theory.Binary.RoundingContract

/-! Compose the independent tensor-core matrix theorem with the existing generic
scalar/conversion contracts. The scalar epilogue is this project's explicitly
specified sequence, not an additional arithmetic rule attributed to the paper.
The independent Matrix module remains free of these implementation imports. -/

namespace TensorCore.PaperSpec

/-- Mathematical scalar contract, with range and zero-sign policy explicit. -/
def ScalarContract (stage : ConversionStage) (x : Rat) (b : BitVec stage.format.width) : Prop :=
  stage.format.WellFormed ∧ absQ x ≤ stage.format.maxFinite ∧
    GemmRounded stage x b ∧ binarySign stage.format b = decide (x < 0)

theorem scalar_contract (stage : ConversionStage) (x : Rat) (d : FiniteBinary stage.format)
    (h : stage.convert x = some d) : ScalarContract stage x d.bits :=
  ⟨(conversionStage_range h).1, (conversionStage_range h).2, gemmConversion_correct stage x d h,
    roundBinary_sign stage.format stage.mode x d.bits (conversionStage_output h)⟩

def EpilogueContract (cfg : GemmEpilogue) (alpha beta c : F32) (t : ScaledGemmCell cfg) : Prop :=
  value32 alpha = some t.alpha.value ∧ value32 beta = some t.beta.value ∧
    value32 c = some t.c.value ∧
    ScalarContract cfg.multiplyStage (t.alpha.value * t.product.output.value) t.scaledProduct.bits ∧
    ScalarContract cfg.multiplyStage (t.beta.value * t.c.value) t.scaledC.bits ∧
    ScalarContract cfg.addStage (t.scaledProduct.value + t.scaledC.value) t.sum.bits ∧
    ScalarContract cfg.output t.sum.value t.output.bits

theorem epilogue_contract (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell)
    (t : ScaledGemmCell cfg) (h : gemmEpilogue cfg alpha beta c product = some t) :
    EpilogueContract cfg alpha beta c t := by
  obtain ⟨hp, ha, hb, hc, had, hbc, hs, ho⟩ := gemmEpilogue_spec cfg alpha beta c product t h
  refine ⟨?_, ?_, ?_, ?_, scalar_contract _ _ _ hbc,
    scalar_contract _ _ _ hs, scalar_contract _ _ _ ho⟩
  · rw [matrix_value32_finite, ha]; rfl
  · rw [matrix_value32_finite, hb]; rfl
  · rw [matrix_value32_finite, hc]; rfl
  · rw [hp]
    exact scalar_contract _ _ _ had

/-- Every successful scaled entry has the independent paper matrix product trace
and the four specified scalar-rounding stages, all in their finite domains. -/
theorem scaledGemm_paper_contract (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (i : Fin m) (j : Fin n) (t : ScaledGemmCell cfg)
    (h : (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t) :
    (wmmaGemm (wmmaModel model) A B (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] =
      some (gemmCellObservation t.product) ∧
    t.product.initial.bits = 0 ∧ EpilogueContract cfg alpha beta C[i.val][j.val] t := by
  obtain ⟨product, hr, he⟩ := scaledGemm_entry model cfg alpha beta A B C i j t h
  have hp := (gemmEpilogue_spec cfg alpha beta _ product t he).1
  refine ⟨?_, ?_, epilogue_contract _ _ _ _ _ _ he⟩
  · apply (gemm_entry_eq_paper_iff _ _ _ _ i j _).2
    refine ⟨product, ?_, by rw [hp]⟩
    simpa only [gemm_entry, DenseMatrix.ofFn, Vector.getElem_ofFn] using hr
  · rw [hp]
    exact finite32_bits (simulateGemmCell_spec _ _ _ _ hr).1

def InputConversionContract (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix F16 m n) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ x, binaryValue source A[i.val][j.val] = some x ∧
    ScalarContract ⟨fp16, mode⟩ x B[i.val][j.val]

theorem input_conversion_contract (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix F16 m n)
    (h : convertGemmInput source mode A = some B) : InputConversionContract source mode A B := by
  intro i j
  have hc := convertGemmInput_entry source mode A B h i j
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at hc
  obtain ⟨x, hx, y, hy, he⟩ := hc
  refine ⟨x, hx, ?_⟩
  rw [← Option.some.inj he]
  exact scalar_contract _ _ _ hy

/-- A single accepted input-only certificate supplies the complete matrix contract:
input conversion, independent tensor-core traces, scalar stages, successful outputs,
and error against the original source words. No run-success or accuracy premise. -/
theorem convertedGemmCheck_paper_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n)
    (h : convertedGemmCheck source mode model cfg b alpha beta A B C = true) :
    ∃ a b' D, convertGemmInput source mode A = some a ∧ convertGemmInput source mode B = some b' ∧
      InputConversionContract source mode A a ∧ InputConversionContract source mode B b' ∧
      convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z E, D[i.val][j.val] = some t ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E ∧
        absQ (z - t.output.value) ≤ E ∧
        (wmmaGemm (wmmaModel model) a b' (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] =
          some (gemmCellObservation t.product) ∧
        t.product.initial.bits = 0 ∧ EpilogueContract cfg alpha beta C[i.val][j.val] t := by
  obtain ⟨a, b', ha, hb, run, _⟩ := convertedGemmCheck_sound source mode model cfg b alpha beta A B C h
  obtain ⟨D, hd, entries⟩ := convertedGemmCheck_source_sound source mode model cfg b alpha beta A B C h
  have heq := Option.some.inj (run.symm.trans hd)
  subst D
  refine ⟨a, b', _, ha, hb, input_conversion_contract _ _ _ _ ha,
    input_conversion_contract _ _ _ _ hb, run, ?_⟩
  intro i j
  obtain ⟨t, z, E, ht, hz, he, hbound⟩ := entries i j
  exact ⟨t, z, E, ht, hz, he, hbound, scaledGemm_paper_contract _ _ _ _ _ _ _ i j t ht⟩

end TensorCore.PaperSpec
