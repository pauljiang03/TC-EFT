# Numerical contracts and Lean declarations

All names below are under `TensorCore` (or `TensorCore.Regression`).

| Contract | Declaration | Domain and status |
| --- | --- | --- |
| Raw product preserves value | `rawProduct_value` | All decoded integer/scale records; proved |
| Common-grid integer accumulation | `sum_coefficients`, `accumulator_value` | Arbitrary finite lists; exact unbounded Int; proved |
| Raw product terms equal direct ideal sum | `terms_value` | All prepared blocks; proved |
| Alignment grid semantics | `alignment_value` | Definitional bridge |
| Signed alignment residual bound | `alignment_residual_bounds`, `alignment_residual` | All exact rationals, every integer binary-grid exponent; proved |
| Stage decomposition | `sum_stage_residuals` | Arbitrary rational list and alignment function; proved by induction |
| Reference recovery | `block_residual_identity` | Any prepared block and supplied rational d, no conformance hypothesis; proved |
| Returned trace recovery | `returned_residual_identity`, `recovered_eq_exactDot` | Every well-typed trace has a finite encoded output; proved |
| Encoded-input evaluator recovery | `evalV100_residual_identity` | Successful `evalV100 x`; exactDot x equals output plus returned residual; proved |
| Correction and executable rounding agree | `corrected_eq_round_exactDot` | Substitution of exact recovered value; proved, **not** nearest-value correctness |
| Arbitrary schedule ledger | `fold_residual_ledger` | Any state space, fixed contributions and supplied local law; induction over any finite list |
| Encoded trace ledger | `encoded_trace_ledger` | `EncodedChain` premise links decoded encoded boundaries; proved |
| Evaluator establishes chain | `runV100_chain` | Any successful finite `runV100`; proved |
| Executable schedule ledger | `runV100_residual_ledger` | Any successful finite schedule and finite initial encoding; proved |
| Same product values, different output | `Regression.r1_equal_product_values`, `r1_factorization_changes_output` | Actual FP16/FP32 encodings; kernel-checked |
| Complete R1–R3 traces | `Regression.r1a_trace`, `r1b_trace`, `r2_trace`, `r3_trace` | Kernel-checked exact scale/coefficient/residual/output fields |
| Zero correction in R2 | `Regression.r2_correction_unchanged` | Kernel-checked |
| R4 corrected midpoint | `Regression.r4_binade_asymmetry`, `r4_midpoint_distances` | Corrects false handoff expectation; kernel-checked |
| Rounding boundary cases | `Regression.r4_*` | Ties, parity, carry, cancellation, underflow, signed zero; kernel-checked |
| Concrete non-monotonicity | `Regression.v100_nonmonotonicity_witness` | Revised TC-EFT III.4 V100 instance; kernel-checked, no universal threshold |
| Two-invocation cancellation | `Regression.two_block_cancellation` | Final encoded output is -2^-20; ledger recovers exact -2^-24; kernel-checked |

Remaining theorem targets: `finalRound_correct` with a nearest-representable-value
specification; FP32 `output_residual_bound`; `block_error_bound`; general encoding
round trips; residual dyadic/expansion representation interfaces; fixed-width
no-wrap refinement; exact scalar consolidation; optimized overlap refinement.
No placeholder declaration stands in for these results.
