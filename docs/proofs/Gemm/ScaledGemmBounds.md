# TensorCore.Gemm.ScaledGemmBounds

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-7d11b98837ef516b"></a>

<details>
<summary><code>TensorCore.sum_four_le</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L9)

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

[TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc)

</details>

</details>

<a id="decl-6b8a518e5f4fda2f"></a>

<details>
<summary><code>TensorCore.gemmProductMagnitude</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L13)

```lean
def gemmProductMagnitude (model : WmmaGemmModel) (cfg : GemmBoundConfig) (k : ℕ) : ℚ :=
  (gemmBlockCount model k : ℚ) * ((model.path.products : ℚ) * (4 * pow2 cfg.productScale))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

</details>

</details>

<a id="decl-53971d1e0a79bd4b"></a>

<details>
<summary><code>TensorCore.gemmCellCheck_product_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L16)

```lean
theorem gemmCellCheck_product_bound (model : WmmaGemmModel) (cfg : GemmBoundConfig)
    (pairs : List (F16 × F16)) (h : gemmCellCheck model cfg pairs 0 = true) :
    ∃ cell p, simulateGemmCell model pairs 0 = .ok cell ∧
      idealProducts v100F16F32 pairs = some p ∧
      absQ (p - cell.output.value) ≤ gemmStaticError model cfg pairs.length ∧
      absQ cell.output.value ≤ gemmProductMagnitude model cfg pairs.length +
        gemmStaticError model cfg pairs.length := by
  obtain ⟨cell, p, hr, hp, hc, he⟩ := gemmCellCheck_sound model cfg pairs 0 h
  have hzero : cell.initial.value = 0 := by
    have hz : value32 0 = some 0 := by decide +kernel
    rw [hz] at hc
    exact (Option.some.inj hc).symm
  simp only [hzero, Rat.zero_add] at he
  have hs : (gemmBlocks model pairs).all (groupScaleCheck model.path.profile cfg.productScale) = true := by
    simp only [gemmCellCheck, Bool.and_eq_true] at h
    exact h.1.2
  have hi : idealContributions model.path.profile (gemmBlocks model pairs) = some p := by
    rwa [gemmBlocks_ideal]
  have hm := idealContributions_abs_le model.path.profile (gemmBlocks model pairs)
    ((model.path.products : ℚ) * (4 * pow2 cfg.productScale)) (by
      intro g hg z hz
      have hb := idealProducts_abs_le_of_scale model.path.profile g cfg.productScale
        (groupScaleCheck_sound _ _ _ (List.all_eq_true.mp hs g hg)) z hz
      simpa only [gemmBlocks_shape model pairs g hg] using hb) p hi
  rw [gemmBlocks_count] at hm
  have ha := absQ_add_le p (cell.output.value - p)
  rw [absQ_sub_comm cell.output.value p] at ha
  have hid : p + (cell.output.value - p) = cell.output.value := by grind
  rw [hid] at ha
  refine ⟨cell, p, hr, hp, he, ?_⟩
  unfold gemmProductMagnitude
  grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_sub_comm](../Core/Exact.md#decl-a632fad01d9c884a), [TensorCore.gemmBlocks_count](Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_shape](Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck_sound](Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.groupScaleCheck_sound](../TC/Program/StaticCertificate.md#decl-5583db47fae0681c), [TensorCore.idealContributions_abs_le](../TC/Program/Bounds/Scales.md#decl-d642c7a05f1cb663), [TensorCore.idealProducts_abs_le_of_scale](../TC/Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a)

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.groupScaleCheck](../TC/Program/StaticCertificate.md#decl-66820a4a9870af93), [TensorCore.idealContributions](../TC/Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

</details>

</details>

<a id="decl-ed7a52391e93046c"></a>

<details>
<summary><code>TensorCore.ScaledGemmBoundConfig</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L49)

