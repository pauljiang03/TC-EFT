# TensorCore.TC.Program.Bounds.Local

[Index](../../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-a4306ef04c6063f5"></a>

<details>
<summary><code>TensorCore.rawAlignmentBudget</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L8)

```lean
def rawAlignmentBudget (t : RawProduct) (q : ℤ) : ℚ :=
  if truncGrid t.value q = t.value then 0 else pow2 q
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_exact_product_alignment](../../../Gemm/Regression/GemmAnalysis.md#decl-e517a47b8f995a4f), [TensorCore.block_local_error](Local.md#decl-fb42d2d152a56c63), [TensorCore.checkGroup_sound](../GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.groupBound](../GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupBound_le_static](../GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_magnitude](../GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.groupBound_nonneg](../GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.rawAlignmentBudget_le](Local.md#decl-7c8beacba137af93), [TensorCore.rawAlignmentBudget_nonneg](Local.md#decl-30f7e6c784a8caa3), [TensorCore.rawAlignmentBudget_sound](Local.md#decl-1e83b17fa3bc236b), [TensorCore.rawAlignmentBudget_zero](Local.md#decl-16ff676e03bc4bb1)

</details>

</details>

<a id="decl-16ff676e03bc4bb1"></a>

<details>
<summary><code>TensorCore.rawAlignmentBudget_zero</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L11)

```lean
theorem rawAlignmentBudget_zero (t : RawProduct) (q : ℤ) (hv : t.value = 0) :
    rawAlignmentBudget t q = 0 := by simp [rawAlignmentBudget, hv, truncGrid_zero]
```

**Supporting proofs:** [TensorCore.truncGrid_zero](../../../Core/Truncation.md#decl-c8fd94be6ed59920)

**Definitions and types:** [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawAlignmentBudget](Local.md#decl-a4306ef04c6063f5), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](../GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.rawAlignmentBudget_sound](Local.md#decl-1e83b17fa3bc236b)

</details>

</details>

<a id="decl-30f7e6c784a8caa3"></a>

<details>
<summary><code>TensorCore.rawAlignmentBudget_nonneg</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L14)

```lean
theorem rawAlignmentBudget_nonneg (t : RawProduct) (q : ℤ) :
    0 ≤ rawAlignmentBudget t q := by
  unfold rawAlignmentBudget
  split
  · exact Rat.le_refl
  · exact Rat.le_of_lt (pow2_pos q)
```

**Supporting proofs:** [TensorCore.pow2_pos](../../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawAlignmentBudget](Local.md#decl-a4306ef04c6063f5), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.groupBound_nonneg](../GroupAnalysis.md#decl-b48fb2a8c56e4563)

</details>

</details>

<a id="decl-7c8beacba137af93"></a>

<details>
<summary><code>TensorCore.rawAlignmentBudget_le</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L21)

```lean
theorem rawAlignmentBudget_le (t : RawProduct) (q : ℤ) :
    rawAlignmentBudget t q ≤ pow2 q := by
  unfold rawAlignmentBudget
  split
  · exact Rat.le_of_lt (pow2_pos q)
  · exact Rat.le_refl
```

**Supporting proofs:** [TensorCore.pow2_pos](../../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawAlignmentBudget](Local.md#decl-a4306ef04c6063f5), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](../GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.groupBound_le_static](../GroupAnalysis.md#decl-dfb61f21eab0646b)

</details>

</details>

<a id="decl-1e83b17fa3bc236b"></a>

<details>
<summary><code>TensorCore.rawAlignmentBudget_sound</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L28)

```lean
theorem rawAlignmentBudget_sound (b : PreparedBlock) (E : ℤ)
    (hs : ScaleBounded b.terms E) (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E)
    (t : RawProduct) (ht : t ∈ b.terms) :
    absQ (t.value - truncGrid t.value b.quantumExponent) ≤
      rawAlignmentBudget t (E - b.profile.alignFraction) := by
  by_cases hz : t.significand = 0
  · have hv : t.value = 0 := by simp [RawProduct.value, hz]
    rw [rawAlignmentBudget_zero t _ hv, hv, truncGrid_zero, Rat.sub_self]
    decide +kernel
  · have hq := quantumExponent_le b E hs hfl t ht hz
    unfold rawAlignmentBudget
    split
    · rename_i he
      have hv : t.value = (truncCoeff t.value (E - b.profile.alignFraction) : ℚ) *
          pow2 (E - b.profile.alignFraction) := he.symm
      have hexact := truncGrid_exact_of_grid (truncCoeff t.value (E - b.profile.alignFraction))
        (E - b.profile.alignFraction) b.quantumExponent hq
      rw [← hv] at hexact
      rw [hexact]
      rw [Rat.sub_self]
      decide +kernel
    · exact Rat.le_trans (Rat.le_of_lt (alignment_residual t.value b.quantumExponent).2)
        (pow2_le_of_le hq)
