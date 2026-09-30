# TensorCore.Numerics.Truncation

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4fd20c57624d75c8"></a>

<details>
<summary><code>TensorCore.alignment_value</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L7)

```lean
theorem alignment_value (x : ℚ) (e : ℤ) :
    truncGrid x e = (truncCoeff x e : ℚ) * pow2 e := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196)

</details>

</details>

<a id="decl-26d336240b1cf59e"></a>

<details>
<summary><code>TensorCore.alignment_residual_bounds</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L11)

```lean
/-- Strict signed bounds, valid for every positive binary grid and either input sign. -/
theorem alignment_residual_bounds (x : ℚ) (e : ℤ) :
    -pow2 e < x - truncGrid x e ∧ x - truncGrid x e < pow2 e := by
  have hq := pow2_pos e
  have hq0 : 0 ≤ pow2 e := by grind
  have hqn : pow2 e ≠ 0 := by grind
  unfold truncGrid truncCoeff
  split
  · have lo := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (-x / pow2 e)) hq0
    rw [Rat.div_mul_cancel hqn] at lo
    have hi := (Rat.div_lt_iff hq).mp (Rat.lt_floor_add_one (-x / pow2 e))
    simp only [Rat.intCast_neg, Rat.intCast_add] at *
    grind
  · have lo := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (x / pow2 e)) hq0
    rw [Rat.div_mul_cancel hqn] at lo
    have hi := (Rat.div_lt_iff hq).mp (Rat.lt_floor_add_one (x / pow2 e))
    simp only [Rat.intCast_add] at *
    grind
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.alignment_residual](Truncation.md#decl-8fb54cfc251e7721)

</details>

</details>

<a id="decl-8fb54cfc251e7721"></a>

<details>
<summary><code>TensorCore.alignment_residual</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L29)

```lean
theorem alignment_residual (x : ℚ) (e : ℤ) :
    x = truncGrid x e + (x - truncGrid x e) ∧
    absQ (x - truncGrid x e) < pow2 e := by
  have h := alignment_residual_bounds x e
  unfold absQ
  split <;> grind
```

**Supporting proofs:** [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_low_bound](../Kernels/EFT/Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca)

</details>

</details>

<a id="decl-a85e1ebfe73b7b21"></a>

<details>
<summary><code>TensorCore.floor_sub_intCast</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L36)

```lean
theorem floor_sub_intCast (t : ℚ) (k : ℤ) : (t - k).floor = t.floor - k := by
  have h := Rat.floor_add_intCast (x := t) (y := -k)
  rw [Rat.intCast_neg] at h
  have : t - (k : ℚ) = t + -(k : ℚ) := by grind
  rw [this, h]
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.floor_grid_split](Truncation.md#decl-561160de9bbd3546)

</details>

</details>

<a id="decl-561160de9bbd3546"></a>

<details>
<summary><code>TensorCore.floor_grid_split</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L43)

```lean
theorem floor_grid_split (m : ℚ) (N : ℕ) :
    m.floor = (N : ℤ) * (m / (N : ℚ)).floor + (m - (N : ℚ) * (m / (N : ℚ)).floor).floor := by
  have hq : (N : ℚ) * ((m / (N : ℚ)).floor : ℚ) = (((N : ℤ) * (m / (N : ℚ)).floor : ℤ) : ℚ) := by
    rw [Rat.intCast_mul, Rat.intCast_natCast]
  rw [hq, floor_sub_intCast]
  omega
```

**Supporting proofs:** [TensorCore.floor_sub_intCast](Truncation.md#decl-a85e1ebfe73b7b21)

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196)

</details>

</details>

<a id="decl-a3484604d19e0df2"></a>

<details>
<summary><code>TensorCore.truncCoeff_nonneg_eq</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L50)

```lean
theorem truncCoeff_nonneg_eq (x : ℚ) (e : ℤ) (hx : 0 ≤ x) :
    truncCoeff x e = (x / pow2 e).floor := by
  unfold truncCoeff
  rw [if_neg (by grind)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196)

