-- Family for GEMM.

import TensorCore.Gemm.Analysis
import TensorCore.Gemm.ScalarAnalysis
import TensorCore.Core.Binary.MagnitudeScale

namespace TensorCore

structure GemmFamily where
  aBound : ℚ
  bBound : ℚ
  cBound : ℚ
  deriving Repr, DecidableEq

def MatrixWithin (f : Format) (M : ℚ) (A : DenseMatrix (BitVec f.width) m n) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ d, (classify f A[i.val][j.val]).finite = some d ∧ absQ d.value ≤ M

def GemmFamily.Contains (f : GemmFamily) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Prop :=
  MatrixWithin fp16 f.aBound A ∧ MatrixWithin fp16 f.bBound B ∧ MatrixWithin fp32 f.cBound C

def familyOperandScale (M : ℚ) : ℤ := max fp16.emin (magnitudeScale M)

theorem familyOperandScale_spec (M : ℚ) (h : 0 ≤ M) :
    fp16.emin ≤ familyOperandScale M ∧ M < pow2 (familyOperandScale M + 1) := by
  have hm := magnitudeScale_spec M h
  have he : magnitudeScale M ≤ familyOperandScale M := by unfold familyOperandScale; omega
  have hp := pow2_le_of_le (show magnitudeScale M + 1 ≤ familyOperandScale M + 1 by omega)
  constructor
  · unfold familyOperandScale; omega
  · grind

def GemmFamily.productScale (f : GemmFamily) : ℤ :=
  familyOperandScale f.aBound + familyOperandScale f.bBound

def familyConditions (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) : Bool :=
  let p := model.path.profile
  let E := cfg.accumulatorScale
  let P := cfg.productScale
  let L := cfg.carryBits
  decide (0 ≤ f.aBound ∧ 0 ≤ f.bBound ∧ 0 ≤ f.cBound ∧
    f.productScale ≤ P ∧ cfg.initialBound = f.cBound ∧
    -126 ≤ E ∧ P ≤ E ∧ (∀ q ∈ p.alignFloor, q ≤ E) ∧
    p.products + 1 ≤ 2 ^ L ∧ E + 2 + L ≤ 127 ∧
    f.cBound + (gemmBlockCount model k : ℚ) *
      ((p.products : ℚ) * (4 * pow2 P) +
        staticBudget (p.products + 1) p.alignFraction E L) < pow2 (E + 1))

def familyError (model : WmmaGemmModel) (k : ℕ) (cfg : GemmBoundConfig) : ℚ :=
  if k = 0 then 0 else gemmStaticError model cfg k

def familyCheck (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) (tol : ℚ) : Bool :=
  decide (0 ≤ f.aBound ∧ 0 ≤ f.bBound ∧ 0 ≤ f.cBound ∧ 0 ≤ tol) &&
  (k == 0 || familyConditions model k f cfg) && decide (familyError model k cfg ≤ tol)

def inferFamily (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily) : Option GemmBoundConfig :=
  let L := match model with | .v100 => 3 | .ampere => 4 | .hopper => 5
  if k = 0 then some ⟨0, f.productScale, L, f.cBound⟩ else
    ((List.range 254).map fun (i : ℕ) => (⟨(i : ℤ) - 126, f.productScale, L, f.cBound⟩ : GemmBoundConfig)).find?
      (familyConditions model k f)

theorem family_pair_scale (model : WmmaGemmModel) (f : GemmFamily)
    (hA : 0 ≤ f.aBound) (hB : 0 ≤ f.bBound) (a b : F16)
    (ha : ∃ d, (classify fp16 a).finite = some d ∧ absQ d.value ≤ f.aBound)
    (hb : ∃ d, (classify fp16 b).finite = some d ∧ absQ d.value ≤ f.bBound) :
    ∃ da db, model.path.profile.decode a = some da ∧ model.path.profile.decode b = some db ∧
      ((rawMul da db).significand ≠ 0 → (rawMul da db).rawScale ≤ f.productScale) := by
  obtain ⟨da, hda, ham⟩ := ha
  obtain ⟨db, hdb, hbm⟩ := hb
  refine ⟨da, db, hda, hdb, ?_⟩
  intro hn
  have hna : da.significand ≠ 0 := by intro hz; apply hn; simp [rawMul, hz]
  have hnb : db.significand ≠ 0 := by intro hz; apply hn; simp [rawMul, hz]
  have hsa := familyOperandScale_spec f.aBound hA
  have hsb := familyOperandScale_spec f.bBound hB
  have hea := classifyNat_scale_le_of_magnitude fp16 a.toNat da hda _ hsa.1 (by grind) hna
  have heb := classifyNat_scale_le_of_magnitude fp16 b.toNat db hdb _ hsb.1 (by grind) hnb
  change da.rawScale + db.rawScale ≤ familyOperandScale f.aBound + familyOperandScale f.bBound
  omega

