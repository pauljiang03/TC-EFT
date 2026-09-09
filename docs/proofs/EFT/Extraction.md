# TensorCore.EFT.Extraction

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-c35e73ca20c0ba9d"></a>

<details>
<summary><code>TensorCore.lowPart_bound</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L18)

```lean
/-- Lemma IV.1: every low component is strictly below the extraction grid. -/
theorem lowPart_bound (t : BlockTrace) :
    ∀ e ∈ t.lowParts, absQ e < pow2 t.extractionExponent := by
  intro e he
  simp only [BlockTrace.lowParts, List.mem_map] at he
  obtain ⟨x, _, rfl⟩ := he
  exact (alignment_residual x.value t.extractionExponent).2
```

**Supporting proofs:** [TensorCore.alignment_residual](../Core/Truncation.md#decl-8fb54cfc251e7721)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9a70c4b963b9ff7e"></a>

<details>
<summary><code>TensorCore.overlap_recovery</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L26)

```lean
/-- Theorem IV.5, overlap form: `S = D − ε_o + Σ εᵢ`. -/
theorem overlap_recovery (t : BlockTrace) :
    t.block.exactDot = t.output.value - t.overlap + sumQ t.lowParts := by
  have h := sum_stage_residuals (t.block.terms.map RawProduct.value)
    (fun x => truncGrid x t.extractionExponent)
  rw [terms_value] at h
  simp only [List.map_map, Function.comp_def] at h
  change t.block.exactDot = sumQ t.coarse + sumQ t.lowParts at h
  unfold BlockTrace.overlap BlockTrace.retainedSum
  grind
```

**Supporting proofs:** [TensorCore.sum_stage_residuals](../TC/StageResiduals.md#decl-fec712a2169085b5), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.coarse](Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.exactConsolidation_eq_corrected](Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d)

</details>

</details>

<a id="decl-3d9c70abef819373"></a>

<details>
<summary><code>TensorCore.accumulator_eq_retained</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L40)

```lean
/-- Lemma IV.3, summed: the aligned accumulator is `H + Σ φ(εᵢ)`. -/
theorem accumulator_eq_retained (t : BlockTrace) :
    t.block.accumulator = t.retainedSum + sumQ t.retainedLowParts := by
  have hτ : ∃ τ : ℕ, t.extractionExponent = t.block.quantumExponent + τ := by
    refine ⟨(t.extractionExponent - t.block.quantumExponent).toNat, ?_⟩
    unfold BlockTrace.extractionExponent
    omega
  obtain ⟨τ, hτ⟩ := hτ
  rw [accumulator_value]
  unfold BlockTrace.retainedSum BlockTrace.retainedLowParts BlockTrace.lowParts BlockTrace.coarse
  rw [List.map_map]
  have hsplit : (fun x : RawProduct => truncGrid x.value t.block.quantumExponent) =
      fun x => truncGrid x.value t.extractionExponent +
        truncGrid (x.value - truncGrid x.value t.extractionExponent) t.block.quantumExponent := by
    funext x
    rw [hτ]
    exact truncGrid_split x.value t.block.quantumExponent τ
  rw [hsplit, sumQ_map_add]
  rfl
```

**Supporting proofs:** [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.sumQ_map_add](../Core/Sum.md#decl-9a866541e41b56c9), [TensorCore.truncGrid_split](../Core/Truncation.md#decl-803d5c7e1ccf0196)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.coarse](Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.retainedLowParts](Defs.md#decl-9ea2d33eab35e3e8), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.outputQuantumExponent](../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.overlap_eq_retained_sub_outputResidual](Extraction.md#decl-fc2dcdeff262fd49)

</details>

</details>

<a id="decl-fc2dcdeff262fd49"></a>

<details>
<summary><code>TensorCore.overlap_eq_retained_sub_outputResidual</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L60)

```lean
/-- Lemma IV.4: `ε_o = Σ φ(εᵢ) − r_out`. -/
theorem overlap_eq_retained_sub_outputResidual (t : BlockTrace) :
    t.overlap = sumQ t.retainedLowParts - t.outputResidual := by
  have h := accumulator_eq_retained t
  unfold BlockTrace.overlap BlockTrace.outputResidual
  grind
```

