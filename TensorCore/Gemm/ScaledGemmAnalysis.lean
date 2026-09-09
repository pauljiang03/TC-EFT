-- Scaled Gemm Analysis for GEMM.

import TensorCore.Gemm.Analysis
import TensorCore.Gemm.ExactScalarAnalysis

namespace TensorCore

structure EpilogueWitness where
  alphaScale : ℤ
  betaScale : ℤ
  sumScale : ℤ
  outputScale : ℤ
  deriving Repr, DecidableEq

structure ScaledWitness where
  groups : List GroupWitness
  epilogue : EpilogueWitness
  deriving Repr, DecidableEq

structure PipelineBound where
  magnitude : ℚ
  alignment : ℚ
  rounding : ℚ
  alphaRounding : ℚ
  betaRounding : ℚ
  addRounding : ℚ
  outputRounding : ℚ
  inputConversion : ℚ := 0
  deriving Repr, DecidableEq

def PipelineBound.error (b : PipelineBound) : ℚ :=
  b.alignment + b.rounding + b.alphaRounding + b.betaRounding +
    b.addRounding + b.outputRounding + b.inputConversion

def checkEpilogue (cfg : GemmEpilogue) (a b c : ℚ) (raw : AnalysisBound)
    (w : EpilogueWitness) : Option PipelineBound := do
  let ad ← checkFiniteMultiply cfg.multiplyMode a raw.magnitude w.alphaScale
  let bd ← checkFiniteMultiply cfg.multiplyMode b (absQ c) w.betaScale
  let sd ← checkFiniteAdd cfg.addMode ad.magnitude bd.magnitude w.sumScale
  let out ← checkOutput cfg.output sd.magnitude w.outputScale
  return ⟨out.magnitude, absQ a * raw.alignment, absQ a * raw.rounding,
    ad.error, bd.error, sd.error, out.error, 0⟩

def inferEpilogue (cfg : GemmEpilogue) (a b c : ℚ) (raw : AnalysisBound) : EpilogueWitness :=
  let A := absQ a * raw.magnitude
  let B := absQ b * absQ c
  let ae := scalarScale fp32 A
  let be := scalarScale fp32 B
  let ad := (checkFiniteMultiply cfg.multiplyMode a raw.magnitude ae).getD ⟨A, 0⟩
  let bd := (checkFiniteMultiply cfg.multiplyMode b (absQ c) be).getD ⟨B, 0⟩
  let S := ad.magnitude + bd.magnitude
  let se := scalarScale fp32 S
  let O := ((checkFiniteAdd cfg.addMode ad.magnitude bd.magnitude se).getD ⟨S, 0⟩).magnitude
  ⟨ae, be, se, scalarScale cfg.output.format O⟩

