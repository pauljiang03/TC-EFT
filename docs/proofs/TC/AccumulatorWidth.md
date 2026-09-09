# TensorCore.TC.AccumulatorWidth

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-297efa863148b988"></a>

<details>
<summary><code>TensorCore.machineAccumulate_eq</code></summary>

[Lean source](../../../TensorCore/TC/AccumulatorWidth.lean#L8)

```lean
theorem machineAccumulate_eq (w : ℕ) (initial : ℤ) (zs : List ℤ) :
    machineAccumulate w (BitVec.ofInt w initial) zs = BitVec.ofInt w (initial + sumZ zs) := by
  induction zs generalizing initial with
  | nil => simp [machineAccumulate, sumZ]
  | cons z zs ih =>
    simp only [machineAccumulate, ← BitVec.ofInt_add, ih, sumZ]
    congr 1
    omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.machineAccumulate](Accumulator.md#decl-5ea736d0760d39b4), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.machineAccumulate_exact](AccumulatorWidth.md#decl-80c3acbccc8106eb)

</details>

</details>

<a id="decl-80c3acbccc8106eb"></a>

<details>
<summary><code>TensorCore.machineAccumulate_exact</code></summary>

[Lean source](../../../TensorCore/TC/AccumulatorWidth.lean#L18)

```lean
/-- Final signed value is exact whenever total absolute support fits the positive range. -/
theorem machineAccumulate_exact (w : ℕ) (zs : List ℤ) (hw : 0 < w)
    (h : magnitudeSum zs < 2 ^ (w - 1)) :
    (machineAccumulate w 0 zs).toInt = sumZ zs := by
  have hs := sumZ_natAbs_le zs
  have hp : ((2 ^ (w - 1) : ℕ) : ℤ) = (2 : ℤ) ^ (w - 1) := by simp
  have hb : (machineAccumulate w 0 zs) = BitVec.ofInt w (sumZ zs) := by
    simpa using machineAccumulate_eq w 0 zs
  rw [hb]
  apply BitVec.toInt_ofInt_eq_self hw <;> omega
```

**Supporting proofs:** [TensorCore.machineAccumulate_eq](AccumulatorWidth.md#decl-297efa863148b988), [TensorCore.sumZ_natAbs_le](../Core/Sum.md#decl-d8b1b90e2d6e4d96)

**Definitions and types:** [TensorCore.machineAccumulate](Accumulator.md#decl-5ea736d0760d39b4), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.machineAccumulate_of_coefficient_bound](AccumulatorWidth.md#decl-c1bb27c5ce2e7d98), [TensorCore.machineAccumulate_prefix_exact](AccumulatorWidth.md#decl-9b23fe9fc6ec5adf), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5)

</details>

</details>

<a id="decl-9b23fe9fc6ec5adf"></a>

<details>
<summary><code>TensorCore.machineAccumulate_prefix_exact</code></summary>

[Lean source](../../../TensorCore/TC/AccumulatorWidth.lean#L29)

```lean
/-- Every prefix is exact under the same support condition, even with cancellation. -/
theorem machineAccumulate_prefix_exact (w : ℕ) (xs ys : List ℤ) (hw : 0 < w)
    (h : magnitudeSum (xs ++ ys) < 2 ^ (w - 1)) :
    (machineAccumulate w 0 xs).toInt = sumZ xs := by
  apply machineAccumulate_exact w xs hw
  rw [magnitudeSum_append] at h
  omega
```

**Supporting proofs:** [TensorCore.machineAccumulate_exact](AccumulatorWidth.md#decl-80c3acbccc8106eb), [TensorCore.magnitudeSum_append](../Core/Sum.md#decl-277547ea66e0e0cf)

**Definitions and types:** [TensorCore.machineAccumulate](Accumulator.md#decl-5ea736d0760d39b4), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733)

</details>

</details>

<a id="decl-c1bb27c5ce2e7d98"></a>

<details>
<summary><code>TensorCore.machineAccumulate_of_coefficient_bound</code></summary>

[Lean source](../../../TensorCore/TC/AccumulatorWidth.lean#L36)

```lean
theorem machineAccumulate_of_coefficient_bound (zs : List ℤ) (B c : ℕ)
    (hterm : ∀ z ∈ zs, z.natAbs < 2 ^ B) (hcount : zs.length ≤ 2 ^ c) :
    (machineAccumulate (B + c + 1) 0 zs).toInt = sumZ zs :=
  machineAccumulate_exact _ zs (by omega) (coefficient_width_sufficient zs B c hterm hcount)
```

**Supporting proofs:** [TensorCore.coefficient_width_sufficient](../Core/Sum.md#decl-50e5b749a17f1c03), [TensorCore.machineAccumulate_exact](AccumulatorWidth.md#decl-80c3acbccc8106eb)

**Definitions and types:** [TensorCore.machineAccumulate](Accumulator.md#decl-5ea736d0760d39b4), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-fa564636f9129fb5"></a>

<details>
<summary><code>TensorCore.machineAccumulator_eq</code></summary>

[Lean source](../../../TensorCore/TC/AccumulatorWidth.lean#L41)

```lean
theorem machineAccumulator_eq (b : PreparedBlock) (w : ℕ) (hw : 0 < w)
    (h : magnitudeSum b.coefficients < 2 ^ (w - 1)) :
    b.machineAccumulator w = b.accumulator := by
  unfold PreparedBlock.machineAccumulator PreparedBlock.accumulator
  rw [machineAccumulate_exact w b.coefficients hw h]
```

**Supporting proofs:** [TensorCore.machineAccumulate_exact](AccumulatorWidth.md#decl-80c3acbccc8106eb)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.machineAccumulate](Accumulator.md#decl-5ea736d0760d39b4), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f)

</details>

</details>
