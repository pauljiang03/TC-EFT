# Agent A / Agent B merge notes

Started 2026-09-06 at 01:22 EDT (05:22 UTC). Status: **both contributions
integrated in the working tree; full combined validation passed**.

Final record: [merge-report.json](tensor-core/data/regressions/merge-report.json).
Fresh suite: [clean-build.json](tensor-core/data/regressions/clean-build.json).
No Git branch merge or submission commit was created: the agents delivered source
copies, and the integration preserves the existing working-tree changes.

## Subsequent scope decision — 6 September 2026

The user takes Accurate Models v4 as the ground-truth specification. Completion
requires faithful Lean semantics, proofs of the stated results, and software
validation. New GPU measurements are optional external validation of the paper's
hardware fidelity and are not a blocker for this formalization or F8. This
supersedes the earlier F5 measurement obligation recorded in the chronological
notes and historical A/B handoffs below. No experiment is being marked performed.

This update changes documentation and the merge record's scope metadata only.
The Lean sources, tests, numerical results, and proof assumptions are unchanged;
the previous successful validation remains evidence for that unchanged code.
The merge report retains its original tested-snapshot hashes and records the
subsequent documentation amendment separately.

## Sources and preserved baseline

- Destination: `/Users/paul/Documents/tc-lean-mp`, branch `main`, initial HEAD
  `95d5f62`. The preexisting `tensor-core/docs/PLAN.md` changes and untracked
  `split.md` are requirements to preserve, not disposable working changes.
- Agent A checkout:
  `/private/var/folders/7s/3dm74t757lv80n92j8gt9z040000gn/T/tc-agent-a-5p701v4c/repo`.
- Agent B checkout: `/private/tmp/tc-agent-b-uqbs96ku/repo`.
- Both agents use independent source copies without Git metadata. Their PLAN and
  split snapshot initially match the destination. Integration therefore requires
  a reviewed file merge, rather than merging two existing Git branches.
- Initial source hashes, the preexisting Git diff, and a copy of split are saved
  under `tmp/merge-monitor/`. Build caches and scratch files are excluded from
  source manifests. Do not copy either agent's `.lake` cache into the destination.

## Observed progress

| Track | Observed at first inspection | Completion evidence |
| --- | --- | --- |
| A | Public-domain changes; program certificate/frontend; bounded-dot application and loop proofs; new regressions and examples | Pending final handoff and validation |
| B | Guarded scalar interface; EFT coverage reports; bounded split primitives/proofs; hardware vectors, harness, and replay scripts | A branch-local build and audit passed; full handoff pending |

Successful intermediate builds or quiet file timestamps do not establish that an
agent has finished. Observe the final handoff/turn completion, then recheck the
source manifest before taking the final integration snapshot.

### 01:26 EDT review

- A has begun landing its independently buildable public-domain changes in the
  destination. These are agent-owned writes, not the final merge; preserve them.
- Inspected `Program.staticCertificate_sound`, `runBlocks_of_scale_bound`,
  `Program.repeat_accurate_of_scales`, and `boundedDot_accurate`. The application
  binds the ordered padded schedule to the original-input ideal. Its stated
  regime is at most 256 signed FP16 pairs below magnitude 1/16, finite initial
  FP32 magnitude at most 1, and absolute tolerance 2^-11. The family proof derives
  prefix bounds from operand scales and count; the concrete frontend separately
  checks exact ideal prefixes. Final acceptance still awaits delivered checks.
- Inspected B's fixed-width multiplication/split implementation and refinement
  statements. They prove no wrap, shift bounds, and exact coarse/low interpretation
  for either sign. They do not yet implement encoded extraction, overlap, guard,
  consolidation, or a success family; B explicitly keeps these F6 tasks open.
- B reports reproduced baseline coverage: 15,000/15,000 published and
  3,000/3,000 near-one cases; broad acceptance 73/1,000, 13/1,000, and 0/1,000.
  Independent correction checks passed on accepted cases. These are interim
  branch results, to be rerun after integration.
- The hardware preparation contains 99 vectors and synthetic replay tests.
  Expectations and actual measurements are separate; no CUDA compiler/GPU run
  has been reported. This does not close F5.

### 02:07 EDT metaprogramming review

- `tc%{...}` expands to the existing typed `Program` AST; encoded literal bounds
  and group shape are proved with kernel reduction. `tc_certify` emits an
  ordinary theorem applying `Program.staticCertificate_sound`; it does not define
  another numerical semantics. `tc_certificate` uses evaluation for diagnostics.
