# TensorCore.Gemm.TightBounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4a9245fa85e7d15b"></a>

<details>
<summary><code>TensorCore.sum_four_le</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L8)

```lean
private theorem sum_four_le (a b c d A B C D : ℚ)
    (ha : a ≤ A) (hb : b ≤ B) (hc : c ≤ C) (hd : d ≤ D) :
    a + b + c + d ≤ A + B + C + D := by grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

</details>

</details>

<a id="decl-0f32a9163e5eb52b"></a>

<details>
<summary><code>TensorCore.scaledGemmTightScalarBudget</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L12)

```lean
def scaledGemmTightScalarBudget (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) : ℚ :=
  gemmConversionModeError cfg.multiplyStage b.alphaScale + gemmConversionModeError cfg.multiplyStage b.betaScale +
  gemmConversionModeError cfg.addStage b.sumScale + gemmConversionModeError cfg.output b.outputScale
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261)

<details>
<summary>Used by</summary>

[TensorCore.Regression.tight_source_budget](../Regression/FoundationCompletion.md#decl-24341707319a2042), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

</details>

</details>

<a id="decl-4ac591737d634082"></a>

<details>
<summary><code>TensorCore.scaledGemmTightError</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L16)

```lean
def scaledGemmTightError (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha : F32) (k : ℕ) : ℚ :=
  absQ ((value32 alpha).getD 0) * gemmStaticError model b.raw k + scaledGemmTightScalarBudget cfg b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.convertedGemmCellTightSourceError](TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf)

</details>

</details>

<a id="decl-bc3fbfa7854946f6"></a>

<details>
<summary><code>TensorCore.scaledGemmCellCheck_tight_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L20)

```lean
theorem scaledGemmCellCheck_tight_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta c : F32) (pairs : List (F16 × F16))
    (h : scaledGemmCellCheck model cfg b alpha beta c pairs = true) :
    ∃ product t z, simulateGemmCell model pairs 0 = .ok product ∧
      gemmEpilogue cfg alpha beta c product = some t ∧
      scaledGemmCellIdeal alpha beta c pairs = some z ∧
      absQ (z - t.output.value) ≤ scaledGemmTightError model cfg b alpha pairs.length := by
  simp only [scaledGemmCellCheck, Bool.and_eq_true] at h
  obtain ⟨⟨hraw, hvalid⟩, hc⟩ := h
  simp only [ScaledGemmBoundConfig.valid, decide_eq_true_eq] at hvalid
  obtain ⟨hf, hAE, hAM, hBE, hBM, hSE, hSM, hOE, hOM⟩ := hvalid
  cases ha : value32 alpha with
  | none => simp [ha] at hc
  | some a =>
    cases hb : value32 beta with
    | none => simp [ha, hb] at hc
    | some betaVal =>
      cases hcv : value32 c with
      | none => simp [ha, hb, hcv] at hc
      | some cv =>
        simp only [ha, hb, hcv, decide_eq_true_eq] at hc
        obtain ⟨ac, hac, _, hav⟩ := finite32_of_value32 alpha a ha
        obtain ⟨bc, hbc, _, hbv⟩ := finite32_of_value32 beta betaVal hb
        obtain ⟨cc, hcc, _, hccv⟩ := finite32_of_value32 c cv hcv
        obtain ⟨product, p, hp, hi, he, hm⟩ := gemmCellCheck_product_bound model b.raw pairs hraw
        have ham : absQ (ac.value * product.output.value) ≤ pow2 b.alphaScale := by
          rw [gemmAbs_mul, hav]
          have ht := Rat.mul_le_mul_of_nonneg_left hm (absQ_nonneg a)
          exact Rat.le_trans ht hc.1
        have hbm : absQ (bc.value * cc.value) ≤ pow2 b.betaScale := by
          simpa [gemmAbs_mul, hbv, hccv] using hc.2.1
        obtain ⟨ad, had, hade, hadm⟩ := gemmConversion_bounded cfg.multiplyStage b.alphaScale
          (by change fp32.WellFormed; decide) hAE hAM _ ham
        obtain ⟨bd, hbd, hbde, hbdm⟩ := gemmConversion_bounded cfg.multiplyStage b.betaScale
          (by change fp32.WellFormed; decide) hBE hBM _ hbm
        have hsm : absQ (ad.value + bd.value) ≤ pow2 b.sumScale := by
          have ht := absQ_add_le ad.value bd.value
          have hh := hc.2.2.1
          change absQ ad.value ≤ pow2 b.alphaScale + gemmConversionError fp32 b.alphaScale at hadm
          change absQ bd.value ≤ pow2 b.betaScale + gemmConversionError fp32 b.betaScale at hbdm
          grind
        obtain ⟨sd, hsd, hsde, hsdm⟩ := gemmConversion_bounded cfg.addStage b.sumScale
          (by change fp32.WellFormed; decide) hSE hSM _ hsm
        have hom : absQ sd.value ≤ pow2 b.outputScale := Rat.le_trans hsdm hc.2.2.2
        obtain ⟨out, hout, houte, _⟩ := gemmConversion_bounded cfg.output b.outputScale hf hOE hOM _ hom
        let t : ScaledGemmCell cfg := ⟨product, ac, bc, cc, ad, bd, sd, out⟩
        have hade := gemmConversion_mode_error cfg.multiplyStage b.alphaScale hAE _ ham ad had
        have hbde := gemmConversion_mode_error cfg.multiplyStage b.betaScale hBE _ hbm bd hbd
        have hsde := gemmConversion_mode_error cfg.addStage b.sumScale hSE _ hsm sd hsd
        have houte := gemmConversion_mode_error cfg.output b.outputScale hOE _ hom out hout
        have hscalar : t.scalarError ≤ scaledGemmTightScalarBudget cfg b :=
          sum_four_le _ _ _ _ _ _ _ _ hade hbde hsde houte
        have hfinal := t.propagate p (gemmStaticError model b.raw pairs.length) he
        refine ⟨product, t, a * p + betaVal * cv, hp, ?_, ?_, ?_⟩
        · simp [gemmEpilogue, hac, hbc, hcc, had, hbd, hsd, hout, t]
        · simp [scaledGemmCellIdeal, ha, hb, hcv, hi]
        · have hh : absQ a * gemmStaticError model b.raw pairs.length + t.scalarError ≤
              absQ a * gemmStaticError model b.raw pairs.length + scaledGemmTightScalarBudget cfg b := by grind
          change absQ (ac.value * p + bc.value * cc.value - out.value) ≤
            absQ ac.value * gemmStaticError model b.raw pairs.length + t.scalarError at hfinal
          rw [hav, hbv, hccv] at hfinal
          have := Rat.le_trans hfinal hh
          simpa [scaledGemmTightError, ha] using this
