# TensorCore.EFT.Defs

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-f4644e4a3c22871b"></a>

<details>
<summary><code>TensorCore.BlockTrace.extractionExponent</code></summary>

[Lean source](../../../TensorCore/EFT/Defs.lean#L9)

```lean
/-- Extraction grid exponent: `qE = max(qA, qD)` (TC-EFT eq. 11). -/
def BlockTrace.extractionExponent (t : BlockTrace) : ℤ :=
  max t.block.quantumExponent (outputQuantumExponent t.output.bits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.outputQuantumExponent](../Core/RoundOp.md#decl-70bb2de461b51682)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.coarse](Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.defaultExtraction](ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.Regression.algorithm1_cases](Regression/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.eftSnapshot](Regression/EFT.md#decl-3c783b17ffee5336), [TensorCore.accumulator_eq_retained](Extraction.md#decl-3d9c70abef819373), [TensorCore.lowPart_bound](Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.overlap_window_width](Algorithm1.md#decl-b8a661b7258cdacc)

</details>

</details>

<a id="decl-a31b735e46831516"></a>

<details>
<summary><code>TensorCore.BlockTrace.coarse</code></summary>

[Lean source](../../../TensorCore/EFT/Defs.lean#L13)

```lean
/-- Coarse retained components `hᵢ = trunc_qE(Tᵢ)` (Lemma IV.1). c is term zero. -/
def BlockTrace.coarse (t : BlockTrace) : List ℚ :=
  t.block.terms.map fun x => truncGrid x.value t.extractionExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.accumulator_eq_retained](Extraction.md#decl-3d9c70abef819373), [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e)

</details>

</details>

<a id="decl-a1697249f111893d"></a>

<details>
<summary><code>TensorCore.BlockTrace.lowParts</code></summary>

[Lean source](../../../TensorCore/EFT/Defs.lean#L17)

```lean
/-- Low components `εᵢ = Tᵢ − hᵢ`. -/
def BlockTrace.lowParts (t : BlockTrace) : List ℚ :=
  t.block.terms.map fun x => x.value - truncGrid x.value t.extractionExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.retainedLowParts](Defs.md#decl-9ea2d33eab35e3e8), [TensorCore.BlockTrace.scalarChecks](Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.Regression.eftSnapshot](Regression/EFT.md#decl-3c783b17ffee5336), [TensorCore.accumulator_eq_retained](Extraction.md#decl-3d9c70abef819373), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.defaultExtraction_components](ExtractionGrid.md#decl-1aa3ddadc14ca74e), [TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.lowPart_bound](Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.scalarChecks_all](Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-577bbe4b7295f20a"></a>

<details>
<summary><code>TensorCore.BlockTrace.retainedSum</code></summary>

[Lean source](../../../TensorCore/EFT/Defs.lean#L21)

```lean
/-- `H = Σ hᵢ`. -/
def BlockTrace.retainedSum (t : BlockTrace) : ℚ := sumQ t.coarse
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.coarse](Defs.md#decl-a31b735e46831516), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.scalarChecks](Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.accumulator_eq_retained](Extraction.md#decl-3d9c70abef819373), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.defaultExtraction_components](ExtractionGrid.md#decl-1aa3ddadc14ca74e), [TensorCore.overlap_eq_retained_sub_outputResidual](Extraction.md#decl-fc2dcdeff262fd49), [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.scalarChecks_all](Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarOverlap_exact](Scalar.md#decl-56c2b8a041adc97f), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-194a0aec6d268873"></a>

<details>
<summary><code>TensorCore.BlockTrace.overlap</code></summary>

[Lean source](../../../TensorCore/EFT/Defs.lean#L24)

```lean
/-- Signed overlap correction `ε_o = D − H` (Lemma IV.4). -/
def BlockTrace.overlap (t : BlockTrace) : ℚ := t.output.value - t.retainedSum
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.exactConsolidation](Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarChecks](Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.Regression.eftSnapshot](Regression/EFT.md#decl-3c783b17ffee5336), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.defaultExtraction_components](ExtractionGrid.md#decl-1aa3ddadc14ca74e), [TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.overlap_eq_retained_sub_outputResidual](Extraction.md#decl-fc2dcdeff262fd49), [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.scalarChecks_all](Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarOverlap_exact](Scalar.md#decl-56c2b8a041adc97f), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-9ea2d33eab35e3e8"></a>

<details>
<summary><code>TensorCore.BlockTrace.retainedLowParts</code></summary>

[Lean source](../../../TensorCore/EFT/Defs.lean#L27)

```lean
/-- Retained parts of the low components on the alignment grid, `φ(εᵢ) = trunc_qA(εᵢ)`. -/
def BlockTrace.retainedLowParts (t : BlockTrace) : List ℚ :=
  t.lowParts.map fun e => truncGrid e t.block.quantumExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.accumulator_eq_retained](Extraction.md#decl-3d9c70abef819373), [TensorCore.overlap_eq_retained_sub_outputResidual](Extraction.md#decl-fc2dcdeff262fd49)

</details>

</details>
