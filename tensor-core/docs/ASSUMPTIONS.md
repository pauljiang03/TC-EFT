# Trust report

## Proof checking

`python3 scripts/check_axioms.py` runs `Audit.lean`, whose `tc_audit` command enumerates
every theorem in the `TensorCore` namespace from the compiled environment (772 constants,
471 written in source, the rest generated structural lemmas) and prints the axioms each
depends on. The command fails if any theorem uses an axiom outside `propext`,
`Classical.choice`, and `Quot.sound`. The verbatim output is [axioms.txt](axioms.txt). The
script also fails if any Lean source in the library, executables, or examples mentions
`sorry`, `admit`, `axiom`, `native_decide`, `ofReduceBool`, or `skipKernelTC`.

There is no project axiom, no compiled reflection, no external solver, and no hardware
assumption inside a proof. Concrete regressions use `decide +kernel`, which reduces the actual
evaluator in the kernel. Generic proofs use induction, standard lemmas, `omega`, and `grind`.
Python scripts and executable runs are tests, not proofs.

The `tc%{ }` elaborator builds ordinary `Program` terms. `tc_verify` applies
`Program.vc_sound` to a kernel-checked proof of `Program.VC`, or to a user-supplied proof of
the same proposition; only errors raised by that elaboration roll it back. Generated theorems
are part of the audit. `tc_inspect` and `tc_instruction` evaluate for diagnostics only.

`tc_certify` applies `Program.staticCertificate_sound` to a kernel-checked Boolean
certificate. Its result includes successful execution and a tolerance bound on the raw
output. `tc_certificate` prints the concrete certificate's input-condition and tolerance
checks; it does not generate a proof or execute a correction. `boundedDotCheck_sound`
instead applies a family theorem using only length and input magnitude checks. Executable
dependency tests verify both paths' stated boundaries, separately from theorem auditing.

## Theorem domains

- `rawProduct_value` holds for arbitrary integer significands and scales. Format
  correctness is a property of the decoder, not a hypothesis.
- Alignment lemmas hold for every rational term and every integer grid exponent.
- The reference accumulator is unbounded `Int`. `evalBlockMachine` folds actual modular
  signed `BitVec` additions, and `fp16Fp32_machine_eq` proves its complete result, including
  every rejection, equals the reference at any width `w ≥ 26 + extra + carryBits` with
  `K + 1 ≤ 2^carryBits`. The bound comes from decoded coefficient magnitudes and protects
  every prefix. It refines accumulation only, not decoding, multiplication, alignment,
  normalization, or any physical register.
- `block_residual_identity` is algebraic recovery for any supplied rational output.
  `evalBlock_residual_identity` connects it to a successful encoded evaluation.
  `evalBlock_success_iff` characterizes success exactly: correct shape, finite operands, and
  an aligned accumulator within `maxFinite32`.
- `runBlocks_residual_ledger` covers every successful finite list of invocations, with each
  next c decoded from the actual returned bits. `runBlocks_uncorrected_error` bounds the
  final uncorrected error by the sum of the traces' local budgets, which depend on the
  actual traces. `OrderedPartition` is a supplied contiguous grouping; nothing infers a
  hardware grouping or justifies permuting groups.
- `staticBudget n F E L` is the input-derived alternative: for terms whose nonzero raw
  scales are at most `E`, a floor at most `E`, and `n ≤ 2^L`, `block_static_error_bound`
  bounds one block's uncorrected error by `n·2^(E−F) + 2^(max(E+1+L, −126) − 23)`, and
  `prepared_static_success` accepts the block when `E + 2 + L ≤ 127`. `runBlocks_static`
  carries this through a schedule: if every group is scale-bounded and every ideal partial
  sum plus the accumulated budget stays below `2^(E+1)`, every accumulator input keeps scale
  `E`, the run is accepted, and the final error is at most the group count times the budget.
  `staticCheck` decides these hypotheses on concrete operands and `staticCheck_sound` applies
  the theorem. The static budget is looser than the trace budget (on the regression schedule
  by about a factor of ten) because it bounds the alignment grid and the output quantum from
  the scale alone; it never runs the model, but the current checker computes exact ideal
  partial sums for the concrete operands. `Program.staticCertificate_sound` additionally
  checks this budget against a requested tolerance and concludes `Program.Accurate`.
- `runBlocks_of_scale_bound` derives the required prefix invariant from decoded product
  scale `P`, total group count, and an initial magnitude bound. It does not evaluate exact
  prefixes. `Program.repeat_accurate_of_scales` applies it to a symbolic count with changing
  rounded state. `boundedDot_accurate_of_bits` discharges its conditions for up to 256 pairs
  whose unsigned FP16 magnitude bits are below `0x2c00`, and finite initial magnitude at
  most 1, obtaining raw absolute error at most `2^-11`. The ordered AST and public run agree
  on finite initial inputs, and their ideal equals the direct unpadded-input sum.
  `boundedDotCheck` only checks membership in this sufficient input family. No GPU
  conformance, relative-error bound, or precision guarantee for larger operands follows.
- `InstructionPath` fixes a contiguous increasing-k grouping and its source.
  `InstructionPath.run` rejects any operand list whose length is not `k`; nothing is padded
  or discarded. `Conforms path device` is a definition, not a theorem: it states that
  whenever the model produces an output, the device produces the same bits. Inputs the model
  rejects (wrong operand count, nonfinite operands, out-of-range accumulators) are outside the
  modeled domain and do not constrain the device. Every result about a device takes
  `Conforms` as a premise. `single_group_output` and `zero_products_passthrough` hold for
  finite accumulators other than `−0` and for floors at most −126; a zero group turns `−0`
  into `+0` in the model, and the device behavior for that case is not established.
