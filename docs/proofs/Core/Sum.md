# TensorCore.Core.Sum

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-87fa253b5e1d3c24"></a>

<details>
<summary><code>TensorCore.magnitudeSum</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L8)

```lean
/-- Total magnitude support. Unlike the final signed sum, it controls every prefix. -/
def magnitudeSum : List ℤ → ℕ
  | [] => 0
  | z :: zs => z.natAbs + magnitudeSum zs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.Regression.eq20_public_accepts](../Regression/FoundationCompletion.md#decl-b1321756db80e3f1), [TensorCore.Regression.eq20_range_and_strict_boundary](../Regression/FoundationCompletion.md#decl-f27799086657473d), [TensorCore.Regression.eq20_signed_budget](../Regression/FoundationCompletion.md#decl-0598e4ed93ef2381), [TensorCore.Regression.scalar64_coarse_grid](../EFT/Regression/ScalarEFT.md#decl-71ebab7703c3a1c5), [TensorCore.Regression.scalar_bitSpan_budget](../EFT/Regression/ScalarEFT.md#decl-4f8ed7cf41298ebe), [TensorCore.Regression.scalar_coefficient_boundary](../EFT/Regression/ScalarEFT.md#decl-486a5f125177b3ef), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.coefficient_bitSpan_sufficient](Sum.md#decl-7b44fd262a25d36a), [TensorCore.coefficient_width_sufficient](Sum.md#decl-50e5b749a17f1c03), [TensorCore.evalBlockMachine_eq](../TC/MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_coefficient_capacity](../TC/AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_machinePrefix](../TC/AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.evalPreparedMachine_eq](../TC/MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.machineAccumulate_exact](../TC/AccumulatorWidth.md#decl-80c3acbccc8106eb), [TensorCore.machineAccumulate_prefix_exact](../TC/AccumulatorWidth.md#decl-9b23fe9fc6ec5adf), [TensorCore.machineAccumulator_eq](../TC/AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.magnitudeSum_append](Sum.md#decl-277547ea66e0e0cf), [TensorCore.magnitudeSum_le_length_mul](Sum.md#decl-65d6fdeb3de8e2f3), [TensorCore.magnitudeSum_perm](Sum.md#decl-7163fe35317eedbf), [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.naiveSum64_exact](Binary/ScalarSum.md#decl-d74afdeb99860469), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinary_exact](Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](Binary/ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.naiveSumBinary_exact_perm](Binary/ScalarSum.md#decl-f78af6692d4089d7), [TensorCore.prepare_coefficient_capacity](../TC/AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.sumZ_natAbs_le](Sum.md#decl-d8b1b90e2d6e4d96)

</details>

</details>

<a id="decl-d8b1b90e2d6e4d96"></a>

<details>
<summary><code>TensorCore.sumZ_natAbs_le</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L12)

```lean
theorem sumZ_natAbs_le (zs : List ℤ) : (sumZ zs).natAbs ≤ magnitudeSum zs := by
  induction zs with
  | nil => simp [sumZ, magnitudeSum]
  | cons z zs ih =>
    have := Int.natAbs_add_le z (sumZ zs)
    simp only [sumZ, magnitudeSum]
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24), [TensorCore.sumZ](Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.machineAccumulate_exact](../TC/AccumulatorWidth.md#decl-80c3acbccc8106eb)

</details>

</details>

<a id="decl-277547ea66e0e0cf"></a>

<details>
<summary><code>TensorCore.magnitudeSum_append</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L20)

