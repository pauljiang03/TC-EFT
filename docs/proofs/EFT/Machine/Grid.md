# TensorCore.EFT.Machine.Grid

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3faa58580e24b52d"></a>

<details>
<summary><code>TensorCore.EFMachine.rawMaximum</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Grid.lean#L11)

```lean
/-- Specification of the raw maximum: zero terms are ignored, before any shift or
normalization. The profile floor is expressed using the same bias as term metadata. -/
def rawMaximum (ts : List Term) (initial : ℕ) : ℕ :=
  ts.foldl (fun e t => if t.word.magnitude = 0 then e else max e t.raw.toNat) initial
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.rawMaximum_eq](Grid.md#decl-97a05462cd1ee144), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769)

</details>

</details>

<a id="decl-97a05462cd1ee144"></a>

<details>
<summary><code>TensorCore.EFMachine.rawMaximum_eq</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Grid.lean#L14)

```lean
theorem rawMaximum_eq (ts : List Term) (e : Grid) :
    (ts.foldl (fun e t => if t.word.magnitude == 0 then e
      else if e ≤ t.raw then t.raw else e) e).toNat = rawMaximum ts e.toNat := by
  induction ts generalizing e with
  | nil => rfl
  | cons t ts ih =>
    simp only [List.foldl_cons, rawMaximum]
    rw [ih]
    by_cases hz : t.word.magnitude = 0
    · simp [hz, rawMaximum]
    · simp only [beq_iff_eq, hz, if_false]
      split
      · rename_i h; rw [Nat.max_eq_right h]; rfl
      · rename_i h
        have h' : t.raw.toNat ≤ e.toNat := by change ¬ e.toNat ≤ t.raw.toNat at h; omega
        rw [Nat.max_eq_left h']; rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.rawMaximum](Grid.md#decl-3faa58580e24b52d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769)

</details>

</details>

<a id="decl-966f710cc75730bb"></a>

<details>
<summary><code>TensorCore.EFMachine.outputGrid_spec</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Grid.lean#L31)

```lean
theorem outputGrid_spec (D : F32) :
    (outputGrid D).toNat = (D.toNat / 8388608 % 256) +
      (if D.toNat / 8388608 % 256 = 0 then 123 else 122) ∧
    ((outputGrid D).toNat : ℤ) - 272 = outputQuantumExponent D ∧
    123 ≤ (outputGrid D).toNat := by
  have he := fp32_exponent_toNat D
  have hb : D.toNat / 8388608 % 256 < 256 := Nat.mod_lt _ (by decide)
  unfold outputGrid
  by_cases hz : D.toNat / 8388608 % 256 = 0
  · have hz' : (((D >>> 23).setWidth 8).zeroExtend 10 : Grid) = 0 := by
      apply BitVec.eq_of_toNat_eq; simpa [hz] using he
    simp [hz', outputQuantumExponent, hz, emin32, Int.max_def]
  · have hz' : (((D >>> 23).setWidth 8).zeroExtend 10 : Grid) ≠ 0 := by
      intro h; have hh := congrArg BitVec.toNat h; rw [he] at hh; exact hz hh
    simp only [beq_iff_eq, hz', if_false, BitVec.toNat_add, he]
    have hm : (D.toNat / 8388608 % 256 + 122) % 1024 = D.toNat / 8388608 % 256 + 122 :=
      Nat.mod_eq_of_lt (by omega)
    simp only [show (122 : Grid).toNat = 122 from rfl, Nat.reducePow, hm, hz, if_false]
    unfold outputQuantumExponent
    simp only [Nat.reducePow, emin32]
    rw [Int.max_eq_left (by omega)]
    exact ⟨trivial, by omega, by omega⟩
```

**Supporting proofs:** [TensorCore.EFMachine.fp32_exponent_toNat](Decode.md#decl-54dae6f9ffe34c9d)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.outputGrid](WordDefs.md#decl-060f999f83e9c7c6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.emin32](../../Core/RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.outputQuantumExponent](../../Core/RoundOp.md#decl-70bb2de461b51682)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769)

</details>

</details>

<a id="decl-31f8d745f2b97769"></a>

<details>
<summary><code>TensorCore.EFMachine.selectedGrid_spec</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Grid.lean#L57)

```lean
/-- Exact qE=max(qA,qD), with qA obtained from raw exponents, not product magnitude.
The biased maximum starts at -512 for V100 (below every nonzero input raw scale),
and at the characterized architectural floor for Ampere/Hopper. -/
theorem selectedGrid_spec (path : Path) (ts : List Term) (D : F32) :
    ((selectedGrid path ts D).toNat : ℤ) - 272 =
      max ((rawMaximum ts path.floor.toNat : ℤ) - 512 - path.profile.alignFraction)
        (outputQuantumExponent D) := by
  have ho : (path.alignmentBits + 240).toNat = path.profile.alignFraction.toNat + 240 := by
    cases path <;> decide
  have hal : (path.profile.alignFraction.toNat : ℤ) = path.profile.alignFraction := by
    cases path <;> decide
  have hd := outputGrid_spec D
  unfold selectedGrid
  generalize he : ts.foldl _ path.floor = e
  have hem := rawMaximum_eq ts path.floor
  rw [he] at hem
  dsimp only
  by_cases hsmall : e < path.alignmentBits + 240
  · rw [if_pos hsmall, if_pos (show (0 : Grid) ≤ outputGrid D from by exact Nat.zero_le _)]
    rw [hd.2.1, Int.max_eq_right]
    change e.toNat < (path.alignmentBits + 240).toNat at hsmall
    rw [ho, hem] at hsmall
    omega
  · have hle : path.alignmentBits + 240 ≤ e := by
      change ¬ e.toNat < _ at hsmall; change _ ≤ e.toNat; omega
    have hsub : (e - (path.alignmentBits + 240)).toNat =
        rawMaximum ts path.floor.toNat - (path.profile.alignFraction.toNat + 240) := by
      rw [BitVec.toNat_sub_of_le hle, hem, ho]
    rw [if_neg hsmall]
    split
    · rename_i h
      change (e - (path.alignmentBits + 240)).toNat ≤ (outputGrid D).toNat at h
      rw [hsub] at h
      rw [hd.2.1, Int.max_eq_right]
      change (path.alignmentBits + 240).toNat ≤ e.toNat at hle
      rw [ho, hem] at hle
      omega
    · rename_i h
      change ¬ (e - (path.alignmentBits + 240)).toNat ≤ (outputGrid D).toNat at h
      rw [hsub] at h
      rw [hsub, Int.max_eq_left]
      · omega
      · omega
```

**Supporting proofs:** [TensorCore.EFMachine.outputGrid_spec](Grid.md#decl-966f710cc75730bb), [TensorCore.EFMachine.rawMaximum_eq](Grid.md#decl-97a05462cd1ee144)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Path](DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.alignmentBits](DecodeDefs.md#decl-409758bc0f53f8d1), [TensorCore.EFMachine.Path.floor](DecodeDefs.md#decl-cb3a933d840dd12f), [TensorCore.EFMachine.Path.profile](DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.outputGrid](WordDefs.md#decl-060f999f83e9c7c6), [TensorCore.EFMachine.rawMaximum](Grid.md#decl-3faa58580e24b52d), [TensorCore.EFMachine.selectedGrid](../Bounded.md#decl-026f0e297cb0d39a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.outputQuantumExponent](../../Core/RoundOp.md#decl-70bb2de461b51682)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
