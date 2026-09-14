# TensorCore.TC.Invocation

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-465383d437a4df50"></a>

<details>
<summary><code>TensorCore.CPlacement</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L8)

```lean
inductive CPlacement where
  | inGroup
  /-- Convert the product accumulator through these stages, then add c exactly. -/
  | afterProducts (stages : List ConversionStage)
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1)

<details>
<summary>Used by</summary>

[TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.Regression.fused_requires_one_product](Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-e676df9d836e3187"></a>

<details>
<summary><code>TensorCore.AccumulationKind</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L14)

```lean
inductive AccumulationKind where
  | aligned (fraction : ℕ) (floor : Option ℤ) (cPlacement : CPlacement)
  /-- An exact single-product FMA, with no lossy alignment stage. -/
  | fused
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50)

<details>
<summary>Used by</summary>

[TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.Regression.fused_requires_one_product](Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-686e1fb8fa675688"></a>

<details>
<summary><code>TensorCore.InvocationSpec</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L20)

```lean
structure InvocationSpec where
  input : OperandEncoding
  cFormat : Format
  products : ℕ
  accumulation : AccumulationKind
  intermediate : List ConversionStage := []
  output : ConversionStage
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836)

<details>
<summary>Used by</summary>

[TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.InvocationTrace.residual](Invocation.md#decl-c97ce73fb104bc58), [TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.PreparedInvocation.exactProducts](Invocation.md#decl-f08483de5406c0c5), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.Regression.a100_bf16_published_row](Regression/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.fma64Bits](Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.fused_requires_one_product](Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.Regression.h100_bf16_published_row](Regression/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.a100BF16Invocation](Profiles.md#decl-5acb22a881be62d1), [TensorCore.a100BF16_descriptor](CanonicalFormats.md#decl-73423114ec6e4035), [TensorCore.a100F16Invocation](Profiles.md#decl-adb5005fe58bba84), [TensorCore.a100TF32Invocation](Profiles.md#decl-2cd9d7c36ba4af85), [TensorCore.a100TF32_descriptor](CanonicalFormats.md#decl-f9243c07ef71dab9), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.alignedInvocation](Profiles.md#decl-08059dfea19f5f55), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.binary64Fma](Profiles.md#decl-8bfe46830da92086), [TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](Conversion.md#decl-73cb656a116a886e), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.fp16Fp32Invocation](CanonicalDefs.md#decl-9e7567381e18f7e6), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.hopperBF16Invocation](Profiles.md#decl-a5fe9df9d0e60b34), [TensorCore.hopperBF16_descriptor](CanonicalFormats.md#decl-3b357b72598d1090), [TensorCore.hopperF16Invocation](Profiles.md#decl-483adc0a1491278e), [TensorCore.hopperTF32MmaInvocation](Profiles.md#decl-8f7f03eca7f57fa1), [TensorCore.hopperTF32Mma_descriptor](CanonicalFormats.md#decl-e22579ddcda1deb8), [TensorCore.hopperTF32WmmaInvocation](Profiles.md#decl-e17fb3f22506998e), [TensorCore.hopperTF32Wmma_descriptor](CanonicalFormats.md#decl-86a6a9842f6010da), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100Invocation](Invocation.md#decl-7a65a9f94124dc03), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>

<a id="decl-e34cdc92870df2ae"></a>

<details>
<summary><code>TensorCore.stagesValid</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L29)

```lean
def stagesValid (ss : List ConversionStage) : Bool := ss.all fun s => decide s.format.WellFormed
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6)

<details>
<summary>Used by</summary>

[TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.Regression.fused_requires_one_product](Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-ba647c851a0365a5"></a>

<details>
<summary><code>TensorCore.InvocationSpec.Valid</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L31)

```lean
def InvocationSpec.Valid (p : InvocationSpec) : Prop :=
  p.input.valueFormat.layout.WellFormed ∧ p.cFormat.WellFormed ∧
  stagesValid p.intermediate = true ∧ p.output.format.WellFormed ∧
  match p.accumulation with
  | .fused => p.products = 1
  | .aligned _ _ .inGroup => True
  | .aligned _ _ (.afterProducts ss) => stagesValid ss = true
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fused_requires_one_product](Regression/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-6320316242fc8f99"></a>

<details>
<summary><code>TensorCore.InvocationInput</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L45)

```lean
structure InvocationInput (p : InvocationSpec) where
  products : List (p.input.Word × p.input.Word)
  c : BitVec p.cFormat.width
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](../Core/Format.md#decl-0e24771a882ef6eb)

<details>
<summary>Used by</summary>

[TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.Regression.a100_bf16_published_row](Regression/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.fma64Bits](Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.h100_bf16_published_row](Regression/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](Conversion.md#decl-73cb656a116a886e), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32Input](CanonicalFormatDefs.md#decl-b27c196f6f1485b1), [TensorCore.tf32InvocationBits](CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-f9bfc73e05dc3dce"></a>

<details>
<summary><code>TensorCore.PreparedInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L50)

```lean
structure PreparedInvocation (p : InvocationSpec) where
  products : List (Decoded × Decoded)
  c : Decoded
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688)

<details>
<summary>Used by</summary>

[TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.PreparedInvocation.exactProducts](Invocation.md#decl-f08483de5406c0c5), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-4c327b22c0823d02"></a>

<details>
<summary><code>TensorCore.prepareInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L55)

```lean
def prepareInvocation {p : InvocationSpec} (x : InvocationInput p) : Option (PreparedInvocation p) := do
  let c ← (classify p.cFormat x.c).finite
  let ps ← x.products.mapM fun (a, b) => do return (← p.input.decode a, ← p.input.decode b)
  return ⟨ps, c⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac)

