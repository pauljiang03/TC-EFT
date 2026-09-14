# TensorCore.Core.Format

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ee0c12c617476387"></a>

<details>
<summary><code>TensorCore.SpecialEncoding</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L7)

```lean
inductive SpecialEncoding where
  | ieee
  /-- The top exponent is finite except for its all-one fraction, which is NaN. -/
  | finiteTopNaN
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.packedIEEE](Format.md#decl-1c87313094e2d4c0), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32Register](Format.md#decl-f0af86f5dcba47c8), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2)

</details>

</details>

<a id="decl-5fda6482ff1a70d2"></a>

<details>
<summary><code>TensorCore.ValueFormat</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L13)

```lean
structure ValueFormat where
  layout : Format
  special : SpecialEncoding := .ieee
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.SpecialEncoding](Format.md#decl-ee0c12c617476387)

<details>
<summary>Used by</summary>

[TensorCore.InvocationSpec.Valid](../TC/Invocation.md#decl-ba647c851a0365a5), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb), [TensorCore.PreparedInvocation.alignedBlock](../TC/Invocation.md#decl-f7d09369ac3f398e), [TensorCore.Regression.fused_requires_one_product](../TC/Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e), [TensorCore.ValueFormat.decode](Format.md#decl-6d84b56a4c29f326), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](../TC/Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.packedIEEE](Format.md#decl-1c87313094e2d4c0), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32Register](Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2)

</details>

</details>

<a id="decl-dfd30a62134c847e"></a>

<details>
<summary><code>TensorCore.ValueFormat.classifyNat</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L18)

```lean
def ValueFormat.classifyNat (f : ValueFormat) (n : ℕ) : Classification :=
  match f.special with
  | .ieee => TensorCore.classifyNat f.layout n
  | .finiteTopNaN =>
    let fraction := n % 2 ^ f.layout.fractionBits
    let exponent := n / 2 ^ f.layout.fractionBits % 2 ^ f.layout.exponentBits
    let negative := n / 2 ^ (f.layout.fractionBits + f.layout.exponentBits) != 0
    if exponent = 2 ^ f.layout.exponentBits - 1 then
      if fraction = 2 ^ f.layout.fractionBits - 1 then .nan
      else .normal ⟨if negative then -((2 ^ f.layout.fractionBits + fraction : ℕ) : ℤ)
        else ((2 ^ f.layout.fractionBits + fraction : ℕ) : ℤ),
        (exponent : ℤ) - f.layout.bias, f.layout.fractionBits⟩
    else TensorCore.classifyNat f.layout n
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.SpecialEncoding](Format.md#decl-ee0c12c617476387), [TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a)

<details>
<summary>Used by</summary>

[TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.ValueFormat.decode](Format.md#decl-6d84b56a4c29f326), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91), [TensorCore.padded_decode_requires_zero](Format.md#decl-8eec2d89dbf9d22f), [TensorCore.padded_decode_value](Format.md#decl-481771923e8baaab), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2)

</details>

</details>

<a id="decl-6d84b56a4c29f326"></a>

<details>
<summary><code>TensorCore.ValueFormat.decode</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L32)

```lean
def ValueFormat.decode (f : ValueFormat) (bits : BitVec f.layout.width) : Option Decoded :=
  (f.classifyNat bits.toNat).finite
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-372baaa74f9e3836"></a>

<details>
<summary><code>TensorCore.OperandEncoding</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L36)

```lean
/-- A value word with required zero low padding. Padding checks are not input rounding. -/
structure OperandEncoding where
  valueFormat : ValueFormat
  lowPadding : ℕ := 0
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2)

<details>
<summary>Used by</summary>

[TensorCore.InvocationSpec](../TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](../TC/Invocation.md#decl-ba647c851a0365a5), [TensorCore.OperandEncoding.Word](Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb), [TensorCore.PreparedInvocation.alignedBlock](../TC/Invocation.md#decl-f7d09369ac3f398e), [TensorCore.Regression.fused_requires_one_product](../TC/Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.alignedInvocation](../TC/Profiles.md#decl-08059dfea19f5f55), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](../TC/Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.operand_decode_bounded](FormatProperties.md#decl-af739da0b7be09a5), [TensorCore.packedIEEE](Format.md#decl-1c87313094e2d4c0), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91), [TensorCore.padded_decode_requires_zero](Format.md#decl-8eec2d89dbf9d22f), [TensorCore.padded_decode_value](Format.md#decl-481771923e8baaab), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32Register](Format.md#decl-f0af86f5dcba47c8), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-0e24771a882ef6eb"></a>

<details>
<summary><code>TensorCore.OperandEncoding.width</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L41)

```lean
@[implicit_reducible] def OperandEncoding.width (s : OperandEncoding) : ℕ :=
  s.valueFormat.layout.width + s.lowPadding
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2)

