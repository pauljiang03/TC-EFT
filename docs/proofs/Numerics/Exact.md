# TensorCore.Numerics.Exact

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b52a0281b35514e3"></a>

<details>
<summary><code>TensorCore.pow2</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L11)

```lean
def pow2 (e : ℤ) : ℚ := (2 : ℚ) ^ e
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.finiteValue](Binary/RoundTrip.md#decl-8ccfd6c43d66f303), [TensorCore.BinaryRep.sign_of_nonzero](Binary/SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.BinaryRep.value](Binary/Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.BinaryRep.value_eq_zero_iff](Binary/RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.BlockTrace.lowCoefficients](../EFT/Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.Decoded.value_ne_zero](../TC/Instruction.md#decl-411ba01d7f55e7d1), [TensorCore.EFMachine.Accumulator.term_value](../Kernels/EFT/Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.Prepared.ideal_allZero](../Kernels/EFT/Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.Word.abs_value](../Kernels/EFT/Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.add_value](../Kernels/EFT/Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.neg_value](../Kernels/EFT/Word.md#decl-2d5527f4636e4785), [TensorCore.EFMachine.Word.range_iff](../Kernels/EFT/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](../Kernels/EFT/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.sameValue_value](../Kernels/EFT/Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.Word.sign_value](../Kernels/EFT/Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low_bound](../Kernels/EFT/Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_reconstruct](../Kernels/EFT/Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.value](../Kernels/EFT/WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.Word.value_zero_iff](../Kernels/EFT/Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.dyadic_div](../Kernels/EFT/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.magnitudeExponent_word](../Kernels/EFT/Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.magnitudeValue](../Kernels/EFT/Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.pow2_common](../Kernels/EFT/Round.md#decl-8e9c8ffd317bb724), [TensorCore.EFMachine.product_value](../Kernels/EFT/Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.EFMachine.roundingCoefficient_convCoeff](../Kernels/EFT/Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingGrid_div](../Kernels/EFT/Round.md#decl-73afe430816bd696), [TensorCore.EFMachine.shiftedWord_value](../Kernels/EFT/Decode.md#decl-c7dc56eb3d6d341c), [TensorCore.EFMachine.signedDyadic](../Kernels/EFT/Split.md#decl-763c208b0e2b895c), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low_residual](../Kernels/EFT/Split.md#decl-6d6fe2bc592a6791), [TensorCore.EFMachine.sumWords_value](../Kernels/EFT/Word.md#decl-c50a82a7014218e4), [TensorCore.EFMachine.zeroWord_value](../Kernels/EFT/Decode.md#decl-4c8297f8c50b7d91), [TensorCore.ExtractionGrid.coefficients](../EFT/ExtractionGrid.md#decl-4e520e672b0502a5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.Format.FiniteValue](Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.binade_grid](Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finiteValue_neg](Binary/CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.Format.maxFinite](Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.maxFinite_lt](Binary/ConversionBounds.md#decl-27fef2f17e469434), [TensorCore.Format.next_binade_grid](Binary/ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.IEEE.LeanBridge.aligned_add_value](../Scalar/LeanBridge.md#decl-e6cb66147cd6c96f), [TensorCore.IEEE.LeanBridge.aligned_sub_value](../Scalar/LeanBridge.md#decl-e1219acca53993f8), [TensorCore.IEEE.LeanBridge.decode32_nonzero](../Scalar/LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decreaseExponent_value](../Scalar/LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteValue32](../Scalar/LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](../Scalar/LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](../Scalar/LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.firstPass32](../Scalar/LeanRounding.md#decl-1f3110087e3c2f88), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../Scalar/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../Scalar/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](../Scalar/LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../Scalar/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../Scalar/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../Scalar/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_eq](../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.shiftRight_represents](../Scalar/LeanRounding.md#decl-7f6354812c57ad44), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](../Scalar/LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.IEEE.LeanBridge.shifted_round_eq_rne](../Scalar/LeanRounding.md#decl-f6d8726852e1a50e), [TensorCore.IEEE.LeanBridge.targetExponent32_eq](../Scalar/LeanRounding.md#decl-fe597c4119872d5a), [TensorCore.IEEE.PrecisionRound](../Scalar/Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.decode_finite_iff](../Scalar/Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.maxFiniteWord_value](../Scalar/Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.precisionMagnitude](../Scalar/Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.precisionMagnitude_correct](../Scalar/Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionMagnitude_le_max](../Scalar/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionMagnitude_positive](../Scalar/Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precisionRound_unique](../Scalar/Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](../Scalar/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../Scalar/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.round_overflow_iff](../Scalar/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.tiny](../Scalar/Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero_value](../Scalar/Basic.md#decl-42575e26b6696b19), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.coefficient_eq](../TC/Specification/Stages.md#decl-2eed3165d7f83748), [TensorCore.PaperSpec.decode_eq](../TC/Specification/Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.raw_value_zero](../TC/Specification/Stages.md#decl-1b686554b9d985d5), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.terms_eq](../TC/Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.machineAccumulator](../TC/Accumulator.md#decl-9e58c7148c06ae54), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.RawProduct.value](RawProduct.md#decl-549312d8d1563679), [TensorCore.Regression.encoded_v100_not_monotone](../Tests/EFT/EncodedEFT.md#decl-83fcbe1b52439ce7), [TensorCore.Regression.finite_bijection_endpoints](../Tests/TC/DirectedBinary.md#decl-b74680eb28ad51fd), [TensorCore.Regression.out_of_range_rejected](../Tests/TC/Cases.md#decl-de4d74472a6abfec), [TensorCore.Regression.r4_binade_asymmetry](../Tests/TC/Cases.md#decl-dd87c11927efb30e), [TensorCore.Regression.r4_binade_carry](../Tests/TC/Cases.md#decl-3b313daa3dfd8b27), [TensorCore.Regression.r4_cancellation](../Tests/TC/Cases.md#decl-f5b3a2f370a66b02), [TensorCore.Regression.r4_even_tie](../Tests/TC/Cases.md#decl-bc54899e2865dcef), [TensorCore.Regression.r4_midpoint_distances](../Tests/TC/Composition.md#decl-7fa1f7d6ed299760), [TensorCore.Regression.r4_negative_zero](../Tests/TC/Cases.md#decl-1edb476558a306fe), [TensorCore.Regression.r4_odd_tie](../Tests/TC/Cases.md#decl-7d03f05653e1e285), [TensorCore.Regression.r4_subnormal_boundary](../Tests/TC/Cases.md#decl-9a49c360edf3a319), [TensorCore.Regression.r4_zero_tie](../Tests/TC/Cases.md#decl-54a7f4f8fbe4a04d), [TensorCore.Regression.scalar64_coarse_grid](../Tests/EFT/ScalarEFT.md#decl-71ebab7703c3a1c5), [TensorCore.Regression.scalar64_double_rounding_incorrect](../Tests/EFT/ScalarEFT.md#decl-75316677317adbed), [TensorCore.Regression.scalar64_finite_boundary](../Tests/EFT/ScalarEFT.md#decl-2400fe596e80a925), [TensorCore.Regression.scalar64_preserves_low_component](../Tests/EFT/ScalarEFT.md#decl-04af8db10d4464ca), [TensorCore.Regression.scalar64_subnormal_sum](../Tests/EFT/ScalarEFT.md#decl-cb03ef10bf4e4cbd), [TensorCore.Regression.scalar_bitSpan_budget](../Tests/EFT/ScalarEFT.md#decl-4f8ed7cf41298ebe), [TensorCore.Regression.source_padding_boundary](../Tests/TC/Features.md#decl-e27f31fdaaf23f2c), [TensorCore.Regression.v100_products_not_monotone](../Tests/EFT/Flowback.md#decl-725fd4d619d07b0f), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual](Truncation.md#decl-8fb54cfc251e7721), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.alignment_value](Truncation.md#decl-4fd20c57624d75c8), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.belowDecoded_value](../TC/MonotonicityRange.md#decl-5392c153e1597baf), [TensorCore.belowOneDecoded_value](../TC/Monotonicity.md#decl-48fa61f0bee3fd85), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.binaryCarry_spec](Binary/ConversionBounds.md#decl-9bdec62f2ae623aa), [TensorCore.binaryConvCoeff_bounds](Binary/ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryConvExp_bounds](Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.binaryMagnitudeRounded](Binary/CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binaryMagnitudeRounded_lower](Binary/CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binaryValue_zero](Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](Binary/CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.carry_spec](ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.classifyNat32_finite](EncodingProperties.md#decl-2559eed0b9bbddd9), [TensorCore.classifyNat_finiteValue](Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.coefficient_range_of_grid](Binary/ScalarSum.md#decl-427e226844e8fe51), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](../TC/Block.md#decl-8e67b4eed923de99), [TensorCore.construction_not_monotone](../TC/Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.convExp_le_of_lt](Rounding.md#decl-49ec78234aca30b2), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.decoded_zero_bounded](FormatProperties.md#decl-552117025e86e0df), [TensorCore.div_pow2](Exact.md#decl-341a7e90774bc1d1), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.encodeBinary_value](Binary/Encoding.md#decl-4c3ec26630f2de66), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finiteValue32_neg](CorrectRounding.md#decl-e82bec275802f6d0), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.grid_finiteValue](Binary/ScalarSum.md#decl-f22e396ecf09e13e), [TensorCore.grid_finiteValue32](ScalarSum.md#decl-5c5b5245f25f71db), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.machineAccumulator_eq](../TC/AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_le_of_lt](Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.maxFinite32_lt_pow128](ConversionBounds.md#decl-5f5cd77d343a83f6), [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.naiveSum64_exact](Binary/ScalarSum.md#decl-d74afdeb99860469), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinary_exact](Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](Binary/ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.naiveSumBinary_exact_perm](Binary/ScalarSum.md#decl-f78af6692d4089d7), [TensorCore.next_binade_grid](ConversionBounds.md#decl-6e741e2915b593fa), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](../TC/Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](../TC/MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.pow2_24](Exact.md#decl-be4c7e0a2eccbdd4), [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_div](Exact.md#decl-71bd87700a9fc6ed), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_lt_succ](Exact.md#decl-b1dfe79296f2080d), [TensorCore.pow2_natCast](Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_one](Exact.md#decl-8feaca6c2e8345f1), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b), [TensorCore.pow2_zero](Exact.md#decl-ac9c8646649b0ae0), [TensorCore.prepared_coefficient_bound](../TC/AlignmentScale.md#decl-929725522df30cf8), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawMul_significand_ne_zero](../TC/Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_nearestEven_correct](Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](Binary/RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](Binary/RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](Binary/DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](Binary/DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](Binary/RoundingContract.md#decl-765cac64e8b78cf4), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncCoeff_nonneg_eq](Truncation.md#decl-a3484604d19e0df2), [TensorCore.truncCoeff_of_grid](Truncation.md#decl-03b847921a9aec6d), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_exact_of_grid](Truncation.md#decl-8a6ed0cd1522f575), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.truncGrid_zero](Truncation.md#decl-c8fd94be6ed59920), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.PaperSpec.zero_bits](../TC/Specification/Rounding.md#decl-6c7995fb8803ab3c)

</details>

</details>

<a id="decl-7127823e49ce5599"></a>

<details>
<summary><code>TensorCore.pow2_add</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L13)

```lean
theorem pow2_add (e f : ℤ) : pow2 (e + f) = pow2 e * pow2 f :=
  Rat.zpow_add (by decide) e f
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.dyadic_div](../Kernels/EFT/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.pow2_common](../Kernels/EFT/Round.md#decl-8e9c8ffd317bb724), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.Format.binade_grid](Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.Format.next_binade_grid](Binary/ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.IEEE.LeanBridge.decreaseExponent_value](../Scalar/LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.finiteValue32_mul](../Scalar/LeanBridge.md#decl-ff38abc65cb0616b), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../Scalar/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](../Scalar/LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.binade_grid](ConversionBounds.md#decl-5b97691144435e79), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.div_pow2](Exact.md#decl-341a7e90774bc1d1), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.pow2_div](Exact.md#decl-71bd87700a9fc6ed), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawProduct_value](RawProduct.md#decl-f5273efeebd6d86f), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-8f231b6648575120"></a>

<details>
<summary><code>TensorCore.pow2_pos</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L16)

