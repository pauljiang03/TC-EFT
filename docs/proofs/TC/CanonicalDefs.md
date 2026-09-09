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

**Definitions and types:** [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd)

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.PaperSpec.gemmInstructions_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.Regression.below_threshold_monotone](Regression/Monotonicity.md#decl-e4f4d875391e40c8), [TensorCore.Regression.canonical_profile_results](Regression/Features.md#decl-3fccaf18bee4a287), [TensorCore.Regression.constructed_partition_boundaries](Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.Regression.constructed_partition_tail](Regression/DotProduct.md#decl-571ad9339f4b196c), [TensorCore.Regression.extra_alignment_bit_matters](Regression/Features.md#decl-2bd04552bd096078), [TensorCore.Regression.flowback_without_increase](../EFT/Regression/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.machine_width_changes_result](Regression/Features.md#decl-40bf2a8b421b9a65), [TensorCore.Regression.padding_range_boundary](Regression/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.range_extrema_k5](Regression/Monotonicity.md#decl-459b27be7be5d321), [TensorCore.Regression.source_padding_boundary](Regression/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.ampereF16F32](CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.boundedDot](Examples/BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.boundedDot_count](Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_ideal](Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.boundedDot_inputs](Examples/BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.boundedDot_run](Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.boundedDot_scales](Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.canonicalPartition](Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.canonicalPartition_count](Program/Partition.md#decl-1992fedc2c2443e2), [TensorCore.canonicalPartition_ideal](Program/Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.familyCheck_sound](../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.fp16Fp32Invocation](CanonicalDefs.md#decl-9e7567381e18f7e6), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.fp16Fp32_schedule_machine_eq](Program/DotProduct.md#decl-1fc40acc7fd9825c), [TensorCore.fp16Fp32_v100](CanonicalDefs.md#decl-b4e76a93c1e0ceaf), [TensorCore.gemmBlocks_count](../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmInstructions](../Gemm/Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmInstructions_flatten](../Gemm/Defs.md#decl-353da63dd578fcb7), [TensorCore.gemmInstructions_shape](../Gemm/Defs.md#decl-863019b6c0164a66), [TensorCore.hopperF16F32](CanonicalDefs.md#decl-3d43fc64b9e4a784), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.idealProducts_padFp16Pairs](Program/Partition.md#decl-78a2a3efb15b0ed0), [TensorCore.nonmonotone_ampere_family](Regression/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](Regression/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_range_ampere_family](Regression/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](Regression/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](Regression/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](Regression/Monotonicity.md#decl-06e754610d570873), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139), [TensorCore.runCanonicalDot](Program/Partition.md#decl-a632fab4c91f1890), [TensorCore.runCanonicalDotMachine](Program/Partition.md#decl-17379ac1513b54b1), [TensorCore.runCanonicalDot_blocks](Program/Partition.md#decl-7011e2bb23eafa4c), [TensorCore.runCanonicalDot_count](Program/Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_finite](Program/Partition.md#decl-70d7bcd0619569bf), [TensorCore.runCanonicalDot_machine_eq](Program/Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Program/Partition.md#decl-a122af29bf2c3029), [TensorCore.runCanonicalDot_uncorrected_error](Program/Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Program/Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_count](../Gemm/Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.ideal_zero_pairs](Program/Partition.md#decl-19d8614714352936), [TensorCore.Regression.onesBlock](Regression/Features.md#decl-f38fbd2896b80c60), [TensorCore.Regression.paddingInput](Regression/Features.md#decl-dcc5ebcf924fd865)

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

[TensorCore.EFMachine.Path.profile](../EFT/Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.Controls.group_reversal_detected](../Regression/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.range_witnesses](Regression/Monotonicity.md#decl-3051dcc3ac0e7fe4), [TensorCore.Regression.table_iii_witnesses](Regression/Monotonicity.md#decl-e962265e5ad3d55f), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4)

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

[TensorCore.EFMachine.Path.profile](../EFT/Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.PaperSpec.implementationProfile](Specification/Supported.md#decl-3c13ed61a6208d31), [TensorCore.Regression.range_witnesses](Regression/Monotonicity.md#decl-3051dcc3ac0e7fe4), [TensorCore.Regression.table_iii_witnesses](Regression/Monotonicity.md#decl-e962265e5ad3d55f), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b)

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

[TensorCore.Regression.zero_product_canonical](Regression/PublicDomains.md#decl-d277804bf4bb3c58)

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