```

**Supporting proofs:** [TensorCore.alignment_residual](../../../Core/Truncation.md#decl-8fb54cfc251e7721), [TensorCore.pow2_le_of_le](../../../Core/Exact.md#decl-064be6edf8651285), [TensorCore.quantumExponent_le](../../StaticBudget.md#decl-53da2dc9d7457364), [TensorCore.rawAlignmentBudget_zero](Local.md#decl-16ff676e03bc4bb1), [TensorCore.truncGrid_exact_of_grid](../../../Core/Truncation.md#decl-8a6ed0cd1522f575), [TensorCore.truncGrid_zero](../../../Core/Truncation.md#decl-c8fd94be6ed59920)

**Definitions and types:** [TensorCore.PreparedBlock](../../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.quantumExponent](../../Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](../../Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.ScaleBounded](../../StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawAlignmentBudget](Local.md#decl-a4306ef04c6063f5), [TensorCore.truncCoeff](../../../Core/Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_local_error](Local.md#decl-fb42d2d152a56c63)

</details>

</details>

<a id="decl-880c80c3d3f6df2b"></a>

<details>
<summary><code>TensorCore.sumQ_map_mono</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L52)

```lean
theorem sumQ_map_mono (xs : List α) (f g : α → ℚ)
    (h : ∀ x ∈ xs, f x ≤ g x) : sumQ (xs.map f) ≤ sumQ (xs.map g) := by
  induction xs with
  | nil => exact Rat.le_refl
  | cons x xs ih =>
    have hx := h x (by simp)
    have ht := ih (fun y hy => h y (by simp [hy]))
    simp only [List.map_cons, sumQ]
    grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](../../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_local_error](Local.md#decl-fb42d2d152a56c63), [TensorCore.groupBound_nonneg](../GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.productMass_nonneg](../GroupAnalysis.md#decl-b18fa7d0371588fa)

</details>

</details>

<a id="decl-97266aac0ec35351"></a>

<details>
<summary><code>TensorCore.accumulator_abs_le_mass</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L62)

```lean
theorem accumulator_abs_le_mass (b : PreparedBlock) :
    absQ b.accumulator ≤ sumQ (b.terms.map fun t => absQ t.value) := by
  rw [accumulator_value]
  have h := absQ_sumQ_le (b.terms.map fun t => truncGrid t.value b.quantumExponent)
  simp only [List.map_map, Function.comp_def] at h
  exact Rat.le_trans h (sumQ_map_abs_truncGrid_le b.terms b.quantumExponent)
```

