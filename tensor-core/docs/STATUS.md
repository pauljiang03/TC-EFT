# Status — 5 September 2026

The first executable acceptance gate is implemented. The larger EFT and
correct-rounding research roadmap remains in progress.

## Completed

- Read the handoff and both supplied papers. Pinned source PDF hashes and
  MATLAB v0.5 commit. Reviewed relevant source with its license preserved.
- Recorded plan changes, including the corrected R4 midpoint expectation,
  reconciled subnormal decoder, and separate rounding-proof milestone.
- Created a standalone Lean 4.33.1 package using only the standard library.
- Implemented finite FP16/FP32 classification, raw products retaining scales,
  signed alignment, exact integer accumulation, FP32 RTZ output, and traces.
- Implemented a direct ideal-sum evaluator, exact residual extractor, executable
  quotient/remainder FP32 RNE, and an independent Python neighbor oracle.
- Proved `rawProduct_value`, `terms_value`, `accumulator_value`, and
  `alignment_residual`, including the strict magnitude bound.
- Proved `block_residual_identity` and `evalV100_residual_identity` for actual
  successful encoded-input evaluations.
- Proved `fold_residual_ledger`, `encoded_trace_ledger`, `runV100_chain`, and
  `runV100_residual_ledger` for arbitrary successful finite schedules.
- Kernel-checked complete R1–R3 traces, R2 unchanged correction, corrected R4
  and boundary cases, a non-monotonicity witness, and two-block cancellation.
- Audited 39 theorem roots: only standard Lean axioms; no placeholders,
  custom axioms, compiled reflection, or disabled checks.
- Differential validation: 715 block cases, 2,910 rounding cases, zero
  mismatches, three intentionally rejected nonfinite blocks, no GPU measurements.

## Verification

```sh
lake build
python3 scripts/check_axioms.py
python3 scripts/validate.py
python3 scripts/check_clean_build.py
```

All four commands pass. A fresh source copy without a `.lake` directory built
all 27 targets and passed the 39-root axiom audit. This result is recorded in
`tmp/clean-build.json`, with output in `tmp/clean-build.log`. See `VALIDATION.md`
and `axioms.txt` for detailed evidence.

## Next concrete work

1. Define FP32 finite representability and a nearest-value/parity specification
   independently of `round32`.
2. Prove the exponent selection and quotient/remainder converter satisfy that
   specification for `abs(S) <= maxFinite32`, including ties and underflow.
3. Prove output truncation's strict residual bound and combine it with the
   existing alignment bound to establish the two-stage block error bound.
4. Prove encoding round trips and residual representability interfaces, then
   exact scalar consolidation and machine-width refinement.

Do not build substantial custom syntax yet. Do not describe
`corrected_eq_round_exactDot` as general correct rounding: it establishes
substitution into the tested converter. Do not claim an optimized EFT cost,
full GPU instruction/kernel conformance, another architecture profile, or a
classical floating-point expansion representation.

The original files remain in the parent workspace. Only the erroneous R4
expectation in the handoff was amended, with provenance; both PDFs are unchanged.
