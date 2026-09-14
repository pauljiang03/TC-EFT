# TensorCore.Core.Exact

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b52a0281b35514e3"></a>

<details>
<summary><code>TensorCore.pow2</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L11)

```lean
def pow2 (e : ℤ) : ℚ := (2 : ℚ) ^ e
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.finiteValue](Binary/RoundTrip.md#decl-8ccfd6c43d66f303), [TensorCore.BinaryRep.sign_of_nonzero](Binary/SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.BinaryRep.value](Binary/Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.BinaryRep.value_eq_zero_iff](Binary/RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.BlockTrace.errorBudget](../TC/Program/ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.BlockTrace.lowCoefficients](../EFT/Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.Decoded.value_ne_zero](../TC/Instruction.md#decl-411ba01d7f55e7d1), [TensorCore.EFMachine.Accumulator.term_value](../EFT/Machine/Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.Prepared.ideal_allZero](../EFT/Machine/Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.Word.abs_value](../EFT/Machine/Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.add_value](../EFT/Machine/Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.neg_value](../EFT/Machine/Word.md#decl-2d5527f4636e4785), [TensorCore.EFMachine.Word.range_iff](../EFT/Machine/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.sameValue_value](../EFT/Machine/Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.Word.sign_value](../EFT/Machine/Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split_coarse_value](../EFT/Machine/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low_bound](../EFT/Machine/Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_reconstruct](../EFT/Machine/Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.value](../EFT/Machine/WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.Word.value_zero_iff](../EFT/Machine/Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.dyadic_div](../EFT/Machine/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.magnitudeExponent_word](../EFT/Machine/Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.magnitudeValue](../EFT/Machine/Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.pow2_common](../EFT/Machine/Round.md#decl-8e9c8ffd317bb724), [TensorCore.EFMachine.product_value](../EFT/Machine/Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.EFMachine.roundingCoefficient_convCoeff](../EFT/Machine/Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingGrid_div](../EFT/Machine/Round.md#decl-73afe430816bd696), [TensorCore.EFMachine.shiftedWord_value](../EFT/Machine/Decode.md#decl-c7dc56eb3d6d341c), [TensorCore.EFMachine.signedDyadic](../EFT/Machine/Split.md#decl-763c208b0e2b895c), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../EFT/Machine/Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low_residual](../EFT/Machine/Split.md#decl-6d6fe2bc592a6791), [TensorCore.EFMachine.sumWords_value](../EFT/Machine/Word.md#decl-c50a82a7014218e4), [TensorCore.EFMachine.zeroWord_value](../EFT/Machine/Decode.md#decl-4c8297f8c50b7d91), [TensorCore.ExtractionGrid.coefficients](../EFT/ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.Format.FiniteValue](Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.binade_grid](Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finiteValue_neg](Binary/CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.Format.maxFinite](Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.maxFinite_lt](Binary/ConversionBounds.md#decl-27fef2f17e469434), [TensorCore.Format.next_binade_grid](Binary/ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.IEEE.LeanBridge.aligned_add_value](../IEEE/LeanBridge.md#decl-e6cb66147cd6c96f), [TensorCore.IEEE.LeanBridge.aligned_sub_value](../IEEE/LeanBridge.md#decl-e1219acca53993f8), [TensorCore.IEEE.LeanBridge.decode32_nonzero](../IEEE/LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decode64_nonzero](../IEEE/LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.decreaseExponent_value](../IEEE/LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../IEEE/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](../IEEE/LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.finiteValue32](../IEEE/LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](../IEEE/LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](../IEEE/LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.finiteValue64](../IEEE/LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.finiteValue64_mul](../IEEE/LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.firstPass32](../IEEE/LeanRounding.md#decl-1f3110087e3c2f88), [TensorCore.IEEE.LeanBridge.firstPass64](../IEEE/LeanRounding64.md#decl-25a14bb65450486f), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../IEEE/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../IEEE/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](../IEEE/LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](../IEEE/LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../IEEE/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](../IEEE/LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../IEEE/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](../IEEE/LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../IEEE/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](../IEEE/LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_eq](../IEEE/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../IEEE/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_eq](../IEEE/LeanBridge64.md#decl-0c708a8abb7275bb), [TensorCore.IEEE.LeanBridge.packRound64_reference](../IEEE/LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.shiftRight_represents](../IEEE/LeanRounding.md#decl-7f6354812c57ad44), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](../IEEE/LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.IEEE.LeanBridge.shifted_round_eq_rne](../IEEE/LeanRounding.md#decl-f6d8726852e1a50e), [TensorCore.IEEE.LeanBridge.targetExponent32_eq](../IEEE/LeanRounding.md#decl-fe597c4119872d5a), [TensorCore.IEEE.LeanBridge.targetExponent64_eq](../IEEE/LeanRounding64.md#decl-459c5dd362ffb581), [TensorCore.IEEE.PrecisionRound](../IEEE/Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.Regression.gradual_underflow](../IEEE/Tests/Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.normal_output_underflow](../IEEE/Tests/Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.tininess_choice](../IEEE/Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.decode_finite_iff](../IEEE/Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.maxFiniteWord_value](../IEEE/Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.nativeAddResult32_eq](../IEEE/NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64_eq](../IEEE/NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32_eq](../IEEE/NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64_eq](../IEEE/NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32_eq](../IEEE/NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](../IEEE/NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.precisionMagnitude](../IEEE/Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.precisionMagnitude_correct](../IEEE/Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionMagnitude_le_max](../IEEE/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](../IEEE/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionMagnitude_positive](../IEEE/Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precisionRound_unique](../IEEE/Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.round_overflow_iff](../IEEE/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.tiny](../IEEE/Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero_value](../IEEE/Basic.md#decl-42575e26b6696b19), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.coefficient_eq](../TC/Specification/Stages.md#decl-2eed3165d7f83748), [TensorCore.PaperSpec.decode_eq](../TC/Specification/Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.raw_value_zero](../TC/Specification/Stages.md#decl-1b686554b9d985d5), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.scalarExponent_unique](../Gemm/Specification/ScalarRounding.md#decl-dc1d766095dea794), [TensorCore.PaperSpec.scalarGridValue_eq](../Gemm/Specification/ScalarRounding.md#decl-b4fe8f74d8aee01a), [TensorCore.PaperSpec.scalarResult_of_roundBinary](../Gemm/Specification/ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.terms_eq](../TC/Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.machineAccumulator](../TC/Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.Program.accurate_of_scales](../TC/Program/Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.repeat_accurate_of_scales](../TC/Program/Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](RawProduct.md#decl-549312d8d1563679), [TensorCore.Regression.analysis_exact_product_alignment](../Gemm/Regression/GemmAnalysis.md#decl-e517a47b8f995a4f), [TensorCore.Regression.encoded_v100_not_monotone](../EFT/Regression/EncodedEFT.md#decl-83fcbe1b52439ce7), [TensorCore.Regression.eq20_public_accepts](../Regression/FoundationCompletion.md#decl-b1321756db80e3f1), [TensorCore.Regression.eq20_signed_budget](../Regression/FoundationCompletion.md#decl-0598e4ed93ef2381), [TensorCore.Regression.exact_scalar_budgets](../Gemm/Regression/DecisionExtensions.md#decl-dc66e6e5ce7975e9), [TensorCore.Regression.family_subnormal_scales](../Gemm/Regression/GemmFamily.md#decl-604135b609aa95d6), [TensorCore.Regression.finite_bijection_endpoints](../TC/Regression/DirectedBinary.md#decl-b74680eb28ad51fd), [TensorCore.Regression.independent_scalar_directions](../Regression/FoundationCompletion.md#decl-ac87bcf2ff18868c), [TensorCore.Regression.out_of_range_rejected](../TC/Regression/Cases.md#decl-de4d74472a6abfec), [TensorCore.Regression.partition_error_contract](../TC/Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.r4_binade_asymmetry](../TC/Regression/Cases.md#decl-dd87c11927efb30e), [TensorCore.Regression.r4_binade_carry](../TC/Regression/Cases.md#decl-3b313daa3dfd8b27), [TensorCore.Regression.r4_cancellation](../TC/Regression/Cases.md#decl-f5b3a2f370a66b02), [TensorCore.Regression.r4_even_tie](../TC/Regression/Cases.md#decl-bc54899e2865dcef), [TensorCore.Regression.r4_midpoint_distances](../TC/Regression/Composition.md#decl-7fa1f7d6ed299760), [TensorCore.Regression.r4_negative_zero](../TC/Regression/Cases.md#decl-1edb476558a306fe), [TensorCore.Regression.r4_odd_tie](../TC/Regression/Cases.md#decl-7d03f05653e1e285), [TensorCore.Regression.r4_subnormal_boundary](../TC/Regression/Cases.md#decl-9a49c360edf3a319), [TensorCore.Regression.r4_zero_tie](../TC/Regression/Cases.md#decl-54a7f4f8fbe4a04d), [TensorCore.Regression.scalar64_coarse_grid](../EFT/Regression/ScalarEFT.md#decl-71ebab7703c3a1c5), [TensorCore.Regression.scalar64_double_rounding_incorrect](../EFT/Regression/ScalarEFT.md#decl-75316677317adbed), [TensorCore.Regression.scalar64_finite_boundary](../EFT/Regression/ScalarEFT.md#decl-2400fe596e80a925), [TensorCore.Regression.scalar64_preserves_low_component](../EFT/Regression/ScalarEFT.md#decl-04af8db10d4464ca), [TensorCore.Regression.scalar64_subnormal_sum](../EFT/Regression/ScalarEFT.md#decl-cb03ef10bf4e4cbd), [TensorCore.Regression.scalar_bitSpan_budget](../EFT/Regression/ScalarEFT.md#decl-4f8ed7cf41298ebe), [TensorCore.Regression.source_padding_boundary](../TC/Regression/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.Regression.tight_input_edges](../Regression/FoundationCompletion.md#decl-d874c31dcab129cf), [TensorCore.Regression.v100_products_not_monotone](../EFT/Regression/Flowback.md#decl-725fd4d619d07b0f), [TensorCore.ScaledGemmBoundConfig.valid](../Gemm/ScaledGemmBounds.md#decl-7446bfd9bf9ae59b), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.accumulator_abs_lt](../TC/StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.accumulator_lt_pow2](../TC/StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual](Truncation.md#decl-8fb54cfc251e7721), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.alignment_static_bound](../TC/StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.alignment_value](Truncation.md#decl-4fd20c57624d75c8), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.belowDecoded_value](../TC/MonotonicityRange.md#decl-5392c153e1597baf), [TensorCore.belowOneDecoded_value](../TC/Monotonicity.md#decl-48fa61f0bee3fd85), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.binaryCarry_spec](Binary/ConversionBounds.md#decl-9bdec62f2ae623aa), [TensorCore.binaryConvCoeff_bounds](Binary/ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryConvExp_bounds](Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.binaryMagnitudeRounded](Binary/CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binaryMagnitudeRounded_lower](Binary/CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binaryValue_zero](Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](Binary/CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.carry_spec](ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkScalar](../Gemm/ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.checkScalar_inferred](../Gemm/ScalarAnalysis.md#decl-6e0263f84e5e0f8c), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.classifyNat32_finite](EncodingProperties.md#decl-2559eed0b9bbddd9), [TensorCore.classifyNat_finiteValue](Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.coefficient_range_of_grid](Binary/ScalarSum.md#decl-427e226844e8fe51), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](../TC/Block.md#decl-8e67b4eed923de99), [TensorCore.construction_not_monotone](../TC/Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.convExp_le_of_lt](Rounding.md#decl-49ec78234aca30b2), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.decoded_zero_bounded](FormatProperties.md#decl-552117025e86e0df), [TensorCore.div_pow2](Exact.md#decl-341a7e90774bc1d1), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.encodeBinary_value](Binary/Encoding.md#decl-4c3ec26630f2de66), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.familyConditions](../Gemm/Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](../Gemm/Family.md#decl-56c849a6d64aa7bf), [TensorCore.familyOperandScale_spec](../Gemm/Family.md#decl-82f743426dfee31b), [TensorCore.family_pair_scale](../Gemm/Family.md#decl-797e6af7a549f294), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finiteValue32_neg](CorrectRounding.md#decl-e82bec275802f6d0), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.gemmCellCheck](../Gemm/Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmConversionError](../Gemm/ConversionBounds.md#decl-74312d1a61a1a984), [TensorCore.gemmConversionModeError_le](../Gemm/RoundingBudget.md#decl-a884460a8acd89fe), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.gemmInputDatum_error_le](../Gemm/InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmProductMagnitude](../Gemm/ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.grid_finiteValue](Binary/ScalarSum.md#decl-f22e396ecf09e13e), [TensorCore.grid_finiteValue32](ScalarSum.md#decl-5c5b5245f25f71db), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.groupBound](../TC/Program/GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupBound_le_static](../TC/Program/GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_magnitude](../TC/Program/GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.groupBound_nonneg](../TC/Program/GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.groupWitnessCheck](../TC/Program/GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.idealProducts_abs_le_of_scale](../TC/Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.inferGroupWitness_valid](../TC/Program/GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.machineAccumulator_eq](../TC/AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_le_of_lt](Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.magnitudeScale_spec](../TC/Program/GroupAnalysis.md#decl-d51d916c1a50ab6d), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.maxFinite32_ge_pow2_127](../TC/StaticBudget.md#decl-c065d1805b03afa6), [TensorCore.maxFinite32_lt_pow128](ConversionBounds.md#decl-5f5cd77d343a83f6), [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.naiveSum64_exact](Binary/ScalarSum.md#decl-d74afdeb99860469), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinary_exact](Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](Binary/ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.naiveSumBinary_exact_perm](Binary/ScalarSum.md#decl-f78af6692d4089d7), [TensorCore.native_zero_products](../Gemm/NativeGemm.md#decl-f24f4761f46023ad), [TensorCore.next_binade_grid](ConversionBounds.md#decl-6e741e2915b593fa), [TensorCore.nonmonotone_ampere_family](../TC/Regression/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](../TC/Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../TC/Regression/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../TC/Regression/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](../TC/MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../TC/Regression/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../TC/Regression/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../TC/Regression/Monotonicity.md#decl-06e754610d570873), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.partialSumsCheck](../TC/Program/StaticCertificate.md#decl-3830663114f133c4), [TensorCore.partialSumsCheck_sound](../TC/Program/StaticCertificate.md#decl-df9e82cd1ad7c2d7), [TensorCore.pow2_24](Exact.md#decl-be4c7e0a2eccbdd4), [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_div](Exact.md#decl-71bd87700a9fc6ed), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_lt_succ](Exact.md#decl-b1dfe79296f2080d), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_one](Exact.md#decl-8feaca6c2e8345f1), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b), [TensorCore.pow2_zero](Exact.md#decl-ac9c8646649b0ae0), [TensorCore.prepared_coefficient_bound](../TC/AlignmentScale.md#decl-929725522df30cf8), [TensorCore.prepared_static_success](../TC/StaticBudget.md#decl-2a79f971d61c16c9), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.rawAlignmentBudget](../TC/Program/Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawAlignmentBudget_le](../TC/Program/Bounds/Local.md#decl-7c8beacba137af93), [TensorCore.rawAlignmentBudget_nonneg](../TC/Program/Bounds/Local.md#decl-30f7e6c784a8caa3), [TensorCore.rawAlignmentBudget_sound](../TC/Program/Bounds/Local.md#decl-1e83b17fa3bc236b), [TensorCore.rawAlignmentBudget_zero](../TC/Program/Bounds/Local.md#decl-16ff676e03bc4bb1), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawMul_significand_ne_zero](../TC/Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_nearestEven_correct](Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](Binary/RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](Binary/RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](Binary/DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](Binary/DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](Binary/RoundingContract.md#decl-765cac64e8b78cf4), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.runBlocks_of_scale_bound](../TC/Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_static](../TC/StaticBudget.md#decl-31af1b208da9e431), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.scalarScale_spec](../Gemm/ScalarAnalysis.md#decl-ab7863fd9c2c72d3), [TensorCore.scaledGemmCellCheck](../Gemm/ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.small16_value](../TC/Examples/BoundedDot.md#decl-a57578c06982c772), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.staticBudget_positive](../TC/Program/Bounds/Scales.md#decl-52e870bce380a2a2), [TensorCore.staticCheck_sound](../TC/Program/StaticCertificate.md#decl-d9cfd7eeec01ec69), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.term_abs_lt](../TC/StaticBudget.md#decl-eb7aab7cbcc8d87a), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncCoeff_nonneg_eq](Truncation.md#decl-a3484604d19e0df2), [TensorCore.truncCoeff_of_grid](Truncation.md#decl-03b847921a9aec6d), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_exact_of_grid](Truncation.md#decl-8a6ed0cd1522f575), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.truncGrid_zero](Truncation.md#decl-c8fd94be6ed59920), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.magnitude_error](../Gemm/ConversionBounds.md#decl-1936078aa7bb5925), [TensorCore.signed_error](../Gemm/ConversionBounds.md#decl-5a8644e3b68e60af), [TensorCore.magnitude_error](../Gemm/RoundingBudget.md#decl-31adebb3a0727f59), [TensorCore.signed_error](../Gemm/RoundingBudget.md#decl-05aed2e9019958e7), [TensorCore.small_schedule_room](../TC/Examples/BoundedDot.md#decl-30fd3ad0d5d57034), [TensorCore.ideal_zero_pairs](../TC/Program/Partition.md#decl-19d8614714352936), [TensorCore.PaperSpec.zero_bits](../TC/Specification/Rounding.md#decl-6c7995fb8803ab3c)

</details>

</details>

<a id="decl-7127823e49ce5599"></a>

<details>
<summary><code>TensorCore.pow2_add</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L13)

```lean
theorem pow2_add (e f : ℤ) : pow2 (e + f) = pow2 e * pow2 f :=
  Rat.zpow_add (by decide) e f
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../EFT/Machine/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.dyadic_div](../EFT/Machine/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.pow2_common](../EFT/Machine/Round.md#decl-8e9c8ffd317bb724), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../EFT/Machine/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.Format.binade_grid](Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.Format.next_binade_grid](Binary/ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.IEEE.LeanBridge.decreaseExponent_value](../IEEE/LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](../IEEE/LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue64_mul](../IEEE/LeanBridge64.md#decl-4c9ad531b46eeeaa), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../IEEE/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](../IEEE/LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.accumulator_lt_pow2](../TC/StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.div_pow2](Exact.md#decl-341a7e90774bc1d1), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.pow2_div](Exact.md#decl-71bd87700a9fc6ed), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-8f231b6648575120"></a>

<details>
<summary><code>TensorCore.pow2_pos</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L16)