theorem gemmBlocks_pair_origin (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (g : List (F16 × F16)) (hg : g ∈ gemmBlocks model pairs) (pair : F16 × F16) (hp : pair ∈ g) :
    pair ∈ pairs ∨ pair = (0, 0) := by
  obtain ⟨instruction, hi, hgi⟩ := List.mem_flatMap.mp hg
  have hmem : pair ∈ (model.path.schedule instruction).flatten := List.mem_flatten.mpr ⟨g, hgi, hp⟩
  rw [model.path.schedule_flatten instruction
    ((gemmInstructions_shape pairs instruction hi).trans (WmmaGemmModel.k model).symm)] at hmem
  have hflat : pair ∈ (gemmInstructions pairs).flatten := List.mem_flatten.mpr ⟨instruction, hi, hmem⟩
  rw [gemmInstructions_flatten, padFp16Pairs, List.mem_append] at hflat
  rcases hflat with h | h
  · exact Or.inl h
  · exact Or.inr (List.mem_replicate.mp h).2

theorem familyConditions_gemmCheck (model : WmmaGemmModel) (f : GemmFamily)
    (cfg : GemmBoundConfig) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) (hf : familyConditions model k f cfg = true)
    (h : f.Contains A B C) : gemmCheck model cfg A B C = true := by
  simp only [familyConditions, decide_eq_true_eq] at hf
  obtain ⟨ha0, hb0, _, hP, hC, hE, hPE, hfloor, hL, hrange, hroom⟩ := hf
  apply decide_eq_true (p := ∀ i : Fin m, ∀ j : Fin n,
    gemmCellCheck model cfg (gemmPairs A B i j) C[i.val][j.val] = true)
  intro i j
  obtain ⟨dc, hdc, hcm⟩ := h.2.2 i j
  change decode32 C[i.val][j.val] = some dc at hdc
  have hcv : value32 C[i.val][j.val] = some dc.value := by simp [value32, hdc]
  have hs : (gemmBlocks model (gemmPairs A B i j)).all
      (groupScaleCheck model.path.profile cfg.productScale) = true := by
    apply List.all_eq_true.mpr
    intro g hg
    apply List.all_eq_true.mpr
    intro pair hp
    have hpair : ∃ da db, model.path.profile.decode pair.1 = some da ∧
        model.path.profile.decode pair.2 = some db ∧
        ((rawMul da db).significand ≠ 0 → (rawMul da db).rawScale ≤ f.productScale) := by
      rcases gemmBlocks_pair_origin model (gemmPairs A B i j) g hg pair hp with hm | hz
      · simp only [gemmPairs, List.mem_ofFn] at hm
        obtain ⟨l, rfl⟩ := hm
        exact family_pair_scale model f ha0 hb0 _ _ (h.1 i l) (h.2.1 l j)
      · rw [hz]
        have hz0 : (classify fp16 (0 : F16)).finite = some (Decoded.mk 0 0 0) := by decide +kernel
        apply family_pair_scale model f ha0 hb0
        · exact ⟨⟨0, 0, 0⟩, hz0, by simpa [Decoded.value, absQ] using ha0⟩
        · exact ⟨⟨0, 0, 0⟩, hz0, by simpa [Decoded.value, absQ] using hb0⟩
    obtain ⟨da, db, hda, hdb, hscale⟩ := hpair
    simp only [hda, hdb, Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq]
    by_cases hz : (rawMul da db).significand = 0
    · exact Or.inl hz
    · exact Or.inr (Int.le_trans (hscale hz) hP)
  simp only [gemmCellCheck, hs, hcv, Bool.and_eq_true, decide_eq_true_eq, gemmPairs_length]
  exact ⟨⟨⟨hE, hPE, hfloor, hL, hrange⟩, True.intro⟩, by simpa [hC] using hcm, by simpa [hC] using hroom⟩