<details>
<summary>Used by</summary>

[TensorCore.InvocationInput](../TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.OperandEncoding.Word](Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.Regression.tf32Row](../TC/Regression/CanonicalFormats.md#decl-381e49e3be9c0a43), [TensorCore.Regression.tf32_unpadded_rejected](../TC/Regression/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.Regression.zero_product_canonical](../TC/Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.operand_decode_bounded](FormatProperties.md#decl-af739da0b7be09a5), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91), [TensorCore.padded_decode_requires_zero](Format.md#decl-8eec2d89dbf9d22f), [TensorCore.padded_decode_value](Format.md#decl-481771923e8baaab), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32Padded](../TC/CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register_decode](../TC/CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32Register_decode_unpadded](../TC/CanonicalFormats.md#decl-8289f6bd2846d909), [TensorCore.tf32Unpack](../TC/CanonicalFormatDefs.md#decl-aefd79d8faed1af7)

</details>

</details>

<a id="decl-3024ce1c6868fc17"></a>

<details>
<summary><code>TensorCore.OperandEncoding.Word</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L43)

```lean
abbrev OperandEncoding.Word (s : OperandEncoding) := BitVec s.width
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb)

<details>
<summary>Used by</summary>

[TensorCore.InvocationInput](../TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.PaperSpec.tf32_eq_paper](../TC/Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.Regression.fma64Bits](../TC/Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.tf32Row](../TC/Regression/CanonicalFormats.md#decl-381e49e3be9c0a43), [TensorCore.Regression.tf32_row_compatible](../TC/Regression/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../TC/Regression/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.Regression.zero_product_canonical](../TC/Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](../TC/Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.operand_decode_bounded](FormatProperties.md#decl-af739da0b7be09a5), [TensorCore.padded_decode_requires_zero](Format.md#decl-8eec2d89dbf9d22f), [TensorCore.padded_decode_value](Format.md#decl-481771923e8baaab), [TensorCore.prepareInvocation](../TC/Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32InvocationBits](../TC/CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32Padded](../TC/CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register_decode](../TC/CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32Register_decode_unpadded](../TC/CanonicalFormats.md#decl-8289f6bd2846d909), [TensorCore.tf32Unpack](../TC/CanonicalFormatDefs.md#decl-aefd79d8faed1af7), [TensorCore.tf32UnpackPairs](../TC/CanonicalFormatDefs.md#decl-d49f9f58663603bc), [TensorCore.tf32_input_bits](../TC/CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_mapM](../TC/CanonicalFormats.md#decl-7c0efbed6b476c43), [TensorCore.tf32_prepare](../TC/CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-54e57bd4e5755510"></a>

<details>
<summary><code>TensorCore.OperandEncoding.decode</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L45)

```lean
def OperandEncoding.decode (s : OperandEncoding) (bits : s.Word) : Option Decoded :=
  if bits.toNat % 2 ^ s.lowPadding != 0 then none
  else (s.valueFormat.classifyNat (bits.toNat / 2 ^ s.lowPadding)).finite
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e)

<details>
<summary>Used by</summary>

[TensorCore.operand_decode_bounded](FormatProperties.md#decl-af739da0b7be09a5), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91), [TensorCore.padded_decode_requires_zero](Format.md#decl-8eec2d89dbf9d22f), [TensorCore.padded_decode_value](Format.md#decl-481771923e8baaab), [TensorCore.prepareInvocation](../TC/Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32Register_decode](../TC/CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32Register_decode_unpadded](../TC/CanonicalFormats.md#decl-8289f6bd2846d909), [TensorCore.tf32_mapM](../TC/CanonicalFormats.md#decl-7c0efbed6b476c43), [TensorCore.tf32_prepare](../TC/CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-1c87313094e2d4c0"></a>

<details>
<summary><code>TensorCore.packedIEEE</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L49)