```lean
theorem magnitudeSum_append (xs ys : List ℤ) :
    magnitudeSum (xs ++ ys) = magnitudeSum xs + magnitudeSum ys := by
  induction xs with
  | nil => simp [magnitudeSum]
  | cons x xs ih => simp [magnitudeSum, ih, Nat.add_assoc]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.machineAccumulate_prefix_exact](../TC/AccumulatorWidth.md#decl-9b23fe9fc6ec5adf)

</details>

</details>

<a id="decl-65d6fdeb3de8e2f3"></a>

<details>
<summary><code>TensorCore.magnitudeSum_le_length_mul</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L26)

```lean
theorem magnitudeSum_le_length_mul (zs : List ℤ) (B : ℕ)
    (h : ∀ z ∈ zs, z.natAbs ≤ B) : magnitudeSum zs ≤ zs.length * B := by
  induction zs with
  | nil => simp [magnitudeSum]
  | cons z zs ih =>
    have hz := h z (by simp)
    have ht := ih (by intro t ht; exact h t (by simp [ht]))
    simp only [magnitudeSum, List.length_cons, Nat.add_mul, Nat.one_mul]
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.coefficient_width_sufficient](Sum.md#decl-50e5b749a17f1c03), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946)

</details>

</details>

<a id="decl-50e5b749a17f1c03"></a>

<details>
<summary><code>TensorCore.coefficient_width_sufficient</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L38)

```lean
/-- A usable conservative signed width: B coefficient bits, carry bits c for the
term count, and a separate sign bit. The bound uses at most `2^B - 1` per term. -/
theorem coefficient_width_sufficient (zs : List ℤ) (B c : ℕ)
    (hterm : ∀ z ∈ zs, z.natAbs < 2 ^ B) (hcount : zs.length ≤ 2 ^ c) :
    magnitudeSum zs < 2 ^ ((B + c + 1) - 1) := by
  have hp := Nat.two_pow_pos B
  have hc := Nat.two_pow_pos c
  have hs := magnitudeSum_le_length_mul zs (2 ^ B - 1) (by
    intro z hz; have := hterm z hz; omega)
  have hm := Nat.mul_le_mul_right (2 ^ B - 1) hcount
  have he : (B + c + 1) - 1 = B + c := by omega
  rw [he, Nat.pow_add, Nat.mul_comm]
  have hd : 2 ^ c * (2 ^ B - 1) < 2 ^ c * 2 ^ B :=
    Nat.mul_lt_mul_of_pos_left (by omega) hc
  omega
```

**Supporting proofs:** [TensorCore.magnitudeSum_le_length_mul](Sum.md#decl-65d6fdeb3de8e2f3)

**Definitions and types:** [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.coefficient_bitSpan_sufficient](Sum.md#decl-7b44fd262a25d36a), [TensorCore.machineAccumulate_of_coefficient_bound](../TC/AccumulatorWidth.md#decl-c1bb27c5ce2e7d98), [TensorCore.prepare_coefficient_capacity](../TC/AlignmentScale.md#decl-c04538f02bc7d682)

</details>

</details>

<a id="decl-515e106ddee189db"></a>

<details>
<summary><code>TensorCore.sumZ_replicate</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L52)

```lean
theorem sumZ_replicate (K : ℕ) (z : ℤ) : sumZ (List.replicate K z) = K * z := by
  induction K with
  | zero => simp [sumZ]
  | succ n ih =>
    simp only [List.replicate_succ, sumZ, ih]
    have : ((n + 1 : ℕ) : ℤ) = (n : ℤ) + 1 := by omega
    rw [this]; grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumZ](Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-23e4bf84c54e623b"></a>

<details>
<summary><code>TensorCore.sumQ_map_sub</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L60)

```lean
theorem sumQ_map_sub (l : List α) (g h : α → ℚ) :
    sumQ (l.map fun x => g x - h x) = sumQ (l.map g) - sumQ (l.map h) := by
  induction l with
  | nil => change (0 : ℚ) = 0 - 0; grind
  | cons x xs ih => simp only [List.map_cons, sumQ, ih]; grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2)

</details>

</details>

<a id="decl-9a866541e41b56c9"></a>

<details>
<summary><code>TensorCore.sumQ_map_add</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L66)

