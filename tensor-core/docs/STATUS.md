# Status — 5 September 2026

The executable reference, exact residual ledger, general finite-range FP32
nearest-even correctness, and two-stage block error bound are proved. A first
typed program language, custom elaborator, and proof-producing verification
command now work for block schedules and bounded repetition. All correction
still uses exact rational residuals; the paper's scalar FP EFT algorithm,
optimized extraction, and machine-arithmetic refinements remain open.

The [current plan](CURRENT_PLAN.md) now prioritizes a complete **parameterized
single-invocation model**: one dot product with unnormalized products and a
block accumulation, including its alignment and output stages. The existing
`Profile` is only a partial feature schema; c/output and several policies remain
hard-coded to the initial family. EFT is a separate local application.
Downstream composition remains planned implementation after the invocation
gate. See [the fresh-context handoff](CONTEXT_HANDOFF.md).

## Position in the handoff

| Milestone | Current position |
| --- | --- |
| 0 — Sources and specification | Complete for the initial V100 path; pinned sources, format/policy decisions, and library inventory. |
| 1 — Executable reference model | Complete within the declared finite V100 FP16/FP32 domain, with checked regressions. |
| 2 — Representation/arithmetic bridges | Reference arithmetic, encoding construction, and rounding proofs complete; machine-width refinement and full scalar exactness interfaces remain. |
| 3 — EFT | Exact reference extraction, recovery, finite error bounds, and final rounding proved; scalar representation/consolidation and optimized extraction remain. |
| 4 — Programs and loops | Fixed-input finite schedules and one reusable symbolic cycle invariant proved; general scalar/adaptive state, expansion invariants, and matrix schedules remain. |
| 5 — Metaprogramming | First working DSL/verifier slice completed; general symbolic analysis, architecture declarations, and richer operations remain. |
| 6 — More profiles and sharp theory | Not implemented beyond the source decision table. General feature coverage is now part of the first invocation-completion gate, rather than deferred behind programs/EFT. |

The initial acceptance gate is complete. The full research plan remains
partially complete; the milestones have different sizes and are not a useful
percentage measure. See [the DSL guide](DSL.md) for the implemented frontend.
`Program.Correct` is a model-schedule theorem. The connection to actual
PTX/SASS instruction grouping, fragment mapping, and composition is still open;
see [the instruction boundary review](PTX_BOUNDARY.md).

## Completed

- Read the handoff and both supplied papers, pinned their hashes and MATLAB
  v0.5, reconciled subnormals, and corrected the handoff's R4 midpoint.
- Built a standalone Lean 4.33.1 package with no external Lean dependencies.
- Implemented profile-indexed block and schedule semantics; V100 FP16/FP32 is
  the only instantiated architecture profile. Raw product scales are preserved.
- Proved raw-product and common-grid value preservation, signed alignment
  bounds, exact local residual recovery, and arbitrary finite schedule recovery
  across actual encoded output boundaries.
- Proved every finite decoded FP32 value satisfies `FiniteValue32`; proved
  `encode32` value preservation, encoding parity, and output quantum under
  explicit exponent/coefficient bounds.
- Proved exponent selection, integer nearest-even rounding, and conversion
  bounds, including subnormals, zero, signs, and binade carries.
- Proved `round32_nearestEven_correct` and `finalRound_correct`: for every
  rational x with `absQ x ≤ maxFinite32`, conversion returns a finite encoding,
  minimizes distance to every finite FP32 value, and selects an even low bit
  on a tie between distinct values. This is a general proof, not a test result.
- Connected that contract to corrected encoded-input blocks and successful
  finite schedules (`evalBlock_corrected_correct`,
  `runBlocks_corrected_correct`). The final exact sum needs its own range bound.
- Proved `output_residual_bound` and `evalBlock_error_bound`. With n terms
  including c, alignment quantum qA, and encoded output quantum qO,
  `abs(S - d) < n*qA + qO`. Successful evaluation supplies the accumulator
  range premise. The accumulator is an unbounded integer reference.
- Kernel-checked R1–R4, rounding boundaries, range/input/shape rejection,
  a non-monotonicity witness, and two-block cancellation and correction.
- Reviewed and retained Fable's profile generalization, device comparison,
  and rounding foundation work; repaired incomplete proofs and restored the
  declared finite-range guard. See [the review](FABLE_REVIEW.md).
- Added `Program p` with typed block operands, sequencing, and nested bounded
  repetition, plus `tc%{ ... }` syntax with source locations and literal checks.
- Added `Program.ideal` from original input bits, `Program.recovery`, and
  `Program.vc_sound`; successful checking implies executable recovery and
  nearest-even correction of that independent ideal sum.
- Added `tc_verify` and `tc_inspect`. Generated proofs apply existing theorems;
  failed verification removes generated declarations. Diagnostics preserve the
  model execution (`runLocated_erases`) and agree with its verification
  conditions (`Program.report_accepts_iff`).
- Proved sequential execution and an arbitrary-count encoded-state cycle
  invariant, with a generated symbolic-loop correctness theorem.
- Checked DSL operand order, nested loops, two-block cancellation, final range,
  zero iterations, source diagnostics, and ten frontend rejection cases.

## Verification

```sh
lake build
python3 scripts/check_axioms.py
python3 scripts/validate.py
python3 scripts/check_device.py
python3 scripts/check_programs.py
python3 scripts/check_clean_build.py
```

All six commands pass. The fresh build checks 51 targets and audits 83 theorem
roots with only standard Lean axioms. The independent oracle checks 715 blocks
and 2,918 rounding cases with zero mismatches; three nonfinite blocks are
intentionally rejected. All 5,000 V100 FP16/FP32 vectors published with v0.5
match bitwise. No new GPU measurements were taken.
The public DSL example compiles, and all ten rejection tests pass. The fresh
source-copy check now also runs these frontend tests.

At the context-handoff checkpoint, `lake build` and the 83-root audit were
rerun successfully. `lake env lean examples/SingleInvocation.lean` also passed;
this standalone example is not imported by the library or counted among those
83 roots. The other validation numbers above are the existing recorded runs;
the documentation-only revision did not rerun the numerical/device suites.

Reports are in `data/regressions/`, including `clean-build.json`; the fresh
build log is `tmp/clean-build.log`. See [validation](VALIDATION.md) and
[the audit output](axioms.txt).

## Next concrete work

1. Build the source-to-code feature coverage matrix and define the well-formed
   single-dot-product invocation contract. Include missing formats, c policies,
   alignment/carry behavior, and output-stage sequences; retain source/domain
   distinctions rather than treating all GPU names as one numeric tuple.
2. Generalize encoded arithmetic and the evaluator, prove the reusable
   single-invocation contracts and required signed-width refinement, and
   preserve V100 behavior through specialization/equivalence.
3. Instantiate and validate the supported feature families. Complete the
   declared invocation coverage gate before expanding downstream programs.
4. Treat invocation-local EFT as a separate application: coarse extraction,
   representability/support, and actual scalar execution remain to be proved.
   EFT is not required for every later use of the invocation model.
5. Implement the later schedule, contract-composition, scalar/loop, instruction
   mapping, and application gates described in [CURRENT_PLAN.md](CURRENT_PLAN.md).
   GPU ordering is an explicit later mapping obligation; current schedules
   execute the order supplied by the program and use an exact rational ledger.

The latest request stops this increment after plan revision and context
preparation. No next-step Lean implementation was added. Both PDFs are unchanged.