```lean
@[implicit_reducible] def packedIEEE (f : Format) : OperandEncoding := ⟨⟨f, .ieee⟩, 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.SpecialEncoding](Format.md#decl-ee0c12c617476387), [TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2)

<details>
<summary>Used by</summary>

[TensorCore.Profile.toInvocation](../TC/Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.a100BF16Invocation](../TC/Profiles.md#decl-5acb22a881be62d1), [TensorCore.a100F16Invocation](../TC/Profiles.md#decl-adb5005fe58bba84), [TensorCore.binary64Fma](../TC/Profiles.md#decl-8bfe46830da92086), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.hopperBF16Invocation](../TC/Profiles.md#decl-a5fe9df9d0e60b34), [TensorCore.hopperF16Invocation](../TC/Profiles.md#decl-483adc0a1491278e), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91)

</details>

</details>

<a id="decl-f0af86f5dcba47c8"></a>

<details>
<summary><code>TensorCore.tf32Register</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L51)

```lean
/-- TF32 values carried in FP32-sized words; the thirteen low bits must be zero. -/
def tf32Register : OperandEncoding := ⟨⟨tf19, .ieee⟩, 13⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.SpecialEncoding](Format.md#decl-ee0c12c617476387), [TensorCore.ValueFormat](Format.md#decl-5fda6482ff1a70d2), [TensorCore.tf19](Defs.md#decl-1b853137564a343d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.tf32_eq_paper](../TC/Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.Regression.tf32Row](../TC/Regression/CanonicalFormats.md#decl-381e49e3be9c0a43), [TensorCore.Regression.tf32_row_compatible](../TC/Regression/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../TC/Regression/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.a100TF32Invocation](../TC/Profiles.md#decl-2cd9d7c36ba4af85), [TensorCore.a100TF32_descriptor](../TC/CanonicalFormats.md#decl-f9243c07ef71dab9), [TensorCore.hopperTF32MmaInvocation](../TC/Profiles.md#decl-8f7f03eca7f57fa1), [TensorCore.hopperTF32Mma_descriptor](../TC/CanonicalFormats.md#decl-e22579ddcda1deb8), [TensorCore.hopperTF32WmmaInvocation](../TC/Profiles.md#decl-e17fb3f22506998e), [TensorCore.hopperTF32Wmma_descriptor](../TC/CanonicalFormats.md#decl-86a6a9842f6010da), [TensorCore.tf32Input](../TC/CanonicalFormatDefs.md#decl-b27c196f6f1485b1), [TensorCore.tf32InvocationBits](../TC/CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32Padded](../TC/CanonicalFormatDefs.md#decl-9dc548ec2c160c15), [TensorCore.tf32Register_decode](../TC/CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32Register_decode_unpadded](../TC/CanonicalFormats.md#decl-8289f6bd2846d909), [TensorCore.tf32Unpack](../TC/CanonicalFormatDefs.md#decl-aefd79d8faed1af7), [TensorCore.tf32UnpackPairs](../TC/CanonicalFormatDefs.md#decl-d49f9f58663603bc), [TensorCore.tf32_input_bits](../TC/CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_mapM](../TC/CanonicalFormats.md#decl-7c0efbed6b476c43), [TensorCore.tf32_prepare](../TC/CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-bf7a7c5a29f4ca91"></a>

<details>
<summary><code>TensorCore.packedIEEE_decode</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L53)

```lean
theorem packedIEEE_decode (f : Format) (bits : BitVec f.width) :
    (packedIEEE f).decode bits = (classify f bits).finite := by
  simp only [OperandEncoding.decode, packedIEEE, ValueFormat.classifyNat, classify,
    Nat.pow_zero, Nat.mod_one, Nat.div_one, bne_self_eq_false, Bool.false_eq_true,
    ↓reduceIte, OperandEncoding.width, Nat.add_zero]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a), [TensorCore.packedIEEE](Format.md#decl-1c87313094e2d4c0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8eec2d89dbf9d22f"></a>

<details>
<summary><code>TensorCore.padded_decode_requires_zero</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L59)

```lean
theorem padded_decode_requires_zero {s : OperandEncoding} {bits : s.Word} {d : Decoded}
    (h : s.decode bits = some d) : bits.toNat % 2 ^ s.lowPadding = 0 := by
  unfold OperandEncoding.decode at h
  split at h <;> simp_all
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-481771923e8baaab"></a>

<details>
<summary><code>TensorCore.padded_decode_value</code></summary>

[Lean source](../../../TensorCore/Core/Format.lean#L64)

```lean
theorem padded_decode_value {s : OperandEncoding} {bits : s.Word} {d : Decoded}
    (h : s.decode bits = some d) :
    (s.valueFormat.classifyNat (bits.toNat / 2 ^ s.lowPadding)).finite = some d := by
  unfold OperandEncoding.decode at h
  split at h <;> simp_all
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.OperandEncoding](Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](Format.md#decl-0e24771a882ef6eb), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.operand_decode_bounded](FormatProperties.md#decl-af739da0b7be09a5)

</details>

</details>
