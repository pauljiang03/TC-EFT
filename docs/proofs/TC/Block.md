# TensorCore.TC.Block

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ad6b462d69117cc6"></a>

<details>
<summary><code>TensorCore.BlockInput</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L10)

```lean
/-- Encoded operands of one normalization group under a profile; `c` is always FP32. -/
structure BlockInput (p : Profile) where
  products : List (p.Word × p.Word)
  c : F32
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.BlockInput.toInvocation](Compatibility.md#decl-93b10149fa8f3535), [TensorCore.EFMachine.algorithm1](../Kernels/EFT/Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](../Kernels/EFT/Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_correct](../Kernels/EFT/Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_eq](../Kernels/EFT/Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../Kernels/EFT/Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../Kernels/EFT/Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](../Kernels/EFT/Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EFMachine.algorithm1_prepared](../Kernels/EFT/Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](../Kernels/EFT/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../Kernels/EFT/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.extraction_loop_bounds](../Kernels/EFT/Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare](../Kernels/EFT/Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_capacity](../Kernels/EFT/Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampereFloorInput](../Tests/Specification/NegativeControls.md#decl-a20e96d306f650cf), [TensorCore.PaperSpec.Controls.hopperFloorInput](../Tests/Specification/NegativeControls.md#decl-686fb49328f7f769), [TensorCore.PaperSpec.implementation_eq_paper](Specification/Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.inputOf](Specification/Stages.md#decl-d730ee2b6b6f92ab), [TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Specification/Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.result_iff_eval](Specification/Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.runBlocks_eq_paper](Specification/Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.supportedInput](Specification/Supported.md#decl-9a9de8a677d86544), [TensorCore.PaperSpec.supported_eq_paper](Specification/Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_valid_success](Specification/Supported.md#decl-5894ca01e6458495), [TensorCore.PaperSpec.terms_eq](Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.valid_success](Specification/Equivalence.md#decl-882143aa8462feae), [TensorCore.Regression.BoundedEFT.tiny_products](../Tests/EFT/BoundedEFT.md#decl-5787e0f814574c53), [TensorCore.Regression.BoundedEFT.wide_cancellation](../Tests/EFT/BoundedEFT.md#decl-7b1c5dfc5773a1d1), [TensorCore.Regression.BoundedEFT.zero_and_rejections](../Tests/EFT/BoundedEFT.md#decl-7cd9ddb4bc8c279c), [TensorCore.Regression.NativeEFT.single_v100_corrected](../Tests/EFT/NativeEFT.md#decl-8bc682481480e65b), [TensorCore.Regression.V100Input](../Tests/TC/Cases.md#decl-909afd874533ccae), [TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.below_threshold_monotone](../Tests/TC/Monotonicity.md#decl-e4f4d875391e40c8), [TensorCore.Regression.broadFiniteCounterexample](../Tests/EFT/EFT.md#decl-80f4870bbf3f2f51), [TensorCore.Regression.cancellationExample](../Tests/EFT/EFT.md#decl-b223f0d33aab3dd5), [TensorCore.Regression.eftSnapshot](../Tests/EFT/EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.encoded_eft_all_zero](../Tests/EFT/EncodedEFT.md#decl-84a376d9133b92c7), [TensorCore.Regression.encoded_eft_cancellation](../Tests/EFT/EncodedEFT.md#decl-277a69997e7c7a84), [TensorCore.Regression.encoded_eft_nonzero_c](../Tests/EFT/EncodedEFT.md#decl-3c8a2a316485713c), [TensorCore.Regression.encoded_eft_rejections](../Tests/EFT/EncodedEFT.md#decl-95e3c5cfb683c2bf), [TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.nonfinite_rejected](../Tests/TC/Cases.md#decl-082e7286ba370e3e), [TensorCore.Regression.outputBits](../Tests/TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.r1a](../Tests/TC/Cases.md#decl-e1107d0ad35081f3), [TensorCore.Regression.r1b](../Tests/TC/Cases.md#decl-5f69a6e568d8f739), [TensorCore.Regression.r2](../Tests/TC/Cases.md#decl-35d8f7ec1d3b4b93), [TensorCore.Regression.r3](../Tests/TC/Cases.md#decl-0419be5c38ea4116), [TensorCore.Regression.range_extrema_k5](../Tests/TC/Monotonicity.md#decl-459b27be7be5d321), [TensorCore.Regression.range_witnesses](../Tests/TC/Monotonicity.md#decl-3051dcc3ac0e7fe4), [TensorCore.Regression.scalar64DoubleRound](../Tests/EFT/ScalarEFT.md#decl-80912967825ad7ba), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.source_padding_boundary](../Tests/TC/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.Regression.subnormalAccumulator](../Tests/EFT/EFT.md#decl-5abbb5145c17d893), [TensorCore.Regression.subnormal_accumulator](../Tests/TC/Cases.md#decl-dda597d7fa9ce35d), [TensorCore.Regression.subnormal_multiplicand](../Tests/TC/Cases.md#decl-d8e79bf46e323fb0), [TensorCore.Regression.supportOverflow](../Tests/EFT/EFT.md#decl-5b2dcd48a837249a), [TensorCore.Regression.table_iii_witnesses](../Tests/TC/Monotonicity.md#decl-e962265e5ad3d55f), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.Regression.twoBlockCorrection](../Tests/TC/Composition.md#decl-ce09e036dcdb2b94), [TensorCore.Regression.twoBlockSummary](../Tests/TC/Composition.md#decl-27d6915f955ce3fa), [TensorCore.Regression.v100_nonmonotonicity_witness](../Tests/TC/Cases.md#decl-151391338d0d6284), [TensorCore.Regression.wrong_shape_rejected](../Tests/TC/Cases.md#decl-ec03e234a512bad1), [TensorCore.Regression.zero_block](../Tests/TC/Cases.md#decl-1a1976da8802c85b), [TensorCore.algorithm1Encoded](../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.algorithm1Encoded_agrees](../EFT/Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](../EFT/Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](../EFT/Encoded.md#decl-81edff15e18bd6d1), [TensorCore.algorithm1Encoded_of_evalBlock](../EFT/Encoded.md#decl-a76734b92f5db6bb), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.encodedBlockValue](EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_c](StageResiduals.md#decl-02be11fb27fe1a11), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_profile](StageResiduals.md#decl-62ff3f8872735af6), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.evalV100](Block.md#decl-9844fa72eb15e59b), [TensorCore.evalV100_machineAccumulator](AlignmentScale.md#decl-0fba10fcc54a6a0b), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](../EFT/Encoded.md#decl-aaaf1649ccd95844), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](../EFT/Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](../EFT/Encoded.md#decl-a3cbd61f8702b171), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.prepare_c](StageResiduals.md#decl-49dbce3f95e00cef), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b), [TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.tf32Input](CanonicalFormatDefs.md#decl-b27c196f6f1485b1), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d), [TensorCore.v100_machine_eq](MachineRefinement.md#decl-4818474771f10689), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.Regression.onesBlock](../Tests/TC/Features.md#decl-d7d6c9f7b87c97f3), [TensorCore.Regression.paddingInput](../Tests/TC/Features.md#decl-9891a3ab02786fc1)

</details>

</details>

<a id="decl-703939eff806d883"></a>

<details>
<summary><code>TensorCore.PreparedBlock</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L16)

```lean
/-- Decoded operands together with the profile that fixes their alignment semantics. -/
structure PreparedBlock where
  profile : Profile
  products : List (Decoded × Decoded)
  c : Decoded
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.EncodedChain](Composition.md#decl-ce41b49b9dd434c2), [TensorCore.MonotoneInAccumulator](Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.PaperSpec.accumulated_eq](Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.exponent_eq](Specification/Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.terms_eq](Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PreparedBlock.AlignmentExact](ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.allZeroTerms](../EFT/Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.PreparedInvocation.alignedBlock](Invocation.md#decl-f7d09369ac3f398e), [TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.r1_equal_product_values](../Tests/TC/Cases.md#decl-a77fdb2904fd7d75), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.source_padding_boundary](../Tests/TC/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.Regression.v100_witness_flowback](../Tests/EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.accumulatorShift](Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.accumulatorShift_of_exact](Flowback.md#decl-d93ce2ab3174723d), [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.block_alignment_bound](ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.eta_upper](AlignmentScale.md#decl-e33a1ecf006bdb03), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_c](StageResiduals.md#decl-02be11fb27fe1a11), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_profile](StageResiduals.md#decl-62ff3f8872735af6), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.flowback](Flowback.md#decl-69e48afeebdfb15c), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.overlap_window_width](../EFT/Algorithm1.md#decl-b8a661b7258cdacc), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT](../EFT/Encoded.md#decl-aaaf1649ccd95844), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](../EFT/Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](../EFT/Encoded.md#decl-a3cbd61f8702b171), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.prepare_c](StageResiduals.md#decl-49dbce3f95e00cef), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b), [TensorCore.terms_value](StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.aligned_recovery](InvocationProperties.md#decl-f6828402db94c42c)

</details>

</details>

<a id="decl-90abac48864edcd2"></a>

<details>
<summary><code>TensorCore.prepareProducts</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L22)