```lean
structure ScaledGemmBoundConfig where
  raw : GemmBoundConfig
  alphaScale : ℤ
  betaScale : ℤ
  sumScale : ℤ
  outputScale : ℤ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.Regression.scaled_certificate_rejects_stages](Regression/GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.smallScaledGemmBounds](Regression/GemmExtensions.md#decl-63eb6d51249fb461), [TensorCore.Regression.sourceGemmBounds](Regression/GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.ScaledGemmBoundConfig.valid](ScaledGemmBounds.md#decl-7446bfd9bf9ae59b), [TensorCore.convertedGemmCellSourceError](InputBounds.md#decl-c6688c492e9e6923), [TensorCore.convertedGemmCellTightSourceError](TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceCertificate_acceptance](InputBounds.md#decl-65084421def64cb7), [TensorCore.convertedGemmSourceCertificate_matrix_error](InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmSourceError](InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceCertificate_acceptance](TightInputBounds.md#decl-533bbea7ddad7c67), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d), [TensorCore.convertedGemmTightSourceError](TightInputBounds.md#decl-2ff467215e0b779e), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmScalarBudget](ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError](TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf), [TensorCore.scaledGemmTightScalarBudget](TightBounds.md#decl-0f32a9163e5eb52b), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

</details>

</details>

<a id="decl-7446bfd9bf9ae59b"></a>

<details>
<summary><code>TensorCore.ScaledGemmBoundConfig.valid</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L57)

```lean
def ScaledGemmBoundConfig.valid (b : ScaledGemmBoundConfig) (cfg : GemmEpilogue) : Bool :=
  decide (cfg.output.format.WellFormed ∧
    fp32.emin ≤ b.alphaScale ∧ pow2 b.alphaScale ≤ fp32.maxFinite ∧
    fp32.emin ≤ b.betaScale ∧ pow2 b.betaScale ≤ fp32.maxFinite ∧
    fp32.emin ≤ b.sumScale ∧ pow2 b.sumScale ≤ fp32.maxFinite ∧
    cfg.output.format.emin ≤ b.outputScale ∧ pow2 b.outputScale ≤ cfg.output.format.maxFinite)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6)

</details>

</details>

<a id="decl-c3595866ddc74b7a"></a>

<details>
<summary><code>TensorCore.scaledGemmScalarBudget</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L64)

```lean
def scaledGemmScalarBudget (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) : ℚ :=
  gemmConversionError fp32 b.alphaScale + gemmConversionError fp32 b.betaScale +
  gemmConversionError fp32 b.sumScale + gemmConversionError cfg.output.format b.outputScale
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984)

<details>
<summary>Used by</summary>

[TensorCore.Regression.tight_source_budget](../Regression/FoundationCompletion.md#decl-24341707319a2042), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf), [TensorCore.scaledGemmTightScalarBudget_le](TightBounds.md#decl-e47a9cfbc68a88aa)

</details>

</details>

<a id="decl-8510b7f8fc18dc85"></a>

<details>
<summary><code>TensorCore.scaledGemmStaticError</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L68)

```lean
def scaledGemmStaticError (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha : F32) (k : ℕ) : ℚ :=
  absQ ((value32 alpha).getD 0) * gemmStaticError model b.raw k + scaledGemmScalarBudget cfg b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.scaledGemmScalarBudget](ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.Regression.source_input_loss_matters](Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.convertedGemmCellSourceError](InputBounds.md#decl-c6688c492e9e6923), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmTightError_le](TightBounds.md#decl-75e41d5600ed7daf)

</details>

</details>

<a id="decl-50cf72a6b5586bc4"></a>

<details>
<summary><code>TensorCore.scaledGemmCellCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L72)

