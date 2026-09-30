# TensorCore.Numerics.RoundingError

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4b7a39e93165716b"></a>

<details>
<summary><code>TensorCore.rtz_magnitude_residual</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundingError.lean#L8)

```lean
/-- The magnitude truncation loss is strictly smaller than the conversion grid. -/
theorem rtz_magnitude_residual (m : ℚ) :
    absQ (m - magnitudeRounded .towardZero m) < pow2 (convExp m - 23) := by
  let q := pow2 (convExp m - 23)
  have hq : 0 < q := pow2_pos _
  have hf := floor_frac_bounds (m / q)
  have he : m - magnitudeRounded .towardZero m = (m / q - (m / q).floor) * q := by
    have h := Rat.div_mul_cancel (a := m) (Rat.ne_of_gt hq)
    unfold magnitudeRounded convCoeff roundCoefficient
    change m - ((m / q).floor : ℚ) * q = _
    grind
  rw [he, absQ_mul_pos _ q hq, absQ_of_nonneg hf.1]
  have h := Rat.mul_lt_mul_of_pos_right hf.2 hq
  simpa using h
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.floor_frac_bounds](Rounding.md#decl-7ca84f988f037dce), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243)

</details>

</details>

<a id="decl-6594122b1c5d4243"></a>

<details>
<summary><code>TensorCore.rtz_signed_residual</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundingError.lean#L22)

```lean
theorem rtz_signed_residual (x : ℚ) :
    absQ (x - signedRounded .towardZero x) < pow2 (convExp (absQ x) - 23) := by
  have h := rtz_magnitude_residual (absQ x)
  unfold signedRounded
  by_cases hn : x < 0
  · simp only [hn, ↓reduceIte, absQ_of_neg hn] at h ⊢
    have he : x - -magnitudeRounded .towardZero (-x) =
      -(-x - magnitudeRounded .towardZero (-x)) := by grind
    rw [he, absQ_neg]; exact h
  · have hn' : 0 ≤ x := by grind
    simpa [hn, absQ_of_nonneg hn'] using h
```

**Supporting proofs:** [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_neg](Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b)

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53)

</details>

</details>

<a id="decl-456564416e37d7c3"></a>

<details>
<summary><code>TensorCore.output_residual_bound</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundingError.lean#L35)

```lean
/-- FP32 truncation's strict output loss bound, with its finite-range hypothesis. -/
theorem output_residual_bound (x : ℚ) (b : F32) (d : ℚ)
    (hr : absQ x ≤ maxFinite32) (hb : round32 .towardZero x = some b)
    (hd : value32 b = some d) :
    absQ (x - d) < pow2 (outputQuantumExponent b) := by
  by_cases hx : x = 0
  · subst x
    have hz : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [hz] at hb
    cases Option.some.inj hb
    have hv : value32 0 = some 0 := by decide +kernel
    rw [hv] at hd
    cases Option.some.inj hd
    have ha : absQ (0 - 0) = 0 := by decide +kernel
    rw [ha]; exact pow2_pos _
  · obtain ⟨b', hb', hd', _, he⟩ := round32_nonzero_spec .towardZero x hx hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hd'
    have hvalue := Option.some.inj hd'
    rw [hvalue]
    have hl := rtz_signed_residual x
    have hq := pow2_le_of_le he
    grind
```

**Supporting proofs:** [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.outputQuantumExponent](RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63)

</details>

</details>

<a id="decl-ad79fb234a6a8f53"></a>

<details>
<summary><code>TensorCore.rtz_residual_lt</code></summary>

[Lean source](../../../TensorCore/Numerics/RoundingError.lean#L60)

```lean
/-- Truncation toward zero loses less than the conversion grid of the input magnitude. -/
theorem rtz_residual_lt (x : ℚ) (b : F32) (d : ℚ) (hr : absQ x ≤ maxFinite32)
    (hb : round32 .towardZero x = some b) (hd : value32 b = some d) :
    absQ (x - d) < pow2 (convExp (absQ x) - 23) := by
  by_cases hx : x = 0
  · subst x
    have hz : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [hz] at hb
    cases Option.some.inj hb
    have hv : value32 0 = some 0 := by decide +kernel
    rw [hv] at hd
    cases Option.some.inj hd
    have ha : absQ (0 - 0) = 0 := by decide +kernel
    rw [ha]; exact pow2_pos _
  · obtain ⟨b', hb', hd', _, _⟩ := round32_nonzero_spec .towardZero x hx hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hd'
    rw [Option.some.inj hd']
    exact rtz_signed_residual x
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.outputQuantumExponent](RoundOp.md#decl-70bb2de461b51682), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