**Supporting proofs:** [TensorCore.accumulator_eq_retained](Extraction.md#decl-3d9c70abef819373)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.outputResidual](../TC/Block.md#decl-d1c97ba3515d5cad), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedLowParts](Defs.md#decl-9ea2d33eab35e3e8), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3d45598c93a47213"></a>

<details>
<summary><code>TensorCore.BlockTrace.supportExponent</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L68)

```lean
/-- Common grid exponent for the low components: the finest term grid, or the extraction
grid if finer. Every `Tᵢ` and `hᵢ` is an integer multiple of `2^ℓ`. -/
def BlockTrace.supportExponent (t : BlockTrace) : ℤ :=
  (t.block.terms.map fun x => x.rawScale - x.fractionalBits).foldl min t.extractionExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.scalarChecks](Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.defaultExtraction_scalar](ExtractionGrid.md#decl-b88738f25d94e135), [TensorCore.scalarChecks_all](Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-a13088cbcb9f6e28"></a>

<details>
<summary><code>TensorCore.BlockTrace.lowCoefficients</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L72)

```lean
/-- Integer coefficients `zᵢ = εᵢ / 2^ℓ`. -/
def BlockTrace.lowCoefficients (t : BlockTrace) : List ℤ :=
  t.lowParts.map fun e => (e / pow2 t.supportExponent).floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarChecks](Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.scalarChecks_all](Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-8144db00332cc0f8"></a>

<details>
<summary><code>TensorCore.BlockTrace.scalarPredicate</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L80)

```lean
/-- The hypotheses of Theorem IV.9, Lemma IV.10, and Corollary IV.11, decided on the
actual components: a grid between `2^-149` and `2^104`, exact integer coefficients, an
absolute coefficient sum below `2^24`, representable `D`, `ε_o`, and `H`, and a final sum
`H + Σ εᵢ` in the finite range. This remains an exact-reference check:
`retained_add_low` proves that the range expression reconstructs the original ideal. -/
def BlockTrace.scalarPredicate (t : BlockTrace) : Bool :=
  decide (-149 ≤ t.supportExponent) && decide (t.supportExponent ≤ 104) &&
  (t.lowParts == t.lowCoefficients.map fun (z : ℤ) => (z : ℚ) * pow2 t.supportExponent) &&
  decide (magnitudeSum t.lowCoefficients < 2 ^ 24) &&
  representable32 t.output.value && representable32 t.overlap &&
  representable32 t.retainedSum &&
  decide (absQ (t.retainedSum + sumQ t.lowParts) ≤ maxFinite32)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representable32](../Core/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.Regression.eftSnapshot](Regression/EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.scalar64_corrects_midpoint](Regression/ScalarEFT.md#decl-18ee9a4ee42888ea), [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.scalarChecks_all](Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedIn_fp32_of_predicate](Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarCorrected_eq](Extraction.md#decl-f5da772603f2c94b), [TensorCore.scalarCorrected_rejects](Extraction.md#decl-2009b13f7b61d30c), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.tceft_correct](Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_eq_corrected](Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tceft_isSome_iff](Extraction.md#decl-bf4ac7118d2101bc)

</details>

</details>

<a id="decl-8c775638dbe095dd"></a>

<details>
<summary><code>TensorCore.BlockTrace.scalarChecks</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L90)

```lean
/-- Named diagnostics for the unchanged baseline predicate. These exact-arithmetic
checks are evidence about the specification, not bounded extraction operations. -/
def BlockTrace.scalarChecks (t : BlockTrace) : List (String × Bool) :=
  [("support_min", decide (-149 ≤ t.supportExponent)),
   ("support_max", decide (t.supportExponent ≤ 104)),
   ("integer_grid", t.lowParts == t.lowCoefficients.map fun (z : ℤ) =>
      (z : ℚ) * pow2 t.supportExponent),
   ("coefficient_budget", decide (magnitudeSum t.lowCoefficients < 2 ^ 24)),
   ("output_representable", representable32 t.output.value),
   ("overlap_representable", representable32 t.overlap),
   ("retained_representable", representable32 t.retainedSum),
   ("final_range", decide (absQ (t.retainedSum + sumQ t.lowParts) ≤ maxFinite32))]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representable32](../Core/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.scalarChecks_all](Extraction.md#decl-6e6d55a04a30d907)

</details>

</details>

<a id="decl-6e6d55a04a30d907"></a>

<details>
<summary><code>TensorCore.scalarChecks_all</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L102)

