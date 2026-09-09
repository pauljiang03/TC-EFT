# TensorCore.Gemm.Regression.GemmInputConversion

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-8df9b91930d685ed"></a>

<details>
<summary><code>TensorCore.Regression.sourceNearOne</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L11)

```lean
def sourceNearOne : DenseMatrix F32 1 1 := #v[#v[0x3f801000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_source_certificate](GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.source_empty_dimensions](GemmInputConversion.md#decl-3bbb9c3194b7241f), [TensorCore.Regression.source_input_loss_matters](GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.tight_source_budget](../../Regression/FoundationCompletion.md#decl-24341707319a2042)

</details>

</details>

<a id="decl-010876357b47a5ed"></a>

<details>
<summary><code>TensorCore.Regression.sourceZero</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L12)

```lean
def sourceZero : DenseMatrix F32 1 1 := #v[#v[0]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.input_range_and_special_rejections](GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.paper_source_certificate](GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.source_input_loss_matters](GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.tight_source_budget](../../Regression/FoundationCompletion.md#decl-24341707319a2042)

</details>

</details>

<a id="decl-f489ee27debc3a73"></a>

<details>
<summary><code>TensorCore.Regression.sourceGemmBounds</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L13)

```lean
def sourceGemmBounds : ScaledGemmBoundConfig := ⟨⟨6, 0, 3, 0⟩, 7, 0, 8, 9⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.ScaledGemmBoundConfig](../ScaledGemmBounds.md#decl-ed7a52391e93046c)

<details>
<summary>Used by</summary>

[TensorCore.Regression.input_range_and_special_rejections](GemmInputConversion.md#decl-77ab18ef716146c1), [TensorCore.Regression.negative_alpha_source_bound](GemmInputConversion.md#decl-8ffd66ebf0b6eae9), [TensorCore.Regression.paper_source_certificate](GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.source_empty_dimensions](GemmInputConversion.md#decl-3bbb9c3194b7241f), [TensorCore.Regression.source_input_loss_matters](GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.tight_source_budget](../../Regression/FoundationCompletion.md#decl-24341707319a2042)

</details>

</details>

<a id="decl-665a3e346fe5111f"></a>

<details>
<summary><code>TensorCore.Regression.source_input_loss_matters</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L16)

```lean
/-- The old post-conversion error budget alone does not bound the source ideal. -/
theorem source_input_loss_matters :
    (convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x3f800000 0 sourceNearOne sourceNearOne sourceZero).isSome = true ∧
    sourceGemmCellIdeal fp32 0x3f800000 0 0 [(0x3f801000, 0x3f801000)] =
      some ((2049 / 2048 : ℚ) * (2049 / 2048)) ∧
    (convertedGemm fp32 .nearestEven .v100 {} 0x3f800000 0 sourceNearOne sourceNearOne sourceZero).map
      (fun out => out.map fun row => row.map fun t => t.map (·.output.bits)) = some #v[#v[some 0x3f800000]] ∧
    scaledGemmStaticError .v100 {} sourceGemmBounds 0x3f800000 1 <
      absQ ((2049 / 2048 : ℚ) * (2049 / 2048) - 1) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.sourceGemmBounds](GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.Regression.sourceNearOne](GemmInputConversion.md#decl-8df9b91930d685ed), [TensorCore.Regression.sourceZero](GemmInputConversion.md#decl-010876357b47a5ed), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertedGemm](../ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmSourceCertificate](../InputBounds.md#decl-f68879ebd2a77165), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmStaticError](../ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.sourceGemmCellIdeal](../InputBounds.md#decl-24f836f23596682e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2eff5e907eb91aa6"></a>

<details>
<summary><code>TensorCore.Regression.input_modes_and_signs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L26)