```lean
theorem pow2_pos (e : ℤ) : 0 < pow2 e := Rat.zpow_pos (by decide)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.sign_of_nonzero](Binary/SignedBijection.md#decl-0d2ca3e13f7ea63f), [TensorCore.BinaryRep.value_eq_zero_iff](Binary/RoundTrip.md#decl-45ba7850d1a076bc), [TensorCore.Decoded.value_ne_zero](../TC/Instruction.md#decl-411ba01d7f55e7d1), [TensorCore.EFMachine.Word.abs_value](../Kernels/EFT/Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.range_iff](../Kernels/EFT/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.sign_value](../Kernels/EFT/Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.value_zero_iff](../Kernels/EFT/Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.dyadic_div](../Kernels/EFT/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.magnitudeExponent_word](../Kernels/EFT/Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.maxFinite_lt](Binary/ConversionBounds.md#decl-27fef2f17e469434), [TensorCore.IEEE.LeanBridge.finiteValue32_ne_zero](../Scalar/LeanFiniteAddition.md#decl-11d149ae2446df9e), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../Scalar/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../Scalar/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../Scalar/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../Scalar/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../Scalar/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_eq](../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.shiftRight_represents](../Scalar/LeanRounding.md#decl-7f6354812c57ad44), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](../Scalar/LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.IEEE.precisionMagnitude_le_max](../Scalar/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionMagnitude_positive](../Scalar/Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precisionRound_unique](../Scalar/Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](../Scalar/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../Scalar/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.PaperSpec.raw_value_zero](../TC/Specification/Stages.md#decl-1b686554b9d985d5), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.binaryConvCoeff_bounds](Binary/ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded_lower](Binary/CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](Binary/CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.coefficient_range_of_grid](Binary/ScalarSum.md#decl-427e226844e8fe51), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.div_pow2](Exact.md#decl-341a7e90774bc1d1), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.pow2_div](Exact.md#decl-71bd87700a9fc6ed), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_lt_succ](Exact.md#decl-b1dfe79296f2080d), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rawMul_significand_ne_zero](../TC/Monotonicity.md#decl-0e4d12d646a70bc9), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_zero](Binary/RoundingContract.md#decl-765cac64e8b78cf4), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncCoeff_of_grid](Truncation.md#decl-03b847921a9aec6d), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.PaperSpec.zero_bits](../TC/Specification/Rounding.md#decl-6c7995fb8803ab3c)

</details>

</details>

<a id="decl-997b22af00ef82dd"></a>

<details>
<summary><code>TensorCore.pow2_natCast</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L18)

```lean
theorem pow2_natCast (n : ℕ) : pow2 (n : ℤ) = ((2 ^ n : ℕ) : ℚ) := by
  unfold pow2; rw [Rat.zpow_natCast]; simp
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.dyadic_div](../Kernels/EFT/Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.pow2_common](../Kernels/EFT/Round.md#decl-8e9c8ffd317bb724), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.Format.binade_grid](Binary/ConversionBounds.md#decl-e0ee28b5db1c0078), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.Format.finite_on_grid](Binary/CorrectRounding.md#decl-45e49aee9dd44e9c), [TensorCore.Format.next_binade_grid](Binary/ConversionBounds.md#decl-fba2cf9fd898146c), [TensorCore.IEEE.LeanBridge.decreaseExponent_value](../Scalar/LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../Scalar/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finite_on_grid](Exact.md#decl-0f03bd798f351376), [TensorCore.floor_natCast_mul_pow2_neg](../TC/MonotonicityRange.md#decl-1f5df0d5f93e1feb), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-8feaca6c2e8345f1"></a>

<details>
<summary><code>TensorCore.pow2_one</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L21)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L23)

