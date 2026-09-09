# TensorCore.Gemm.TightInputBounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-1a5881f86db47f83"></a>

<details>
<summary><code>TensorCore.gemmInputPairTightError</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L11)

```lean
/-- Both operand perturbations and their cross term are required. -/
def gemmInputPairTightError (a b : GemmInputDatum) : ℚ :=
  min (absQ a.value * b.error + absQ b.converted * a.error)
      (absQ a.converted * b.error + absQ b.value * a.error)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.GemmInputDatum.error](InputBounds.md#decl-8d5afe3c429da546), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

<details>
<summary>Used by</summary>

[TensorCore.gemmInputPairTightError_bound](TightInputBounds.md#decl-251c676d4c121cd6), [TensorCore.gemmInputPairTightError_le](TightInputBounds.md#decl-8ffbd0992c010ee1), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b)

</details>

</details>

<a id="decl-c19657b0f9cb6d37"></a>

<details>
<summary><code>TensorCore.gemmInputProductTightError</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L15)

```lean
def gemmInputProductTightError (source : Format) (mode : BinaryRoundingMode) :
    List (BitVec source.width × BitVec source.width) → Option ℚ
  | [] => some 0
  | (a, b) :: rest => do
    let av ← gemmInputDatum source mode a
    let bv ← gemmInputDatum source mode b
    let tail ← gemmInputProductTightError source mode rest
    return gemmInputPairTightError av bv + tail
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.gemmInputDatum](InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83)

<details>
<summary>Used by</summary>

[TensorCore.Regression.tight_input_edges](../Regression/FoundationCompletion.md#decl-d874c31dcab129cf), [TensorCore.analyzeConvertedGemm_checked](ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.checkConvertedCell](ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertedGemmCellTightSourceError](TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.sourceAnalysisCell](ConvertedGemmAnalysis.md#decl-9df6da962c5020b7)

</details>

</details>

<a id="decl-c868505bc89fc75a"></a>

<details>
<summary><code>TensorCore.convertedGemmCellTightSourceError</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L26)

```lean
/-- Add original-input conversion loss to the existing complete pipeline budget.
This function never computes the original or converted exact dot product. -/
def convertedGemmCellTightSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (pairs : List (BitVec source.width × BitVec source.width)) : Option ℚ := do
  let a ← value32 alpha
  let inputError ← gemmInputProductTightError source mode pairs
  return scaledGemmTightError model cfg b alpha pairs.length + absQ a * inputError
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e)

</details>

</details>

<a id="decl-2ff467215e0b779e"></a>

<details>
<summary><code>TensorCore.convertedGemmTightSourceError</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L33)

```lean
def convertedGemmTightSourceError (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n) :
    DenseMatrix (Option ℚ) m n :=
  DenseMatrix.ofFn fun i j => convertedGemmCellTightSourceError source mode model cfg b alpha
    (sourceGemmPairs source A B i j)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmCellTightSourceError](TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceCertificate_acceptance](TightInputBounds.md#decl-533bbea7ddad7c67), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d)

</details>

</details>

<a id="decl-251c676d4c121cd6"></a>

<details>
<summary><code>TensorCore.gemmInputPairTightError_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L40)

