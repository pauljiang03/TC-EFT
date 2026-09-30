# TensorCore.EFT.ExtractionGrid

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d0237d242e3d9256"></a>

<details>
<summary><code>TensorCore.ExtractionGrid</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L10)

```lean
structure ExtractionGrid (t : BlockTrace) where
  exponent : ℤ
  coarser : t.block.quantumExponent ≤ exponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.defaultExtraction](ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.extractAt](ExtractionGrid.md#decl-4fac256684e59d74), [TensorCore.ExtractionGrid.accumulator_eq_retained](ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coarse](ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.eq20_coefficients](ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.lowParts_on_grid](ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.ExtractionGrid.recovery](ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.retainedLowParts](ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.retained_add_low](ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrected](ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](ExtractionGrid.md#decl-2a11ac5f9735f162), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.extractAt_isSome_iff](ExtractionGrid.md#decl-452a7d9a3ed988fa)

</details>

</details>

<a id="decl-bf2bd98ffc3db444"></a>

<details>
<summary><code>TensorCore.BlockTrace.defaultExtraction</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L14)

```lean
def BlockTrace.defaultExtraction (t : BlockTrace) : ExtractionGrid t :=
  ⟨t.extractionExponent, Int.le_max_left _ _⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractionExponent](Defs.md#decl-f4644e4a3c22871b), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.outputQuantumExponent](../Numerics/RoundOp.md#decl-70bb2de461b51682)

<details>
<summary>Used by</summary>

[TensorCore.defaultExtraction_components](ExtractionGrid.md#decl-1aa3ddadc14ca74e), [TensorCore.defaultExtraction_scalar](ExtractionGrid.md#decl-b88738f25d94e135)

</details>

</details>

<a id="decl-4fac256684e59d74"></a>

<details>
<summary><code>TensorCore.BlockTrace.extractAt</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L18)

```lean
/-- Reject a grid finer than alignment, without changing the existing extractor. -/
def BlockTrace.extractAt (t : BlockTrace) (b : ℤ) : Option (ExtractionGrid t) :=
  if h : t.block.quantumExponent ≤ b then some ⟨b, h⟩ else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64)

<details>
<summary>Used by</summary>

[TensorCore.extractAt_isSome_iff](ExtractionGrid.md#decl-452a7d9a3ed988fa)

</details>

</details>

<a id="decl-452a7d9a3ed988fa"></a>

<details>
<summary><code>TensorCore.extractAt_isSome_iff</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L21)

```lean
theorem extractAt_isSome_iff (t : BlockTrace) (b : ℤ) :
    (t.extractAt b).isSome = true ↔ t.block.quantumExponent ≤ b := by
  simp [BlockTrace.extractAt]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.extractAt](ExtractionGrid.md#decl-4fac256684e59d74), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-fa64a28cdb2655d5"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.coarse</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L27)

```lean
def coarse (g : ExtractionGrid t) : List ℚ :=
  t.block.terms.map fun x => truncGrid x.value g.exponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.accumulator_eq_retained](ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0)

</details>

</details>

<a id="decl-9b1a30bc57169e40"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.lowParts</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L29)

```lean
def lowParts (g : ExtractionGrid t) : List ℚ :=
  t.block.terms.map fun x => x.value - truncGrid x.value g.exponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.accumulator_eq_retained](ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.eq20_coefficients](ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts_on_grid](ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.recovery](ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.retainedLowParts](ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.ExtractionGrid.retained_add_low](ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.defaultExtraction_components](ExtractionGrid.md#decl-1aa3ddadc14ca74e)

</details>

</details>

<a id="decl-2e41827366b1c9d0"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.retainedSum</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L31)

```lean
def retainedSum (g : ExtractionGrid t) : ℚ := sumQ g.coarse
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coarse](ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.accumulator_eq_retained](ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.ExtractionGrid.recovery](ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.retained_add_low](ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.defaultExtraction_components](ExtractionGrid.md#decl-1aa3ddadc14ca74e)

</details>

</details>

<a id="decl-83babfaeb37f9950"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.overlap</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L32)

```lean
def overlap (g : ExtractionGrid t) : ℚ := t.output.value - g.retainedSum
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.ExtractionGrid.recovery](ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.defaultExtraction_components](ExtractionGrid.md#decl-1aa3ddadc14ca74e)

</details>

</details>

<a id="decl-c761247ea38946db"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.retainedLowParts</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L33)