```lean
theorem pow2_pos (e : ℤ) : 0 < pow2 e := Rat.zpow_pos (by decide)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.sign_of_nonzero](Binary/SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.BinaryRep.value_eq_zero_iff](Binary/RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.Decoded.value_ne_zero](../TC/Instruction.md#decl-411ba01d7f55e7d1), [TensorCore.EFMachine.Word.abs_value](../EFT/Machine/Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.range_iff](../EFT/Machine/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.sign_value](../EFT/Machine/Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split_coarse_value](../EFT/Machine/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.value_zero_iff](../EFT/Machine/Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.dyadic_div](../EFT/Machine/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.magnitudeExponent_word](../EFT/Machine/Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../EFT/Machine/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.maxFinite_lt](Binary/ConversionBounds.md#decl-27fef2f17e469434), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](../IEEE/LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../IEEE/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../IEEE/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](../IEEE/LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../IEEE/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](../IEEE/LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../IEEE/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](../IEEE/LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../IEEE/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](../IEEE/LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_eq](../IEEE/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../IEEE/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_eq](../IEEE/LeanBridge64.md#decl-0c708a8abb7275bb), [TensorCore.IEEE.LeanBridge.packRound64_reference](../IEEE/LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.shiftRight_represents](../IEEE/LeanRounding.md#decl-7f6354812c57ad44), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](../IEEE/LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.IEEE.precisionMagnitude_le_max](../IEEE/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](../IEEE/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionMagnitude_positive](../IEEE/Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precisionRound_unique](../IEEE/Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.PaperSpec.raw_value_zero](../TC/Specification/Stages.md#decl-1b686554b9d985d5), [TensorCore.accumulator_lt_pow2](../TC/StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.alignment_static_bound](../TC/StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.binaryConvCoeff_bounds](Binary/ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded_lower](Binary/CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](Binary/CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.coefficient_range_of_grid](Binary/ScalarSum.md#decl-427e226844e8fe51), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.div_pow2](Exact.md#decl-341a7e90774bc1d1), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.gemmConversionModeError_le](../Gemm/RoundingBudget.md#decl-a884460a8acd89fe), [TensorCore.gemmConversionModeError_pos](../Gemm/RoundingBudget.md#decl-56f45d66ad10df52), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.groupBound_le_static](../TC/Program/GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_nonneg](../TC/Program/GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.magnitudeScale_spec](../TC/Program/GroupAnalysis.md#decl-d51d916c1a50ab6d), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.pow2_div](Exact.md#decl-71bd87700a9fc6ed), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_lt_succ](Exact.md#decl-b1dfe79296f2080d), [TensorCore.rawAlignmentBudget_le](../TC/Program/Bounds/Local.md#decl-7c8beacba137af93), [TensorCore.rawAlignmentBudget_nonneg](../TC/Program/Bounds/Local.md#decl-30f7e6c784a8caa3), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawMul_significand_ne_zero](../TC/Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_zero](Binary/RoundingContract.md#decl-765cac64e8b78cf4), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.runBlocks_of_scale_bound](../TC/Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.scalarScale_spec](../Gemm/ScalarAnalysis.md#decl-ab7863fd9c2c72d3), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.staticBudget_positive](../TC/Program/Bounds/Scales.md#decl-52e870bce380a2a2), [TensorCore.term_abs_lt](../TC/StaticBudget.md#decl-eb7aab7cbcc8d87a), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncCoeff_of_grid](Truncation.md#decl-03b847921a9aec6d), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.magnitude_error](../Gemm/ConversionBounds.md#decl-1936078aa7bb5925), [TensorCore.magnitude_error](../Gemm/RoundingBudget.md#decl-31adebb3a0727f59), [TensorCore.PaperSpec.zero_bits](../TC/Specification/Rounding.md#decl-6c7995fb8803ab3c)

</details>

</details>

<a id="decl-997b22af00ef82dd"></a>

<details>
<summary><code>TensorCore.pow2_natCast</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L18)

```lean
theorem pow2_natCast (n : ℕ) : pow2 (n : ℤ) = ((2 ^ n : ℕ) : ℚ) := by
  unfold pow2; rw [Rat.zpow_natCast]; simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../EFT/Machine/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.dyadic_div](../EFT/Machine/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.pow2_common](../EFT/Machine/Round.md#decl-8e9c8ffd317bb724), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../EFT/Machine/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.Format.binade_grid](Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.Format.next_binade_grid](Binary/ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.IEEE.LeanBridge.decreaseExponent_value](../IEEE/LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../IEEE/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.accumulator_lt_pow2](../TC/StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-8feaca6c2e8345f1"></a>

<details>
<summary><code>TensorCore.pow2_one</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L21)

