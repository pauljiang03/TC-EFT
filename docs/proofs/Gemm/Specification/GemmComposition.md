# TensorCore.Gemm.Specification.GemmComposition

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-c38284ec00ab1c53"></a>

<details>
<summary><code>TensorCore.PaperSpec.ScalarContract</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L13)

```lean
/-- Mathematical scalar contract, with range and zero-sign policy explicit. -/
def ScalarContract (stage : ConversionStage) (x : ℚ) (b : BitVec stage.format.width) : Prop :=
  stage.format.WellFormed ∧ absQ x ≤ stage.format.maxFinite ∧
    GemmRounded stage x b ∧ binarySign stage.format b = decide (x < 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmRounded](../ScaledGemm.md#decl-601fdad850a94274), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binarySign](../../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.EpilogueContract](GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.InputConversionContract](GemmComposition.md#decl-8e4b3aa57a1c71a3), [TensorCore.PaperSpec.epilogue_contract](GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.input_conversion_contract](GemmComposition.md#decl-ac7f025391a91852), [TensorCore.PaperSpec.scalar_contract](GemmComposition.md#decl-c67acc89e63ba8f4)

</details>

</details>

<a id="decl-c67acc89e63ba8f4"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalar_contract</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L17)

```lean
theorem scalar_contract (stage : ConversionStage) (x : ℚ) (d : FiniteBinary stage.format)
    (h : stage.convert x = some d) : ScalarContract stage x d.bits :=
  ⟨(conversionStage_range h).1, (conversionStage_range h).2, gemmConversion_correct stage x d h,
    roundBinary_sign stage.format stage.mode x d.bits (conversionStage_output h)⟩
```

**Supporting proofs:** [TensorCore.conversionStage_output](../../Core/Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](../../Core/Conversion.md#decl-9878d77fe9422846), [TensorCore.gemmConversion_correct](../ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.roundBinary_sign](../../Core/Binary/RoundingContract.md#decl-89538250b2c31eac)

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.GemmRounded](../ScaledGemm.md#decl-601fdad850a94274), [TensorCore.PaperSpec.ScalarContract](GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binarySign](../../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.epilogue_contract](GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.input_conversion_contract](GemmComposition.md#decl-ac7f025391a91852)

</details>

</details>

<a id="decl-4ca3d97c3fa1daf2"></a>

<details>
<summary><code>TensorCore.PaperSpec.EpilogueContract</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L22)

```lean
def EpilogueContract (cfg : GemmEpilogue) (alpha beta c : F32) (t : ScaledGemmCell cfg) : Prop :=
  value32 alpha = some t.alpha.value ∧ value32 beta = some t.beta.value ∧
    value32 c = some t.c.value ∧
    ScalarContract cfg.multiplyStage (t.alpha.value * t.product.output.value) t.scaledProduct.bits ∧
    ScalarContract cfg.multiplyStage (t.beta.value * t.c.value) t.scaledC.bits ∧
    ScalarContract cfg.addStage (t.scaledProduct.value + t.scaledC.value) t.sum.bits ∧
    ScalarContract cfg.output t.sum.value t.output.bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](../ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](../ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.PaperSpec.ScalarContract](GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.epilogue_contract](GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958)

</details>

</details>

<a id="decl-0314f033539b5450"></a>

<details>
<summary><code>TensorCore.PaperSpec.epilogue_contract</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L30)

```lean
theorem epilogue_contract (cfg : GemmEpilogue) (alpha beta c : F32) (product : GemmCell)
    (t : ScaledGemmCell cfg) (h : gemmEpilogue cfg alpha beta c product = some t) :
    EpilogueContract cfg alpha beta c t := by
  obtain ⟨hp, ha, hb, hc, had, hbc, hs, ho⟩ := gemmEpilogue_spec cfg alpha beta c product t h
  refine ⟨?_, ?_, ?_, ?_, scalar_contract _ _ _ hbc,
    scalar_contract _ _ _ hs, scalar_contract _ _ _ ho⟩
  · rw [matrix_value32_finite, ha]; rfl
  · rw [matrix_value32_finite, hb]; rfl
  · rw [matrix_value32_finite, hc]; rfl
  · rw [hp]
    exact scalar_contract _ _ _ had
```

