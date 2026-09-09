import TensorCore.Gemm.ScaledGemmBounds

/-! Error relative to the original source-format matrices. Input deviations are
computed from decoding and conversion alone; no tensor-core result, epilogue,
or exact dot product is used in the error certificate. Acceptance is the existing
convertedGemmCheck, including its finite-domain and empty-matrix conventions. -/

namespace TensorCore

/-- The original row/column operands, before any input conversion or padding. -/
def sourceGemmPairs (source : Format) (A : DenseMatrix (BitVec source.width) m k)
    (B : DenseMatrix (BitVec source.width) k n) (i : Fin m) (j : Fin n) :=
  List.ofFn fun l : Fin k => (A[i.val][l.val], B[l.val][j.val])

/-- Independent original-bit dot product: decode and sum, with no conversion. -/
def sourceGemmProducts (source : Format) : List (BitVec source.width × BitVec source.width) → Option ℚ
  | [] => some 0
  | (a, b) :: rest => do
    let av ← binaryValue source a
    let bv ← binaryValue source b
    let tail ← sourceGemmProducts source rest
    return av * bv + tail

def sourceGemmCellIdeal (source : Format) (alpha beta c : F32)
    (pairs : List (BitVec source.width × BitVec source.width)) : Option ℚ := do
  let a ← value32 alpha
  let b ← value32 beta
  let cv ← value32 c
  let p ← sourceGemmProducts source pairs
  return a * p + b * cv

def sourceGemmIdeal (source : Format) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => sourceGemmCellIdeal source alpha beta C[i.val][j.val]
    (sourceGemmPairs source A B i j)

structure GemmInputDatum where
  value : ℚ
  converted : ℚ
  deriving Repr, DecidableEq

def GemmInputDatum.error (d : GemmInputDatum) : ℚ := absQ (d.value - d.converted)

/-- Input-only information; a failed conversion remains a rejection. -/
def gemmInputDatum (source : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) : Option GemmInputDatum := do
  let x ← binaryValue source bits
  let y ← (ConversionStage.mk fp16 mode).convert x
  return ⟨x, y.value⟩

/-- Both operand perturbations and their cross term are required. -/
def gemmInputPairError (a b : GemmInputDatum) : ℚ :=
  absQ a.value * b.error + absQ b.value * a.error + a.error * b.error

def gemmInputProductError (source : Format) (mode : BinaryRoundingMode) :
    List (BitVec source.width × BitVec source.width) → Option ℚ
  | [] => some 0
  | (a, b) :: rest => do
    let av ← gemmInputDatum source mode a
    let bv ← gemmInputDatum source mode b
    let tail ← gemmInputProductError source mode rest
    return gemmInputPairError av bv + tail

/-- Add original-input conversion loss to the existing complete pipeline budget.
This function never computes the original or converted exact dot product. -/
def convertedGemmCellSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (pairs : List (BitVec source.width × BitVec source.width)) : Option ℚ := do
  let a ← value32 alpha
  let inputError ← gemmInputProductError source mode pairs
  return scaledGemmStaticError model cfg b alpha pairs.length + absQ a * inputError

def convertedGemmSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n) :
    DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => convertedGemmCellSourceError source mode model cfg b alpha
    (sourceGemmPairs source A B i j)

theorem sourceGemmProducts_eq_idealProducts (p : Profile) (xs : List (p.Word × p.Word)) :
    sourceGemmProducts p.input xs = idealProducts p xs := by
  induction xs with
  | nil => rfl
  | cons pair rest ih =>
    obtain ⟨a, b⟩ := pair
    change sourceGemmProducts p.input ((a, b) :: rest) = idealProducts p ([(a, b)] ++ rest)
    rw [idealProducts_append]
    simp only [sourceGemmProducts, ih]
    cases ha : (classify p.input a).finite <;> cases hb : (classify p.input b).finite <;>
      simp [binaryValue, idealProducts, prepareProducts, Profile.decode, ha, hb, sumQ, Rat.add_zero]