```lean
theorem pow2_succ (e : ℤ) : pow2 (e + 1) = pow2 e * 2 := by rw [pow2_add, pow2_one]
```

**Supporting proofs:** [TensorCore.pow2_add](Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_one](Exact.md#decl-8feaca6c2e8345f1)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.shiftRight_represents](../Scalar/LeanRounding.md#decl-7f6354812c57ad44), [TensorCore.binaryCarry_spec](Binary/ConversionBounds.md#decl-9bdec62f2ae623aa), [TensorCore.carry_spec](ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.next_binade_grid](ConversionBounds.md#decl-6e741e2915b593fa), [TensorCore.pow2_lt_succ](Exact.md#decl-b1dfe79296f2080d)

</details>

</details>

<a id="decl-b1dfe79296f2080d"></a>

<details>
<summary><code>TensorCore.pow2_lt_succ</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L25)

```lean
theorem pow2_lt_succ (e : ℤ) : pow2 e < pow2 (e + 1) := by
  rw [pow2_succ]; have := pow2_pos e; grind
```

**Supporting proofs:** [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120), [TensorCore.pow2_succ](Exact.md#decl-57be1bea59f2897b)

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-064be6edf8651285"></a>

<details>
<summary><code>TensorCore.pow2_le_of_le</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L29)

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

[TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.binaryConvExp_bounds](Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.coefficient_range_of_grid](Binary/ScalarSum.md#decl-427e226844e8fe51), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_le_of_lt](Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3)

</details>

</details>

<a id="decl-f20062bdc47118bd"></a>

<details>
<summary><code>TensorCore.sumQ</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L40)

```lean
def sumQ : List ℚ → ℚ
  | [] => 0
  | x :: xs => x + sumQ xs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.exactConsolidation](../EFT/Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.retainedSum](../EFT/Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.ConversionRun.loss](Conversion.md#decl-29f602efd8dc0504), [TensorCore.EFMachine.Prepared.ideal](../Kernels/EFT/Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Prepared.ideal_allZero](../Kernels/EFT/Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.algorithm1_prepared](../Kernels/EFT/Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.extract_spec](../Kernels/EFT/Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](../Kernels/EFT/Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.split_sum](../Kernels/EFT/Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.EFMachine.sumWords_value](../Kernels/EFT/Word.md#decl-c50a82a7014218e4), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](../EFT/ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.ExtractionGrid.recovery](../EFT/ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.retainedSum](../EFT/ExtractionGrid.md#decl-2e41827366b1c9d0), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.LocalAccumulation.loss](../TC/Invocation.md#decl-68d84640e3352f8b), [TensorCore.PreparedBlock.exactProducts](../TC/Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.extractReference](../TC/Block.md#decl-6cc810f8061e66a0), [TensorCore.PreparedInvocation.exactProducts](../TC/Invocation.md#decl-f08483de5406c0c5), [TensorCore.Regression.twoBlockSummary](../Tests/TC/Composition.md#decl-27d6915f955ce3fa), [TensorCore.absQ_sumQ_le](Sum.md#decl-9728c1755d91fb0d), [TensorCore.accumulateInvocation](../TC/Invocation.md#decl-7e7acb74ce8e2620), [TensorCore.accumulateInvocation_recovery](../TC/InvocationProperties.md#decl-42509334ff62e502), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_residual_identity](../TC/StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.correctedSchedule_correct](../TC/Correction.md#decl-c5490d1a25901294), [TensorCore.encoded_trace_ledger](../TC/Composition.md#decl-775280e15ad44086), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.flowback](../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.fold_residual_ledger](../TC/Composition.md#decl-ff8ab9a0bbbddfad), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.overlap_eq_retained_sub_outputResidual](../EFT/Extraction.md#decl-fc2dcdeff262fd49), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.recoveredSchedule](../TC/Correction.md#decl-dd85a41a20883c51), [TensorCore.retained_add_low](../EFT/Extraction.md#decl-da77fbfd62ee1185), [TensorCore.runBlocks_corrected_correct](../TC/Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_residual_ledger](../TC/Composition.md#decl-c73efd4921810886), [TensorCore.runConversions_recovery](Conversion.md#decl-9a595a0bbdd2a7fc), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.sumQ_map_add](Sum.md#decl-9a866541e41b56c9), [TensorCore.sumQ_map_le](Sum.md#decl-02931053452cdfec), [TensorCore.sumQ_map_lt](Sum.md#decl-5c0b2e6254ce280d), [TensorCore.sumQ_map_sub](Sum.md#decl-23e4bf84c54e623b), [TensorCore.sumQ_map_zero](Sum.md#decl-181b288c0a867eb6), [TensorCore.sum_coefficients](Exact.md#decl-005e2ad99fe60fa3), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.sum_stage_residuals](../TC/StageResiduals.md#decl-fec712a2169085b5), [TensorCore.terms_value](../TC/StageResiduals.md#decl-7b530e0eb36f1f90), [TensorCore.aligned_recovery](../TC/InvocationProperties.md#decl-f6828402db94c42c)

</details>

</details>

<a id="decl-eba77bb372c3b3ff"></a>

<details>
<summary><code>TensorCore.sumZ</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L44)

```lean
def sumZ : List ℤ → ℤ
  | [] => 0
  | x :: xs => x + sumZ xs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_exact_sum](../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PreparedBlock.accumulator](../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.Regression.scalar64_coarse_grid](../Tests/EFT/ScalarEFT.md#decl-71ebab7703c3a1c5), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.evalBlock_machinePrefix](../TC/AlignmentScale.md#decl-503fa36f9568f733), [TensorCore.machineAccumulate_eq](../TC/AccumulatorWidth.md#decl-297efa863148b988), [TensorCore.machineAccumulate_exact](../TC/AccumulatorWidth.md#decl-80c3acbccc8106eb), [TensorCore.machineAccumulate_of_coefficient_bound](../TC/AccumulatorWidth.md#decl-c1bb27c5ce2e7d98), [TensorCore.machineAccumulate_prefix_exact](../TC/AccumulatorWidth.md#decl-9b23fe9fc6ec5adf), [TensorCore.machineAccumulator_eq](../TC/AccumulatorWidth.md#decl-fa564636f9129fb5), [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.naiveSum64_exact](Binary/ScalarSum.md#decl-d74afdeb99860469), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinary_exact](Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](Binary/ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.naiveSumBinary_exact_perm](Binary/ScalarSum.md#decl-f78af6692d4089d7), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.sumZ_natAbs_le](Sum.md#decl-d8b1b90e2d6e4d96), [TensorCore.sumZ_perm](Sum.md#decl-e7bd85cdcec165e7), [TensorCore.sumZ_replicate](Sum.md#decl-515e106ddee189db), [TensorCore.sum_coefficients](Exact.md#decl-005e2ad99fe60fa3), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-8dd63ab202e070d3"></a>

<details>
<summary><code>TensorCore.absQ</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L48)

