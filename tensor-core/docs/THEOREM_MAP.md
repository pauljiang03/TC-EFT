# Theorem map

All names are under `TensorCore` or `TensorCore.Regression`.

## V100 block, rounding, and correction

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| Raw product preserves value | `rawProduct_value` | All decoded integer/scale records; proved |
| Common-grid integer accumulation | `sum_coefficients`, `accumulator_value` | Arbitrary finite lists; exact unbounded Int; proved |
| Raw product terms equal direct ideal sum | `terms_value` | All prepared blocks; proved |
| Alignment grid semantics | `alignment_value` | Definitional bridge |
| Signed alignment residual bound | `alignment_residual_bounds`, `alignment_residual` | All rationals, every integer grid exponent; proved |
| Stage decomposition | `sum_stage_residuals` | Arbitrary rational list and alignment function; induction |
| Reference recovery | `block_residual_identity` | Any prepared block and supplied rational d, no conformance hypothesis; proved |
| Returned trace recovery | `returned_residual_identity`, `recovered_eq_exactDot` | Every well-typed trace has a finite encoded output; proved |
| Encoded-input evaluator recovery | `evalBlock_residual_identity` | Successful `evalBlock x` under any profile; proved |
| Correction and executable rounding agree | `corrected_eq_round_exactDot` | Substitution only; not a nearest-value result |
| Finite decoded values have bounded arithmetic form | `decode32_finite`, `value32_finite` | All finite FP32 encodings; proved |
| Bounded encoding value, parity, quantum | `encode32_toNat`, `encode32_value`, `encode32_quantum` | Explicit exponent, coefficient, and subnormal bounds; proved |
| Nearest-even integer selection | `rneInt_nearest`, `rneInt_tie_even` | Every rational input and competing integer; proved |
| Exponent selection | `magnitudeExponent_spec` | Every positive rational; proved |
| Conversion bounds and carry | `convExp_bounds`, `convCoeff_bounds`, `carry_spec` | Positive finite-range magnitude and bounded coefficient; proved |
| Converter returns its selected grid value | `round32_nonzero_spec` | Nonzero rational x, `absQ x ≤ maxFinite32`, RTZ or RNE; proved |
| Nearest-even FP32 correctness | `round32_nearestEven_correct`, `finalRound_correct` | Every rational x with `absQ x ≤ maxFinite32`; finite output, nearest value, even encoding bit at ties between distinct values; proved |
| Corrected block is correctly rounded | `corrected_correct`, `evalBlock_corrected_correct` | Successful evaluation and independent `exactDot x` in range; proved |
| Output truncation loss | `output_residual_bound` | Successful finite-range RTZ conversion; strict bound by the encoded output quantum; proved |
| Aggregate alignment loss | `block_alignment_bound` | Every prepared block; the term count includes c; proved |
| Two-stage model error | `block_error_bound`, `evalBlock_error_bound` | Finite-range RTZ output or successful evaluator; `abs(S − d) < n·qA + qO`; proved |

## Parameterized family and machine width

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| All-zero group characterization | `alignmentScale_none` | Any term list; proved |
| Every nonzero term's raw scale is at most η | `eta_term` | Any prepared block; proved |
| Decoded operands and raw products are bounded by their scale | `operand_decode_bounded`, `rawMul_bounded`, `prepare_terms_bounded` | Any IEEE-style or padded encoding; proved |
| Each aligned coefficient is below `2^(F+2)` | `aligned_term_coefficient_bound` | Bounded term with scale at most η; proved |
| Modular signed-word accumulation is exact, every prefix | `machineAccumulate_eq`, `machineAccumulate_exact`, `machineAccumulate_prefix_exact`, `coefficient_width_sufficient` | Magnitude sum below `2^(w−1)`; proved |
| Derived machine width for a successful block | `evalBlock_machineAccumulator`, `evalV100_machineAccumulator` | `F + 2 + carry + 1` bits; 29 for V100; proved |
| Contract for any product count and extra bits | `fp16Fp32_contract` | Recovery, output equation, error bound, machine width `26 + extra + carry`; proved |
| Ampere and Hopper machine widths | `ampere_machineAccumulator`, `hopper_machineAccumulator` | 31 and 33 bits; proved |
| Floors at or below −126 are inactive | `canonical_eta_floor_inactive`, `prepare_fp16_terms_lower`, `alignmentScale_lower` | FP16 operands and FP32 c; proved |
| Padded operand words require zero padding | `packedIEEE_decode`, `padded_decode_requires_zero` | TF32-in-FP32 storage; proved |