```lean
theorem sumQ_map_add (l : List α) (g h : α → ℚ) :
    sumQ (l.map fun x => g x + h x) = sumQ (l.map g) + sumQ (l.map h) := by
  induction l with
  | nil => change (0 : ℚ) = 0 + 0; grind
  | cons x xs ih => simp only [List.map_cons, sumQ, ih]; grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373)

</details>

</details>

<a id="decl-9728c1755d91fb0d"></a>

<details>
<summary><code>TensorCore.absQ_sumQ_le</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L72)

```lean
theorem absQ_sumQ_le (xs : List ℚ) : absQ (sumQ xs) ≤ sumQ (xs.map absQ) := by
  induction xs with
  | nil =>
    simp only [sumQ, List.map_nil]
    have : absQ 0 = 0 := by decide +kernel
    rw [this]
    exact Rat.le_refl
  | cons x xs ih =>
    simp only [sumQ, List.map_cons]
    have := absQ_add_le x (sumQ xs)
    grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](Exact.md#decl-5c1117bc0bcece80)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](../EFT/Machine/Success.md#decl-5145abbc51875848), [TensorCore.accumulator_abs_le_mass](../TC/Program/Bounds/Local.md#decl-97266aac0ec35351), [TensorCore.accumulator_abs_lt](../TC/StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.idealProducts_abs_le_of_scale](../TC/Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a)

</details>

</details>

<a id="decl-02931053452cdfec"></a>

<details>
<summary><code>TensorCore.sumQ_map_le</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L84)

```lean
theorem sumQ_map_le (xs : List α) (f : α → ℚ) (B : ℚ) (h : ∀ x ∈ xs, f x ≤ B) :
    sumQ (xs.map f) ≤ (xs.length : ℚ) * B := by
  induction xs with
  | nil =>
    simp only [List.map_nil, sumQ, List.length_nil]
    grind
  | cons x xs ih =>
    have hx := h x (by simp)
    have hrest := ih (fun y hy => h y (by simp [hy]))
    have hs : ((xs.length + 1 : ℕ) : ℚ) = (xs.length : ℚ) + 1 := by
      rw [Rat.natCast_add]; rfl
    simp only [List.map_cons, sumQ, List.length_cons, hs]
    grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](../EFT/Machine/Success.md#decl-5145abbc51875848), [TensorCore.groupBound_le_static](../TC/Program/GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.idealProducts_abs_le_of_scale](../TC/Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.matrixAbsSum_bound](../Gemm/Bounds.md#decl-485a6ec947a4e04d), [TensorCore.sumQ_map_lt](Sum.md#decl-5c0b2e6254ce280d)

</details>

</details>

<a id="decl-5c0b2e6254ce280d"></a>

<details>
<summary><code>TensorCore.sumQ_map_lt</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L98)

```lean
theorem sumQ_map_lt (xs : List α) (hne : xs ≠ []) (f : α → ℚ) (B : ℚ)
    (h : ∀ y ∈ xs, f y < B) : sumQ (xs.map f) < (xs.length : ℚ) * B := by
  cases xs with
  | nil => exact absurd rfl hne
  | cons x xs =>
    have hx := h x (by simp)
    have hrest := sumQ_map_le xs f B (fun y hy => Rat.le_of_lt (h y (by simp [hy])))
    have hs : ((xs.length + 1 : ℕ) : ℚ) = (xs.length : ℚ) + 1 := by
      rw [Rat.natCast_add]; rfl
    simp only [List.map_cons, sumQ, List.length_cons, hs]
    grind
```

**Supporting proofs:** [TensorCore.sumQ_map_le](Sum.md#decl-02931053452cdfec)

**Definitions and types:** [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulator_abs_lt](../TC/StaticBudget.md#decl-a5c9d0f9181e3641)

</details>

</details>

<a id="decl-181b288c0a867eb6"></a>

<details>
<summary><code>TensorCore.sumQ_map_zero</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L110)

```lean
theorem sumQ_map_zero (xs : List α) : sumQ (xs.map fun _ => (0 : ℚ)) = 0 := by
  induction xs with
  | nil => rfl
  | cons _ _ ih => simp only [List.map_cons, sumQ, ih]; grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.alignment_static_bound](../TC/StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.groupBound_nonneg](../TC/Program/GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.productMass_nonneg](../TC/Program/GroupAnalysis.md#decl-b18fa7d0371588fa)

</details>

</details>

<a id="decl-7163fe35317eedbf"></a>

<details>
<summary><code>TensorCore.magnitudeSum_perm</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L115)