```lean
def absQ (x : ℚ) : ℚ := if x < 0 then -x else x
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec.finite](Binary/RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.Decoded.Bounded](Defs.md#decl-716025aa0e922bfd), [TensorCore.EFMachine.Word.abs_value](../Kernels/EFT/Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.range_iff](../Kernels/EFT/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](../Kernels/EFT/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](../Kernels/EFT/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.Word.split_low_bound](../Kernels/EFT/Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.value_zero_iff](../Kernels/EFT/Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.add32WithLean_eq](../Kernels/EFT/Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../Kernels/EFT/Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../Kernels/EFT/Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_range_iff](../Kernels/EFT/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../Kernels/EFT/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.IEEE.IntegerRound](../Scalar/Precision.md#decl-c1146843cf5e28a6), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../Scalar/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](../Scalar/LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](../Scalar/LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../Scalar/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../Scalar/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../Scalar/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_reference](../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](../Scalar/LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.RoundSpec](../Scalar/Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.coefficient_correct](../Scalar/Precision.md#decl-9de0c69639190f6d), [TensorCore.IEEE.convert_self_finite](../Scalar/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.finiteBits](../Scalar/Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](../Scalar/Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](../Scalar/Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.integerRound_unique](../Scalar/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.precision_ceil_all](../Scalar/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../Scalar/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.round](../Scalar/Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](../Scalar/Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](../Scalar/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](../Scalar/Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](../Scalar/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](../Scalar/Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](../Scalar/Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](../Scalar/Rounding.md#decl-99b995352bd4bae1), [TensorCore.NearestEven](Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.NearestEven32](RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PaperSpec.magnitude_eq](../TC/Specification/Rounding.md#decl-324135f1be845e5f), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.valid_iff](../TC/Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.RawProduct.Bounded](RawProduct.md#decl-3e529071d4e652db), [TensorCore.Regression.bf16_rounding_correct](../Tests/TC/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.directed_unusual_format](../Tests/TC/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.fp16_rounding_correct](../Tests/TC/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp32_generic_agrees](../Tests/TC/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.fp64_rounding_correct](../Tests/TC/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.negative_subnormal_lower_contract](../Tests/TC/DirectedBinary.md#decl-6ef36ec120fedf99), [TensorCore.Regression.negative_subnormal_upper_contract](../Tests/TC/DirectedBinary.md#decl-7cbd49d6e0ce38c4), [TensorCore.Regression.r4_midpoint_distances](../Tests/TC/Composition.md#decl-7fa1f7d6ed299760), [TensorCore.Regression.scalar_bitSpan_budget](../Tests/EFT/ScalarEFT.md#decl-4f8ed7cf41298ebe), [TensorCore.Regression.tf19_rounding_correct](../Tests/TC/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.TowardZero](Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ_add_le](Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_intCast](Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_le_iff](Exact.md#decl-3513a75c8e3035b2), [TensorCore.absQ_lt_iff](Exact.md#decl-33f2b1d708f79f21), [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_neg](Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_nonneg](Exact.md#decl-137ea017d6c4d0cd), [TensorCore.absQ_of_neg](Exact.md#decl-3279b57bfb1b8206), [TensorCore.absQ_of_nonneg](Exact.md#decl-2aceea0008eec277), [TensorCore.absQ_pos_of_ne_zero](CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.absQ_sub_comm](Exact.md#decl-a632fad01d9c884a), [TensorCore.absQ_sumQ_le](Sum.md#decl-9728c1755d91fb0d), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual](Truncation.md#decl-8fb54cfc251e7721), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.binary64Fma_correct](../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binarySignedRounded](Binary/CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](Binary/DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](Binary/DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](Binary/CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.c_term_bounded](RawProduct.md#decl-a5b1dc2326008483), [TensorCore.canonical_padding_success_iff](../TC/Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_success_iff](../TC/Padding.md#decl-ca6987fa7885e6c2), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.conversionStage_nearestEven_correct](../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_range](Conversion.md#decl-9878d77fe9422846), [TensorCore.conversionStage_towardNegative_correct](../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.correctedSchedule_correct](../TC/Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](../TC/Correction.md#decl-ee6543cdd6791a37), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.decoded_zero_bounded](FormatProperties.md#decl-552117025e86e0df), [TensorCore.dist_scale](Rounding.md#decl-b773da87e31ab58f), [TensorCore.evalBlock_corrected_correct](../TC/Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_success_iff](../TC/AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalInvocation_output](../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finalRound_correct](CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinary_exact_of_bitSpan](Binary/ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](Binary/ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rneInt_dist_le_half](Rounding.md#decl-926c4e219d946918), [TensorCore.rneInt_nearest](Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_tie_even](Rounding.md#decl-b3bf5bfe6d222ec7), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_grid_nearest_q](Binary/CorrectRounding.md#decl-ca751f6fe596d9e8), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.roundBinary](Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_correct](Binary/RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_exact_of_finite](Binary/ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_isSome_iff](Binary/RoundingContract.md#decl-9083817d3e897973), [TensorCore.roundBinary_nearestEven_correct](Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](Binary/CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](Binary/RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](Binary/RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](Binary/DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](Binary/DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](Binary/RoundingContract.md#decl-765cac64e8b78cf4), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.runBlocks_corrected_correct](../TC/Correction.md#decl-5c2f929f60e023e5), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.EFMachine.unit_product](../Kernels/EFT/Success.md#decl-4cb1d90c8b7bff20)

</details>

</details>

<a id="decl-137ea017d6c4d0cd"></a>

<details>
<summary><code>TensorCore.absQ_nonneg</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L50)

```lean
theorem absQ_nonneg (x : ℚ) : 0 ≤ absQ x := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.round_correct](../Scalar/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_overflow_iff](../Scalar/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.roundBinary_nearestEven_correct](Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf)