```lean
/-- Diagnostic conjunction is exactly the public predicate, including every guard. -/
theorem scalarChecks_all (t : BlockTrace) :
    (t.scalarChecks.all fun c => c.2) = t.scalarPredicate := by
  simp [BlockTrace.scalarChecks, BlockTrace.scalarPredicate, Bool.and_assoc]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarChecks](Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representable32](../Core/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b298427558415577"></a>

<details>
<summary><code>TensorCore.BlockTrace.scalarCorrectedUnchecked</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L109)

```lean
/-- Unchecked diagnostic implementation of Algorithm 1, scalar branch. This can return
incorrect bits when `scalarPredicate` fails; use `scalarCorrected` or `tceft`. It performs
naive FP32 summation of the low parts, `D ⊖ ε_o`, and one final nearest-even addition. Every operation is a correctly rounded FP32 addition. -/
def BlockTrace.scalarCorrectedUnchecked (t : BlockTrace) : Option F32 :=
  (naiveSum32 t.lowParts).bind fun etot =>
    (fp32Add t.output.value (-t.overlap)).bind fun h =>
      round32 .nearestEven (h + etot)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.fp32Add](../Core/ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.naiveSum32](../Core/ScalarSum.md#decl-928516c1237c62d4), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.Regression.broad_finite_unchecked_incorrect](Regression/EFT.md#decl-cb45e79b5c259faf), [TensorCore.Regression.eftSnapshot](Regression/EFT.md#decl-3c783b17ffee5336), [TensorCore.scalarCorrectedInUnchecked_fp32](Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_eq](Extraction.md#decl-f5da772603f2c94b), [TensorCore.scalarCorrected_rejects](Extraction.md#decl-2009b13f7b61d30c), [TensorCore.tceft_correct](Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_eq_corrected](Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tceft_isSome_iff](Extraction.md#decl-bf4ac7118d2101bc)

</details>

</details>

<a id="decl-d043d5f94dfed74a"></a>

<details>
<summary><code>TensorCore.BlockTrace.scalarCorrected</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L115)

```lean
/-- Safe public scalar correction: reject unless the sufficient predicate holds. -/
def BlockTrace.scalarCorrected (t : BlockTrace) : Option F32 :=
  if t.scalarPredicate then t.scalarCorrectedUnchecked else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.algorithm1](Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.tceft](Extraction.md#decl-7b07b124468a5e26), [TensorCore.Regression.broad_finite_unchecked_incorrect](Regression/EFT.md#decl-cb45e79b5c259faf), [TensorCore.Regression.scalar_public_r3](Regression/EFT.md#decl-deb2ed8170b801e3), [TensorCore.Regression.scalar_public_subnormal_rejected](Regression/EFT.md#decl-15c9e1f2ec694c3a), [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.algorithm1_scalar_iff](Algorithm1.md#decl-035c260a0676f872), [TensorCore.scalarCorrectedIn_fp32_of_predicate](Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarCorrected_eq](Extraction.md#decl-f5da772603f2c94b), [TensorCore.scalarCorrected_rejects](Extraction.md#decl-2009b13f7b61d30c), [TensorCore.tceft_correct](Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_eq_corrected](Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tceft_isSome_iff](Extraction.md#decl-bf4ac7118d2101bc)

</details>

</details>

<a id="decl-7b07b124468a5e26"></a>

<details>
<summary><code>TensorCore.BlockTrace.tceft</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L120)

```lean
/-- The scalar EFT: the scalar branch when its predicate holds, and `none` otherwise. A
failed predicate is a failure of this procedure, not a signal to compute something else. -/
def BlockTrace.tceft (t : BlockTrace) : Option F32 := t.scalarCorrected
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.eftSnapshot](Regression/EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.scalar_public_subnormal_rejected](Regression/EFT.md#decl-15c9e1f2ec694c3a), [TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.evalBlock_tceft_correct](Extraction.md#decl-c42bf0d990e653f7), [TensorCore.tceft_correct](Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_eq_corrected](Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tceft_isSome_iff](Extraction.md#decl-bf4ac7118d2101bc)

</details>

</details>

<a id="decl-da77fbfd62ee1185"></a>

<details>
<summary><code>TensorCore.retained_add_low</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L122)

