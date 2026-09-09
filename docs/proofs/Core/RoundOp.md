# TensorCore.Core.RoundOp

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3d487bd4115d0af1"></a>

<details>
<summary><code>TensorCore.RoundingMode</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L7)

```lean
inductive RoundingMode where
  | towardZero
  | nearestEven
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.exactConsolidation](../EFT/Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](../EFT/Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarCorrectedUnchecked](../EFT/Extraction.md#decl-b298427558415577), [TensorCore.EFMachine.Components.scalar_correct](../EFT/Machine/Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.round32_correct](../EFT/Machine/Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](../EFT/Machine/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.add32WithLean_eq](../EFT/Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](../EFT/Machine/Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.algorithm1WithLean_correct](../EFT/Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1_agrees](../EFT/Machine/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](../EFT/Machine/Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](../EFT/Machine/Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](../EFT/Machine/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../EFT/Machine/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.roundingCoefficient_convCoeff](../EFT/Machine/Round.md#decl-a55b48c044a3a9d5), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](../EFT/ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](../IEEE/LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](../IEEE/LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.round32_finiteValue32](../IEEE/LeanFiniteAddition.md#decl-4eefaec604b419ba), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](../IEEE/LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.PaperSpec.Controls.ieeeAlignmentBits](../Regression/Specification/NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.Controls.noFloorBits](../Regression/Specification/NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.Controls.normalizedBits](../Regression/Specification/NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.Controls.signed_zero_is_required](../Regression/Specification/NegativeControls.md#decl-1c0835dee2595631), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.rounds_iff](../TC/Specification/Rounding.md#decl-aec56cebf6fd4fd1), [TensorCore.Program.vc_sound](../TC/Program/Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.eq20_public_corrects](../Regression/FoundationCompletion.md#decl-d2b5a2f26403185e), [TensorCore.Regression.finite_range_converter_policy](../TC/Regression/PublicDomains.md#decl-bf3a494234874689), [TensorCore.Regression.fp32_generic_agrees](../TC/Regression/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.out_of_range_rejected](../TC/Regression/Cases.md#decl-de4d74472a6abfec), [TensorCore.Regression.r4_binade_asymmetry](../TC/Regression/Cases.md#decl-dd87c11927efb30e), [TensorCore.Regression.r4_binade_carry](../TC/Regression/Cases.md#decl-3b313daa3dfd8b27), [TensorCore.Regression.r4_cancellation](../TC/Regression/Cases.md#decl-f5b3a2f370a66b02), [TensorCore.Regression.r4_even_tie](../TC/Regression/Cases.md#decl-bc54899e2865dcef), [TensorCore.Regression.r4_negative_zero](../TC/Regression/Cases.md#decl-1edb476558a306fe), [TensorCore.Regression.r4_odd_tie](../TC/Regression/Cases.md#decl-7d03f05653e1e285), [TensorCore.Regression.r4_subnormal_boundary](../TC/Regression/Cases.md#decl-9a49c360edf3a319), [TensorCore.Regression.r4_zero_tie](../TC/Regression/Cases.md#decl-54a7f4f8fbe4a04d), [TensorCore.Regression.scalar64_double_rounding_incorrect](../EFT/Regression/ScalarEFT.md#decl-75316677317adbed), [TensorCore.RoundingMode.toBinary](Binary/RoundOp.md#decl-812d25a411978fe0), [TensorCore.algorithm1Encoded_agrees](../EFT/Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1_bits_eq_round](../EFT/Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.binaryCoefficient_intCast](Binary/RoundTrip.md#decl-b8f8bffe28447932), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.canonical_padding_output](../TC/Padding.md#decl-2108e38788477de9), [TensorCore.canonical_source_padding_output](../TC/Padding.md#decl-5bdc8050550eb3f9), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.correctedSchedule](../TC/Program/Correction.md#decl-968ff850f4220ec9), [TensorCore.correctedSchedule_correct](../TC/Program/Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](../TC/Program/Correction.md#decl-ee6543cdd6791a37), [TensorCore.corrected_eq_round_exactDot](../TC/StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.evalBlock_exact_alignment](../TC/ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_static](../TC/StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.evalBlock_success_iff](../TC/AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared](../TC/Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](../TC/Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](../TC/MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](../TC/StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](../TC/ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.finalRound_correct](CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](../TC/Flowback.md#decl-b0715c384a285eb0), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp32Add](ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.fp32Add_exact](ScalarSum.md#decl-91c0a32b3579d248), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_condition](../TC/Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.representable32](ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.representable32_finite](ScalarSum.md#decl-04f29e613917ad68), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.round32_rtz_abs_le](../TC/Program/Bounds/Local.md#decl-b5d2bbed636879a7), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundBinary_fp32](Binary/RoundOp.md#decl-11e910ef6ebcee78), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5), [TensorCore.roundCoefficient_bounds](ConversionBounds.md#decl-73fca2c325f92d4a), [TensorCore.roundCoefficient_intCast](RoundTrip.md#decl-19d63265706221b3), [TensorCore.roundCoefficient_le_integer](ConversionBounds.md#decl-90034c8b2f8bb971), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](../EFT/Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_eq](../EFT/Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrectedIn_fp32_of_predicate](../EFT/Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarCorrected_eq](../EFT/Extraction.md#decl-f5da772603f2c94b), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20), [TensorCore.tceft_eq_corrected](../EFT/Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.value32_injective](RoundTrip.md#decl-c92b8ed7f76cc40c), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-db1578f6a47fc8b5"></a>

<details>
<summary><code>TensorCore.emin32</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L12)

```lean
def emin32 : ℤ := -126
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.outputGrid_spec](../EFT/Machine/Grid.md#decl-966f710cc75730bb), [TensorCore.EFMachine.roundingGrid_convExp](../EFT/Machine/Round.md#decl-cf575f3a4700f276), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.convExp_le_of_lt](Rounding.md#decl-49ec78234aca30b2), [TensorCore.encode32_quantum](EncodingProperties.md#decl-6f10a9a038e29fd3), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.outputQuantumExponent](RoundOp.md#decl-70bb2de461b51682), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b)

</details>

</details>

<a id="decl-49745d9860bef700"></a>

<details>
<summary><code>TensorCore.maxFinite32</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L13)