```lean
theorem pow2_one : pow2 1 = 2 := Rat.zpow_one 2
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b)

</details>

</details>

<a id="decl-57be1bea59f2897b"></a>

<details>
<summary><code>TensorCore.pow2_succ</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L23)

```lean
theorem pow2_succ (e : ℤ) : pow2 (e + 1) = pow2 e * 2 := by rw [pow2_add, pow2_one]
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_one](Exact.md#decl-8feaca6c2e8345f1)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shiftRight_represents](../IEEE/LeanRounding.md#decl-7f6354812c57ad44), [TensorCore.binaryCarry_spec](Binary/ConversionBounds.md#decl-9bdec62f2ae623aa), [TensorCore.carry_spec](ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.next_binade_grid](ConversionBounds.md#decl-6e741e2915b593fa), [TensorCore.pow2_lt_succ](Exact.md#decl-b1dfe79296f2080d)

</details>

</details>

<a id="decl-b1dfe79296f2080d"></a>

<details>
<summary><code>TensorCore.pow2_lt_succ</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L25)

```lean
theorem pow2_lt_succ (e : ℤ) : pow2 e < pow2 (e + 1) := by
  rw [pow2_succ]; have := pow2_pos e; grind
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab)

</details>

</details>

<a id="decl-064be6edf8651285"></a>

<details>
<summary><code>TensorCore.pow2_le_of_le</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L29)

```lean
/-- Monotonicity of the binary grid in its exponent. -/
theorem pow2_le_of_le {e f : ℤ} (h : e ≤ f) : pow2 e ≤ pow2 f := by
  have hd : (f - e).toNat = (f - e) := by omega
  have : pow2 f = pow2 e * pow2 ((f - e).toNat : ℤ) := by
    rw [← pow2_add]; congr 1; omega
  rw [this, pow2_natCast]
  have hp := pow2_pos e
  have h1 : (1 : ℚ) ≤ ((2 ^ (f - e).toNat : ℕ) : ℚ) :=
    Rat.natCast_le_natCast.mpr (Nat.one_le_two_pow)
  have := Rat.mul_le_mul_of_nonneg_left h1 (Rat.le_of_lt hp)
  grind
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.PaperSpec.scalarExponent_unique](../Gemm/Specification/ScalarRounding.md#decl-dc1d766095dea794), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_static_bound](../TC/StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.binaryConvExp_bounds](Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.coefficient_range_of_grid](Binary/ScalarSum.md#decl-427e226844e8fe51), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.familyOperandScale_spec](../Gemm/Family.md#decl-82f743426dfee31b), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.groupBound_le_static](../TC/Program/GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.inferGroupWitness_valid](../TC/Program/GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_le_of_lt](Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.magnitudeScale_spec](../TC/Program/GroupAnalysis.md#decl-d51d916c1a50ab6d), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.prepared_static_success](../TC/StaticBudget.md#decl-2a79f971d61c16c9), [TensorCore.rawAlignmentBudget_sound](../TC/Program/Bounds/Local.md#decl-1e83b17fa3bc236b), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.scalarScale_spec](../Gemm/ScalarAnalysis.md#decl-ab7863fd9c2c72d3), [TensorCore.small16_value](../TC/Examples/BoundedDot.md#decl-a57578c06982c772), [TensorCore.term_abs_lt](../TC/StaticBudget.md#decl-eb7aab7cbcc8d87a)

</details>

</details>

<a id="decl-f20062bdc47118bd"></a>

<details>
<summary><code>TensorCore.sumQ</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L40)

