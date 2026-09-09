# TensorCore.IEEE.Precision

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-c1146843cf5e28a6"></a>

<details>
<summary><code>TensorCore.IEEE.IntegerRound</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L10)

```lean
/-- A rounding direction applied to a nonnegative magnitude. -/
def IntegerRound (mode : BinaryRoundingMode) (negative : Bool) (t : ℚ) (k : ℤ) : Prop :=
  match mode with
  | .nearestEven =>
      (∀ j : ℤ, absQ (t - k) ≤ absQ (t - j)) ∧
      (∀ j : ℤ, j ≠ k → absQ (t - j) = absQ (t - k) → k % 2 = 0)
  | .towardZero => (k : ℚ) ≤ t ∧ ∀ j : ℤ, (j : ℚ) ≤ t → j ≤ k
  | .towardNegative => if negative then
      t ≤ (k : ℚ) ∧ ∀ j : ℤ, t ≤ (j : ℚ) → k ≤ j
    else (k : ℚ) ≤ t ∧ ∀ j : ℤ, (j : ℚ) ≤ t → j ≤ k
  | .towardPositive => if negative then
      (k : ℚ) ≤ t ∧ ∀ j : ℤ, (j : ℚ) ≤ t → j ≤ k
    else t ≤ (k : ℚ) ∧ ∀ j : ℤ, t ≤ (j : ℚ) → k ≤ j
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.PrecisionRound](Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.coefficient_correct](Precision.md#decl-9de0c69639190f6d), [TensorCore.IEEE.integerRound_unique](Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.precisionMagnitude_correct](Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionRound_unique](Precision.md#decl-a293a5d8f23d9070)

</details>

</details>

<a id="decl-9de0c69639190f6d"></a>

<details>
<summary><code>TensorCore.IEEE.coefficient_correct</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L23)

```lean
theorem coefficient_correct (mode : BinaryRoundingMode) (negative : Bool) (t : ℚ) :
    IntegerRound mode negative t (binaryCoefficient mode negative t) := by
  have hf : (t.floor : ℚ) ≤ t ∧ ∀ j : ℤ, (j : ℚ) ≤ t → j ≤ t.floor :=
    ⟨Rat.floor_le t, fun _ h => Rat.le_floor_iff.mpr h⟩
  have hc : t ≤ (t.ceil : ℚ) ∧ ∀ j : ℤ, t ≤ (j : ℚ) → t.ceil ≤ j :=
    ⟨Rat.le_ceil, fun _ h => Rat.ceil_le_iff.mpr h⟩
  cases mode with
  | nearestEven => exact ⟨rneInt_nearest t, fun j hn ht => rneInt_tie_even t j ht hn⟩
  | towardZero => exact hf
  | towardNegative => cases negative <;> first | exact hf | exact hc
  | towardPositive => cases negative <;> first | exact hf | exact hc
```

**Supporting proofs:** [TensorCore.rneInt_nearest](../Core/Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_tie_even](../Core/Rounding.md#decl-b3bf5bfe6d222ec7)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.IEEE.IntegerRound](Precision.md#decl-c1146843cf5e28a6), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionMagnitude_correct](Precision.md#decl-248cb65f71cd879e)

</details>

</details>

<a id="decl-5643af5ce25bcc8c"></a>

<details>
<summary><code>TensorCore.IEEE.integerRound_unique</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L37)

```lean
/-- Optimality plus even tie breaking determines one integer, not a set of
convenient witnesses that could alter exception behavior. -/
theorem integerRound_unique (mode : BinaryRoundingMode) (negative : Bool) (t : ℚ)
    (k : ℤ) (h : IntegerRound mode negative t k) :
    k = binaryCoefficient mode negative t := by
  have hf : ((k : ℚ) ≤ t ∧ ∀ j : ℤ, (j : ℚ) ≤ t → j ≤ k) → k = t.floor := by
    intro h
    exact Int.le_antisymm (Rat.le_floor_iff.mpr h.1) (h.2 _ (Rat.floor_le t))
  have hc : (t ≤ (k : ℚ) ∧ ∀ j : ℤ, t ≤ (j : ℚ) → k ≤ j) → k = t.ceil := by
    intro h
    exact Int.le_antisymm (h.2 _ Rat.le_ceil) (Rat.ceil_le_iff.mpr h.1)
  cases mode with
  | towardZero => exact hf h
  | towardNegative => cases negative <;> first | exact hf h | exact hc h
  | towardPositive => cases negative <;> first | exact hf h | exact hc h
  | nearestEven =>
    change k = rneInt t
    apply Classical.byContradiction
    intro hn
    have he := Rat.le_antisymm (h.1 (rneInt t)) (rneInt_nearest t k)
    have hkEven := h.2 (rneInt t) (Ne.symm hn) he.symm
    have hrEven := rneInt_tie_even t k he hn
    have hd := rneInt_dist_le_half t
    have hk : absQ (t - (k : ℚ)) ≤ (1 / 2 : ℚ) := by grind
    have hr : absQ (t - (rneInt t : ℚ)) ≤ (1 / 2 : ℚ) := by grind
    have bk := (absQ_le_iff _ _).mp hk
    have br := (absQ_le_iff _ _).mp hr
    have hkl : k ≤ rneInt t + 1 := by
      apply Rat.intCast_le_intCast.mp
      simp only [Rat.intCast_add, Rat.intCast_one]
      grind
    have hlk : rneInt t ≤ k + 1 := by
      apply Rat.intCast_le_intCast.mp
      simp only [Rat.intCast_add, Rat.intCast_one]
      grind
    omega
