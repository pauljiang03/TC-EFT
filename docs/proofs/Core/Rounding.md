# TensorCore.Core.Rounding

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-7ca84f988f037dce"></a>

<details>
<summary><code>TensorCore.floor_frac_bounds</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L10)

```lean
theorem floor_frac_bounds (t : ℚ) : 0 ≤ t - t.floor ∧ t - t.floor < 1 := by
  have h1 := Rat.floor_le t
  have h2 := Rat.lt_floor_add_one t
  simp only [Rat.intCast_add, Rat.intCast_one] at h2
  grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shiftRightOne_represents](../IEEE/LeanRounding.md#decl-8be2298798509a20), [TensorCore.rneInt_dist_le_half](Rounding.md#decl-926c4e219d946918), [TensorCore.rneInt_nearest](Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_tie_even](Rounding.md#decl-b3bf5bfe6d222ec7), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b)

</details>

</details>

<a id="decl-e5447611a083eb47"></a>

<details>
<summary><code>TensorCore.rneInt_cases</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L16)

```lean
theorem rneInt_cases (t : ℚ) :
    (rneInt t = t.floor + 1 ∧
      (1 < 2 * (t - t.floor) ∨ (2 * (t - t.floor) = 1 ∧ t.floor % 2 = 1))) ∨
    (rneInt t = t.floor ∧
      ¬(1 < 2 * (t - t.floor) ∨ (2 * (t - t.floor) = 1 ∧ t.floor % 2 = 1))) := by
  unfold rneInt; split <;> simp [*]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryCoefficient_bounds](Binary/ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.binaryCoefficient_le_integer](Binary/ConversionBounds.md#decl-e41347a8800b8463), [TensorCore.rneInt_dist_le_half](Rounding.md#decl-926c4e219d946918), [TensorCore.rneInt_nearest](Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_nonneg](Rounding.md#decl-6fb6bba59b59a133), [TensorCore.rneInt_tie_even](Rounding.md#decl-b3bf5bfe6d222ec7), [TensorCore.roundCoefficient_bounds](ConversionBounds.md#decl-73fca2c325f92d4a), [TensorCore.roundCoefficient_le_integer](ConversionBounds.md#decl-90034c8b2f8bb971)

</details>

</details>

<a id="decl-70143fba24fcdb46"></a>

<details>
<summary><code>TensorCore.intCast_le_or_succ_le</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L24)

```lean
/-- Integers are at least one apart, stated over the rationals. -/
theorem intCast_le_or_succ_le (j k : ℤ) : (j : ℚ) ≤ k ∨ (k : ℚ) + 1 ≤ j := by
  by_cases h : j ≤ k
  · exact Or.inl (Rat.intCast_le_intCast.mpr h)
  · right
    have : k + 1 ≤ j := by omega
    have h' := Rat.intCast_le_intCast.mpr this
    simpa [Rat.intCast_add, Rat.intCast_one] using h'
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.rneInt_nearest](Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_tie_even](Rounding.md#decl-b3bf5bfe6d222ec7)

</details>

</details>

<a id="decl-926c4e219d946918"></a>

<details>
<summary><code>TensorCore.rneInt_dist_le_half</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L32)

```lean
theorem rneInt_dist_le_half (t : ℚ) : 2 * absQ (t - rneInt t) ≤ 1 := by
  have h := floor_frac_bounds t
  rcases rneInt_cases t with ⟨hk, hc⟩ | ⟨hk, hc⟩ <;> rw [hk] <;>
    (try simp only [Rat.intCast_add, Rat.intCast_one]) <;> unfold absQ <;> split <;> grind
```

**Supporting proofs:** [TensorCore.floor_frac_bounds](Rounding.md#decl-7ca84f988f037dce), [TensorCore.rneInt_cases](Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.integerRound_unique](../IEEE/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.coefficient_error](../Gemm/ConversionBounds.md#decl-f64f69d45bdd3bc3), [TensorCore.coefficient_error](../Gemm/RoundingBudget.md#decl-f755f2a49fffbd90)

</details>

</details>

<a id="decl-17ccd373bb12baa1"></a>

<details>
<summary><code>TensorCore.rneInt_nearest</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L38)

```lean
/-- The selected integer is at least as close as every integer. -/
theorem rneInt_nearest (t : ℚ) (j : ℤ) : absQ (t - rneInt t) ≤ absQ (t - j) := by
  have h := floor_frac_bounds t
  have hj := intCast_le_or_succ_le j t.floor
  rcases rneInt_cases t with ⟨hk, hc⟩ | ⟨hk, hc⟩ <;> rw [hk] <;>
    (try simp only [Rat.intCast_add, Rat.intCast_one]) <;> unfold absQ <;> split <;> split <;>
    grind
