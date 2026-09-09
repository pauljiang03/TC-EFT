# TensorCore.Gemm.Regression.GemmExtensions

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-9f16c29325b246ad"></a>

<details>
<summary><code>TensorCore.Regression.smallGemmBounds</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L11)

```lean
def smallGemmBounds : GemmBoundConfig := ⟨1, -10, 5, 1⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_improves_existing_certificate](GemmAnalysis.md#decl-a1392f6a35ba7d56), [TensorCore.Regression.certified_tiny](GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.gemm_certificate_rejects](GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_certifies_all_profiles](GemmExtensions.md#decl-04b959ba551a2db5), [TensorCore.Regression.smallScaledGemmBounds](GemmExtensions.md#decl-63eb6d51249fb461)

</details>

</details>

<a id="decl-63eb6d51249fb461"></a>

<details>
<summary><code>TensorCore.Regression.smallScaledGemmBounds</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L13)

```lean
def smallScaledGemmBounds : ScaledGemmBoundConfig := ⟨smallGemmBounds, 0, 0, 2, 3⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Regression.smallGemmBounds](GemmExtensions.md#decl-9f16c29325b246ad), [TensorCore.ScaledGemmBoundConfig](../ScaledGemmBounds.md#decl-ed7a52391e93046c)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scaled_certificate_rejects_stages](GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](GemmExtensions.md#decl-8c37b22a932158df)

</details>

</details>

<a id="decl-8c37b22a932158df"></a>

<details>
<summary><code>TensorCore.Regression.scaled_certifies_all_profiles</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L15)

```lean
theorem scaled_certifies_all_profiles :
    scaledGemmCheck .v100 {} smallScaledGemmBounds 0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = true ∧
    scaledGemmCheck .ampere {} smallScaledGemmBounds 0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = true ∧
    scaledGemmCheck .hopper {} smallScaledGemmBounds 0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = true := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.smallScaledGemmBounds](GemmExtensions.md#decl-63eb6d51249fb461), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmCheck](../ScaledGemmBounds.md#decl-17a083c7587911ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3f2241a861f287ed"></a>

<details>
<summary><code>TensorCore.Regression.scaled_certificate_rejects_stages</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L20)

```lean
theorem scaled_certificate_rejects_stages :
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with alphaScale := -10}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false ∧
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with betaScale := -2}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false ∧
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with sumScale := 1}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false ∧
    scaledGemmCheck .v100 {} {smallScaledGemmBounds with outputScale := 2}
      0x40000000 0xbf000000 gemmTinyA gemmTinyB gemmOne = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.smallScaledGemmBounds](GemmExtensions.md#decl-63eb6d51249fb461), [TensorCore.ScaledGemmBoundConfig](../ScaledGemmBounds.md#decl-ed7a52391e93046c), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmCheck](../ScaledGemmBounds.md#decl-17a083c7587911ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-04b959ba551a2db5"></a>

<details>
<summary><code>TensorCore.Regression.gemm_certifies_all_profiles</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L30)

```lean
theorem gemm_certifies_all_profiles :
    gemmCheck .v100 smallGemmBounds gemmTinyA gemmTinyB gemmOne = true ∧
    gemmCheck .ampere smallGemmBounds gemmTinyA gemmTinyB gemmOne = true ∧
    gemmCheck .hopper smallGemmBounds gemmTinyA gemmTinyB gemmOne = true := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.smallGemmBounds](GemmExtensions.md#decl-9f16c29325b246ad), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmCheck](../Bounds.md#decl-6dd15d2054647056)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e72450f7dbc8fe47"></a>

<details>
<summary><code>TensorCore.Regression.certified_tiny</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L36)

```lean
/-- The certificate proves execution and accuracy without a supplied output trace. -/
theorem certified_tiny (model : WmmaGemmModel) :
    ∃ cell z, (gemm model gemmTinyA gemmTinyB gemmOne)[0][0] = .ok cell ∧
      (gemmIdeal gemmTinyA gemmTinyB gemmOne)[0][0] = some z ∧
      absQ (z - cell.output.value) ≤ gemmStaticError model smallGemmBounds 17 := by
  apply gemmCheck_sound model smallGemmBounds gemmTinyA gemmTinyB gemmOne _ ⟨0, by decide⟩ ⟨0, by decide⟩
  cases model <;> decide +kernel