```lean
def sumQ : List ℚ → ℚ
  | [] => 0
  | x :: xs => x + sumQ xs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.exactConsolidation](../EFT/Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.retainedSum](../EFT/Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.EFMachine.Prepared.ideal](../EFT/Machine/Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Prepared.ideal_allZero](../EFT/Machine/Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.algorithm1_prepared](../EFT/Machine/Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_unitInputs_success](../EFT/Machine/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.extract_spec](../EFT/Machine/Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](../EFT/Machine/Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_spec](../EFT/Machine/Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.split_sum](../EFT/Machine/Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.EFMachine.sumWords_value](../EFT/Machine/Word.md#decl-c50a82a7014218e4), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](../EFT/ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.ExtractionGrid.recovery](../EFT/ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.retainedSum](../EFT/ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.GemmCell.errorBudget](../Gemm/Defs.md#decl-77bf8f0088e678b8), [TensorCore.LocalAccumulation.loss](../TC/Invocation.md#decl-68d84640e3352f8b), [TensorCore.OrderedPartition.uncorrected_error](../TC/Program/DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.PreparedBlock.exactProducts](../TC/Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.extractReference](../TC/Block.md#decl-6cc810f8061e66a0), [TensorCore.PreparedInvocation.exactProducts](../TC/Invocation.md#decl-f08483de5406c0c5), [TensorCore.Program.recovery](../TC/Program/Defs.md#decl-c675b351c6aa5e02), [TensorCore.Program.repeat_vc_of_cycle](../TC/Program/Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report](../TC/Program/Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](../TC/Program/Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.uncorrected_error](../TC/Program/ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Regression.partition_error_contract](../TC/Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.static_certificate_consistent](../TC/Regression/StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.Regression.symbolic_cycle_vc](../TC/Regression/Programs.md#decl-5719553e703a7aad), [TensorCore.Regression.twoBlockSummary](../TC/Regression/Composition.md#decl-27d6915f955ce3fa), [TensorCore.absQ_sumQ_le](Sum.md#decl-9728c1755d91fb0d), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.accumulator_abs_le_mass](../TC/Program/Bounds/Local.md#decl-97266aac0ec35351), [TensorCore.accumulator_abs_lt](../TC/StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.alignment_static_bound](../TC/StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_residual_identity](../TC/StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.conforms_uncorrected_error](../TC/Instruction.md#decl-89203da1fcc0b32e), [TensorCore.correctedSchedule_correct](../TC/Program/Correction.md#decl-c5490d1a25901294), [TensorCore.encoded_trace_ledger](../TC/Program/Composition.md#decl-775280e15ad44086), [TensorCore.evalBlock_idealProducts](../TC/Program/Defs.md#decl-18057f2f716ca715), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.flowback](../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.fold_residual_ledger](../TC/Program/Composition.md#decl-ff8ab9a0bbbddfad), [TensorCore.groupBound](../TC/Program/GroupAnalysis.md#decl-e75a1094a7fa65e5), [TensorCore.groupBound_le_static](../TC/Program/GroupAnalysis.md#decl-dfb61f21eab0646b), [TensorCore.groupBound_magnitude](../TC/Program/GroupAnalysis.md#decl-8181aa98ef2aa6c9), [TensorCore.groupBound_nonneg](../TC/Program/GroupAnalysis.md#decl-b48fb2a8c56e4563), [TensorCore.idealContributions_flatten](../TC/Program/DotProduct.md#decl-9ddff146f804b161), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.idealProducts_abs_le_of_scale](../TC/Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.idealProducts_append](../TC/Program/DotProduct.md#decl-623f08595b227aca), [TensorCore.idealProducts_of_prepareProducts](../TC/StaticBudget.md#decl-46af87ad95b9feb9), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.matrixAbsSum](../Gemm/Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.matrixAbsSum_bound](../Gemm/Bounds.md#decl-485a6ec947a4e04d), [TensorCore.matrixAbsSum_le_entry_bounds](../Gemm/InputBounds.md#decl-46e7ff540915c07d), [TensorCore.native_zero_products](../Gemm/NativeGemm.md#decl-f24f4761f46023ad), [TensorCore.overlap_eq_retained_sub_outputResidual](../EFT/Extraction.md#decl-fc2dcdeff262fd49), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.productMass](../TC/Program/GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.productMass_nonneg](../TC/Program/GroupAnalysis.md#decl-b18fa7d0371588fa), [TensorCore.recoveredSchedule](../TC/Program/Correction.md#decl-dd85a41a20883c51), [TensorCore.retained_add_low](../EFT/Extraction.md#decl-da77fbfd62ee1185), [TensorCore.runBlocks_corrected_correct](../TC/Program/Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_idealContributions](../TC/Program/Defs.md#decl-a06c7915ecf4c91c), [TensorCore.runBlocks_residual_budget](../TC/Program/ErrorBounds.md#decl-cc967a2bb9a08415), [TensorCore.runBlocks_residual_ledger](../TC/Program/Composition.md#decl-c73efd4921810886), [TensorCore.runBlocks_uncorrected_error](../TC/Program/ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_uncorrected_error](../TC/Program/Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](../TC/Program/Partition.md#decl-4665afff730521a0), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.simulateGemmCell_error](../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.sourceGemmProducts_eq_idealProducts](../Gemm/InputBounds.md#decl-1c676a2d69d32e7d), [TensorCore.sumQ_append](../TC/Program/Loops.md#decl-474827c336526185), [TensorCore.sumQ_map_abs_truncGrid_le](../TC/StaticBudget.md#decl-387c2ed6b8a278d3), [TensorCore.sumQ_map_add](Sum.md#decl-9a866541e41b56c9), [TensorCore.sumQ_map_le](Sum.md#decl-02931053452cdfec), [TensorCore.sumQ_map_lt](Sum.md#decl-5c0b2e6254ce280d), [TensorCore.sumQ_map_mono](../TC/Program/Bounds/Local.md#decl-880c80c3d3f6df2b), [TensorCore.sumQ_map_sub](Sum.md#decl-23e4bf84c54e623b), [TensorCore.sumQ_map_zero](Sum.md#decl-181b288c0a867eb6), [TensorCore.sumQ_repeatList_zero](../TC/Program/Loops.md#decl-1a78835f34f88e04), [TensorCore.sum_coefficients](Exact.md#decl-005e2ad99fe60fa3), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.sum_stage_residuals](../TC/StageResiduals.md#decl-fec712a2169085b5), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.input_sumFn_mono](../Gemm/InputBounds.md#decl-dc26ce7dbc7b97a5), [TensorCore.input_sum_mono](../Gemm/InputBounds.md#decl-da38b637ee97bcc3), [TensorCore.aligned_recovery](../TC/InvocationProperties.md#decl-f6828402db94c42c), [TensorCore.ideal_zero_pairs](../TC/Program/Partition.md#decl-19d8614714352936)

</details>

</details>

<a id="decl-eba77bb372c3b3ff"></a>

<details>
<summary><code>TensorCore.sumZ</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L44)

```lean
def sumZ : List ℤ → ℤ
  | [] => 0
  | x :: xs => x + sumZ xs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.Regression.scalar64_coarse_grid](../EFT/Regression/ScalarEFT.md#decl-71ebab7703c3a1c5), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.evalBlock_machinePrefix](../TC/AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.machineAccumulate_eq](../TC/AccumulatorWidth.md#decl-297efa863148b988), [TensorCore.machineAccumulate_exact](../TC/AccumulatorWidth.md#decl-80c3acbccc8106eb), [TensorCore.machineAccumulate_of_coefficient_bound](../TC/AccumulatorWidth.md#decl-c1bb27c5ce2e7d98), [TensorCore.machineAccumulate_prefix_exact](../TC/AccumulatorWidth.md#decl-9b23fe9fc6ec5adf), [TensorCore.machineAccumulator_eq](../TC/AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.naiveSum64_exact](Binary/ScalarSum.md#decl-d74afdeb99860469), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinary_exact](Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](Binary/ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.naiveSumBinary_exact_perm](Binary/ScalarSum.md#decl-f78af6692d4089d7), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.sumZ_natAbs_le](Sum.md#decl-d8b1b90e2d6e4d96), [TensorCore.sumZ_perm](Sum.md#decl-e7bd85cdcec165e7), [TensorCore.sumZ_replicate](Sum.md#decl-515e106ddee189db), [TensorCore.sum_coefficients](Exact.md#decl-005e2ad99fe60fa3), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-8dd63ab202e070d3"></a>

<details>
<summary><code>TensorCore.absQ</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L48)

