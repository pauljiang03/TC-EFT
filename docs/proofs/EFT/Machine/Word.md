# TensorCore.EFT.Machine.Word

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-eb624cca7c61f035"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.neg_coefficient</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L10)

```lean
theorem Word.neg_coefficient (x : Word) : x.neg.coefficient = -x.coefficient := by
  cases hn : x.negative <;> simp [Word.neg, Word.coefficient, hn]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.neg_value](Word.md#decl-2d5527f4636e4785)

</details>

</details>

<a id="decl-2d5527f4636e4785"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.neg_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L13)

```lean
theorem Word.neg_value (x : Word) : x.neg.value = -x.value := by
  simp [Word.value, Word.neg_coefficient, Rat.neg_mul]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.neg_coefficient](Word.md#decl-eb624cca7c61f035)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.sub_value](Word.md#decl-0b550b776f4cac6a)

</details>

</details>

<a id="decl-89220ff5bda6d20c"></a>

<details>
<summary><code>TensorCore.EFMachine.magnitude_add_no_wrap</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L16)

```lean
theorem magnitude_add_no_wrap (a b : Magnitude) :
    ¬ a + b < a ↔ a.toNat + b.toNat < 2 ^ 576 := by
  have ha := a.isLt
  have hb := b.isLt
  simp only [BitVec.lt_def, BitVec.toNat_add]
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.add_coefficient](Word.md#decl-8e4d668108a43518), [TensorCore.EFMachine.Word.add_exists](Word.md#decl-72199538c51a73d2)

</details>

</details>

<a id="decl-8e4d668108a43518"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.add_coefficient</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L23)

```lean
theorem Word.add_coefficient {x y z : Word} (h : x.add y = some z) :
    z.coefficient = x.coefficient + y.coefficient := by
  unfold Word.add at h
  dsimp only at h
  split at h
  · rename_i hs
    have hs' : x.negative = y.negative := by simpa using hs
    split at h
    · contradiction
    · rename_i hn
      cases Option.some.inj h
      have hw := magnitude_add_no_wrap x.magnitude y.magnitude |>.mp hn
      simp only [Word.coefficient, BitVec.toNat_add, Nat.mod_eq_of_lt hw, hs']
      cases y.negative <;> simp <;> omega
  · rename_i hs
    have hs' : x.negative ≠ y.negative := by simpa using hs
    split at h
    · rename_i hm
      cases Option.some.inj h
      have hm' : y.magnitude.toNat ≤ x.magnitude.toNat := hm
      rw [Word.coefficient, BitVec.toNat_sub_of_le hm, Int.ofNat_sub hm']
      cases hx : x.negative <;> cases hy : y.negative <;>
        simp_all [Word.coefficient] <;> omega
    · rename_i hm
      cases Option.some.inj h
      have hm' : x.magnitude ≤ y.magnitude := by
        simp only [BitVec.le_def] at *; omega
      rw [Word.coefficient, BitVec.toNat_sub_of_le hm', Int.ofNat_sub hm']
      cases hx : x.negative <;> cases hy : y.negative <;>
        simp_all [Word.coefficient] <;> omega
```

**Supporting proofs:** [TensorCore.EFMachine.magnitude_add_no_wrap](Word.md#decl-89220ff5bda6d20c)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4)

</details>

</details>

<a id="decl-888a94b87381a4b4"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.add_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L54)

```lean
theorem Word.add_value {x y z : Word} (h : x.add y = some z) :
    z.value = x.value + y.value := by
  simp only [Word.value, Word.add_coefficient h, Rat.intCast_add, Rat.add_mul]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_coefficient](Word.md#decl-8e4d668108a43518)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.sub_value](Word.md#decl-0b550b776f4cac6a), [TensorCore.EFMachine.add32WithLean_eq](../Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4)

</details>

</details>

<a id="decl-0b550b776f4cac6a"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.sub_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L58)

```lean
theorem Word.sub_value {x y z : Word} (h : x.sub y = some z) :
    z.value = x.value - y.value := by
  have ha := Word.add_value h
  rw [Word.neg_value] at ha
  simpa [Rat.sub_eq_add_neg] using ha
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.neg_value](Word.md#decl-2d5527f4636e4785)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.sub](WordDefs.md#decl-31dba9dd75052db7), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e)

</details>

</details>

<a id="decl-72199538c51a73d2"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.add_exists</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L65)

```lean
/-- A sufficient input-derived magnitude budget guarantees an accepted addition. -/
theorem Word.add_exists (x y : Word)
    (h : x.magnitude.toNat + y.magnitude.toNat < 2 ^ 576) :
    ∃ z, x.add y = some z := by
  unfold Word.add
  split
  · rw [if_neg ((magnitude_add_no_wrap _ _).mpr h)]
    exact ⟨_, rfl⟩
  · split <;> exact ⟨_, rfl⟩
```

**Supporting proofs:** [TensorCore.EFMachine.magnitude_add_no_wrap](Word.md#decl-89220ff5bda6d20c)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0)

</details>

</details>

<a id="decl-53b494a56c2c7d9a"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.add_magnitude</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L74)

```lean
theorem Word.add_magnitude {x y z : Word} (h : x.add y = some z) :
    z.magnitude.toNat ≤ x.magnitude.toNat + y.magnitude.toNat := by
  unfold Word.add at h
  dsimp only at h
  split at h
  · split at h
    · contradiction
    · cases Option.some.inj h
      simp only [BitVec.toNat_add]
      exact Nat.mod_le _ _
  · split at h
    · rename_i hm
      cases Option.some.inj h
      rw [BitVec.toNat_sub_of_le hm]
      omega
    · rename_i hm
      cases Option.some.inj h
      have hm' : x.magnitude ≤ y.magnitude := by
        simp only [BitVec.le_def] at *; omega
      rw [BitVec.toNat_sub_of_le hm']
      omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0)

</details>

</details>

<a id="decl-c50a82a7014218e4"></a>

<details>
<summary><code>TensorCore.EFMachine.sumWords_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L96)