```

**Supporting proofs:** [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.gemmAbs_mul](ScaledGemm.md#decl-be05cc60206155ae), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmConversion_bounded](ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_mode_error](RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.sum_four_le](TightBounds.md#decl-4a9245fa85e7d15b)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmBoundConfig.valid](ScaledGemmBounds.md#decl-7446bfd9bf9ae59b), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510)

</details>

</details>

<a id="decl-9356e64e4f80c510"></a>

<details>
<summary><code>TensorCore.scaledGemmCheck_tight_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L83)

```lean
theorem scaledGemmCheck_tight_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : scaledGemmCheck model cfg b alpha beta A B C = true) (i : Fin m) (j : Fin n) :
    ∃ t z, (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t ∧
      (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ scaledGemmTightError model cfg b alpha k := by
  obtain ⟨product, t, z, hp, ht, hi, he⟩ := scaledGemmCellCheck_tight_sound model cfg b alpha beta _ _
    (of_decide_eq_true h i j)
  refine ⟨t, z, ?_, ?_, ?_⟩
  · simp only [scaledGemm, DenseMatrix.ofFn, Vector.getElem_ofFn, gemm_entry]
    change ((simulateGemmCell model (gemmPairs A B i j) (0 : F32)).toOption.bind
      fun product => gemmEpilogue cfg alpha beta C[i.val][j.val] product) = some t
    rw [hp]
    exact ht
  · simpa [scaledGemmIdeal, DenseMatrix.ofFn] using hi
  · simpa using he
```

**Supporting proofs:** [TensorCore.gemmPairs_length](Defs.md#decl-5e4e68c0669cd541), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed)

</details>

</details>

<a id="decl-b6171e34311f79ed"></a>

<details>
<summary><code>TensorCore.scaledGemmCheck_tight_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L101)

```lean
theorem scaledGemmCheck_tight_matrix_error (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : scaledGemmCheck model cfg b alpha beta A B C = true) (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ t,
      (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * scaledGemmTightError model cfg b alpha k := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨t, z, hr, hi, he⟩ := scaledGemmCheck_tight_sound model cfg b alpha beta A B C h i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j t hr] using he
```

**Supporting proofs:** [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bda461b71c4f083d"></a>

<details>
<summary><code>TensorCore.convertedGemmCheck_tight_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L117)

```lean
theorem convertedGemmCheck_tight_sound (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n)
    (h : convertedGemmCheck source inputMode model cfg b alpha beta A B C = true) :
    ∃ a b', convertGemmInput source inputMode A = some a ∧
      convertGemmInput source inputMode B = some b' ∧
      convertedGemm source inputMode model cfg alpha beta A B C =
        some (scaledGemm model cfg alpha beta a b' C) ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z,
        (scaledGemm model cfg alpha beta a b' C)[i.val][j.val] = some t ∧
        (scaledGemmIdeal alpha beta a b' C)[i.val][j.val] = some z ∧
        absQ (z - t.output.value) ≤ scaledGemmTightError model cfg b alpha k := by
  cases ha : convertGemmInput source inputMode A with
  | none => simp [convertedGemmCheck, ha] at h
  | some a =>
    cases hb : convertGemmInput source inputMode B with
    | none => simp [convertedGemmCheck, ha, hb] at h
    | some b' =>
      simp only [convertedGemmCheck, ha, hb] at h
      refine ⟨a, b', rfl, rfl, ?_, fun i j => scaledGemmCheck_tight_sound model cfg b alpha beta a b' C h i j⟩
      simp [convertedGemm, ha, hb]
```

**Supporting proofs:** [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58)

</details>

</details>

<a id="decl-e47a9cfbc68a88aa"></a>

<details>
<summary><code>TensorCore.scaledGemmTightScalarBudget_le</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L141)

```lean
/-- The new scalar budget is never larger, for any mixture of rounding modes. -/
theorem scaledGemmTightScalarBudget_le (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) :
    scaledGemmTightScalarBudget cfg b ≤ scaledGemmScalarBudget cfg b :=
  sum_four_le _ _ _ _ _ _ _ _ (gemmConversionModeError_le cfg.multiplyStage _)
    (gemmConversionModeError_le cfg.multiplyStage _) (gemmConversionModeError_le cfg.addStage _)
    (gemmConversionModeError_le cfg.output _)
```

**Supporting proofs:** [TensorCore.gemmConversionModeError_le](RoundingBudget.md#decl-a884460a8acd89fe), [TensorCore.sum_four_le](TightBounds.md#decl-4a9245fa85e7d15b)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmConversionModeError](RoundingBudget.md#decl-426ed137365dd261), [TensorCore.scaledGemmScalarBudget](ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf)

</details>

</details>

<a id="decl-75e41d5600ed7daf"></a>

<details>
<summary><code>TensorCore.scaledGemmTightError_le</code></summary>

[Lean source](../../../TensorCore/Gemm/TightBounds.lean#L147)

```lean
theorem scaledGemmTightError_le (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha : F32) (k : ℕ) :
    scaledGemmTightError model cfg b alpha k ≤ scaledGemmStaticError model cfg b alpha k := by
  have := scaledGemmTightScalarBudget_le cfg b
  unfold scaledGemmTightError scaledGemmStaticError
  grind
```

**Supporting proofs:** [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.scaledGemmScalarBudget](ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