**Supporting proofs:** [TensorCore.PaperSpec.matrix_value32_finite](GemmEquivalence.md#decl-9ce8d5ea689e94d1), [TensorCore.PaperSpec.scalar_contract](GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.gemmEpilogue_spec](../ScaledGemm.md#decl-6abb69dd837ac6d2)

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](../ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](../ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.PaperSpec.EpilogueContract](GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.ScalarContract](GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.PaperSpec.value32](../../TC/Specification/Defs.md#decl-bb0f9e183270ad3e), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmEpilogue](../ScaledGemm.md#decl-830c6be1cd273929)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c)

</details>

</details>

<a id="decl-5aa9310ef5d2311c"></a>

<details>
<summary><code>TensorCore.PaperSpec.scaledGemm_paper_contract</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L44)

```lean
/-- Every successful scaled entry has the independent paper matrix product trace
and the four specified scalar-rounding stages, all in their finite domains. -/
theorem scaledGemm_paper_contract (model : WmmaGemmModel) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (i : Fin m) (j : Fin n) (t : ScaledGemmCell cfg)
    (h : (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t) :
    (wmmaGemm (wmmaModel model) A B (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] =
      some (gemmCellObservation t.product) ∧
    t.product.initial.bits = 0 ∧ EpilogueContract cfg alpha beta C[i.val][j.val] t := by
  obtain ⟨product, hr, he⟩ := scaledGemm_entry model cfg alpha beta A B C i j t h
  have hp := (gemmEpilogue_spec cfg alpha beta _ product t he).1
  refine ⟨?_, ?_, epilogue_contract _ _ _ _ _ _ he⟩
  · apply (gemm_entry_eq_paper_iff _ _ _ _ i j _).2
    refine ⟨product, ?_, by rw [hp]⟩
    simpa only [gemm_entry, DenseMatrix.ofFn, Vector.getElem_ofFn] using hr
  · rw [hp]
    exact finite32_bits (simulateGemmCell_spec _ _ _ _ hr).1
```

**Supporting proofs:** [TensorCore.PaperSpec.epilogue_contract](GemmComposition.md#decl-0314f033539b5450), [TensorCore.PaperSpec.gemm_entry_eq_paper_iff](GemmEquivalence.md#decl-c3ea9f4e462f6e60), [TensorCore.finite32_bits](../../TC/Program/Defs.md#decl-08ec57f1c290b572), [TensorCore.gemmEpilogue_spec](../ScaledGemm.md#decl-6abb69dd837ac6d2), [TensorCore.gemm_entry](../Defs.md#decl-e24588ca0d6e9549), [TensorCore.scaledGemm_entry](../ScaledGemm.md#decl-438d50a92caf24c7), [TensorCore.simulateGemmCell_spec](../Defs.md#decl-73d76a7ad6000a87)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](../ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](../ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.EpilogueContract](GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](../Defs.md#decl-860954743cbdf9bb), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmEpilogue](../ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmInstructions](../Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmPairs](../Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.runGemmInstructions](../Defs.md#decl-fa58899497fedd29), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.simulateGemmCell](../Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.InputConversionContract](GemmComposition.md#decl-8e4b3aa57a1c71a3), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94)

</details>

</details>

<a id="decl-8e4b3aa57a1c71a3"></a>

<details>
<summary><code>TensorCore.PaperSpec.InputConversionContract</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L60)

```lean
def InputConversionContract (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix F16 m n) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ x, binaryValue source A[i.val][j.val] = some x ∧
    ScalarContract ⟨fp16, mode⟩ x B[i.val][j.val]
```

**Supporting proofs:** [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.ScalarContract](GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.input_conversion_contract](GemmComposition.md#decl-ac7f025391a91852), [TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958)

</details>

</details>

<a id="decl-ac7f025391a91852"></a>

<details>
<summary><code>TensorCore.PaperSpec.input_conversion_contract</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L65)

