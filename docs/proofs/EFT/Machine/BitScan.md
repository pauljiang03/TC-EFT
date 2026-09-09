# TensorCore.EFT.Machine.BitScan

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-613a0696640783fc"></a>

<details>
<summary><code>TensorCore.EFMachine.scanBoundary_correct</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L9)

```lean
theorem scanBoundary_correct (test : ℕ → Bool) (target limit fuel lo hi : ℕ)
    (ht : ∀ n, n < limit → (test n = true ↔ n < target))
    (hl : lo ≤ target) (hh : target ≤ hi) (hb : hi ≤ limit)
    (hw : hi - lo < 2 ^ fuel) :
    scanBoundary test fuel lo hi = target := by
  induction fuel generalizing lo hi with
  | zero => simp only [Nat.pow_zero] at hw; simp [scanBoundary]; omega
  | succ fuel ih =>
    rw [scanBoundary]
    split
    · rename_i hlt
      have hm : (lo + hi) / 2 < hi := by omega
      have hp : 2 ^ (fuel + 1) = 2 * 2 ^ fuel := by rw [Nat.pow_succ, Nat.mul_comm]
      rw [hp] at hw
      dsimp only
      split
      · rename_i htst
        have htarget := (ht _ (by omega)).mp htst
        apply ih _ _ (by omega) hh hb
        omega
      · rename_i htst
        have htarget : target ≤ (lo + hi) / 2 := by
          have : ¬ (lo + hi) / 2 < target := fun h => htst ((ht _ (by omega)).mpr h)
          omega
        apply ih _ _ hl htarget (by omega)
        omega
    · rename_i hlt
      omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.scanBoundary](BitScanDefs.md#decl-c67168584d6cebcb)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.leadingZeros_eq](BitScan.md#decl-6a874aca0a7bf352), [TensorCore.EFMachine.trailingZeros_eq](BitScan.md#decl-e84601fe6258d42b)

</details>

</details>

<a id="decl-5667ff2a832a1bf8"></a>

<details>
<summary><code>TensorCore.EFMachine.trailingZeros_test</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L38)

```lean
theorem trailingZeros_test (m : BitVec 576) (n : ℕ) (hn : n < 576) :
    (m.setWidth (n + 1) == 0) = true ↔ n < m.ctz.toNat := by
  constructor
  · intro h
    have he : m.setWidth (n + 1) = 0 := by simpa using h
    by_cases hn' : n < m.ctz.toNat
    · exact hn'
    · have hz : m ≠ 0 := BitVec.ctz_lt_iff_ne_zero.mp (by
        change m.ctz.toNat < 576
        omega)
      have hb := BitVec.getLsbD_true_ctz_of_ne_zero hz
      have ht := congrArg (fun b : BitVec (n + 1) => b.getLsbD m.ctz.toNat) he
      simp [show m.ctz.toNat < n + 1 by omega, hb] at ht
  · intro h
    apply beq_iff_eq.mpr
    apply BitVec.eq_of_getLsbD_eq
    intro i
    by_cases hi : i < n + 1
    · have hf := BitVec.getLsbD_false_of_lt_ctz (x := m) (show i < m.ctz.toNat by omega)
      simp [hi, hf]
    · simp [BitVec.getLsbD_setWidth, hi]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.trailingZeros_eq](BitScan.md#decl-e84601fe6258d42b)

</details>

</details>

<a id="decl-e84601fe6258d42b"></a>

<details>
<summary><code>TensorCore.EFMachine.trailingZeros_eq</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L60)

```lean
theorem trailingZeros_eq (m : BitVec 576) : trailingZeros m = m.ctz := by
  have hc : m.ctz.toNat ≤ 576 := by
    have h := BitVec.clz_le (x := m.reverse)
    simpa [BitVec.ctz, BitVec.le_def] using h
  have hs := scanBoundary_correct _ m.ctz.toNat 576 10 0 576
    (trailingZeros_test m) (by omega) hc (by omega) (by decide)
  unfold trailingZeros
  exact (congrArg (BitVec.ofNat 576) hs).trans (by simp)
```