```lean
def absQ (x : ℚ) : ℚ := if x < 0 then -x else x
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec.finite](Binary/RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.ConvertedGemmAccurate](../Gemm/ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.CutlassWmma.project_check_sound](../Gemm/Kernels/CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.EFMachine.Word.abs_value](../EFT/Machine/Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.range_iff](../EFT/Machine/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](../EFT/Machine/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.Word.split_low_bound](../EFT/Machine/Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.value_zero_iff](../EFT/Machine/Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.add32WithLean_eq](../EFT/Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../EFT/Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../EFT/Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_range_iff](../EFT/Machine/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../EFT/Machine/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](../EFT/Machine/Success.md#decl-5145abbc51875848), [TensorCore.EntryWithin](../Gemm/EntryFamily.md#decl-e603cd759712ff3e), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.GemmAccurate](../Gemm/Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmInputDatum.error](../Gemm/InputBounds.md#decl-8d5afe3c429da546), [TensorCore.IEEE.IntegerRound](../IEEE/Precision.md#decl-c1146843cf5e28a6), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../IEEE/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](../IEEE/LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../IEEE/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](../IEEE/LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](../IEEE/LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](../IEEE/LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../IEEE/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](../IEEE/LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../IEEE/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](../IEEE/LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../IEEE/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](../IEEE/LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](../IEEE/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](../IEEE/LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](../IEEE/LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.RoundSpec](../IEEE/Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.addWithLean](../IEEE/NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_eq](../IEEE/NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.addWithLean_native](../IEEE/NativeOperations.md#decl-fd6a11fc2eaba885), [TensorCore.IEEE.coefficient_correct](../IEEE/Precision.md#decl-9de0c69639190f6d), [TensorCore.IEEE.convert_self_finite](../IEEE/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.finiteBits](../IEEE/Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](../IEEE/Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](../IEEE/Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.inRangeResult32](../IEEE/NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.inRangeResult32_eq](../IEEE/NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64](../IEEE/NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](../IEEE/NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.integerRound_unique](../IEEE/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.mulWithLean](../IEEE/NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_eq](../IEEE/NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mulWithLean_native](../IEEE/NativeOperations.md#decl-fbd7d0b915acb4bd), [TensorCore.IEEE.nativeAddResult32_eq](../IEEE/NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64_eq](../IEEE/NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32_eq](../IEEE/NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64_eq](../IEEE/NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32_eq](../IEEE/NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](../IEEE/NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.precision_ceil_all](../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.round](../IEEE/Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](../IEEE/Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](../IEEE/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](../IEEE/Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](../IEEE/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](../IEEE/Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](../IEEE/Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](../IEEE/Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.subWithLean](../IEEE/NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_eq](../IEEE/NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.subWithLean_native](../IEEE/NativeOperations.md#decl-7f93d5f56de6f401), [TensorCore.MatrixWithin](../Gemm/Family.md#decl-71221945e17a1cdc), [TensorCore.NativeConvertedGemmAccurate](../Gemm/NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmAccurate](../Gemm/NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NearestEven](Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.NearestEven32](RoundOp.md#decl-e8aa71a6813779de), [TensorCore.OrderedPartition.uncorrected_error](../TC/Program/DotProduct.md#decl-ad212c5eb40bffac), [TensorCore.PaperSpec.ScalarContract](../Gemm/Specification/GemmComposition.md#decl-c38284ec00ab1c53), [TensorCore.PaperSpec.conversionStage_bits_eq](../Gemm/Specification/ScaledGemmEquivalence.md#decl-13632aec059d0b49), [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](../Gemm/Specification/GemmComposition.md#decl-463c7ce44999fc94), [TensorCore.PaperSpec.magnitude_eq](../TC/Specification/Rounding.md#decl-324135f1be845e5f), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.scalarGridValue_eq](../Gemm/Specification/ScalarRounding.md#decl-b4fe8f74d8aee01a), [TensorCore.PaperSpec.scalarResult_of_roundBinary](../Gemm/Specification/ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalar_contract](../Gemm/Specification/GemmComposition.md#decl-c67acc89e63ba8f4), [TensorCore.PaperSpec.valid_iff](../TC/Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.Program.Accurate](../TC/Program/CertifiedProgram.md#decl-5a5f6971912cfb9a), [TensorCore.Program.VC](../TC/Program/Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.accurate_of_run](../TC/Program/CertifiedProgram.md#decl-77e10634842ecb7f), [TensorCore.Program.accurate_of_scales](../TC/Program/Bounds/Loops.md#decl-1a60f53bc1fc3642), [TensorCore.Program.repeat_accurate_of_scales](../TC/Program/Bounds/Loops.md#decl-428a5fa42c1f272b), [TensorCore.Program.repeat_vc_of_cycle](../TC/Program/Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report](../TC/Program/Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](../TC/Program/Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.staticCertificate_sound](../TC/Program/CertifiedProgram.md#decl-c46da972b4dd783a), [TensorCore.Program.uncorrected_error](../TC/Program/ErrorBounds.md#decl-eb2ba0b8cf65050e), [TensorCore.Program.vc_sound](../TC/Program/Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](../Gemm/Regression/ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.family_member](../Gemm/Regression/ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.native_error_value](../Gemm/Regression/ReviewClaims.md#decl-8619ffd6d743c4c4), [TensorCore.Regression.ReviewClaims.positive_error_separates_models](../Gemm/Regression/ReviewClaims.md#decl-503df615928e2452), [TensorCore.Regression.ReviewClaims.second_family_member](../Gemm/Regression/ReviewClaims.md#decl-d565737a82ea57ef), [TensorCore.Regression.bf16_rounding_correct](../TC/Regression/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.certified_tiny](../Gemm/Regression/GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.directed_unusual_format](../TC/Regression/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.eq20_public_accepts](../Regression/FoundationCompletion.md#decl-b1321756db80e3f1), [TensorCore.Regression.eq20_signed_budget](../Regression/FoundationCompletion.md#decl-0598e4ed93ef2381), [TensorCore.Regression.family_membership_signed_subnormal](../Gemm/Regression/GemmFamily.md#decl-a3201c4c5fa5173c), [TensorCore.Regression.final_range_rejected](../TC/Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.fp16_rounding_correct](../TC/Regression/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp32_generic_agrees](../TC/Regression/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.fp64_rounding_correct](../TC/Regression/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.negative_subnormal_lower_contract](../TC/Regression/DirectedBinary.md#decl-6ef36ec120fedf99), [TensorCore.Regression.negative_subnormal_upper_contract](../TC/Regression/DirectedBinary.md#decl-7cbd49d6e0ce38c4), [TensorCore.Regression.nonfinite_initial_rejected](../TC/Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.paper_source_certificate](../Gemm/Regression/GemmSpecification.md#decl-718309cb9b0ed958), [TensorCore.Regression.partition_error_contract](../TC/Regression/DotProduct.md#decl-ab9940b7024825ae), [TensorCore.Regression.r4_midpoint_distances](../TC/Regression/Composition.md#decl-7fa1f7d6ed299760), [TensorCore.Regression.rejected_program_vc](../TC/Regression/Programs.md#decl-06af08619320969d), [TensorCore.Regression.scalar_bitSpan_budget](../EFT/Regression/ScalarEFT.md#decl-4f8ed7cf41298ebe), [TensorCore.Regression.source_input_loss_matters](../Gemm/Regression/GemmInputConversion.md#decl-665a3e346fe5111f), [TensorCore.Regression.static_certificate_applied](../TC/Regression/StaticBudget.md#decl-0a3d92d955e4909d), [TensorCore.Regression.static_certificate_consistent](../TC/Regression/StaticBudget.md#decl-00b62b8ddc7d4024), [TensorCore.Regression.subnormal_cross_term](../Gemm/Regression/GemmInputConversion.md#decl-cea5bdaa327d80b0), [TensorCore.Regression.symbolic_changing_loop](../TC/Regression/Application.md#decl-d4a47d36d3054d89), [TensorCore.Regression.symbolic_cycle_vc](../TC/Regression/Programs.md#decl-5719553e703a7aad), [TensorCore.Regression.tf19_rounding_correct](../TC/Regression/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.ScaledGemmCell.errorBudget](../Gemm/ScaledGemm.md#decl-4b85a5b450b169a8), [TensorCore.ScaledGemmCell.propagate](../Gemm/ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.ScaledGemmCell.scalarError](../Gemm/ScaledGemm.md#decl-5bb52d0e23c81596), [TensorCore.TowardZero](Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ_add_le](Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_intCast](Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_le_iff](Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_lt_iff](Exact.md#decl-33f2b1d708f79f21), [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_nonneg](Exact.md#decl-137ea017d6c4d0cd), [TensorCore.absQ_of_neg](Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.absQ_sub_comm](Exact.md#decl-a632fad01d9c884a), [TensorCore.absQ_sumQ_le](Sum.md#decl-9728c1755d91fb0d), [TensorCore.accumulator_abs_le_mass](../TC/Program/Bounds/Local.md#decl-97266aac0ec35351), [TensorCore.accumulator_abs_lt](../TC/StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.accumulator_lt_pow2](../TC/StaticBudget.md#decl-690ecb505bab83f2), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual](Truncation.md#decl-8fb54cfc251e7721), [TensorCore.alignment_static_bound](../TC/StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.analyzeConvertedGemm_checked](../Gemm/ConvertedGemmAnalysis.md#decl-3e25466cb1f5da5e), [TensorCore.analyzeConvertedGemm_matrix_error](../Gemm/ConvertedGemmAnalysis.md#decl-ed9b066ca6295243), [TensorCore.analyzeGemmCell](../Gemm/Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](../Gemm/Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeGemm_entry_sound](../Gemm/Analysis.md#decl-6787ae59a9d8b991), [TensorCore.analyzeGemm_matrix_error](../Gemm/Analysis.md#decl-055cab5838c28c64), [TensorCore.analyzeNativeCell](../Gemm/NativeGemm.md#decl-75268401e2373f4a), [TensorCore.analyzeNativeCell_checked](../Gemm/NativeGemm.md#decl-6973598426e420da), [TensorCore.analyzeNativeCell_complete](../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.analyzeNativeConvertedGemm_checked](../Gemm/NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](../Gemm/NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.analyzeNativeGemm_entry_sound](../Gemm/NativeGemm.md#decl-3cd7435d85d547ee), [TensorCore.analyzeNativeGemm_matrix_error](../Gemm/NativeGemm.md#decl-8f01a47ceaac6ebd), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binarySignedRounded](Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](Binary/DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](Binary/DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](Binary/CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.boundedDotCheck](../TC/Examples/BoundedDot.md#decl-ec759e24e02a72b7), [TensorCore.boundedDotCheck_sound](../TC/Examples/BoundedDot.md#decl-bee6a2a1f0c3f285), [TensorCore.boundedDot_accurate](../TC/Examples/BoundedDot.md#decl-5f4a54e532e0f3b9), [TensorCore.boundedDot_accurate_of_bits](../TC/Examples/BoundedDot.md#decl-feec6cddd4e6942c), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.canonical_padding_success_iff](../TC/Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_success_iff](../TC/Padding.md#decl-ca6987fa7885e6c2), [TensorCore.checkConvertedCell](../Gemm/ConvertedGemmAnalysis.md#decl-f8060bc8fd76f1ba), [TensorCore.checkConvertedCell_sound](../Gemm/ConvertedGemmAnalysis.md#decl-aacb76261a0f16bf), [TensorCore.checkEpilogue](../Gemm/ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](../Gemm/ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteAdd_sound](../Gemm/ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkFiniteMultiply](../Gemm/ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkFiniteMultiply_sound](../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkGemmCell](../Gemm/Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkGroups_sound](../TC/Program/GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkNativeCell](../Gemm/NativeGemm.md#decl-9b50e2e7318616a8), [TensorCore.checkNativeCell_sound](../Gemm/NativeGemm.md#decl-3d33153bf5b5dc40), [TensorCore.checkNativeConvertedCell](../Gemm/NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](../Gemm/NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.checkNativeScaledCell_inputConversion](../Gemm/NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkNativeScaledCell_sound](../Gemm/NativeScaledGemm.md#decl-1e3769740c5dad78), [TensorCore.checkOutput_sound](../Gemm/ScalarAnalysis.md#decl-f783bada48aebde4), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.checkScaledCell_inputConversion](../Gemm/ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.checkScaledCell_sound](../Gemm/ScaledGemmAnalysis.md#decl-4ba652d62c50104f), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.conforms_uncorrected_error](../TC/Instruction.md#decl-89203da1fcc0b32e), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.conversion_exact_value](../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.convertGemmInput_products_error](../Gemm/InputBounds.md#decl-16fc2b35730daa25), [TensorCore.convertGemmInput_products_tight_error](../Gemm/TightInputBounds.md#decl-b437c54d5d208f5c), [TensorCore.convertNativeInput_products_error](../Gemm/NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.convertedAnalysisCheck_matrix_error](../Gemm/ConvertedGemmAnalysis.md#decl-1df5f7ac9d761951), [TensorCore.convertedAnalysisCheck_paper](../Gemm/ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.convertedAnalysisCheck_sound](../Gemm/ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.convertedGemmCellSourceError](../Gemm/InputBounds.md#decl-c6688c492e9e6923), [TensorCore.convertedGemmCellTightSourceError](../Gemm/TightInputBounds.md#decl-c868505bc89fc75a), [TensorCore.convertedGemmCheck_sound](../Gemm/ScaledGemmBounds.md#decl-2517f6508460b33a), [TensorCore.convertedGemmCheck_source_sound](../Gemm/InputBounds.md#decl-82c7f6139915a514), [TensorCore.convertedGemmCheck_tight_sound](../Gemm/TightBounds.md#decl-bda461b71c4f083d), [TensorCore.convertedGemmCheck_tight_source_sound](../Gemm/TightInputBounds.md#decl-c7ecc23878e71c58), [TensorCore.convertedGemmSourceCertificate_matrix_error](../Gemm/InputBounds.md#decl-7954eea10de74384), [TensorCore.convertedGemmSourceCertificate_sound](../Gemm/InputBounds.md#decl-07b8c70e183a7fd6), [TensorCore.convertedGemmTightSourceCertificate_matrix_error](../Gemm/TightInputBounds.md#decl-e90fa532540a8a09), [TensorCore.convertedGemmTightSourceCertificate_sound](../Gemm/TightInputBounds.md#decl-9670e739c545855d), [TensorCore.correctedSchedule_correct](../TC/Program/Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](../TC/Program/Correction.md#decl-ee6543cdd6791a37), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.decoded_zero_bounded](FormatProperties.md#decl-552117025e86e0df), [TensorCore.dist_scale](Rounding.md#decl-b773da87e31ab58f), [TensorCore.entryFamilyCheck_matrix_error](../Gemm/EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamily_cell_sound](../Gemm/EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.evalBlock_corrected_correct](../TC/Program/Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_residual_bound](../TC/Program/ErrorBounds.md#decl-74198f50c769d497), [TensorCore.evalBlock_static](../TC/StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.evalBlock_success_iff](../TC/AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.familyCheck_matrix_error](../Gemm/Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](../Gemm/Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions_gemmCheck](../Gemm/Family.md#decl-56c849a6d64aa7bf), [TensorCore.family_pair_scale](../Gemm/Family.md#decl-797e6af7a549f294), [TensorCore.finalRound_correct](CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.gemmAbs_mul](../Gemm/ScaledGemm.md#decl-be05cc60206155ae), [TensorCore.gemmAnalysisCheck_matrix_error](../Gemm/Analysis.md#decl-099e6418fcc0de51), [TensorCore.gemmAnalysisCheck_paper](../Gemm/Analysis.md#decl-7b3d3dd3b1859d7d), [TensorCore.gemmAnalysisCheck_sound](../Gemm/Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.gemmCellCheck](../Gemm/Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmCheck_matrix_error](../Gemm/Bounds.md#decl-fdf1144ac6e97ba3), [TensorCore.gemmCheck_sound](../Gemm/Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmConversion_correct](../Gemm/ScaledGemm.md#decl-e58a1d25b374dba1), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.gemmConversion_total](../Gemm/ConversionBounds.md#decl-e4112c653555bb26), [TensorCore.gemmInputDatum_error_le](../Gemm/InputBounds.md#decl-6e5aac7e5b718d88), [TensorCore.gemmInputPairError](../Gemm/InputBounds.md#decl-85a247fb58310475), [TensorCore.gemmInputPairError_bound](../Gemm/InputBounds.md#decl-0b206d7ac67403b7), [TensorCore.gemmInputPairTightError](../Gemm/TightInputBounds.md#decl-1a5881f86db47f83), [TensorCore.gemmInputPairTightError_bound](../Gemm/TightInputBounds.md#decl-251c676d4c121cd6), [TensorCore.gemmInputPairTightError_le](../Gemm/TightInputBounds.md#decl-8ffbd0992c010ee1), [TensorCore.gemmInputProductError_bound](../Gemm/InputBounds.md#decl-5c6d092f063552e4), [TensorCore.gemmInputProductTightError_bound](../Gemm/TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.gemmSourceError_propagate](../Gemm/InputBounds.md#decl-7a3b7a6efc84a1d7), [TensorCore.gemm_entry_error](../Gemm/Defs.md#decl-ca7357044cdac1e9), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.idealContributions_abs_le](../TC/Program/Bounds/Scales.md#decl-d642c7a05f1cb663), [TensorCore.idealProducts_abs_le_of_scale](../TC/Program/Bounds/Scales.md#decl-8ac3fa4265b04b8a), [TensorCore.inferEpilogue](../Gemm/ScaledGemmAnalysis.md#decl-c09f0572310ed572), [TensorCore.inputProductErrorTo_bound](../Gemm/MatrixConversion.md#decl-b9c5e5986779238b), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.matrixAbsSum](../Gemm/Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.matrixAbsSum_bound](../Gemm/Bounds.md#decl-485a6ec947a4e04d), [TensorCore.matrixAbsSum_le_entry_bounds](../Gemm/InputBounds.md#decl-46e7ff540915c07d), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](Binary/ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.nativeAnalysisCheck_sound](../Gemm/NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeConvertedAnalysisCheck_matrix_error](../Gemm/NativeConvertedAnalysis.md#decl-4bdd23a2e2a4ea33), [TensorCore.nativeConvertedAnalysisCheck_paper](../Gemm/NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa), [TensorCore.nativeConvertedAnalysisCheck_sound](../Gemm/NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeSourceAnalysisCell](../Gemm/NativeConvertedAnalysis.md#decl-1fde80241417645a), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.partialSumsCheck](../TC/Program/StaticCertificate.md#decl-3830663114f133c4), [TensorCore.partialSumsCheck_sound](../TC/Program/StaticCertificate.md#decl-df9e82cd1ad7c2d7), [TensorCore.prepared_static_success](../TC/StaticBudget.md#decl-2a79f971d61c16c9), [TensorCore.productMass](../TC/Program/GroupAnalysis.md#decl-be16bcf976708cd5), [TensorCore.productMass_nonneg](../TC/Program/GroupAnalysis.md#decl-b18fa7d0371588fa), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.rawAlignmentBudget_sound](../TC/Program/Bounds/Local.md#decl-1e83b17fa3bc236b), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rneInt_dist_le_half](Rounding.md#decl-926c4e219d946918), [TensorCore.rneInt_nearest](Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_tie_even](Rounding.md#decl-b3bf5bfe6d222ec7), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_grid_nearest_q](Binary/CorrectRounding.md#decl-ca751f6fe596d9e8), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.round32_rtz_abs_le](../TC/Program/Bounds/Local.md#decl-b5d2bbed636879a7), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_correct](Binary/RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_exact_of_finite](Binary/ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_isSome_iff](Binary/RoundingContract.md#decl-9083817d3e897973), [TensorCore.roundBinary_nearestEven_correct](Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](Binary/RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](Binary/RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](Binary/DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](Binary/DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](Binary/RoundingContract.md#decl-765cac64e8b78cf4), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.runBlocks_corrected_correct](../TC/Program/Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_of_scale_bound](../TC/Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_residual_budget](../TC/Program/ErrorBounds.md#decl-cc967a2bb9a08415), [TensorCore.runBlocks_static](../TC/StaticBudget.md#decl-31af1b208da9e431), [TensorCore.runBlocks_uncorrected_error](../TC/Program/ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_uncorrected_error](../TC/Program/Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](../TC/Program/Partition.md#decl-4665afff730521a0), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.scaledGemmCellCheck](../Gemm/ScaledGemmBounds.md#decl-50cf72a6b5586bc4), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.scaledGemmCheck_matrix_error](../Gemm/ScaledGemmBounds.md#decl-7addf1d7932b65bf), [TensorCore.scaledGemmCheck_sound](../Gemm/ScaledGemmBounds.md#decl-e5b7bcea73549f4d), [TensorCore.scaledGemmCheck_tight_matrix_error](../Gemm/TightBounds.md#decl-b6171e34311f79ed), [TensorCore.scaledGemmCheck_tight_sound](../Gemm/TightBounds.md#decl-9356e64e4f80c510), [TensorCore.scaledGemmStaticError](../Gemm/ScaledGemmBounds.md#decl-8510b7f8fc18dc85), [TensorCore.scaledGemmTightError](../Gemm/TightBounds.md#decl-4ac591737d634082), [TensorCore.scaledGemmTightError_le](../Gemm/TightBounds.md#decl-75e41d5600ed7daf), [TensorCore.scaledGemm_entry_error](../Gemm/ScaledGemm.md#decl-41d7005d3d150b02), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.simulateGemmCell_error](../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.small16_value](../TC/Examples/BoundedDot.md#decl-a57578c06982c772), [TensorCore.small_repeat_accurate](../TC/Examples/BoundedDot.md#decl-13ea2e2e9f51acd8), [TensorCore.sourceAnalysisCell](../Gemm/ConvertedGemmAnalysis.md#decl-9df6da962c5020b7), [TensorCore.staticCheck_sound](../TC/Program/StaticCertificate.md#decl-d9cfd7eeec01ec69), [TensorCore.sumQ_map_abs_truncGrid_le](../TC/StaticBudget.md#decl-387c2ed6b8a278d3), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.term_abs_lt](../TC/StaticBudget.md#decl-eb7aab7cbcc8d87a), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.EFMachine.unit_product](../EFT/Machine/Success.md#decl-895d5a87632fe65b), [TensorCore.coefficient_error](../Gemm/ConversionBounds.md#decl-f64f69d45bdd3bc3), [TensorCore.magnitude_error](../Gemm/ConversionBounds.md#decl-1936078aa7bb5925), [TensorCore.signed_error](../Gemm/ConversionBounds.md#decl-5a8644e3b68e60af), [TensorCore.Regression.ReviewClaims.within_of_checks](../Gemm/Regression/ReviewClaims.md#decl-1c7e1d8a6330eda3), [TensorCore.coefficient_error](../Gemm/RoundingBudget.md#decl-f755f2a49fffbd90), [TensorCore.magnitude_error](../Gemm/RoundingBudget.md#decl-31adebb3a0727f59), [TensorCore.signed_error](../Gemm/RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-137ea017d6c4d0cd"></a>

<details>
<summary><code>TensorCore.absQ_nonneg</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L50)

```lean
theorem absQ_nonneg (x : ℚ) : 0 ≤ absQ x := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.round_correct](../IEEE/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_overflow_iff](../IEEE/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.ScaledGemmCell.propagate](../Gemm/ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.analyzeGemmCell_complete](../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell_complete](../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.checkFiniteMultiply_sound](../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.gemmInputPairTightError_le](../Gemm/TightInputBounds.md#decl-8ffbd0992c010ee1), [TensorCore.gemmSourceError_propagate](../Gemm/InputBounds.md#decl-7a3b7a6efc84a1d7), [TensorCore.productMass_nonneg](../TC/Program/GroupAnalysis.md#decl-b18fa7d0371588fa), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.roundBinary_nearestEven_correct](Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf)

</details>

</details>

<a id="decl-3513a75c8e3035b2"></a>

<details>
<summary><code>TensorCore.absQ_le_iff</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L51)

