# TensorCore.Scalar.LeanRounding

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-45511da2f3f29c76"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.AccuracyRepresents</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L12)

```lean
/-- Meaning of Lean's accuracy metadata relative to an exact rational input. -/
def AccuracyRepresents (a : Accuracy) (t : ℚ) (m : ℕ) : Prop :=
  t.floor = (m : ℤ) ∧ match a with
  | .exact => t = (m : ℚ)
  | .inexact .lt => 0 < t - (m : ℚ) ∧ 2 * (t - (m : ℚ)) < 1
  | .inexact .eq => 2 * (t - (m : ℚ)) = 1
  | .inexact .gt => 1 < 2 * (t - (m : ℚ))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.accuracy_round_eq_rne](LeanRounding.md#decl-1e62b5285da24aef), [TensorCore.IEEE.LeanBridge.shiftRightOne_represents](LeanRounding.md#decl-8be2298798509a20), [TensorCore.IEEE.LeanBridge.shiftRight_represents](LeanRounding.md#decl-7f6354812c57ad44), [TensorCore.IEEE.LeanBridge.shifted_round_eq_rne](LeanRounding.md#decl-f6d8726852e1a50e)

</details>

</details>

<a id="decl-1e62b5285da24aef"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.accuracy_round_eq_rne</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L21)

```lean
/-- Lean's rounding decision agrees with the rational nearest-even reference
whenever the supplied metadata describes the exact input. -/
theorem accuracy_round_eq_rne (a : Accuracy) (t : ℚ) (m : ℕ)
    (h : AccuracyRepresents a t m) :
    (a.roundToNearestEven m : ℤ) = rneInt t := by
  obtain ⟨hf, ha⟩ := h
  cases a with
  | exact =>
    simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
    simp [ha, Rat.sub_self]
    grind
  | inexact o =>
    cases o with
    | lt =>
      simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
      rw [if_neg (by grind)]
    | eq =>
      simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
      rw [ha]
      simp only [Rat.lt_irrefl, false_or, true_and, Int.natCast_add]
      split <;> omega
    | gt =>
      simp only [Accuracy.roundToNearestEven, rneInt, hf, Rat.intCast_natCast]
      rw [if_pos (Or.inl ha)]
      omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.LeanBridge.AccuracyRepresents](LeanRounding.md#decl-45511da2f3f29c76), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shifted_round_eq_rne](LeanRounding.md#decl-f6d8726852e1a50e)

</details>

</details>

<a id="decl-8be2298798509a20"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.shiftRightOne_represents</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L46)

```lean
/-- One shift preserves the meaning of the retained mantissa and residual bits. -/
theorem shiftRightOne_represents (em : ExtendedMantissa) (t : ℚ)
    (h : AccuracyRepresents em.accuracy t em.mantissa) :
    AccuracyRepresents em.shiftRightOne.accuracy (t / 2) em.shiftRightOne.mantissa := by
  obtain ⟨hf, ha⟩ := h
  have hb := floor_frac_bounds t
  rw [hf] at hb
  simp only [Rat.intCast_natCast] at hb
  have hm : (em.mantissa : ℚ) =
      2 * ((em.mantissa / 2 : ℕ) : ℚ) + ((em.mantissa % 2 : ℕ) : ℚ) := by
    have he := Nat.div_add_mod em.mantissa 2
    have hc := congrArg (fun n : ℕ => (n : ℚ)) he
    simpa only [Rat.natCast_add, Rat.natCast_mul, Rat.natCast_ofNat] using hc.symm
  have hmod : em.mantissa % 2 = 0 ∨ em.mantissa % 2 = 1 := by omega
  have hq : (t / 2).floor = ((em.mantissa / 2 : ℕ) : ℤ) := by
    apply Int.le_antisymm
    · have hu : t / 2 < (((em.mantissa / 2 : ℕ) : ℤ) : ℚ) + 1 := by
        simp only [Rat.intCast_natCast]
        apply (Rat.div_lt_iff (by decide : (0 : ℚ) < 2)).mpr
        rcases hmod with he | he <;> rw [he] at hm <;> simp only [Rat.natCast_ofNat] at hm
        all_goals grind
      have := Rat.floor_le (t / 2)
      have hc : ((t / 2).floor : ℚ) < (((em.mantissa / 2 : ℕ) : ℤ) + 1 : ℤ) := by
        simp only [Rat.intCast_add, Rat.intCast_one]
        grind
      have := Rat.intCast_lt_intCast.mp hc
      omega
    · apply Rat.le_floor_iff.mpr
      simp only [Rat.intCast_natCast]
      apply le_div_of_mul_le _ _ _ (by decide : (0 : ℚ) < 2)
      rcases hmod with he | he <;> rw [he] at hm <;> simp only [Rat.natCast_ofNat] at hm
      all_goals grind
  refine ⟨hq, ?_⟩
  have ht : t / 2 * 2 = t := Rat.div_mul_cancel (by decide)
  rcases em with ⟨m, r, s⟩
  dsimp at *
  cases r <;> cases s <;>
    simp only [ExtendedMantissa.accuracy] at ha <;>
    rcases hmod with he | he <;>
    simp [ExtendedMantissa.shiftRightOne, he, ExtendedMantissa.accuracy] <;>
    rw [he] at hm <;> simp only [Rat.natCast_ofNat] at hm
  all_goals grind
```

