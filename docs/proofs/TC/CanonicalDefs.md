# TensorCore.TC.CanonicalDefs

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-00203670fbae3212"></a>

<details>
<summary><code>TensorCore.fp16Fp32Profile</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalDefs.lean#L10)

```lean
/-- Canonical FP16 products and FP32 c/output, with arbitrary block size and extra
alignment bits beyond the baseline 23. No finite upper limit is imposed on either
parameter by the reference model. Concrete hardware profiles require separate evidence. -/
@[implicit_reducible] def fp16Fp32Profile (K extraBits : ℕ) (floor : Option ℤ := none) : Profile :=
  ⟨fp16, K, (23 + extraBits : ℕ), floor⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.fp16](../Numerics/Defs.md#decl-2f0f377d9e2ae7dd)

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.Regression.below_threshold_monotone](../Tests/TC/Monotonicity.md#decl-e4f4d875391e40c8), [TensorCore.Regression.canonical_profile_results](../Tests/TC/Features.md#decl-3fccaf18bee4a287), [TensorCore.Regression.extra_alignment_bit_matters](../Tests/TC/Features.md#decl-2bd04552bd096078), [TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.machine_width_changes_result](../Tests/TC/Features.md#decl-40bf2a8b421b9a65), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.range_extrema_k5](../Tests/TC/Monotonicity.md#decl-459b27be7be5d321), [TensorCore.Regression.source_padding_boundary](../Tests/TC/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.ampereF16F32](CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.fp16Fp32Invocation](CanonicalDefs.md#decl-9e7567381e18f7e6), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.fp16Fp32_v100](CanonicalDefs.md#decl-b4e76a93c1e0ceaf), [TensorCore.hopperF16F32](CanonicalDefs.md#decl-3d43fc64b9e4a784), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.Regression.onesBlock](../Tests/TC/Features.md#decl-d7d6c9f7b87c97f3), [TensorCore.Regression.paddingInput](../Tests/TC/Features.md#decl-9891a3ab02786fc1)

</details>

</details>

<a id="decl-ac59b5835ffcc59f"></a>

<details>
<summary><code>TensorCore.ampereF16F32</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalDefs.lean#L13)

```lean
@[implicit_reducible] def ampereF16F32 : Profile := fp16Fp32Profile 8 1 (some (-132))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.profile](../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.Controls.group_reversal_detected](../Tests/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.range_witnesses](../Tests/TC/Monotonicity.md#decl-3051dcc3ac0e7fe4), [TensorCore.Regression.table_iii_witnesses](../Tests/TC/Monotonicity.md#decl-e962265e5ad3d55f), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4)

</details>

</details>

<a id="decl-3d43fc64b9e4a784"></a>

<details>
<summary><code>TensorCore.hopperF16F32</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalDefs.lean#L14)

```lean
@[implicit_reducible] def hopperF16F32 : Profile := fp16Fp32Profile 16 2 (some (-133))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Path.profile](../Kernels/EFT/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.range_witnesses](../Tests/TC/Monotonicity.md#decl-3051dcc3ac0e7fe4), [TensorCore.Regression.table_iii_witnesses](../Tests/TC/Monotonicity.md#decl-e962265e5ad3d55f), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b)

</details>

</details>

<a id="decl-9e7567381e18f7e6"></a>

<details>
<summary><code>TensorCore.fp16Fp32Invocation</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalDefs.lean#L16)

```lean
@[implicit_reducible] def fp16Fp32Invocation (K extraBits : ℕ) (floor : Option ℤ := none) :
    InvocationSpec := (fp16Fp32Profile K extraBits floor).toInvocation (23 + extraBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InvocationSpec](Invocation.md#decl-686e1fb8fa675688), [TensorCore.Profile.toInvocation](Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212)

<details>
<summary>Used by</summary>

[TensorCore.Regression.zero_product_canonical](../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58)

</details>

</details>

<a id="decl-b4e76a93c1e0ceaf"></a>

<details>
<summary><code>TensorCore.fp16Fp32_v100</code></summary>

[Lean source](../../../TensorCore/TC/CanonicalDefs.lean#L19)

```lean
theorem fp16Fp32_v100 : fp16Fp32Profile 4 0 none = v100F16F32 := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.v100F16F32](Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