```lean
def maxFinite32 : ℚ := (2 ^ 24 - 1 : ℕ) * pow2 104
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.EFMachine.Word.range_iff](../EFT/Machine/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](../EFT/Machine/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.add32WithLean_eq](../EFT/Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../EFT/Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../EFT/Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_range_iff](../EFT/Machine/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../EFT/Machine/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](../EFT/Machine/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.maxMagnitude32_value](../EFT/Machine/Round.md#decl-246fd8187438ee97), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.PaperSpec.maxFinite_eq](../TC/Specification/Rounding.md#decl-b5e80a12c41db688), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.valid_iff](../TC/Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.Program.VC](../TC/Program/Defs.md#decl-8bdb929e75d195cf), [TensorCore.Program.repeat_vc_of_cycle](../TC/Program/Loops.md#decl-4f3792d4e823ab22), [TensorCore.Program.report](../TC/Program/Report.md#decl-153a1a264738ed2c), [TensorCore.Program.report_accepts_iff](../TC/Program/Report.md#decl-cb9f58bb2a973044), [TensorCore.Program.vc_sound](../TC/Program/Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.eq20_public_accepts](../Regression/FoundationCompletion.md#decl-b1321756db80e3f1), [TensorCore.Regression.final_range_rejected](../TC/Regression/Programs.md#decl-b957b5671d3ec1f7), [TensorCore.Regression.finite_range_converter_policy](../TC/Regression/PublicDomains.md#decl-bf3a494234874689), [TensorCore.Regression.fp32_generic_agrees](../TC/Regression/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.nonfinite_initial_rejected](../TC/Regression/Programs.md#decl-e3e1420815ec77d6), [TensorCore.Regression.out_of_range_rejected](../TC/Regression/Cases.md#decl-de4d74472a6abfec), [TensorCore.Regression.rejected_program_vc](../TC/Regression/Programs.md#decl-06af08619320969d), [TensorCore.Regression.symbolic_cycle_vc](../TC/Regression/Programs.md#decl-5719553e703a7aad), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.analyzeGemmCell_complete](../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.analyzeNativeCell_complete](../Gemm/NativeGemm.md#decl-6fb9db9d725eff50), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.canonical_padding_success_iff](../TC/Padding.md#decl-2df711842ed5ef42), [TensorCore.canonical_source_padding_success_iff](../TC/Padding.md#decl-ca6987fa7885e6c2), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.correctedSchedule_correct](../TC/Program/Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](../TC/Program/Correction.md#decl-ee6543cdd6791a37), [TensorCore.evalBlock_corrected_correct](../TC/Program/Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_static](../TC/StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.evalBlock_success_iff](../TC/AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.finalRound_correct](CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.groupWitnessCheck](../TC/Program/GroupAnalysis.md#decl-87ee478b88995006), [TensorCore.inferGroupWitness_valid](../TC/Program/GroupAnalysis.md#decl-d38055dcae5dab22), [TensorCore.inferGroups_complete](../TC/Program/GroupAnalysis.md#decl-f38baddc12606950), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.maxFinite32_ge_pow2_127](../TC/StaticBudget.md#decl-c065d1805b03afa6), [TensorCore.maxFinite32_lt_pow128](ConversionBounds.md#decl-5f5cd77d343a83f6), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.prepared_static_success](../TC/StaticBudget.md#decl-2a79f971d61c16c9), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.runBlocks_corrected_correct](../TC/Program/Correction.md#decl-5c2f929f60e023e5), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-c2651a1e8f74a14a"></a>

<details>
<summary><code>TensorCore.rneInt</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L16)

```lean
/-- Nearest integer with ties to even: floor, then a doubled-remainder comparison. -/
def rneInt (t : ℚ) : ℤ :=
  if 1 < 2 * (t - t.floor) ∨ (2 * (t - t.floor) = 1 ∧ t.floor % 2 = 1) then t.floor + 1
  else t.floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.rneInt_nat_div](../EFT/Machine/Dyadic.md#decl-a8bf3e6699d80787), [TensorCore.EFMachine.roundingCoefficient_convCoeff](../EFT/Machine/Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingCoefficient_spec](../EFT/Machine/Round.md#decl-23d703ce50cbcf2a), [TensorCore.IEEE.LeanBridge.accuracy_round_eq_rne](../IEEE/LeanRounding.md#decl-1e62b5285da24aef), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../IEEE/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](../IEEE/LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.firstPass32](../IEEE/LeanRounding.md#decl-1f3110087e3c2f88), [TensorCore.IEEE.LeanBridge.firstPass64](../IEEE/LeanRounding64.md#decl-25a14bb65450486f), [TensorCore.IEEE.LeanBridge.packRound32_eq](../IEEE/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../IEEE/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_eq](../IEEE/LeanBridge64.md#decl-0c708a8abb7275bb), [TensorCore.IEEE.LeanBridge.packRound64_reference](../IEEE/LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](../IEEE/LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.IEEE.LeanBridge.shifted_round_eq_rne](../IEEE/LeanRounding.md#decl-f6d8726852e1a50e), [TensorCore.IEEE.integerRound_unique](../IEEE/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.binaryCoefficient](Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryCoefficient_bounds](Binary/ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.binaryCoefficient_intCast](Binary/RoundTrip.md#decl-b8f8bffe28447932), [TensorCore.binaryCoefficient_le_integer](Binary/ConversionBounds.md#decl-e41347a8800b8463), [TensorCore.binaryCoefficient_nearestEven](Binary/CorrectRounding.md#decl-72bfac3090586308), [TensorCore.binary_rne_lower_binade_strict](Binary/CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_tie_even](Binary/CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.rneInt_cases](Rounding.md#decl-e5447611a083eb47), [TensorCore.rneInt_dist_le_half](Rounding.md#decl-926c4e219d946918), [TensorCore.rneInt_nearest](Rounding.md#decl-17ccd373bb12baa1), [TensorCore.rneInt_nonneg](Rounding.md#decl-6fb6bba59b59a133), [TensorCore.rneInt_tie_even](Rounding.md#decl-b3bf5bfe6d222ec7), [TensorCore.rne_grid_nearest](CorrectRounding.md#decl-2e1bab62ec0b2b78), [TensorCore.rne_grid_nearest_q](Binary/CorrectRounding.md#decl-ca751f6fe596d9e8), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5), [TensorCore.roundCoefficient_bounds](ConversionBounds.md#decl-73fca2c325f92d4a), [TensorCore.roundCoefficient_intCast](RoundTrip.md#decl-19d63265706221b3), [TensorCore.roundCoefficient_le_integer](ConversionBounds.md#decl-90034c8b2f8bb971), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.coefficient_error](../Gemm/ConversionBounds.md#decl-f64f69d45bdd3bc3), [TensorCore.coefficient_error](../Gemm/RoundingBudget.md#decl-f755f2a49fffbd90)

</details>

</details>

<a id="decl-7662cf06d1725fc5"></a>

<details>
<summary><code>TensorCore.roundCoefficient</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L21)

