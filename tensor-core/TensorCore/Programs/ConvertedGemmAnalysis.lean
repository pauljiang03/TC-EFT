import TensorCore.Programs.ScaledGemmAnalysis
import TensorCore.Programs.GemmTightInputBounds
import TensorCore.PaperSpec.ScaledGemmEquivalence

namespace TensorCore

def sourceAnalysisCell (source : Format) (mode : BinaryRoundingMode)
    (alpha : F32) (pairs : List (BitVec source.width × BitVec source.width))
    (cell : ScaledAnalysis) : Option ScaledAnalysis := do
  let a ← value32 alpha
  let e ← gemmInputProductTightError source mode pairs
  return ⟨cell.witness, {cell.bound with inputConversion := absQ a * e}⟩

def analyzeConvertedGemm (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option ScaledAnalysis) m n) := do
  let a ← convertGemmInput source mode A
  let b ← convertGemmInput source mode B
  return DenseMatrix.ofFn fun i j => do
    let cell ← analyzeScaledCell model cfg alpha beta C[i.val][j.val] (gemmPairs a b i j)
    sourceAnalysisCell source mode alpha (sourceGemmPairs source A B i j) cell

def checkConvertedCell (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) (original : List (BitVec source.width × BitVec source.width))
    (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let e ← gemmInputProductTightError source mode original
  let b ← checkScaledCell model cfg alpha beta c pairs w
  return {b with inputConversion := absQ a * e}

def convertedAnalysisCheck (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : Rat) : Bool :=
  decide (0 ≤ tol) && match convertGemmInput source mode A, convertGemmInput source mode B with
  | some a, some b => decide (∀ i : Fin m, ∀ j : Fin n,
      ((checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
        (gemmPairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val]).map
          fun bound => decide (bound.error ≤ tol)).getD false = true)
  | _, _ => false

def ConvertedGemmAccurate (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : Rat) : Prop :=
  ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
    ∀ i : Fin m, ∀ j : Fin n, ∃ t z, D[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ tol

theorem checkConvertedCell_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (a : DenseMatrix F16 m k) (b : DenseMatrix F16 k n)
    (ha : convertGemmInput source mode A = some a) (hb : convertGemmInput source mode B = some b)
    (i : Fin m) (j : Fin n) (w : ScaledWitness) (bound : PipelineBound)
    (h : checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (gemmPairs a b i j) (sourceGemmPairs source A B i j) w = some bound) :
    ∃ t z, (scaledGemm model cfg alpha beta a b C)[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkConvertedCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨av, hav, e, herr, bound, hbound, rfl⟩ := h
  have hzero := checkScaledCell_inputConversion model cfg alpha beta _ _ w bound hbound
  obtain ⟨product, t, z, hp, ht, hz, hm, he⟩ := checkScaledCell_sound model cfg alpha beta _ _ w bound hbound
  obtain ⟨s, p, e', hs, hi, he', hdiff⟩ := convertGemmInput_products_tight_error source mode A B a b ha hb i j
  rw [herr] at he'
  cases Option.some.inj he'
  simp only [scaledGemmCellIdeal, hav, bind, pure, Option.bind_some, Option.bind_eq_some_iff] at hz
  obtain ⟨bv, hbv, cv, hcv, p', hp', hz⟩ := hz
  rw [hi] at hp'
  cases Option.some.inj hp'
  cases Option.some.inj hz
  refine ⟨t, av * s + bv * cv, ?_, ?_, hm, ?_⟩
  · simp only [scaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn, gemm_entry]
    change ((simulateGemmCell model (gemmPairs a b i j) (0 : F32)).toOption.bind
      fun product => gemmEpilogue cfg alpha beta C[i.val][j.val] product) = some t
    rw [hp]
    exact ht
  · simp [sourceGemmIdeal, DenseMatrix.ofFn, sourceGemmCellIdeal, hav, hbv, hcv, hs]
  · have hfinal := gemmSourceError_propagate av bv cv s p t.output.value e bound.error hdiff he
    simpa [PipelineBound.error, hzero, Rat.add_zero] using hfinal

theorem convertedAnalysisCheck_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : Rat)
    (h : convertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ConvertedGemmAccurate source mode model cfg alpha beta A B C tol := by
  simp only [convertedAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  cases ha : convertGemmInput source mode A with
  | none => simp [ha] at h
  | some a =>
    cases hb : convertGemmInput source mode B with
    | none => simp [ha, hb] at h
    | some b =>
      simp only [ha, hb, decide_eq_true_eq] at h
      refine ⟨scaledGemm model cfg alpha beta a b C, by simp [convertedGemm, ha, hb], ?_⟩
      intro i j
      have hc := h.2 i j
      cases he : checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
          (gemmPairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val] with
      | none => simp [he] at hc
      | some bound =>
        simp only [he, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
        obtain ⟨t, z, ht, hz, _, herr⟩ := checkConvertedCell_sound source mode model cfg alpha beta
          A B C a b ha hb i j _ bound he
        exact ⟨t, z, ht, hz, Rat.le_trans herr hc⟩

theorem analyzeConvertedGemm_checked (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (a : DenseMatrix F16 m k) (b : DenseMatrix F16 k n)
    (ha : convertGemmInput source mode A = some a) (hb : convertGemmInput source mode B = some b)
    (i : Fin m) (j : Fin n) (cell : ScaledAnalysis) (hc : cells[i.val][j.val] = some cell) :
    checkConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (gemmPairs a b i j) (sourceGemmPairs source A B i j) cell.witness = some cell.bound := by
  simp only [analyzeConvertedGemm, ha, hb, bind, pure, Option.bind_some, Option.some.injEq] at h
  rw [← h] at hc
  simp only [DenseMatrix.ofFn, Vector.getElem_ofFn, Option.bind_eq_some_iff] at hc
  obtain ⟨raw, hraw, hsource⟩ := hc
  simp only [sourceAnalysisCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hsource
  obtain ⟨av, hav, e, he, rfl⟩ := hsource
  simp [checkConvertedCell, hav, he, analyzeScaledCell_checked model cfg alpha beta _ _ raw hraw]

theorem convertedAnalysisCheck_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : Rat)
    (h : convertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true)
    (D Z : DenseMatrix Rat m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : Rat) * (n : Rat) * tol := by
  obtain ⟨out, hr, entries⟩ := convertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨t, z, ht, hi, he⟩ := entries i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd out hr i j t ht] using he

theorem convertedAnalysisCheck_paper (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : Rat)
    (h : convertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ∃ D, PaperSpec.convertedMatrix (PaperSpec.layoutOf source) (PaperSpec.scalarModeOf mode)
        (PaperSpec.wmmaModel model) (PaperSpec.epilogueOf cfg) alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t d z, D[i.val][j.val] = some t ∧
        binaryValue cfg.output.format t.output = some d ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨out, hr, entries⟩ := convertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  refine ⟨out.map (fun row => row.map fun t => t.map PaperSpec.scaledCellObservation), ?_, ?_⟩
  · rw [← PaperSpec.convertedGemm_eq_independent, hr]
    rfl
  · intro i j
    obtain ⟨t, z, ht, hz, he⟩ := entries i j
    refine ⟨PaperSpec.scaledCellObservation t, t.output.value, z, ?_, ?_, hz, he⟩
    · simp [ht]
    · simp [PaperSpec.scaledCellObservation, binaryValue, t.output.valid, FiniteBinary.value]

def pipelineEntryBounds (cells : DenseMatrix (Option ScaledAnalysis) m n) : DenseMatrix Rat m n :=
  cells.map fun row => row.map fun a => (a.map fun c => c.bound.error).getD 0

theorem analyzeConvertedGemm_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (hcells : ∀ i : Fin m, ∀ j : Fin n, ∃ cell, cells[i.val][j.val] = some cell)
    (D Z : DenseMatrix Rat m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (pipelineEntryBounds cells) := by
  cases ha : convertGemmInput source mode A with
  | none => simp [analyzeConvertedGemm, ha] at h
  | some a =>
    cases hb : convertGemmInput source mode B with
    | none => simp [analyzeConvertedGemm, ha, hb] at h
    | some b =>
      have hr : convertedGemm source mode model cfg alpha beta A B C =
          some (scaledGemm model cfg alpha beta a b C) := by simp [convertedGemm, ha, hb]
      apply matrixAbsSum_le_entry_bounds
      intro i j
      obtain ⟨cell, hcell⟩ := hcells i j
      have hchecked := analyzeConvertedGemm_checked source mode model cfg alpha beta A B C cells h
        a b ha hb i j cell hcell
      obtain ⟨t, z, ht, hi, _, he⟩ := checkConvertedCell_sound source mode model cfg alpha beta
        A B C a b ha hb i j cell.witness cell.bound hchecked
      rw [hz i j] at hi
      cases Option.some.inj hi
      simpa [DenseMatrix.ofFn, pipelineEntryBounds, hcell, hd _ hr i j t ht] using he

end TensorCore
