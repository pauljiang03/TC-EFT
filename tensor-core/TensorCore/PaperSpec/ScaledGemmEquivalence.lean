import TensorCore.PaperSpec.ScalarRounding
import TensorCore.PaperSpec.GemmComposition

/-! Complete implementation/independent-specification equality for the explicit
scaled pipeline, including input conversion, every scalar encoded boundary,
ill-formed output formats, nonfinite operands, and finite-range rejection. -/

namespace TensorCore.PaperSpec

@[implicit_reducible] def scalarStageOf (s : ConversionStage) : ScalarStage := ⟨layoutOf s.format, scalarModeOf s.mode⟩
@[implicit_reducible] def epilogueOf (cfg : GemmEpilogue) : ScalarEpilogue :=
  ⟨scalarModeOf cfg.multiplyMode, scalarModeOf cfg.addMode, scalarStageOf cfg.output⟩

theorem scalarConvert_eq (s : ConversionStage) (x : Rat) :
    scalarConvert (scalarStageOf s) x = (s.convert x).map (fun d => (d.bits, d.value)) := by
  simp only [scalarConvert, scalarStageOf, scalarRound_eq, bind, pure]
  simp only [scalarValue_eq]
  cases hr : roundBinary s.format s.mode x with
  | none => simp [ConversionStage.convert, hr, Option.bind_none]
  | some bits =>
    cases hd : (classify s.format bits).finite with
    | none => simp [ConversionStage.convert, hr, binaryValue, hd, finiteBinary_none hd, Option.bind_some]
    | some d => simp [ConversionStage.convert, hr, binaryValue, hd, finiteBinary_some hd, FiniteBinary.value, Option.bind_some]

theorem conversionStage_bits_eq (s : ConversionStage) (x : Rat) :
    (s.convert x).map FiniteBinary.bits = roundBinary s.format s.mode x := by
  cases hr : roundBinary s.format s.mode x with
  | none => simp [ConversionStage.convert, hr]
  | some bits =>
    obtain ⟨hf, hx⟩ := roundBinary_range hr
    obtain ⟨bits', hb, hc⟩ := roundBinary_correct s.format hf s.mode x hx
    rw [hr] at hb
    cases Option.some.inj hb
    obtain ⟨d, hd⟩ := hc.finite
    simp [ConversionStage.convert, hr, finiteBinary_some hd]

def scaledCellObservation (t : ScaledGemmCell cfg) : ScaledMatrixCell (layoutOf cfg.output.format) :=
  ⟨gemmCellObservation t.product, t.scaledProduct.bits, t.scaledC.bits, t.sum.bits, t.output.bits⟩

theorem scalarValue32_finite (b : F32) :
    scalarValue binary32 b = (finite32 b).map Finite32.value := matrix_value32_finite b

theorem scalarValue32_of_finite (d : Finite32) : scalarValue binary32 d.bits = some d.value := by
  change value32 d.bits = some d.value
  rw [matrix_value32_eq]
  simp [TensorCore.value32, d.valid, Finite32.value]

theorem scalarEpilogue_eq (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell) :
    scalarEpilogue (epilogueOf cfg) alpha beta c (gemmCellObservation product) =
      (gemmEpilogue cfg alpha beta c product).map scaledCellObservation := by
  simp only [scalarEpilogue, gemmCellObservation_output, scalarValue32_of_finite]
  rw [scalarValue32_finite, scalarValue32_finite, scalarValue32_finite]
  change (do
    let a ← (finite32 alpha).map Finite32.value
    let b ← (finite32 beta).map Finite32.value
    let c ← (finite32 c).map Finite32.value
    let p ← some product.output.value
    let ad ← scalarConvert (scalarStageOf cfg.multiplyStage) (a * p)
    let bc ← scalarConvert (scalarStageOf cfg.multiplyStage) (b * c)
    let sum ← scalarConvert (scalarStageOf cfg.addStage) (ad.2 + bc.2)
    let out ← scalarConvert (scalarStageOf cfg.output) sum.2
    pure (ScaledMatrixCell.mk (gemmCellObservation product) ad.1 bc.1 sum.1 out.1)) = _
  simp only [scalarConvert_eq, gemmEpilogue]
  cases ha : finite32 alpha <;> cases hb : finite32 beta <;> cases hc : finite32 c <;>
    simp [bind, pure, Option.bind_map, Option.map_bind, Option.bind_some, Option.bind_none, Function.comp_def, scaledCellObservation] <;> rfl

