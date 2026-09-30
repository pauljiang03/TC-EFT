# TensorCore.Kernels.EFT.Dyadic

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5d49d73c88f3b4a6"></a>

<details>
<summary><code>TensorCore.EFMachine.floor_nat_div</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Dyadic.lean#L8)

```lean
theorem floor_nat_div (m d : ℕ) (hd : 0 < d) :
    ((m : ℚ) / (d : ℚ)).floor = (m / d : ℕ) := by
  have hdp : (0 : ℚ) < (d : ℚ) := Rat.natCast_pos.mpr hd
  have hlo : ((m / d : ℕ) : ℚ) * (d : ℚ) ≤ (m : ℚ) := by
    rw [← Rat.natCast_mul]
    exact Rat.natCast_le_natCast.mpr (Nat.div_mul_le_self m d)
  have hhi : (m : ℚ) < ((m / d : ℕ) + 1 : ℚ) * (d : ℚ) := by
    have hn : m < (m / d + 1) * d := by
      have := Nat.mod_lt m hd
      have hh := Nat.mod_add_div m d
      rw [Nat.mul_comm] at hh
      rw [Nat.add_mul, Nat.one_mul]
      omega
    exact_mod_cast hn
  have hl : ((m / d : ℕ) : ℤ) ≤ ((m : ℚ) / (d : ℚ)).floor := by
    apply Rat.le_floor_iff.mpr
    have h := Rat.div_lt_iff (a := (m : ℚ)) (c := ((m / d : ℕ) : ℚ)) hdp
    simp only [Rat.intCast_natCast]
    grind
  have hh : ((m : ℚ) / (d : ℚ)).floor < ((m / d : ℕ) : ℤ) + 1 := by
    apply Rat.floor_lt_iff.mpr
    simpa only [Rat.intCast_add, Rat.intCast_natCast, Rat.intCast_one] using
      (Rat.div_lt_iff hdp).mpr hhi
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.rneInt_nat_div](Dyadic.md#decl-a8bf3e6699d80787)

</details>

</details>

<a id="decl-fd28badee16494f1"></a>

<details>
<summary><code>TensorCore.EFMachine.dyadic_div</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Dyadic.lean#L33)

```lean
theorem dyadic_div (m : ℕ) (scale : ℤ) (gap : ℕ) :
    (m : ℚ) * pow2 scale / pow2 (scale + gap) = (m : ℚ) / (2 ^ gap : ℕ) := by
  have hp := pow2_pos scale
  have hd : (0 : ℚ) < ((2 ^ gap : ℕ) : ℚ) := Rat.natCast_pos.mpr (Nat.two_pow_pos _)
  rw [pow2_add, pow2_natCast, Rat.div_def, Rat.inv_mul_rev]
  have hc := Rat.mul_inv_cancel (pow2 scale) (Rat.ne_of_gt hp)
  rw [Rat.div_def]
  grind