- `FiniteValue32` is the arithmetic form of finite FP32 values; `value32_finite` and
  `finiteValue32_abs_le` place every such value in range. `round32_nearestEven_correct`
  proves finite output, nearest value, and even parity at ties for every rational in range.
  `value32_round32` proves that converting the value of a nonzero finite encoding, in either
  mode, returns exactly that encoding, and `value32_injective` that nonzero values have unique
  encodings. `NearestEven32` compares values and does not distinguish the two zero encodings.
- The scalar EFT theorems use `fp32Add`, the value of a correctly rounded FP32 addition.
  `naiveSum32_exact` is stated for grid exponents `-149 ≤ ℓ ≤ 104`, which covers every grid
  a term or output quantum of this model can have; the paper's explicit range condition is
  then implied by the coefficient bound. `scalarPredicate` decides the hypotheses of
  Theorem IV.9, Lemma IV.10, and Corollary IV.11 on the actual components: the common grid,
  the coefficient bound, representability of `D`, `ε_o`, and `H`, and the range of the
  component sum `H + Σ εᵢ`. It forms this sum in exact `Rat` arithmetic;
  `retained_add_low` proves it equals the exact ideal. Avoiding a direct call to `exactDot`
  does not eliminate exact reconstruction or implement a machine range check.
  Both `scalarCorrected` and `tceft` check the predicate; the explicitly named
  `scalarCorrectedUnchecked` is retained only for diagnostics and counterexamples.
  `tceft` returns a result only
  when the predicate holds (`tceft_isSome_iff`), and `tceft_correct` proves every result is
  the correctly rounded exact sum. The predicate is sufficient, not necessary: a rejected
  input is a failure of the procedure, and the exact-rational `corrected` reference is a
  separate specification, not a substitute. Lemmas IV.3–IV.4 are `truncGrid_split`,
  `accumulator_eq_retained`, and `overlap_eq_retained_sub_outputResidual`: each coarse low
  part splits into its retained part on the alignment grid and the alignment residual, and
  `ε_o` is the retained low sum minus the output residual. The theorems concern the
  left-to-right naive summation on values. The bounded `EFMachine` primitives prove
  11-bit significand multiplication and 24-bit coarse/low splitting, including
  no-wrap, shift bounds, and exact signed truncation/residual interpretation.
  Their `Rat` interpretation belongs to the specification; executable primitives
  use bitvectors. Encoded extraction, bounded overlap/guard/consolidation, and a
  correction-success family are not yet implemented and proved.
- `nonmonotone_perturbation` fixes `c = 1`, `c' = 1 − 2^-24`, and `K` equal products of
  value `2^-(24+p)` with raw scale at most `−1`, for any profile with `F = 23 + p` and a
  floor at most `−1`, and `K < 2^(24+p)`. It is a theorem about this family only; a profile
  where the construction fails is not thereby proved monotone. `nonmonotone_range` extends
  it to `c_j = 1 − j·2^-24` for `1 ≤ j ≤ 2^23`: the output exceeds `1` exactly when
  `(j + 2)·2^p ≤ K`, equals `1 + 2^-23·⌊(K − j·2^p)/2^(p+1)⌋` whenever `j·2^p ≤ K`, and never
  exceeds the `j = 1` value. `nonmonotone_range_iff` rewrites the condition as
  `j ≤ min(2^23, ⌊K/2^p⌋ − 2)`; `decode32_below` connects `c_j` to the bits `3f800000 − j`.
- `fp16Fp32_contract` quantifies over the product count and the extra alignment bits.
  `canonical_eta_floor_inactive` shows floors at or below −126 never change the alignment
  exponent for FP16 operands and FP32 c. The padding thresholds are sufficient, not minimal;
  more padding can also turn an accepted `maxFinite32` result into a range rejection
  (`Regression.padding_range_boundary`). No monotone-improvement claim follows.
- `evalInvocation_recovery` is exact loss accounting for every `InvocationSpec`.
  `roundBinary` is proved to agree with `round32` on FP32 only; the BF16, TF32, FP16-output,
  and FP64 descriptors have no rounding-correctness proof, and the BF16/TF32 device matches
  are evidence about the descriptors, not theorems.
- `Program.recovery`, `Program.vc_sound`, `runLocated_erases`, and
  `Program.report_accepts_iff` state what the checker establishes for the fixed-input
  fragment. The checker runs finite schedules; `Program.repeat_vc_of_cycle` is one inductive
  rule with explicit premises.

## Hardware and open obligations

The profiles are interpretations of Accurate Models v4 and the v0.5 source. The
correspondence between a profile and a device is empirical and outside the proofs. The
published vectors match the evaluator for V100, A100, and H100 FP16, and the descriptors for
A100 and H100 BF16 and TF32, 5,000 rows each. Each row is one group with its products in k
positions `0..K−1`; by `single_group_output` that is one test of the whole instruction path
under the increasing-k rule, but it never tests the order of two nonzero groups. The rows
contain almost no zero or subnormal operands or c, and none reach the BF16/TF32 alignment
floors. The separate `data/hardware/` corpus prepares 99 targeted vectors with
unmeasured model expectations; synthetic replay tests are not device measurements.
No GPU was used by this project, and the TC-EFT paper's historical 100-case V100
experiment is not evidence for this implementation.

Not proved: rounding correctness for any output format other than FP32, an efficient
residual extractor, boundary operators other than the encoded FP32 boundary, and conformance
of any BF16, TF32, FP8, FP16-output, or FP64 specification. No placeholder declaration stands
in for these. See [PLAN.md](PLAN.md).