## Generalized invocation evaluator

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| General converter agrees with `round32` on FP32 | `roundBinary_fp32`, `roundBinary_range` | FP32 only; other formats have no correctness proof |
| Ordered conversion stages telescope with retained losses | `conversionStage_output`, `runConversions_recovery`, `runConversions_events` | Any stage list; proved |
| Successful evaluation certifies every stage | `evalInvocation_spec`, `evalInvocation_output` | Any `InvocationSpec`; proved |
| Original-bit ideal equals output plus all local losses | `evalInvocation_recovery` | Any `InvocationSpec`, including late c and the fused variant; proved |
| Agreement with the original evaluator, including rejection | `legacy_invocation_bits`, `v100_invocation_bits`, `fp16Fp32_invocation_compatible` | Any profile with a well-formed format and positive K; proved |

## Schedules and programs

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| Arbitrary schedule ledger | `fold_residual_ledger` | Any state space, fixed contributions, supplied local law; induction over any finite list |
| Encoded trace ledger | `encoded_trace_ledger` | `EncodedChain` premise links decoded encoded boundaries; proved |
| Evaluator establishes chain | `runBlocks_chain` | Any successful finite `runBlocks`; proved |
| Executable schedule ledger | `runBlocks_residual_ledger` | Any successful finite schedule and finite initial encoding; proved |
| Corrected schedule is correctly rounded | `correctedSchedule_correct`, `runBlocks_corrected_correct` | Final exact sum in range; exact rational consolidation; proved |
| Schedule products equal original-input contributions | `runBlocks_idealContributions` | Every successful finite schedule; proved |
| AST recovery of the independent ideal | `Program.recovery` | Typed fixed-input program, finite initial value, successful execution; proved |
| Program checking soundness | `Program.vc_sound` | `Program.VC` implies success, exact recovery, and nearest-even final correction; proved |
| Diagnostics preserve semantics | `runLocated_erases` | Arbitrary located call list; proved |
| Report and checker agree | `Program.report_accepts_iff` | Report success iff `Program.VC`; proved |
| Sequential execution | `runBlocks_append` | Two successful schedules joined at the actual encoded boundary; proved |
| Symbolic cycle iteration | `runBlocks_repeat_invariant`, `Program.repeat_vc_of_cycle` | Any iteration count; body preserves the encoded state; the VC rule also needs a zero ledger and initial range; induction |

## Kernel-checked cases

| Case | Declaration |
| --- | --- |
| Same product values, different output | `Regression.r1_equal_product_values`, `r1_factorization_changes_output` |
| Complete R1–R3 traces | `Regression.r1a_trace`, `r1b_trace`, `r2_trace`, `r3_trace` |
| Zero correction in R2 | `Regression.r2_correction_unchanged` |
| R4 corrected midpoint | `Regression.r4_binade_asymmetry`, `r4_midpoint_distances` |
| Rounding boundary cases | `Regression.r4_*` |
| Concrete non-monotonicity, TC-EFT III.4 on V100 | `Regression.v100_nonmonotonicity_witness` |
| Two-invocation cancellation and correction | `Regression.two_block_cancellation`, `two_block_corrected` |
| One extra alignment bit changes the output | `Regression.extra_alignment_bit_matters` |
| Ampere, Hopper, and a non-hardware profile evaluate | `Regression.canonical_profile_results` |
| Signed-word prefix wrap example | `Regression.signed_capacity_prefix` |
| Generated DSL correctness | `Regression.cancellation_program_correct`, `repeated_program_correct`, `zero_iterations_correct`, `symbolic_cycle_correct` |
| Intended elaboration and failure behavior | `Regression.cancellation_program_inputs`, `nested_program_order`, `symbolic_syntax_inputs`, `rejected_program_location`, `final_range_rejected` |

Next targets are listed in [PLAN.md](PLAN.md); no placeholder declaration stands in for them.