```lean
def prepareProducts (p : Profile) (ps : List (p.Word × p.Word)) :
    Option (List (Decoded × Decoded)) :=
  ps.mapM fun (a, b) => do
    return (← p.decode a, ← p.decode b)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.decodeProducts_values](../Kernels/EFT/Preparation.md#decl-db0d4ea753e99da4), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.PaperSpec.decode_products_eq](Specification/Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.terms_eq](Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.not_monotoneInAccumulator_of_encoded](EncodedMonotonicity.md#decl-6b04e8218d0c9697), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.prepareProducts_bounds](AlignmentScale.md#decl-24fca5acfef90681), [TensorCore.prepareProducts_origin](CanonicalFloor.md#decl-11f8a3777df18b50), [TensorCore.prepareProducts_replicate](Block.md#decl-3ef93e2d1a862b59), [TensorCore.prepare_c](StageResiduals.md#decl-49dbce3f95e00cef), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-32c2d7273540d876"></a>

<details>
<summary><code>TensorCore.prepare</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L27)

```lean
def prepare {p : Profile} (x : BlockInput p) : Option PreparedBlock :=
  match decode32 x.c, prepareProducts p x.products with
  | some c, some ps => some ⟨p, ps, c⟩
  | _, _ => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.decode32](../Numerics/Encoding.md#decl-a4001029898e709f), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.terms_eq](Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.Regression.r1_equal_product_values](../Tests/TC/Cases.md#decl-a77fdb2904fd7d75), [TensorCore.Regression.source_padding_boundary](../Tests/TC/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.prepareEncodedEFT](../EFT/Encoded.md#decl-aaaf1649ccd95844), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](../EFT/Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](../EFT/Encoded.md#decl-a3cbd61f8702b171), [TensorCore.prepareInvocation_legacy](Compatibility.md#decl-be944aa91243ce64), [TensorCore.prepare_c](StageResiduals.md#decl-49dbce3f95e00cef), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepare_fp16_products_metadata](Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](CanonicalFormats.md#decl-23c687067612f3ac), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-1f40b290e956d863"></a>

<details>
<summary><code>TensorCore.PreparedBlock.exactProducts</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L33)

