# TensorCore.Regression.FoundationCompletion

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0598e4ed93ef2381"></a>

<details>
<summary><code>TensorCore.Regression.eq20_signed_budget</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L16)

```lean
/-- Eq.20 includes signed coefficients and the strict count-times-cap budget. -/
theorem eq20_signed_budget : magnitudeSum [7, -7, 7, -7] < 2 ^ 5 := by
  apply extraction_coefficient_bound [7, -7, 7, -7] 3 0 5 (by decide)
  · intro z hz
    simp only [List.mem_cons, List.not_mem_nil, or_false] at hz
    rcases hz with h | h | h | h <;> subst z <;> decide +kernel
  · decide +kernel
```

**Supporting proofs:** [TensorCore.extraction_coefficient_bound](../Core/Binary/ResidualBudget.md#decl-19d0467f0a8a4946)

**Definitions and types:** [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-34693c7b47f67923"></a>

<details>
<summary><code>TensorCore.Regression.eq20Trace</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L23)

```lean
def eq20Trace : BlockTrace := (evalBlock r3).toOption.get (by decide +kernel)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.r3](../TC/Regression/Cases.md#decl-0419be5c38ea4116), [TensorCore.evalBlock](../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.eq20Grid](FoundationCompletion.md#decl-4fbb74e159ffccc9), [TensorCore.Regression.eq20_public_accepts](FoundationCompletion.md#decl-b1321756db80e3f1), [TensorCore.Regression.eq20_public_corrects](FoundationCompletion.md#decl-d2b5a2f26403185e), [TensorCore.Regression.extraction_alternative_and_finer_rejection](FoundationCompletion.md#decl-6ea13e9e81db1aae)

</details>

</details>

<a id="decl-4fbb74e159ffccc9"></a>

<details>
<summary><code>TensorCore.Regression.eq20Grid</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L24)

```lean
def eq20Grid : ExtractionGrid eq20Trace := ⟨-19, by decide +kernel⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](../EFT/ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.Regression.eq20Trace](FoundationCompletion.md#decl-34693c7b47f67923)

<details>
<summary>Used by</summary>

[TensorCore.Regression.eq20_public_accepts](FoundationCompletion.md#decl-b1321756db80e3f1), [TensorCore.Regression.eq20_public_corrects](FoundationCompletion.md#decl-d2b5a2f26403185e), [TensorCore.Regression.extraction_alternative_and_finer_rejection](FoundationCompletion.md#decl-6ea13e9e81db1aae)

</details>

</details>

<a id="decl-b1321756db80e3f1"></a>

<details>
<summary><code>TensorCore.Regression.eq20_public_accepts</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L27)

```lean
/-- The public paper corollary proves acceptance for a nondefault extraction grid. -/
theorem eq20_public_accepts : eq20Grid.scalarPredicate fp32 (-24) = true := by
  apply eq20Grid.eq20_scalarPredicate fp32 (by decide) (-24) (by decide) (by decide +kernel)
  · intro x hx
    refine ⟨(x.value / pow2 (-24)).floor, ?_⟩
    have hall : eq20Trace.block.terms.all (fun x => decide
        (x.value = ((x.value / pow2 (-24)).floor : ℚ) * pow2 (-24))) = true := by decide +kernel
    exact of_decide_eq_true (List.all_eq_true.mp hall x hx)
  all_goals decide +kernel
```

**Supporting proofs:** [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](../EFT/ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](../EFT/ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.overlap](../EFT/ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedSum](../EFT/ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.Regression.eq20Grid](FoundationCompletion.md#decl-4fbb74e159ffccc9), [TensorCore.Regression.eq20Trace](FoundationCompletion.md#decl-34693c7b47f67923), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Core/Binary/ScalarSum.md#decl-983cd49dc90d1170)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.eq20_public_corrects](FoundationCompletion.md#decl-d2b5a2f26403185e)

</details>

</details>

<a id="decl-d2b5a2f26403185e"></a>

<details>
<summary><code>TensorCore.Regression.eq20_public_corrects</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L36)

```lean
theorem eq20_public_corrects :
    eq20Grid.scalarCorrected fp32 (-24) = round32 .nearestEven eq20Trace.block.exactDot :=
  eq20Grid.scalarCorrected_eq fp32 (-24) eq20_public_accepts
```

**Supporting proofs:** [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.Regression.eq20_public_accepts](FoundationCompletion.md#decl-b1321756db80e3f1)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid.scalarCorrected](../EFT/ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.Regression.eq20Grid](FoundationCompletion.md#decl-4fbb74e159ffccc9), [TensorCore.Regression.eq20Trace](FoundationCompletion.md#decl-34693c7b47f67923), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6ea13e9e81db1aae"></a>

<details>
<summary><code>TensorCore.Regression.extraction_alternative_and_finer_rejection</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L40)

```lean
theorem extraction_alternative_and_finer_rejection :
    eq20Grid.lowParts = [31 / 16777216, 0, 0, 0, 0] ∧
    eq20Grid.overlap = 1 / 1048576 ∧
    (eq20Grid.scalarCorrected fp32 (-24)).map BitVec.toNat = some 0x41080000 ∧
    (eq20Trace.extractAt (-24)).isSome = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace.extractAt](../EFT/ExtractionGrid.md#decl-4fac256684e59d74), [TensorCore.ExtractionGrid](../EFT/ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](../EFT/ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.scalarCorrected](../EFT/ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.Regression.eq20Grid](FoundationCompletion.md#decl-4fbb74e159ffccc9), [TensorCore.Regression.eq20Trace](FoundationCompletion.md#decl-34693c7b47f67923), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9b66085d356dcc00"></a>

<details>
<summary><code>TensorCore.Regression.extraction_negative_zero_and_subnormal</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L46)

```lean
theorem extraction_negative_zero_and_subnormal :
    ((evalBlock (⟨[(0xbc00, 1), (0, 0), (0, 0), (0, 0)], 0⟩ : V100Input)).map fun t =>
      (t.defaultExtraction.lowParts, t.defaultExtraction.scalarCorrected fp32 (-24))) =
      .ok ([0, 0, 0, 0, 0], some 0xb3800000) ∧
    ((evalBlock (⟨[(0, 0), (0, 0), (0, 0), (0, 0)], 0⟩ : V100Input)).map fun t =>
      t.defaultExtraction.scalarCorrected fp32 (-149)) = .ok (some 0) ∧
    ((evalBlock subnormalAccumulator).map fun t =>
      t.defaultExtraction.scalarCorrected fp32 (-149)) = .ok none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.defaultExtraction](../EFT/ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.scalarCorrected](../EFT/ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.subnormalAccumulator](../EFT/Regression/EFT.md#decl-5abbb5145c17d893), [TensorCore.evalBlock](../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f27799086657473d"></a>

<details>
<summary><code>TensorCore.Regression.eq20_range_and_strict_boundary</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L55)