- The command disables asynchronous elaboration for the generated theorem,
  watches only new error messages, and restores the saved environment on failure.
  A's delivered certificate report records eight rejected cases, absence of the
  failed theorem, successful explicit proofs, and preservation of a valid theorem
  when an unrelated prior error exists.
- The certificate checker transitively inspects executable definition bodies:
  the concrete certificate/report do not call the model or residual ledger, and
  the family membership checker additionally avoids exact prefix computations.
  A deliberately contaminated dependency provides a negative control.
- This is appropriate use of Lean metaprogramming: generated proof terms remain
  kernel checked. Concrete reduction has input-size costs; the frontend is not
  itself a general symbolic invariant synthesizer. Combined reruns remain pending.

### 02:09 EDT B handoff

- `tensor-core/data/regressions/eft-handoff.json` now declares B ready for
  integration. B copied its owned files into the destination. All 15 pinned source
  hashes match; its session's final turn completion is still being monitored.
- The final B cohort has 21,966 cases, including one-block application samples;
  it retains the original 21,000 baseline rows. Accepted corrections have zero
  independent-oracle mismatches. One-block coverage is not composed-dot coverage.
- B's fresh gate passed with 699 theorem roots (423 written), zero Lean warnings,
  and two `ld64.lld` missing-`/usr/local/lib` warnings. These counts are branch-local.
- B proofs are reachable through `Regression.EFT`; no new executable root or
  target is required. Add `scripts/check_eft.py` to the final clean-build gate.
- A's current clean-build warning regex only matches `ld: warning:`. Check and
  repair it during final integration so `ld64.lld: warning:` is counted accurately.

### 02:14 EDT DSL and completion review

- B's final turn completed at 02:08:35 EDT. Its final handoff, source manifest,
  and completion record are saved under `tmp/merge-monitor/final-agent-b-*`.
- The source comparison currently has only one overlapping changed file:
  `tensor-core/docs/axioms.txt`, an aggregate report that must be regenerated.
- Reviewed the embedded DSL's translation of blocks, typed calls, sequences, and
  nested repetition. Reverse iteration followed by prepending preserves source
  order; `Program.blocks` defines ordered schedule expansion, and `Program.run`
  executes that schedule. Literal range checks precede conversion to bitvectors.
- Existing DSL regression coverage checks order and includes ten failure cases.
  The supported fragment has fixed operands; it does not provide matrix indexing,
  adaptive operands, arbitrary scalar statements, or automatic invariant discovery.
- At this checkpoint A remained active on documentation and validation. Do not treat its earlier
  successful application build as a final delivery snapshot.

### 02:16–02:22 EDT final handoffs and integration

- A's final turn completed at 02:16:18 EDT; B completed at 02:08:35 EDT. Both
  handoffs declare `ready_for_integration`. All 37 A file hashes and all 15 B
  source hashes matched the destination before integration edits. Final delivery
  manifests and completion evidence are saved in `tmp/merge-monitor/`.
- The agents copied their own files into the destination without overlapping
  source edits. Reviewed that combined file merge and preserved both deliveries,
  the original PLAN requirements, and the original split text plus A's handoff.
  No Git branches existed for these source copies, so this is a working-tree
  integration rather than a merge of two branch tips.
- Added B's `scripts/check_eft.py` to the combined clean-build gate. The gate now
  publishes all generated validation/coverage reports and the axiom listing from
  its single fresh run. Historical agent handoffs retain their branch-local counts.
- A repaired the linker warning matcher before handoff; no further matcher change
  was needed. Updated README, specification, theorem map, trust report, DSL, PLAN,
  and validation docs for the guarded scalar API, primitive scope, coverage, and
  unmeasured hardware preparation.
- The combined workspace `lake build` passed all 148 jobs. The direct axiom audit
  passed 772 theorem roots / 471 written declarations, standard axioms only.
  `scripts/check_clean_build.py` is now running the full combined suite in a new
  source copy without a build cache.

## Integration decisions and review gates

1. Preserve the file ownership in `split.md` while agents are active. This monitor
   owns `merge.md`; defer destination source edits until both deliveries finish.
2. Compare each delivery against the initial destination snapshot. Apply only
   intentional changes. Resolve shared imports, target registrations, audit roots,
   documentation, and generated reports together; do not overwrite one complete
   checkout with the other.
