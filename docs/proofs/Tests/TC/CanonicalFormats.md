# TensorCoreTests.TC.CanonicalFormats

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3aa2ab7a77ce764e"></a>

<details>
<summary><code>TensorCore.Regression.a100Bf16Row</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L13)

```lean
def a100Bf16Row : List (BitVec 16 × BitVec 16) :=
  [(0x3f7a, 0x3f19), (0x3f87, 0xbf26), (0xbea6, 0x3ed7), (0x3fbf, 0x3e9d), (0xbf3d, 0xbff3),
    (0x3ead, 0x3ef2), (0x3f80, 0xbfc1), (0x3fe8, 0xbf90)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.a100_bf16_published_row](CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.h100Bf16Row](CanonicalFormats.md#decl-aed79311be1382f6)

</details>

</details>

<a id="decl-aed79311be1382f6"></a>

<details>
<summary><code>TensorCore.Regression.h100Bf16Row</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L17)

```lean
def h100Bf16Row : List (BitVec 16 × BitVec 16) :=
  a100Bf16Row ++ [(0x3f62, 0x3dbf), (0x3f5d, 0xbf31), (0xbf8c, 0xbf52), (0x3eb3, 0x400e),
    (0x3cf1, 0xbc71), (0x3e9c, 0x401e), (0x3f86, 0x3e1c), (0x3f59, 0xbea4)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Regression.a100Bf16Row](CanonicalFormats.md#decl-3aa2ab7a77ce764e)

<details>
<summary>Used by</summary>

[TensorCore.Regression.h100_bf16_published_row](CanonicalFormats.md#decl-99837dca7e6541e3)

</details>

</details>

<a id="decl-381e49e3be9c0a43"></a>

<details>
<summary><code>TensorCore.Regression.tf32Row</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L21)

```lean
def tf32Row : List (tf32Register.Word × tf32Register.Word) :=
  [(0x3f7aa000, 0x3f194000), (0x3f87c000, 0xbf26a000), (0xbea68000, 0x3ed7e000),
    (0x3fbf0000, 0x3e9d8000)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.OperandEncoding.Word](../../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](../../Numerics/Format.md#decl-0e24771a882ef6eb), [TensorCore.tf32Register](../../Numerics/Format.md#decl-f0af86f5dcba47c8)

<details>
<summary>Used by</summary>

[TensorCore.Regression.tf32_published_rows](CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](CanonicalFormats.md#decl-c857f0b8ba84dbc8)

</details>

</details>

<a id="decl-cdaa9fc7deac3fab"></a>

<details>
<summary><code>TensorCore.Regression.a100_bf16_published_row</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L26)

```lean
/-- A100 BF16 row 1: device output `bfbe56d5` from the profile and from the descriptor. -/
theorem a100_bf16_published_row :
    (evalBlock (⟨a100Bf16Row, 0x3e8e06ad⟩ : BlockInput a100BF16F32)).toOption.map
      (fun t => t.output.bits.toNat) = some 0xbfbe56d5 ∧
    (invocationBits (p := a100BF16Invocation) ⟨a100Bf16Row, 0x3e8e06ad⟩).map BitVec.toNat =
      some 0xbfbe56d5 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationInput](../../TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](../../TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.a100Bf16Row](CanonicalFormats.md#decl-3aa2ab7a77ce764e), [TensorCore.a100BF16F32](../../TC/CanonicalFormatDefs.md#decl-93f6070f8a03aaee), [TensorCore.a100BF16Invocation](../../TC/Profiles.md#decl-5acb22a881be62d1), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.invocationBits](../../TC/Invocation.md#decl-c68ad16b896f3817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-99837dca7e6541e3"></a>

<details>
<summary><code>TensorCore.Regression.h100_bf16_published_row</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L33)

