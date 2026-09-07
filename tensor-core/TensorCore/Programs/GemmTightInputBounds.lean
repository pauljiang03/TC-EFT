import TensorCore.Programs.GemmTightBounds
import TensorCore.Programs.GemmInputBounds

/-! Tighter original-input certificates. Two exact product-difference expansions
use the original magnitude of one operand and converted magnitude of the other;
taking their minimum avoids the old worst-case cross-term overestimate. -/

namespace TensorCore

/-- Both operand perturbations and their cross term are required. -/
def gemmInputPairTightError (a b : GemmInputDatum) : Rat :=
  min (absQ a.value * b.error + absQ b.converted * a.error)
      (absQ a.converted * b.error + absQ b.value * a.error)

def gemmInputProductTightError (source : Format) (mode : BinaryRoundingMode) :
    List (BitVec source.width × BitVec source.width) → Option Rat
  | [] => some 0
  | (a, b) :: rest => do
    let av ← gemmInputDatum source mode a
    let bv ← gemmInputDatum source mode b
    let tail ← gemmInputProductTightError source mode rest
    return gemmInputPairTightError av bv + tail

/-- Add original-input conversion loss to the existing complete pipeline budget.
This function never computes the original or converted exact dot product. -/
def convertedGemmCellTightSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (pairs : List (BitVec source.width × BitVec source.width)) : Option Rat := do
  let a ← value32 alpha
  let inputError ← gemmInputProductTightError source mode pairs
  return scaledGemmTightError model cfg b alpha pairs.length + absQ a * inputError

def convertedGemmTightSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n) :
    DenseMatrix (Option Rat) m n :=
  DenseMatrix.ofFn fun i j => convertedGemmCellTightSourceError source mode model cfg b alpha
    (sourceGemmPairs source A B i j)

theorem gemmInputPairTightError_bound (a b : GemmInputDatum) :
    absQ (a.value * b.value - a.converted * b.converted) ≤ gemmInputPairTightError a b := by
  have h1 := absQ_add_le (a.value * (b.value - b.converted))
    (b.converted * (a.value - a.converted))
  have h2 := absQ_add_le (a.converted * (b.value - b.converted))
    (b.value * (a.value - a.converted))
  rw [gemmAbs_mul, gemmAbs_mul] at h1 h2
  unfold gemmInputPairTightError GemmInputDatum.error
  have he1 : a.value * (b.value - b.converted) + b.converted * (a.value - a.converted) =
      a.value * b.value - a.converted * b.converted := by grind
  have he2 : a.converted * (b.value - b.converted) + b.value * (a.value - a.converted) =
      a.value * b.value - a.converted * b.converted := by grind
  rw [he1] at h1
  rw [he2] at h2
  rw [Rat.min_def]
  split <;> assumption

/-- The tighter perturbation budget never exceeds the previous cross-term bound. -/
theorem gemmInputPairTightError_le (a b : GemmInputDatum) :
    gemmInputPairTightError a b ≤ gemmInputPairError a b := by
  have hb := absQ_add_le b.value (b.converted - b.value)
  have hid : b.value + (b.converted - b.value) = b.converted := by grind
  rw [hid, absQ_sub_comm] at hb
  have hm := Rat.mul_le_mul_of_nonneg_right hb (absQ_nonneg (a.value - a.converted))
  unfold gemmInputPairTightError gemmInputPairError GemmInputDatum.error
  rw [Rat.min_def]
  split <;> grind