theorem gemmInputDatum_of_conversion (source : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (output : F16)
    (h : convertGemmWord source fp16 mode input = some output) :
    ∃ d, gemmInputDatum source mode input = some d ∧
      binaryValue source input = some d.value ∧ binaryValue fp16 output = some d.converted := by
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, hx, y, hy, he⟩ := h
  cases Option.some.inj he
  refine ⟨⟨x, y.value⟩, by simp [gemmInputDatum, hx, hy], hx, ?_⟩
  simp [binaryValue, y.valid, FiniteBinary.value]

/-- The data-dependent deviation also satisfies the generic grid-spacing bound
when an original-value magnitude cap is supplied, in all four input modes. -/
theorem gemmInputDatum_error_le (source : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (d : GemmInputDatum)
    (h : gemmInputDatum source mode input = some d) (E : ℤ)
    (hE : fp16.emin ≤ E) (hx : absQ d.value ≤ pow2 E) :
    d.error ≤ gemmConversionError fp16 E := by
  simp only [gemmInputDatum, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, _, y, hy, he⟩ := h
  cases Option.some.inj he
  exact gemmConversion_error ⟨fp16, mode⟩ E hE x hx y hy

theorem gemmInputPairError_bound (a b : GemmInputDatum) :
    absQ (a.value * b.value - a.converted * b.converted) ≤ gemmInputPairError a b := by
  have h1 := absQ_add_le (a.value * (b.value - b.converted))
    (b.value * (a.value - a.converted))
  have h2 := absQ_add_le
    (a.value * (b.value - b.converted) + b.value * (a.value - a.converted))
    (-((a.value - a.converted) * (b.value - b.converted)))
  rw [absQ_neg, gemmAbs_mul] at h2
  rw [gemmAbs_mul, gemmAbs_mul] at h1
  unfold gemmInputPairError GemmInputDatum.error
  grind

/-- Conversion perturbations compose over the actual ordered operands; the source
ideal remains independent of the conversions used to derive the bound. -/
theorem gemmInputProductError_bound (source : Format) (mode : BinaryRoundingMode)
    (xs : List ι) (input : ι → BitVec source.width × BitVec source.width)
    (output : ι → F16 × F16)
    (h : ∀ x ∈ xs,
      convertGemmWord source fp16 mode (input x).1 = some (output x).1 ∧
      convertGemmWord source fp16 mode (input x).2 = some (output x).2) :
    ∃ s p e, sourceGemmProducts source (xs.map input) = some s ∧
      sourceGemmProducts fp16 (xs.map output) = some p ∧
      gemmInputProductError source mode (xs.map input) = some e ∧ absQ (s - p) ≤ e := by
  induction xs with
  | nil => exact ⟨0, 0, 0, rfl, rfl, rfl, by decide +kernel⟩
  | cons x xs ih =>
    obtain ⟨ha, hb⟩ := h x (by simp)
    obtain ⟨a, had, hav, hac⟩ := gemmInputDatum_of_conversion source mode _ _ ha
    obtain ⟨b, hbd, hbv, hbc⟩ := gemmInputDatum_of_conversion source mode _ _ hb
    obtain ⟨s, p, e, hs, hp, he, hbnd⟩ := ih (by intro y hy; exact h y (by simp [hy]))
    refine ⟨a.value * b.value + s, a.converted * b.converted + p,
      gemmInputPairError a b + e, ?_, ?_, ?_, ?_⟩
    · simp [sourceGemmProducts, hav, hbv, hs]
    · simp [sourceGemmProducts, hac, hbc, hp]
    · simp [gemmInputProductError, had, hbd, he]
    · have ht := absQ_add_le (a.value * b.value - a.converted * b.converted) (s - p)
      have hx := gemmInputPairError_bound a b
      grind

theorem convertGemmInput_products_error (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (a : DenseMatrix F16 m k) (b : DenseMatrix F16 k n)
    (ha : convertGemmInput source mode A = some a) (hb : convertGemmInput source mode B = some b)
    (i : Fin m) (j : Fin n) :
    ∃ s p e, sourceGemmProducts source (sourceGemmPairs source A B i j) = some s ∧
      idealProducts v100F16F32 (gemmPairs a b i j) = some p ∧
      gemmInputProductError source mode (sourceGemmPairs source A B i j) = some e ∧
      absQ (s - p) ≤ e := by
  have h := gemmInputProductError_bound source mode (List.finRange k)
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

/-- Propagate conversion error through alpha and add the already certified
tensor-core/epilogue budget. Beta*C is unchanged by A/B input conversion. -/
theorem gemmSourceError_propagate (alpha beta c source converted output inputError E : ℚ)
    (hi : absQ (source - converted) ≤ inputError)
    (he : absQ (alpha * converted + beta * c - output) ≤ E) :
    absQ (alpha * source + beta * c - output) ≤ E + absQ alpha * inputError := by
  have hm := Rat.mul_le_mul_of_nonneg_left hi (absQ_nonneg alpha)
  rw [← gemmAbs_mul] at hm
  have ht := absQ_add_le (alpha * (source - converted))
    (alpha * converted + beta * c - output)
  grind

/-- An unchanged accepted input certificate proves every output exists and bounds
its error against alpha*A*B+beta*C decoded from the original source-format words.
No successful run, exact-sum bound, or conversion-error bound is a premise. -/
theorem convertedGemmCheck_source_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n)
    (h : convertedGemmCheck source mode model cfg b alpha beta A B C = true) :
    ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z E,
        D[i.val][j.val] = some t ∧ (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E ∧
        absQ (z - t.output.value) ≤ E := by
  obtain ⟨a, b', ha, hb, hr, entries⟩ := convertedGemmCheck_sound source mode model cfg b alpha beta A B C h
  refine ⟨scaledGemm model cfg alpha beta a b' C, hr, ?_⟩
  intro i j
  obtain ⟨t, z, ht, hz, he⟩ := entries i j
  obtain ⟨s, p, e, hs, hp, herr, hbound⟩ := convertGemmInput_products_error source mode A B a b' ha hb i j
  simp only [scaledGemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, scaledGemmCellIdeal,
    bind, pure, Option.bind_eq_some_iff] at hz
  obtain ⟨av, hav, bv, hbv, cv, hcv, p', hp', hz⟩ := hz
  rw [hp] at hp'
  cases Option.some.inj hp'
  cases Option.some.inj hz
  refine ⟨t, av * s + bv * cv, scaledGemmStaticError model cfg b alpha k + absQ av * e,
    ht, ?_, ?_, ?_⟩
  · simp [sourceGemmIdeal, DenseMatrix.ofFn, sourceGemmCellIdeal, hav, hbv, hcv, hs]
  · simp only [convertedGemmSourceError, DenseMatrix.ofFn, Vector.getElem_ofFn]
    simp only [convertedGemmCellSourceError, hav, bind, pure, Option.bind_some, herr]
    simp [sourceGemmPairs]
  · exact gemmSourceError_propagate av bv cv s p t.output.value e _ hbound he

/-- Return source-relative entry bounds exactly when the existing checker accepts.
The soundness theorem proves every selected bound is present, so getD's default
is unreachable at an accepted logical entry. No arithmetic output is substituted. -/
def convertedGemmSourceCertificate (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix ℚ m n) :=
  if convertedGemmCheck source mode model cfg b alpha beta A B C then
    some (DenseMatrix.ofFn fun i j =>
      ((convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val]).getD 0)
  else none

theorem convertedGemmSourceCertificate_acceptance (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemmSourceCertificate source mode model cfg b alpha beta A B C).isSome =
      convertedGemmCheck source mode model cfg b alpha beta A B C := by
  cases h : convertedGemmCheck source mode model cfg b alpha beta A B C <;>
    simp [convertedGemmSourceCertificate, h]

theorem convertedGemmSourceCertificate_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix ℚ m n)
    (h : convertedGemmSourceCertificate source mode model cfg b alpha beta A B C = some E) :
    ∃ D, convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z,
        D[i.val][j.val] = some t ∧ (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E[i.val][j.val] ∧
        absQ (z - t.output.value) ≤ E[i.val][j.val] := by
  cases hc : convertedGemmCheck source mode model cfg b alpha beta A B C with
  | false => simp [convertedGemmSourceCertificate, hc] at h
  | true =>
    simp only [convertedGemmSourceCertificate, hc, ↓reduceIte] at h
    cases Option.some.inj h
    obtain ⟨D, hr, entries⟩ := convertedGemmCheck_source_sound source mode model cfg b alpha beta A B C hc
    refine ⟨D, hr, ?_⟩
    intro i j
    obtain ⟨t, z, e, ht, hz, he, hbound⟩ := entries i j
    refine ⟨t, z, ht, hz, ?_, ?_⟩
    · simp only [DenseMatrix.ofFn, Vector.getElem_ofFn, he, Option.getD_some]
    · simpa only [DenseMatrix.ofFn, Vector.getElem_ofFn, he, Option.getD_some] using hbound

private theorem input_sum_mono (xs : List ι) (f g : ι → ℚ)
    (h : ∀ x ∈ xs, f x ≤ g x) : sumQ (xs.map f) ≤ sumQ (xs.map g) := by
  induction xs with
  | nil => exact Rat.le_refl
  | cons x xs ih =>
    have hh := h x (by simp)
    have ht := ih (by intro y hy; exact h y (by simp [hy]))
    simp only [List.map_cons, sumQ]
    grind

private theorem input_sumFn_mono (f g : Fin k → ℚ) (h : ∀ i, f i ≤ g i) :
    sumQ (List.ofFn f) ≤ sumQ (List.ofFn g) := by
  have hs := input_sum_mono (List.finRange k) f g (fun i _ => h i)
  simpa [List.finRange, List.map_ofFn, Function.comp_def] using hs

/-- Sum varying entry budgets, rather than multiplying by a worst-case entry. -/
theorem matrixAbsSum_le_entry_bounds (X E : DenseMatrix ℚ m n)
    (h : ∀ i : Fin m, ∀ j : Fin n, absQ X[i.val][j.val] ≤ E[i.val][j.val]) :
    matrixAbsSum X ≤ matrixAbsSum E := by
  apply input_sumFn_mono
  intro i
  apply input_sumFn_mono
  intro j
  have he : E[i.val][j.val] ≤ absQ E[i.val][j.val] :=
    ((absQ_le_iff _ _).mp Rat.le_refl).2
  exact Rat.le_trans (h i j) he

/-- Input-only acceptance proves the entrywise 1-norm guarantee against the
original source ideal. The projection premises merely identify decoded matrices;
neither successful execution nor an accuracy bound is assumed. -/
theorem convertedGemmSourceCertificate_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix ℚ m n)
    (h : convertedGemmSourceCertificate source mode model cfg b alpha beta A B C = some E)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ out, convertedGemm source mode model cfg alpha beta A B C = some out →
      ∀ i : Fin m, ∀ j : Fin n, ∀ t, out[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n,
      (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum E := by
  obtain ⟨out, hr, entries⟩ := convertedGemmSourceCertificate_sound source mode model cfg b alpha beta A B C E h
  apply matrixAbsSum_le_entry_bounds
  intro i j
  obtain ⟨t, z, ht, hi, _, he⟩ := entries i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa only [DenseMatrix.ofFn, Vector.getElem_ofFn, hd out hr i j t ht] using he

end TensorCore