```lean
/-- Ideal sum from decoded operands, without raw multiplication, alignment, or correction. -/
def PreparedBlock.exactProducts (b : PreparedBlock) : ℚ :=
  sumQ (b.products.map fun (a, b) => a.value * b.value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.runBlocks_corrected_correct](Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032)

</details>

</details>

<a id="decl-32d061749cae163e"></a>

<details>
<summary><code>TensorCore.PreparedBlock.exactDot</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L36)

```lean
def PreparedBlock.exactDot (b : PreparedBlock) : ℚ := b.c.value + b.exactProducts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.recovery](../EFT/ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](../EFT/ExtractionGrid.md#decl-2a11ac5f9735f162), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.source_padding_boundary](../Tests/TC/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.algorithm1Encoded_agrees](../EFT/Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1_bits_eq_round](../EFT/Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](../EFT/Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.corrected_correct](Correction.md#decl-ee6543cdd6791a37), [TensorCore.corrected_eq_round_exactDot](StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.recovered_eq_exactDot](StageResiduals.md#decl-8de6ec1e79d4f44f), [TensorCore.retained_add_low](../EFT/Extraction.md#decl-da77fbfd62ee1185), [TensorCore.returned_residual_identity](StageResiduals.md#decl-51c1f1398611023e), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_eq](../EFT/Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrectedIn_fp32_of_predicate](../EFT/Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrectedIn_isSome_iff](../EFT/Scalar.md#decl-a76f1dddc089a764), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarCorrected_eq](../EFT/Extraction.md#decl-f5da772603f2c94b), [TensorCore.tceft_correct](../EFT/Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_eq_corrected](../EFT/Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tceft_isSome_iff](../EFT/Extraction.md#decl-bf4ac7118d2101bc), [TensorCore.terms_value](StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.aligned_recovery](InvocationProperties.md#decl-f6828402db94c42c)

</details>

</details>

<a id="decl-451fb68e7faa00f3"></a>

<details>
<summary><code>TensorCore.exactDot</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L38)

```lean
def exactDot {p : Profile} (x : BlockInput p) : Option ℚ :=
  (prepare x).map PreparedBlock.exactDot
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_correct](../Kernels/EFT/Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../Kernels/EFT/Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../Kernels/EFT/Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](../Kernels/EFT/Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_range_iff](../Kernels/EFT/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../Kernels/EFT/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.extraction_loop_bounds](../Kernels/EFT/Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_capacity](../Kernels/EFT/Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.Regression.r1_equal_ideal](../Tests/TC/Cases.md#decl-268c5214225a8657), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478)

</details>

</details>

<a id="decl-5c50cde42f4cd44c"></a>

<details>
<summary><code>TensorCore.PreparedBlock.terms</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L41)

```lean
def PreparedBlock.terms (b : PreparedBlock) : List RawProduct :=
  ⟨b.c.significand, b.c.rawScale, b.c.fractionalBits⟩ ::
    b.products.map fun (a, b) => rawMul a b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.rawMul](../Numerics/RawProduct.md#decl-ebe5dd867373b275)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.coarse](../EFT/Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.lowParts](../EFT/Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.supportExponent](../EFT/Extraction.md#decl-3d45598c93a47213), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coarse](../EFT/ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.PaperSpec.accumulated_eq](Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.exponent_eq](Specification/Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.terms_eq](Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PreparedBlock.AlignmentExact](ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.allZeroTerms](../EFT/Encoded.md#decl-12dcaf3961e33ea9), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.block_alignment_bound](ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.eta_upper](AlignmentScale.md#decl-e33a1ecf006bdb03), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepare_fp16_term_metadata](Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_terms_bounded](AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.terms_value](StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032)

</details>

</details>

<a id="decl-2785502e5e4cba7a"></a>

<details>
<summary><code>TensorCore.alignmentScale</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L46)

```lean
/-- A nonempty maximum ignores zero terms; none explicitly represents an all-zero block. -/
def alignmentScale (ts : List RawProduct) : Option ℤ :=
  (ts.filterMap fun t => if t.significand = 0 then none else some t.rawScale).foldl
    (fun acc e => some (match acc with | none => e | some v => max v e)) none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.exponent_eq](Specification/Stages.md#decl-9cd77a7095185dd7), [TensorCore.PaperSpec.largestExponent_eq](Specification/Stages.md#decl-03502dce6de5b53e), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.alignmentScale_lower](CanonicalFloor.md#decl-e1b8106c4610681f), [TensorCore.alignmentScale_none](AlignmentScale.md#decl-7a39bdbbb3758c27), [TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6), [TensorCore.alignmentScale_upper](AlignmentScale.md#decl-4c48f1374c92ea89), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.eta_upper](AlignmentScale.md#decl-e33a1ecf006bdb03), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032)

</details>

</details>

<a id="decl-e0fb0ac9eab867d5"></a>

<details>
<summary><code>TensorCore.PreparedBlock.eta</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L51)

```lean
/-- Alignment exponent `eta`: nonzero raw-scale maximum, then the profile floor. -/
def PreparedBlock.eta (b : PreparedBlock) : Option ℤ :=
  b.profile.applyFloor (alignmentScale b.terms)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.accumulated_eq](Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.exponent_eq](Specification/Stages.md#decl-9cd77a7095185dd7), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.canonical_eta_floor_inactive](CanonicalFloor.md#decl-578fd56536970714), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_eta](Monotonicity.md#decl-2bc6cc7079bc2e96), [TensorCore.eta_term](AlignmentScale.md#decl-0312f3eb05a1fc6b), [TensorCore.eta_upper](AlignmentScale.md#decl-e33a1ecf006bdb03), [TensorCore.overlap_window_width](../EFT/Algorithm1.md#decl-b8a661b7258cdacc), [TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-43c39ff5fd4eef64"></a>

<details>
<summary><code>TensorCore.PreparedBlock.quantumExponent</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L55)