```lean
/-- H100 BF16 row 1: device output `3f3cc4dd`. -/
theorem h100_bf16_published_row :
    (evalBlock (⟨h100Bf16Row, 0x3f342579⟩ : BlockInput hopperBF16F32)).toOption.map
      (fun t => t.output.bits.toNat) = some 0x3f3cc4dd ∧
    (invocationBits (p := hopperBF16Invocation) ⟨h100Bf16Row, 0x3f342579⟩).map BitVec.toNat =
      some 0x3f3cc4dd := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.ConversionStage](../../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationInput](../../TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](../../TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.h100Bf16Row](CanonicalFormats.md#decl-aed79311be1382f6), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.hopperBF16F32](../../TC/CanonicalFormatDefs.md#decl-c021958593ae7dc6), [TensorCore.hopperBF16Invocation](../../TC/Profiles.md#decl-a5fe9df9d0e60b34), [TensorCore.invocationBits](../../TC/Invocation.md#decl-c68ad16b896f3817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1e06fafbd32db00b"></a>

<details>
<summary><code>TensorCore.Regression.tf32_published_rows</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L41)

```lean
/-- A100 and H100 TF32 row 1: the same four register-word pairs give `3f36f7de` on A100 and,
with a different accumulator input, `3f9888df` on H100, through both paths. -/
theorem tf32_published_rows :
    (tf32InvocationBits 4 24 (some (-132)) tf32Row 0x3efe7b25).map BitVec.toNat =
      some 0x3f36f7de ∧
    (evalBlock (⟨tf32UnpackPairs tf32Row, 0x3efe7b25⟩ : BlockInput a100TF32F32)).toOption.map
      (fun t => t.output.bits.toNat) = some 0x3f36f7de ∧
    (tf32InvocationBits 4 25 (some (-133)) tf32Row 0x3f795773).map BitVec.toNat =
      some 0x3f9888df ∧
    (evalBlock (⟨tf32UnpackPairs tf32Row, 0x3f795773⟩ : BlockInput hopperTF32WmmaF32)).toOption.map
      (fun t => t.output.bits.toNat) = some 0x3f9888df := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.tf32Row](CanonicalFormats.md#decl-381e49e3be9c0a43), [TensorCore.a100TF32F32](../../TC/CanonicalFormatDefs.md#decl-d2e41a9c0176d61b), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.hopperTF32WmmaF32](../../TC/CanonicalFormatDefs.md#decl-a012d676a51f02f1), [TensorCore.tf32InvocationBits](../../TC/CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32UnpackPairs](../../TC/CanonicalFormatDefs.md#decl-d49f9f58663603bc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-18627a02cd9991c4"></a>

<details>
<summary><code>TensorCore.Regression.tf32_unpadded_rejected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L53)

```lean
/-- A register word with a nonzero low bit is not a TF32 value: the descriptor rejects it,
while the profile would accept the truncated value word. -/
theorem tf32_unpadded_rejected :
    tf32Padded 0x3f7aa001 = false ∧
    tf32InvocationBits 4 24 (some (-132)) [(0x3f7aa001, 0x3f194000), (0, 0), (0, 0), (0, 0)] 0 =
      none ∧
    ((evalBlock (⟨tf32UnpackPairs [(0x3f7aa001, 0x3f194000), (0, 0), (0, 0), (0, 0)], 0⟩ :
      BlockInput a100TF32F32)).toOption.map (fun t => t.output.bits.toNat)).isSome = true := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding.Word](../../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](../../Numerics/Format.md#decl-0e24771a882ef6eb), [TensorCore.a100TF32F32](../../TC/CanonicalFormatDefs.md#decl-d2e41a9c0176d61b), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.tf32InvocationBits](../../TC/CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32Padded](../../TC/CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../../Numerics/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32UnpackPairs](../../TC/CanonicalFormatDefs.md#decl-d49f9f58663603bc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c857f0b8ba84dbc8"></a>

<details>
<summary><code>TensorCore.Regression.tf32_row_compatible</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/CanonicalFormats.lean#L62)

```lean
/-- The descriptor-to-profile theorem applied to the published TF32 row. -/
theorem tf32_row_compatible :
    tf32InvocationBits 4 (23 + 1) (some (-132)) tf32Row 0x3efe7b25 =
      (evalBlock (⟨tf32UnpackPairs tf32Row, 0x3efe7b25⟩ : BlockInput (tf19Fp32Profile 4 1 (some (-132))))).toOption.map
        (fun t => t.output.bits) :=
  tf32_invocation_bits 4 1 (some (-132)) tf32Row 0x3efe7b25 (by decide +kernel)
```

**Supporting proofs:** [TensorCore.tf32_invocation_bits](../../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OperandEncoding.Word](../../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.Regression.tf32Row](CanonicalFormats.md#decl-381e49e3be9c0a43), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.tf19Fp32Profile](../../TC/CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32InvocationBits](../../TC/CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32Padded](../../TC/CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register](../../Numerics/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32UnpackPairs](../../TC/CanonicalFormatDefs.md#decl-d49f9f58663603bc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