```lean
theorem retained_add_low (t : BlockTrace) :
    t.retainedSum + sumQ t.lowParts = t.block.exactDot := by
  have h := overlap_recovery t
  unfold BlockTrace.overlap at h
  grind
```

**Supporting proofs:** [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de)

</details>

</details>

<a id="decl-421b3488061da23d"></a>

<details>
<summary><code>TensorCore.scalarCorrectedUnchecked_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L130)

```lean
/-- Theorem IV.9 and Lemma IV.10 applied: under the predicate, the scalar branch computes
exactly `RN(S)`. -/
theorem scalarCorrectedUnchecked_eq (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarCorrectedUnchecked = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.scalarPredicate at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨h1, h2⟩, hgrid⟩, hmag⟩, _⟩, _⟩, hH⟩, _⟩ := h
  have hsum : naiveSum32 t.lowParts = some (sumQ t.lowParts) := by
    rw [hgrid, naiveSum32_exact _ h1 h2 _ hmag, sum_coefficients]
  have hsub : fp32Add t.output.value (-t.overlap) = some (t.output.value + -t.overlap) := by
    apply fp32Add_exact
    have hr : t.output.value + -t.overlap = t.retainedSum := by
      unfold BlockTrace.overlap; grind
    rw [hr]
    exact representable32_finite hH
  unfold BlockTrace.scalarCorrectedUnchecked
  rw [hsum, hsub]
  simp only [Option.bind_some]
  congr 1
  have := overlap_recovery t
  grind
```

**Supporting proofs:** [TensorCore.fp32Add_exact](../Core/ScalarSum.md#decl-91c0a32b3579d248), [TensorCore.naiveSum32_exact](../Core/ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.overlap_recovery](Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.representable32_finite](../Core/ScalarSum.md#decl-04f29e613917ad68), [TensorCore.sum_coefficients](../Core/Exact.md#decl-005e2ad99fe60fa3)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.FiniteValue32](../Core/Defs.md#decl-916e7e459d399e32), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32Add](../Core/ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.naiveSum32](../Core/ScalarSum.md#decl-928516c1237c62d4), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representable32](../Core/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrected_eq](Extraction.md#decl-f5da772603f2c94b), [TensorCore.tceft_eq_corrected](Extraction.md#decl-942f125d26cb2d1b)

</details>

</details>

<a id="decl-f5da772603f2c94b"></a>

<details>
<summary><code>TensorCore.scalarCorrected_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L151)

```lean
/-- The guarded public helper preserves all previously justified successful results. -/
theorem scalarCorrected_eq (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarCorrected = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.scalarCorrected
  rw [if_pos h, scalarCorrectedUnchecked_eq t h]
```

**Supporting proofs:** [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933), [TensorCore.scalarCorrectedIn_fp32_of_predicate](Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de)

</details>

</details>

<a id="decl-2009b13f7b61d30c"></a>

<details>
<summary><code>TensorCore.scalarCorrected_rejects</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L157)

```lean
/-- The public helper refuses the known-unsafe branch when its predicate fails. -/
theorem scalarCorrected_rejects (t : BlockTrace) (h : t.scalarPredicate = false) :
    t.scalarCorrected = none := by simp [BlockTrace.scalarCorrected, h]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_bits_isSome_iff](Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29)

</details>

</details>

<a id="decl-57f834dbd8f945de"></a>

<details>
<summary><code>TensorCore.scalarCorrected_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L161)

```lean
/-- Corollary IV.11: the scalar branch returns the correctly rounded exact dot product. -/
theorem scalarCorrected_correct (t : BlockTrace) (h : t.scalarPredicate = true) :
    ∃ b, t.scalarCorrected = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [scalarCorrected_eq t h]
  apply round32_nearestEven_correct
  unfold BlockTrace.scalarPredicate at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  rw [← retained_add_low]
  exact h.2