```lean
def retainedLowParts (g : ExtractionGrid t) : List ℚ :=
  g.lowParts.map fun e => truncGrid e t.block.quantumExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.accumulator_eq_retained](ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](ExtractionGrid.md#decl-f08a58a2cdf1dea5)

</details>

</details>

<a id="decl-1f823e542050f1b9"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.lowPart_bound</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L36)

```lean
theorem lowPart_bound (g : ExtractionGrid t) :
    ∀ e ∈ g.lowParts, absQ e < pow2 g.exponent := by
  intro e he
  obtain ⟨x, _, rfl⟩ := List.mem_map.mp he
  exact (alignment_residual x.value g.exponent).2
```

**Supporting proofs:** [TensorCore.alignment_residual](../Numerics/Truncation.md#decl-8fb54cfc251e7721)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_coefficients](ExtractionGrid.md#decl-98cbe3951ade59c5)

</details>

</details>

<a id="decl-613cd2d8bf397127"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.retained_add_low</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L42)

```lean
theorem retained_add_low (g : ExtractionGrid t) :
    g.retainedSum + sumQ g.lowParts = t.block.exactDot := by
  have h := sum_stage_residuals (t.block.terms.map RawProduct.value)
    (fun x => truncGrid x g.exponent)
  rw [terms_value] at h
  simpa [retainedSum, coarse, lowParts, List.map_map, Function.comp_def] using h.symm
```

**Supporting proofs:** [TensorCore.sum_stage_residuals](../TC/StageResiduals.md#decl-fec712a2169085b5), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.recovery](ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de)

</details>

</details>

<a id="decl-7c36a09e78670e2b"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.recovery</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L49)

```lean
theorem recovery (g : ExtractionGrid t) :
    t.block.exactDot = t.output.value - g.overlap + sumQ g.lowParts := by
  have := g.retained_add_low
  unfold overlap
  grind
```

**Supporting proofs:** [TensorCore.ExtractionGrid.retained_add_low](ExtractionGrid.md#decl-613cd2d8bf397127)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8a8af9009921f9cf"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.accumulator_eq_retained</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L55)

```lean
theorem accumulator_eq_retained (g : ExtractionGrid t) :
    t.block.accumulator = g.retainedSum + sumQ g.retainedLowParts := by
  have hτ : g.exponent = t.block.quantumExponent + (g.exponent - t.block.quantumExponent).toNat := by
    have := g.coarser
    omega
  rw [accumulator_value]
  unfold retainedSum retainedLowParts lowParts coarse
  rw [List.map_map]
  have hsplit : (fun x : RawProduct => truncGrid x.value t.block.quantumExponent) =
      fun x => truncGrid x.value g.exponent +
        truncGrid (x.value - truncGrid x.value g.exponent) t.block.quantumExponent := by
    funext x
    rw [hτ]
    exact truncGrid_split _ _ _
  rw [hsplit, sumQ_map_add]
  rfl
```

**Supporting proofs:** [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.sumQ_map_add](../Numerics/Sum.md#decl-9a866541e41b56c9), [TensorCore.truncGrid_split](../Numerics/Truncation.md#decl-803d5c7e1ccf0196)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coarse](ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.retainedLowParts](ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.quantumExponent](../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](ExtractionGrid.md#decl-f08a58a2cdf1dea5)

</details>

</details>

<a id="decl-f08a58a2cdf1dea5"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L72)

```lean
theorem overlap_eq_retained_sub_outputResidual (g : ExtractionGrid t) :
    g.overlap = sumQ g.retainedLowParts - t.outputResidual := by
  have := g.accumulator_eq_retained
  unfold overlap BlockTrace.outputResidual
  grind
```

**Supporting proofs:** [TensorCore.ExtractionGrid.accumulator_eq_retained](ExtractionGrid.md#decl-8a8af9009921f9cf)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.outputResidual](../TC/Block.md#decl-d1c97ba3515d5cad), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedLowParts](ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4e520e672b0502a5"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.coefficients</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L78)

```lean
def coefficients (g : ExtractionGrid t) (ℓ : ℤ) : List ℤ :=
  g.lowParts.map fun e => (e / pow2 ℓ).floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_coefficients](ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowParts_on_grid](ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a)