/-- Conversion perturbations compose over the actual ordered operands; the source
ideal remains independent of the conversions used to derive the bound. -/
theorem gemmInputProductTightError_bound (source : Format) (mode : BinaryRoundingMode)
    (xs : List ι) (input : ι → BitVec source.width × BitVec source.width)
    (output : ι → F16 × F16)
    (h : ∀ x ∈ xs,
      convertGemmWord source fp16 mode (input x).1 = some (output x).1 ∧
      convertGemmWord source fp16 mode (input x).2 = some (output x).2) :
    ∃ s p e, sourceGemmProducts source (xs.map input) = some s ∧
      sourceGemmProducts fp16 (xs.map output) = some p ∧
      gemmInputProductTightError source mode (xs.map input) = some e ∧ absQ (s - p) ≤ e := by
  induction xs with
  | nil => exact ⟨0, 0, 0, rfl, rfl, rfl, by decide +kernel⟩
  | cons x xs ih =>
    obtain ⟨ha, hb⟩ := h x (by simp)
    obtain ⟨a, had, hav, hac⟩ := gemmInputDatum_of_conversion source mode _ _ ha
    obtain ⟨b, hbd, hbv, hbc⟩ := gemmInputDatum_of_conversion source mode _ _ hb
    obtain ⟨s, p, e, hs, hp, he, hbnd⟩ := ih (by intro y hy; exact h y (by simp [hy]))
    refine ⟨a.value * b.value + s, a.converted * b.converted + p,
      gemmInputPairTightError a b + e, ?_, ?_, ?_, ?_⟩
    · simp [sourceGemmProducts, hav, hbv, hs]
    · simp [sourceGemmProducts, hac, hbc, hp]
    · simp [gemmInputProductTightError, had, hbd, he]
    · have ht := absQ_add_le (a.value * b.value - a.converted * b.converted) (s - p)
      have hx := gemmInputPairTightError_bound a b
      grind