```lean
theorem magnitudeSum_perm {xs ys : List ℤ} (h : xs.Perm ys) : magnitudeSum xs = magnitudeSum ys := by
  induction h with
  | nil => rfl
  | cons x _ ih => simp only [magnitudeSum, ih]
  | swap x y zs => simp only [magnitudeSum]; omega
  | trans _ _ ih1 ih2 => exact ih1.trans ih2
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSumBinary_exact_perm](Binary/ScalarSum.md#decl-f78af6692d4089d7)

</details>

</details>

<a id="decl-e7bd85cdcec165e7"></a>

<details>
<summary><code>TensorCore.sumZ_perm</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L122)

```lean
theorem sumZ_perm {xs ys : List ℤ} (h : xs.Perm ys) : sumZ xs = sumZ ys := by
  induction h with
  | nil => rfl
  | cons x _ ih => simp only [sumZ, ih]
  | swap x y zs => simp only [sumZ]; omega
  | trans _ _ ih1 ih2 => exact ih1.trans ih2
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumZ](Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSumBinary_exact_perm](Binary/ScalarSum.md#decl-f78af6692d4089d7)

</details>

</details>

<a id="decl-19c2da9023bf4c87"></a>

<details>
<summary><code>TensorCore.ceilLog2</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L130)

```lean
/-- Ceiling of log₂ n for positive n, extended by zero at n = 0. -/
def ceilLog2 (n : ℕ) : ℕ := if n ≤ 1 then 0 else (n - 1).log2 + 1
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.scalar_bitSpan_budget](../EFT/Regression/ScalarEFT.md#decl-4f8ed7cf41298ebe), [TensorCore.Regression.scalar_coefficient_boundary](../EFT/Regression/ScalarEFT.md#decl-486a5f125177b3ef), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.ceilLog2_le_iff](Sum.md#decl-79fda09bde15802b), [TensorCore.coefficient_bitSpan_sufficient](Sum.md#decl-7b44fd262a25d36a), [TensorCore.le_two_pow_ceilLog2](Sum.md#decl-3b9a0bf681c3e344), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c)

</details>

</details>

<a id="decl-79fda09bde15802b"></a>

<details>
<summary><code>TensorCore.ceilLog2_le_iff</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L132)

```lean
theorem ceilLog2_le_iff (n c : ℕ) : ceilLog2 n ≤ c ↔ n ≤ 2 ^ c := by
  by_cases hn : n ≤ 1
  · simp only [ceilLog2, if_pos hn, Nat.zero_le, true_iff]
    have := Nat.two_pow_pos c
    omega
  · have hlog := Nat.log2_lt (n := n - 1) (k := c) (by omega)
    simp only [ceilLog2, if_neg hn]
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ceilLog2](Sum.md#decl-19c2da9023bf4c87)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.le_two_pow_ceilLog2](Sum.md#decl-3b9a0bf681c3e344)

</details>

</details>

<a id="decl-3b9a0bf681c3e344"></a>

<details>
<summary><code>TensorCore.le_two_pow_ceilLog2</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L141)

```lean
theorem le_two_pow_ceilLog2 (n : ℕ) : n ≤ 2 ^ ceilLog2 n :=
  (ceilLog2_le_iff n _).mp (Nat.le_refl _)
```

