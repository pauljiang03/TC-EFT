# TensorCore.EFT.Machine.Split

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-7154e65664b6f748"></a>

<details>
<summary><code>TensorCore.EFMachine.multiplySignificands_exact</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L9)

```lean
/-- No multiplication wrap: even the largest 11-bit significands fit in 22 bits. -/
theorem multiplySignificands_exact (a b : BitVec 11) :
    (multiplySignificands a b).toNat = a.toNat * b.toNat := by
  have ha := a.isLt
  have hb := b.isLt
  have hprod : a.toNat * b.toNat < 2 ^ 24 := by
    have h := Nat.mul_le_mul (show a.toNat ≤ 2047 by omega) (show b.toNat ≤ 2047 by omega)
    omega
  simp [multiplySignificands, BitVec.toNat_mul,
    Nat.mod_eq_of_lt (show a.toNat < 2 ^ 24 by omega),
    Nat.mod_eq_of_lt (show b.toNat < 2 ^ 24 by omega), Nat.mod_eq_of_lt hprod]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.multiplySignificands](SplitDefs.md#decl-fa9d1dd91a2047b7)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d)

</details>

</details>

<a id="decl-a57af4a3cd6f414f"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude_coarse</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L21)

```lean
/-- The machine coarse component is the quotient times its binary grid. -/
theorem splitMagnitude_coarse (m : BitVec 24) (gap : BitVec 8) :
    (splitMagnitude m gap).coarse.toNat = m.toNat / 2 ^ gap.toNat * 2 ^ gap.toNat := by
  have hm := m.isLt
  have hle := Nat.div_mul_le_self m.toNat (2 ^ gap.toNat)
  unfold splitMagnitude
  split
  · rename_i h
    have hg : 24 ≤ gap.toNat := by simpa [BitVec.le_def] using h
    have hp : 2 ^ 24 ≤ 2 ^ gap.toNat := Nat.pow_le_pow_right (by decide) hg
    have hz : m.toNat / 2 ^ gap.toNat = 0 := Nat.div_eq_of_lt (by omega)
    simp [hz]
  · change (((m >>> gap.toNat) <<< gap.toNat) : BitVec 24).toNat = _
    rw [BitVec.toNat_shiftLeft, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
      Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.splitMagnitude](SplitDefs.md#decl-cd5e2ed872b48654)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low](Split.md#decl-be65c44fdce1d820), [TensorCore.EFMachine.splitMagnitude_reconstruct](Split.md#decl-05bc6c16610d5178)

</details>

</details>

<a id="decl-be65c44fdce1d820"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude_low</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L37)

```lean
/-- The low component is the exact remainder; subtraction never underflows. -/
theorem splitMagnitude_low (m : BitVec 24) (gap : BitVec 8) :
    (splitMagnitude m gap).low.toNat = m.toNat % 2 ^ gap.toNat := by
  have hc := splitMagnitude_coarse m gap
  have hle := Nat.div_mul_le_self m.toNat (2 ^ gap.toNat)
  have hmod := Nat.mod_add_div m.toNat (2 ^ gap.toNat)
  rw [Nat.mul_comm] at hmod
  by_cases hg : gap ≥ 24
  · simp only [splitMagnitude, if_pos hg] at hc ⊢
    have hz : m.toNat / 2 ^ gap.toNat * 2 ^ gap.toNat = 0 := by simpa using hc.symm
    omega
  · simp only [splitMagnitude, if_neg hg] at hc ⊢
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def]; rw [hc]; exact hle)]
    rw [hc]
    omega
```

**Supporting proofs:** [TensorCore.EFMachine.splitMagnitude_coarse](Split.md#decl-a57af4a3cd6f414f)

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.splitMagnitude](SplitDefs.md#decl-cd5e2ed872b48654)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.splitMagnitude_low_lt](Split.md#decl-cb49563084f7df38), [TensorCore.EFMachine.splitMagnitude_reconstruct](Split.md#decl-05bc6c16610d5178)

</details>

</details>

<a id="decl-05bc6c16610d5178"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude_reconstruct</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L53)