```lean
def scaledGemmCellCheck (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta c : F32) (pairs : List (F16 × F16)) : Bool :=
  gemmCellCheck model b.raw pairs 0 && b.valid cfg &&
  match value32 alpha, value32 beta, value32 c with
  | some a, some beta, some c => decide (
      absQ a * (gemmProductMagnitude model b.raw pairs.length + gemmStaticError model b.raw pairs.length) ≤ pow2 b.alphaScale ∧
      absQ beta * absQ c ≤ pow2 b.betaScale ∧
      (pow2 b.alphaScale + gemmConversionError fp32 b.alphaScale) +
        (pow2 b.betaScale + gemmConversionError fp32 b.betaScale) ≤ pow2 b.sumScale ∧
      pow2 b.sumScale + gemmConversionError fp32 b.sumScale ≤ pow2 b.outputScale)
  | _, _, _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmBoundConfig.valid](ScaledGemmBounds.md#decl-7446bfd9bf9ae59b), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510)

</details>

</details>

<a id="decl-853772be57cd1ddc"></a>

<details>
<summary><code>TensorCore.scaledGemmCellCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L84)

```lean
theorem scaledGemmCellCheck_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta c : F32) (pairs : List (F16 × F16))
    (h : scaledGemmCellCheck model cfg b alpha beta c pairs = true) :
    ∃ product t z, simulateGemmCell model pairs 0 = .ok product ∧
      gemmEpilogue cfg alpha beta c product = some t ∧
      scaledGemmCellIdeal alpha beta c pairs = some z ∧
      absQ (z - t.output.value) ≤ scaledGemmStaticError model cfg b alpha pairs.length := by
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
        have hscalar : t.scalarError ≤ scaledGemmScalarBudget cfg b := by
          change absQ (ac.value * product.output.value - ad.value) ≤ gemmConversionError fp32 b.alphaScale at hade
          change absQ (bc.value * cc.value - bd.value) ≤ gemmConversionError fp32 b.betaScale at hbde
          change absQ (ad.value + bd.value - sd.value) ≤ gemmConversionError fp32 b.sumScale at hsde
          exact sum_four_le _ _ _ _ _ _ _ _ hade hbde hsde houte
        have hfinal := t.propagate p (gemmStaticError model b.raw pairs.length) he
        refine ⟨product, t, a * p + betaVal * cv, hp, ?_, ?_, ?_⟩
        · simp [gemmEpilogue, hac, hbc, hcc, had, hbd, hsd, hout, t]
        · simp [scaledGemmCellIdeal, ha, hb, hcv, hi]
        · have hh : absQ a * gemmStaticError model b.raw pairs.length + t.scalarError ≤
              absQ a * gemmStaticError model b.raw pairs.length + scaledGemmScalarBudget cfg b := by grind
          change absQ (ac.value * p + bc.value * cc.value - out.value) ≤
            absQ ac.value * gemmStaticError model b.raw pairs.length + t.scalarError at hfinal
          rw [hav, hbv, hccv] at hfinal
          have := Rat.le_trans hfinal hh
          simpa [scaledGemmStaticError, ha] using this
```

**Supporting proofs:** [TensorCore.ScaledGemmCell.propagate](ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.gemmAbs_mul](ScaledGemm.md#decl-be05cc60206155ae), [TensorCore.gemmCellCheck_product_bound](ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmConversion_bounded](ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.sum_four_le](ScaledGemmBounds.md#decl-7d11b98837ef516b)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmEpilogue.addStage](ScaledGemm.md#decl-e11a69df69709a91), [TensorCore.GemmEpilogue.multiplyStage](ScaledGemm.md#decl-d5926afbc7beec92), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmBoundConfig.valid](ScaledGemmBounds.md#decl-7446bfd9bf9ae59b), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.ScaledGemmCell.scalarError](ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmConversionError](ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmProductMagnitude](ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.scaledGemmScalarBudget](ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d)

</details>

</details>

<a id="decl-17a083c7587911ff"></a>

<details>
<summary><code>TensorCore.scaledGemmCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L147)

```lean
def scaledGemmCheck (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Bool :=
  decide (∀ i : Fin m, ∀ j : Fin n,
    scaledGemmCellCheck model cfg b alpha beta C[i.val][j.val] (gemmPairs A B i j) = true)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.Regression.scaled_certificate_rejects_stages](Regression/GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](Regression/GemmExtensions.md#decl-8c37b22a932158df), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](TightBounds.md#decl-9356e64e4f80c510)

</details>

</details>

<a id="decl-e5b7bcea73549f4d"></a>

<details>
<summary><code>TensorCore.scaledGemmCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L154)