**Supporting proofs:** [TensorCore.absQ_sumQ_le](../../../Core/Sum.md#decl-9728c1755d91fb0d), [TensorCore.accumulator_value](../../StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.sumQ_map_abs_truncGrid_le](../../StaticBudget.md#decl-387c2ed6b8a278d3)

**Definitions and types:** [TensorCore.PreparedBlock](../../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../../Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.quantumExponent](../../Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](../../Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.sumQ](../../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](../GroupAnalysis.md#decl-0eb9c5d6e9fead1f)

</details>

</details>

<a id="decl-0342238d71ef1dea"></a>

<details>
<summary><code>TensorCore.round32_rtz_truncGrid</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L69)

```lean
theorem round32_rtz_truncGrid (x : ℚ) (d : Finite32)
    (h : round32 .towardZero x = some d.bits) :
    d.value = truncGrid x (convExp (absQ x) - 23) := by
  have hd : value32 d.bits = some d.value := by simp [value32, d.valid, Finite32.value]
  by_cases hz : x = 0
  · subst x
    have h0 : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [h0] at h
    have hv : value32 0 = some 0 := by decide +kernel
    rw [← Option.some.inj h, hv] at hd
    rw [← Option.some.inj hd, truncGrid_zero]
  · obtain ⟨bits, hb, hv, _, _⟩ := round32_nonzero_spec .towardZero x hz (round32_range h)
    rw [h] at hb
    cases Option.some.inj hb
    rw [hd] at hv
    rw [Option.some.inj hv]
    unfold signedRounded magnitudeRounded convCoeff roundCoefficient truncGrid truncCoeff
    by_cases hn : x < 0
    · simp [hn, absQ_of_neg hn, Rat.intCast_neg, Rat.neg_mul]
    · simp [hn, absQ_of_nonneg (show 0 ≤ x by grind)]
```

**Supporting proofs:** [TensorCore.absQ_of_neg](../../../Core/Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](../../../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.round32_nonzero_spec](../../../Core/CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](../../../Core/RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.truncGrid_zero](../../../Core/Truncation.md#decl-c8fd94be6ed59920)

**Definitions and types:** [TensorCore.Decoded](../../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.RoundingMode](../../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](../../../Core/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.decode32](../../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.magnitudeRounded](../../../Core/RoundOp.md#decl-5eba0588921ede09), [TensorCore.outputQuantumExponent](../../../Core/RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../../../Core/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.round32](../../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundCoefficient](../../../Core/RoundOp.md#decl-7662cf06d1725fc5), [TensorCore.signedRounded](../../../Core/RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.truncCoeff](../../../Core/Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b), [TensorCore.value32](../../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.round32_rtz_abs_le](Local.md#decl-b5d2bbed636879a7), [TensorCore.round32_rtz_error_of_scale](Local.md#decl-3de60de11d813601)

</details>

</details>

<a id="decl-b5d2bbed636879a7"></a>

<details>
<summary><code>TensorCore.round32_rtz_abs_le</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L90)

```lean
theorem round32_rtz_abs_le (x : ℚ) (d : Finite32)
    (h : round32 .towardZero x = some d.bits) : absQ d.value ≤ absQ x := by
  rw [round32_rtz_truncGrid x d h]
  exact truncGrid_abs_le x _
```

**Supporting proofs:** [TensorCore.round32_rtz_truncGrid](Local.md#decl-0342238d71ef1dea), [TensorCore.truncGrid_abs_le](../../../Core/Truncation.md#decl-7a0e78c2723e16d6)

**Definitions and types:** [TensorCore.F32](../../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.RoundingMode](../../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convExp](../../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.round32](../../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](../GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.round32_rtz_error_of_scale](Local.md#decl-3de60de11d813601)

</details>

</details>

<a id="decl-3de60de11d813601"></a>

<details>
<summary><code>TensorCore.round32_rtz_error_of_scale</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L95)

```lean
theorem round32_rtz_error_of_scale (x : ℚ) (d : Finite32) (R : ℤ)
    (hR : -126 ≤ R) (hx : absQ x < pow2 (R + 1))
    (h : round32 .towardZero x = some d.bits) :
    absQ (x - d.value) ≤ pow2 (R - 23) := by
  by_cases hz : x = 0
  · have hd := round32_rtz_abs_le x d h
    have hn := absQ_nonneg d.value
    subst x
    have ha : absQ (0 - d.value) = absQ d.value := by
      rw [show 0 - d.value = -d.value by grind, absQ_neg]
    rw [ha]
    have h0 : absQ 0 = 0 := by decide +kernel
    rw [h0] at hd
    have := pow2_pos (R - 23)
    grind
  · have hc := convExp_le_of_lt (absQ x) (absQ_pos_of_ne_zero x hz) R hx
    have hq := pow2_le_of_le (show convExp (absQ x) - 23 ≤ R - 23 by omega)
    rw [round32_rtz_truncGrid x d h]
    exact Rat.le_trans (Rat.le_of_lt (alignment_residual x _).2) hq
```

**Supporting proofs:** [TensorCore.absQ_neg](../../../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_nonneg](../../../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.absQ_pos_of_ne_zero](../../../Core/CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.alignment_residual](../../../Core/Truncation.md#decl-8fb54cfc251e7721), [TensorCore.convExp_le_of_lt](../../../Core/Rounding.md#decl-49ec78234aca30b2), [TensorCore.pow2_le_of_le](../../../Core/Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../../../Core/Exact.md#decl-8f231b6648575120), [TensorCore.round32_rtz_abs_le](Local.md#decl-b5d2bbed636879a7), [TensorCore.round32_rtz_truncGrid](Local.md#decl-0342238d71ef1dea)

**Definitions and types:** [TensorCore.F32](../../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.RoundingMode](../../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convExp](../../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_local_error](Local.md#decl-fb42d2d152a56c63)

</details>

</details>

<a id="decl-fb42d2d152a56c63"></a>

<details>
<summary><code>TensorCore.block_local_error</code></summary>

[Lean source](../../../../../TensorCore/TC/Program/Bounds/Local.lean#L115)

```lean
theorem block_local_error (b : PreparedBlock) (d : Finite32) (E R : ℤ)
    (hs : ScaleBounded b.terms E) (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E)
    (hR : -126 ≤ R) (hm : absQ b.accumulator < pow2 (R + 1))
    (hout : round32 .towardZero b.accumulator = some d.bits) :
    absQ (b.exactDot - d.value) ≤
      sumQ (b.terms.map fun t => rawAlignmentBudget t (E - b.profile.alignFraction)) +
        pow2 (R - 23) := by
  have ha := absQ_sumQ_le b.alignmentResiduals
  have hb := sumQ_map_mono b.terms
    (fun t => absQ (t.value - truncGrid t.value b.quantumExponent))
    (fun t => rawAlignmentBudget t (E - b.profile.alignFraction))
    (fun t ht => rawAlignmentBudget_sound b E hs hfl t ht)
  simp only [PreparedBlock.alignmentResiduals, List.map_map, Function.comp_def] at ha
  have halign : absQ (sumQ b.alignmentResiduals) ≤
      sumQ (b.terms.map fun t => rawAlignmentBudget t (E - b.profile.alignFraction)) :=
    Rat.le_trans ha hb
  have ho := round32_rtz_error_of_scale b.accumulator d R hR hm hout
  have hi := block_residual_identity b d.value
  unfold PreparedBlock.extractReference at hi
  have ht := absQ_add_le (b.accumulator - d.value) (sumQ b.alignmentResiduals)
  have he : b.exactDot - d.value = (b.accumulator - d.value) + sumQ b.alignmentResiduals := by grind
  rw [he]
  grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../../../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_sumQ_le](../../../Core/Sum.md#decl-9728c1755d91fb0d), [TensorCore.block_residual_identity](../../StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.rawAlignmentBudget_sound](Local.md#decl-1e83b17fa3bc236b), [TensorCore.round32_rtz_error_of_scale](Local.md#decl-3de60de11d813601), [TensorCore.sumQ_map_mono](Local.md#decl-880c80c3d3f6df2b)

**Definitions and types:** [TensorCore.F32](../../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock](../../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../../Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](../../Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.exactDot](../../Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.extractReference](../../Block.md#decl-6cc810f8061e66a0), [TensorCore.PreparedBlock.quantumExponent](../../Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](../../Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](../../Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.RoundingMode](../../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.ScaleBounded](../../StaticBudget.md#decl-e94ea19e60b20a46), [TensorCore.absQ](../../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawAlignmentBudget](Local.md#decl-a4306ef04c6063f5), [TensorCore.round32](../../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkGroup_sound](../GroupAnalysis.md#decl-0eb9c5d6e9fead1f)

</details>

</details>