</details>

</details>

<a id="decl-fb6adb3614a7013f"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.lowParts_on_grid</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L83)

```lean
/-- Original terms on a common grid yield exact residual coefficients on it.
The grid need not be the finest nonzero residual grid, and all-zero terms work. -/
theorem lowParts_on_grid (g : ExtractionGrid t) (ℓ : ℤ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ) :
    g.lowParts = (g.coefficients ℓ).map fun (z : ℤ) => (z : ℚ) * pow2 ℓ := by
  unfold coefficients lowParts
  rw [List.map_map, List.map_map]
  apply List.map_congr_left
  intro x hx
  obtain ⟨z, hz⟩ := hinput x hx
  have he : pow2 g.exponent = ((2 ^ (g.exponent - ℓ).toNat : ℕ) : ℚ) * pow2 ℓ := by
    rw [← pow2_natCast, ← pow2_add]
    congr 1
    omega
  have hr : x.value - truncGrid x.value g.exponent =
      ((z - truncCoeff x.value g.exponent * (2 ^ (g.exponent - ℓ).toNat : ℕ) : ℤ) : ℚ) * pow2 ℓ := by
    rw [alignment_value, he, Rat.intCast_sub, Rat.intCast_mul, Rat.intCast_natCast]
    grind
  dsimp only [Function.comp_def]
  rw [hr, Rat.mul_div_cancel (Rat.ne_of_gt (pow2_pos ℓ)), Rat.floor_intCast]
```

**Supporting proofs:** [TensorCore.alignment_value](../Numerics/Truncation.md#decl-4fd20c57624d75c8), [TensorCore.pow2_add](../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Numerics/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](../Numerics/Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_coefficients](ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319)

</details>

</details>

<a id="decl-98cbe3951ade59c5"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.eq20_coefficients</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L104)

```lean
/-- Equation 20 derives the actual coefficient budget from the original input
grid, component count (including C), and chosen extraction exponent. -/
theorem eq20_coefficients (g : ExtractionGrid t) (ℓ : ℤ) (P : ℕ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ P) :
    magnitudeSum (g.coefficients ℓ) < 2 ^ P := by
  have hg := g.lowParts_on_grid ℓ hℓ hinput
  apply extraction_coefficient_bound _ g.exponent ℓ P hℓ
  · intro z hz
    apply g.lowPart_bound
    rw [hg]
    exact List.mem_map.mpr ⟨z, hz, rfl⟩
  · simpa [coefficients, lowParts] using hbudget
```

**Supporting proofs:** [TensorCore.ExtractionGrid.lowPart_bound](ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts_on_grid](ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.extraction_coefficient_bound](../Numerics/Binary/ResidualBudget.md#decl-19d0467f0a8a4946)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_exact_sum](ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319)

</details>

</details>

<a id="decl-802e16aa4b0d2cbf"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.eq20_exact_sum</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L116)

```lean
theorem eq20_exact_sum (g : ExtractionGrid t) (f : Format) (hf : f.WellFormed)
    (ℓ : ℤ) (hmin : f.emin - f.fractionBits ≤ ℓ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum (g.coefficients ℓ) : ℚ) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f g.lowParts = some (sumQ g.lowParts) := by
  rw [g.lowParts_on_grid ℓ hℓ hinput,
    naiveSumBinary_exact f hf ℓ hmin _ (g.eq20_coefficients ℓ _ hℓ hinput hbudget) hrange,
    sum_coefficients]
```