</details>

</details>

<a id="decl-3513a75c8e3035b2"></a>

<details>
<summary><code>TensorCore.absQ_le_iff</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L51)

```lean
theorem absQ_le_iff (x c : ℚ) : absQ x ≤ c ↔ -c ≤ x ∧ x ≤ c := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.integerRound_unique](../Scalar/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.precision_ceil_all](../Scalar/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../Scalar/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.absQ_add_le](Exact.md#decl-5c1117bc0bcece80), [TensorCore.binary_ceil_magnitude_spec](Binary/DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.roundBinary_exact_of_finite](Binary/ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.EFMachine.unit_product](../Kernels/EFT/Success.md#decl-4cb1d90c8b7bff20)

</details>

</details>

<a id="decl-33f2b1d708f79f21"></a>

<details>
<summary><code>TensorCore.absQ_lt_iff</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L52)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L53)

```lean
theorem absQ_neg (x : ℚ) : absQ (-x) = absQ x := by unfold absQ; split <;> split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.abs_value](../Kernels/EFT/Round.md#decl-5922e66553898d4e), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../Scalar/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../Scalar/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_reference](../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-a632fad01d9c884a"></a>

<details>
<summary><code>TensorCore.absQ_sub_comm</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L54)

```lean
theorem absQ_sub_comm (x y : ℚ) : absQ (x - y) = absQ (y - x) := by
  unfold absQ; split <;> split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5608efce37c35b7f"></a>

<details>
<summary><code>TensorCore.absQ_mul_pos</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L56)

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

[TensorCore.Format.finiteValue_abs_le](Binary/ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.Format.finite_below_binade](Binary/CorrectRounding.md#decl-287dcf11c77d730d), [TensorCore.bitSpan_coefficient_bound](Sum.md#decl-dd359e6ccc782af7), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.dist_scale](Rounding.md#decl-b773da87e31ab58f), [TensorCore.extraction_coefficient_bound](Binary/ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.finite_below_binade](Exact.md#decl-df27871aa2e75878), [TensorCore.grid_finiteValue_of_range](Binary/ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.naiveSumBinaryFrom_exact](Binary/ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6)

</details>

</details>

<a id="decl-2aceea0008eec277"></a>

<details>
<summary><code>TensorCore.absQ_of_nonneg</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L66)

```lean
theorem absQ_of_nonneg {x : ℚ} (h : 0 ≤ x) : absQ x = x := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.abs_value](../Kernels/EFT/Round.md#decl-5922e66553898d4e), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../Scalar/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../Scalar/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_reference](../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.precision_nearest_all](../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](Binary/DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](Binary/DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.decoded_normal_magnitude_lower](Binary/MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.decoded_signed_bounded](FormatProperties.md#decl-4fcf0bbda143bae8), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e)

</details>

</details>

<a id="decl-3279b57bfb1b8206"></a>

<details>
<summary><code>TensorCore.absQ_of_neg</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L67)