```lean
theorem sumWords_value {xs : List Word} {z : Word} (h : sumWords xs = some z) :
    z.value = sumQ (xs.map Word.value) := by
  induction xs generalizing z with
  | nil => cases Option.some.inj h; simp [Word.value, Word.coefficient, Word.zero, sumQ]
  | cons x xs ih =>
    cases hs : sumWords xs with
    | none => simp [sumWords, hs] at h
    | some y =>
      simp only [sumWords, hs] at h
      rw [Word.add_value h, ih hs]
      rfl
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.Word.zero](WordDefs.md#decl-6c4317a5e83370fa), [TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e)

</details>

</details>

<a id="decl-0632d0aa311c3d92"></a>

<details>
<summary><code>TensorCore.EFMachine.wordBudget</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L108)

```lean
def wordBudget (xs : List Word) : ℕ := (xs.map fun x => x.magnitude.toNat).sum
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0)

</details>

</details>

<a id="decl-3960d51da75c24b0"></a>

<details>
<summary><code>TensorCore.EFMachine.sumWords_exists</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L111)

```lean
/-- Every suffix sum fits under the original inputs' absolute budget. -/
theorem sumWords_exists (xs : List Word) (h : wordBudget xs < 2 ^ 576) :
    ∃ z, sumWords xs = some z ∧ z.magnitude.toNat ≤ wordBudget xs := by
  induction xs with
  | nil => exact ⟨Word.zero, rfl, by simp [wordBudget, Word.zero]⟩
  | cons x xs ih =>
    have hb : wordBudget (x :: xs) = x.magnitude.toNat + wordBudget xs := by
      simp [wordBudget]
    obtain ⟨y, hy, hmy⟩ := ih (by omega)
    obtain ⟨z, hz⟩ := Word.add_exists x y (by omega)
    refine ⟨z, by simp [sumWords, hy, hz], ?_⟩
    have hm := Word.add_magnitude hz
    omega
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_exists](Word.md#decl-72199538c51a73d2), [TensorCore.EFMachine.Word.add_magnitude](Word.md#decl-53b494a56c2c7d9a)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.zero](WordDefs.md#decl-6c4317a5e83370fa), [TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91), [TensorCore.EFMachine.wordBudget](Word.md#decl-0632d0aa311c3d92)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f)

</details>

</details>

<a id="decl-16bf34f9d85335a9"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_coarse</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L124)

```lean
theorem Word.split_coarse (x : Word) (g : Grid) :
    (x.split g).coarse.magnitude.toNat = x.magnitude.toNat / 2 ^ g.toNat * 2 ^ g.toNat := by
  have hm := x.magnitude.isLt
  have hle := Nat.div_mul_le_self x.magnitude.toNat (2 ^ g.toNat)
  unfold Word.split
  split
  · rename_i hg
    have hg' : 576 ≤ g.toNat := by simpa [BitVec.le_def] using hg
    have hp : 2 ^ 576 ≤ 2 ^ g.toNat := Nat.pow_le_pow_right (by decide) hg'
    have hz : x.magnitude.toNat / 2 ^ g.toNat = 0 := Nat.div_eq_of_lt (by omega)
    simp [hz]
  · change (((x.magnitude >>> g.toNat) <<< g.toNat) : Magnitude).toNat = _
    rw [BitVec.toNat_shiftLeft, BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow,
      Nat.shiftLeft_eq, Nat.mod_eq_of_lt (by omega)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80), [TensorCore.EFMachine.Word.split_magnitude](Word.md#decl-c8c834f6a1821fc0), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf)

</details>

</details>

<a id="decl-d1e0b15124927d80"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_low</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L139)

