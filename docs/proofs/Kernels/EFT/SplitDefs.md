# TensorCore.Kernels.EFT.SplitDefs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d377875ed5ceec31"></a>

<details>
<summary><code>TensorCore.EFMachine.SplitMagnitude</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/SplitDefs.lean#L11)

```lean
structure SplitMagnitude where
  coarse : BitVec 24
  low : BitVec 24
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.splitMagnitude](SplitDefs.md#decl-cd5e2ed872b48654), [TensorCore.EFMachine.splitMagnitude_coarse](Split.md#decl-a57af4a3cd6f414f), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low](Split.md#decl-be65c44fdce1d820), [TensorCore.EFMachine.splitMagnitude_low_lt](Split.md#decl-cb49563084f7df38), [TensorCore.EFMachine.splitMagnitude_low_residual](Split.md#decl-6d6fe2bc592a6791), [TensorCore.EFMachine.splitMagnitude_reconstruct](Split.md#decl-05bc6c16610d5178), [TensorCore.Regression.EFMachine.negative_residual](../../Tests/EFT/MachineSplit.md#decl-f12f3766824311d7), [TensorCore.Regression.EFMachine.split_boundaries](../../Tests/EFT/MachineSplit.md#decl-7e2050099cf55f3e)

</details>

</details>

<a id="decl-cd5e2ed872b48654"></a>

<details>
<summary><code>TensorCore.EFMachine.splitMagnitude</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/SplitDefs.lean#L18)

```lean
/-- Split a magnitude at `gap` low bits. The explicit large-gap branch avoids
platform-dependent masked shifts. On the other branch the shift count is below 24. -/
def splitMagnitude (m : BitVec 24) (gap : BitVec 8) : SplitMagnitude :=
  if gap ≥ 24 then ⟨0, m⟩
  else
    let coarse := (m >>> gap) <<< gap
    ⟨coarse, m - coarse⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.SplitMagnitude](SplitDefs.md#decl-d377875ed5ceec31)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.splitMagnitude_coarse](Split.md#decl-a57af4a3cd6f414f), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low](Split.md#decl-be65c44fdce1d820), [TensorCore.EFMachine.splitMagnitude_low_lt](Split.md#decl-cb49563084f7df38), [TensorCore.EFMachine.splitMagnitude_low_residual](Split.md#decl-6d6fe2bc592a6791), [TensorCore.EFMachine.splitMagnitude_reconstruct](Split.md#decl-05bc6c16610d5178), [TensorCore.Regression.EFMachine.negative_residual](../../Tests/EFT/MachineSplit.md#decl-f12f3766824311d7), [TensorCore.Regression.EFMachine.split_boundaries](../../Tests/EFT/MachineSplit.md#decl-7e2050099cf55f3e)

</details>

</details>

<a id="decl-fa9d1dd91a2047b7"></a>

<details>
<summary><code>TensorCore.EFMachine.multiplySignificands</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/SplitDefs.lean#L25)

```lean
/-- Multiply two unsigned FP16 significands after widening, so every product fits. -/
def multiplySignificands (a b : BitVec 11) : BitVec 24 :=
  a.zeroExtend 24 * b.zeroExtend 24
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.multiplySignificands_exact](Split.md#decl-7154e65664b6f748), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.Regression.EFMachine.product_maximum](../../Tests/EFT/MachineSplit.md#decl-da946ed9e47550b4)

</details>

</details>