```lean
/-- Integer coefficient selected on a nonnegative scaled magnitude. -/
def roundCoefficient : RoundingMode → ℚ → ℤ
  | .towardZero, t => t.floor
  | .nearestEven, t => rneInt t
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.rneInt](RoundOp.md#decl-c2651a1e8f74a14a)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingCoefficient_convCoeff](../EFT/Machine/Round.md#decl-a55b48c044a3a9d5), [TensorCore.binaryCoefficient_intCast](Binary/RoundTrip.md#decl-b8f8bffe28447932), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundCoefficient_bounds](ConversionBounds.md#decl-73fca2c325f92d4a), [TensorCore.roundCoefficient_intCast](RoundTrip.md#decl-19d63265706221b3), [TensorCore.roundCoefficient_le_integer](ConversionBounds.md#decl-90034c8b2f8bb971), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf)

</details>

</details>

<a id="decl-d0b00fe98f5e4d15"></a>

<details>
<summary><code>TensorCore.magnitudeExponent</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L26)

```lean
/-- Called on positive magnitudes only; the public converter branches on zero first. -/
def magnitudeExponent (x : ℚ) : ℤ :=
  let e : ℤ := (x.num.natAbs.log2 : ℤ) - (x.den.log2 : ℤ)
  if x < pow2 e then e - 1 else e
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.magnitudeExponent_word](../EFT/Machine/Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.roundingGrid_convExp](../EFT/Machine/Round.md#decl-cf575f3a4700f276), [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](../IEEE/LeanRounding.md#decl-0ef7cbf9638ce869), [TensorCore.IEEE.LeanBridge.targetExponent32_eq](../IEEE/LeanRounding.md#decl-fe597c4119872d5a), [TensorCore.IEEE.LeanBridge.targetExponent64_eq](../IEEE/LeanRounding64.md#decl-459c5dd362ffb581), [TensorCore.IEEE.precisionMagnitude](../IEEE/Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.precisionMagnitude_correct](../IEEE/Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionMagnitude_le_max](../IEEE/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](../IEEE/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionMagnitude_positive](../IEEE/Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precisionRound_unique](../IEEE/Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](../IEEE/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../IEEE/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../IEEE/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.round_overflow_iff](../IEEE/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.binaryConvExp](Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.binaryConvExp_bounds](Binary/ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.convExp_le_of_lt](Rounding.md#decl-49ec78234aca30b2), [TensorCore.gemmConversion_error](../Gemm/ConversionBounds.md#decl-e310928c2b037b3f), [TensorCore.gemmConversion_mode_error](../Gemm/RoundingBudget.md#decl-d3d71a31e2b78bab), [TensorCore.magnitudeExponent_eq_of_bounds](Rounding.md#decl-bf009f29f695c88d), [TensorCore.magnitudeExponent_le_of_lt](Rounding.md#decl-1ab0c4e86c90f2f2), [TensorCore.magnitudeExponent_spec](Rounding.md#decl-22960168891fe5d1), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.magnitudeScale](../TC/Program/GroupAnalysis.md#decl-f9bf1f8eba9679a8), [TensorCore.magnitudeScale_spec](../TC/Program/GroupAnalysis.md#decl-d51d916c1a50ab6d), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.roundBinary_canonical](Binary/RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.scalarScale](../Gemm/ScalarAnalysis.md#decl-9699e837c1012c63), [TensorCore.scalarScale_spec](../Gemm/ScalarAnalysis.md#decl-ab7863fd9c2c72d3)

</details>

</details>

<a id="decl-2d041a1e685373ec"></a>

<details>
<summary><code>TensorCore.encode32</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L32)