**Supporting proofs:** [TensorCore.EFMachine.scanBoundary_correct](BitScan.md#decl-613a0696640783fc), [TensorCore.EFMachine.trailingZeros_test](BitScan.md#decl-5667ff2a832a1bf8)

**Definitions and types:** [TensorCore.EFMachine.scanBoundary](BitScanDefs.md#decl-c67168584d6cebcb), [TensorCore.EFMachine.trailingZeros](BitScanDefs.md#decl-f7c3937192f344ad)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8184f215f76b7017"></a>

<details>
<summary><code>TensorCore.EFMachine.leadingZeros_test</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L69)

```lean
theorem leadingZeros_test (m : BitVec 576) (n : ℕ) :
    ((m >>> n) != 0) = true ↔ n < 576 - m.clz.toNat := by
  have hc : m.clz.toNat ≤ 576 := by
    simpa [BitVec.le_def] using (BitVec.clz_le (x := m))
  have hu : ∀ j, m.getLsbD (576 - m.clz.toNat + j) = false :=
    BitVec.getLsbD_false_of_clzAuxRec (x := m) (n := 575)
      (by intro i hi; exact BitVec.getLsbD_of_ge m i (by omega))
  simp only [bne_iff_ne]
  constructor
  · intro h
    by_cases hn : n < 576 - m.clz.toNat
    · exact hn
    · apply False.elim (h ?_)
      apply BitVec.eq_of_getLsbD_eq
      intro i _
      have hz := hu (n + i - (576 - m.clz.toNat))
      have he : 576 - m.clz.toNat + (n + i - (576 - m.clz.toNat)) = n + i := by omega
      simpa [he, Nat.add_comm] using hz
  · intro hn hz
    have hm : m ≠ 0 := BitVec.clz_lt_iff_ne_zero.mp (by
      change m.clz.toNat < 576
      omega)
    have ht := BitVec.getLsbD_true_clz_of_ne_zero (x := m) (by decide) hm
    have he := congrArg (fun x : BitVec 576 => x.getLsbD (575 - m.clz.toNat - n)) hz
    have hi : n + (575 - m.clz.toNat - n) = 575 - m.clz.toNat := by omega
    change m.getLsbD (575 - m.clz.toNat) = true at ht
    simp [hi, ht] at he
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.leadingZeros_eq](BitScan.md#decl-6a874aca0a7bf352)

</details>

</details>

<a id="decl-6a874aca0a7bf352"></a>

<details>
<summary><code>TensorCore.EFMachine.leadingZeros_eq</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L97)

```lean
theorem leadingZeros_eq (m : BitVec 576) : leadingZeros m = m.clz := by
  have hc : m.clz.toNat ≤ 576 := by
    simpa [BitVec.le_def] using (BitVec.clz_le (x := m))
  have hs := scanBoundary_correct _ (576 - m.clz.toNat) 576 10 0 576
    (fun n _ => leadingZeros_test m n) (by omega) (by omega) (by omega) (by decide)
  unfold leadingZeros
  rw [hs]
  apply BitVec.eq_of_toNat_eq
  rw [BitVec.toNat_sub_of_le (by change (576 - m.clz.toNat) % 2 ^ 576 ≤ 576; omega)]
  change 576 - (576 - m.clz.toNat) % 2 ^ 576 = m.clz.toNat
  rw [Nat.mod_eq_of_lt (show 576 - m.clz.toNat < 2 ^ 576 by omega)]
  omega
```

**Supporting proofs:** [TensorCore.EFMachine.leadingZeros_test](BitScan.md#decl-8184f215f76b7017), [TensorCore.EFMachine.scanBoundary_correct](BitScan.md#decl-613a0696640783fc)

**Definitions and types:** [TensorCore.EFMachine.leadingZeros](BitScanDefs.md#decl-dc7b8bb67a09f476), [TensorCore.EFMachine.scanBoundary](BitScanDefs.md#decl-c67168584d6cebcb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingGrid_toNat](Round.md#decl-cab4fbf103e63d2a)

</details>

</details>

<a id="decl-9bb35112130e66cc"></a>

<details>
<summary><code>TensorCore.EFMachine.scanBoundaryTrace</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L112)

```lean
/-- Specification instrumentation: record exactly the probes made by scanBoundary.
This trace is absent from the executable EFT dependency graph. -/
def scanBoundaryTrace (test : ℕ → Bool) : ℕ → ℕ → ℕ → ℕ × List ℕ
  | 0, lo, _ => (lo, [])
  | fuel + 1, lo, hi =>
    if lo < hi then
      let mid := (lo + hi) / 2
      let next := if test mid then scanBoundaryTrace test fuel (mid + 1) hi
        else scanBoundaryTrace test fuel lo mid
      (next.1, mid :: next.2)
    else (lo, [])
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.bitScan_probe_budget](BitScan.md#decl-c51428ef6c88e999), [TensorCore.EFMachine.scanBoundaryTrace_bounds](BitScan.md#decl-ceefaf5db6e0c29d), [TensorCore.EFMachine.scanBoundaryTrace_result](BitScan.md#decl-eb1ad31b2f0a011c)

</details>

</details>

<a id="decl-eb1ad31b2f0a011c"></a>

<details>
<summary><code>TensorCore.EFMachine.scanBoundaryTrace_result</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L122)

