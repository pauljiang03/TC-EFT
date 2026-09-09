-- Native Converted Analysis for GEMM.

import TensorCore.Gemm.Specification.NativeScaledGemmEquivalence
import TensorCore.Gemm.ConvertedGemmAnalysis

namespace TensorCore

theorem convertNativeInput_products_error (source : Format) (precision : NativePrecision) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (a : DenseMatrix (NativeWord precision) m k) (b : DenseMatrix (NativeWord precision) k n)
    (ha : convertMatrixTo source precision.format mode A = some a)
    (hb : convertMatrixTo source precision.format mode B = some b) (i : Fin m) (j : Fin n) :
    ∃ s p e, sourceGemmProducts source (sourceGemmPairs source A B i j) = some s ∧
      sourceGemmProducts precision.format (nativePairs a b i j) = some p ∧
      inputProductErrorTo source precision.format mode (sourceGemmPairs source A B i j) = some e ∧ absQ (s - p) ≤ e := by
  have h := inputProductErrorTo_bound source precision.format mode (List.finRange k)
    (fun l : Fin k => (A[i.val][l.val], B[l.val][j.val]))
    (fun l : Fin k => (a[i.val][l.val], b[l.val][j.val]))
    (by intro l _; exact ⟨convertMatrixTo_entry source precision.format mode A a ha i l,
      convertMatrixTo_entry source precision.format mode B b hb l j⟩)
  simpa [List.finRange, List.map_ofFn, Function.comp_def, sourceGemmPairs, nativePairs] using h

def nativeSourceAnalysisCell (source target : Format) (mode : BinaryRoundingMode)
    (alpha : F32) (pairs : List (BitVec source.width × BitVec source.width))
    (cell : ScaledAnalysis) : Option ScaledAnalysis := do
  let a ← value32 alpha
  let e ← inputProductErrorTo source target mode pairs
  return ⟨cell.witness, {cell.bound with inputConversion := absQ a * e}⟩

def analyzeNativeConvertedGemm (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option ScaledAnalysis) m n) := do
  let a ← convertMatrixTo source precision.format mode A
  let b ← convertMatrixTo source precision.format mode B
  return DenseMatrix.ofFn fun i j => do
    let cell ← analyzeNativeScaledCell model cfg alpha beta C[i.val][j.val] (nativePairs a b i j)
    nativeSourceAnalysisCell source precision.format mode alpha (sourceGemmPairs source A B i j) cell