</details>

</details>

<a id="decl-ce4f20cb15188442"></a>

<details>
<summary><code>TensorCore.truncGrid_le_self</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L55)

```lean
theorem truncGrid_le_self (x : ℚ) (e : ℤ) (hx : 0 ≤ x) : truncGrid x e ≤ x := by
  have hq := pow2_pos e
  unfold truncGrid
  rw [truncCoeff_nonneg_eq x e hx]
  have := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (x / pow2 e)) (Rat.le_of_lt hq)
  rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at this
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.truncCoeff_nonneg_eq](Truncation.md#decl-a3484604d19e0df2)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c8fd94be6ed59920"></a>

<details>
<summary><code>TensorCore.truncGrid_zero</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L62)

```lean
theorem truncGrid_zero (e : ℤ) : truncGrid 0 e = 0 := by
  unfold truncGrid truncCoeff
  rw [if_neg (by decide +kernel), Rat.div_def, Rat.zero_mul, ← Rat.intCast_zero,
    Rat.floor_intCast]
  simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c)

</details>

</details>

<a id="decl-5a536b3a975b733c"></a>

<details>
<summary><code>TensorCore.truncGrid_neg</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L68)

```lean
theorem truncGrid_neg (z : ℚ) (e : ℤ) : truncGrid (-z) e = -truncGrid z e := by
  by_cases hz0 : z = 0
  · subst hz0
    rw [Rat.neg_zero, truncGrid_zero]
    simp
  · unfold truncGrid truncCoeff
    by_cases hz : z < 0
    · rw [if_pos hz, if_neg (by grind)]
      rw [Rat.intCast_neg]
      grind
    · rw [if_neg hz, if_pos (by grind)]
      rw [Rat.intCast_neg]
      grind
```

**Supporting proofs:** [TensorCore.truncGrid_zero](Truncation.md#decl-c8fd94be6ed59920)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196)

</details>

</details>

<a id="decl-803d5c7e1ccf0196"></a>

<details>
<summary><code>TensorCore.truncGrid_split</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L83)