```lean
/-- Bit pattern for sign, exponent `e`, and coefficient `k` on `2^(e-23)`. A coefficient
below `2^23` is the subnormal or zero range and requires `e = -126`. -/
def encode32 (negative : Bool) (e k : ℤ) : F32 :=
  BitVec.ofNat 32 ((if negative then 2 ^ 31 else 0) +
    (if k < 2 ^ 23 then k.toNat else (e + 127).toNat * 2 ^ 23 + (k - 2 ^ 23).toNat))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.encodeAtGrid_spec](../EFT/Machine/Round.md#decl-825e23e32bfda2dc), [TensorCore.EFMachine.encodeRounded_spec](../EFT/Machine/Round.md#decl-6aa1647dc1e12481), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.encode32_quantum](EncodingProperties.md#decl-6f10a9a038e29fd3), [TensorCore.encode32_toNat](EncodingProperties.md#decl-69d2d972fbf20b0d), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.encodeBinary_fp32](Binary/RoundOp.md#decl-28f15cc4c036f614), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.PaperSpec.encode32_sign](../TC/Specification/Rounding.md#decl-b87aa592b2f7ce0a)

</details>

</details>

<a id="decl-712564d4fa452350"></a>

<details>
<summary><code>TensorCore.convExp</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L37)

```lean
/-- Exponent selected for a positive magnitude, clamped to the subnormal range. -/
def convExp (m : ℚ) : ℤ := max (magnitudeExponent m) emin32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.emin32](RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.magnitudeExponent](RoundOp.md#decl-d0b00fe98f5e4d15)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.roundingCoefficient_convCoeff](../EFT/Machine/Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingGrid_convExp](../EFT/Machine/Round.md#decl-cf575f3a4700f276), [TensorCore.EFMachine.roundingGrid_div](../EFT/Machine/Round.md#decl-73afe430816bd696), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.convExp_bounds](ConversionBounds.md#decl-a4885e74ce89d102), [TensorCore.convExp_le_of_lt](Rounding.md#decl-49ec78234aca30b2), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_rtz_abs_le](../TC/Program/Bounds/Local.md#decl-b5d2bbed636879a7), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda)

</details>

</details>

<a id="decl-9af925aec44b7c00"></a>

<details>
<summary><code>TensorCore.convCoeff</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L40)

