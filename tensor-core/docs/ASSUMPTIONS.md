# Trust report

## Proof checking

`python3 scripts/check_axioms.py` runs `Audit.lean`, which prints the axioms of 201 theorem
roots, and fails if any root uses an axiom outside `propext`, `Classical.choice`, and
`Quot.sound`. The verbatim output is [axioms.txt](axioms.txt). The script also fails if any
source under `TensorCore/` mentions `sorry`, `admit`, `axiom`, `native_decide`,
`ofReduceBool`, or `skipKernelTC`.

There is no project axiom, no compiled reflection, no external solver, and no hardware
assumption inside a proof. Concrete regressions use `decide +kernel`, which reduces the actual
evaluator in the kernel. Generic proofs use induction, standard lemmas, `omega`, and `grind`.
Python scripts and executable runs are tests, not proofs.

The `tc%{ }` elaborator builds ordinary `Program` terms. `tc_verify` applies
`Program.vc_sound` to a kernel-checked proof of `Program.VC`, or to a user-supplied proof of
the same proposition. Generated theorems are part of the audit. `tc_inspect` evaluates for
diagnostics only; nothing it computes is used as a proof certificate.

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
  final uncorrected error by the sum of the traces' local budgets; the budgets depend on the
  actual traces, not on a static input analysis. `OrderedPartition` is a supplied contiguous
  grouping; nothing infers a hardware grouping or justifies permuting groups.
- `FiniteValue32` is the arithmetic form of finite FP32 values; `value32_finite` and
  `finiteValue32_abs_le` place every such value in range. `round32_nearestEven_correct`
  proves finite output, nearest value, and even parity at ties for every rational in range.
  `NearestEven32` compares values and does not distinguish the two zero encodings.
- The scalar EFT theorems use `fp32Add`, the value of a correctly rounded FP32 addition.
  `naiveSum32_exact` is stated for grid exponents `-149 ≤ ℓ ≤ 104`, which covers every grid
  a term or output quantum of this model can have; the paper's explicit range condition is
  then implied by the coefficient bound. `scalarPredicate` decides the hypotheses of
  Theorem IV.9, Lemma IV.10, and Corollary IV.11 on the actual components, including
  representability of `D`, `ε_o`, and `H`. `tceft_correct` needs the ideal sum in range.
  The theorems concern the left-to-right naive summation on values; no machine extraction
  of the residuals is modeled.
- `nonmonotone_perturbation` fixes `c = 1`, `c' = 1 − 2^-24`, and `K` equal products of
  value `2^-(24+p)` with raw scale at most `−1`, for any profile with `F = 23 + p` and a
  floor at most `−1`, and `K < 2^(24+p)`. It is a theorem about this family only; a profile
  where the construction fails is not thereby proved monotone.
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
positions `0..K−1`, the rows contain almost no zero or subnormal operands or c, and none
reach the BF16/TF32 alignment floors. No GPU was used by this project, and the TC-EFT
paper's historical 100-case V100 experiment is not evidence for this implementation.

`runBlocks` composes groups in the supplied order. Nothing here discovers the order inside a
hardware instruction; see [COMPOSITION.md](COMPOSITION.md).

Not proved: bit-for-bit decoder/encoder round trips, rounding correctness for any output
format other than FP32, the overlap lemmas IV.3–IV.4 in coarse-component form, Theorem
III.5, an efficient residual extractor, and conformance of any BF16, TF32, FP8,
FP16-output, or FP64 specification. No placeholder declaration stands in for these. See
[PLAN.md](PLAN.md).
