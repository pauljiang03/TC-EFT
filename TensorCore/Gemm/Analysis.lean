-- Analysis for GEMM.

import TensorCore.TC.Program.GroupAnalysis
import TensorCore.Gemm.InputBounds
import TensorCore.Gemm.Specification.GemmEquivalence

namespace TensorCore

def checkGemmCell (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32)
    (ws : List GroupWitness) : Option AnalysisBound := do
  let cv ← value32 c
  checkGroups model.path.profile (gemmBlocks model pairs) (absQ cv) ws

theorem checkGemmCell_sound (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32)
    (ws : List GroupWitness) (b : AnalysisBound) (h : checkGemmCell model pairs c ws = some b) :
    ∃ cell products, simulateGemmCell model pairs c = .ok cell ∧
      idealProducts v100F16F32 pairs = some products ∧ value32 c = some cell.initial.value ∧
      absQ cell.output.value ≤ b.magnitude ∧
      absQ (cell.initial.value + products - cell.output.value) ≤ b.error := by
  simp only [checkGemmCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨cv, hv, hc⟩ := h
  obtain ⟨initial, hi, hb, hval⟩ := finite32_of_value32 c cv hv
  obtain ⟨ts, products, hr, hp, hm, he⟩ := checkGroups_sound model.path.profile
    (gemmBlocks model pairs) (absQ cv) ws b hc initial (by rw [hval]; exact Rat.le_refl)
  obtain ⟨traces, ht, hf⟩ := runGemmInstructions_complete model.path initial
    (gemmInstructions pairs) ts
    (fun g hg => (gemmInstructions_shape pairs g hg).trans (WmmaGemmModel.k model).symm) hr
  refine ⟨⟨initial, traces⟩, products, ?_, ?_, ?_, ?_, ?_⟩
  · simp [simulateGemmCell, hi, ht]
  · rwa [gemmBlocks_ideal] at hp
  · simpa [hval] using hv
  · simpa [GemmCell.output, GemmCell.blocks, hf] using hm
  · simpa [GemmCell.output, GemmCell.blocks, hf] using he

structure CellAnalysis where
  witness : List GroupWitness
  bound : AnalysisBound
  deriving Repr, DecidableEq

def analyzeGemmCell (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32) :
    Option CellAnalysis := do
  let cv ← value32 c
  let ws ← inferGroups model.path.profile (gemmBlocks model pairs) (absQ cv)
  let b ← checkGemmCell model pairs c ws
  return ⟨ws, b⟩

theorem analyzeGemmCell_checked (model : WmmaGemmModel) (pairs : List (F16 × F16)) (c : F32)
    (a : CellAnalysis) (h : analyzeGemmCell model pairs c = some a) :
    checkGemmCell model pairs c a.witness = some a.bound := by
  simp only [analyzeGemmCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨_, _, ws, _, b, hb, he⟩ := h
  cases he
  exact hb

theorem analyzeGemmCell_complete (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (c : F32) (cv M : ℚ) (hc : value32 c = some cv)
    (hm : scheduleMass model.path.profile (gemmBlocks model pairs) = some M)
    (hr : absQ cv + M ≤ maxFinite32) : ∃ a, analyzeGemmCell model pairs c = some a := by
  obtain ⟨ws, hw⟩ := inferGroups_complete model.path.profile (gemmBlocks model pairs) (absQ cv) M
    (gemmBlocks_shape model pairs) (absQ_nonneg cv) hm hr
  obtain ⟨b, hb⟩ := inferGroups_checked model.path.profile (gemmBlocks model pairs) (absQ cv) ws hw
  exact ⟨⟨ws, b⟩, by simp [analyzeGemmCell, checkGemmCell, hc, hw, hb]⟩

def analyzeGemm (model : WmmaGemmModel) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option CellAnalysis) m n :=
  DenseMatrix.ofFn fun i j => analyzeGemmCell model (gemmPairs A B i j) C[i.val][j.val]

def analysisEntryBounds (cells : DenseMatrix (Option CellAnalysis) m n) : DenseMatrix ℚ m n :=
  cells.map fun row => row.map fun a => (a.map fun c => c.bound.error).getD 0

def gemmAnalysisCheck (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ) : Bool :=
  decide (0 ≤ tolerance) &&
  decide (∀ i : Fin m, ∀ j : Fin n,
    ((checkGemmCell model (gemmPairs A B i j) C[i.val][j.val] witness[i.val][j.val]).map
      fun b => decide (b.error ≤ tolerance)).getD false = true)

def GemmAccurate (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (tolerance : ℚ) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ cell z,
    (gemm model A B C)[i.val][j.val] = .ok cell ∧
    (gemmIdeal A B C)[i.val][j.val] = some z ∧ absQ (z - cell.output.value) ≤ tolerance

theorem gemmAnalysisCheck_sound (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ)
    (h : gemmAnalysisCheck model A B C witness tolerance = true) :
    GemmAccurate model A B C tolerance := by
  simp only [gemmAnalysisCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro i j
  have hc := h.2 i j
  cases hb : checkGemmCell model (gemmPairs A B i j) C[i.val][j.val] witness[i.val][j.val] with
  | none => simp [hb] at hc
  | some b =>
    simp only [hb, Option.map_some, Option.getD_some, decide_eq_true_eq] at hc
    obtain ⟨cell, products, hr, hp, hv, _, he⟩ := checkGemmCell_sound model _ _ _ b hb
    refine ⟨cell, cell.initial.value + products, ?_, ?_, Rat.le_trans he hc⟩
    · rwa [gemm_entry]
    · simp [gemmIdeal, DenseMatrix.ofFn, hv, hp]

theorem analyzeGemm_entry_sound (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (i : Fin m) (j : Fin n)
    (a : CellAnalysis) (h : (analyzeGemm model A B C)[i.val][j.val] = some a) :
    ∃ cell z, (gemm model A B C)[i.val][j.val] = .ok cell ∧
      (gemmIdeal A B C)[i.val][j.val] = some z ∧
      absQ cell.output.value ≤ a.bound.magnitude ∧ absQ (z - cell.output.value) ≤ a.bound.error := by
  simp only [analyzeGemm, DenseMatrix.ofFn, Vector.getElem_ofFn] at h
  have hc := analyzeGemmCell_checked model _ _ a h
  obtain ⟨cell, products, hr, hp, hv, hm, he⟩ := checkGemmCell_sound model _ _ _ _ hc
  refine ⟨cell, cell.initial.value + products, ?_, ?_, hm, he⟩
  · rwa [gemm_entry]
  · simp [gemmIdeal, DenseMatrix.ofFn, hv, hp]

theorem gemmAnalysisCheck_matrix_error (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ)
    (h : gemmAnalysisCheck model A B C witness tolerance = true)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * tolerance := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨cell, z, hr, hi, he⟩ := gemmAnalysisCheck_sound model A B C witness tolerance h i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he

theorem analyzeGemm_matrix_error (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : ∀ i : Fin m, ∀ j : Fin n, ∃ a, (analyzeGemm model A B C)[i.val][j.val] = some a)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (analysisEntryBounds (analyzeGemm model A B C)) := by
  apply matrixAbsSum_le_entry_bounds
  intro i j
  obtain ⟨a, ha⟩ := h i j
  obtain ⟨cell, z, hr, hi, _, he⟩ := analyzeGemm_entry_sound model A B C i j a ha
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, analysisEntryBounds, ha, hd i j cell hr] using he

theorem gemmAnalysisCheck_paper (model : WmmaGemmModel) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (witness : DenseMatrix (List GroupWitness) m n) (tolerance : ℚ)
    (h : gemmAnalysisCheck model A B C witness tolerance = true) (i : Fin m) (j : Fin n) :
    ∃ bits d z,
      (PaperSpec.wmmaGemmBits (PaperSpec.wmmaModel model) A B C)[i.val][j.val] = some bits ∧
      value32 bits = some d ∧ (gemmIdeal A B C)[i.val][j.val] = some z ∧
      absQ (z - d) ≤ tolerance := by
  obtain ⟨cell, z, hr, hi, he⟩ := gemmAnalysisCheck_sound model A B C witness tolerance h i j
  refine ⟨cell.output.bits, cell.output.value, z, ?_, ?_, hi, he⟩
  · rw [← PaperSpec.gemmBits_eq_paper]
    simp [gemmBits, hr, Except.toOption, Except.map]
  · simp [value32, cell.output.valid, Finite32.value]

end TensorCore