```

**Supporting proofs:** [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.rneInt_dist_le_half](../Core/Rounding.md#decl-926c4e219d946918), [TensorCore.rneInt_nearest](../Core/Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_tie_even](../Core/Rounding.md#decl-b3bf5bfe6d222ec7)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.IEEE.IntegerRound](Precision.md#decl-c1146843cf5e28a6), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionRound_unique](Precision.md#decl-a293a5d8f23d9070)

</details>

</details>

<a id="decl-273af52c676de10a"></a>

<details>
<summary><code>TensorCore.IEEE.precisionMagnitude</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L73)

```lean
/-- Positive magnitude rounded to the destination precision with no exponent limits. -/
def precisionMagnitude (f : Format) (mode : BinaryRoundingMode) (negative : Bool) (m : ℚ) : ℚ :=
  if m = 0 then 0 else
    let q := pow2 (magnitudeExponent m - f.fractionBits)
    (binaryCoefficient mode negative (m / q) : ℚ) * q
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.precisionMagnitude_correct](Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionMagnitude_le_max](Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionMagnitude_positive](Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precisionRound_unique](Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-ac46ea0f0a5d7f56"></a>

<details>
<summary><code>TensorCore.IEEE.PrecisionRound</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L78)

```lean
def PrecisionRound (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m u : ℚ) : Prop :=
  (m = 0 ∧ u = 0) ∨
  ∃ e : ℤ, ∃ k : ℤ, pow2 e ≤ m ∧ m < pow2 (e + 1) ∧
    IntegerRound mode negative (m / pow2 (e - f.fractionBits)) k ∧
    u = (k : ℚ) * pow2 (e - f.fractionBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.IntegerRound](Precision.md#decl-c1146843cf5e28a6), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.precisionMagnitude_correct](Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionRound_unique](Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

</details>

</details>

<a id="decl-248cb65f71cd879e"></a>

<details>
<summary><code>TensorCore.IEEE.precisionMagnitude_correct</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L85)

```lean
theorem precisionMagnitude_correct (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : ℚ) (hm : 0 ≤ m) :
    PrecisionRound f mode negative m (precisionMagnitude f mode negative m) := by
  by_cases hz : m = 0
  · exact Or.inl ⟨hz, by simp [precisionMagnitude, hz]⟩
  · have hs := magnitudeExponent_spec m (show 0 < m by grind)
    exact Or.inr ⟨magnitudeExponent m, _, hs.1, hs.2, coefficient_correct _ _ _,
      by simp [precisionMagnitude, hz]⟩