theorem checkEpilogue_sound (cfg : GemmEpilogue) (alpha beta c : F32) (a b cv : ℚ)
    (ha : value32 alpha = some a) (hb : value32 beta = some b) (hc : value32 c = some cv)
    (raw : AnalysisBound) (w : EpilogueWitness) (bound : PipelineBound)
    (h : checkEpilogue cfg a b cv raw w = some bound) (product : GemmCell) (p : ℚ)
    (hm : absQ product.output.value ≤ raw.magnitude)
    (he : absQ (p - product.output.value) ≤ raw.error) :
    ∃ t, gemmEpilogue cfg alpha beta c product = some t ∧
      absQ t.output.value ≤ bound.magnitude ∧
      absQ (a * p + b * cv - t.output.value) ≤ bound.error := by
  simp only [checkEpilogue, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨ad, had, bd, hbd, sd, hsd, out, hout, rfl⟩ := h
  obtain ⟨ac, hac, _, hav⟩ := finite32_of_value32 alpha a ha
  obtain ⟨bc, hbc, _, hbv⟩ := finite32_of_value32 beta b hb
  obtain ⟨cc, hcc, _, hcv⟩ := finite32_of_value32 c cv hc
  obtain ⟨adatum, hat, hatm, hate⟩ := checkFiniteMultiply_sound _ _ _ _ ad had
    product.output.value (classifyNat_finiteValue fp32 (by decide) _ _ product.output.valid) hm
  obtain ⟨bt, hbt, hbtm, hbte⟩ := checkFiniteMultiply_sound _ _ _ _ bd hbd
    cc.value (classifyNat_finiteValue fp32 (by decide) _ _ cc.valid) (by rw [hcv]; exact Rat.le_refl)
  rw [← hav] at hat hate
  rw [← hbv] at hbt hbte
  obtain ⟨st, hst, hstm, hste⟩ := checkFiniteAdd_sound _ _ _ _ sd hsd adatum bt hatm hbtm
  obtain ⟨ot, hot, hotm, hote⟩ := checkOutput_sound _ _ _ out hout st hstm
  change cfg.output.convert st.value = some ot at hot
  change absQ (st.value - ot.value) ≤ out.error at hote
  let t : ScaledGemmCell cfg := ⟨product, ac, bc, cc, adatum, bt, st, ot⟩
  refine ⟨t, ?_, hotm, ?_⟩
  · simp [gemmEpilogue, GemmEpilogue.multiplyStage, GemmEpilogue.addStage, hac, hbc, hcc, hat, hbt, hst, hot, t]
  · have hs : t.scalarError ≤ ad.error + bd.error + sd.error + out.error := by
      change absQ (ac.value * product.output.value - adatum.value) +
        absQ (bc.value * cc.value - bt.value) + absQ (adatum.value + bt.value - st.value) +
        absQ (st.value - ot.value) ≤ _
      grind
    have hp := t.propagate p raw.error he
    change absQ (ac.value * p + bc.value * cc.value - ot.value) ≤
      absQ ac.value * raw.error + t.scalarError at hp
    rw [hav, hbv, hcv] at hp
    simp only [PipelineBound.error, AnalysisBound.error] at *
    change absQ (a * p + b * cv - ot.value) ≤ _
    grind

def checkScaledCell (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) (w : ScaledWitness) : Option PipelineBound := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← checkGemmCell model pairs 0 w.groups
  checkEpilogue cfg a b cv raw w.epilogue

theorem checkScaledCell_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (F16 × F16)) (w : ScaledWitness) (bound : PipelineBound)
    (h : checkScaledCell model cfg alpha beta c pairs w = some bound) :
    ∃ product t z, simulateGemmCell model pairs 0 = .ok product ∧
      gemmEpilogue cfg alpha beta c product = some t ∧
      scaledGemmCellIdeal alpha beta c pairs = some z ∧
      absQ t.output.value ≤ bound.magnitude ∧ absQ (z - t.output.value) ≤ bound.error := by
  simp only [checkScaledCell, bind, Option.bind_eq_some_iff] at h
  obtain ⟨a, ha, b, hb, cv, hc, raw, hraw, hepi⟩ := h
  obtain ⟨product, p, hp, hi, hv, hm, he⟩ := checkGemmCell_sound model pairs 0 w.groups raw hraw
  have hzero : product.initial.value = 0 := by
    have hz : value32 0 = some 0 := by decide +kernel
    rw [hz] at hv
    exact (Option.some.inj hv).symm
  rw [hzero, Rat.zero_add] at he
  obtain ⟨t, ht, hmag, herr⟩ := checkEpilogue_sound cfg alpha beta c a b cv ha hb hc
    raw w.epilogue bound hepi product p hm he
  exact ⟨product, t, a * p + b * cv, hp, ht,
    by simp [scaledGemmCellIdeal, ha, hb, hc, hi], hmag, herr⟩

def inferScaledWitness (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) : Option ScaledWitness := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let raw ← analyzeGemmCell model pairs 0
  return ⟨raw.witness, inferEpilogue cfg a b cv raw.bound⟩

structure ScaledAnalysis where
  witness : ScaledWitness
  bound : PipelineBound
  deriving Repr, DecidableEq

def analyzeScaledCell (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta c : F32)
    (pairs : List (F16 × F16)) : Option ScaledAnalysis := do
  let w ← inferScaledWitness model cfg alpha beta c pairs
  let b ← checkScaledCell model cfg alpha beta c pairs w
  return ⟨w, b⟩

theorem analyzeScaledCell_checked (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (F16 × F16)) (a : ScaledAnalysis)
    (h : analyzeScaledCell model cfg alpha beta c pairs = some a) :
    checkScaledCell model cfg alpha beta c pairs a.witness = some a.bound := by
  simp only [analyzeScaledCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at h
  obtain ⟨w, _, b, hb, rfl⟩ := h
  exact hb

theorem checkScaledCell_inputConversion (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (alpha beta c : F32) (pairs : List (F16 × F16)) (w : ScaledWitness) (b : PipelineBound)
    (h : checkScaledCell model cfg alpha beta c pairs w = some b) : b.inputConversion = 0 := by
  simp only [checkScaledCell, checkEpilogue, bind, pure, Option.bind_eq_some_iff,
    Option.some.injEq] at h
  obtain ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, rfl⟩ := h
  rfl

end TensorCore