**Supporting proofs:** [TensorCore.ExtractionGrid.eq20_coefficients](ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.lowParts_on_grid](ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.naiveSumBinary_exact](../Numerics/Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.sum_coefficients](../Numerics/Exact.md#decl-005e2ad99fe60fa3)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Numerics/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](../Numerics/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.sumZ](../Numerics/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-555af608d3c6bc2a"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.scalarPredicate</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L126)

```lean
def scalarPredicate (g : ExtractionGrid t) (f : Format) (ℓ : ℤ) : Bool :=
  decide f.WellFormed && decide (f.emin - f.fractionBits ≤ ℓ) &&
  (g.lowParts == (g.coefficients ℓ).map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) &&
  decide (magnitudeSum (g.coefficients ℓ) < 2 ^ (f.fractionBits + 1)) &&
  decide ((magnitudeSum (g.coefficients ℓ) : ℚ) * pow2 ℓ ≤ f.maxFinite) &&
  representableBinary f t.output.value && representableBinary f g.overlap &&
  representableBinary f g.retainedSum &&
  decide (absQ (g.retainedSum + sumQ g.lowParts) ≤ maxFinite32)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Numerics/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Numerics/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_scalarPredicate](ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.scalarCorrected](ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](ExtractionGrid.md#decl-2a11ac5f9735f162), [TensorCore.defaultExtraction_scalar](ExtractionGrid.md#decl-b88738f25d94e135)

</details>

</details>

<a id="decl-c30f6fdadcf7a711"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.scalarCorrectedUnchecked</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L135)

```lean
def scalarCorrectedUnchecked (g : ExtractionGrid t) (f : Format) : Option F32 := do
  let low ← naiveSumBinary f g.lowParts
  let high ← binaryAdd f t.output.value (-g.overlap)
  round32 .nearestEven (high + low)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.binaryAdd](../Numerics/Binary/ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.naiveSumBinary](../Numerics/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.scalarCorrected](ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](ExtractionGrid.md#decl-2a11ac5f9735f162)

</details>

</details>

<a id="decl-477dde6ee16e0ccb"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.scalarCorrected</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L140)

```lean
def scalarCorrected (g : ExtractionGrid t) (f : Format) (ℓ : ℤ) : Option F32 :=
  if g.scalarPredicate f ℓ then g.scalarCorrectedUnchecked f else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](ExtractionGrid.md#decl-2a11ac5f9735f162), [TensorCore.defaultExtraction_scalar](ExtractionGrid.md#decl-b88738f25d94e135)

</details>

</details>

<a id="decl-f8de0b017f5795de"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.scalarCorrected_eq</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L143)

```lean
theorem scalarCorrected_eq (g : ExtractionGrid t) (f : Format) (ℓ : ℤ)
    (h : g.scalarPredicate f ℓ = true) :
    g.scalarCorrected f ℓ = round32 .nearestEven t.block.exactDot := by
  have hp := h
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨⟨hf, hmin⟩, hgrid⟩, hbudget⟩, hrange⟩, _⟩, _⟩, hH⟩, _⟩ := h
  have hs : naiveSumBinary f g.lowParts = some (sumQ g.lowParts) := by
    rw [hgrid, naiveSumBinary_exact f hf ℓ hmin _ hbudget hrange, sum_coefficients]
  have he : t.output.value + -g.overlap = g.retainedSum := by unfold overlap; grind
  have hh := binaryAdd_exact f hf t.output.value (-g.overlap)
    (by rw [he]; exact representableBinary_finite f hf hH)
  simp only [scalarCorrected, hp, ↓reduceIte, scalarCorrectedUnchecked, bind, hs, Option.bind_some,
    hh, he, retained_add_low]
```

**Supporting proofs:** [TensorCore.ExtractionGrid.retained_add_low](ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.binaryAdd_exact](../Numerics/Binary/ScalarSum.md#decl-3e2f947ce0bc4931), [TensorCore.naiveSumBinary_exact](../Numerics/Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.representableBinary_finite](../Numerics/Binary/ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.sum_coefficients](../Numerics/Exact.md#decl-005e2ad99fe60fa3)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.scalarCorrected](ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Numerics/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Numerics/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryAdd](../Numerics/Binary/ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.naiveSumBinary](../Numerics/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Numerics/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd), [TensorCore.sumZ](../Numerics/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b)

</details>

</details>

<a id="decl-b71ff86835e7406b"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.scalarCorrected_correct</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L157)

```lean
theorem scalarCorrected_correct (g : ExtractionGrid t) (f : Format) (ℓ : ℤ)
    (h : g.scalarPredicate f ℓ = true) :
    ∃ bits, g.scalarCorrected f ℓ = some bits ∧ NearestEven32 t.block.exactDot bits := by
  rw [g.scalarCorrected_eq f ℓ h]
  apply round32_nearestEven_correct
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq] at h
  simpa [retained_add_low] using h.2