```lean
/-- Grid exponent `eta - F`. In an all-zero block any grid is equivalent. -/
def PreparedBlock.quantumExponent (b : PreparedBlock) : ℤ :=
  b.eta.getD 0 - b.profile.alignFraction
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.defaultExtraction](../EFT/ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.extractAt](../EFT/ExtractionGrid.md#decl-4fac256684e59d74), [TensorCore.BlockTrace.extractionExponent](../EFT/Defs.md#decl-f4644e4a3c22871b), [TensorCore.BlockTrace.retainedLowParts](../EFT/Defs.md#decl-9ea2d33eab35e3e8), [TensorCore.ExtractionGrid](../EFT/ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.retainedLowParts](../EFT/ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.PaperSpec.accumulated_eq](Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PreparedBlock.AlignmentExact](ExactAlignment.md#decl-0db1dbe57acfdb23), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.Regression.algorithm1_cases](../Tests/EFT/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.accumulatorShift](Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.accumulatorShift_of_exact](Flowback.md#decl-d93ce2ab3174723d), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.block_alignment_bound](ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.extractAt_isSome_iff](../EFT/ExtractionGrid.md#decl-452a7d9a3ed988fa), [TensorCore.flowback](Flowback.md#decl-69e48afeebdfb15c), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.overlap_window_width](../EFT/Algorithm1.md#decl-b8a661b7258cdacc), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-c0369f010f61825c"></a>

<details>
<summary><code>TensorCore.PreparedBlock.coefficients</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L58)

```lean
def PreparedBlock.coefficients (b : PreparedBlock) : List ℤ :=
  b.terms.map fun t => truncCoeff t.value b.quantumExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.truncCoeff](../Numerics/Exact.md#decl-282a0db962f1b274)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.accumulated_eq](Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.machineAccumulator](Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepared_coefficient_bound](AlignmentScale.md#decl-929725522df30cf8), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-a7916980cd8ee13e"></a>

<details>
<summary><code>TensorCore.PreparedBlock.accumulator</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L61)