def GemmFamilyAccurate (model : WmmaGemmModel) (f : GemmFamily) (m n k : ℕ) (tol : ℚ) : Prop :=
  ∀ (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n),
    f.Contains A B C → GemmAccurate model A B C tol

theorem familyCheck_sound (model : WmmaGemmModel) (f : GemmFamily) (cfg : GemmBoundConfig)
    (m n k : ℕ) (tol : ℚ) (h : familyCheck model k f cfg tol = true) :
    GemmFamilyAccurate model f m n k tol := by
  simp only [familyCheck, Bool.and_eq_true, Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq] at h
  intro A B C hmem i j
  by_cases hk : k = 0
  · subst k
    obtain ⟨dc, hdc, _⟩ := hmem.2.2 i j
    change decode32 C[i.val][j.val] = some dc at hdc
    have hcv : value32 C[i.val][j.val] = some dc.value := by simp only [value32, hdc, Option.map_some]
    obtain ⟨initial, hf, _, hv⟩ := finite32_of_value32 C[i.val][j.val] dc.value hcv
    have hp : gemmPairs A B i j = [] := by simp [gemmPairs]
    refine ⟨⟨initial, []⟩, initial.value, ?_, ?_, ?_⟩
    · rw [gemm_entry, hp]
      simp [simulateGemmCell, hf, gemmInstructions, canonicalPartition, partitionExact,
        OrderedPartition.inputs, padFp16Pairs, groupCount, tailPadding, runGemmInstructions]
    · simp only [gemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, hp, hcv, bind, pure, Option.bind_some]
      change some (dc.value + 0) = some initial.value
      rw [hv, Rat.add_zero]
    · change absQ (initial.value - initial.value) ≤ tol
      simpa [Rat.sub_self, absQ] using h.1.1.2.2.2
  · have hc := h.1.2.resolve_left hk
    obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound model cfg A B C
      (familyConditions_gemmCheck model f cfg A B C hc hmem) i j
    refine ⟨cell, z, hr, hi, Rat.le_trans he ?_⟩
    simpa [familyError, hk] using h.2

theorem inferFamily_valid (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) (h : inferFamily model k f = some cfg) :
    k = 0 ∨ familyConditions model k f cfg = true := by
  by_cases hk : k = 0
  · exact Or.inl hk
  · simp only [inferFamily, hk, ↓reduceIte] at h
    exact Or.inr (List.find?_some h)

theorem familyCheck_matrix_error (model : WmmaGemmModel) (f : GemmFamily) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (tol : ℚ)
    (h : familyCheck model k f cfg tol = true) (hmem : f.Contains A B C)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * tol := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨cell, z, hr, hi, he⟩ := familyCheck_sound model f cfg m n k tol h A B C hmem i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he

theorem familyCheck_paper (model : WmmaGemmModel) (f : GemmFamily) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (tol : ℚ)
    (h : familyCheck model k f cfg tol = true) (hmem : f.Contains A B C) (i : Fin m) (j : Fin n) :
    ∃ bits d z,
      (PaperSpec.wmmaGemmBits (PaperSpec.wmmaModel model) A B C)[i.val][j.val] = some bits ∧
      value32 bits = some d ∧ (gemmIdeal A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨cell, z, hr, hi, he⟩ := familyCheck_sound model f cfg m n k tol h A B C hmem i j
  refine ⟨cell.output.bits, cell.output.value, z, ?_, ?_, hi, he⟩
  · rw [← PaperSpec.gemmBits_eq_paper]
    simp [gemmBits, hr, Except.toOption, Except.map]
  · simp [value32, cell.output.valid, Finite32.value]

theorem familyError_nonneg (model : WmmaGemmModel) (k : ℕ) (cfg : GemmBoundConfig) :
    0 ≤ familyError model k cfg := by
  unfold familyError
  split
  · exact Rat.le_refl
  · exact Rat.mul_nonneg Rat.natCast_nonneg
      (Rat.le_of_lt (staticBudget_positive _ _ _ _))

theorem familyCheck_at_bound (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) (tol : ℚ) (h : familyCheck model k f cfg tol = true) :
    familyCheck model k f cfg (familyError model k cfg) = true := by
  simp only [familyCheck, Bool.and_eq_true, decide_eq_true_eq] at h ⊢
  exact ⟨⟨⟨h.1.1.1, h.1.1.2.1, h.1.1.2.2.1, familyError_nonneg model k cfg⟩, h.1.2⟩, Rat.le_refl⟩

end TensorCore