**Supporting proofs:** [TensorCore.ceilLog2_le_iff](Sum.md#decl-79fda09bde15802b)

**Definitions and types:** [TensorCore.ceilLog2](Sum.md#decl-19c2da9023bf4c87)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.coefficient_bitSpan_sufficient](Sum.md#decl-7b44fd262a25d36a)

</details>

</details>

<a id="decl-7b44fd262a25d36a"></a>

<details>
<summary><code>TensorCore.coefficient_bitSpan_sufficient</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L145)

```lean
/-- The bit-width form of Theorem IV.8's stronger sufficient coefficient budget. -/
theorem coefficient_bitSpan_sufficient (zs : List ℤ) (B P : ℕ)
    (hterm : ∀ z ∈ zs, z.natAbs < 2 ^ B) (hspan : B + ceilLog2 zs.length ≤ P) :
    magnitudeSum zs < 2 ^ P := by
  have h := coefficient_width_sufficient zs B (ceilLog2 zs.length) hterm
    (le_two_pow_ceilLog2 _)
  have hp := Nat.pow_le_pow_right (show 0 < 2 by decide) hspan
  have he : (B + ceilLog2 zs.length + 1) - 1 = B + ceilLog2 zs.length := by omega
  rw [he] at h
  omega
```

**Supporting proofs:** [TensorCore.coefficient_width_sufficient](Sum.md#decl-50e5b749a17f1c03), [TensorCore.le_two_pow_ceilLog2](Sum.md#decl-3b9a0bf681c3e344)

**Definitions and types:** [TensorCore.ceilLog2](Sum.md#decl-19c2da9023bf4c87), [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7)

</details>

</details>

<a id="decl-dd359e6ccc782af7"></a>

<details>
<summary><code>TensorCore.bitSpan_coefficient_bound</code></summary>

[Lean source](../../../TensorCore/Core/Sum.lean#L158)

```lean
/-- The paper's signed-exponent form: |Tᵢ| < 2^(b+1), Tᵢ = zᵢ 2^ℓ, and
`b − ℓ + 1 + ⌈log₂ n⌉ ≤ P` imply the predicate's strict coefficient budget.
If the term bound lies below the common grid, every coefficient must be zero. -/
theorem bitSpan_coefficient_bound (zs : List ℤ) (b ℓ : ℤ) (P : ℕ)
    (hterm : ∀ z ∈ zs, absQ ((z : ℚ) * pow2 ℓ) < pow2 (b + 1))
    (hspan : b - ℓ + 1 + (ceilLog2 zs.length : ℤ) ≤ P) : magnitudeSum zs < 2 ^ P := by
  by_cases hB : ℓ ≤ b + 1
  · let B := (b - ℓ + 1).toNat
    have hBe : (B : ℤ) = b - ℓ + 1 := by dsimp [B]; omega
    apply coefficient_bitSpan_sufficient zs B P
    · intro z hz
      have h := hterm z hz
      rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast, Rat.intCast_natCast] at h
      have he : b + 1 = (B : ℤ) + ℓ := by omega
      rw [he, pow2_add, pow2_natCast] at h
      exact Rat.natCast_lt_natCast.mp (Rat.lt_of_mul_lt_mul_right h (Rat.le_of_lt (pow2_pos _)))
    · omega
  · have hzero : ∀ z ∈ zs, z.natAbs ≤ 0 := by
      intro z hz
      have h := hterm z hz
      have hgrid := pow2_le_of_le (show b + 1 ≤ ℓ by omega)
      rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast, Rat.intCast_natCast] at h
      have hz1 : (z.natAbs : ℚ) * pow2 ℓ < 1 * pow2 ℓ := by grind
      have hz2 : z.natAbs < 1 :=
        Rat.natCast_lt_natCast.mp (Rat.lt_of_mul_lt_mul_right hz1 (Rat.le_of_lt (pow2_pos _)))
      omega
    have := magnitudeSum_le_length_mul zs 0 hzero
    have := Nat.two_pow_pos P
    omega
```

**Supporting proofs:** [TensorCore.absQ_intCast](Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.coefficient_bitSpan_sufficient](Sum.md#decl-7b44fd262a25d36a), [TensorCore.magnitudeSum_le_length_mul](Sum.md#decl-65d6fdeb3de8e2f3), [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.ceilLog2](Sum.md#decl-19c2da9023bf4c87), [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.scalar_bitSpan_budget](../EFT/Regression/ScalarEFT.md#decl-4f8ed7cf41298ebe), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c)

</details>

</details>