```lean
def PreparedBlock.accumulator (b : PreparedBlock) : ℚ :=
  (sumZ b.coefficients : ℚ) * pow2 b.quantumExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Numerics/Exact.md#decl-eba77bb372c3b3ff)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.outputResidual](Block.md#decl-d1c97ba3515d5cad), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](../EFT/ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.PaperSpec.accumulated_eq](Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0), [TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.source_padding_boundary](../Tests/TC/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.canonical_padding_accumulator](Padding.md#decl-f91954987380658d), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_accumulator](Padding.md#decl-134b78c51d70ac7b), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.evalV100_machineAccumulator](AlignmentScale.md#decl-0fba10fcc54a6a0b), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.machineAccumulator_eq](AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.overlap_eq_retained_sub_outputResidual](../EFT/Extraction.md#decl-fc2dcdeff262fd49), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.aligned_recovery](InvocationProperties.md#decl-f6828402db94c42c)

</details>

</details>

<a id="decl-36e297929b24e234"></a>

<details>
<summary><code>TensorCore.PreparedBlock.alignmentResiduals</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L64)

```lean
def PreparedBlock.alignmentResiduals (b : PreparedBlock) : List ℚ :=
  b.terms.map fun t => t.value - truncGrid t.value b.quantumExponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.truncGrid](../Numerics/Exact.md#decl-104d085b38c6a29b)

<details>
<summary>Used by</summary>

[TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.accumulateInvocation](Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](InvocationProperties.md#decl-42509334ff62e502), [TensorCore.block_alignment_bound](ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.aligned_recovery](InvocationProperties.md#decl-f6828402db94c42c)

</details>

</details>

<a id="decl-6cc810f8061e66a0"></a>

<details>
<summary><code>TensorCore.PreparedBlock.extractReference</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L68)

```lean
/-- Exact stage extractor for any supplied numerical output. No conformance assumption. -/
def PreparedBlock.extractReference (b : PreparedBlock) (d : ℚ) : ℚ :=
  (b.accumulator - d) + sumQ b.alignmentResiduals
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.sumQ](../Numerics/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.aligned_recovery](InvocationProperties.md#decl-f6828402db94c42c)

</details>

</details>

<a id="decl-6e6aa9836448ab93"></a>

<details>
<summary><code>TensorCore.BlockTrace</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L72)

```lean
/-- All trace fields except the accepted input/output are derived by definitions. -/
structure BlockTrace where
  block : PreparedBlock
  output : Finite32
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.algorithm1](../EFT/Algorithm1.md#decl-01de1ae42b7279f3), [TensorCore.BlockTrace.coarse](../EFT/Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.corrected](Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.defaultExtraction](../EFT/ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.exactConsolidation](../EFT/Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.extractAt](../EFT/ExtractionGrid.md#decl-4fac256684e59d74), [TensorCore.BlockTrace.extractionExponent](../EFT/Defs.md#decl-f4644e4a3c22871b), [TensorCore.BlockTrace.lowCoefficients](../EFT/Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](../EFT/Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.outputResidual](Block.md#decl-d1c97ba3515d5cad), [TensorCore.BlockTrace.overlap](../EFT/Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.recovered](Block.md#decl-3d1b2fa71193a56d), [TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.BlockTrace.retainedLowParts](../EFT/Defs.md#decl-9ea2d33eab35e3e8), [TensorCore.BlockTrace.retainedSum](../EFT/Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarCorrected](../EFT/Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedIn](../EFT/Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](../EFT/Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarCorrectedUnchecked](../EFT/Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.BlockTrace.supportExponent](../EFT/Extraction.md#decl-3d45598c93a47213), [TensorCore.BlockTrace.tceft](../EFT/Extraction.md#decl-7b07b124468a5e26), [TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EncodedChain](Composition.md#decl-ce41b49b9dd434c2), [TensorCore.ExtractionGrid](../EFT/ExtractionGrid.md#decl-d0237d242e3d9256), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coarse](../EFT/ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.coefficients](../EFT/ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.overlap](../EFT/ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](../EFT/ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.ExtractionGrid.recovery](../EFT/ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.retainedLowParts](../EFT/ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.ExtractionGrid.retainedSum](../EFT/ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrected](../EFT/ExtractionGrid.md#decl-477dde6ee16e0ccb), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](../EFT/ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](../EFT/ExtractionGrid.md#decl-2a11ac5f9735f162), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.InstructionPath.output](Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.run_blocks](Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](Instruction.md#decl-812320a0c4dc3b22), [TensorCore.MonotoneInAccumulator](Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.group_reversal_detected](../Tests/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.implementation_eq_paper](Specification/Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Specification/Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.result_iff_eval](Specification/Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.runBlocks_eq_paper](Specification/Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.schedule_last_eq_paper](Specification/Composition.md#decl-551846c5cac8f668), [TensorCore.PaperSpec.supported_eq_paper](Specification/Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_valid_success](Specification/Supported.md#decl-5894ca01e6458495), [TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.valid_success](Specification/Equivalence.md#decl-882143aa8462feae), [TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.algorithm1_cases](../Tests/EFT/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.broad_finite_unchecked_incorrect](../Tests/EFT/EFT.md#decl-cb45e79b5c259faf), [TensorCore.Regression.canonical_profile_results](../Tests/TC/Features.md#decl-3fccaf18bee4a287), [TensorCore.Regression.eftSnapshot](../Tests/EFT/EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.extra_alignment_bit_matters](../Tests/TC/Features.md#decl-2bd04552bd096078), [TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.machine_width_changes_result](../Tests/TC/Features.md#decl-40bf2a8b421b9a65), [TensorCore.Regression.outputBits](../Tests/TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.r2_correction_unchanged](../Tests/TC/Cases.md#decl-2dfb188506a87c9a), [TensorCore.Regression.scalar64_corrects_midpoint](../Tests/EFT/ScalarEFT.md#decl-18ee9a4ee42888ea), [TensorCore.Regression.scalar64_subnormal_guard_rejects](../Tests/EFT/ScalarEFT.md#decl-6132856fad76f2bb), [TensorCore.Regression.scalar_generic_invalid_format_rejects](../Tests/EFT/ScalarEFT.md#decl-f7a094e3217d8fda), [TensorCore.Regression.scalar_public_r3](../Tests/EFT/EFT.md#decl-deb2ed8170b801e3), [TensorCore.Regression.scalar_public_subnormal_rejected](../Tests/EFT/EFT.md#decl-15c9e1f2ec694c3a), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.Regression.twoBlockCorrection](../Tests/TC/Composition.md#decl-ce09e036dcdb2b94), [TensorCore.Regression.twoBlockSummary](../Tests/TC/Composition.md#decl-27d6915f955ce3fa), [TensorCore.Regression.v100_witness_flowback](../Tests/EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.algorithm1Encoded](../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.algorithm1Encoded_agrees](../EFT/Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](../EFT/Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](../EFT/Encoded.md#decl-81edff15e18bd6d1), [TensorCore.algorithm1Encoded_of_evalBlock](../EFT/Encoded.md#decl-a76734b92f5db6bb), [TensorCore.algorithm1_bits_eq_round](../EFT/Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](../EFT/Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.algorithm1_scalar_iff](../EFT/Algorithm1.md#decl-035c260a0676f872), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.correctedSchedule](Correction.md#decl-968ff850f4220ec9), [TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](Correction.md#decl-ee6543cdd6791a37), [TensorCore.corrected_eq_round_exactDot](StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.defaultExtraction_components](../EFT/ExtractionGrid.md#decl-1aa3ddadc14ca74e), [TensorCore.defaultExtraction_scalar](../EFT/ExtractionGrid.md#decl-b88738f25d94e135), [TensorCore.encodedBlockValue](EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_c](StageResiduals.md#decl-02be11fb27fe1a11), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_profile](StageResiduals.md#decl-62ff3f8872735af6), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.evalV100](Block.md#decl-9844fa72eb15e59b), [TensorCore.evalV100_machineAccumulator](AlignmentScale.md#decl-0fba10fcc54a6a0b), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.extractAt_isSome_iff](../EFT/ExtractionGrid.md#decl-452a7d9a3ed988fa), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.lastOutput_bits](Instruction.md#decl-922f2f0fa043267c), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.overlap_eq_retained_sub_outputResidual](../EFT/Extraction.md#decl-fc2dcdeff262fd49), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.overlap_window_width](../EFT/Algorithm1.md#decl-b8a661b7258cdacc), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareEncodedEFT](../EFT/Encoded.md#decl-aaaf1649ccd95844), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](../EFT/Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](../EFT/Encoded.md#decl-a3cbd61f8702b171), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.recovered_eq_exactDot](StageResiduals.md#decl-8de6ec1e79d4f44f), [TensorCore.retained_add_low](../EFT/Extraction.md#decl-da77fbfd62ee1185), [TensorCore.returned_residual_identity](StageResiduals.md#decl-51c1f1398611023e), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b), [TensorCore.runBlocks_corrected_correct](Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886), [TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139), [TensorCore.runV100](Composition.md#decl-db0ac9bfd91eb790), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](../EFT/Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_eq](../EFT/Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrectedIn_fp32_of_predicate](../EFT/Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrectedIn_isSome_iff](../EFT/Scalar.md#decl-a76f1dddc089a764), [TensorCore.scalarCorrectedIn_rejects](../EFT/Scalar.md#decl-135cb7a9f7ad6ebe), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarCorrected_eq](../EFT/Extraction.md#decl-f5da772603f2c94b), [TensorCore.scalarCorrected_rejects](../EFT/Extraction.md#decl-2009b13f7b61d30c), [TensorCore.scalarOverlap_exact](../EFT/Scalar.md#decl-56c2b8a041adc97f), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.tceft_correct](../EFT/Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_eq_corrected](../EFT/Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tceft_isSome_iff](../EFT/Extraction.md#decl-bf4ac7118d2101bc), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d), [TensorCore.v100_machine_eq](MachineRefinement.md#decl-4818474771f10689), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-29503c8290420b97"></a>

<details>
<summary><code>TensorCore.BlockTrace.residual</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L77)

