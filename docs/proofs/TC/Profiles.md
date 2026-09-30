# TensorCore.TC.Profiles

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-08059dfea19f5f55"></a>

<details>
<summary><code>TensorCore.alignedInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L9)

```lean
/-- Source-backed FP32-output families. These describe one arithmetic group;
profile names do not assert instruction mapping or independent device conformance. -/
@[implicit_reducible] def alignedInvocation (input : OperandEncoding) (K F : ℕ) (floor : Option ℤ) : InvocationSpec :=
  ⟨input, fp32, K, .aligned F floor .inGroup, [], ⟨fp32, .towardZero⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.OperandEncoding](../Numerics/Format.md#decl-372baaa74f9e3836), [TensorCore.fp32](../Numerics/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.a100BF16Invocation](Profiles.md#decl-5acb22a881be62d1), [TensorCore.a100F16Invocation](Profiles.md#decl-adb5005fe58bba84), [TensorCore.a100TF32Invocation](Profiles.md#decl-2cd9d7c36ba4af85), [TensorCore.a100TF32_descriptor](CanonicalFormats.md#decl-f9243c07ef71dab9), [TensorCore.hopperBF16Invocation](Profiles.md#decl-a5fe9df9d0e60b34), [TensorCore.hopperF16Invocation](Profiles.md#decl-483adc0a1491278e), [TensorCore.hopperTF32MmaInvocation](Profiles.md#decl-8f7f03eca7f57fa1), [TensorCore.hopperTF32Mma_descriptor](CanonicalFormats.md#decl-e22579ddcda1deb8), [TensorCore.hopperTF32WmmaInvocation](Profiles.md#decl-e17fb3f22506998e), [TensorCore.hopperTF32Wmma_descriptor](CanonicalFormats.md#decl-86a6a9842f6010da), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.tf32Input](CanonicalFormatDefs.md#decl-b27c196f6f1485b1), [TensorCore.tf32InvocationBits](CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-adb5005fe58bba84"></a>

<details>
<summary><code>TensorCore.a100F16Invocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L12)

```lean
def a100F16Invocation : InvocationSpec := alignedInvocation (packedIEEE fp16) 8 24 (some (-132))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.fp16](../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.packedIEEE](../Numerics/Format.md#decl-1c87313094e2d4c0)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5acb22a881be62d1"></a>

<details>
<summary><code>TensorCore.a100BF16Invocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L13)

```lean
def a100BF16Invocation : InvocationSpec := alignedInvocation (packedIEEE bf16) 8 24 (some (-132))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.bf16](../Numerics/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.packedIEEE](../Numerics/Format.md#decl-1c87313094e2d4c0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.a100BF16_descriptor](CanonicalFormats.md#decl-73423114ec6e4035)

</details>

</details>

<a id="decl-2cd9d7c36ba4af85"></a>

<details>
<summary><code>TensorCore.a100TF32Invocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L14)

```lean
def a100TF32Invocation : InvocationSpec := alignedInvocation tf32Register 4 24 (some (-132))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.tf32Register](../Numerics/Format.md#decl-f0af86f5dcba47c8)

<details>
<summary>Used by</summary>

[TensorCore.a100TF32_descriptor](CanonicalFormats.md#decl-f9243c07ef71dab9)

</details>

</details>

<a id="decl-483adc0a1491278e"></a>

<details>
<summary><code>TensorCore.hopperF16Invocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L15)

```lean
def hopperF16Invocation : InvocationSpec := alignedInvocation (packedIEEE fp16) 16 25 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.fp16](../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.packedIEEE](../Numerics/Format.md#decl-1c87313094e2d4c0)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a5fe9df9d0e60b34"></a>

<details>
<summary><code>TensorCore.hopperBF16Invocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L16)

```lean
def hopperBF16Invocation : InvocationSpec := alignedInvocation (packedIEEE bf16) 16 25 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.bf16](../Numerics/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.packedIEEE](../Numerics/Format.md#decl-1c87313094e2d4c0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.hopperBF16_descriptor](CanonicalFormats.md#decl-3b357b72598d1090)

</details>

</details>

<a id="decl-8f7f03eca7f57fa1"></a>

<details>
<summary><code>TensorCore.hopperTF32MmaInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L17)

```lean
def hopperTF32MmaInvocation : InvocationSpec := alignedInvocation tf32Register 8 25 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.tf32Register](../Numerics/Format.md#decl-f0af86f5dcba47c8)

<details>
<summary>Used by</summary>

[TensorCore.hopperTF32Mma_descriptor](CanonicalFormats.md#decl-e22579ddcda1deb8)

</details>

</details>

<a id="decl-e17fb3f22506998e"></a>

<details>
<summary><code>TensorCore.hopperTF32WmmaInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L18)

```lean
def hopperTF32WmmaInvocation : InvocationSpec := alignedInvocation tf32Register 4 25 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.tf32Register](../Numerics/Format.md#decl-f0af86f5dcba47c8)

<details>
<summary>Used by</summary>

[TensorCore.hopperTF32Wmma_descriptor](CanonicalFormats.md#decl-86a6a9842f6010da)

</details>

</details>

<a id="decl-8bfe46830da92086"></a>

<details>
<summary><code>TensorCore.binary64Fma</code></summary>

[Lean source](../../../TensorCore/TC/Profiles.lean#L21)

```lean
/-- Finite-domain binary64 fused arithmetic, with an explicit rounding direction. -/
def binary64Fma (mode : BinaryRoundingMode) : InvocationSpec :=
  ⟨packedIEEE fp64, fp64, 1, .fused, [], ⟨fp64, mode⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Numerics/Conversion.md#decl-19660b95e076faa1), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.fp64](../Numerics/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.packedIEEE](../Numerics/Format.md#decl-1c87313094e2d4c0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fma64Bits](../Tests/TC/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](Conversion.md#decl-73cb656a116a886e)

</details>

</details>