```lean
theorem absQ_le_iff (x c : ℚ) : absQ x ≤ c ↔ -c ≤ x ∧ x ≤ c := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.integerRound_unique](../IEEE/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.precision_ceil_all](../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.absQ_add_le](Exact.md#decl-5c1117bc0bcece80), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.checkFiniteAdd_sound](../Gemm/ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.conversion_exact_value](../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.matrixAbsSum_le_entry_bounds](../Gemm/InputBounds.md#decl-46e7ff540915c07d), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.roundBinary_exact_of_finite](Binary/ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.EFMachine.unit_product](../EFT/Machine/Success.md#decl-895d5a87632fe65b), [TensorCore.coefficient_error](../Gemm/ConversionBounds.md#decl-f64f69d45bdd3bc3), [TensorCore.coefficient_error](../Gemm/RoundingBudget.md#decl-f755f2a49fffbd90)

</details>

</details>

<a id="decl-33f2b1d708f79f21"></a>

<details>
<summary><code>TensorCore.absQ_lt_iff</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L52)

```lean
theorem absQ_lt_iff (x c : ℚ) : absQ x < c ↔ -c < x ∧ x < c := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5fcbb1ea121d8a53"></a>

<details>
<summary><code>TensorCore.absQ_neg</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L53)

```lean
theorem absQ_neg (x : ℚ) : absQ (-x) = absQ x := by unfold absQ; split <;> split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.abs_value](../EFT/Machine/Round.md#decl-5922e66553898d4e), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../IEEE/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](../IEEE/LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../IEEE/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](../IEEE/LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](../IEEE/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](../IEEE/LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.checkFiniteMultiply_sound](../Gemm/ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.gemmAbs_mul](../Gemm/ScaledGemm.md#decl-be05cc60206155ae), [TensorCore.gemmInputPairError_bound](../Gemm/InputBounds.md#decl-0b206d7ac67403b7), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.signed_error](../Gemm/ConversionBounds.md#decl-5a8644e3b68e60af), [TensorCore.signed_error](../Gemm/RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-a632fad01d9c884a"></a>

<details>
<summary><code>TensorCore.absQ_sub_comm</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L54)

```lean
theorem absQ_sub_comm (x y : ℚ) : absQ (x - y) = absQ (y - x) := by
  unfold absQ; split <;> split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.gemmCellCheck_product_bound](../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmInputPairTightError_le](../Gemm/TightInputBounds.md#decl-8ffbd0992c010ee1), [TensorCore.runBlocks_static](../TC/StaticBudget.md#decl-31af1b208da9e431)

</details>

</details>

<a id="decl-5608efce37c35b7f"></a>

<details>
<summary><code>TensorCore.absQ_mul_pos</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L56)