```

**Supporting proofs:** [TensorCore.floor_frac_bounds](Rounding.md#decl-7ca84f988f037dce), [TensorCore.intCast_le_or_succ_le](Rounding.md#decl-70143fba24fcdb46), [TensorCore.rneInt_cases](Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.coefficient_correct](../IEEE/Precision.md#decl-9de0c69639190f6d), [TensorCore.IEEE.integerRound_unique](../IEEE/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_grid_nearest_q](Binary/CorrectRounding.md#decl-ca751f6fe596d9e8)

</details>

</details>

<a id="decl-b3bf5bfe6d222ec7"></a>

<details>
<summary><code>TensorCore.rneInt_tie_even</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L46)

```lean
/-- An equally close different integer forces a tie, and the selection is then even. -/
theorem rneInt_tie_even (t : ℚ) (j : ℤ) (htie : absQ (t - j) = absQ (t - rneInt t))
    (hne : j ≠ rneInt t) : rneInt t % 2 = 0 := by
  have h := floor_frac_bounds t
  have hj := intCast_le_or_succ_le j t.floor
  have hj2 := intCast_le_or_succ_le (t.floor + 1) j
  simp only [Rat.intCast_add, Rat.intCast_one] at hj2
  rcases rneInt_cases t with ⟨hk, hc⟩ | ⟨hk, hc⟩ <;> rw [hk] at htie hne ⊢
  · have hne' : (j : ℚ) ≠ (t.floor : ℚ) + 1 := by
      intro he
      apply hne
      have : (j : ℚ) = ((t.floor + 1 : ℤ) : ℚ) := by
        simpa [Rat.intCast_add, Rat.intCast_one] using he
      exact Rat.intCast_inj.mp this
    simp only [Rat.intCast_add, Rat.intCast_one] at htie
    have hf : 2 * (t - t.floor) = 1 := by
      unfold absQ at htie; split at htie <;> split at htie <;> grind
    rcases hc with hc | ⟨_, hodd⟩
    · exfalso; rw [hf] at hc; exact Rat.lt_irrefl hc
    · omega
  · have hne' : (j : ℚ) ≠ (t.floor : ℚ) := fun he => hne (Rat.intCast_inj.mp he)
    have hf : 2 * (t - t.floor) = 1 := by
      unfold absQ at htie; split at htie <;> split at htie <;> grind
    have : ¬ (t.floor % 2 = 1) := fun hodd => hc (Or.inr ⟨hf, hodd⟩)
    omega
```

**Supporting proofs:** [TensorCore.floor_frac_bounds](Rounding.md#decl-7ca84f988f037dce), [TensorCore.intCast_le_or_succ_le](Rounding.md#decl-70143fba24fcdb46), [TensorCore.rneInt_cases](Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.coefficient_correct](../IEEE/Precision.md#decl-9de0c69639190f6d), [TensorCore.IEEE.integerRound_unique](../IEEE/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165)

</details>

</details>

<a id="decl-f7facdfc71bea1f2"></a>

<details>
<summary><code>TensorCore.floor_nonneg_of_nonneg</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L71)

```lean
theorem floor_nonneg_of_nonneg (t : ℚ) (h : 0 ≤ t) : 0 ≤ t.floor := by
  have := Rat.lt_floor_add_one t
  simp only [Rat.intCast_add, Rat.intCast_one] at this
  have h2 : (-1 : ℚ) < t.floor := by grind
  have h3 : (-1 : ℤ) < t.floor := by
    have := Rat.intCast_lt_intCast (a := -1) (b := t.floor)
    simp only [Rat.intCast_neg, Rat.intCast_one] at this
    exact this.mp h2
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryCoefficient_bounds](Binary/ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.rneInt_nonneg](Rounding.md#decl-6fb6bba59b59a133), [TensorCore.roundCoefficient_bounds](ConversionBounds.md#decl-73fca2c325f92d4a)

</details>

</details>

<a id="decl-6fb6bba59b59a133"></a>

<details>
<summary><code>TensorCore.rneInt_nonneg</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L81)

```lean
theorem rneInt_nonneg (t : ℚ) (h : 0 ≤ t) : 0 ≤ rneInt t := by
  have := floor_nonneg_of_nonneg t h
  rcases rneInt_cases t with ⟨hk, _⟩ | ⟨hk, _⟩ <;> omega
```