```lean
theorem input_modes_and_signs :
    gemmInputDatum fp32 .nearestEven 0x3f801800 = some ⟨4099 / 4096, 1025 / 1024⟩ ∧
    gemmInputDatum fp32 .towardZero 0x3f801800 = some ⟨4099 / 4096, 1⟩ ∧
    gemmInputDatum fp32 .towardNegative 0xbf801800 = some ⟨-4099 / 4096, -1025 / 1024⟩ ∧
    gemmInputDatum fp32 .towardPositive 0xbf801800 = some ⟨-4099 / 4096, -1⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](../InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmInputDatum](../InputBounds.md#decl-228cfe81593bf2a2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-cea5bdaa327d80b0"></a>

<details>
<summary><code>TensorCore.Regression.subnormal_cross_term</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L34)

```lean
/-- Upward conversion of two quarter-subnormal operands needs the cross term.
The two first-order contributions alone are strictly smaller than the true loss. -/
theorem subnormal_cross_term :
    gemmInputDatum fp32 .towardPositive 0x32800000 = some ⟨1 / 67108864, 1 / 16777216⟩ ∧
    gemmInputProductError fp32 .towardPositive [(0x32800000, 0x32800000)] =
      some (15 / 4503599627370496) ∧
    (6 / 4503599627370496 : ℚ) < absQ ((1 / 67108864 : ℚ) * (1 / 67108864) -
      (1 / 16777216) * (1 / 16777216)) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](../InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmInputDatum](../InputBounds.md#decl-228cfe81593bf2a2), [TensorCore.gemmInputProductError](../InputBounds.md#decl-44a67c4ea7aef5c8)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8a42b37a2ff8769e"></a>

<details>
<summary><code>TensorCore.Regression.exact_conversion_and_zero_loss</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L41)

```lean
theorem exact_conversion_and_zero_loss :
    gemmInputProductError fp32 .nearestEven [(0x3f800000, 0xbf800000), (0x80000000, 0)] = some 0 ∧
    gemmInputProductError fp16 .towardPositive [(1, 0x8001), (0x7bff, 0x8000)] = some 0 ∧
    gemmInputProductError fp64 .nearestEven [(0x3ff0000000000000, 0xbff0000000000000)] = some 0 ∧
    gemmInputProductError bf16 .towardZero [(0x3f80, 0xbf80)] = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.gemmInputProductError](../InputBounds.md#decl-44a67c4ea7aef5c8)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-77ab18ef716146c1"></a>

<details>
<summary><code>TensorCore.Regression.input_range_and_special_rejections</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L47)

```lean
theorem input_range_and_special_rejections :
    gemmInputDatum fp32 .towardZero 0x47800000 = none ∧
    gemmInputDatum fp32 .towardNegative 0xc7800000 = none ∧
    gemmInputDatum fp32 .nearestEven 0x7f800000 = none ∧
    gemmInputDatum fp32 .nearestEven 0x7fc00000 = none ∧
    gemmInputDatum fp32 .nearestEven 0x477fe000 = some ⟨65504, 65504⟩ ∧
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0 0 (#v[#v[0x7fc00000]]) sourceZero sourceZero = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.GemmInputDatum](../InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.Regression.sourceGemmBounds](GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.Regression.sourceZero](GemmInputConversion.md#decl-010876357b47a5ed), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmSourceCertificate](../InputBounds.md#decl-f68879ebd2a77165), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmInputDatum](../InputBounds.md#decl-228cfe81593bf2a2)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3bbb9c3194b7241f"></a>

<details>
<summary><code>TensorCore.Regression.source_empty_dimensions</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L56)

```lean
theorem source_empty_dimensions :
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x7fc00000 0 (#v[] : DenseMatrix F32 0 1) sourceNearOne #v[] = some #v[] ∧
    convertedGemmSourceCertificate fp32 .nearestEven .v100 {} sourceGemmBounds
      0x7fc00000 0 sourceNearOne (#v[#v[]] : DenseMatrix F32 1 0) #v[#v[]] = some #v[#v[]] ∧
    gemmInputProductError fp32 .nearestEven [] = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.sourceGemmBounds](GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.Regression.sourceNearOne](GemmInputConversion.md#decl-8df9b91930d685ed), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmSourceCertificate](../InputBounds.md#decl-f68879ebd2a77165), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmInputProductError](../InputBounds.md#decl-44a67c4ea7aef5c8)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8ffd66ebf0b6eae9"></a>

<details>
<summary><code>TensorCore.Regression.negative_alpha_source_bound</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmInputConversion.lean#L63)

```lean
theorem negative_alpha_source_bound :
    convertedGemmCellSourceError fp32 .nearestEven .v100 {} sourceGemmBounds 0xc0000000
      [(0x3f801000, 0x3f801000)] =
    convertedGemmCellSourceError fp32 .nearestEven .v100 {} sourceGemmBounds 0x40000000
      [(0x3f801000, 0x3f801000)] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.sourceGemmBounds](GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertedGemmCellSourceError](../InputBounds.md#decl-c6688c492e9e6923), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