```lean
/-- `trunc_qA(x) = trunc_qE(x) + trunc_qA(x − trunc_qE(x))` for `qE = 2^τ · qA`. -/
theorem truncGrid_split (x : ℚ) (a : ℤ) (τ : ℕ) :
    truncGrid x a = truncGrid x (a + τ) + truncGrid (x - truncGrid x (a + τ)) a := by
  have hqa := pow2_pos a
  have hne := Rat.ne_of_gt hqa
  have hN : pow2 (a + τ) = pow2 a * ((2 ^ τ : ℕ) : ℚ) := by
    rw [pow2_add, pow2_natCast]
  have hNpos : (0 : ℚ) < ((2 ^ τ : ℕ) : ℚ) := Rat.natCast_pos.mpr (Nat.two_pow_pos τ)
  have hNne : ((2 ^ τ : ℕ) : ℚ) ≠ 0 := Rat.ne_of_gt hNpos
  have hqEne : pow2 a * ((2 ^ τ : ℕ) : ℚ) ≠ 0 := Rat.ne_of_gt (Rat.mul_pos hqa hNpos)
  have key : ∀ y : ℚ, 0 ≤ y →
      truncGrid y a = truncGrid y (a + τ) + truncGrid (y - truncGrid y (a + τ)) a := by
    intro y hy
    have hyq : y / pow2 a * pow2 a = y := Rat.div_mul_cancel hne
    have hmq : 0 ≤ y / pow2 a := by
      have := Rat.div_lt_iff (a := y) (c := 0) hqa
      grind
    generalize y / pow2 a = m at hyq hmq
    subst hyq
    have hfloorN : ((m / ((2 ^ τ : ℕ) : ℚ)).floor : ℚ) ≤ m / ((2 ^ τ : ℕ) : ℚ) :=
      Rat.floor_le _
    have hdivN : m / ((2 ^ τ : ℕ) : ℚ) * ((2 ^ τ : ℕ) : ℚ) = m := Rat.div_mul_cancel hNne
    have h1 : truncGrid (m * pow2 a) a = ((m.floor : ℤ) : ℚ) * pow2 a := by
      rw [alignment_value, truncCoeff_nonneg_eq _ _ hy, Rat.mul_div_cancel hne]
    have hcoarse : m * pow2 a / pow2 (a + τ) = m / ((2 ^ τ : ℕ) : ℚ) := by
      rw [hN]
      have : m * pow2 a = m / ((2 ^ τ : ℕ) : ℚ) * (pow2 a * ((2 ^ τ : ℕ) : ℚ)) := by grind
      rw [this, Rat.mul_div_cancel hqEne]
    have h2 : truncGrid (m * pow2 a) (a + τ) =
        (((m / ((2 ^ τ : ℕ) : ℚ)).floor : ℤ) : ℚ) * (pow2 a * ((2 ^ τ : ℕ) : ℚ)) := by
      rw [alignment_value, truncCoeff_nonneg_eq _ _ hy, hcoarse, hN]
    have hrem_eq : m * pow2 a - truncGrid (m * pow2 a) (a + τ) =
        (m - ((2 ^ τ : ℕ) : ℚ) * (((m / ((2 ^ τ : ℕ) : ℚ)).floor : ℤ) : ℚ)) * pow2 a := by
      rw [h2]; grind
    have hrem_nonneg :
        0 ≤ m - ((2 ^ τ : ℕ) : ℚ) * (((m / ((2 ^ τ : ℕ) : ℚ)).floor : ℤ) : ℚ) := by
      have := Rat.mul_le_mul_of_nonneg_right hfloorN (Rat.le_of_lt hNpos)
      rw [hdivN] at this
      grind
    have h3 : truncGrid (m * pow2 a - truncGrid (m * pow2 a) (a + τ)) a =
        (((m - ((2 ^ τ : ℕ) : ℚ) * (((m / ((2 ^ τ : ℕ) : ℚ)).floor : ℤ) : ℚ)).floor : ℤ) : ℚ) *
          pow2 a := by
      rw [hrem_eq, alignment_value,
        truncCoeff_nonneg_eq _ _ (Rat.mul_nonneg hrem_nonneg (Rat.le_of_lt hqa)),
        Rat.mul_div_cancel hne]
    rw [h3, h1, h2, floor_grid_split m (2 ^ τ), Rat.intCast_add, Rat.intCast_mul,
      Rat.intCast_natCast]
    grind
  by_cases hx : 0 ≤ x
  · exact key x hx
  · have h := key (-x) (by grind)
    rw [truncGrid_neg, truncGrid_neg] at h
    have h2 : -x - -truncGrid x (a + τ) = -(x - truncGrid x (a + τ)) := by grind
    rw [h2, truncGrid_neg] at h
    grind
```

**Supporting proofs:** [TensorCore.alignment_value](Truncation.md#decl-4fd20c57624d75c8), [TensorCore.floor_grid_split](Truncation.md#decl-561160de9bbd3546), [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.truncCoeff_nonneg_eq](Truncation.md#decl-a3484604d19e0df2), [TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373)

</details>

</details>

<a id="decl-03b847921a9aec6d"></a>

<details>
<summary><code>TensorCore.truncCoeff_of_grid</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L139)