3. A's finite empty-input policy must retain low-level `runBlocks` no-op behavior
   and the finite-input machine-equivalence guarantee. Recheck zero-product CLI
   behavior and preserve the finite-range rounding guard.
4. B's scalar API must preserve the subnormal counterexample: unchecked
   `0x3f800000`, exact `0x3f800001`, guarded failure. Verify all renamed callers.
5. Inspect application hypotheses: raw-output accuracy and requested tolerance
   must follow from input bounds with changing accumulator state. Concrete
   certification and symbolic-family analysis remain separate claims.
6. Inspect bounded EFT dependencies and theorem assumptions. Split primitives,
   coverage evidence, or exact reference arithmetic do not alone complete F6.
   Retain explicit hardware conformance premises in device-transfer theorems;
   unmeasured GPU cases belong to optional F5 and do not block the formalization.
7. Make every delivered proof reachable from `TensorCore.lean`, scan every new
   executable root, and include new checks/examples in the clean-build script.
8. Recheck destination changes immediately before applying the merged result so
   concurrent work and the original uncommitted PLAN/split changes survive.

## Final validation

From `tensor-core/`: `lake build`, `scripts/check_axioms.py`, `scripts/validate.py`,
`scripts/check_features.py`, `scripts/check_dot_products.py`,
`scripts/check_device.py`, `scripts/check_device_formats.py`,
`scripts/check_programs.py`, and `scripts/check_clean_build.py` (Python scripts
run with `python3`). Also run every delivered certificate, application, EFT, and
hardware-replay check and all relevant examples.

All commands above passed, either directly in the combined workspace or as part
of the fresh combined suite. `check_clean_build.py` ran 19 commands with no existing
`.lake` cache, including all eight standalone examples. Its nested EFT gate also
ran coverage, hardware generation, and synthetic replay. No test was disabled or
weakened. The final numbers are:

| Check | Result |
| --- | --- |
| Fresh build | 148 jobs; passed |
| Full environment audit | 772 theorem roots / 471 written; standard axioms only |
| Warnings | 0 Lean warnings; 2 `ld64.lld` missing-`/usr/local/lib` warnings |
| Original oracle | 715 blocks and 2,918 rounding inputs; passed |
| Parameterized feature oracle | 2,033 cases; zero mismatches |
| Ordered dot products | 280 cases; zero mismatches |
| Published device/format evidence | 35,000 unique published rows; zero mismatches |
| DSL and certification | 10 program rejections, 8 certificate rejections, rollback and dependency negative controls passed |
| Application | 87 cases; zero mismatches; 52 family and 69 concrete certificates |
| EFT coverage | 21,966 cases; zero accepted-correction mismatches; baseline distributions preserved |
| Targeted hardware preparation | 99 vectors; 12 synthetic replay checks; 0 measured vectors |
| Source checks | All 11 new library modules reachable; contributed Lean hashes match handoffs; pinned vendor files unchanged; Python parses; `git diff --check` passed |

The final clean run regenerated the shared reports and axiom listing. Its combined
log is `tensor-core/tmp/clean-build.log`; the workspace build log and the complete
clean-report output are under `tmp/merge-monitor/`. The durable merge report records
their hashes and the tested source manifest. Historical A/B handoffs retain their
isolated counts and source hashes rather than being relabeled as combined evidence.

## Remaining work after this merge

- **F1:** complete under the documented finite-range rounding policy.
- **F2:** complete for concrete-input certificates; the frontend does not infer
  general symbolic invariants.
- **F3/F4:** complete for the stated fixed-input, signed bounded-dot family and
  symbolic repetition. Bounds are conservative; this is a reference-schedule
  guarantee with hardware conformance kept separate.
- **F5:** optional external validation, outside formalization completion
  requirements. Harness/vector/replay preparation is delivered; CUDA compilation
  and actual GPU measurements are unperformed, not completion blockers.
- **F6:** safe interface, coverage, and bounded primitive refinement delivered.
  Full encoded extraction, overlap/guard/consolidation, complete refinement, useful
  success-family proof, and full phase-cost evidence remain open.
- **F7:** deferred.
- **F8:** combined sources, documentation, and fresh validation integrated. The
  source manifest pins this tested working-tree artifact; selecting and committing
  a final submission revision remains outside this source-copy merge.
