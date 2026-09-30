# TensorCore.TC.Accumulator

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5ea736d0760d39b4"></a>

<details>
<summary><code>TensorCore.machineAccumulate</code></summary>

[Lean source](../../../TensorCore/TC/Accumulator.lean#L8)

```lean
/-- Actual modular signed-word additions, starting from a supplied register. -/
def machineAccumulate (w : ℕ) (acc : BitVec w) : List ℤ → BitVec w
  | [] => acc
  | z :: zs => machineAccumulate w (acc + BitVec.ofInt w z) zs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.Regression.signed_capacity_prefix](../Tests/TC/Features.md#decl-63bc25b56c070053), [TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.machineAccumulate_eq](AccumulatorWidth.md#decl-297efa863148b988), [TensorCore.machineAccumulate_exact](AccumulatorWidth.md#decl-80c3acbccc8106eb), [TensorCore.machineAccumulate_of_coefficient_bound](AccumulatorWidth.md#decl-c1bb27c5ce2e7d98), [TensorCore.machineAccumulate_prefix_exact](AccumulatorWidth.md#decl-9b23fe9fc6ec5adf), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5)

</details>

</details>

<a id="decl-9e58c7148c06ae54"></a>

<details>
<summary><code>TensorCore.PreparedBlock.machineAccumulator</code></summary>

[Lean source](../../../TensorCore/TC/Accumulator.lean#L13)

```lean
/-- Interpret the signed machine sum at the reference alignment quantum. -/
def PreparedBlock.machineAccumulator (b : PreparedBlock) (w : ℕ) : ℚ :=
  ((machineAccumulate w 0 b.coefficients).toInt : ℚ) * pow2 b.quantumExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.machineAccumulate](Accumulator.md#decl-5ea736d0760d39b4), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalPreparedMachine](Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalV100_machineAccumulator](AlignmentScale.md#decl-0fba10fcc54a6a0b), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478)

</details>

</details>

<a id="decl-0c49fa80fec5d50f"></a>

<details>
<summary><code>TensorCore.evalPreparedMachine</code></summary>

[Lean source](../../../TensorCore/TC/Accumulator.lean#L19)

```lean
/-- Execute accumulation with w-bit additions, then the ordinary FP32 conversion.
The trace retains the reference preparation. Equality to its reference accumulator
requires a sufficient-width proof; it is not part of this definition. -/
def evalPreparedMachine (w : ℕ) (b : PreparedBlock) : Except ModelError BlockTrace :=
  match round32 .towardZero (b.machineAccumulator w) with
  | none => .error .accumulatorOutOfRange
  | some bits => match finite32 bits with
    | none => .error .nonfiniteOutput
    | some d => .ok ⟨b, d⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f)

</details>

</details>

<a id="decl-ab9031f1fdf12cee"></a>

<details>
<summary><code>TensorCore.evalBlockMachine</code></summary>

[Lean source](../../../TensorCore/TC/Accumulator.lean#L26)

```lean
def evalBlockMachine (w : ℕ) {p : Profile} (x : BlockInput p) :
    Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => evalPreparedMachine w b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalPreparedMachine](Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.machine_eq_paper](Specification/Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.Regression.machine_width_changes_result](../Tests/TC/Features.md#decl-40bf2a8b421b9a65), [TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b), [TensorCore.v100_machine_eq](MachineRefinement.md#decl-4818474771f10689)

</details>

</details>
