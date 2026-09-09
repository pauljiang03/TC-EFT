# TensorCore.TC.ExactAlignment

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0db1dbe57acfdb23"></a>

<details>
<summary><code>TensorCore.PreparedBlock.AlignmentExact</code></summary>

[Lean source](../../../TensorCore/TC/ExactAlignment.lean#L9)

```lean
/-- Sufficient alignment precision for this actual input, retaining raw metadata.
Zero terms place no restriction on the grid. This is not a monotonicity claim. -/
def PreparedBlock.AlignmentExact (b : PreparedBlock) : Prop :=
  ∀ t ∈ b.terms, t.significand ≠ 0 →
    b.quantumExponent ≤ t.rawScale - t.fractionalBits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4)

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20)

</details>

</details>

<a id="decl-42bb343ddba6bc20"></a>

<details>
<summary><code>TensorCore.exact_alignment_accumulator</code></summary>

[Lean source](../../../TensorCore/TC/ExactAlignment.lean#L13)

```lean
theorem exact_alignment_accumulator (b : PreparedBlock) (h : b.AlignmentExact) :
    b.accumulator = b.exactDot := by
  rw [accumulator_value, ← terms_value]
  congr 1
  apply List.map_congr_left
  intro t ht
  by_cases hz : t.significand = 0
  · simp [RawProduct.value, hz, truncGrid, truncCoeff, Rat.div_def]
    have hf : (0 : ℚ).floor = 0 := rfl
    rw [hf]
    simp
  · exact truncGrid_exact_of_grid t.significand (t.rawScale - t.fractionalBits)
      b.quantumExponent (h t ht hz)
```

**Supporting proofs:** [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.terms_value](StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.truncGrid_exact_of_grid](../Core/Truncation.md#decl-8a6ed0cd1522f575)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.AlignmentExact](ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncCoeff](../Core/Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c)

</details>

</details>

<a id="decl-dc5077740e6bb58c"></a>

<details>
<summary><code>TensorCore.evalBlock_exact_alignment</code></summary>

[Lean source](../../../TensorCore/TC/ExactAlignment.lean#L29)

```lean
/-- If padding makes every member exactly alignable, the canonical output is a
single FP32 RTZ conversion of the independently decoded ideal sum. -/
theorem evalBlock_exact_alignment {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (he : evalBlock x = .ok t) (ha : t.block.AlignmentExact) :
    exactDot x = some t.block.exactDot ∧
    round32 .towardZero t.block.exactDot = some t.output.bits := by
  have hout := evalPrepared_output (evalBlock_evalPrepared he)
  rw [exact_alignment_accumulator t.block ha] at hout
  exact ⟨by simp [exactDot, evalBlock_prepared he], hout⟩
```

**Supporting proofs:** [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.AlignmentExact](ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9)

</details>

</details>