```lean
/-- Independent integer reconstruction, valid for every magnitude and every gap. -/
theorem splitMagnitude_reconstruct (m : BitVec 24) (gap : BitVec 8) :
    (splitMagnitude m gap).coarse.toNat + (splitMagnitude m gap).low.toNat = m.toNat := by
  rw [splitMagnitude_coarse, splitMagnitude_low]
  have h := Nat.mod_add_div m.toNat (2 ^ gap.toNat)
  rw [Nat.mul_comm] at h
  omega
```

**Supporting proofs:** [TensorCore.EFMachine.splitMagnitude_coarse](Split.md#decl-a57af4a3cd6f414f), [TensorCore.EFMachine.splitMagnitude_low](Split.md#decl-be65c44fdce1d820)

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.splitMagnitude](SplitDefs.md#decl-cd5e2ed872b48654)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.splitMagnitude_low_residual](Split.md#decl-6d6fe2bc592a6791)

</details>

</details>

<a id="decl-cb49563084f7df38"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude_low_lt</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L61)

```lean
/-- A strict residual bound on the actual machine output. -/
theorem splitMagnitude_low_lt (m : BitVec 24) (gap : BitVec 8) :
    (splitMagnitude m gap).low.toNat < 2 ^ gap.toNat := by
  rw [splitMagnitude_low]
  exact Nat.mod_lt _ (Nat.two_pow_pos _)
```

**Supporting proofs:** [TensorCore.EFMachine.splitMagnitude_low](Split.md#decl-be65c44fdce1d820)

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.splitMagnitude](SplitDefs.md#decl-cd5e2ed872b48654)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b8d88a10b51cee99"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude_shift_bound</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L67)

```lean
/-- The only executed shift branch uses a count strictly smaller than the word width. -/
theorem splitMagnitude_shift_bound (gap : BitVec 8) (h : ¬ gap ≥ 24) : gap.toNat < 24 := by
  simpa [BitVec.le_def] using h
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b148729eb2b2141d"></a>

<details>
<summary><code>TensorCore.EFMachine.floor_nat_div</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L70)

```lean
private theorem floor_nat_div (m d : ℕ) (hd : 0 < d) :
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

[TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](Split.md#decl-596556927b61a3b2)

</details>

</details>

<a id="decl-763c208b0e2b895c"></a>

<details>
<summary><code>TensorCore.EFMachine.signedDyadic</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L96)

```lean
/-- Specification-side interpretation only; the machine stores a separate sign bit. -/
def signedDyadic (negative : Bool) (m : ℕ) (scale : ℤ) : ℚ :=
  if negative then -((m : ℚ) * pow2 scale) else (m : ℚ) * pow2 scale
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low_residual](Split.md#decl-6d6fe2bc592a6791), [TensorCore.Regression.EFMachine.negative_residual](../Regression/MachineSplit.md#decl-f12f3766824311d7)

</details>

</details>

<a id="decl-596556927b61a3b2"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude_coarse_truncGrid</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L101)

```lean
/-- The machine coarse component refines the existing exact truncation, at arbitrary
binary scale and for either sign. No component equality is assumed. -/
theorem splitMagnitude_coarse_truncGrid (negative : Bool) (m : BitVec 24)
    (gap : BitVec 8) (scale : ℤ) :
    signedDyadic negative (splitMagnitude m gap).coarse.toNat scale =
      truncGrid (signedDyadic negative m.toNat scale) (scale + gap.toNat) := by
  have hp := pow2_pos scale
  have hd : 0 < (2 ^ gap.toNat : ℕ) := Nat.two_pow_pos _
  have hdp : (0 : ℚ) < ((2 ^ gap.toNat : ℕ) : ℚ) := Rat.natCast_pos.mpr hd
  have he : pow2 (scale + gap.toNat) = pow2 scale * ((2 ^ gap.toNat : ℕ) : ℚ) := by
    rw [pow2_add, pow2_natCast]
  have hdiv : (m.toNat : ℚ) * pow2 scale / pow2 (scale + gap.toNat) =
      (m.toNat : ℚ) / ((2 ^ gap.toNat : ℕ) : ℚ) := by
    rw [he]
    have hne := Rat.ne_of_gt hp
    have hdne := Rat.ne_of_gt hdp
    rw [Rat.div_def, Rat.inv_mul_rev]
    have hcancel := Rat.mul_inv_cancel (pow2 scale) hne
    rw [Rat.div_def]
    grind
  have hnonneg : (0 : ℚ) ≤ (m.toNat : ℚ) * pow2 scale :=
    Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt hp)
  have hpos : ((splitMagnitude m gap).coarse.toNat : ℚ) * pow2 scale =
      truncGrid ((m.toNat : ℚ) * pow2 scale) (scale + gap.toNat) := by
    rw [alignment_value, truncCoeff_nonneg_eq _ _ hnonneg, hdiv,
      floor_nat_div _ _ hd, splitMagnitude_coarse, Rat.natCast_mul, he]
    simp only [Rat.intCast_natCast]
    grind
  cases negative
  · exact hpos
  · simpa only [signedDyadic, Bool.false_eq_true, if_false, if_true, truncGrid_neg] using congrArg Neg.neg hpos