**Supporting proofs:** [TensorCore.floor_nonneg_of_nonneg](Rounding.md#decl-f7facdfc71bea1f2), [TensorCore.rneInt_cases](Rounding.md#decl-e5447611a083eb47)

**Definitions and types:** [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-22960168891fe5d1"></a>

<details>
<summary><code>TensorCore.magnitudeExponent_spec</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L86)

```lean
/-- For positive x, `magnitudeExponent x` is the binary exponent: `2^e ≤ x < 2^(e+1)`. -/
theorem magnitudeExponent_spec (x : ℚ) (hx : 0 < x) :
    pow2 (magnitudeExponent x) ≤ x ∧ x < pow2 (magnitudeExponent x + 1) := by
  have hden : (0 : ℚ) < x.den := Rat.natCast_pos.mpr x.den_pos
  have hnum0 : x.num ≠ 0 := fun h => by
    have := Rat.num_eq_zero.mp h; subst this; exact Rat.lt_irrefl hx
  have hnumnn : 0 ≤ x.num := Rat.num_nonneg.mpr (Rat.le_of_lt hx)
  have hxd : x * x.den = x.num := by
    have h := Rat.num_divInt_den x
    rw [Rat.divInt_eq_div, Rat.intCast_natCast] at h
    calc x * x.den = (x.num / (x.den : ℚ)) * x.den := by rw [h]
      _ = x.num := Rat.div_mul_cancel (Rat.ne_of_gt hden)
  have hnR : ((x.num.natAbs : ℕ) : ℚ) = (x.num : ℚ) := by
    rw [← Rat.intCast_natCast, Int.natAbs_of_nonneg hnumnn]
  have hn0 : x.num.natAbs ≠ 0 := fun h => hnum0 (Int.natAbs_eq_zero.mp h)
  have hd0 : x.den ≠ 0 := Nat.pos_iff_ne_zero.mp x.den_pos
  have h1 : ((2 ^ x.num.natAbs.log2 : ℕ) : ℚ) ≤ x.num.natAbs :=
    Rat.natCast_le_natCast.mpr (Nat.log2_self_le hn0)
  have h2 : (x.num.natAbs : ℚ) < ((2 ^ (x.num.natAbs.log2 + 1) : ℕ) : ℚ) :=
    Rat.natCast_lt_natCast.mpr Nat.lt_log2_self
  have h3 : ((2 ^ x.den.log2 : ℕ) : ℚ) ≤ x.den :=
    Rat.natCast_le_natCast.mpr (Nat.log2_self_le hd0)
  have h4 : (x.den : ℚ) < ((2 ^ (x.den.log2 + 1) : ℕ) : ℚ) :=
    Rat.natCast_lt_natCast.mpr Nat.lt_log2_self
  rw [← pow2_natCast] at h1 h2 h3 h4
  rw [hnR] at h1 h2
  generalize hA : (x.num.natAbs.log2 : ℤ) = a at *
  generalize hB : (x.den.log2 : ℤ) = b at *
  have hcast1 : ((x.num.natAbs.log2 + 1 : ℕ) : ℤ) = a + 1 := by omega
  have hcast2 : ((x.den.log2 + 1 : ℕ) : ℤ) = b + 1 := by omega
  rw [hcast1] at h2; rw [hcast2] at h4
  have lo : pow2 (a - b - 1) < x := by
    have hq := pow2_pos (a - b - 1)
    have e1 : pow2 (a - b - 1) * pow2 (b + 1) = pow2 a := by
      rw [← pow2_add]; congr 1; omega
    have e2 : pow2 (a - b - 1) * x.den < pow2 (a - b - 1) * pow2 (b + 1) :=
      (Rat.mul_lt_mul_left hq).mpr h4
    rw [e1] at e2
    have e3 : pow2 (a - b - 1) * x.den < x * x.den := by rw [hxd]; grind
    exact Rat.lt_of_mul_lt_mul_right e3 (Rat.le_of_lt hden)
  have hi : x < pow2 (a - b + 1) := by
    have hq := pow2_pos (a - b + 1)
    have e1 : pow2 (a - b + 1) * pow2 b = pow2 (a + 1) := by
      rw [← pow2_add]; congr 1; omega
    have e2 : pow2 (a - b + 1) * pow2 b ≤ pow2 (a - b + 1) * x.den :=
      Rat.mul_le_mul_of_nonneg_left h3 (Rat.le_of_lt hq)
    rw [e1] at e2
    have e3 : x * x.den < pow2 (a - b + 1) * x.den := by rw [hxd]; grind
    exact Rat.lt_of_mul_lt_mul_right e3 (Rat.le_of_lt hden)
  have hdef : magnitudeExponent x = if x < pow2 (a - b) then a - b - 1 else a - b := by
    unfold magnitudeExponent; rw [hA, hB]
  rw [hdef]
  split
  · have : a - b - 1 + 1 = a - b := by omega
    rw [this]; exact ⟨Rat.le_of_lt lo, by assumption⟩
  · exact ⟨by grind, hi⟩
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionMagnitude_correct](../IEEE/Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionMagnitude_lower](../IEEE/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precision_ceil_all](../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binaryConvExp_bounds](Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_le_of_lt](Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.magnitudeScale_spec](../TC/Program/GroupAnalysis.md#decl-d51d916c1a50ab6d), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.scalarScale_spec](../Gemm/ScalarAnalysis.md#decl-ab7863fd9c2c72d3)

</details>

</details>

<a id="decl-b773da87e31ab58f"></a>

<details>
<summary><code>TensorCore.dist_scale</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L145)

```lean
/-- Scaling a grid distance by the quantum. -/
theorem dist_scale (m : ℚ) (q : ℚ) (hq : 0 < q) (j : ℤ) :
    absQ (m - j * q) = absQ (m / q - j) * q := by
  rw [← absQ_mul_pos _ q hq]
  have := Rat.div_mul_cancel (a := m) (Rat.ne_of_gt hq)
  congr 1
  grind
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_grid_nearest_q](Binary/CorrectRounding.md#decl-ca751f6fe596d9e8), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165)

</details>

</details>

<a id="decl-bf009f29f695c88d"></a>

<details>
<summary><code>TensorCore.magnitudeExponent_eq_of_bounds</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L153)