```lean
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
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.gemmAbs_mul](ScaledGemm.md#decl-be05cc60206155ae)

**Definitions and types:** [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.GemmInputDatum.error](InputBounds.md#decl-8d5afe3c429da546), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b)

</details>

</details>

<a id="decl-8ffbd0992c010ee1"></a>

<details>
<summary><code>TensorCore.gemmInputPairTightError_le</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L58)

```lean
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
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.absQ_sub_comm](../Core/Exact.md#decl-a632fad01d9c884a)

**Definitions and types:** [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.GemmInputDatum.error](InputBounds.md#decl-8d5afe3c429da546), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmInputPairError](InputBounds.md#decl-85a247fb58310475), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-94b8603bf720f7d2"></a>

<details>
<summary><code>TensorCore.gemmInputProductTightError_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L70)

```lean
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
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.gemmInputDatum_of_conversion](InputBounds.md#decl-63322710811f0233), [TensorCore.gemmInputPairTightError_bound](TightInputBounds.md#decl-251c676d4c121cd6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.gemmInputDatum](InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c)

</details>

</details>

<a id="decl-b437c54d5d208f5c"></a>

<details>
<summary><code>TensorCore.convertGemmInput_products_tight_error</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L95)

```lean
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
```

**Supporting proofs:** [TensorCore.convertGemmInput_entry](ScaledGemm.md#decl-fa0fab71bf8fc712), [TensorCore.gemmInputProductTightError_bound](TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.sourceGemmProducts_eq_idealProducts](InputBounds.md#decl-1c676a2d69d32e7d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkConvertedCell_sound](ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58)

</details>

</details>

<a id="decl-c7ecc23878e71c58"></a>

<details>
<summary><code>TensorCore.convertedGemmCheck_tight_source_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L120)

```lean
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
```

**Supporting proofs:** [TensorCore.convertGemmInput_products_tight_error](TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.gemmSourceError_propagate](InputBounds.md#decl-7a3b7a6efc84a1d7), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCellTightSourceError](TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e), [TensorCore.gemmInputProductTightError](TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.sourceGemmCellIdeal](InputBounds.md#decl-24f836f23596682e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d)

</details>

</details>

<a id="decl-08f2144e6c98b276"></a>

<details>
<summary><code>TensorCore.convertedGemmTightSourceCertificate</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L152)

```lean
/-- Return source-relative entry bounds exactly when the existing checker accepts.
The soundness theorem proves every selected bound is present, so getD's default
is unreachable at an accepted logical entry. No arithmetic output is substituted. -/
def convertedGemmTightSourceCertificate (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Option (DenseMatrix ℚ m n) :=
  if convertedGemmCheck source mode model cfg b alpha beta A B C then
    some (DenseMatrix.ofFn fun i j =>
      ((convertedGemmTightSourceError source mode model cfg b alpha A B)[i.val][j.val]).getD 0)
  else none
```

**Supporting proofs:** [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Regression.tight_source_budget](../Regression/FoundationCompletion.md#decl-24341707319a2042), [TensorCore.convertedGemmTightSourceCertificate_acceptance](TightInputBounds.md#decl-533bbea7ddad7c67), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d)

</details>

</details>

<a id="decl-533bbea7ddad7c67"></a>

<details>
<summary><code>TensorCore.convertedGemmTightSourceCertificate_acceptance</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L161)

```lean
theorem convertedGemmTightSourceCertificate_acceptance (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (convertedGemmTightSourceCertificate source mode model cfg b alpha beta A B C).isSome =
      convertedGemmCheck source mode model cfg b alpha beta A B C := by
  cases h : convertedGemmCheck source mode model cfg b alpha beta A B C <;>
    simp [convertedGemmTightSourceCertificate, h]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9670e739c545855d"></a>

<details>
<summary><code>TensorCore.convertedGemmTightSourceCertificate_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L170)

```lean
theorem convertedGemmTightSourceCertificate_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix ℚ m n)
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
```

**Supporting proofs:** [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09)

</details>

</details>

<a id="decl-e90fa532540a8a09"></a>

<details>
<summary><code>TensorCore.convertedGemmTightSourceCertificate_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/TightInputBounds.lean#L196)

```lean
/-- Input-only acceptance proves the entrywise 1-norm guarantee against the
original source ideal. The projection premises merely identify decoded matrices;
neither successful execution nor an accuracy bound is assumed. -/
theorem convertedGemmTightSourceCertificate_matrix_error (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) (E : DenseMatrix ℚ m n)
    (h : convertedGemmTightSourceCertificate source mode model cfg b alpha beta A B C = some E)
    (D Z : DenseMatrix ℚ m n)
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
```

**Supporting proofs:** [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.sourceGemmIdeal](InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