```

**Supporting proofs:** [TensorCore.IEEE.coefficient_correct](Precision.md#decl-9de0c69639190f6d), [TensorCore.magnitudeExponent_spec](../Core/Rounding.md#decl-22960168891fe5d1)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.IntegerRound](Precision.md#decl-c1146843cf5e28a6), [TensorCore.IEEE.PrecisionRound](Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

</details>

</details>

<a id="decl-a293a5d8f23d9070"></a>

<details>
<summary><code>TensorCore.IEEE.precisionRound_unique</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L95)

```lean
/-- The relational precision specification has exactly the computed magnitude. -/
theorem precisionRound_unique (f : Format) (mode : BinaryRoundingMode) (negative : Bool)
    (m u : ℚ) (h : PrecisionRound f mode negative m u) :
    u = precisionMagnitude f mode negative m := by
  rcases h with ⟨hm, hu⟩ | ⟨e, k, hl, hh, hk, hu⟩
  · simp [precisionMagnitude, hm, hu]
  · have hm : 0 < m := by have := pow2_pos e; grind
    have he := magnitudeExponent_eq_of_bounds m e hl hh
    have hc := integerRound_unique mode negative _ k hk
    simp [precisionMagnitude, Rat.ne_of_gt hm, he, ← hc, hu]
```

**Supporting proofs:** [TensorCore.IEEE.integerRound_unique](Precision.md#decl-5643af5ce25bcc8c), [TensorCore.magnitudeExponent_eq_of_bounds](../Core/Rounding.md#decl-bf009f29f695c88d), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.IntegerRound](Precision.md#decl-c1146843cf5e28a6), [TensorCore.IEEE.PrecisionRound](Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-01aabfab31a5714d"></a>

<details>
<summary><code>TensorCore.IEEE.precisionMagnitude_lower</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L105)

```lean
theorem precisionMagnitude_lower (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : ℚ) (hm : 0 < m) :
    pow2 (magnitudeExponent m) ≤ precisionMagnitude f mode negative m := by
  let e := magnitudeExponent m
  let q := pow2 (e - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  have hs := magnitudeExponent_spec m hm
  have hl : ((2 ^ f.fractionBits : ℕ) : ℚ) ≤ m / q := by
    apply le_div_of_mul_le _ _ _ hq
    change ((2 ^ f.fractionBits : ℕ) : ℚ) * pow2 (e - f.fractionBits) ≤ m
    rw [← f.binade_grid]; exact hs.1
  have hu : m / q < ((2 ^ (f.fractionBits + 1) : ℕ) : ℚ) := by
    apply (Rat.div_lt_iff hq).mpr
    change m < ((2 ^ (f.fractionBits + 1) : ℕ) : ℚ) * pow2 (e - f.fractionBits)
    rw [← f.next_binade_grid]; exact hs.2
  have hb := binaryCoefficient_bounds mode negative (m / q) (2 ^ (f.fractionBits + 1))
    (Rat.le_trans Rat.natCast_nonneg hl) hu
  have hfl : (2 ^ f.fractionBits : ℕ) ≤ (m / q).floor := Rat.le_floor_iff.mpr hl
  have hk : ((2 ^ f.fractionBits : ℕ) : ℤ) ≤ binaryCoefficient mode negative (m / q) := by omega
  rw [precisionMagnitude, if_neg (Rat.ne_of_gt hm), f.binade_grid]
  exact Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hk) (Rat.le_of_lt hq)
```

**Supporting proofs:** [TensorCore.Format.binade_grid](../Core/Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.next_binade_grid](../Core/Binary/ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.binaryCoefficient_bounds](../Core/Binary/ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.le_div_of_mul_le](../Core/Exact.md#decl-020e94a8d8a6259e), [TensorCore.magnitudeExponent_spec](../Core/Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.precisionMagnitude_positive](Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precision_floor_all](Precision.md#decl-bc21de7fff02bb8b)

</details>

</details>

<a id="decl-1150eb9378a6cdaf"></a>

<details>
<summary><code>TensorCore.IEEE.precisionMagnitude_positive</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L127)

```lean
theorem precisionMagnitude_positive (f : Format) (mode : BinaryRoundingMode)
    (negative : Bool) (m : ℚ) (hm : 0 < m) :
    0 < precisionMagnitude f mode negative m := by
  have := pow2_pos (magnitudeExponent m)
  have := precisionMagnitude_lower f mode negative m hm
  grind