```lean
/-- Coefficient selected on the grid `2^(convExp m - 23)`. -/
def convCoeff (mode : RoundingMode) (m : ℚ) : ℤ :=
  roundCoefficient mode (m / pow2 (convExp m - 23))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.roundCoefficient](RoundOp.md#decl-7662cf06d1725fc5)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.roundingCoefficient_convCoeff](../EFT/Machine/Round.md#decl-a55b48c044a3a9d5), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.convCoeff_bounds](ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09), [TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-e870a105595fff5f"></a>

<details>
<summary><code>TensorCore.carry</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L44)

```lean
/-- A coefficient of `2^24` carries into the next binade. -/
def carry (e k : ℤ) : ℤ × ℤ := if k = 2 ^ 24 then (e + 1, k / 2) else (e, k)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.encodeRounded_spec](../EFT/Machine/Round.md#decl-6aa1647dc1e12481), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.carry_spec](ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64)

</details>

</details>

<a id="decl-a47adb12319758c3"></a>

<details>
<summary><code>TensorCore.round32Core</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L48)

```lean
/-- Conversion core. Exponent overflow is rejected; this is not a complete IEEE
exception/overflow policy. Use `round32` for the public finite-range contract. -/
def round32Core (mode : RoundingMode) (x : ℚ) : Option F32 :=
  if x = 0 then some 0
  else
    let (e', k') := carry (convExp (absQ x)) (convCoeff mode (absQ x))
    if e' > 127 then none else some (encode32 (decide (x < 0)) e' k')
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.carry](RoundOp.md#decl-e870a105595fff5f), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.encode32](RoundOp.md#decl-2d041a1e685373ec)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.Regression.finite_range_converter_policy](../TC/Regression/PublicDomains.md#decl-bf3a494234874689), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](RoundOp.md#decl-cd74c43ff6d7803c)

</details>

</details>

<a id="decl-11a6489236dbb65b"></a>

<details>
<summary><code>TensorCore.round32</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L57)

```lean
/-- Finite-range reference conversion. Magnitudes above `maxFinite32` are rejected
before conversion. Exact zero is +0; negative nonzero values rounded to zero keep
their sign. Extending the accepted range requires a separate overflow contract. -/
def round32 (mode : RoundingMode) (x : ℚ) : Option F32 :=
  if absQ x > maxFinite32 then none else round32Core mode x
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.corrected](../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.exactConsolidation](../EFT/Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](../EFT/Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarCorrectedUnchecked](../EFT/Extraction.md#decl-b298427558415577), [TensorCore.EFMachine.Components.scalar_correct](../EFT/Machine/Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.round32_correct](../EFT/Machine/Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_eq](../EFT/Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](../EFT/Machine/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.add32WithLean_eq](../EFT/Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](../EFT/Machine/Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.algorithm1WithLean_correct](../EFT/Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1_agrees](../EFT/Machine/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](../EFT/Machine/Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](../EFT/Machine/Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.algorithm1_range_iff](../EFT/Machine/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../EFT/Machine/Correctness.md#decl-56c6ead02b649bea), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](../EFT/ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](../IEEE/LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](../IEEE/LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.round32_finiteValue32](../IEEE/LeanFiniteAddition.md#decl-4eefaec604b419ba), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](../IEEE/LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.PaperSpec.Controls.ieeeAlignmentBits](../Regression/Specification/NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.Controls.noFloorBits](../Regression/Specification/NegativeControls.md#decl-617af7d5092e241f), [TensorCore.PaperSpec.Controls.normalizedBits](../Regression/Specification/NegativeControls.md#decl-e19ba3c5a394b16f), [TensorCore.PaperSpec.Controls.signed_zero_is_required](../Regression/Specification/NegativeControls.md#decl-1c0835dee2595631), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.PaperSpec.rounds_iff](../TC/Specification/Rounding.md#decl-aec56cebf6fd4fd1), [TensorCore.Program.vc_sound](../TC/Program/Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.eq20_public_corrects](../Regression/FoundationCompletion.md#decl-d2b5a2f26403185e), [TensorCore.Regression.finite_range_converter_policy](../TC/Regression/PublicDomains.md#decl-bf3a494234874689), [TensorCore.Regression.fp32_generic_agrees](../TC/Regression/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.out_of_range_rejected](../TC/Regression/Cases.md#decl-de4d74472a6abfec), [TensorCore.Regression.r4_binade_asymmetry](../TC/Regression/Cases.md#decl-dd87c11927efb30e), [TensorCore.Regression.r4_binade_carry](../TC/Regression/Cases.md#decl-3b313daa3dfd8b27), [TensorCore.Regression.r4_cancellation](../TC/Regression/Cases.md#decl-f5b3a2f370a66b02), [TensorCore.Regression.r4_even_tie](../TC/Regression/Cases.md#decl-bc54899e2865dcef), [TensorCore.Regression.r4_negative_zero](../TC/Regression/Cases.md#decl-1edb476558a306fe), [TensorCore.Regression.r4_odd_tie](../TC/Regression/Cases.md#decl-7d03f05653e1e285), [TensorCore.Regression.r4_subnormal_boundary](../TC/Regression/Cases.md#decl-9a49c360edf3a319), [TensorCore.Regression.r4_zero_tie](../TC/Regression/Cases.md#decl-54a7f4f8fbe4a04d), [TensorCore.Regression.scalar64_double_rounding_incorrect](../EFT/Regression/ScalarEFT.md#decl-75316677317adbed), [TensorCore.algorithm1Encoded_agrees](../EFT/Encoded.md#decl-7c68f1eaf0403ab9), [TensorCore.algorithm1_bits_eq_round](../EFT/Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_local_error](../TC/Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_static_error_bound](../TC/StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.canonical_padding_output](../TC/Padding.md#decl-2108e38788477de9), [TensorCore.canonical_source_padding_output](../TC/Padding.md#decl-5bdc8050550eb3f9), [TensorCore.checkGroup_sound](../TC/Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.correctedSchedule](../TC/Program/Correction.md#decl-968ff850f4220ec9), [TensorCore.correctedSchedule_correct](../TC/Program/Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](../TC/Program/Correction.md#decl-ee6543cdd6791a37), [TensorCore.corrected_eq_round_exactDot](../TC/StageResiduals.md#decl-4f25be9ce5c88c41), [TensorCore.evalBlock_exact_alignment](../TC/ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_static](../TC/StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.evalPrepared](../TC/Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](../TC/Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](../TC/MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](../TC/StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](../TC/ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.finalRound_correct](CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp32Add](ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.fp32Add_exact](ScalarSum.md#decl-91c0a32b3579d248), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.representable32](ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.representable32_finite](ScalarSum.md#decl-04f29e613917ad68), [TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_range](RoundOp.md#decl-cd74c43ff6d7803c), [TensorCore.round32_rtz_abs_le](../TC/Program/Bounds/Local.md#decl-b5d2bbed636879a7), [TensorCore.round32_rtz_error_of_scale](../TC/Program/Bounds/Local.md#decl-3de60de11d813601), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.roundBinary_fp32](Binary/RoundOp.md#decl-11e910ef6ebcee78), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](../EFT/Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_eq](../EFT/Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrectedIn_fp32_of_predicate](../EFT/Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarCorrected_eq](../EFT/Extraction.md#decl-f5da772603f2c94b), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.tceft_eq_corrected](../EFT/Extraction.md#decl-942f125d26cb2d1b), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.value32_injective](RoundTrip.md#decl-c92b8ed7f76cc40c), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-70bb2de461b51682"></a>

<details>
<summary><code>TensorCore.outputQuantumExponent</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L62)