theorem convertGemmInput_products_tight_error (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (a : DenseMatrix F16 m k) (b : DenseMatrix F16 k n)
    (ha : convertGemmInput source mode A = some a) (hb : convertGemmInput source mode B = some b)
    (i : Fin m) (j : Fin n) :
    ∃ s p e, sourceGemmProducts source (sourceGemmPairs source A B i j) = some s ∧
      idealProducts v100F16F32 (gemmPairs a b i j) = some p ∧
      gemmInputProductTightError source mode (sourceGemmPairs source A B i j) = some e ∧
      absQ (s - p) ≤ e := by
  have h := gemmInputProductTightError_bound source mode (List.finRange k)
    (fun l : Fin k => (A[i.val][l.val], B[l.val][j.val]))
    (fun l : Fin k => (a[i.val][l.val], b[l.val][j.val]))
    (by intro l _; exact ⟨convertGemmInput_entry source mode A a ha i l,
      convertGemmInput_entry source mode B b hb l j⟩)
  obtain ⟨s, p, e, hs, hp, he, hbound⟩ := h
  refine ⟨s, p, e, ?_, ?_, ?_, hbound⟩
  · simpa [List.finRange, List.map_ofFn, Function.comp_def, sourceGemmPairs] using hs
  · have hp' : sourceGemmProducts fp16 (gemmPairs a b i j) = some p := by
      simpa [List.finRange, List.map_ofFn, Function.comp_def, gemmPairs] using hp
    exact (sourceGemmProducts_eq_idealProducts v100F16F32 _).symm.trans hp'
  · simpa [List.finRange, List.map_ofFn, Function.comp_def, sourceGemmPairs] using he

/-- An unchanged accepted input certificate proves every output exists and bounds
its error against alpha*A*B+beta*C decoded from the original source-format words.
No successful run, exact-sum bound, or conversion-error bound is a premise. -/
theorem convertedGemmCheck_tight_source_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n)
    (h : convertedGemmCheck source mode model cfg b alpha beta A B C = true) :
    ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z E,
        D[i.val][j.val] = some t ∧ (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmTightSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E ∧
        absQ (z - t.output.value) ≤ E := by
  obtain ⟨a, b', ha, hb, hr, entries⟩ := convertedGemmCheck_tight_sound source mode model cfg b alpha beta A B C h
  refine ⟨scaledGemm model cfg alpha beta a b' C, hr, ?_⟩
  intro i j
  obtain ⟨t, z, ht, hz, he⟩ := entries i j
  obtain ⟨s, p, e, hs, hp, herr, hbound⟩ := convertGemmInput_products_tight_error source mode A B a b' ha hb i j
  simp only [scaledGemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, scaledGemmCellIdeal,
    bind, pure, Option.bind_eq_some_iff] at hz
  obtain ⟨av, hav, bv, hbv, cv, hcv, p', hp', hz⟩ := hz
  rw [hp] at hp'
  cases Option.some.inj hp'
  cases Option.some.inj hz
  refine ⟨t, av * s + bv * cv, scaledGemmTightError model cfg b alpha k + absQ av * e,
    ht, ?_, ?_, ?_⟩
  · simp [sourceGemmIdeal, DenseMatrix.ofFn, sourceGemmCellIdeal, hav, hbv, hcv, hs]
  · simp only [convertedGemmTightSourceError, DenseMatrix.ofFn, Vector.getElem_ofFn]
    simp only [convertedGemmCellTightSourceError, hav, bind, pure, Option.bind_some, herr]
    simp [sourceGemmPairs]
  · exact gemmSourceError_propagate av bv cv s p t.output.value e _ hbound he

/-- Return source-relative entry bounds exactly when the existing checker accepts.
The soundness theorem proves every selected bound is present, so getD's default
is unreachable at an accepted logical entry. No arithmetic output is substituted. -/
def convertedGemmTightSourceCertificate (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix Rat m n) :=
  if convertedGemmCheck source mode model cfg b alpha beta A B C then
    some (DenseMatrix.ofFn fun i j =>
      ((convertedGemmTightSourceError source mode model cfg b alpha A B)[i.val][j.val]).getD 0)
  else none

theorem convertedGemmTightSourceCertificate_acceptance (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemmTightSourceCertificate source mode model cfg b alpha beta A B C).isSome =
      convertedGemmCheck source mode model cfg b alpha beta A B C := by
  cases h : convertedGemmCheck source mode model cfg b alpha beta A B C <;>
    simp [convertedGemmTightSourceCertificate, h]

theorem convertedGemmTightSourceCertificate_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix Rat m n)
    (h : convertedGemmTightSourceCertificate source mode model cfg b alpha beta A B C = some E) :
    ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z,
        D[i.val][j.val] = some t ∧ (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmTightSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E[i.val][j.val] ∧
        absQ (z - t.output.value) ≤ E[i.val][j.val] := by
  cases hc : convertedGemmCheck source mode model cfg b alpha beta A B C with
  | false => simp [convertedGemmTightSourceCertificate, hc] at h
  | true =>
    simp only [convertedGemmTightSourceCertificate, hc, ↓reduceIte] at h
    cases Option.some.inj h
    obtain ⟨D, hr, entries⟩ := convertedGemmCheck_tight_source_sound source mode model cfg b alpha beta A B C hc
    refine ⟨D, hr, ?_⟩
    intro i j
    obtain ⟨t, z, e, ht, hz, he, hbound⟩ := entries i j
    refine ⟨t, z, ht, hz, ?_, ?_⟩
    · simp only [DenseMatrix.ofFn, Vector.getElem_ofFn, he, Option.getD_some]
    · simpa only [DenseMatrix.ofFn, Vector.getElem_ofFn, he, Option.getD_some] using hbound

/-- Input-only acceptance proves the entrywise 1-norm guarantee against the
original source ideal. The projection premises merely identify decoded matrices;
neither successful execution nor an accuracy bound is assumed. -/
theorem convertedGemmTightSourceCertificate_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix Rat m n)
    (h : convertedGemmTightSourceCertificate source mode model cfg b alpha beta A B C = some E)
    (D Z : DenseMatrix Rat m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum E := by
  obtain ⟨out, hr, entries⟩ := convertedGemmTightSourceCertificate_sound source mode model cfg b alpha beta A B C E h
  apply matrixAbsSum_le_entry_bounds
  intro i j
  obtain ⟨t, z, ht, hi, _, he⟩ := entries i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa only [DenseMatrix.ofFn, Vector.getElem_ofFn, hd out hr i j t ht] using he

end TensorCore