```lean
theorem absQ_of_neg {x : ℚ} (h : x < 0) : absQ x = -x := by unfold absQ; split <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binarySignedRounded_nearest](Binary/CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](Binary/CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](Binary/DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](Binary/DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.rawMul_bounded](RawProduct.md#decl-8b1220a1d4a27018), [TensorCore.roundBinary_towardZero_correct](Binary/CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e)

</details>

</details>

<a id="decl-282a0db962f1b274"></a>

<details>
<summary><code>TensorCore.truncCoeff</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L70)

```lean
/-- Signed magnitude truncation. Division is applied to a nonnegative magnitude. -/
def truncCoeff (x : ℚ) (e : ℤ) : ℤ :=
  if x < 0 then -((-x / pow2 e).floor) else (x / pow2 e).floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.PaperSpec.accumulated_eq](../TC/Specification/Stages.md#decl-4c3add47ac2ab200), [TensorCore.PaperSpec.coefficient_eq](../TC/Specification/Stages.md#decl-2eed3165d7f83748), [TensorCore.PreparedBlock.coefficients](../TC/Block.md#decl-c0369f010f61825c), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.aligned_term_coefficient_bound](../TC/AlignmentScale.md#decl-5d30bccb64b9e9ad), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.alignment_value](Truncation.md#decl-4fd20c57624d75c8), [TensorCore.construction_accumulator_below](../TC/Monotonicity.md#decl-e5161ec0a85d5b73), [TensorCore.construction_accumulator_one](../TC/Monotonicity.md#decl-04cdce600f593f04), [TensorCore.construction_accumulator_range](../TC/MonotonicityRange.md#decl-d9208cfa13b8ff00), [TensorCore.construction_coefficients](../TC/Block.md#decl-8e67b4eed923de99), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.prepare_coefficient_capacity](../TC/AlignmentScale.md#decl-c04538f02bc7d682), [TensorCore.prepared_coefficient_bound](../TC/AlignmentScale.md#decl-929725522df30cf8), [TensorCore.truncCoeff_abs_le](Truncation.md#decl-fc0fb5f55225cc0e), [TensorCore.truncCoeff_nonneg_eq](Truncation.md#decl-a3484604d19e0df2), [TensorCore.truncCoeff_of_grid](Truncation.md#decl-03b847921a9aec6d), [TensorCore.truncGrid](Exact.md#decl-104d085b38c6a29b), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.truncGrid_zero](Truncation.md#decl-c8fd94be6ed59920), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-104d085b38c6a29b"></a>

<details>
<summary><code>TensorCore.truncGrid</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L73)

