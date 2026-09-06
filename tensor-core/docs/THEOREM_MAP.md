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
| Returned trace recovery | `returned_residual_identity`, `recovered_eq_exactDot` | Every well-typed trace; proved |
| Encoded-input evaluator recovery | `evalBlock_residual_identity` | Successful `evalBlock x` under any profile; proved |
| Correction and executable rounding agree | `corrected_eq_round_exactDot` | Substitution only |
| Finite decoded values have bounded arithmetic form | `decode32_finite`, `value32_finite` | All finite FP32 encodings; proved |
| Bounded encoding value, parity, quantum | `encode32_toNat`, `encode32_value`, `encode32_quantum` | Explicit exponent, coefficient, and subnormal bounds; proved |
| Nearest-even integer selection | `rneInt_nearest`, `rneInt_tie_even` | Every rational input and competing integer; proved |
| Exponent selection | `magnitudeExponent_spec`, `magnitudeExponent_eq_of_bounds` | Every positive rational; proved |
| Conversion bounds and carry | `convExp_bounds`, `convCoeff_bounds`, `carry_spec` | Positive finite-range magnitude and bounded coefficient; proved |
| Converter returns its selected grid value | `round32_nonzero_spec` | Nonzero rational x in range, RTZ or RNE; proved |
| Nearest-even FP32 correctness | `round32_nearestEven_correct`, `finalRound_correct` | Every rational x with `absQ x ≤ maxFinite32`; proved |
| Corrected block is correctly rounded | `corrected_correct`, `evalBlock_corrected_correct` | Successful evaluation and independent ideal in range; proved |
| Output truncation loss; aggregate alignment loss; two-stage error | `output_residual_bound`, `block_alignment_bound`, `block_error_bound`, `evalBlock_error_bound` | `abs(S − d) < n·qA + qO`; proved |

## Parameterized family, accepted domain, machine width, padding

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| All-zero group; every nonzero term's scale is at most η; upper bound on η | `alignmentScale_none`, `eta_term`, `alignmentScale_upper`, `eta_upper` | Any term list; proved |
| Decoded operands and raw products are bounded by their scale | `operand_decode_bounded`, `rawMul_bounded`, `prepare_terms_bounded` | Any IEEE-style or padded encoding; proved |
| Each aligned coefficient is below `2^(F+2)` | `aligned_term_coefficient_bound`, `prepare_coefficient_capacity`, `evalBlock_coefficient_capacity` | Bounded term with scale at most η; proved |
| Modular signed-word accumulation is exact, every prefix | `machineAccumulate_exact`, `machineAccumulate_prefix_exact`, `coefficient_width_sufficient`, `evalBlock_machinePrefix` | Magnitude sum below `2^(w−1)`; proved |
| Machine evaluator returns the same complete result as the reference | `evalPreparedMachine_eq`, `evalBlockMachine_eq`, `fp16Fp32_machine_eq`, `v100_machine_eq`, `ampere_machine_eq`, `hopper_machine_eq` | Any width `w ≥ 26 + extra + carryBits`; includes rejections; proved |
| Contract for any product count and extra bits | `fp16Fp32_contract` | Recovery, output equation, error bound, machine width; proved |
| Exact accepted domain | `evalBlock_success_iff`, `evalPrepared_total`, `round32_finite_exists` | Success iff shape, finite operands, and accumulator in range; proved |
| Floors at or below −126 are inactive | `canonical_eta_floor_inactive`, `prepare_fp16_terms_lower`, `alignmentScale_lower` | FP16 operands and FP32 c; proved |
| Input-specific exact alignment | `PreparedBlock.AlignmentExact`, `exact_alignment_accumulator`, `evalBlock_exact_alignment`, `truncGrid_exact_of_grid` | Grid at most every term grid; output is one RTZ of the ideal; proved |
| Sufficient padding thresholds | `canonical_source_padding_exact` (`extra ≥ 156`, floors ≤ 30), `canonical_padding_exact` (`extra ≥ 253`, floors ≤ 127), with `_accumulator`, `_output`, `_success_iff` corollaries | Every finite canonical input, any K; sufficient, not minimal; proved |
| Term metadata bounds | `classifyNat_metadata`, `prepare_fp16_term_metadata`, `prepare_fp16_products_metadata` | FP16 products and FP32 c; proved |
| Padded operand words require zero padding | `packedIEEE_decode`, `padded_decode_requires_zero` | TF32-in-FP32 storage; proved |