```lean
def BlockTrace.residual (t : BlockTrace) : ℚ := t.block.extractReference t.output.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.recovered](Block.md#decl-3d1b2fa71193a56d), [TensorCore.Regression.r2_correction_unchanged](../Tests/TC/Cases.md#decl-2dfb188506a87c9a), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.twoBlockSummary](../Tests/TC/Composition.md#decl-27d6915f955ce3fa), [TensorCore.correctedSchedule_correct](Correction.md#decl-c5490d1a25901294), [TensorCore.encoded_trace_ledger](Composition.md#decl-775280e15ad44086), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.recoveredSchedule](Correction.md#decl-dd85a41a20883c51), [TensorCore.recovered_eq_exactDot](StageResiduals.md#decl-8de6ec1e79d4f44f), [TensorCore.returned_residual_identity](StageResiduals.md#decl-51c1f1398611023e), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886)

</details>

</details>

<a id="decl-d1c97ba3515d5cad"></a>

<details>
<summary><code>TensorCore.BlockTrace.outputResidual</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L78)

```lean
def BlockTrace.outputResidual (t : BlockTrace) : ℚ := t.block.accumulator - t.output.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e)

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](../EFT/ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.overlap_eq_retained_sub_outputResidual](../EFT/Extraction.md#decl-fc2dcdeff262fd49)

</details>

</details>

<a id="decl-3d1b2fa71193a56d"></a>

<details>
<summary><code>TensorCore.BlockTrace.recovered</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L79)

```lean
def BlockTrace.recovered (t : BlockTrace) : ℚ := t.output.value + t.residual
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.Finite32.value](../Numerics/Encoding.md#decl-453b2816528e5c77)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.corrected](Block.md#decl-f68123201009b874), [TensorCore.corrected_eq_round_exactDot](StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.recovered_eq_exactDot](StageResiduals.md#decl-8de6ec1e79d4f44f)

</details>

</details>

<a id="decl-f68123201009b874"></a>

<details>
<summary><code>TensorCore.BlockTrace.corrected</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L80)

```lean
def BlockTrace.corrected (t : BlockTrace) : Option F32 := round32 .nearestEven t.recovered
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.recovered](Block.md#decl-3d1b2fa71193a56d), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.broad_finite_unchecked_incorrect](../Tests/EFT/EFT.md#decl-cb45e79b5c259faf), [TensorCore.Regression.r2_correction_unchanged](../Tests/TC/Cases.md#decl-2dfb188506a87c9a), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.algorithm1_bits_eq_round](../EFT/Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](../EFT/Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.corrected_correct](Correction.md#decl-ee6543cdd6791a37), [TensorCore.corrected_eq_round_exactDot](StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.tceft_eq_corrected](../EFT/Extraction.md#decl-942f125d26cb2d1b)

</details>

</details>

<a id="decl-f7be0c438a4d4d1d"></a>

<details>
<summary><code>TensorCore.ModelError</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L82)