/-- Every encoded product and scalar boundary agrees, for all input matrices.
No certificate, execution-success, range, or stage-correctness premise. -/
theorem scaledGemm_eq_independent (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) :
    (scaledGemm model cfg alpha beta A B C).map (fun row => row.map fun cell =>
      cell.map scaledCellObservation) = scaledMatrix (wmmaModel model) (epilogueOf cfg) alpha beta A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [Vector.getElem_map]
  have hm := congrArg (fun D => D[i][j]) (gemm_eq_paper model A B (DenseMatrix.ofFn fun _ _ => 0))
  simp only [Vector.getElem_map] at hm
  simp only [scaledGemm, scaledMatrix, DenseMatrix.ofFn, Vector.getElem_ofFn]
  change ((gemm model A B (DenseMatrix.ofFn fun _ _ => 0))[i][j].toOption.bind
    (gemmEpilogue cfg alpha beta C[i][j])).map scaledCellObservation =
    ((wmmaGemm (wmmaModel model) A B (DenseMatrix.ofFn fun _ _ => 0))[i][j].bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
  rw [← hm]
  cases hp : (gemm model A B (DenseMatrix.ofFn fun _ _ => 0))[i][j] with
  | error e => rfl
  | ok product => exact (scalarEpilogue_eq cfg alpha beta C[i][j] product).symm

theorem scaledGemmBits_eq_independent (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) :
    scaledGemmBits model cfg alpha beta A B C =
      (scaledMatrix (wmmaModel model) (epilogueOf cfg) alpha beta A B C).map
        (fun row => row.map fun cell => cell.map ScaledMatrixCell.output) := by
  rw [← scaledGemm_eq_independent]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [scaledGemmBits, Vector.getElem_map, Option.map_map]
  rfl

theorem scalarConvertWord_eq (source target : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) :
    scalarConvertWord (layoutOf source) (layoutOf target) (scalarModeOf mode) bits =
      convertGemmWord source target mode bits := by
  simp only [scalarConvertWord, scalarValue_eq, scalarRound_eq, convertGemmWord]
  cases hd : binaryValue source bits with
  | none => rfl
  | some x =>
    change roundBinary target mode x = (ConversionStage.convert ⟨target, mode⟩ x).bind (fun y => some y.bits)
    rw [← conversionStage_bits_eq (ConversionStage.mk target mode) x]
    cases (ConversionStage.convert ⟨target, mode⟩ x) <;> rfl

theorem convertMatrix_eq (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) :
    convertMatrix (layoutOf source) (scalarModeOf mode) A = convertGemmInput source mode A := by
  classical
  unfold convertMatrix convertGemmInput
  change (if ∀ i : Fin m, ∀ j : Fin n,
      (scalarConvertWord (layoutOf source) (layoutOf fp16) (scalarModeOf mode) A[i.val][j.val]).isSome then
    some (DenseMatrix.ofFn fun i j =>
      (scalarConvertWord (layoutOf source) (layoutOf fp16) (scalarModeOf mode) A[i.val][j.val]).getD 0)
    else none) = _
  simp only [scalarConvertWord_eq]

/-- Complete source-format pipeline equality, including whole-input-conversion
failure and per-entry scalar/tensor-core failure. Empty dimensions remain explicit. -/
theorem convertedGemm_eq_independent (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemm source inputMode model cfg alpha beta A B C).map
      (fun D => D.map fun row => row.map fun cell => cell.map scaledCellObservation) =
      convertedMatrix (layoutOf source) (scalarModeOf inputMode) (wmmaModel model)
        (epilogueOf cfg) alpha beta A B C := by
  simp only [convertedGemm, convertedMatrix, convertMatrix_eq]
  cases ha : convertGemmInput source inputMode A <;> cases hb : convertGemmInput source inputMode B <;>
    simp [bind, pure, scaledGemm_eq_independent] <;> rfl

end TensorCore.PaperSpec