## Scalar EFT (TC-EFT §IV)

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| Every finite FP32 value is within `maxFinite32` | `finiteValue32_abs_le` | proved |
| Lemma IV.7: a representable exact sum is returned exactly | `round32_exact_of_finite`, `fp32Add_exact` | Any representable value; proved |
| Grid multiples with fewer than 24 significant bits are representable | `grid_finiteValue32` | `-149 ≤ ℓ ≤ 104`; proved |
| Theorem IV.8: naive FP32 summation on one grid is exact | `naiveSum32_exact` | Coefficient magnitude sum below `2^24`; every prefix; proved |
| Lemma IV.1: low components are below the extraction grid | `lowPart_bound` | Any trace; proved |
| Theorem IV.5, overlap form: `S = D − ε_o + Σ εᵢ` | `overlap_recovery` | Any trace; proved |
| Executable representability implies representability | `representable32_finite` | proved |
| IV.9–IV.10: under the predicate the scalar branch computes `RN(S)` | `scalarCorrected_eq` | Predicate on the actual components; proved |
| Corollary IV.11: the scalar branch is correctly rounded | `scalarCorrected_correct` | proved |
| Lemmas IV.3–IV.4: a coarse low part is its retained part on the alignment grid plus the alignment residual; `ε_o = Σ φ(εᵢ) − r_out` | `truncGrid_split`, `accumulator_eq_retained`, `overlap_eq_retained_sub_outputResidual` | Any trace; proved |
| The scalar EFT returns a result exactly when its predicate holds; every result is correctly rounded and equals the exact-rational reference | `tceft_isSome_iff`, `tceft_correct`, `tceft_eq_corrected`, `evalBlock_tceft_correct` | proved |

## Non-monotonicity (TC-EFT §III)

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| Grid multiples keep their coefficient under truncation | `truncCoeff_of_grid` | proved |
| Alignment exponent and accumulators of the construction | `construction_eta`, `construction_accumulator_one`, `construction_accumulator_below` | Any profile with `F = 23 + p`, floor ≤ −1; proved |
| Theorem III.4 | `nonmonotone_perturbation` | `K < 2^(24+p)` products `2^-(24+p)` with raw scale ≤ −1; output rises iff `K ≥ 3·2^p`; proved |
| Encoded-operand form on the canonical family | `prepareProducts_replicate`, `nonmonotone_encoded` | Any `K`, `p`, floor ≤ −1; proved |
| Source-path families | `nonmonotone_v100_family`, `nonmonotone_ampere_family`, `nonmonotone_hopper_family` | Thresholds 3, 6, 12; proved |
| Floor of a natural number scaled by `2^-d` | `floor_eq_of_bounds`, `floor_natCast_mul_pow2_neg` | proved |
| Theorem III.5: with `c_j = 1 − j·2^-24`, the output rises iff `(j + 2)·2^p ≤ K`; output `1 + 2^-23·⌊(K − j·2^p)/2^(p+1)⌋` when `j·2^p ≤ K`; maximum at `j = 1` | `construction_accumulator_range`, `nonmonotone_range`, `nonmonotone_range_iff` | `1 ≤ j ≤ 2^23`, same family as III.4; proved |
| Encoded form: `c_j` has bits `3f800000 − j` | `decode32_below`, `nonmonotone_range_encoded`, `nonmonotone_range_v100_family`, `nonmonotone_range_ampere_family`, `nonmonotone_range_hopper_family` | proved |

## Generalized invocation evaluator

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| General converter agrees with `round32` on FP32 | `roundBinary_fp32`, `roundBinary_range` | FP32 only; other formats have no correctness proof |
| Ordered conversion stages telescope with retained losses | `conversionStage_output`, `runConversions_recovery`, `runConversions_events` | Any stage list; proved |
| Successful evaluation certifies every stage; exact loss accounting | `evalInvocation_spec`, `evalInvocation_output`, `evalInvocation_recovery` | Any `InvocationSpec`; proved |
| Agreement with the original evaluator, including rejection | `legacy_invocation_bits`, `v100_invocation_bits`, `fp16Fp32_invocation_compatible` | Any profile with a well-formed format and positive K; proved |

## Round trip and instruction paths

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| Field decomposition of a finite FP32 encoding | `decode32_fields` | Zero, subnormal, and normal cases; proved |
| The converter returns the canonical encoding of any nonzero representable value | `round32_canonical` | Both modes; proved |
| Converting a nonzero finite value returns its own bits | `value32_round32` | Both modes; proved |
| Nonzero finite values have unique encodings | `value32_injective` | proved |
| Zero-value encodings other than `−0` are `+0` | `zero_value_bits` | proved |
| Contiguous grouping of an instruction's operands | `chunks_flatten`, `chunks_first_group`, `chunks_replicate`, `InstructionPath.schedule_flatten` | `N_FMA ∣ k`; proved |
| A group of zero products passes its accumulator through | `zero_products_eta`, `zero_products_passthrough`, `runBlocks_zero_groups` | Finite accumulator other than `−0`; floors at most −126; proved |
| An instruction runs on exactly `k` operands | `InstructionPath.run_length`, `InstructionPath.run_blocks` | Other counts are rejected; proved |
| Under conformance, a device result is the model's last group output and obeys the composed error bound | `conforms_uncorrected_error` | `Conforms path device` (agreement on the model's accepted domain) as an explicit premise; proved |
| Single-group inputs reproduce the first group's output on the whole instruction | `single_group_output` | First group's output not `−0`; proved |
| Pinned paths | `v100Wmma16` (4 × 4), `ampereWmma16` (2 × 8), `hopperWmma16` (1 × 16) | Descriptors with sources; `tc_instruction` refuses other names |