```lean
theorem input_conversion_contract (source : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix F16 m n)
    (h : convertGemmInput source mode A = some B) : InputConversionContract source mode A B := by
  intro i j
  have hc := convertGemmInput_entry source mode A B h i j
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at hc
  obtain ⟨x, hx, y, hy, he⟩ := hc
  refine ⟨x, hx, ?_⟩
  rw [← Option.some.inj he]
  exact scalar_contract _ _ _ hy
```

**Supporting proofs:** [TensorCore.PaperSpec.scalar_contract](GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.convertGemmInput_entry](../ScaledGemm.md#decl-fa0fab71bf8fc712)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.InputConversionContract](GemmComposition.md#decl-8e4b3aa57a1c71a3), [TensorCore.PaperSpec.ScalarContract](GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertGemmWord](../ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemmCheck_paper_sound](GemmComposition.md#decl-463c7ce44999fc94)

</details>

</details>

<a id="decl-463c7ce44999fc94"></a>

<details>
<summary><code>TensorCore.PaperSpec.convertedGemmCheck_paper_sound</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/GemmComposition.lean#L79)

```lean
/-- A single accepted input-only certificate supplies the complete matrix contract:
input conversion, independent tensor-core traces, scalar stages, successful outputs,
and error against the original source words. No run-success or accuracy premise. -/
theorem convertedGemmCheck_paper_sound (source : Format) (mode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n)
    (h : convertedGemmCheck source mode model cfg b alpha beta A B C = true) :
    ∃ a b' D, convertGemmInput source mode A = some a ∧ convertGemmInput source mode B = some b' ∧
      InputConversionContract source mode A a ∧ InputConversionContract source mode B b' ∧
      convertedGemm source mode model cfg alpha beta A B C = some D ∧
      ∀ i : Fin m, ∀ j : Fin n, ∃ t z E, D[i.val][j.val] = some t ∧
        (sourceGemmIdeal source alpha beta A B C)[i.val][j.val] = some z ∧
        (convertedGemmSourceError source mode model cfg b alpha A B)[i.val][j.val] = some E ∧
        absQ (z - t.output.value) ≤ E ∧
        (wmmaGemm (wmmaModel model) a b' (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] =
          some (gemmCellObservation t.product) ∧
        t.product.initial.bits = 0 ∧ EpilogueContract cfg alpha beta C[i.val][j.val] t := by
  obtain ⟨a, b', ha, hb, run, _⟩ := convertedGemmCheck_sound source mode model cfg b alpha beta A B C h
  obtain ⟨D, hd, entries⟩ := convertedGemmCheck_source_sound source mode model cfg b alpha beta A B C h
  have heq := Option.some.inj (run.symm.trans hd)
  subst D
  refine ⟨a, b', _, ha, hb, input_conversion_contract _ _ _ _ ha,
    input_conversion_contract _ _ _ _ hb, run, ?_⟩
  intro i j
  obtain ⟨t, z, E, ht, hz, he, hbound⟩ := entries i j
  exact ⟨t, z, E, ht, hz, he, hbound, scaledGemm_paper_contract _ _ _ _ _ _ _ i j t ht⟩
```

**Supporting proofs:** [TensorCore.PaperSpec.input_conversion_contract](GemmComposition.md#decl-ac7f025391a91852), [TensorCore.PaperSpec.scaledGemm_paper_contract](GemmComposition.md#decl-5aa9310ef5d2311c), [TensorCore.convertedGemmCheck_sound](../ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](../InputBounds.md#decl-82c7f6139915a514)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.EpilogueContract](GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.InputConversionContract](GemmComposition.md#decl-8e4b3aa57a1c71a3), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.ScaledGemmBoundConfig](../ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](../ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck](../ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmSourceError](../InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck](../ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](../ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmStaticError](../ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.sourceGemmIdeal](../InputBounds.md#decl-f22289384470bd38), [TensorCore.sourceGemmPairs](../InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_source_certificate](../Regression/GemmSpecification.md#decl-718309cb9b0ed958)

</details>

</details>