```

**Supporting proofs:** [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.round32_nearestEven_correct](../Core/CorrectRounding.md#decl-213324c196c49312), [TensorCore.scalarCorrected_eq](Extraction.md#decl-f5da772603f2c94b)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representable32](../Core/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_exact_iff](Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.tceft_correct](Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_isSome_iff](Extraction.md#decl-bf4ac7118d2101bc)

</details>

</details>

<a id="decl-4cc1687d08757464"></a>

<details>
<summary><code>TensorCore.tceft_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L171)

```lean
/-- Whenever the scalar EFT returns a result, it is the correctly rounded exact sum. -/
theorem tceft_correct (t : BlockTrace) (b : F32) (h : t.tceft = some b) :
    NearestEven32 t.block.exactDot b := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected at h
  split at h
  · rename_i hp
    obtain ⟨b', hb', hn⟩ := scalarCorrected_correct t hp
    simp only [BlockTrace.scalarCorrected, if_pos hp] at hb'
    rw [hb'] at h
    cases Option.some.inj h
    exact hn
  · contradiction
```

**Supporting proofs:** [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.tceft](Extraction.md#decl-7b07b124468a5e26), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_correct](Algorithm1.md#decl-7c971273335df3a8), [TensorCore.evalBlock_tceft_correct](Extraction.md#decl-c42bf0d990e653f7)

</details>

</details>

<a id="decl-bf4ac7118d2101bc"></a>

<details>
<summary><code>TensorCore.tceft_isSome_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L184)

```lean
/-- The scalar EFT succeeds exactly when its predicate holds. -/
theorem tceft_isSome_iff (t : BlockTrace) : (t.tceft).isSome = true ↔ t.scalarPredicate = true := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected
  constructor
  · intro h
    split at h
    · assumption
    · simp at h
  · intro hp
    rw [if_pos hp]
    obtain ⟨b, hb, _⟩ := scalarCorrected_correct t hp
    simp only [BlockTrace.scalarCorrected, if_pos hp] at hb
    rw [hb]
    rfl
```

**Supporting proofs:** [TensorCore.scalarCorrected_correct](Extraction.md#decl-57f834dbd8f945de)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.tceft](Extraction.md#decl-7b07b124468a5e26), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_bits_eq_round](Encoded.md#decl-ff78455708a6f933)

</details>

</details>

<a id="decl-942f125d26cb2d1b"></a>

<details>
<summary><code>TensorCore.tceft_eq_corrected</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L199)

```lean
/-- Under the predicate, the scalar EFT and the exact-rational reference return the same bits. -/
theorem tceft_eq_corrected (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.tceft = t.corrected := by
  unfold BlockTrace.tceft BlockTrace.scalarCorrected
  rw [if_pos h, scalarCorrectedUnchecked_eq t h, corrected_eq_round_exactDot]
```

**Supporting proofs:** [TensorCore.corrected_eq_round_exactDot](../TC/StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.scalarCorrectedUnchecked_eq](Extraction.md#decl-421b3488061da23d)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.tceft](Extraction.md#decl-7b07b124468a5e26), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c42bf0d990e653f7"></a>

<details>
<summary><code>TensorCore.evalBlock_tceft_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Extraction.lean#L206)

```lean
/-- On a successful encoded-input evaluation, a scalar EFT result correctly rounds the
independent ideal sum. -/
theorem evalBlock_tceft_correct {p : Profile} {x : BlockInput p} {t : BlockTrace} {z : ℚ}
    {b : F32} (h : evalBlock x = .ok t) (hz : exactDot x = some z) (hb : t.tceft = some b) :
    NearestEven32 z b := by
  simp only [exactDot, evalBlock_prepared h, Option.map_some] at hz
  rw [← Option.some.inj hz]
  exact tceft_correct t b hb
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](../TC/StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.tceft_correct](Extraction.md#decl-4cc1687d08757464)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.tceft](Extraction.md#decl-7b07b124468a5e26), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