```

**Supporting proofs:** [TensorCore.IEEE.precisionMagnitude_lower](Precision.md#decl-01aabfab31a5714d), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c4d94067e704664f"></a>

<details>
<summary><code>TensorCore.IEEE.precisionMagnitude_le_max</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L135)

```lean
/-- Rounding a magnitude already inside the finite range cannot signal overflow. -/
theorem precisionMagnitude_le_max (f : Format) (hf : f.WellFormed)
    (mode : BinaryRoundingMode) (negative : Bool) (m : ℚ)
    (hm : 0 ≤ m) (hr : m ≤ f.maxFinite) :
    precisionMagnitude f mode negative m ≤ f.maxFinite := by
  by_cases hz : m = 0
  · simp [precisionMagnitude, hz]
    exact Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt (pow2_pos _))
  have hp : 0 < m := by grind
  let e := magnitudeExponent m
  have he : e ≤ f.emax := by
    have hb := binaryConvExp_bounds f hf m hp hr
    unfold binaryConvExp at hb
    dsimp [e]; omega
  obtain ⟨j, hj⟩ := f.finite_on_grid
    ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℤ) f.emax e he
  have hmj : f.maxFinite = (j : ℚ) * pow2 (e - f.fractionBits) := hj
  have hq := pow2_pos (e - f.fractionBits)
  have ht : m / pow2 (e - f.fractionBits) ≤ (j : ℚ) := by
    apply Rat.le_of_mul_le_mul_right (c := pow2 (e - f.fractionBits)) _ hq
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq), ← hmj]
    exact hr
  have hc := binaryCoefficient_le_integer mode negative (m / pow2 (e - f.fractionBits)) j ht
  rw [precisionMagnitude, if_neg hz, hmj]
  exact Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)
```

**Supporting proofs:** [TensorCore.Format.finite_on_grid](../Core/Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.binaryCoefficient_le_integer](../Core/Binary/ConversionBounds.md#decl-e41347a8800b8463), [TensorCore.binaryConvExp_bounds](../Core/Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219)

</details>

</details>

<a id="decl-1c14649b5fbd1fc1"></a>

<details>
<summary><code>TensorCore.IEEE.precision_nearest_all</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L162)

```lean
/-- The normal-precision result is nearest among all bounded-significand dyadics,
even when a competitor uses a different exponent. -/
theorem precision_nearest_all (f : Format) (m : ℚ) (hm : 0 < m)
    (j e : ℤ) (hj : j.natAbs < 2 ^ (f.fractionBits + 1)) :
    absQ (m - precisionMagnitude f .nearestEven false m) ≤
      absQ (m - (j : ℚ) * pow2 (e - f.fractionBits)) := by
  let b := magnitudeExponent m
  have hs := magnitudeExponent_spec m hm
  by_cases he : b ≤ e
  · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
    rw [hz, precisionMagnitude, if_neg (Rat.ne_of_gt hm)]
    exact rne_grid_nearest_q m _ (pow2_pos _) z
  · have hsmall := f.finite_below_binade j e b hj (by omega)
    have hsmall' := (absQ_le_iff _ _).mp hsmall
    have hq := pow2_pos (b - f.fractionBits - 1)
    have hn := rne_grid_nearest_q m (pow2 (b - f.fractionBits)) (pow2_pos _)
      ((2 ^ f.fractionBits : ℕ) : ℤ)
    rw [Rat.intCast_natCast, ← f.binade_grid] at hn
    change absQ (m - (rneInt (m / pow2 (b - f.fractionBits)) : ℚ) *
      pow2 (b - f.fractionBits)) ≤ absQ (m - pow2 b) at hn
    rw [precisionMagnitude, if_neg (Rat.ne_of_gt hm)]
    change absQ (m - (rneInt (m / pow2 (b - f.fractionBits)) : ℚ) *
      pow2 (b - f.fractionBits)) ≤ _
    have h1 : 0 ≤ m - pow2 b := by grind
    have h2 : 0 ≤ m - (j : ℚ) * pow2 (e - f.fractionBits) := by grind
    rw [absQ_of_nonneg h1] at hn
    rw [absQ_of_nonneg h2]
    grind