```lean
theorem absQ_mul_pos (x q : ℚ) (hq : 0 < q) : absQ (x * q) = absQ x * q := by
  unfold absQ
  by_cases hx : x < 0
  · have : x * q < 0 := by
      have := Rat.mul_lt_mul_of_pos_right hx hq; simpa using this
    simp [hx, this]; grind
  · have hx' : 0 ≤ x := by grind
    have : ¬ (x * q < 0) := by
      have := Rat.mul_nonneg hx' (Rat.le_of_lt hq); grind
    simp [hx, this]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.dist_scale](Rounding.md#decl-b773da87e31ab58f), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.gemmAbs_mul](../Gemm/ScaledGemm.md#decl-be05cc60206155ae), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.magnitude_error](../Gemm/ConversionBounds.md#decl-1936078aa7bb5925), [TensorCore.magnitude_error](../Gemm/RoundingBudget.md#decl-31adebb3a0727f59)

</details>

</details>

<a id="decl-2aceea0008eec277"></a>

<details>
<summary><code>TensorCore.absQ_of_nonneg</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L66)

```lean
theorem absQ_of_nonneg {x : ℚ} (h : 0 ≤ x) : absQ x = x := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.abs_value](../EFT/Machine/Round.md#decl-5922e66553898d4e), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../IEEE/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](../IEEE/LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../IEEE/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](../IEEE/LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](../IEEE/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](../IEEE/LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](Binary/DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](Binary/DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.conversion_exact_value](../Gemm/ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.finite32_scale_le](../TC/StaticBudget.md#decl-b23246c067dbeca7), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.signed_error](../Gemm/ConversionBounds.md#decl-5a8644e3b68e60af), [TensorCore.signed_error](../Gemm/RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-3279b57bfb1b8206"></a>

<details>
<summary><code>TensorCore.absQ_of_neg</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L67)

```lean
theorem absQ_of_neg {x : ℚ} (h : x < 0) : absQ x = -x := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](Binary/DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](Binary/DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.signed_error](../Gemm/ConversionBounds.md#decl-5a8644e3b68e60af), [TensorCore.signed_error](../Gemm/RoundingBudget.md#decl-05aed2e9019958e7)

</details>

</details>

<a id="decl-282a0db962f1b274"></a>

<details>
<summary><code>TensorCore.truncCoeff</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L70)

```lean
/-- Signed magnitude truncation. Division is applied to a nonnegative magnitude. -/
def truncCoeff (x : ℚ) (e : ℤ) : ℤ :=
  if x < 0 then -((-x / pow2 e).floor) else (x / pow2 e).floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../EFT/Machine/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../EFT/Machine/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.coefficient_eq](../TC/Specification/Stages.md#decl-2eed3165d7f83748), [TensorCore.PreparedBlock.coefficients](../TC/Block.md#decl-c0369f010f61825c), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.alignment_value](Truncation.md#decl-4fd20c57624d75c8), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](../TC/Block.md#decl-8e67b4eed923de99), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.prepare_coefficient_capacity](../TC/AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepared_coefficient_bound](../TC/AlignmentScale.md#decl-929725522df30cf8), [TensorCore.rawAlignmentBudget_sound](../TC/Program/Bounds/Local.md#decl-1e83b17fa3bc236b), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncCoeff_nonneg_eq](Truncation.md#decl-a3484604d19e0df2), [TensorCore.truncCoeff_of_grid](Truncation.md#decl-03b847921a9aec6d), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.truncGrid_zero](Truncation.md#decl-c8fd94be6ed59920), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-104d085b38c6a29b"></a>

<details>
<summary><code>TensorCore.truncGrid</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L73)

```lean
def truncGrid (x : ℚ) (e : ℤ) : ℚ := (truncCoeff x e : ℚ) * pow2 e
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.coarse](../EFT/Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.lowParts](../EFT/Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.retainedLowParts](../EFT/Defs.md#decl-9ea2d33eab35e3e8), [TensorCore.EFMachine.Word.split_coarse_value](../EFT/Machine/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low_bound](../EFT/Machine/Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_low_value](../EFT/Machine/Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.extract_component](../EFT/Machine/Extraction.md#decl-f7b97097f702b90a), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../EFT/Machine/Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low_residual](../EFT/Machine/Split.md#decl-6d6fe2bc592a6791), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coarse](../EFT/ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.retainedLowParts](../EFT/ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.PreparedBlock.alignmentResiduals](../TC/Block.md#decl-36e297929b24e234), [TensorCore.Regression.EFMachine.negative_residual](../EFT/Regression/MachineSplit.md#decl-f12f3766824311d7), [TensorCore.Regression.r4_signed_truncation](../TC/Regression/Cases.md#decl-055774464a138a7b), [TensorCore.accumulatorShift](../TC/Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.accumulatorShift_of_exact](../TC/Flowback.md#decl-d93ce2ab3174723d), [TensorCore.accumulator_abs_le_mass](../TC/Program/Bounds/Local.md#decl-97266aac0ec35351), [TensorCore.accumulator_abs_lt](../TC/StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.alignment_residual](Truncation.md#decl-8fb54cfc251e7721), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.alignment_static_bound](../TC/StaticBudget.md#decl-dc1f3c9c25d3691b), [TensorCore.alignment_value](Truncation.md#decl-4fd20c57624d75c8), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_residual_identity](../TC/StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.flowback](../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.rawAlignmentBudget](../TC/Program/Bounds/Local.md#decl-a4306ef04c6063f5), [TensorCore.rawAlignmentBudget_le](../TC/Program/Bounds/Local.md#decl-7c8beacba137af93), [TensorCore.rawAlignmentBudget_nonneg](../TC/Program/Bounds/Local.md#decl-30f7e6c784a8caa3), [TensorCore.rawAlignmentBudget_sound](../TC/Program/Bounds/Local.md#decl-1e83b17fa3bc236b), [TensorCore.rawAlignmentBudget_zero](../TC/Program/Bounds/Local.md#decl-16ff676e03bc4bb1), [TensorCore.round32_rtz_abs_le](../TC/Program/Bounds/Local.md#decl-b5d2bbed636879a7), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.sumQ_map_abs_truncGrid_le](../TC/StaticBudget.md#decl-387c2ed6b8a278d3), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_exact_of_grid](Truncation.md#decl-8a6ed0cd1522f575), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.truncGrid_zero](Truncation.md#decl-c8fd94be6ed59920)

</details>

</details>

<a id="decl-005e2ad99fe60fa3"></a>

<details>
<summary><code>TensorCore.sum_coefficients</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L75)

```lean
theorem sum_coefficients (zs : List ℤ) (q : ℚ) :
    sumQ (zs.map fun (z : ℤ) => (z : ℚ) * q) = (sumZ zs : ℚ) * q := by
  induction zs with
  | nil => simp [sumQ, sumZ]
  | cons z zs ih => simp [sumQ, sumZ, ih, Rat.add_mul]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](Exact.md#decl-f20062bdc47118bd), [TensorCore.sumZ](Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d)

</details>

</details>

<a id="decl-ac9c8646649b0ae0"></a>

<details>
<summary><code>TensorCore.pow2_zero</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L81)

```lean
theorem pow2_zero : pow2 0 = 1 := by simp [pow2]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.div_pow2](Exact.md#decl-341a7e90774bc1d1), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4)

</details>

</details>

<a id="decl-71bd87700a9fc6ed"></a>

<details>
<summary><code>TensorCore.pow2_div</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L83)

```lean
theorem pow2_div (a b : ℤ) : pow2 a / pow2 b = pow2 (a - b) := by
  have h : pow2 a = pow2 (a - b) * pow2 b := by
    rw [← pow2_add]; congr 1; omega
  rw [h, Rat.mul_div_cancel (Rat.ne_of_gt (pow2_pos b))]
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04)

