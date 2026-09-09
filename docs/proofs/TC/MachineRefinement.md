# TensorCore.TC.MachineRefinement

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d2f2aa91376a054f"></a>

<details>
<summary><code>TensorCore.evalPreparedMachine_eq</code></summary>

[Lean source](../../../TensorCore/TC/MachineRefinement.lean#L8)

```lean
theorem evalPreparedMachine_eq (b : PreparedBlock) (w : ℕ) (hw : 0 < w)
    (h : magnitudeSum b.coefficients < 2 ^ (w - 1)) :
    evalPreparedMachine w b = evalPrepared b := by
  simp only [evalPreparedMachine, evalPrepared, machineAccumulator_eq b w hw h]
  rfl
```

**Supporting proofs:** [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58)

</details>

</details>

<a id="decl-d4518ab25c18ea58"></a>

<details>
<summary><code>TensorCore.evalBlockMachine_eq</code></summary>

[Lean source](../../../TensorCore/TC/MachineRefinement.lean#L16)

```lean
/-- All encoded inputs have identical reference and machine results at any adequate
width. This includes wrong shapes, nonfinite operands, and output-range rejections. -/
theorem evalBlockMachine_eq {p : Profile} (x : BlockInput p) (w F carryBits : ℕ)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits)
    (hw : F + 2 + carryBits + 1 ≤ w) : evalBlockMachine w x = evalBlock x := by
  unfold evalBlockMachine evalBlock
  split
  · rfl
  · rename_i hshape
    have hs : x.products.length = p.products := by simpa using hshape
    cases hp : prepare x with
    | none => rfl
    | some b =>
      apply evalPreparedMachine_eq b w (by omega)
      have hc := prepare_coefficient_capacity hp hs F carryBits hF hcount
      have hm : 2 ^ ((F + 2 + carryBits + 1) - 1) ≤ 2 ^ (w - 1) :=
        Nat.pow_le_pow_right (by decide) (by omega)
      omega
```

**Supporting proofs:** [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.machine_eq_paper](Specification/Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.runBlocksMachine_eq](Program/DotProduct.md#decl-69afa0bf303103ec), [TensorCore.v100_machine_eq](MachineRefinement.md#decl-4818474771f10689)

</details>

</details>

<a id="decl-528413e0ee3dba60"></a>

<details>
<summary><code>TensorCore.fp16Fp32_machine_eq</code></summary>

[Lean source](../../../TensorCore/TC/MachineRefinement.lean#L33)

```lean
theorem fp16Fp32_machine_eq (K extra carryBits w : ℕ) (floor : Option ℤ)
    (x : BlockInput (fp16Fp32Profile K extra floor))
    (hc : K + 1 ≤ 2 ^ carryBits) (hw : 26 + extra + carryBits ≤ w) :
    evalBlockMachine w x = evalBlock x :=
  evalBlockMachine_eq x w (23 + extra) carryBits rfl hc (by omega)
```

**Supporting proofs:** [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b)

</details>

</details>

<a id="decl-4818474771f10689"></a>

<details>
<summary><code>TensorCore.v100_machine_eq</code></summary>

[Lean source](../../../TensorCore/TC/MachineRefinement.lean#L39)

```lean
theorem v100_machine_eq (x : BlockInput v100F16F32) :
    evalBlockMachine 29 x = evalBlock x :=
  evalBlockMachine_eq x 29 23 3 rfl (by decide) (by decide)
```

**Supporting proofs:** [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.v100F16F32](Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-16fb9b96706fbec4"></a>

<details>
<summary><code>TensorCore.ampere_machine_eq</code></summary>

[Lean source](../../../TensorCore/TC/MachineRefinement.lean#L43)

```lean
theorem ampere_machine_eq (x : BlockInput ampereF16F32) :
    evalBlockMachine 31 x = evalBlock x :=
  fp16Fp32_machine_eq 8 1 4 31 (some (-132)) x (by decide) (by decide)
```

**Supporting proofs:** [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.ampereF16F32](CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ec34a5ffce80d97b"></a>

<details>
<summary><code>TensorCore.hopper_machine_eq</code></summary>

[Lean source](../../../TensorCore/TC/MachineRefinement.lean#L47)

```lean
theorem hopper_machine_eq (x : BlockInput hopperF16F32) :
    evalBlockMachine 33 x = evalBlock x :=
  fp16Fp32_machine_eq 16 2 5 33 (some (-133)) x (by decide) (by decide)
```

**Supporting proofs:** [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.hopperF16F32](CanonicalDefs.md#decl-3d43fc64b9e4a784)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