```lean
theorem Word.split_low (x : Word) (g : Grid) :
    (x.split g).low.magnitude.toNat = x.magnitude.toNat % 2 ^ g.toNat := by
  have hc := x.split_coarse g
  have hle := Nat.div_mul_le_self x.magnitude.toNat (2 ^ g.toNat)
  have hmod := Nat.mod_add_div x.magnitude.toNat (2 ^ g.toNat)
  rw [Nat.mul_comm] at hmod
  by_cases hg : g ≥ 576
  · simp only [Word.split, if_pos hg] at hc ⊢
    have hz : x.magnitude.toNat / 2 ^ g.toNat * 2 ^ g.toNat = 0 := by simpa using hc.symm
    omega
  · simp only [Word.split, if_neg hg] at hc ⊢
    rw [BitVec.toNat_sub_of_le (by rw [BitVec.le_def, hc]; exact hle), hc]
    omega
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_magnitude](Word.md#decl-c8c834f6a1821fc0), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf)

</details>

</details>

<a id="decl-2477bb5e600645f0"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_sign</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L153)

```lean
theorem Word.split_sign (x : Word) (g : Grid) :
    (x.split g).coarse.negative = x.negative ∧ (x.split g).low.negative = x.negative := by
  unfold Word.split; split <;> exact ⟨rfl, rfl⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf)

</details>

</details>

<a id="decl-86df21d9c0f746cf"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_reconstruct</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L157)

```lean
theorem Word.split_reconstruct (x : Word) (g : Grid) :
    (x.split g).coarse.value + (x.split g).low.value = x.value := by
  have hc := x.split_coarse g
  have hl := x.split_low g
  have hm := Nat.mod_add_div x.magnitude.toNat (2 ^ g.toNat)
  rw [Nat.mul_comm] at hm
  have hn : (x.split g).coarse.magnitude.toNat + (x.split g).low.magnitude.toNat =
      x.magnitude.toNat := by omega
  have hi := congrArg (fun n : ℕ => (n : ℤ)) hn
  simp only [Int.natCast_add] at hi
  have hs := x.split_sign g
  have he : (x.split g).coarse.coefficient + (x.split g).low.coefficient = x.coefficient := by
    simp only [Word.coefficient, hs.1, hs.2]
    cases x.negative <;> simp_all <;> omega
  simp only [Word.value, ← Rat.add_mul, ← Rat.intCast_add, he]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80), [TensorCore.EFMachine.Word.split_sign](Word.md#decl-2477bb5e600645f0)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0)

</details>

</details>

<a id="decl-c8c834f6a1821fc0"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split_magnitude</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Word.lean#L173)

```lean
theorem Word.split_magnitude (x : Word) (g : Grid) :
    (x.split g).coarse.magnitude.toNat ≤ x.magnitude.toNat ∧
    (x.split g).low.magnitude.toNat ≤ x.magnitude.toNat := by
  rw [x.split_coarse, x.split_low]
  exact ⟨Nat.div_mul_le_self _ _, Nat.mod_le _ _⟩
```

**Supporting proofs:** [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d)

</details>

</details>
