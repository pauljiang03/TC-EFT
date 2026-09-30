# TensorCore.Numerics.Conversion

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-819c01227290b53b"></a>

<details>
<summary><code>TensorCore.FiniteBinary</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L7)

```lean
structure FiniteBinary (f : Format) where
  bits : BitVec f.width
  decoded : Decoded
  valid : (classify f bits).finite = some decoded
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32), [TensorCore.InvocationTrace](../TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.Regression.fma64Bits](../Tests/TC/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.zero_product_canonical](../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.finiteBinary_none](Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](Conversion.md#decl-66e4132ec74cac83), [TensorCore.invocationBits](../TC/Invocation.md#decl-c68ad16b896f3817), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-91103d704c4a7c32"></a>

<details>
<summary><code>TensorCore.FiniteBinary.value</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L13)

```lean
def FiniteBinary.value {f : Format} (d : FiniteBinary f) : ℚ := d.decoded.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-4947fce7ecea0c20"></a>

<details>
<summary><code>TensorCore.finiteBinary</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L15)

```lean
def finiteBinary (f : Format) (bits : BitVec f.width) : Option (FiniteBinary f) :=
  match h : (classify f bits).finite with
  | none => none
  | some d => some ⟨bits, d, h⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.finiteBinary_none](Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](Conversion.md#decl-66e4132ec74cac83), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-ec8059a2865c017f"></a>

<details>
<summary><code>TensorCore.finiteBinary_none</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L20)

```lean
theorem finiteBinary_none {f : Format} {bits : BitVec f.width}
    (hd : (classify f bits).finite = none) : finiteBinary f bits = none := by
  unfold finiteBinary
  split
  · rfl
  · rename_i d h
    rw [hd] at h
    contradiction
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-66e4132ec74cac83"></a>

<details>
<summary><code>TensorCore.finiteBinary_some</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L29)

```lean
theorem finiteBinary_some {f : Format} {bits : BitVec f.width} {d : Decoded}
    (hd : (classify f bits).finite = some d) : finiteBinary f bits = some ⟨bits, d, hd⟩ := by
  unfold finiteBinary
  split
  · rename_i h
    rw [hd] at h
    contradiction
  · rename_i d' h
    rw [hd] at h
    cases Option.some.inj h
    rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-19660b95e076faa1"></a>

<details>
<summary><code>TensorCore.ConversionStage</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L41)

```lean
structure ConversionStage where
  format : Format
  mode : BinaryRoundingMode
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.CPlacement](../TC/Invocation.md#decl-465383d437a4df50), [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.InvocationSpec](../TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationSpec.Valid](../TC/Invocation.md#decl-ba647c851a0365a5), [TensorCore.InvocationTrace](../TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.PaperSpec.invocation_eq_paper](../TC/Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.Profile.toInvocation](../TC/Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.fma64Bits](../Tests/TC/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.fused_requires_one_product](../Tests/TC/PublicDomains.md#decl-b03cee6d1c37cccb), [TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.zero_product_canonical](../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.alignedInvocation](../TC/Profiles.md#decl-08059dfea19f5f55), [TensorCore.bf16Fp32_invocation_compatible](../TC/CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.binary64Fma](../TC/Profiles.md#decl-8bfe46830da92086), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation](../TC/Invocation.md#decl-d69509a8df45ebe4), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.fp16Fp32_invocation_compatible](../TC/Canonical.md#decl-77d448deb0e063d7), [TensorCore.invocationBits](../TC/Invocation.md#decl-c68ad16b896f3817), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.stagesValid](../TC/Invocation.md#decl-e34cdc92870df2ae), [TensorCore.tf32_input_bits](../TC/CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100_invocation_bits](../TC/Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>

<a id="decl-5e2170b37d7e10f7"></a>

<details>
<summary><code>TensorCore.ConversionStage.convert</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L46)

```lean
def ConversionStage.convert (s : ConversionStage) (x : ℚ) : Option (FiniteBinary s.format) := do
  finiteBinary s.format (← roundBinary s.format s.mode x)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

<details>
<summary>Used by</summary>

[TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-4715b3224a6fd37c"></a>

<details>
<summary><code>TensorCore.ConversionEvent</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L49)

```lean
structure ConversionEvent where
  stage : ConversionStage
  input : ℚ
  output : FiniteBinary stage.format
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b)

<details>
<summary>Used by</summary>

[TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.LocalAccumulation](../TC/Invocation.md#decl-a84c087ad8e27576), [TensorCore.LocalAccumulation.loss](../TC/Invocation.md#decl-68d84640e3352f8b), [TensorCore.Regression.zero_product_canonical](../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-60b5dc28ff8bfb5b"></a>

<details>
<summary><code>TensorCore.ConversionEvent.loss</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L55)

```lean
def ConversionEvent.loss (e : ConversionEvent) : ℚ := e.input - e.output.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32)

<details>
<summary>Used by</summary>

[TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.LocalAccumulation.loss](../TC/Invocation.md#decl-68d84640e3352f8b), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-ed5a81cbcde403d2"></a>

<details>
<summary><code>TensorCore.ConversionRun</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L57)

```lean
structure ConversionRun where
  events : List ConversionEvent
  value : ℚ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c)

<details>
<summary>Used by</summary>

[TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.InvocationTrace](../TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.Regression.zero_product_canonical](../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-29f602efd8dc0504"></a>

<details>
<summary><code>TensorCore.ConversionRun.loss</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L62)

```lean
def ConversionRun.loss (r : ConversionRun) : ℚ := sumQ (r.events.map ConversionEvent.loss)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.InvocationTrace.residual](../TC/Invocation.md#decl-c97ce73fb104bc58), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-3bc91db620898ff3"></a>

<details>
<summary><code>TensorCore.runConversions</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L65)

```lean
/-- Each following conversion receives the decoded encoding of its predecessor. -/
def runConversions : List ConversionStage → ℚ → Option ConversionRun
  | [], x => some ⟨[], x⟩
  | s :: ss, x => do
    let d ← s.convert x
    let rest ← runConversions ss d.value
    return ⟨⟨s, x, d⟩ :: rest.events, rest.value⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32)

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.binary64Fma_exact_input](../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.evalInvocationPrepared](../TC/Invocation.md#decl-0d3709c08efd2102), [TensorCore.evalInvocationPrepared_spec](../TC/InvocationProperties.md#decl-d12d00baae1cb453), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalInvocation_output_nearestEven](../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9), [TensorCore.evalInvocation_spec](../TC/InvocationProperties.md#decl-cf70673e8284a3b5), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.runConversions_events](Conversion.md#decl-ee15bd4271d1b71d), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc)

</details>

</details>

<a id="decl-3479ab5362b59148"></a>

<details>
<summary><code>TensorCore.conversionStage_output</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L72)

```lean
theorem conversionStage_output {s : ConversionStage} {x : ℚ} {d : FiniteBinary s.format}
    (h : s.convert x = some d) : roundBinary s.format s.mode x = some d.bits := by
  unfold ConversionStage.convert at h
  cases hr : roundBinary s.format s.mode x with
  | none => simp [hr] at h
  | some bits =>
    simp [hr] at h
    unfold finiteBinary at h
    split at h
    · simp at h
    · simp only [Option.some.injEq] at h
      subst d
      rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d)

</details>

</details>

<a id="decl-9878d77fe9422846"></a>

<details>
<summary><code>TensorCore.conversionStage_range</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L86)

```lean
theorem conversionStage_range {s : ConversionStage} {x : ℚ} {d : FiniteBinary s.format}
    (h : s.convert x = some d) : s.format.WellFormed ∧ absQ x ≤ s.format.maxFinite :=
  roundBinary_range (conversionStage_output h)
```

**Supporting proofs:** [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.roundBinary_range](Binary/RoundOp.md#decl-0877ce0e6eb40a61)

**Definitions and types:** [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.Format.WellFormed](Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d)

</details>

</details>

<a id="decl-9a595a0bbdd2a7fc"></a>

<details>
<summary><code>TensorCore.runConversions_recovery</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L91)

```lean
/-- Executed sequences telescope across actual encodings, with every loss retained. -/
theorem runConversions_recovery (ss : List ConversionStage) (x : ℚ) (r : ConversionRun)
    (h : runConversions ss x = some r) : x = r.value + r.loss := by
  induction ss generalizing x r with
  | nil =>
    simp [runConversions] at h
    subst r
    simp [ConversionRun.loss, sumQ]
    grind
  | cons s ss ih =>
    cases hd : s.convert x with
    | none => simp [runConversions, hd] at h
    | some d =>
      cases hr : runConversions ss d.value with
      | none => simp [runConversions, hd, hr] at h
      | some rest =>
        simp [runConversions, hd, hr] at h
        subst r
        have hi := ih d.value rest hr
        simp only [ConversionRun.loss, List.map_cons, sumQ, ConversionEvent.loss] at *
        grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionEvent.loss](Conversion.md#decl-60b5dc28ff8bfb5b), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3), [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.evalInvocation_recovery](../TC/InvocationProperties.md#decl-137c91f57a77bdc9)

</details>

</details>

<a id="decl-ee15bd4271d1b71d"></a>

<details>
<summary><code>TensorCore.runConversions_events</code></summary>

[Lean source](../../../TensorCore/Numerics/Conversion.lean#L113)

```lean
/-- Every event is a successful conversion; the trace does not invent rounded boundaries. -/
theorem runConversions_events (ss : List ConversionStage) (x : ℚ) (r : ConversionRun)
    (h : runConversions ss x = some r) :
    r.events.map ConversionEvent.stage = ss ∧
      ∀ e ∈ r.events, e.stage.convert e.input = some e.output := by
  induction ss generalizing x r with
  | nil => simp [runConversions] at h; subst r; simp
  | cons s ss ih =>
    cases hd : s.convert x with
    | none => simp [runConversions, hd] at h
    | some d =>
      cases hr : runConversions ss d.value with
      | none => simp [runConversions, hd, hr] at h
      | some rest =>
        simp [runConversions, hd, hr] at h
        subst r
        have hi := ih d.value rest hr
        constructor
        · simpa using hi.1
        · intro e he
          simp only [List.mem_cons] at he
          rcases he with he | he
          · subst e; exact hd
          · exact hi.2 e he
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionEvent](Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](Conversion.md#decl-91103d704c4a7c32), [TensorCore.runConversions](Conversion.md#decl-3bc91db620898ff3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