```lean
/-- Exponent of the quantum of an encoded output: `E - 150` for a normal encoding with
exponent field `E`, and `-149` for a subnormal or zero encoding. -/
def outputQuantumExponent (b : F32) : ℤ :=
  max (((b.toNat / 2 ^ 23 % 2 ^ 8 : ℕ) : ℤ) - 127) emin32 - 23
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.emin32](RoundOp.md#decl-db1578f6a47fc8b5)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.defaultExtraction](../EFT/ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.errorBudget](../TC/Program/ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.BlockTrace.extractionExponent](../EFT/Defs.md#decl-f4644e4a3c22871b), [TensorCore.EFMachine.outputGrid_spec](../EFT/Machine/Grid.md#decl-966f710cc75730bb), [TensorCore.EFMachine.selectedGrid_spec](../EFT/Machine/Grid.md#decl-31f8d745f2b97769), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.encode32_quantum](EncodingProperties.md#decl-6f10a9a038e29fd3), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.overlap_window_width](../EFT/Algorithm1.md#decl-b8a661b7258cdacc), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478)

</details>

</details>

<a id="decl-cd74c43ff6d7803c"></a>

<details>
<summary><code>TensorCore.round32_range</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L66)

```lean
/-- Success in the public conversion implies the *accumulator* range condition. -/
theorem round32_range {mode : RoundingMode} {x : ℚ} {b : F32}
    (h : round32 mode x = some b) : absQ x ≤ maxFinite32 := by
  unfold round32 at h
  split at h
  · contradiction
  · grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](RoundOp.md#decl-a47adb12319758c3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_correct](../EFT/Machine/Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_isSome_iff](../EFT/Machine/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.algorithm1_range_iff](../EFT/Machine/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.round32_sign](../TC/Specification/Rounding.md#decl-f93b23e259cce9bf), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.evalBlock_success_iff](../TC/AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea)

</details>

</details>

<a id="decl-5eba0588921ede09"></a>

<details>
<summary><code>TensorCore.magnitudeRounded</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L73)

