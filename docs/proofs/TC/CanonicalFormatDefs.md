# TensorCore.TC.CanonicalFormatDefs

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-cca6376296353039"></a>

<details>
<summary><code>TensorCore.bf16Fp32Profile</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L11)

```lean
/-- BF16 products, FP32 c and output, `F = 23 + extraBits`. -/
@[implicit_reducible] def bf16Fp32Profile (K extraBits : ℕ) (floor : Option ℤ := none) :
    Profile := ⟨bf16, K, 23 + extraBits, floor⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.bf16](../Numerics/Defs.md#decl-10da45ae98cf5fcc)

<details>
<summary>Used by</summary>

[TensorCore.a100BF16F32](CanonicalFormatDefs.md#decl-93f6070f8a03aaee), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.hopperBF16F32](CanonicalFormatDefs.md#decl-c021958593ae7dc6)

</details>

</details>

<a id="decl-1c2bbf7dc7ddd176"></a>

<details>
<summary><code>TensorCore.tf19Fp32Profile</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L15)

```lean
/-- TF32 values in the packed 19-bit `tf19` layout, FP32 c and output. -/
@[implicit_reducible] def tf19Fp32Profile (K extraBits : ℕ) (floor : Option ℤ := none) :
    Profile := ⟨tf19, K, 23 + extraBits, floor⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.tf19](../Numerics/Defs.md#decl-1b853137564a343d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.a100TF32F32](CanonicalFormatDefs.md#decl-d2e41a9c0176d61b), [TensorCore.hopperTF32MmaF32](CanonicalFormatDefs.md#decl-bda067835b02f97d), [TensorCore.hopperTF32WmmaF32](CanonicalFormatDefs.md#decl-a012d676a51f02f1), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.tf32Input](CanonicalFormatDefs.md#decl-b27c196f6f1485b1), [TensorCore.tf32Register_decode](CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_mapM](CanonicalFormats.md#decl-7c0efbed6b476c43), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-93f6070f8a03aaee"></a>

<details>
<summary><code>TensorCore.a100BF16F32</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L18)

```lean
@[implicit_reducible] def a100BF16F32 : Profile := bf16Fp32Profile 8 1 (some (-132))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.bf16Fp32Profile](CanonicalFormatDefs.md#decl-cca6376296353039)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.profile](../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.Controls.ampereFloorInput](../Tests/Specification/NegativeControls.md#decl-a20e96d306f650cf), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.a100BF16_descriptor](CanonicalFormats.md#decl-73423114ec6e4035)

</details>

</details>

<a id="decl-c021958593ae7dc6"></a>

<details>
<summary><code>TensorCore.hopperBF16F32</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L19)

```lean
@[implicit_reducible] def hopperBF16F32 : Profile := bf16Fp32Profile 16 2 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.bf16Fp32Profile](CanonicalFormatDefs.md#decl-cca6376296353039)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.profile](../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.Controls.hopperFloorInput](../Tests/Specification/NegativeControls.md#decl-686fb49328f7f769), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.hopperBF16_descriptor](CanonicalFormats.md#decl-3b357b72598d1090)

</details>

</details>

<a id="decl-d2e41a9c0176d61b"></a>

<details>
<summary><code>TensorCore.a100TF32F32</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L20)

```lean
@[implicit_reducible] def a100TF32F32 : Profile := tf19Fp32Profile 4 1 (some (-132))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.profile](../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4)

</details>

</details>

<a id="decl-a012d676a51f02f1"></a>

<details>
<summary><code>TensorCore.hopperTF32WmmaF32</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L21)

```lean
@[implicit_reducible] def hopperTF32WmmaF32 : Profile := tf19Fp32Profile 4 2 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.profile](../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b)

</details>

</details>

<a id="decl-bda067835b02f97d"></a>

<details>
<summary><code>TensorCore.hopperTF32MmaF32</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L22)

```lean
@[implicit_reducible] def hopperTF32MmaF32 : Profile := tf19Fp32Profile 8 2 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.profile](../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31)

</details>

</details>

<a id="decl-9dc548ec2c160c15"></a>

<details>
<summary><code>TensorCore.tf32Padded</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L25)

```lean
/-- The thirteen low bits of a TF32 register word must be zero. -/
def tf32Padded (w : tf32Register.Word) : Bool := w.toNat % 2 ^ 13 == 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](../Numerics/Format.md#decl-0e24771a882ef6eb), [TensorCore.tf32Register](../Numerics/Format.md#decl-f0af86f5dcba47c8)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.tf32Register_decode](CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32Register_decode_unpadded](CanonicalFormats.md#decl-8289f6bd2846d909), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_mapM](CanonicalFormats.md#decl-7c0efbed6b476c43), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-aefd79d8faed1af7"></a>

<details>
<summary><code>TensorCore.tf32Unpack</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L28)

```lean
/-- The 19 value bits of a TF32 register word. -/
def tf32Unpack (w : tf32Register.Word) : BitVec 19 := BitVec.ofNat 19 (w.toNat / 2 ^ 13)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](../Numerics/Format.md#decl-0e24771a882ef6eb), [TensorCore.tf32Register](../Numerics/Format.md#decl-f0af86f5dcba47c8)

<details>
<summary>Used by</summary>

[TensorCore.tf32Register_decode](CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32UnpackPairs](CanonicalFormatDefs.md#decl-d49f9f58663603bc), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_mapM](CanonicalFormats.md#decl-7c0efbed6b476c43)

</details>

</details>

<a id="decl-d49f9f58663603bc"></a>

<details>
<summary><code>TensorCore.tf32UnpackPairs</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L30)

```lean
def tf32UnpackPairs (ps : List (tf32Register.Word × tf32Register.Word)) :
    List (BitVec 19 × BitVec 19) :=
  ps.map fun (a, b) => (tf32Unpack a, tf32Unpack b)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.OperandEncoding.Word](../Numerics/Format.md#decl-3024ce1c6868fc17), [TensorCore.tf32Register](../Numerics/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32Unpack](CanonicalFormatDefs.md#decl-aefd79d8faed1af7)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.tf32Input](CanonicalFormatDefs.md#decl-b27c196f6f1485b1), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_mapM](CanonicalFormats.md#decl-7c0efbed6b476c43), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-b27c196f6f1485b1"></a>

<details>
<summary><code>TensorCore.tf32Input</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalFormatDefs.lean#L35)

```lean
/-- The register-word input of a TF32 descriptor as a value-word input of the profile. -/
def tf32Input {K F : ℕ} {floor : Option ℤ}
    (x : InvocationInput (alignedInvocation tf32Register K F floor)) (extra : ℕ) :
    BlockInput (tf19Fp32Profile K extra floor) :=
  ⟨tf32UnpackPairs x.products, x.c⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.tf19Fp32Profile](CanonicalFormatDefs.md#decl-1c2bbf7dc7ddd176), [TensorCore.tf32Register](../Numerics/Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32UnpackPairs](CanonicalFormatDefs.md#decl-d49f9f58663603bc)

<details>
<summary>Used by</summary>

[TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159)

</details>

</details>
