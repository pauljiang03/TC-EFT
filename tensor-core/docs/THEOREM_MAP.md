# Theorem map

All names are under `TensorCore` or `TensorCore.Regression`.

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
| Encoded-input evaluator recovery | `evalBlock_residual_identity` | Successful `evalBlock x` under any profile; `exactDot x` equals output plus returned residual; proved |
| Correction and executable rounding agree | `corrected_eq_round_exactDot` | Substitution only; not a nearest-value result |
| Arbitrary schedule ledger | `fold_residual_ledger` | Any state space, fixed contributions, supplied local law; induction over any finite list |
| Encoded trace ledger | `encoded_trace_ledger` | `EncodedChain` premise links decoded encoded boundaries; proved |
| Evaluator establishes chain | `runBlocks_chain` | Any successful finite `runBlocks`; proved |
| Executable schedule ledger | `runBlocks_residual_ledger` | Any successful finite schedule and finite initial encoding; proved |
| Finite decoded values have bounded arithmetic form | `decode32_finite`, `value32_finite` | All finite FP32 encodings; proved |
| Bounded encoding value, parity, quantum | `encode32_toNat`, `encode32_value`, `encode32_quantum` | Explicit exponent, coefficient, and subnormal bounds; proved |
| Nearest-even integer selection | `rneInt_nearest`, `rneInt_tie_even` | Every rational input and competing integer; proved |
| Exponent selection | `magnitudeExponent_spec` | Every positive rational; proved |
| Conversion bounds and carry | `convExp_bounds`, `convCoeff_bounds`, `carry_spec` | Positive finite-range magnitude and bounded coefficient; proved |
| Converter returns its selected grid value | `round32_nonzero_spec` | Nonzero rational x, `absQ x ≤ maxFinite32`, RTZ or RNE; proved |
| Nearest-even FP32 correctness | `round32_nearestEven_correct`, `finalRound_correct` | Every rational x with `absQ x ≤ maxFinite32`; finite output, nearest value, even encoding bit at ties between distinct values; proved |
| Corrected block is correctly rounded | `corrected_correct`, `evalBlock_corrected_correct` | Successful evaluation and independent `exactDot x` in range; proved |
| Corrected schedule is correctly rounded | `correctedSchedule_correct`, `runBlocks_corrected_correct` | Encoded chain or successful finite schedule, final exact sum in range; exact rational consolidation; proved |
| Output truncation loss | `output_residual_bound` | Successful finite-range RTZ conversion; strict bound by the encoded output quantum; proved |
| Aggregate alignment loss | `block_alignment_bound` | Every prepared block; the term count includes c; proved |
| Two-stage model error | `block_error_bound`, `evalBlock_error_bound` | Finite-range RTZ output or successful evaluator; `abs(S − d) < n·qA + qO`; proved |
| Same product values, different output | `Regression.r1_equal_product_values`, `r1_factorization_changes_output` | Actual FP16/FP32 encodings; kernel-checked |
| Complete R1–R3 traces | `Regression.r1a_trace`, `r1b_trace`, `r2_trace`, `r3_trace` | Exact scales, coefficients, residuals, output; kernel-checked |
| Zero correction in R2 | `Regression.r2_correction_unchanged` | Kernel-checked |
| R4 corrected midpoint | `Regression.r4_binade_asymmetry`, `r4_midpoint_distances` | Kernel-checked |
| Rounding boundary cases | `Regression.r4_*` | Ties, parity, carry, cancellation, underflow, signed zero; kernel-checked |
| Concrete non-monotonicity | `Regression.v100_nonmonotonicity_witness` | TC-EFT III.4 V100 instance; kernel-checked, no universal threshold |
| Two-invocation cancellation | `Regression.two_block_cancellation` | Final output −2^-20; ledger recovers −2^-24; kernel-checked |
| Executable schedule correction | `Regression.two_block_corrected` | Corrected two-block output `b3800000`; kernel-checked |
| Schedule products equal original-input contributions | `runBlocks_idealContributions` | Every successful finite schedule; proved |
| AST recovery of the independent ideal | `Program.recovery` | Typed fixed-input program, finite initial value, successful execution; proved |
| Program checking soundness | `Program.vc_sound` | `Program.VC` implies success, exact recovery, and nearest-even final correction; proved |
| Diagnostics preserve semantics | `runLocated_erases` | Arbitrary located call list; proved |
| Report and checker agree | `Program.report_accepts_iff` | Report success iff `Program.VC`; proved |
| Sequential execution | `runBlocks_append` | Two successful schedules joined at the actual encoded boundary; proved |
| Symbolic cycle iteration | `runBlocks_repeat_invariant`, `Program.repeat_vc_of_cycle` | Any iteration count; body preserves the encoded state; the VC rule also needs a zero ledger and initial range; induction |
| Generated DSL correctness | `Regression.cancellation_program_correct`, `repeated_program_correct`, `zero_iterations_correct` | `tc_verify` applies `Program.vc_sound` to kernel-checked conditions |
| Generated symbolic-loop correctness | `Regression.symbolic_cycle_correct` | Every iteration count; explicit inductive VC proof supplied |
| Intended elaboration and failure behavior | `Regression.cancellation_program_inputs`, `nested_program_order`, `symbolic_syntax_inputs`, `rejected_program_location`, `final_range_rejected` | Operand order, nested and symbolic iteration, diagnostics, final range rejection; kernel-checked |

`Profile` covers only the input format, product count, alignment fraction, and floor, so
generic theorems over it do not cover every feature in the source. Next targets are listed in
[ROADMAP.md](ROADMAP.md); no placeholder declaration stands in for them.