## Schedules, long dot products, and programs

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| Arbitrary schedule ledger | `fold_residual_ledger`, `encoded_trace_ledger`, `runBlocks_chain`, `runBlocks_residual_ledger` | Any successful finite schedule; proved |
| Corrected schedule is correctly rounded | `correctedSchedule_correct`, `runBlocks_corrected_correct` | Final exact sum in range; proved |
| Schedule products equal original-input contributions | `runBlocks_idealContributions`, `idealContributions_flatten` | Every successful finite schedule; proved |
| Local error budget and composed uncorrected error | `evalBlock_residual_bound`, `runBlocks_residual_budget`, `runBlocks_uncorrected_error`, `Program.uncorrected_error` | Sum of trace budgets; strict for nonempty schedules; proved |
| Ordered partition of a long dot product | `OrderedPartition.input_count`, `OrderedPartition.ideal`, `OrderedPartition.uncorrected_error` | Supplied contiguous fixed-size groups; proved |
| Executable partition with tail padding | `partitionExact_count`, `padded_length`, `tailPadding_lt`, `canonicalPartition_count`, `idealProducts_padFp16Pairs`, `canonicalPartition_ideal` | Zero pairs only on a partial tail; ideal preserved; proved |
| Constructed long dot product | `runCanonicalDot_count`, `runCanonicalDot_uncorrected_error`, `runCanonicalDot_uncorrected_error_strict`, `runCanonicalDot_machine_eq` | proved |
| Machine equivalence through schedules | `runBlocksMachine_eq`, `fp16Fp32_schedule_machine_eq` | Every encoded boundary, including failures; proved |
| AST recovery, checker soundness, diagnostics | `Program.recovery`, `Program.vc_sound`, `runLocated_erases`, `Program.report_accepts_iff` | proved |
| Sequential execution and symbolic cycle iteration | `runBlocks_append`, `runBlocks_repeat_invariant`, `Program.repeat_vc_of_cycle` | Any iteration count; induction |

## Kernel-checked cases

| Case | Declaration |
| --- | --- |
| Same product values, different output; complete R1–R3 traces; R2 zero correction | `Regression.r1_*`, `r2_*`, `r3_trace` |
| R4 corrected midpoint and rounding boundaries | `Regression.r4_*` |
| One extra alignment bit changes the output; padding and range boundaries | `Regression.extra_alignment_bit_matters`, `padding_range_boundary`, `source_padding_boundary` |
| Machine width changes the result when undersized | `Regression.machine_width_changes_result`, `signed_capacity_prefix` |
| Ampere, Hopper, and a non-hardware profile evaluate | `Regression.canonical_profile_results` |
| Two-invocation cancellation and correction; partition order changes output | `Regression.two_block_cancellation`, `two_block_corrected`, `partition_original_order`, `partition_order_changes_output`, `partition_error_contract`, `constructed_partition_*` |
| EFT on R2, R3, the paper's cancellation example, and two predicate rejections | `Regression.r2_eft`, `r3_eft`, `cancellation_eft`, `predicate_rejected`, `subnormal_accumulator_rejected` |
| TC-EFT Table III witnesses, below-threshold monotone cases, III.5 ranges and extrema | `Regression.v100_nonmonotonicity_witness`, `table_iii_witnesses`, `below_threshold_monotone`, `range_witnesses`, `range_extrema_k5` |
| Instruction paths: padded single group equals one group, two Ampere groups, one Hopper group, group order observable, wrong width rejected in both directions | `Regression.v100_instruction_single_group`, `ampere_instruction_two_groups`, `hopper_instruction_one_group`, `ampere_instruction_order_matters`, `instruction_wrong_width` |
| Generated DSL correctness and intended elaboration | `Regression.cancellation_program_correct`, `repeated_program_correct`, `zero_iterations_correct`, `symbolic_cycle_correct`, `nested_program_order`, `rejected_program_location`, `final_range_rejected` |

Next targets are listed in [PLAN.md](PLAN.md); no placeholder declaration stands in for them.