```lean
theorem eq20_range_and_strict_boundary :
    ¬ 4 * (2 ^ (4 : ℕ) - 1) < 2 ^ (5 : ℕ) ∧
    ¬ magnitudeSum [16, -16] < 2 ^ 5 ∧
    naiveSumBinary fp32 [fp32.maxFinite, fp32.maxFinite, -fp32.maxFinite] = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ac87bcf2ff18868c"></a>

<details>
<summary><code>TensorCore.Regression.independent_scalar_directions</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L62)

```lean
/-- Scalar specification is mathematical; rewrite by the universal bridge and
kernel-check the resulting encodings, including negative underflow and exact zero. -/
theorem independent_scalar_directions :
    scalarRound (layoutOf fp16) .towardNegative (-pow2 (-25)) = some 0x8001 ∧
    scalarRound (layoutOf fp16) .towardPositive (-pow2 (-25)) = some 0x8000 ∧
    scalarRound (layoutOf fp16) .towardZero (-pow2 (-25)) = some 0x8000 ∧
    scalarRound (layoutOf fp16) .nearestEven (-pow2 (-25)) = some 0x8000 ∧
    scalarRound (layoutOf fp16) .towardNegative 0 = some 0 ∧
    scalarRound (layoutOf fp16) .towardPositive (-65504) = some 0xfbff ∧
    scalarRound (layoutOf fp16) .towardZero 65505 = none ∧
    scalarRound (layoutOf (⟨0, 5, 15⟩ : Format)) .nearestEven 0 = none := by
  change scalarRound (layoutOf fp16) (scalarModeOf .towardNegative) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardPositive) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardZero) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .nearestEven) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardNegative) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardPositive) _ = _ ∧
    scalarRound (layoutOf fp16) (scalarModeOf .towardZero) _ = _ ∧
    scalarRound (layoutOf _) (scalarModeOf .nearestEven) _ = _
  simp only [scalarRound_eq]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarRound_eq](../Gemm/Specification/ScalarRounding.md#decl-dac12f3fa291169b)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.width](../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarMode](../Gemm/Specification/Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.layoutOf](../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarModeOf](../Gemm/Specification/ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarRound](../Gemm/Specification/Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ca2da7cbbbbc9939"></a>

<details>
<summary><code>TensorCore.Regression.independent_scaled_complete</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L82)