</details>

</details>

<a id="decl-341a7e90774bc1d1"></a>

<details>
<summary><code>TensorCore.div_pow2</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L88)

```lean
theorem div_pow2 (x : ℚ) (e : ℤ) : x / pow2 e = x * pow2 (-e) := by
  have h1 : pow2 (-e) * pow2 e = 1 := by
    rw [← pow2_add]
    have : -e + e = 0 := by omega
    rw [this, pow2_zero]
  have hne := Rat.ne_of_gt (pow2_pos e)
  calc x / pow2 e = x * pow2 (-e) * pow2 e / pow2 e := by rw [Rat.mul_assoc, h1, Rat.mul_one]
    _ = x * pow2 (-e) := Rat.mul_div_cancel hne
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.pow2_zero](Exact.md#decl-ac9c8646649b0ae0)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4)

</details>

</details>

<a id="decl-67bd25479bf5fb7a"></a>

<details>
<summary><code>TensorCore.div_nonneg_of_pos</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L97)

```lean
theorem div_nonneg_of_pos (x q : ℚ) (hx : 0 ≤ x) (hq : 0 < q) : 0 ≤ x / q := by
  rw [Rat.div_def]
  exact Rat.mul_nonneg hx (Rat.le_of_lt (Rat.inv_pos.mpr hq))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf)

</details>

</details>

<a id="decl-020e94a8d8a6259e"></a>

<details>
<summary><code>TensorCore.le_div_of_mul_le</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L101)

```lean
theorem le_div_of_mul_le (a y q : ℚ) (hq : 0 < q) (h : a * q ≤ y) : a ≤ y / q := by
  have hinv := Rat.le_of_lt (Rat.inv_pos.mpr hq)
  have := Rat.mul_le_mul_of_nonneg_right h hinv
  rw [Rat.mul_assoc, Rat.mul_inv_cancel q (Rat.ne_of_gt hq), Rat.mul_one, ← Rat.div_def] at this
  exact this
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shiftRightOne_represents](../IEEE/LeanRounding.md#decl-8be2298798509a20), [TensorCore.IEEE.precisionMagnitude_lower](../IEEE/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precision_floor_all](../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.binaryMagnitudeRounded_lower](Binary/CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91)

</details>

</details>

<a id="decl-c05af5c54a1fa836"></a>

<details>
<summary><code>TensorCore.div_le_div_of_le_right</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L107)

```lean
theorem div_le_div_of_le_right (x y q : ℚ) (hq : 0 < q) (h : x ≤ y) : x / q ≤ y / q := by
  rw [Rat.div_def, Rat.div_def]
  exact Rat.mul_le_mul_of_nonneg_right h (Rat.le_of_lt (Rat.inv_pos.mpr hq))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91)

</details>

</details>

<a id="decl-5c1117bc0bcece80"></a>

<details>
<summary><code>TensorCore.absQ_add_le</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L111)

```lean
theorem absQ_add_le (x y : ℚ) : absQ (x + y) ≤ absQ x + absQ y := by
  have hx := (absQ_le_iff x (absQ x)).mp Rat.le_refl
  have hy := (absQ_le_iff y (absQ y)).mp Rat.le_refl
  apply (absQ_le_iff _ _).mpr
  constructor <;> grind
```

**Supporting proofs:** [TensorCore.absQ_le_iff](Exact.md#decl-3513a75c8e3035b2)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_unitInputs_success](../EFT/Machine/Success.md#decl-5145abbc51875848), [TensorCore.ScaledGemmCell.propagate](../Gemm/ScaledGemm.md#decl-0c7811dde43338db), [TensorCore.absQ_sumQ_le](Sum.md#decl-9728c1755d91fb0d), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.checkFiniteAdd_sound](../Gemm/ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.checkGroups_sound](../TC/Program/GroupAnalysis.md#decl-1b68b353164cb06a), [TensorCore.checkScalar_sound](../Gemm/ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.gemmCellCheck_product_bound](../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmConversion_bounded](../Gemm/ConversionBounds.md#decl-42b2253d93dfc597), [TensorCore.gemmInputPairError_bound](../Gemm/InputBounds.md#decl-0b206d7ac67403b7), [TensorCore.gemmInputPairTightError_bound](../Gemm/TightInputBounds.md#decl-251c676d4c121cd6), [TensorCore.gemmInputPairTightError_le](../Gemm/TightInputBounds.md#decl-8ffbd0992c010ee1), [TensorCore.gemmInputProductError_bound](../Gemm/InputBounds.md#decl-5c6d092f063552e4), [TensorCore.gemmInputProductTightError_bound](../Gemm/TightInputBounds.md#decl-94b8603bf720f7d2), [TensorCore.gemmSourceError_propagate](../Gemm/InputBounds.md#decl-7a3b7a6efc84a1d7), [TensorCore.idealContributions_abs_le](../TC/Program/Bounds/Scales.md#decl-d642c7a05f1cb663), [TensorCore.inputProductErrorTo_bound](../Gemm/MatrixConversion.md#decl-b9c5e5986779238b), [TensorCore.runBlocks_of_scale_bound](../TC/Program/Bounds/Scales.md#decl-c2c004c589ff0bb6), [TensorCore.runBlocks_residual_budget](../TC/Program/ErrorBounds.md#decl-cc967a2bb9a08415), [TensorCore.runBlocks_static](../TC/StaticBudget.md#decl-31af1b208da9e431), [TensorCore.scaledGemmCellCheck_sound](../Gemm/ScaledGemmBounds.md#decl-853772be57cd1ddc), [TensorCore.scaledGemmCellCheck_tight_sound](../Gemm/TightBounds.md#decl-bc3fbfa7854946f6), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca)

</details>

</details>

<a id="decl-5369402afa8a06d2"></a>

<details>
<summary><code>TensorCore.absQ_intCast</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L117)

```lean
theorem absQ_intCast (k : ℤ) : absQ (k : ℚ) = ((k.natAbs : ℤ) : ℚ) := by
  unfold absQ
  split
  · have hk : k < 0 := by
      have := Rat.intCast_lt_intCast (a := k) (b := 0); simp at this; grind
    rw [← Int.natAbs_neg, Int.natAbs_of_nonneg (by omega), Rat.intCast_neg]
  · have hk : 0 ≤ k := by
      have := Rat.intCast_le_intCast (a := 0) (b := k); simp at this; grind
    rw [Int.natAbs_of_nonneg hk]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6)

</details>

</details>

<a id="decl-be4c7e0a2eccbdd4"></a>

<details>
<summary><code>TensorCore.pow2_24</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L127)

```lean
theorem pow2_24 : pow2 24 = 16777216 := by decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878)

</details>

</details>

<a id="decl-df27871aa2e75878"></a>

<details>
<summary><code>TensorCore.finite_below_binade</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L130)

```lean
/-- A finite value with exponent below `e` is at most `2^e - 2^(e-24)` in magnitude. -/
theorem finite_below_binade (k e2 e : ℤ) (hk : k.natAbs < 2 ^ 24) (h : e2 < e) :
    absQ ((k : ℚ) * pow2 (e2 - 23)) ≤ pow2 e - pow2 (e - 24) := by
  have hq := pow2_pos (e2 - 23)
  rw [absQ_mul_pos _ _ hq, absQ_intCast]
  have hk' : ((k.natAbs : ℤ) : ℚ) ≤ (16777215 : ℚ) := by
    have h1 : (k.natAbs : ℤ) ≤ 16777215 := by omega
    have h2 := Rat.intCast_le_intCast.mpr h1
    simpa using h2
  have hgrid : pow2 (e2 - 23) ≤ pow2 (e - 24) := pow2_le_of_le (by omega)
  have hnn : (0 : ℚ) ≤ ((k.natAbs : ℤ) : ℚ) := Rat.intCast_nonneg.mpr (by omega)
  have step1 : ((k.natAbs : ℤ) : ℚ) * pow2 (e2 - 23) ≤ 16777215 * pow2 (e - 24) :=
    calc ((k.natAbs : ℤ) : ℚ) * pow2 (e2 - 23)
        ≤ ((k.natAbs : ℤ) : ℚ) * pow2 (e - 24) := Rat.mul_le_mul_of_nonneg_left hgrid hnn
      _ ≤ 16777215 * pow2 (e - 24) :=
          Rat.mul_le_mul_of_nonneg_right hk' (Rat.le_of_lt (pow2_pos _))
  have step2 : (16777215 : ℚ) * pow2 (e - 24) = pow2 e - pow2 (e - 24) := by
    have : pow2 e = pow2 (e - 24) * pow2 24 := by rw [← pow2_add]; congr 1; omega
    rw [this, pow2_24]
    grind
  rw [← step2]; exact step1
```

**Supporting proofs:** [TensorCore.absQ_intCast](Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.pow2_24](Exact.md#decl-be4c7e0a2eccbdd4), [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de)

</details>

</details>

<a id="decl-0f03bd798f351376"></a>

<details>
<summary><code>TensorCore.finite_on_grid</code></summary>

[Lean source](../../../TensorCore/Core/Exact.lean#L151)

```lean
theorem finite_on_grid (k e2 e : ℤ) (h : e ≤ e2) :
    ∃ j : ℤ, (k : ℚ) * pow2 (e2 - 23) = j * pow2 (e - 23) := by
  refine ⟨k * 2 ^ (e2 - e).toNat, ?_⟩
  have : pow2 (e2 - 23) = pow2 (e - 23) * pow2 ((e2 - e).toNat : ℤ) := by
    rw [← pow2_add]; congr 1; omega
  rw [this, pow2_natCast, Rat.intCast_mul, Rat.intCast_pow]
  simp only [Rat.intCast_ofNat, Rat.natCast_pow, Rat.natCast_ofNat]
  grind
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.truncGrid_exact_of_grid](Truncation.md#decl-8a6ed0cd1522f575)

</details>

</details>
