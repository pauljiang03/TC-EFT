# Trust report

## Proof checking

`python3 scripts/check_axioms.py` runs `Audit.lean`, which prints the axioms of 117 theorem
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
- Accumulation is over unbounded `Int`; no-wrap is a property of that representation.
  `evalBlock_machineAccumulator` separately proves that modular signed-word accumulation of
  width `F + 2 + carry + 1` equals the exact sum for every prefix, from decoded operand
  bounds. That width is derived, not a claim about a device register.
- `block_residual_identity` is algebraic recovery for any supplied rational output. It needs
  no model or device hypothesis. `evalBlock_residual_identity` connects it to a successful
  encoded evaluation, which enforces the product count, finite inputs, and a finite-range
  accumulator. `Finite32.valid` ties output bits to their decoded value.
- `runBlocks_residual_ledger` covers every successful finite list of invocations. Each
  contribution is the exact product sum of the returned trace, and each next c is decoded
  from the actual returned bits. This is a fixed-input schedule theorem, not a statement
  about adaptive operands, GEMM scheduling, or a GPU kernel.
- `FiniteValue32` is the arithmetic form of finite FP32 values; `value32_finite` proves every
  decoded finite value has it. `encode32_value` proves the converter's construction decodes
  to its intended value with the intended parity.
- `round32_nearestEven_correct` proves, for every rational input with magnitude at most
  `maxFinite32`, that the output is finite, no finite FP32 value is closer, and the low
  encoding bit is even whenever a different value is equally close. `NearestEven32` compares
  values, so it does not distinguish the two zero encodings; the signed-zero policy lives in
  the executable converter.
- `evalBlock_corrected_correct` and `runBlocks_corrected_correct` combine recovery with the
  rounding theorem. `corrected_eq_round_exactDot` on its own is only substitution.
- `output_residual_bound` and `evalBlock_error_bound` are strict bounds; the block bound
  counts every term, including c.
- Conversion and final rounding reject magnitudes above `maxFinite32`. Successful
  intermediate calls bound each retained accumulator; the final exact sum needs its own
  bound. Neither implies the other.
- `fp16Fp32_contract` quantifies over the product count and the extra alignment bits of
  `fp16Fp32Profile`. `canonical_eta_floor_inactive` shows any floor at or below −126 never
  changes the alignment exponent for FP16 operands and FP32 c, so the Ampere and Hopper
  floors are inert on these paths. Neither theorem gives a parameter value a hardware meaning.
- `evalInvocation_recovery` is exact loss accounting for every `InvocationSpec`, including
  ordered conversion stages, late c, and the fused variant. `v100_invocation_bits` proves the
  generalized evaluator returns the same bits, and rejects the same inputs, as `evalBlock`.
  `roundBinary` is proved to agree with `round32` on FP32 (`roundBinary_fp32`); its
  correctness for other formats and directed modes is not proved.
- `Program.recovery` connects the compiled invocation list to `Program.ideal`, which decodes
  the original operand bits independently. `Program.Correct` states success, recovery, and
  nearest-even correction of that ideal.
- `Program.vc_sound` proves the checked conditions imply `Program.Correct`. The checker runs
  finite schedules; it is not a symbolic range engine. `Program.repeat_vc_of_cycle` is one
  inductive rule with explicit state, zero-ledger, and range premises.
- Source locations are metadata; `runLocated_erases` proves they cannot change execution, and
  `Program.report_accepts_iff` proves the report succeeds exactly when the conditions hold.

## Hardware and open obligations

The profiles are interpretations of Accurate Models v4 and the v0.5 source. The
correspondence between a profile and a device is empirical and outside the proofs. The
published FP16 vectors match the evaluator for V100, A100, and H100, 5,000 rows each
(`scripts/check_device.py`, `scripts/check_device_families.py`). Each row is one group with
its products in k positions `0..K−1`, and the rows contain almost no zero or subnormal
operands or c. No GPU was used by this project, and the TC-EFT paper's historical 100-case
V100 experiment is not evidence for this implementation.

`runBlocks` composes groups in the supplied order. Nothing here discovers the order inside a
hardware instruction; see [COMPOSITION.md](COMPOSITION.md).

Not proved: bit-for-bit decoder/encoder round trips, rounding correctness for any output
format other than FP32, scalar residual representability and consolidation, a residual
expansion interface, optimized overlap extraction, and conformance of any BF16, TF32, FP8,
FP16-output, or FP64 specification. No placeholder declaration stands in for these. See
[PLAN.md](PLAN.md).