```lean
theorem scanBoundaryTrace_result (test : ℕ → Bool) (fuel lo hi : ℕ) :
    (scanBoundaryTrace test fuel lo hi).1 = scanBoundary test fuel lo hi := by
  induction fuel generalizing lo hi with
  | zero => rfl
  | succ fuel ih =>
    simp only [scanBoundaryTrace, scanBoundary]
    split
    · dsimp only
      split <;> simp only [ih]
    · rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.scanBoundary](BitScanDefs.md#decl-c67168584d6cebcb), [TensorCore.EFMachine.scanBoundaryTrace](BitScan.md#decl-9bb35112130e66cc)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ceefaf5db6e0c29d"></a>

<details>
<summary><code>TensorCore.EFMachine.scanBoundaryTrace_bounds</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L133)

```lean
theorem scanBoundaryTrace_bounds (test : ℕ → Bool) (fuel lo hi : ℕ) :
    (scanBoundaryTrace test fuel lo hi).2.length ≤ fuel ∧
      ∀ n ∈ (scanBoundaryTrace test fuel lo hi).2, lo ≤ n ∧ n < hi := by
  induction fuel generalizing lo hi with
  | zero => simp [scanBoundaryTrace]
  | succ fuel ih =>
    rw [scanBoundaryTrace]
    split
    · rename_i hlt
      dsimp only
      have hm : lo ≤ (lo + hi) / 2 ∧ (lo + hi) / 2 < hi := by omega
      split
      · have ht := ih ((lo + hi) / 2 + 1) hi
        constructor
        · simpa only [List.length_cons] using Nat.succ_le_succ ht.1
        · intro n hn
          rcases List.mem_cons.mp hn with he | he
          · subst n; exact hm
          · have := ht.2 n he; omega
      · have ht := ih lo ((lo + hi) / 2)
        constructor
        · simpa only [List.length_cons] using Nat.succ_le_succ ht.1
        · intro n hn
          rcases List.mem_cons.mp hn with he | he
          · subst n; exact hm
          · have := ht.2 n he; omega
    · simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.scanBoundaryTrace](BitScan.md#decl-9bb35112130e66cc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.bitScan_probe_budget](BitScan.md#decl-c51428ef6c88e999)

</details>

</details>

<a id="decl-c51428ef6c88e999"></a>

<details>
<summary><code>TensorCore.EFMachine.bitScan_probe_budget</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/BitScan.lean#L163)

```lean
/-- Every probe index is below 576: all intermediate prefix words have width at
most 576, and at most ten probes are executed, including for the zero word. -/
theorem bitScan_probe_budget (test : ℕ → Bool) :
    (scanBoundaryTrace test 10 0 576).2.length ≤ 10 ∧
      ∀ n ∈ (scanBoundaryTrace test 10 0 576).2, n < 576 := by
  have h := scanBoundaryTrace_bounds test 10 0 576
  exact ⟨h.1, fun n hn => (h.2 n hn).2⟩
```

**Supporting proofs:** [TensorCore.EFMachine.scanBoundaryTrace_bounds](BitScan.md#decl-ceefaf5db6e0c29d)

**Definitions and types:** [TensorCore.EFMachine.scanBoundaryTrace](BitScan.md#decl-9bb35112130e66cc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