</details>

</details>

<a id="decl-f08483de5406c0c5"></a>

<details>
<summary><code>TensorCore.PreparedInvocation.exactProducts</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L60)

```lean
def PreparedInvocation.exactProducts {p : InvocationSpec} (b : PreparedInvocation p) : ℚ :=
  sumQ (b.products.map fun (a, b) => a.value * b.value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502)

</details>

</details>

<a id="decl-d708da3010825603"></a>

<details>
<summary><code>TensorCore.PreparedInvocation.exactDot</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L63)

```lean
def PreparedInvocation.exactDot {p : InvocationSpec} (b : PreparedInvocation p) : ℚ :=
  b.c.value + b.exactProducts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.exactProducts](Invocation.md#decl-f08483de5406c0c5)

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.invocationIdeal](Invocation.md#decl-ce5a842b255050cf)

</details>

</details>

<a id="decl-ce5a842b255050cf"></a>

<details>
<summary><code>TensorCore.invocationIdeal</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L67)

```lean
/-- Original-bit ideal. It uses decoding and rational multiplication only. -/
def invocationIdeal {p : InvocationSpec} (x : InvocationInput p) : Option ℚ :=
  (prepareInvocation x).map PreparedInvocation.exactDot
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02)

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9)

</details>

</details>

<a id="decl-f7d09369ac3f398e"></a>

<details>
<summary><code>TensorCore.PreparedInvocation.alignedBlock</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L72)

```lean
/-- Reuse the proved raw-product/grid primitive. Late-c uses an exact zero sentinel;
it neither selects eta nor changes the sum. This does not decode through the old profile. -/
def PreparedInvocation.alignedBlock {p : InvocationSpec} (b : PreparedInvocation p)
    (F : ℕ) (floor : Option ℤ) (includeC : Bool) : PreparedBlock :=
  ⟨⟨p.input.valueFormat.layout, p.products, F, floor⟩, b.products,
    if includeC then b.c else ⟨0, 0, 0⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2)

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-a84c087ad8e27576"></a>

<details>
<summary><code>TensorCore.LocalAccumulation</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L77)

```lean
structure LocalAccumulation where
  value : ℚ
  alignmentLoss : ℚ
  conversions : List ConversionEvent
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c)

<details>
<summary>Used by</summary>

[TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation.loss](Invocation.md#decl-68d84640e3352f8b), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-68d84640e3352f8b"></a>

<details>
<summary><code>TensorCore.LocalAccumulation.loss</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L83)

```lean
def LocalAccumulation.loss (r : LocalAccumulation) : ℚ :=
  r.alignmentLoss + sumQ (r.conversions.map ConversionEvent.loss)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](../Core/Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.InvocationTrace.residual](Invocation.md#decl-c97ce73fb104bc58), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9)

</details>

</details>

<a id="decl-7e7acb74ce8e2620"></a>

<details>
<summary><code>TensorCore.accumulateInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L86)

```lean
def accumulateInvocation {p : InvocationSpec} (b : PreparedInvocation p) : Option LocalAccumulation :=
  match p.accumulation with
  | .fused => some ⟨b.exactDot, 0, []⟩
  | .aligned F floor cp =>
    match cp with
    | .inGroup =>
      let a := b.alignedBlock F floor true
      some ⟨a.accumulator, sumQ a.alignmentResiduals, []⟩
    | .afterProducts stages => do
      let a := b.alignedBlock F floor false
      let r ← runConversions stages a.accumulator
      return ⟨r.value + b.c.value, sumQ a.alignmentResiduals, r.events⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionEvent](../Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.PreparedInvocation.exactDot](Invocation.md#decl-d708da3010825603), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5)

</details>

</details>

<a id="decl-b63a56d7a7c92388"></a>

<details>
<summary><code>TensorCore.InvocationTrace</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L99)

```lean
structure InvocationTrace (p : InvocationSpec) where
  prepared : PreparedInvocation p
  accumulation : LocalAccumulation
  intermediate : ConversionRun
  output : FiniteBinary p.output.format
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce)

<details>
<summary>Used by</summary>

[TensorCore.InvocationTrace.residual](Invocation.md#decl-c97ce73fb104bc58), [TensorCore.Regression.fma64Bits](Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](Conversion.md#decl-73cb656a116a886e), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-c97ce73fb104bc58"></a>

<details>
<summary><code>TensorCore.InvocationTrace.residual</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L106)