**Supporting proofs:** [TensorCore.floor_frac_bounds](../Numerics/Rounding.md#decl-7ca84f988f037dce), [TensorCore.le_div_of_mul_le](../Numerics/Exact.md#decl-020e94a8d8a6259e)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.AccuracyRepresents](LeanRounding.md#decl-45511da2f3f29c76)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shiftRight_represents](LeanRounding.md#decl-7f6354812c57ad44)

</details>

</details>

<a id="decl-7f6354812c57ad44"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.shiftRight_represents</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L90)

```lean
/-- Arbitrarily many shifts retain enough information for exact nearest-even
rounding; this is not restricted to any floating-point format. -/
theorem shiftRight_represents (em : ExtendedMantissa) (t : ℚ) (n : ℕ)
    (h : AccuracyRepresents em.accuracy t em.mantissa) :
    AccuracyRepresents (em >>> n).accuracy (t / pow2 (n : ℤ)) (em >>> n).mantissa := by
  induction n with
  | zero =>
    simpa [HShiftRight.hShiftRight, Nat.repeat, pow2, Rat.div_def,
      show (1 : ℚ)⁻¹ = 1 from by decide +kernel, Rat.mul_one] using h
  | succ n ih =>
    have hs := shiftRightOne_represents (em >>> n) (t / pow2 (n : ℤ)) ih
    have he : t / pow2 (n : ℤ) / 2 = t / (pow2 (n : ℤ) * 2) := by
      have hp := pow2_pos (n : ℤ)
      have h1 := Rat.div_mul_cancel (a := t) (Rat.ne_of_gt hp)
      have h2 := Rat.div_mul_cancel (a := t / pow2 (n : ℤ)) (by decide : (2 : ℚ) ≠ 0)
      have h3 := Rat.div_mul_cancel (a := t)
        (Rat.ne_of_gt (Rat.mul_pos hp (by decide : (0 : ℚ) < 2)))
      grind
    simpa [HShiftRight.hShiftRight, Nat.repeat, pow2_succ, he] using hs
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.shiftRightOne_represents](LeanRounding.md#decl-8be2298798509a20), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120), [TensorCore.pow2_succ](../Numerics/Exact.md#decl-57be1bea59f2897b)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.AccuracyRepresents](LeanRounding.md#decl-45511da2f3f29c76), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shifted_round_eq_rne](LeanRounding.md#decl-f6d8726852e1a50e)

</details>

</details>

<a id="decl-f6d8726852e1a50e"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.shifted_round_eq_rne</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L110)

```lean
/-- Lean's exact mantissa plus shifts agrees with our rational rounding on
every nonnegative dyadic coefficient. -/
theorem shifted_round_eq_rne (m n : ℕ) :
    ((ExtendedMantissa.ofMantissaAndAccuracy m .exact >>> n).roundedMantissa : ℤ) =
      rneInt ((m : ℚ) / pow2 (n : ℤ)) := by
  apply accuracy_round_eq_rne
  apply shiftRight_represents
  constructor
  · simpa only [Rat.intCast_natCast, ExtendedMantissa.ofMantissaAndAccuracy] using
      Rat.floor_intCast (m : ℤ)
  · rfl
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.accuracy_round_eq_rne](LeanRounding.md#decl-1e62b5285da24aef), [TensorCore.IEEE.LeanBridge.shiftRight_represents](LeanRounding.md#decl-7f6354812c57ad44)

**Definitions and types:** [TensorCore.IEEE.LeanBridge.AccuracyRepresents](LeanRounding.md#decl-45511da2f3f29c76), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](LeanRounding.md#decl-14facc14bbf9c0d8)

</details>

</details>

<a id="decl-0ef7cbf9638ce869"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L122)

```lean
/-- The binade selected by the rational reference agrees with the integer
logarithm used by Lean's logical model. -/
theorem magnitudeExponent_dyadic (m : ℕ) (e : ℤ) (hm : 0 < m) :
    magnitudeExponent ((m : ℚ) * pow2 e) = (m.log2 : ℤ) + e := by
  apply magnitudeExponent_eq_of_bounds
  · rw [pow2_add, pow2_natCast]
    exact Rat.mul_le_mul_of_nonneg_right
      (Rat.natCast_le_natCast.mpr (Nat.log2_self_le (by omega)))
      (Rat.le_of_lt (pow2_pos e))
  · have he : (m.log2 : ℤ) + e + 1 = ((m.log2 + 1 : ℕ) : ℤ) + e := by omega
    rw [he, pow2_add, pow2_natCast]
    exact (Rat.mul_lt_mul_right (pow2_pos e)).mpr
      (Rat.natCast_lt_natCast.mpr Nat.lt_log2_self)
```

**Supporting proofs:** [TensorCore.magnitudeExponent_eq_of_bounds](../Numerics/Rounding.md#decl-bf009f29f695c88d), [TensorCore.pow2_add](../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Numerics/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.magnitudeExponent](../Numerics/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.targetExponent32_eq](LeanRounding.md#decl-fe597c4119872d5a)

</details>

</details>

<a id="decl-fe597c4119872d5a"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.targetExponent32_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L135)

```lean
/-- Exponent selection agrees, including the gradual-underflow floor. -/
theorem targetExponent32_eq (m : ℕ) (e : ℤ) (hm : 0 < m) :
    Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent m e) =
      binaryConvExp fp32 ((m : ℚ) * pow2 e) - fp32.fractionBits := by
  rw [binaryConvExp, magnitudeExponent_dyadic m e hm]
  simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
    Float.Model.Format.mantissaBits,
    Float.Model.Format.minExponent, fp32, Format.emin]
  omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](LeanRounding.md#decl-0ef7cbf9638ce869)

**Definitions and types:** [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Numerics/Defs.md#decl-af48d9057baa67b0), [TensorCore.binaryConvExp](../Numerics/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.magnitudeExponent](../Numerics/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.firstPass32](LeanRounding.md#decl-1f3110087e3c2f88), [TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e)

</details>

</details>

<a id="decl-8bceb00d2c5415ab"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.decreaseExponent_value</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L145)

```lean
/-- Left alignment in Lean's model preserves the exact dyadic value. -/
theorem decreaseExponent_value (m : ℕ) (e target : ℤ) :
    ((decreaseExponent m e target).1 : ℚ) * pow2 (decreaseExponent m e target).2 =
      (m : ℚ) * pow2 e := by
  simp only [decreaseExponent, Nat.shiftLeft_eq, Rat.natCast_mul]
  rw [← pow2_natCast, Rat.mul_assoc, ← pow2_add]
  congr 2
  omega
```

**Supporting proofs:** [TensorCore.pow2_add](../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Numerics/Exact.md#decl-997b22af00ef82dd)

**Definitions and types:** [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.aligned_add_value](LeanBridge.md#decl-e6cb66147cd6c96f), [TensorCore.IEEE.LeanBridge.aligned_sub_value](LeanBridge.md#decl-e1219acca53993f8), [TensorCore.IEEE.LeanBridge.firstPass32](LeanRounding.md#decl-1f3110087e3c2f88)

</details>

</details>

<a id="decl-14facc14bbf9c0d8"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L155)

```lean
/-- The first alignment and rounding pass computes the reference coefficient
on any coarser dyadic grid. -/
theorem shiftToExponent_round_eq (m : ℕ) (e target : ℤ) (he : e ≤ target) :
    ((shiftToExponent m e .exact target).1.roundedMantissa : ℤ) =
      rneInt ((m : ℚ) * pow2 e / pow2 target) := by
  simp only [shiftToExponent]
  rw [shifted_round_eq_rne]
  congr 1
  have hn : ((target - e).toNat : ℤ) = target - e := Int.toNat_of_nonneg (by omega)
  rw [hn]
  have hp : pow2 (target - e) * pow2 e = pow2 target := by
    rw [← pow2_add]; congr 1; omega
  have h1 := Rat.div_mul_cancel (a := (m : ℚ)) (Rat.ne_of_gt (pow2_pos (target - e)))
  have h2 := Rat.div_mul_cancel (a := (m : ℚ) * pow2 e) (Rat.ne_of_gt (pow2_pos target))
  have hne := Rat.ne_of_gt (pow2_pos target)
  grind
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.shifted_round_eq_rne](LeanRounding.md#decl-f6d8726852e1a50e), [TensorCore.pow2_add](../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_pos](../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.firstPass32](LeanRounding.md#decl-1f3110087e3c2f88)

</details>

</details>

<a id="decl-42f813492ff38dd0"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.secondPass32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L171)

