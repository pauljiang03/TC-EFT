-- Native Scaled Gemm for GEMM.

import TensorCore.Gemm.NativeGemm
import TensorCore.Gemm.ScaledGemmAnalysis
import TensorCore.Gemm.MatrixConversion

namespace TensorCore

def nativeProductTrace (model : NativeGemmModel p) (k : ℕ) (cell : NativeGemmCell) : GemmCell :=
  ⟨cell.initial, chunks (p.inner / model.products) (groupCount p.inner k) cell.blocks⟩

theorem nativeProductTrace_output (model : NativeGemmModel p)
    (pairs : List (NativeWord p × NativeWord p)) (cell : NativeGemmCell)
    (h : nativeGemmCell model pairs 0 = some cell) :
    (nativeProductTrace model pairs.length cell).output = cell.output := by
  unfold GemmCell.output GemmCell.blocks nativeProductTrace
  rw [native_instruction_trace_covers model pairs 0 cell h]
  rfl

def nativeProductCell (model : NativeGemmModel p) (pairs : List (NativeWord p × NativeWord p)) :
    Option GemmCell := (nativeGemmCell model pairs 0).map (nativeProductTrace model pairs.length)

def nativeScaledGemm (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option (ScaledGemmCell cfg)) m n :=
  DenseMatrix.ofFn fun i j => do
    let product ← nativeProductCell model (nativePairs A B i j)
    gemmEpilogue cfg alpha beta C[i.val][j.val] product

def nativeConvertedGemm (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix (Option (ScaledGemmCell cfg)) m n) := do
  let a ← convertMatrixTo source p.format mode A
  let b ← convertMatrixTo source p.format mode B
  return nativeScaledGemm model cfg alpha beta a b C

def checkNativeScaledCell (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord p × NativeWord p)) (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← checkNativeCell model pairs 0 w.groups
  checkEpilogue cfg a b cv raw w.epilogue

theorem checkNativeScaledCell_sound (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (NativeWord p × NativeWord p))
    (w : ScaledWitness) (bound : PipelineBound)
    (h : checkNativeScaledCell model cfg alpha beta c pairs w = some bound) :
    ∃ product t z, nativeProductCell model pairs = some product ∧
      gemmEpilogue cfg alpha beta c product = some t ∧
      sourceGemmCellIdeal p.format alpha beta c pairs = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkNativeScaledCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨a, ha, b, hb, cv, hc, raw, hraw, hepi⟩ := h
  obtain ⟨cell, v, hp, hi, hv, hm, he⟩ := checkNativeCell_sound model pairs 0 w.groups raw hraw
  have hz : cell.initial.value = 0 := by
    have hzero : value32 0 = some 0 := by decide +kernel
    rw [hzero] at hv
    exact (Option.some.inj hv).symm
  rw [hz, Rat.zero_add] at he
  let product := nativeProductTrace model pairs.length cell
  have ho : product.output = cell.output := nativeProductTrace_output model pairs cell hp
  obtain ⟨t, ht, hmag, herr⟩ := checkEpilogue_sound cfg alpha beta c a b cv ha hb hc raw
    w.epilogue bound hepi product v (by simpa [ho] using hm) (by simpa [ho] using he)
  have hi' : sourceGemmProducts p.format pairs = some v :=
    (sourceGemmProducts_eq_idealProducts model.profile pairs).trans hi
  exact ⟨product, t, a * v + b * cv, by unfold nativeProductCell; rw [hp]; rfl, ht,
    by simp [sourceGemmCellIdeal, ha, hb, hc, hi'], hmag, herr⟩

def inferNativeScaledWitness (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord p × NativeWord p)) : Option ScaledWitness := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← analyzeNativeCell model pairs 0
  return ⟨raw.witness, inferEpilogue cfg a b cv raw.bound⟩

def analyzeNativeScaledCell (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (NativeWord p × NativeWord p)) : Option ScaledAnalysis := do
  let w ← inferNativeScaledWitness model cfg alpha beta c pairs
  let b ← checkNativeScaledCell model cfg alpha beta c pairs w
  return ⟨w, b⟩

theorem analyzeNativeScaledCell_checked (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (NativeWord p × NativeWord p)) (a : ScaledAnalysis)
    (h : analyzeNativeScaledCell model cfg alpha beta c pairs = some a) :
    checkNativeScaledCell model cfg alpha beta c pairs a.witness = some a.bound := by
  simp only [analyzeNativeScaledCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨w, _, b, hb, rfl⟩ := h
  exact hb

theorem checkNativeScaledCell_inputConversion (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (NativeWord p × NativeWord p)) (w : ScaledWitness) (b : PipelineBound)
    (h : checkNativeScaledCell model cfg alpha beta c pairs w = some b) : b.inputConversion = 0 := by
  simp only [checkNativeScaledCell, checkEpilogue, bind, pure, Option.bind_eq_some_iff,
    Option.some.injEq] at h
  obtain ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, rfl⟩ := h
  rfl

end TensorCore