```

**Supporting proofs:** [TensorCore.Format.binade_grid](../Core/Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finite_below_binade](../Core/Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](../Core/Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_of_nonneg](../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.magnitudeExponent_spec](../Core/Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120), [TensorCore.rne_grid_nearest_q](../Core/Binary/CorrectRounding.md#decl-ca751f6fe596d9e8)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bc21de7fff02bb8b"></a>

<details>
<summary><code>TensorCore.IEEE.precision_floor_all</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L191)

```lean
/-- Directed precision rounding is a greatest lower bound over every bounded-
significand dyadic, rather than only competitors on the selected grid. -/
theorem precision_floor_all (f : Format) (m : ℚ) (hm : 0 < m) :
    precisionMagnitude f .towardZero false m ≤ m ∧
    ∀ j e : ℤ, j.natAbs < 2 ^ (f.fractionBits + 1) →
      (j : ℚ) * pow2 (e - f.fractionBits) ≤ m →
      (j : ℚ) * pow2 (e - f.fractionBits) ≤ precisionMagnitude f .towardZero false m := by
  let b := magnitudeExponent m
  let q := pow2 (b - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  constructor
  · have h := Rat.mul_le_mul_of_nonneg_right (Rat.floor_le (m / q)) (Rat.le_of_lt hq)
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at h
    simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
  · intro j e hj hjm
    by_cases he : b ≤ e
    · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
      rw [hz] at hjm ⊢
      have hc : z ≤ (m / q).floor := Rat.le_floor_iff.mpr
        (le_div_of_mul_le _ _ _ hq hjm)
      have h := Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)
      simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
    · have hsmall := f.finite_below_binade j e b hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have hl := precisionMagnitude_lower f .towardZero false m hm
      have hp := pow2_pos (b - f.fractionBits - 1)
      grind
```

**Supporting proofs:** [TensorCore.Format.finite_below_binade](../Core/Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](../Core/Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.IEEE.precisionMagnitude_lower](Precision.md#decl-01aabfab31a5714d), [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.le_div_of_mul_le](../Core/Exact.md#decl-020e94a8d8a6259e), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8c61542341b05489"></a>

<details>
<summary><code>TensorCore.IEEE.precision_ceil_all</code></summary>

[Lean source](../../../TensorCore/IEEE/Precision.lean#L218)

```lean
/-- The corresponding least-upper-bound characterization, with unrestricted exponents. -/
theorem precision_ceil_all (f : Format) (m : ℚ) (hm : 0 < m) :
    m ≤ precisionMagnitude f .towardPositive false m ∧
    ∀ j e : ℤ, j.natAbs < 2 ^ (f.fractionBits + 1) →
      m ≤ (j : ℚ) * pow2 (e - f.fractionBits) →
      precisionMagnitude f .towardPositive false m ≤ (j : ℚ) * pow2 (e - f.fractionBits) := by
  let b := magnitudeExponent m
  let q := pow2 (b - f.fractionBits)
  have hq : 0 < q := pow2_pos _
  constructor
  · have h := Rat.mul_le_mul_of_nonneg_right (Rat.le_ceil (x := m / q)) (Rat.le_of_lt hq)
    rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at h
    simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
  · intro j e hj hmj
    by_cases he : b ≤ e
    · obtain ⟨z, hz⟩ := f.finite_on_grid j e b he
      rw [hz] at hmj ⊢
      have hdiv : m / q ≤ (z : ℚ) := by
        apply Rat.le_of_mul_le_mul_right (c := q) _ hq
        rw [Rat.div_mul_cancel (Rat.ne_of_gt hq)]
        exact hmj
      have hc : (m / q).ceil ≤ z := Rat.ceil_le_iff.mpr hdiv
      have h := Rat.mul_le_mul_of_nonneg_right (Rat.intCast_le_intCast.mpr hc) (Rat.le_of_lt hq)
      simpa [precisionMagnitude, Rat.ne_of_gt hm, binaryCoefficient] using h
    · have hsmall := f.finite_below_binade j e b hj (by omega)
      have hsmall' := (absQ_le_iff _ _).mp hsmall
      have hl := (magnitudeExponent_spec m hm).1
      have hp := pow2_pos (b - f.fractionBits - 1)
      grind
```

**Supporting proofs:** [TensorCore.Format.finite_below_binade](../Core/Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](../Core/Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.magnitudeExponent_spec](../Core/Rounding.md#decl-22960168891fe5d1), [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