```lean
/-- Every finite value with exponent at least `e` is an integer multiple of `2^(e-23)`. -/
theorem magnitudeExponent_eq_of_bounds (x : ℚ) (e : ℤ) (h1 : pow2 e ≤ x)
    (h2 : x < pow2 (e + 1)) : magnitudeExponent x = e := by
  have hx : 0 < x := by have := pow2_pos e; grind
  obtain ⟨hlo, hhi⟩ := magnitudeExponent_spec x hx
  apply Classical.byContradiction
  intro hne
  rcases Int.lt_or_gt_of_ne hne with hlt | hgt
  · have := pow2_le_of_le (show magnitudeExponent x + 1 ≤ e by omega)
    grind
  · have := pow2_le_of_le (show e + 1 ≤ magnitudeExponent x by omega)
    grind
```

**Supporting proofs:** [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.magnitudeExponent_word](../EFT/Machine/Round.md#decl-47a33e7a1a646083), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../IEEE/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.precisionRound_unique](../IEEE/Precision.md#decl-a293a5d8f23d9070), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-1ab0c4e86c90f2f2"></a>

<details>
<summary><code>TensorCore.magnitudeExponent_le_of_lt</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L165)

```lean
theorem magnitudeExponent_le_of_lt (x : ℚ) (hx : 0 < x) (e : ℤ) (h : x < pow2 (e + 1)) :
    magnitudeExponent x ≤ e := by
  obtain ⟨hlo, _⟩ := magnitudeExponent_spec x hx
  apply Classical.byContradiction
  intro hne
  have hle : e + 1 ≤ magnitudeExponent x := by omega
  have := pow2_le_of_le hle
  grind
```

**Supporting proofs:** [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285)

**Definitions and types:** [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convExp_le_of_lt](Rounding.md#decl-49ec78234aca30b2), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab)

</details>

</details>

<a id="decl-49ec78234aca30b2"></a>

<details>
<summary><code>TensorCore.convExp_le_of_lt</code></summary>

[Lean source](../../../TensorCore/Core/Rounding.lean#L174)

```lean
theorem convExp_le_of_lt (x : ℚ) (hx : 0 < x) (e : ℤ) (h : x < pow2 (e + 1)) :
    convExp x ≤ max e (-126) := by
  unfold convExp emin32
  have := magnitudeExponent_le_of_lt x hx e h
  omega
```

**Supporting proofs:** [TensorCore.magnitudeExponent_le_of_lt](Rounding.md#decl-1ab0c4e86c90f2f2)

**Definitions and types:** [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.emin32](RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601)

</details>

</details>
