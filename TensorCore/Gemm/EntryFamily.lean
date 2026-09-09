-- Entry Family for GEMM.

import TensorCore.Gemm.Family

namespace TensorCore

structure EntryFamily (m n k : ℕ) where
  a : DenseMatrix ℚ m k
  b : DenseMatrix ℚ k n
  c : DenseMatrix ℚ m n
  deriving Repr, DecidableEq

def capMaximum : List ℚ → ℚ
  | [] => 0
  | x :: xs => max x (capMaximum xs)

theorem le_capMaximum (xs : List ℚ) (x : ℚ) (h : x ∈ xs) : x ≤ capMaximum xs := by
  induction xs with
  | nil => simp at h
  | cons y ys ih =>
    simp only [List.mem_cons] at h
    rcases h with rfl | h
    · unfold capMaximum; grind
    · have := ih h
      unfold capMaximum; grind

def EntryFamily.cell (f : EntryFamily m n k) (i : Fin m) (j : Fin n) : GemmFamily :=
  ⟨capMaximum (List.ofFn fun l : Fin k => f.a[i.val][l.val]),
   capMaximum (List.ofFn fun l : Fin k => f.b[l.val][j.val]), f.c[i.val][j.val]⟩

def EntryWithin (fmt : Format) (caps : DenseMatrix ℚ m n)
    (A : DenseMatrix (BitVec fmt.width) m n) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ d,
    (classify fmt A[i.val][j.val]).finite = some d ∧ absQ d.value ≤ caps[i.val][j.val]

def EntryFamily.Contains (f : EntryFamily m n k) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Prop :=
  EntryWithin fp16 f.a A ∧ EntryWithin fp16 f.b B ∧ EntryWithin fp32 f.c C

def entryFamilyCheck (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : ℚ) : Bool :=
  decide (0 ≤ tol) && decide (∀ i : Fin m, ∀ j : Fin n,
    familyCheck model k (f.cell i j) ws[i.val][j.val] tol = true)

def inferEntryFamily (model : WmmaGemmModel) (f : EntryFamily m n k) :
    Option (DenseMatrix GemmBoundConfig m n) :=
  let cells := DenseMatrix.ofFn fun i j => inferFamily model k (f.cell i j)
  if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
    some (cells.map fun row => row.map fun c => c.getD ⟨0, 0, 0, 0⟩)
  else none

def EntryFamilyAccurate (model : WmmaGemmModel) (f : EntryFamily m n k) (tol : ℚ) : Prop :=
  ∀ A B C, f.Contains A B C → GemmAccurate model A B C tol

theorem entryFamily_cell_sound (model : WmmaGemmModel) (f : EntryFamily m n k)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (hm : f.Contains A B C) (i : Fin m) (j : Fin n) (cfg : GemmBoundConfig) (tol : ℚ)
    (h : familyCheck model k (f.cell i j) cfg tol = true) :
    ∃ cell z, (gemm model A B C)[i.val][j.val] = .ok cell ∧
      (gemmIdeal A B C)[i.val][j.val] = some z ∧ absQ (z - cell.output.value) ≤ tol := by
  let a : DenseMatrix F16 1 k := DenseMatrix.ofFn fun _ l => A[i.val][l.val]
  let b : DenseMatrix F16 k 1 := DenseMatrix.ofFn fun l _ => B[l.val][j.val]
  let c : DenseMatrix F32 1 1 := #v[#v[C[i.val][j.val]]]
  have hc : (f.cell i j).Contains a b c := by
    refine ⟨?_, ?_, ?_⟩
    · intro r l
      obtain ⟨d, hd, hb⟩ := hm.1 i l
      refine ⟨d, by simpa [a, DenseMatrix.ofFn] using hd, Rat.le_trans hb ?_⟩
      exact le_capMaximum _ _ (List.mem_ofFn.mpr ⟨l, rfl⟩)
    · intro l s
      obtain ⟨d, hd, hb⟩ := hm.2.1 l j
      refine ⟨d, by simpa [b, DenseMatrix.ofFn] using hd, Rat.le_trans hb ?_⟩
      exact le_capMaximum _ _ (List.mem_ofFn.mpr ⟨l, rfl⟩)
    · intro r s
      have hr : r = 0 := by omega
      have hs : s = 0 := by omega
      subst r; subst s
      simpa [c, EntryFamily.cell] using hm.2.2 i j
  obtain ⟨cell, z, hr, hz, he⟩ := familyCheck_sound model (f.cell i j) cfg
    1 1 k tol h a b c hc 0 0
  refine ⟨cell, z, ?_, ?_, he⟩
  · rw [gemm_entry] at hr ⊢
    simpa [gemmPairs, a, b, c, DenseMatrix.ofFn] using hr
  · simpa [gemmIdeal, gemmPairs, a, b, c, DenseMatrix.ofFn] using hz

theorem entryFamilyCheck_sound (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : ℚ)
    (h : entryFamilyCheck model f ws tol = true) : EntryFamilyAccurate model f tol := by
  simp only [entryFamilyCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro A B C hm i j
  exact entryFamily_cell_sound model f A B C hm i j ws[i.val][j.val] tol (h.2 i j)

theorem entryFamilyCheck_matrix_error (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : ℚ)
    (h : entryFamilyCheck model f ws tol = true)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (hm : f.Contains A B C) (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (ws.map fun row => row.map (familyError model k)) := by
  simp only [entryFamilyCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  apply matrixAbsSum_le_entry_bounds
  intro i j
  have hc := familyCheck_at_bound model k (f.cell i j) ws[i.val][j.val] tol (h.2 i j)
  obtain ⟨cell, z, hr, hi, he⟩ := entryFamily_cell_sound model f A B C hm i j ws[i.val][j.val] _ hc
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he

end TensorCore