```

**Supporting proofs:** [TensorCore.EFMachine.splitMagnitude_coarse](Split.md#decl-a57af4a3cd6f414f), [TensorCore.alignment_value](../../Core/Truncation.md#decl-4fd20c57624d75c8), [TensorCore.pow2_add](../../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120), [TensorCore.truncCoeff_nonneg_eq](../../Core/Truncation.md#decl-a3484604d19e0df2), [TensorCore.truncGrid_neg](../../Core/Truncation.md#decl-5a536b3a975b733c), [TensorCore.EFMachine.floor_nat_div](Split.md#decl-b148729eb2b2141d)

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.signedDyadic](Split.md#decl-763c208b0e2b895c), [TensorCore.EFMachine.splitMagnitude](SplitDefs.md#decl-cd5e2ed872b48654), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](../../Core/Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.splitMagnitude_low_residual](Split.md#decl-6d6fe2bc592a6791)

</details>

</details>

<a id="decl-6d6fe2bc592a6791"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude_low_residual</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Split.lean#L132)

```lean
/-- The low component refines the independently specified exact residual. -/
theorem splitMagnitude_low_residual (negative : Bool) (m : BitVec 24)
    (gap : BitVec 8) (scale : ℤ) :
    signedDyadic negative (splitMagnitude m gap).low.toNat scale =
      signedDyadic negative m.toNat scale -
        truncGrid (signedDyadic negative m.toNat scale) (scale + gap.toNat) := by
  rw [← splitMagnitude_coarse_truncGrid]
  have h := splitMagnitude_reconstruct m gap
  have hq := congrArg (fun n : ℕ => (n : ℚ)) h
  rw [Rat.natCast_add] at hq
  cases negative <;> simp only [signedDyadic, Bool.false_eq_true, if_false, if_true] <;> grind
```

**Supporting proofs:** [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_reconstruct](Split.md#decl-05bc6c16610d5178)

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](SplitDefs.md#decl-d377875ed5ceec31), [TensorCore.EFMachine.signedDyadic](Split.md#decl-763c208b0e2b895c), [TensorCore.EFMachine.splitMagnitude](SplitDefs.md#decl-cd5e2ed872b48654), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.truncGrid](../../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.EFMachine.negative_residual](../Regression/MachineSplit.md#decl-f12f3766824311d7)

</details>

</details>