```lean
inductive ModelError where
  | wrongProductCount
  | nonfiniteInput
  | accumulatorOutOfRange
  | nonfiniteOutput
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.InstructionPath.output](Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.run_blocks](Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](Instruction.md#decl-812320a0c4dc3b22), [TensorCore.MonotoneInAccumulator](Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.MonotoneInEncodedAccumulator](EncodedMonotonicity.md#decl-2fe557d3c0f04019), [TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.group_reversal_detected](../Tests/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.implementation_eq_paper](Specification/Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Specification/Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.result_iff_eval](Specification/Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.runBlocks_eq_paper](Specification/Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.schedule_last_eq_paper](Specification/Composition.md#decl-551846c5cac8f668), [TensorCore.PaperSpec.supported_eq_paper](Specification/Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_valid_success](Specification/Supported.md#decl-5894ca01e6458495), [TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.valid_success](Specification/Equivalence.md#decl-882143aa8462feae), [TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.algorithm1_cases](../Tests/EFT/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.below_threshold_monotone](../Tests/TC/Monotonicity.md#decl-e4f4d875391e40c8), [TensorCore.Regression.broad_finite_unchecked_incorrect](../Tests/EFT/EFT.md#decl-cb45e79b5c259faf), [TensorCore.Regression.cancellation_eft](../Tests/EFT/EFT.md#decl-6b77eba48adde1d2), [TensorCore.Regression.canonical_profile_results](../Tests/TC/Features.md#decl-3fccaf18bee4a287), [TensorCore.Regression.eftSnapshot](../Tests/EFT/EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.encoded_eft_all_zero](../Tests/EFT/EncodedEFT.md#decl-84a376d9133b92c7), [TensorCore.Regression.encoded_eft_branches](../Tests/EFT/EncodedEFT.md#decl-5458dc9dc7e0d9ae), [TensorCore.Regression.encoded_eft_cancellation](../Tests/EFT/EncodedEFT.md#decl-277a69997e7c7a84), [TensorCore.Regression.encoded_eft_nonzero_c](../Tests/EFT/EncodedEFT.md#decl-3c8a2a316485713c), [TensorCore.Regression.encoded_eft_rejections](../Tests/EFT/EncodedEFT.md#decl-95e3c5cfb683c2bf), [TensorCore.Regression.encoded_v100_not_monotone](../Tests/EFT/EncodedEFT.md#decl-83fcbe1b52439ce7), [TensorCore.Regression.extra_alignment_bit_matters](../Tests/TC/Features.md#decl-2bd04552bd096078), [TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.machine_width_changes_result](../Tests/TC/Features.md#decl-40bf2a8b421b9a65), [TensorCore.Regression.nonfinite_rejected](../Tests/TC/Cases.md#decl-082e7286ba370e3e), [TensorCore.Regression.outputBits](../Tests/TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.predicate_rejected](../Tests/EFT/EFT.md#decl-bf8ce5f4bd10756f), [TensorCore.Regression.r1_factorization_changes_output](../Tests/TC/Cases.md#decl-3b1ab9cc47cd7125), [TensorCore.Regression.r1_first_output](../Tests/TC/Cases.md#decl-16960547aa45240b), [TensorCore.Regression.r1_second_output](../Tests/TC/Cases.md#decl-9c6bafbcc319e9e9), [TensorCore.Regression.r1a_trace](../Tests/TC/Cases.md#decl-603c1bb56fa4a12b), [TensorCore.Regression.r1b_trace](../Tests/TC/Cases.md#decl-8231a2638d7ee001), [TensorCore.Regression.r2_correction_unchanged](../Tests/TC/Cases.md#decl-2dfb188506a87c9a), [TensorCore.Regression.r2_eft](../Tests/EFT/EFT.md#decl-d690dacbfcf7c018), [TensorCore.Regression.r2_trace](../Tests/TC/Cases.md#decl-bd812c9c48613529), [TensorCore.Regression.r3_eft](../Tests/EFT/EFT.md#decl-1bb37a5fcad699a9), [TensorCore.Regression.r3_trace](../Tests/TC/Cases.md#decl-cc0eab369e2b2bd7), [TensorCore.Regression.range_extrema_k5](../Tests/TC/Monotonicity.md#decl-459b27be7be5d321), [TensorCore.Regression.range_witnesses](../Tests/TC/Monotonicity.md#decl-3051dcc3ac0e7fe4), [TensorCore.Regression.scalar64_corrects_midpoint](../Tests/EFT/ScalarEFT.md#decl-18ee9a4ee42888ea), [TensorCore.Regression.scalar64_subnormal_guard_rejects](../Tests/EFT/ScalarEFT.md#decl-6132856fad76f2bb), [TensorCore.Regression.scalar_generic_invalid_format_rejects](../Tests/EFT/ScalarEFT.md#decl-f7a094e3217d8fda), [TensorCore.Regression.scalar_public_r3](../Tests/EFT/EFT.md#decl-deb2ed8170b801e3), [TensorCore.Regression.scalar_public_subnormal_rejected](../Tests/EFT/EFT.md#decl-15c9e1f2ec694c3a), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.subnormal_accumulator](../Tests/TC/Cases.md#decl-dda597d7fa9ce35d), [TensorCore.Regression.subnormal_accumulator_rejected](../Tests/EFT/EFT.md#decl-4c5672a5730106f4), [TensorCore.Regression.subnormal_multiplicand](../Tests/TC/Cases.md#decl-d8e79bf46e323fb0), [TensorCore.Regression.table_iii_witnesses](../Tests/TC/Monotonicity.md#decl-e962265e5ad3d55f), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.Regression.twoBlockCorrection](../Tests/TC/Composition.md#decl-ce09e036dcdb2b94), [TensorCore.Regression.twoBlockSummary](../Tests/TC/Composition.md#decl-27d6915f955ce3fa), [TensorCore.Regression.two_block_cancellation](../Tests/TC/Composition.md#decl-5f6a1741627b19bc), [TensorCore.Regression.two_block_corrected](../Tests/TC/Composition.md#decl-ee25e15fcb98163d), [TensorCore.Regression.v100_instruction_single_group](../Tests/TC/Instruction.md#decl-47a66c36f1e33146), [TensorCore.Regression.v100_nonmonotonicity_witness](../Tests/TC/Cases.md#decl-151391338d0d6284), [TensorCore.Regression.v100_witness_flowback](../Tests/EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.Regression.wrong_shape_rejected](../Tests/TC/Cases.md#decl-ec03e234a512bad1), [TensorCore.Regression.zero_block](../Tests/TC/Cases.md#decl-1a1976da8802c85b), [TensorCore.algorithm1Encoded](../EFT/Encoded.md#decl-8017eca136315bcf), [TensorCore.algorithm1Encoded_agrees](../EFT/Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1Encoded_allZero](../EFT/Encoded.md#decl-29b7b451e1ee0a65), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_nonzero](../EFT/Encoded.md#decl-81edff15e18bd6d1), [TensorCore.algorithm1Encoded_of_evalBlock](../EFT/Encoded.md#decl-a76734b92f5db6bb), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.encodedBlockValue](EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine](Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_c](StageResiduals.md#decl-02be11fb27fe1a11), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_profile](StageResiduals.md#decl-62ff3f8872735af6), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.evalV100](Block.md#decl-9844fa72eb15e59b), [TensorCore.evalV100_machineAccumulator](AlignmentScale.md#decl-0fba10fcc54a6a0b), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareEncodedEFT](../EFT/Encoded.md#decl-aaaf1649ccd95844), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](../EFT/Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](../EFT/Encoded.md#decl-a3cbd61f8702b171), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b), [TensorCore.runBlocks_corrected_correct](Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_residual_ledger](Composition.md#decl-c73efd4921810886), [TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139), [TensorCore.runV100](Composition.md#decl-db0ac9bfd91eb790), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d), [TensorCore.v100_machine_eq](MachineRefinement.md#decl-4818474771f10689), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-700b85398ddd8f12"></a>

<details>
<summary><code>TensorCore.evalPrepared</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L89)

```lean
def evalPrepared (b : PreparedBlock) : Except ModelError BlockTrace :=
  match round32 .towardZero b.accumulator with
  | none => .error .accumulatorOutOfRange
  | some bits => match finite32 bits with
    | none => .error .nonfiniteOutput
    | some d => .ok ⟨b, d⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.RoundingMode](../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.finite32](../Numerics/Encoding.md#decl-82d0e30146423be5), [TensorCore.round32](../Numerics/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.MonotoneInAccumulator](Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.v100_witness_flowback](../Tests/EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.construction_not_monotone](Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPreparedMachine_eq](MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.flowback_necessary](Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](Flowback.md#decl-b0715c384a285eb0), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](Compatibility.md#decl-50d76905479abf5e), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_perturbation](Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.output_condition](Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.padded_prepared_bits](CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-58fdfbbb09a9ba58"></a>

<details>
<summary><code>TensorCore.evalBlock</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L97)