```lean
def truncGrid (x : ℚ) (e : ℤ) : ℚ := (truncCoeff x e : ℚ) * pow2 e
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.truncCoeff](Exact.md#decl-282a0db962f1b274)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.coarse](../EFT/Defs.md#decl-a31b735e46831516), [TensorCore.BlockTrace.lowParts](../EFT/Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.retainedLowParts](../EFT/Defs.md#decl-9ea2d33eab35e3e8), [TensorCore.EFMachine.Word.split_coarse_value](../Kernels/EFT/Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low_bound](../Kernels/EFT/Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_low_value](../Kernels/EFT/Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.extract_component](../Kernels/EFT/Extraction.md#decl-f7b97097f702b90a), [TensorCore.EFMachine.splitMagnitude_coarse_truncGrid](../Kernels/EFT/Split.md#decl-596556927b61a3b2), [TensorCore.EFMachine.splitMagnitude_low_residual](../Kernels/EFT/Split.md#decl-6d6fe2bc592a6791), [TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.ExtractionGrid.coarse](../EFT/ExtractionGrid.md#decl-fa64a28cdb2655d5), [TensorCore.ExtractionGrid.eq20_coefficients](../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.ExtractionGrid.lowPart_bound](../EFT/ExtractionGrid.md#decl-1f823e542050f1b9), [TensorCore.ExtractionGrid.lowParts](../EFT/ExtractionGrid.md#decl-9b1a30bc57169e40), [TensorCore.ExtractionGrid.lowParts_on_grid](../EFT/ExtractionGrid.md#decl-fb6adb3614a7013f), [TensorCore.ExtractionGrid.retainedLowParts](../EFT/ExtractionGrid.md#decl-c761247ea38946db), [TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.PreparedBlock.alignmentResiduals](../TC/Block.md#decl-36e297929b24e234), [TensorCore.Regression.EFMachine.negative_residual](../Tests/EFT/MachineSplit.md#decl-f12f3766824311d7), [TensorCore.Regression.r4_signed_truncation](../Tests/TC/Cases.md#decl-055774464a138a7b), [TensorCore.accumulatorShift](../TC/Flowback.md#decl-c8ad334d1cfc26df), [TensorCore.accumulatorShift_of_exact](../TC/Flowback.md#decl-d93ce2ab3174723d), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.accumulator_value](../TC/StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.alignment_residual](Truncation.md#decl-8fb54cfc251e7721), [TensorCore.alignment_residual_bounds](Truncation.md#decl-26d336240b1cf59e), [TensorCore.alignment_value](Truncation.md#decl-4fd20c57624d75c8), [TensorCore.block_alignment_bound](../TC/ErrorBounds.md#decl-6c4703b9700d8982), [TensorCore.block_residual_identity](../TC/StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.exact_alignment_accumulator](../TC/ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.flowback](../TC/Flowback.md#decl-69e48afeebdfb15c), [TensorCore.lowPart_bound](../EFT/Extraction.md#decl-c35e73ca20c0ba9d), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.perturbed_accumulator](../TC/Flowback.md#decl-d8db235e56c7f3c2), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca), [TensorCore.truncGrid_abs_le](Truncation.md#decl-7a0e78c2723e16d6), [TensorCore.truncGrid_exact_of_grid](Truncation.md#decl-8a6ed0cd1522f575), [TensorCore.truncGrid_fixed](Truncation.md#decl-5fd2d7fb322fdc95), [TensorCore.truncGrid_le_self](Truncation.md#decl-ce4f20cb15188442), [TensorCore.truncGrid_neg](Truncation.md#decl-5a536b3a975b733c), [TensorCore.truncGrid_split](Truncation.md#decl-803d5c7e1ccf0196), [TensorCore.truncGrid_zero](Truncation.md#decl-c8fd94be6ed59920)

</details>

</details>

<a id="decl-005e2ad99fe60fa3"></a>

<details>
<summary><code>TensorCore.sum_coefficients</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L75)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L81)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L83)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L88)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L97)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L101)

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

[TensorCore.IEEE.LeanBridge.shiftRightOne_represents](../Scalar/LeanRounding.md#decl-8be2298798509a20), [TensorCore.IEEE.precisionMagnitude_lower](../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precision_floor_all](../Scalar/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.binaryMagnitudeRounded_lower](Binary/CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binary_rtz_magnitude_spec](Binary/CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91)

</details>

</details>

<a id="decl-c05af5c54a1fa836"></a>

<details>
<summary><code>TensorCore.div_le_div_of_le_right</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L107)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L111)

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

[TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.absQ_sumQ_le](Sum.md#decl-9728c1755d91fb0d), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.sum_residual_bounds](../TC/ErrorBounds.md#decl-233a4e25b95c20ca)

</details>

</details>

<a id="decl-5369402afa8a06d2"></a>

<details>
<summary><code>TensorCore.absQ_intCast</code></summary>

[Lean source](../../../TensorCore/Numerics/Exact.lean#L117)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L127)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L130)

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

[Lean source](../../../TensorCore/Numerics/Exact.lean#L151)

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