```lean
/-- The second pass is exactly the single-bit carry of binary32 precision. -/
theorem secondPass32 (k : ℕ) (e : ℤ) (hk : k ≤ 2 ^ 24) (he : -149 ≤ e) :
    shiftToTargetExponent Float.Model.Format.binary32 k e .exact =
      if k = 2 ^ 24 then (⟨2 ^ 23, false, false⟩, e + 1)
      else (⟨k, false, false⟩, e) := by
  by_cases hc : k = 2 ^ 24
  · subst k
    have ht : Float.Model.Format.binary32.targetExponent
        (Float.Model.totalExponent (2 ^ 24) e) = e + 1 := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Nat.log2_two_pow, Float.Model.Format.mantissaBits,
        Float.Model.Format.minExponent]
      omega
    simp only [shiftToTargetExponent, ht, shiftToExponent, show e + 1 - e = 1 from by omega,
      show (1 : ℤ).toNat = 1 from rfl, HShiftRight.hShiftRight, Nat.repeat,
      ExtendedMantissa.ofMantissaAndAccuracy, ExtendedMantissa.shiftRightOne,
      ↓reduceIte]
    rfl
  · have hl : k.log2 ≤ 23 := by
      by_cases hz : k = 0
      · simp [hz]
      · have := (Nat.log2_lt hz).mpr (show k < 2 ^ 24 by omega)
        omega
    have ht : Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent k e) ≤ e := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Float.Model.Format.mantissaBits, Float.Model.Format.minExponent]
      omega
    have hn : (Float.Model.Format.binary32.targetExponent
        (Float.Model.totalExponent k e) - e).toNat = 0 := by omega
    simp [shiftToTargetExponent, shiftToExponent, hn, hc, HShiftRight.hShiftRight,
      Nat.repeat, ExtendedMantissa.ofMantissaAndAccuracy]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e)

</details>

</details>

<a id="decl-1f3110087e3c2f88"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.firstPass32</code></summary>

[Lean source](../../../TensorCore/Scalar/LeanRounding.lean#L204)

```lean
/-- The first normalization pass selects the same exponent and nearest-even
coefficient as the independent rational reference. -/
theorem firstPass32 (m : ℕ) (e : ℤ) (hm : 0 < m) :
    let q := Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent m e)
    let d := decreaseExponent m e q
    let first := shiftToTargetExponent Float.Model.Format.binary32 d.1 d.2 .exact
    first.2 = q ∧ (first.1.roundedMantissa : ℤ) =
      rneInt ((m : ℚ) * pow2 e / pow2 q) := by
  intro q d first
  have hd : 0 < d.1 := by
    dsimp [d, decreaseExponent]
    rw [Nat.shiftLeft_eq]
    exact Nat.mul_pos hm (Nat.two_pow_pos _)
  have hv := decreaseExponent_value m e q
  have hq : Float.Model.Format.binary32.targetExponent (Float.Model.totalExponent d.1 d.2) = q := by
    rw [targetExponent32_eq d.1 d.2 hd, hv]
    exact (targetExponent32_eq m e hm).symm
  have he : d.2 ≤ q := by dsimp [d, decreaseExponent]; omega
  have hs : first = shiftToExponent d.1 d.2 .exact q := by
    dsimp only [first, shiftToTargetExponent]
    rw [hq]
  rw [hs]
  constructor
  · dsimp [shiftToExponent]; omega
  · rw [shiftToExponent_round_eq _ _ _ he, hv]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decreaseExponent_value](LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.IEEE.LeanBridge.targetExponent32_eq](LeanRounding.md#decl-fe597c4119872d5a)

**Definitions and types:** [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.binaryConvExp](../Numerics/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Numerics/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e)

</details>

</details>