```lean
/-- One normalization group of the profile, not a complete PTX tile or GEMM. -/
def evalBlock {p : Profile} (x : BlockInput p) : Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => evalPrepared b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.implementation_eq_paper](Specification/Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.invocation_eq_paper](Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](Specification/Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.result_iff_eval](Specification/Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.runBlocks_eq_paper](Specification/Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.supported_eq_paper](Specification/Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_valid_success](Specification/Supported.md#decl-5894ca01e6458495), [TensorCore.PaperSpec.tf32_eq_paper](Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.PaperSpec.valid_success](Specification/Equivalence.md#decl-882143aa8462feae), [TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.algorithm1_cases](../Tests/EFT/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.broad_finite_unchecked_incorrect](../Tests/EFT/EFT.md#decl-cb45e79b5c259faf), [TensorCore.Regression.canonical_profile_results](../Tests/TC/Features.md#decl-3fccaf18bee4a287), [TensorCore.Regression.eftSnapshot](../Tests/EFT/EFT.md#decl-3c783b17ffee5336), [TensorCore.Regression.extra_alignment_bit_matters](../Tests/TC/Features.md#decl-2bd04552bd096078), [TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.outputBits](../Tests/TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.scalar64_corrects_midpoint](../Tests/EFT/ScalarEFT.md#decl-18ee9a4ee42888ea), [TensorCore.Regression.scalar64_subnormal_guard_rejects](../Tests/EFT/ScalarEFT.md#decl-6132856fad76f2bb), [TensorCore.Regression.scalar_generic_invalid_format_rejects](../Tests/EFT/ScalarEFT.md#decl-f7a094e3217d8fda), [TensorCore.Regression.scalar_public_r3](../Tests/EFT/EFT.md#decl-deb2ed8170b801e3), [TensorCore.Regression.scalar_public_subnormal_rejected](../Tests/EFT/EFT.md#decl-15c9e1f2ec694c3a), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.algorithm1Encoded_of_evalBlock](../EFT/Encoded.md#decl-a76734b92f5db6bb), [TensorCore.ampere_machineAccumulator](Canonical.md#decl-4e3007238613f1c9), [TensorCore.ampere_machine_eq](MachineRefinement.md#decl-16fb9b96706fbec4), [TensorCore.bf16Fp32_contract](CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.bf16Fp32_invocation_compatible](CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_padding_success_iff](Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.canonical_source_padding_success_iff](Padding.md#decl-ca6987fa7885e6c2), [TensorCore.encodedBlockValue](EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.evalBlockMachine_eq](MachineRefinement.md#decl-d4518ab25c18ea58), [TensorCore.evalBlock_c](StageResiduals.md#decl-02be11fb27fe1a11), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_corrected_correct](Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_machineAccumulator](AlignmentScale.md#decl-33be1c6d56f7d2cd), [TensorCore.evalBlock_machinePrefix](AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalBlock_profile](StageResiduals.md#decl-62ff3f8872735af6), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.evalV100](Block.md#decl-9844fa72eb15e59b), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp16Fp32_invocation_compatible](Canonical.md#decl-77d448deb0e063d7), [TensorCore.fp16Fp32_machine_eq](MachineRefinement.md#decl-528413e0ee3dba60), [TensorCore.hopper_machineAccumulator](Canonical.md#decl-06a8e4120caf10df), [TensorCore.hopper_machine_eq](MachineRefinement.md#decl-ec34a5ffce80d97b), [TensorCore.legacy_invocation_bits](Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.monotoneInAccumulator_encoded](EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runBlocks_chain](Composition.md#decl-4a9736f9c5dc068b), [TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.tf19Fp32_contract](CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.tf32_input_bits](CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100_machine_eq](MachineRefinement.md#decl-4818474771f10689), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-9844fa72eb15e59b"></a>

<details>
<summary><code>TensorCore.evalV100</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L103)

```lean
abbrev evalV100 (x : BlockInput v100F16F32) : Except ModelError BlockTrace := evalBlock x
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.v100F16F32](Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.r2_correction_unchanged](../Tests/TC/Cases.md#decl-2dfb188506a87c9a), [TensorCore.evalV100_machineAccumulator](AlignmentScale.md#decl-0fba10fcc54a6a0b), [TensorCore.v100_invocation_bits](Compatibility.md#decl-eb86b04e40aea23d)

</details>

</details>

<a id="decl-3ef93e2d1a862b59"></a>

<details>
<summary><code>TensorCore.prepareProducts_replicate</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L105)

```lean
theorem prepareProducts_replicate (p : Profile) (a b : p.Word) (da db : Decoded) (K : ℕ)
    (ha : p.decode a = some da) (hb : p.decode b = some db) :
    prepareProducts p (List.replicate K (a, b)) = some (List.replicate K (da, db)) := by
  induction K with
  | zero => rfl
  | succ n ih =>
    have ih' := ih
    simp [prepareProducts] at ih'
    simp [prepareProducts, List.replicate_succ, List.mapM_cons, ha, hb, ih']
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_encoded](Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_range_encoded](MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-8e67b4eed923de99"></a>

<details>
<summary><code>TensorCore.construction_coefficients</code></summary>

[Lean source](../../../TensorCore/TC/Block.lean#L116)

```lean
/-- Coefficients of a block with one repeated operand pair. -/
theorem construction_coefficients (prof : Profile) (K : ℕ) (da db c : Decoded) :
    (PreparedBlock.mk prof (List.replicate K (da, db)) c).coefficients =
      truncCoeff c.value (PreparedBlock.mk prof (List.replicate K (da, db)) c).quantumExponent ::
      List.replicate K (truncCoeff (rawMul da db).value
        (PreparedBlock.mk prof (List.replicate K (da, db)) c).quantumExponent) := by
  simp [PreparedBlock.coefficients, PreparedBlock.terms, List.map_replicate, RawProduct.value,
    Decoded.value]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Numerics/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.truncCoeff](../Numerics/Exact.md#decl-282a0db962f1b274)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_below](Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>