```

**Supporting proofs:** [TensorCore.ExtractionGrid.retained_add_low](ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrected_eq](ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.round32_nearestEven_correct](../Numerics/CorrectRounding.md#decl-213324c196c49312)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.scalarCorrected](ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Numerics/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Numerics/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](ExtractionGrid.md#decl-2a11ac5f9735f162)

</details>

</details>

<a id="decl-2a11ac5f9735f162"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.scalarCorrected_isSome_iff</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L165)

```lean
theorem scalarCorrected_isSome_iff (g : ExtractionGrid t) (f : Format) (ℓ : ℤ) :
    (g.scalarCorrected f ℓ).isSome = true ↔ g.scalarPredicate f ℓ = true := by
  constructor
  · intro h
    unfold scalarCorrected at h
    split at h
    · assumption
    · contradiction
  · intro h
    obtain ⟨bits, hb, _⟩ := g.scalarCorrected_correct f ℓ h
    simp [hb]
```

**Supporting proofs:** [TensorCore.ExtractionGrid.scalarCorrected_correct](ExtractionGrid.md#decl-b71ff86835e7406b)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.scalarCorrected](ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.NearestEven32](../Numerics/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d4904f8d22c84319"></a>

<details>
<summary><code>TensorCore.ExtractionGrid.eq20_scalarPredicate</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L179)

```lean
/-- Eq.20 is a sufficient precision condition for the actual scalar correction.
The independent range and representability obligations remain explicit. -/
theorem eq20_scalarPredicate (g : ExtractionGrid t) (f : Format) (hf : f.WellFormed)
    (ℓ : ℤ) (hmin : f.emin - f.fractionBits ≤ ℓ) (hℓ : ℓ ≤ g.exponent)
    (hinput : ∀ x ∈ t.block.terms, ∃ z : ℤ, x.value = (z : ℚ) * pow2 ℓ)
    (hbudget : t.block.terms.length * (2 ^ (g.exponent - ℓ).toNat - 1) < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum (g.coefficients ℓ) : ℚ) * pow2 ℓ ≤ f.maxFinite)
    (hD : representableBinary f t.output.value = true)
    (hO : representableBinary f g.overlap = true)
    (hH : representableBinary f g.retainedSum = true)
    (hfinal : absQ t.block.exactDot ≤ maxFinite32) :
    g.scalarPredicate f ℓ = true := by
  have hgrid := g.lowParts_on_grid ℓ hℓ hinput
  have hcoeff := g.eq20_coefficients ℓ _ hℓ hinput hbudget
  simp only [scalarPredicate, Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq]
  exact ⟨⟨⟨⟨⟨⟨⟨⟨hf, hmin⟩, hgrid⟩, hcoeff⟩, hrange⟩, hD⟩, hO⟩, hH⟩,
    by simpa [g.retained_add_low] using hfinal⟩
```

**Supporting proofs:** [TensorCore.ExtractionGrid.eq20_coefficients](ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.lowParts_on_grid](ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.retained_add_low](ExtractionGrid.md#decl-613cd2d8bf397127)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ExtractionGrid](ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.coefficients](ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Numerics/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Numerics/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Numerics/Defs.md#decl-6cac0e89f6135a61), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.terms](../TC/Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Numerics/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Numerics/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1aa3ddadc14ca74e"></a>

<details>
<summary><code>TensorCore.defaultExtraction_components</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L198)

```lean
theorem defaultExtraction_components (t : BlockTrace) :
    t.defaultExtraction.lowParts = t.lowParts ∧ t.defaultExtraction.overlap = t.overlap ∧
      t.defaultExtraction.retainedSum = t.retainedSum := ⟨rfl, rfl, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.defaultExtraction](ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.ExtractionGrid.lowParts](ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.overlap](ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.retainedSum](ExtractionGrid.md#decl-2e41827366b1c9d0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b88738f25d94e135"></a>

<details>
<summary><code>TensorCore.defaultExtraction_scalar</code></summary>

[Lean source](../../../TensorCore/EFT/ExtractionGrid.lean#L202)

```lean
theorem defaultExtraction_scalar (t : BlockTrace) (f : Format) :
    t.defaultExtraction.scalarPredicate f t.supportExponent = t.scalarPredicateIn f ∧
      t.defaultExtraction.scalarCorrected f t.supportExponent = t.scalarCorrectedIn f := ⟨rfl, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.defaultExtraction](ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.ExtractionGrid.scalarCorrected](ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarPredicate](ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