```lean
def InvocationTrace.residual {p : InvocationSpec} (t : InvocationTrace p) : ℚ :=
  t.accumulation.loss + t.intermediate.loss + (t.intermediate.value - t.output.value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionRun.loss](../Core/Conversion.md#decl-29f602efd8dc0504), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation.loss](Invocation.md#decl-68d84640e3352f8b)

<details>
<summary>Used by</summary>

[TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9)

</details>

</details>

<a id="decl-4afa1dfc6f87e57d"></a>

<details>
<summary><code>TensorCore.InvocationError</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L109)

```lean
inductive InvocationError where
  | invalidSpec
  | wrongProductCount
  | nonfiniteOrInvalidEncoding
  | localConversionFailed
  | intermediateConversionFailed
  | outputConversionFailed
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.fma64Bits](Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](Conversion.md#decl-73cb656a116a886e), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-0d3709c08efd2102"></a>

<details>
<summary><code>TensorCore.evalInvocationPrepared</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L118)

```lean
def evalInvocationPrepared {p : InvocationSpec} (b : PreparedInvocation p) :
    Except InvocationError (InvocationTrace p) :=
  match accumulateInvocation b with
  | none => .error .localConversionFailed
  | some a => match runConversions p.intermediate a.value with
    | none => .error .intermediateConversionFailed
    | some r => match p.output.convert r.value with
      | none => .error .outputConversionFailed
      | some d => .ok ⟨b, a, r, d⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionRun](../Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](Invocation.md#decl-a84c087ad8e27576), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.runConversions](../Core/Conversion.md#decl-3bc91db620898ff3)

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared_spec](InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-d69509a8df45ebe4"></a>

<details>
<summary><code>TensorCore.evalInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L128)

```lean
def evalInvocation {p : InvocationSpec} (x : InvocationInput p) :
    Except InvocationError (InvocationTrace p) :=
  if ¬ p.Valid then .error .invalidSpec
  else if x.products.length != p.products then .error .wrongProductCount
  else match prepareInvocation x with
    | none => .error .nonfiniteOrInvalidEncoding
    | some b => evalInvocationPrepared b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.OperandEncoding](../Core/Format.md#decl-372baaa74f9e3836), [TensorCore.OperandEncoding.Word](../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.PreparedInvocation](Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.ValueFormat](../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.evalInvocationPrepared](Invocation.md#decl-0d3709c08efd2102), [TensorCore.prepareInvocation](Invocation.md#decl-4c327b22c0823d02), [TensorCore.stagesValid](Invocation.md#decl-e34cdc92870df2ae)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fma64Bits](Regression/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.binary64Fma_correct](FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](Conversion.md#decl-73cb656a116a886e), [TensorCore.evalInvocation_output](InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.invocationBits](Invocation.md#decl-c68ad16b896f3817), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-b30efe02b0f3acb9"></a>

<details>
<summary><code>TensorCore.Profile.toInvocation</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L137)

```lean
/-- The old family embedded without changing its numerical policy. -/
@[implicit_reducible] def Profile.toInvocation (p : Profile) (F : ℕ) : InvocationSpec :=
  ⟨packedIEEE p.input, fp32, p.products, .aligned F p.alignFloor .inGroup,
    [], ⟨fp32, .towardZero⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.AccumulationKind](Invocation.md#decl-e676df9d836e3187), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CPlacement](Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.packedIEEE](../Core/Format.md#decl-1c87313094e2d4c0)

<details>
<summary>Used by</summary>

[TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.a100BF16_descriptor](CanonicalFormats.md#decl-73423114ec6e4035), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.fp16Fp32Invocation](CanonicalDefs.md#decl-9e7567381e18f7e6), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.hopperBF16_descriptor](CanonicalFormats.md#decl-3b357b72598d1090), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.v100Invocation](Invocation.md#decl-7a65a9f94124dc03), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>

<a id="decl-7a65a9f94124dc03"></a>

<details>
<summary><code>TensorCore.v100Invocation</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L141)

```lean
def v100Invocation : InvocationSpec := v100F16F32.toInvocation 23
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.v100F16F32](Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fused_requires_one_product](Regression/PublicDomains.md#decl-b03cee6d1c37cccb)

</details>

</details>

<a id="decl-c68ad16b896f3817"></a>

<details>
<summary><code>TensorCore.invocationBits</code></summary>

[Lean source](../../../TensorCore/TC/Invocation.lean#L144)

```lean
/-- Numerical observation includes rejection as `none`; error constructors are API-specific. -/
def invocationBits {p : InvocationSpec} (x : InvocationInput p) : Option (BitVec p.output.format.width) :=
  (evalInvocation x).toOption.map fun t => t.output.bits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](Invocation.md#decl-b63a56d7a7c92388), [TensorCore.evalInvocation](Invocation.md#decl-d69509a8df45ebe4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.Regression.a100_bf16_published_row](Regression/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.h100_bf16_published_row](Regression/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.tf32InvocationBits](CanonicalFormats.md#decl-959c4b9a405d61ab), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>