def checkNativeConvertedCell (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord precision × NativeWord precision)) (original : List (BitVec source.width × BitVec source.width))
    (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let e ← inputProductErrorTo source precision.format mode original
  let b ← checkNativeScaledCell model cfg alpha beta c pairs w
  return {b with inputConversion := absQ a * e}

def nativeConvertedAnalysisCheck (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ) : Bool :=
  decide (0 ≤ tol) && match convertMatrixTo source precision.format mode A, convertMatrixTo source precision.format mode B with
  | some a, some b => decide (∀ i : Fin m, ∀ j : Fin n,
      ((checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
        (nativePairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val]).map
          fun bound => decide (bound.error ≤ tol)).getD false = true)
  | _, _ => false

def NativeConvertedGemmAccurate (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (tol : ℚ) : Prop :=
  ∃ D, nativeConvertedGemm source mode model cfg alpha beta A B C = some D ∧
    ∀ i : Fin m, ∀ j : Fin n, ∃ t z, D[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ tol

theorem checkNativeConvertedCell_sound (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (a : DenseMatrix (NativeWord precision) m k) (b : DenseMatrix (NativeWord precision) k n)
    (ha : convertMatrixTo source precision.format mode A = some a) (hb : convertMatrixTo source precision.format mode B = some b)
    (i : Fin m) (j : Fin n) (w : ScaledWitness) (bound : PipelineBound)
    (h : checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (nativePairs a b i j) (sourceGemmPairs source A B i j) w = some bound) :
    ∃ t z, (nativeScaledGemm model cfg alpha beta a b C)[i.val][j.val] = some t ∧
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkNativeConvertedCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨av, hav, e, herr, bound, hbound, rfl⟩ := h
  have hzero := checkNativeScaledCell_inputConversion model cfg alpha beta _ _ w bound hbound
  obtain ⟨product, t, z, hp, ht, hz, hm, he⟩ := checkNativeScaledCell_sound model cfg alpha beta _ _ w bound hbound
  obtain ⟨s, p, e', hs, hi, he', hdiff⟩ := convertNativeInput_products_error source precision mode A B a b ha hb i j
  rw [herr] at he'
  cases Option.some.inj he'
  simp only [sourceGemmCellIdeal, hav, bind, pure, Option.bind_some, Option.bind_eq_some_iff] at hz
  obtain ⟨bv, hbv, cv, hcv, p', hp', hz⟩ := hz
  rw [hi] at hp'
  cases Option.some.inj hp'
  cases Option.some.inj hz
  refine ⟨t, av * s + bv * cv, ?_, ?_, hm, ?_⟩
  · simp only [nativeScaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn]
    rw [hp]
    exact ht
  · simp [sourceGemmIdeal, DenseMatrix.ofFn, sourceGemmCellIdeal, hav, hbv, hcv, hs]
  · have hfinal := gemmSourceError_propagate av bv cv s p t.output.value e bound.error hdiff he
    simpa [PipelineBound.error, hzero, Rat.add_zero] using hfinal

theorem nativeConvertedAnalysisCheck_sound (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    NativeConvertedGemmAccurate source mode model cfg alpha beta A B C tol := by
  simp only [nativeConvertedAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  cases ha : convertMatrixTo source precision.format mode A with
  | none => simp [ha] at h
  | some a =>
    cases hb : convertMatrixTo source precision.format mode B with
    | none => simp [ha, hb] at h
    | some b =>
      simp only [ha, hb, decide_eq_true_eq] at h
      refine ⟨nativeScaledGemm model cfg alpha beta a b C, by simp [nativeConvertedGemm, ha, hb], ?_⟩
      intro i j
      have hc := h.2 i j
      cases he : checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
          (nativePairs a b i j) (sourceGemmPairs source A B i j) w[i.val][j.val] with
      | none => simp [he] at hc
      | some bound =>
        simp only [he, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
        obtain ⟨t, z, ht, hz, _, herr⟩ := checkNativeConvertedCell_sound source mode model cfg alpha beta
          A B C a b ha hb i j _ bound he
        exact ⟨t, z, ht, hz, Rat.le_trans herr hc⟩

theorem analyzeNativeConvertedGemm_checked (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeNativeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (a : DenseMatrix (NativeWord precision) m k) (b : DenseMatrix (NativeWord precision) k n)
    (ha : convertMatrixTo source precision.format mode A = some a) (hb : convertMatrixTo source precision.format mode B = some b)
    (i : Fin m) (j : Fin n) (cell : ScaledAnalysis) (hc : cells[i.val][j.val] = some cell) :
    checkNativeConvertedCell source mode model cfg alpha beta C[i.val][j.val]
      (nativePairs a b i j) (sourceGemmPairs source A B i j) cell.witness = some cell.bound := by
  simp only [analyzeNativeConvertedGemm, ha, hb, bind, pure, Option.bind_some, Option.some.injEq] at h
  rw [← h] at hc
  simp only [DenseMatrix.ofFn, Vector.getElem_ofFn, Option.bind_eq_some_iff] at hc
  obtain ⟨raw, hraw, hsource⟩ := hc
  simp only [nativeSourceAnalysisCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hsource
  obtain ⟨av, hav, e, he, rfl⟩ := hsource
  simp [checkNativeConvertedCell, hav, he, analyzeNativeScaledCell_checked model cfg alpha beta _ _ raw hraw]

theorem nativeConvertedAnalysisCheck_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, nativeConvertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * tol := by
  obtain ⟨out, hr, entries⟩ := nativeConvertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨t, z, ht, hi, he⟩ := entries i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd out hr i j t ht] using he

theorem nativeConvertedAnalysisCheck_paper (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (w : DenseMatrix ScaledWitness m n) (tol : ℚ)
    (h : nativeConvertedAnalysisCheck source mode model cfg alpha beta A B C w tol = true) :
    ∃ D, PaperSpec.nativeConvertedMatrix (PaperSpec.layoutOf source) (PaperSpec.scalarModeOf mode)
        (PaperSpec.parametersOf model.profile) precision.inner (PaperSpec.epilogueOf cfg) alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t d z, D[i.val][j.val] = some t ∧
        binaryValue cfg.output.format t.output = some d ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨out, hr, entries⟩ := nativeConvertedAnalysisCheck_sound source mode model cfg alpha beta A B C w tol h
  refine ⟨out.map (fun row => row.map fun t => t.map PaperSpec.scaledCellObservation), ?_, ?_⟩
  · rw [← PaperSpec.nativeConvertedGemm_eq_independent, hr]
    rfl
  · intro i j
    obtain ⟨t, z, ht, hz, he⟩ := entries i j
    refine ⟨PaperSpec.scaledCellObservation t, t.output.value, z, ?_, ?_, hz, he⟩
    · simp [ht]
    · simp [PaperSpec.scaledCellObservation, binaryValue, t.output.valid, FiniteBinary.value]

theorem analyzeNativeConvertedGemm_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel precision) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (cells : DenseMatrix (Option ScaledAnalysis) m n)
    (h : analyzeNativeConvertedGemm source mode model cfg alpha beta A B C = some cells)
    (hcells : ∀ i : Fin m, ∀ j : Fin n, ∃ cell, cells[i.val][j.val] = some cell)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, nativeConvertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (pipelineEntryBounds cells) := by
  cases ha : convertMatrixTo source precision.format mode A with
  | none => simp [analyzeNativeConvertedGemm, ha] at h
  | some a =>
    cases hb : convertMatrixTo source precision.format mode B with
    | none => simp [analyzeNativeConvertedGemm, ha, hb] at h
    | some b =>
      have hr : nativeConvertedGemm source mode model cfg alpha beta A B C =
          some (nativeScaledGemm model cfg alpha beta a b C) := by simp [nativeConvertedGemm, ha, hb]
      apply matrixAbsSum_le_entry_bounds
      intro i j
      obtain ⟨cell, hcell⟩ := hcells i j
      have hchecked := analyzeNativeConvertedGemm_checked source mode model cfg alpha beta A B C cells h
        a b ha hb i j cell hcell
      obtain ⟨t, z, ht, hi, _, he⟩ := checkNativeConvertedCell_sound source mode model cfg alpha beta
        A B C a b ha hb i j cell.witness cell.bound hchecked
      rw [hz i j] at hi
      cases Option.some.inj hi
      simpa [DenseMatrix.ofFn, pipelineEntryBounds, hcell, hd _ hr i j t ht] using he

end TensorCore
