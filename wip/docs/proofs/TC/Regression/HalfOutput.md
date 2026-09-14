> Archived proof page from `050b50734a9cc9cb4fe6c229b676042874c87f79`. Links refer to that revision.

# TensorCore.TC.Regression.HalfOutput

[Index](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-682138777079290e"></a>

<details>
<summary><code>TensorCore.Regression.halfRow</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/HalfOutput.lean#L16)

```lean
def halfRow : List (F16 × F16) := [(0x3bd5, 0x38ca), (0x3c3e, 0xb935), (0xb534, 0x36bf), (0x3df8, 0x34ec)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.half_published_row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/HalfOutput.md#decl-147fa80584a17d2c)

</details>

</details>

<a id="decl-147fa80584a17d2c"></a>

<details>
<summary><code>TensorCore.Regression.half_published_row</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/HalfOutput.lean#L19)

```lean
/-- Published V100 FP16-output row 1: device output `3cdc` from both candidates. -/
theorem half_published_row :
    (invocationBits (p := v100HalfDirectCandidate) ⟨halfRow, 0x3bfa⟩).map BitVec.toNat =
      some 0x3cdc ∧
    (invocationBits (p := v100HalfStagedCandidate) ⟨halfRow, 0x3bfa⟩).map BitVec.toNat =
      some 0x3cdc := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.width](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationInput](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.Regression.halfRow](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/HalfOutput.md#decl-682138777079290e), [TensorCore.invocationBits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-c68ad16b896f3817), [TensorCore.v100HalfDirectCandidate](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Profiles.md#decl-5079e6cca6513c89), [TensorCore.v100HalfStagedCandidate](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Profiles.md#decl-acd1dc2d20623ae7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2c3b5d49cb92f58f"></a>

<details>
<summary><code>TensorCore.Regression.halfSplitter</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/HalfOutput.lean#L26)

```lean
/-- A double-rounding input on which the two stage orders differ. -/
def halfSplitter : List (F16 × F16) := [(0x3c00, 0x3c00), (0x2800, 0x2800), (0x0c00, 0x1000), (0, 0)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.half_output_stage_order](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/HalfOutput.md#decl-f5190132a2f03d58)

</details>

</details>

<a id="decl-f5190132a2f03d58"></a>

<details>
<summary><code>TensorCore.Regression.half_output_stage_order</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/HalfOutput.lean#L28)

```lean
theorem half_output_stage_order :
    (invocationBits (p := v100HalfDirectCandidate) ⟨halfSplitter, 0x3c00⟩).map BitVec.toNat =
      some 0x4001 ∧
    (invocationBits (p := v100HalfStagedCandidate) ⟨halfSplitter, 0x3c00⟩).map BitVec.toNat =
      some 0x4000 ∧
    invocationIdeal (p := v100HalfDirectCandidate) ⟨halfSplitter, 0x3c00⟩ =
      some (2 + 1 / 1024 + 1 / 8388608) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.width](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationInput](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.Regression.halfSplitter](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/HalfOutput.md#decl-2c3b5d49cb92f58f), [TensorCore.invocationBits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-c68ad16b896f3817), [TensorCore.invocationIdeal](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-ce5a842b255050cf), [TensorCore.v100HalfDirectCandidate](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Profiles.md#decl-5079e6cca6513c89), [TensorCore.v100HalfStagedCandidate](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Profiles.md#decl-acd1dc2d20623ae7)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