```lean
theorem independent_scaled_complete :
    (scaledMatrix .v100 (epilogueOf {multiplyMode := .towardNegative}) 0 0xbf800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]]).map
        (fun row => row.map fun cell => cell.map ScaledMatrixCell.output) = #v[#v[some 0xbf800003]] ∧
    (scaledMatrix .hopper (epilogueOf {output := ⟨fp16, .towardZero⟩}) 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x47800000]]).map
        (fun row => row.map fun cell => cell.map ScaledMatrixCell.output) = #v[#v[none]] := by
  rw [← scaledGemmBits_eq_independent .v100, ← scaledGemmBits_eq_independent .hopper]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.scaledGemmBits_eq_independent](../Gemm/Specification/ScaledGemmEquivalence.md#decl-92020721ef951c58)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Gemm/Matrix.md#decl-b089377bd907619f), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../Gemm/ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.Layout.width](../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarEpilogue](../Gemm/Specification/Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](../Gemm/Specification/Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](../Gemm/Specification/Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.WmmaModel](../Gemm/Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.epilogueOf](../Gemm/Specification/ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.scaledMatrix](../Gemm/Specification/Scalar.md#decl-eb73cbc06da59e62), [TensorCore.PaperSpec.wmmaModel](../Gemm/Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Regression.emptyGemmA](../Gemm/Regression/GemmExtensions.md#decl-51119571e7cbedeb), [TensorCore.Regression.emptyGemmB](../Gemm/Regression/GemmExtensions.md#decl-860055124233caf6), [TensorCore.WmmaGemmModel](../Gemm/Defs.md#decl-a44ab2c261ff842b), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmBits](../Gemm/ScaledGemm.md#decl-54ef760c8311c4d0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2a3011cf657be65d"></a>

<details>
<summary><code>TensorCore.Regression.independent_converted_rejection</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L92)

```lean
theorem independent_converted_rejection :
    convertedMatrix (layoutOf fp32) (scalarModeOf .nearestEven) .v100 (epilogueOf {}) 0 0
      (#v[#v[0x7fc00000]] : DenseMatrix F32 1 1) sourceZero sourceZero = none := by
  rw [← convertedGemm_eq_independent fp32 .nearestEven .v100]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.convertedGemm_eq_independent](../Gemm/Specification/ScaledGemmEquivalence.md#decl-cf7e09c03287eb25)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Gemm/Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](../Gemm/ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.Matrix](../Gemm/Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.ScalarEpilogue](../Gemm/Specification/Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](../Gemm/Specification/Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](../Gemm/Specification/Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.WmmaModel](../Gemm/Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.convertedMatrix](../Gemm/Specification/Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.epilogueOf](../Gemm/Specification/ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.layoutOf](../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.scalarModeOf](../Gemm/Specification/ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scaledCellObservation](../Gemm/Specification/ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.wmmaModel](../Gemm/Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Regression.sourceZero](../Gemm/Regression/GemmInputConversion.md#decl-010876357b47a5ed), [TensorCore.ScaledGemmCell](../Gemm/ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Gemm/Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemm](../Gemm/ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-24341707319a2042"></a>

<details>
<summary><code>TensorCore.Regression.tight_source_budget</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L99)

```lean
/-- Both improvements are strict on the same accepted input certificate. -/
theorem tight_source_budget :
    scaledGemmTightScalarBudget {} sourceGemmBounds = 897 / 16777216 ∧
    scaledGemmScalarBudget {} sourceGemmBounds = 897 / 8388608 ∧
    convertedGemmTightSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x3f800000 0 sourceNearOne sourceNearOne sourceZero = some #v[#v[28037 / 16777216]] ∧
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x3f800000 0 sourceNearOne sourceNearOne sourceZero = some #v[#v[14471 / 8388608]] ∧
    (28037 / 16777216 : ℚ) < 14471 / 8388608 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Gemm/Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](../Gemm/ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.sourceGemmBounds](../Gemm/Regression/GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.Regression.sourceNearOne](../Gemm/Regression/GemmInputConversion.md#decl-8df9b91930d685ed), [TensorCore.Regression.sourceZero](../Gemm/Regression/GemmInputConversion.md#decl-010876357b47a5ed), [TensorCore.WmmaGemmModel](../Gemm/Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmSourceCertificate](../Gemm/InputBounds.md#decl-f68879ebd2a77165), [TensorCore.convertedGemmTightSourceCertificate](../Gemm/TightInputBounds.md#decl-08f2144e6c98b276), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmScalarBudget](../Gemm/ScaledGemmBounds.md#decl-c3595866ddc74b7a), [TensorCore.scaledGemmTightScalarBudget](../Gemm/TightBounds.md#decl-0f32a9163e5eb52b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d874c31dcab129cf"></a>

<details>
<summary><code>TensorCore.Regression.tight_input_edges</code></summary>

[Lean source](../../../TensorCore/Regression/FoundationCompletion.lean#L110)

```lean
/-- Subnormal cross effects remain bounded, including upward conversion of both
operands. Exact conversions, signed zero and failed input conversion are preserved. -/
theorem tight_input_edges :
    gemmInputProductTightError fp32 .towardPositive [(0x32800000, 0x32800000)] =
      some (15 / 4503599627370496) ∧
    gemmInputProductTightError fp32 .nearestEven [(0x3f800000, 0xbf800000), (0x80000000, 0)] = some 0 ∧
    gemmInputProductTightError fp32 .nearestEven [(0x7fc00000, 0)] = none ∧
    gemmConversionModeError ⟨fp32, .nearestEven⟩ (-126) = pow2 (-150) ∧
    gemmConversionModeError ⟨fp32, .towardNegative⟩ (-126) = pow2 (-149) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmConversionModeError](../Gemm/RoundingBudget.md#decl-426ed137365dd261), [TensorCore.gemmInputProductTightError](../Gemm/TightInputBounds.md#decl-c19657b0f9cb6d37), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