```lean
/-- The complete scaled matrix exists and is accurate, from input checks alone. -/
theorem scaledGemmCheck_sound (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : scaledGemmCheck model cfg b alpha beta A B C = true) (i : Fin m) (j : Fin n) :
    ∃ t z, (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t ∧
      (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some z ∧
      absQ (z - t.output.value) ≤ scaledGemmStaticError model cfg b alpha k := by
  obtain ⟨product, t, z, hp, ht, hi, he⟩ := scaledGemmCellCheck_sound model cfg b alpha beta _ _
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

**Supporting proofs:** [TensorCore.gemmPairs_length](Defs.md#decl-5e4e68c0669cd541), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.scaledGemmCellCheck_sound](ScaledGemmBounds.md#decl-853772be57cd1ddc)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmEpilogue](ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellIdeal](ScaledGemm.md#decl-d68ce5e2862aec7d), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.scaledGemmCheck_matrix_error](ScaledGemmBounds.md#decl-7addf1d7932b65bf)

</details>

</details>

<a id="decl-7addf1d7932b65bf"></a>

<details>
<summary><code>TensorCore.scaledGemmCheck_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L172)

```lean
theorem scaledGemmCheck_matrix_error (model : WmmaGemmModel) (cfg : GemmEpilogue)
    (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (h : scaledGemmCheck model cfg b alpha beta A B C = true) (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ t,
      (scaledGemm model cfg alpha beta A B C)[i.val][j.val] = some t → D[i.val][j.val] = t.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (scaledGemmIdeal alpha beta A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * scaledGemmStaticError model cfg b alpha k := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨t, z, hr, hi, he⟩ := scaledGemmCheck_sound model cfg b alpha beta A B C h i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j t hr] using he
```

**Supporting proofs:** [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d), [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d)

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2dc2798c7ad94c7b"></a>

<details>
<summary><code>TensorCore.convertedGemmCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L190)

```lean
/-- Input conversions may execute during validation; tensor-core and epilogue
execution do not. The error reference is the resulting encoded FP16 matrices. -/
def convertedGemmCheck (source : Format) (inputMode : BinaryRoundingMode)
    (model : WmmaGemmModel) (cfg : GemmEpilogue) (b : ScaledGemmBoundConfig) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) : Bool :=
  match convertGemmInput source inputMode A, convertGemmInput source inputMode B with
  | some a, some b' => scaledGemmCheck model cfg b alpha beta a b' C
  | _, _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.scaledGemmCellCheck](ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.Regression.paper_source_certificate](Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.convertedGemmCheck_sound](ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate](InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmSourceCertificate_acceptance](InputBounds.md#decl-65084421def64cb7), [TensorCore.convertedGemmSourceCertificate_sound](InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmTightSourceCertificate](TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.convertedGemmTightSourceCertificate_acceptance](TightInputBounds.md#decl-533bbea7ddad7c67), [TensorCore.convertedGemmTightSourceCertificate_sound](TightInputBounds.md#decl-9670e739c545855d)

</details>

</details>

<a id="decl-2517f6508460b33a"></a>

<details>
<summary><code>TensorCore.convertedGemmCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ScaledGemmBounds.lean#L198)

```lean
theorem convertedGemmCheck_sound (source : Format) (inputMode : BinaryRoundingMode)
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
        absQ (z - t.output.value) ≤ scaledGemmStaticError model cfg b alpha k := by
  cases ha : convertGemmInput source inputMode A with
  | none => simp [convertedGemmCheck, ha] at h
  | some a =>
    cases hb : convertGemmInput source inputMode B with
    | none => simp [convertedGemmCheck, ha, hb] at h
    | some b' =>
      simp only [convertedGemmCheck, ha, hb] at h
      refine ⟨a, b', rfl, rfl, ?_, fun i j => scaledGemmCheck_sound model cfg b alpha beta a b' C h i j⟩
      simp [convertedGemm, ha, hb]
```

**Supporting proofs:** [TensorCore.scaledGemmCheck_sound](ScaledGemmBounds.md#decl-e5b7bcea73549f4d)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ScaledGemmBoundConfig](ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.ScaledGemmCell](ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck](ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.scaledGemm](ScaledGemm.md#decl-aee47dc0721f3c2d), [TensorCore.scaledGemmCheck](ScaledGemmBounds.md#decl-17a083c7587911ff), [TensorCore.scaledGemmIdeal](ScaledGemm.md#decl-566f73fbf4351125), [TensorCore.scaledGemmStaticError](ScaledGemmBounds.md#decl-8510b7f8fc18dc85)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemmCheck_paper_sound](Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.convertedGemmCheck_source_sound](InputBounds.md#decl-82c7f6139915a514)

</details>

</details>