```lean
def magnitudeRounded (mode : RoundingMode) (m : ℚ) : ℚ :=
  (convCoeff mode m : ℚ) * pow2 (convExp m - 23)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.convCoeff](RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](RoundOp.md#decl-712564d4fa452350), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.magnitudeRounded_rtz_monotone](../TC/Flowback.md#decl-baefc4c567a5cd91), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.rne_lower_binade_strict](CorrectRounding.md#decl-8a3cc46b2fb434de), [TensorCore.rne_magnitude_nearest](CorrectRounding.md#decl-530f2f5b5e7938cb), [TensorCore.rne_magnitude_tie_even](CorrectRounding.md#decl-9a2b59ee0932b165), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.rtz_magnitude_residual](RoundingError.md#decl-4b7a39e93165716b), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded](RoundOp.md#decl-68ebd78aa09fbefc), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-68ebd78aa09fbefc"></a>

<details>
<summary><code>TensorCore.signedRounded</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L76)

```lean
def signedRounded (mode : RoundingMode) (x : ℚ) : ℚ :=
  if x < 0 then -magnitudeRounded mode (absQ x) else magnitudeRounded mode (absQ x)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeRounded](RoundOp.md#decl-5eba0588921ede09)

<details>
<summary>Used by</summary>

[TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](../TC/Flowback.md#decl-b0715c384a285eb0), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_condition](../TC/Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.round32_rtz_truncGrid](../TC/Program/Bounds/Local.md#decl-0342238d71ef1dea), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.rtz_signed_residual](RoundingError.md#decl-6594122b1c5d4243), [TensorCore.signedRounded_nearest](CorrectRounding.md#decl-9faaf61526f9495d), [TensorCore.signedRounded_rtz_monotone](../TC/Flowback.md#decl-561aeb37f020d4bf), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.signedRounded_tie_even](CorrectRounding.md#decl-9ff415905688cc20)

</details>

</details>

<a id="decl-e8aa71a6813779de"></a>

<details>
<summary><code>TensorCore.NearestEven32</code></summary>

[Lean source](../../../TensorCore/Core/RoundOp.lean#L81)

```lean
/-- Independent mathematical contract: finite result, nearest finite value, and an
even low encoding bit whenever another distinct value is equally near. -/
def NearestEven32 (x : ℚ) (b : F32) : Prop :=
  ∃ d : ℚ, value32 b = some d ∧
    (∀ y : ℚ, FiniteValue32 y → absQ (x - d) ≤ absQ (x - y)) ∧
    (∀ y : ℚ, FiniteValue32 y → y ≠ d →
      absQ (x - y) = absQ (x - d) → b.toNat % 2 = 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_correct](../EFT/Machine/Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_isSome_iff](../EFT/Machine/Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.algorithm1WithLean_success](../EFT/Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_range_iff](../EFT/Machine/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../EFT/Machine/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](../EFT/Machine/Success.md#decl-5145abbc51875848), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_isSome_iff](../EFT/ExtractionGrid.md#decl-2a11ac5f9735f162), [TensorCore.Program.Correct](../TC/Program/Defs.md#decl-e6d61788143fb846), [TensorCore.Program.vc_sound](../TC/Program/Defs.md#decl-6bd1edcfd2f397a0), [TensorCore.Regression.fp32_generic_agrees](../TC/Regression/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.algorithm1_exact_iff](../EFT/Algorithm1.md#decl-b5fbc137128bfc29), [TensorCore.correctedSchedule_correct](../TC/Program/Correction.md#decl-c5490d1a25901294), [TensorCore.corrected_correct](../TC/Program/Correction.md#decl-ee6543cdd6791a37), [TensorCore.evalBlock_corrected_correct](../TC/Program/Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.finalRound_correct](CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.fp32_nearestEven](Binary/CorrectRounding.md#decl-b9ecfe2e37db1cfd), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.runBlocks_corrected_correct](../TC/Program/Correction.md#decl-5c2f929f60e023e5), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_isSome_iff](../EFT/Scalar.md#decl-a76f1dddc089a764), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.tceft_correct](../EFT/Extraction.md#decl-4cc1687d08757464), [TensorCore.tceft_isSome_iff](../EFT/Extraction.md#decl-bf4ac7118d2101bc)

</details>

</details>