```

**Supporting proofs:** [TensorCore.gemmCheck_sound](../Bounds.md#decl-3d79dbcc8fc2e521)

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.smallGemmBounds](GemmExtensions.md#decl-9f16c29325b246ad), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmCheck](../Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](../Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmStaticError](../Bounds.md#decl-f2b1a703f1fc6bcf)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-36649ed141d65992"></a>

<details>
<summary><code>TensorCore.Regression.gemm_certificate_rejects</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L43)

```lean
theorem gemm_certificate_rejects :
    gemmCheck .v100 smallGemmBounds gemmA gemmB gemmC = false ∧
    gemmCheck .hopper {smallGemmBounds with carryBits := 4} gemmTinyA gemmTinyB gemmOne = false ∧
    gemmCheck .ampere {smallGemmBounds with initialBound := 4} gemmTinyA gemmTinyB gemmOne = false ∧
    gemmCheck .v100 smallGemmBounds
      (#v[#v[0x7c00]] : DenseMatrix F16 1 1) #v[#v[0]] #v[#v[0]] = false := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.Regression.gemmA](Gemm.md#decl-cd0883f1e38ef115), [TensorCore.Regression.gemmB](Gemm.md#decl-6218aaffd17d1302), [TensorCore.Regression.gemmC](Gemm.md#decl-ab7c3d001b056c5e), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.Regression.smallGemmBounds](GemmExtensions.md#decl-9f16c29325b246ad), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmCheck](../Bounds.md#decl-6dd15d2054647056)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-94ac378f052b4fa8"></a>

<details>
<summary><code>TensorCore.Regression.scaled_rectangular</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L50)

```lean
theorem scaled_rectangular :
    ((scaledGemm .ampere {} 0x40000000 0xbf000000 gemmA gemmB gemmC).map
      fun row => row.map fun t => t.map (·.output.value)) =
      #v[#v[some (59 / 2), some 109, some (-63 / 2)],
         #v[some (-32), some (-225 / 2), some 27]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.gemmA](Gemm.md#decl-cd0883f1e38ef115), [TensorCore.Regression.gemmB](Gemm.md#decl-6218aaffd17d1302), [TensorCore.Regression.gemmC](Gemm.md#decl-ab7c3d001b056c5e), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemm](../ScaledGemm.md#decl-aee47dc0721f3c2d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e35d8dd7f8722081"></a>

<details>
<summary><code>TensorCore.Regression.scaled_c_placement</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L57)

```lean
/-- The C-initialized path and the scalar-epilogue path intentionally differ. -/
theorem scaled_c_placement :
    scaledGemmBits .v100 {} 0x3f800000 0x3f800000 gemmTinyA gemmTinyB gemmOne =
      #v[#v[some 0x3f800008]] ∧
    gemmBits .v100 gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800000]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b), [TensorCore.scaledGemmBits](../ScaledGemm.md#decl-54ef760c8311c4d0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-51119571e7cbedeb"></a>

<details>
<summary><code>TensorCore.Regression.emptyGemmA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L62)

```lean
def emptyGemmA : DenseMatrix F16 1 0 := #v[#v[]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.scaled_conversion](GemmExtensions.md#decl-7ffd0a676f988e41), [TensorCore.Regression.scaled_multiply_rounding](GemmExtensions.md#decl-43dfad9ae9cb03ec), [TensorCore.Regression.scaled_rejections_and_zero](GemmExtensions.md#decl-d1b81d931f9d9b7f)

</details>

</details>

<a id="decl-860055124233caf6"></a>

<details>
<summary><code>TensorCore.Regression.emptyGemmB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L63)

```lean
def emptyGemmB : DenseMatrix F16 0 1 := #v[]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.Regression.scaled_conversion](GemmExtensions.md#decl-7ffd0a676f988e41), [TensorCore.Regression.scaled_multiply_rounding](GemmExtensions.md#decl-43dfad9ae9cb03ec), [TensorCore.Regression.scaled_rejections_and_zero](GemmExtensions.md#decl-d1b81d931f9d9b7f)