```lean
/-- A term already on the grid keeps its coefficient. -/
theorem truncCoeff_of_grid (k e : ℤ) : truncCoeff ((k : ℚ) * pow2 e) e = k := by
  have hne := Rat.ne_of_gt (pow2_pos e)
  unfold truncCoeff
  split
  · rw [show -((k : ℚ) * pow2 e) = ((-k : ℤ) : ℚ) * pow2 e by
        rw [Rat.intCast_neg]; grind,
      Rat.mul_div_cancel hne, Rat.floor_intCast]
    omega
  · rw [Rat.mul_div_cancel hne, Rat.floor_intCast]
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-fc0fb5f55225cc0e"></a>

<details>
<summary><code>TensorCore.truncCoeff_abs_le</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L150)

```lean
/-- Truncation never increases the magnitude of a scaled value. -/
theorem truncCoeff_abs_le (x : ℚ) (e : ℤ) :
    ((truncCoeff x e).natAbs : ℚ) ≤ absQ x / pow2 e := by
  have hp := pow2_pos e
  unfold truncCoeff
  split
  · rename_i hx
    have hn : 0 ≤ -x / pow2 e := by
      have := Rat.div_lt_iff (a := -x) (c := 0) hp
      grind
    have hf : 0 ≤ (-x / pow2 e).floor := Rat.le_floor_iff.mpr hn
    rw [Int.natAbs_neg, ← Rat.intCast_natCast, Int.natAbs_of_nonneg hf, absQ_of_neg hx]
    exact Rat.floor_le _
  · rename_i hx
    have hn : 0 ≤ x / pow2 e := by
      have := Rat.div_lt_iff (a := x) (c := 0) hp
      grind
    have hf : 0 ≤ (x / pow2 e).floor := Rat.le_floor_iff.mpr hn
    rw [← Rat.intCast_natCast, Int.natAbs_of_nonneg hf, absQ_of_nonneg (by grind)]
    exact Rat.floor_le _
```

**Supporting proofs:** [TensorCore.absQ_of_neg](Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6)

</details>

</details>

<a id="decl-7a0e78c2723e16d6"></a>

<details>
<summary><code>TensorCore.truncGrid_abs_le</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L172)

```lean
/-- Two integer magnitude bits plus F fractional bits suffice for each aligned term. -/

theorem truncGrid_abs_le (x : ℚ) (e : ℤ) : absQ (truncGrid x e) ≤ absQ x := by
  have hq := pow2_pos e
  have h := truncCoeff_abs_le x e
  unfold truncGrid
  rw [absQ_mul_pos _ _ hq, absQ_intCast]
  have := Rat.mul_le_mul_of_nonneg_right h (Rat.le_of_lt hq)
  rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at this
```

**Supporting proofs:** [TensorCore.absQ_intCast](Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5fd2d7fb322fdc95"></a>

<details>
<summary><code>TensorCore.truncGrid_fixed</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L180)

```lean
theorem truncGrid_fixed (k e : ℤ) : truncGrid ((k : ℚ) * pow2 e) e = (k : ℚ) * pow2 e := by
  have hn : pow2 e ≠ 0 := Rat.ne_of_gt (pow2_pos e)
  unfold truncGrid truncCoeff
  split
  · have he : -((k : ℚ) * pow2 e) / pow2 e = ((-k : ℤ) : ℚ) := by
      rw [← Rat.neg_mul, Rat.mul_div_cancel hn, Rat.intCast_neg]
    rw [he, Rat.floor_intCast]
    simp
  · rw [Rat.mul_div_cancel hn, Rat.floor_intCast]
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.truncGrid_exact_of_grid](Truncation.md#decl-8a6ed0cd1522f575)

</details>

</details>

<a id="decl-8a6ed0cd1522f575"></a>

<details>
<summary><code>TensorCore.truncGrid_exact_of_grid</code></summary>

[Lean source](../../../TensorCore/Numerics/Truncation.lean#L190)

```lean
theorem truncGrid_exact_of_grid (k scale grid : ℤ) (h : grid ≤ scale) :
    truncGrid ((k : ℚ) * pow2 scale) grid = (k : ℚ) * pow2 scale := by
  obtain ⟨j, hj⟩ := finite_on_grid k (scale + 23) (grid + 23) (by omega)
  have hs : scale + 23 - 23 = scale := by omega
  have hg : grid + 23 - 23 = grid := by omega
  rw [hs, hg] at hj
  rw [hj, truncGrid_fixed]
```

**Supporting proofs:** [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20)

</details>

</details>