```

**Supporting proofs:** [TensorCore.pow2_add](../../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../../Numerics/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../../Numerics/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.roundingGrid_div](Round.md#decl-73afe430816bd696)

</details>

</details>

<a id="decl-ff27bb512df53e23"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_coarse_value</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Dyadic.lean#L44)

```lean
/-- The implemented quotient/remainder split is the paper's magnitude truncation,
including negative terms and gaps beyond a machine limb's width. -/
theorem Word.split_coarse_value (x : Word) (g : Grid) :
    (x.split g).coarse.value = truncGrid x.value ((g.toNat : ℤ) - 272) := by
  have hs := x.split_sign g
  have hn : (0 : ℚ) ≤ (x.magnitude.toNat : ℚ) * pow2 (-272) :=
    Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt (pow2_pos _))
  have hpos : ((x.split g).coarse.magnitude.toNat : ℚ) * pow2 (-272) =
      truncGrid ((x.magnitude.toNat : ℚ) * pow2 (-272)) ((g.toNat : ℤ) - 272) := by
    rw [show (g.toNat : ℤ) - 272 = -272 + g.toNat by omega]
    rw [alignment_value, truncCoeff_nonneg_eq _ _ hn, dyadic_div,
      floor_nat_div _ _ (Nat.two_pow_pos _), x.split_coarse, Rat.natCast_mul,
      pow2_add, pow2_natCast]
    simp only [Rat.intCast_natCast]
    grind
  cases hx : x.negative
  · simpa only [Word.value, Word.coefficient, hs.1, hx, Bool.false_eq_true,
      if_false, Rat.intCast_natCast] using hpos
  · simpa only [Word.value, Word.coefficient, hs.1, hx, if_true, Rat.intCast_neg,
      Rat.intCast_natCast, Rat.neg_mul, truncGrid_neg] using congrArg Neg.neg hpos
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_sign](Word.md#decl-2477bb5e600645f0), [TensorCore.EFMachine.dyadic_div](Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.floor_nat_div](Dyadic.md#decl-5d49d73c88f3b4a6), [TensorCore.alignment_value](../../Numerics/Truncation.md#decl-4fd20c57624d75c8), [TensorCore.pow2_add](../../Numerics/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../../Numerics/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../../Numerics/Exact.md#decl-8f231b6648575120), [TensorCore.truncCoeff_nonneg_eq](../../Numerics/Truncation.md#decl-a3484604d19e0df2), [TensorCore.truncGrid_neg](../../Numerics/Truncation.md#decl-5a536b3a975b733c)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](../../Numerics/Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](../../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.extract_component](Extraction.md#decl-f7b97097f702b90a)

</details>

</details>

<a id="decl-74ccca76d4f48986"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_low_value</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Dyadic.lean#L63)

```lean
theorem Word.split_low_value (x : Word) (g : Grid) :
    (x.split g).low.value = x.value - truncGrid x.value ((g.toNat : ℤ) - 272) := by
  have h := x.split_reconstruct g
  rw [x.split_coarse_value] at h
  grind
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.truncGrid](../../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_low_bound](Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.extract_component](Extraction.md#decl-f7b97097f702b90a)

</details>

</details>

<a id="decl-74c80ff9c30d5552"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_low_bound</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Dyadic.lean#L69)

```lean
theorem Word.split_low_bound (x : Word) (g : Grid) :
    absQ (x.split g).low.value < pow2 ((g.toNat : ℤ) - 272) := by
  rw [x.split_low_value]
  exact (alignment_residual _ _).2
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.alignment_residual](../../Numerics/Truncation.md#decl-8fb54cfc251e7721)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.absQ](../../Numerics/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](../../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a8bf3e6699d80787"></a>

<details>
<summary><code>TensorCore.EFMachine.rneInt_nat_div</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/Dyadic.lean#L74)

```lean
theorem rneInt_nat_div (m d : ℕ) (hd : 0 < d) :
    rneInt ((m : ℚ) / (d : ℚ)) =
      if d < 2 * (m % d) ∨ (2 * (m % d) = d ∧ m / d % 2 = 1)
      then ((m / d + 1 : ℕ) : ℤ) else ((m / d : ℕ) : ℤ) := by
  have hp : (0 : ℚ) < (d : ℚ) := Rat.natCast_pos.mpr hd
  have hn : ((m % d : ℕ) : ℚ) + (d : ℚ) * ((m / d : ℕ) : ℚ) = m := by
    exact_mod_cast Nat.mod_add_div m d
  have hrem : (m : ℚ) / (d : ℚ) - ((m / d : ℕ) : ℚ) = (m % d : ℕ) / (d : ℚ) := by
    have hc := Rat.div_mul_cancel (a := (m : ℚ)) (Rat.ne_of_gt hp)
    have hr := Rat.div_mul_cancel (a := ((m % d : ℕ) : ℚ)) (Rat.ne_of_gt hp)
    grind
  have he : (1 : ℚ) < 2 * ((m % d : ℕ) / (d : ℚ)) ↔ d < 2 * (m % d) := by
    have hc := Rat.div_mul_cancel (a := ((m % d : ℕ) : ℚ)) (Rat.ne_of_gt hp)
    have hi := Rat.mul_lt_mul_right (a := (1 : ℚ)) (b := 2 * ((m % d : ℕ) / (d : ℚ))) hp
    have hc' : (2 : ℚ) * ((m % d : ℕ) / (d : ℚ)) * d = ((2 * (m % d) : ℕ) : ℚ) := by
      simp only [Rat.natCast_mul]; grind
    rw [Rat.one_mul, hc'] at hi
    exact hi.symm.trans Rat.natCast_lt_natCast
  have ht : 2 * ((m % d : ℕ) / (d : ℚ)) = (1 : ℚ) ↔ 2 * (m % d) = d := by
    have hc := Rat.div_mul_cancel (a := ((m % d : ℕ) : ℚ)) (Rat.ne_of_gt hp)
    have hdne := Rat.ne_of_gt hp
    constructor
    · intro h
      have h' : ((2 * (m % d) : ℕ) : ℚ) = (d : ℚ) := by
        simp only [Rat.natCast_mul]; grind
      exact Rat.natCast_inj.mp h'
    · intro h
      have h' : (2 : ℚ) * ((m % d : ℕ) : ℚ) = (d : ℚ) := by exact_mod_cast h
      grind
  unfold rneInt
  rw [floor_nat_div _ _ hd]
  simp only [Rat.intCast_natCast, hrem, he, ht]
  have hp2 : ((m / d : ℕ) : ℤ) % 2 = 1 ↔ m / d % 2 = 1 := by omega
  simp only [hp2, Int.natCast_add, Int.natCast_one]
```

**Supporting proofs:** [TensorCore.EFMachine.floor_nat_div](Dyadic.md#decl-5d49d73c88f3b4a6)

**Definitions and types:** [TensorCore.rneInt](../../Numerics/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingCoefficient_spec](Round.md#decl-23d703ce50cbcf2a)

</details>

</details>