</details>

</details>

<a id="decl-43dfad9ae9cb03ec"></a>

<details>
<summary><code>TensorCore.Regression.scaled_multiply_rounding</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L65)

```lean
theorem scaled_multiply_rounding :
    scaledGemmBits .v100 {} 0 0x3f800001 emptyGemmA emptyGemmB #v[#v[0x3f800001]] =
      #v[#v[some 0x3f800002]] ∧
    scaledGemmBits .v100 {multiplyMode := .towardPositive} 0 0x3f800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]] = #v[#v[some 0x3f800003]] ∧
    scaledGemmBits .v100 {multiplyMode := .towardNegative} 0 0xbf800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]] = #v[#v[some 0xbf800003]] ∧
    scaledGemmBits .v100 {multiplyMode := .towardZero} 0 0xbf800001
      emptyGemmA emptyGemmB #v[#v[0x3f800001]] = #v[#v[some 0xbf800002]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.emptyGemmA](GemmExtensions.md#decl-51119571e7cbedeb), [TensorCore.Regression.emptyGemmB](GemmExtensions.md#decl-860055124233caf6), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmBits](../ScaledGemm.md#decl-54ef760c8311c4d0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7ffd0a676f988e41"></a>

<details>
<summary><code>TensorCore.Regression.scaled_conversion</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L75)

```lean
theorem scaled_conversion :
    scaledGemmBits .hopper {output := ⟨fp16, .nearestEven⟩} 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x3f801000]] = #v[#v[some 0x3c00]] ∧
    scaledGemmBits .hopper {output := ⟨fp16, .towardPositive⟩} 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x3f801000]] = #v[#v[some 0x3c01]] ∧
    convertGemmInput fp32 .nearestEven (#v[#v[0x3f801000]] : DenseMatrix F32 1 1) =
      some #v[#v[0x3c00]] ∧
    convertGemmInput fp32 .towardPositive (#v[#v[0x3f801000]] : DenseMatrix F32 1 1) =
      some #v[#v[0x3c01]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.emptyGemmA](GemmExtensions.md#decl-51119571e7cbedeb), [TensorCore.Regression.emptyGemmB](GemmExtensions.md#decl-860055124233caf6), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmBits](../ScaledGemm.md#decl-54ef760c8311c4d0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d1b81d931f9d9b7f"></a>

<details>
<summary><code>TensorCore.Regression.scaled_rejections_and_zero</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmExtensions.lean#L85)

```lean
theorem scaled_rejections_and_zero :
    scaledGemmBits .v100 {} 0 0x7f800000 emptyGemmA emptyGemmB gemmOne = #v[#v[none]] ∧
    scaledGemmBits .v100 {} 0 0x40000000 emptyGemmA emptyGemmB #v[#v[0x7f7fffff]] = #v[#v[none]] ∧
    scaledGemmBits .v100 {output := ⟨fp16, .towardZero⟩} 0 0x3f800000
      emptyGemmA emptyGemmB #v[#v[0x47800000]] = #v[#v[none]] ∧
    convertGemmInput fp32 .nearestEven (#v[#v[0x7fc00000]] : DenseMatrix F32 1 1) = none ∧
    scaledGemmBits .v100 {} 0x80000000 0x3f800000 emptyGemmA emptyGemmB #v[#v[0x80000000]] =
      #v[#v[some 0]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.Regression.emptyGemmA](GemmExtensions.md#decl-51119571e7cbedeb), [TensorCore.Regression.emptyGemmB](GemmExtensions.md#decl-860055124233caf6), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.scaledGemmBits](../ScaledGemm.md#decl-54ef760c8311c4d0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
