# Two-agent implementation split

Prepared 6 September 2026 for the implementation reviewed at `95d5f62`, together with the
subsequent working-tree updates to [PLAN.md](tensor-core/docs/PLAN.md). PLAN remains the
source of requirements and acceptance criteria; this file assigns ownership and sequencing.
Nothing below is marked implemented. Both agents must read PLAN, including the rules against
superficial fixes and the follow-up coverage measurements.

Scope update, 6 September 2026: Accurate Models v4 is the ground-truth
specification. Faithful Lean semantics, proofs, and software validation determine
completion. New GPU measurements are optional external validation and are not
required for either track or the combined artifact. This supersedes earlier
measurement obligations; unperformed experiments remain labeled unmeasured.

## Division of work

**Agent A: public domains, program certification, and a verified application.**
**Agent B: safe scalar correction, bounded EFT extraction, and empirical evidence.**

Agent A proves accuracy of an **uncorrected** ordered dot product, so its application does
not depend on Agent B finishing the extractor. Agent B works against the existing block
semantics and rounding contracts, so it does not depend on Agent A's new certificate or
loop machinery. Run these two tracks concurrently; integrate their small API fixes early.

| PLAN item | Owner | Deliverable or boundary |
| --- | --- | --- |
| F1: zero-product, empty-input, and rounding domains | A | Consistent public policies, proofs, CLI behavior, and boundary regressions |
| F1: unchecked scalar helper | B | Safe public correction interface; preserve the counterexample and guarded failure |
| F2: `tc_certify` | A | Kernel-checked acceptance and uncorrected error/tolerance theorem for a program |
| F3: changing-state loops and input families | A | Symbolic-count invariant derived from input bounds |
| F4: verified application | A | Ordered bounded FP16 dot product with a useful quantitative accuracy guarantee |
| F5: optional external hardware evidence | B | Retain prepared harness/vectors; new GPU measurements are optional and do not gate completion |
| F6: bounded EFT extraction and coverage | B | Machine operations, refinement, success family, and reproducible cost/coverage checks |
| F7: additional boundary operators/formats | Deferred | Neither track expands into this without an application-driven reason |
| F8: final artifact and claim alignment | A integrates; B supplies evidence | Combined validation, accurate docs, and explicit prior-work comparison |

F6 is a substantial proof and implementation task. Its ownership here does not turn
extractor scaffolding or a coverage script into completion. F5's unmeasured cases
are optional external work, not unfinished requirements for this formalization.

## Shared contracts to preserve

- Preserve `BlockInput`, `PreparedBlock`, `BlockTrace`, the meaning of `evalBlock`, the
  original-input ideal, and the existing raw-product/alignment semantics. Neither agent
  rewrites the reference model to simplify its new proof.
- Preserve `round32`'s public finite-range behavior and its correctness theorems. Keep the
  overflow guard; implementing an extended IEEE overflow policy is outside this split.
- Preserve `runBlocks`' low-level empty-list no-op behavior. Agent A enforces finite-input
  policy at the public dot-product wrapper and repairs its machine-equivalence statement
  accordingly. In particular, the present unguarded machine schedule on a NaN empty input
  cannot remain unconditionally equal to a newly guarded public wrapper.
- Agent A's changes to invocation validity must preserve positive-product FP16 behavior.
  Agent B uses those existing positive-product block profiles, with source floors, for the
  hardware paths. Generalizing beyond them is a separately stated theorem, not a hardware
  claim.
- Preserve the meanings of `scalarPredicate`, `tceft`, and their current successful results
  while establishing the baseline coverage gate. Agent B may rename the unchecked helper
  or require its predicate, updating its callers and proofs. Any later broader predicate
  must be distinguished from the baseline and independently proved sound.
- Keep `Conforms` explicit in any device theorem. Model output equality may be a hardware
  transfer premise; it cannot stand in for a missing machine-extraction refinement proof.

New declarations and filenames below are proposed implementation locations, not existing
APIs or promises that their proofs already exist.

## Agent A work package

### A1. Fix public domain inconsistencies (F1)

Use these policies to avoid spending both agents' time on competing interpretations:

1. Preserve zero-product block evaluation. Make the canonical aligned invocation agree at
   `K = 0`, including the CLI path; keep fused specifications restricted to one product.
   Extend the appropriate compatibility result and validate malformed/nonfinite inputs.
2. Reject a nonfinite initial accumulator at the public `runCanonicalDot` entry point even
   when the operand list is empty. Retain finite empty-input behavior and the low-level
   `runBlocks` no-op. Update every affected wrapper theorem, including machine equivalence;
   do not delete a theorem or silently lose its original finite-input guarantee.
3. State the existing finite-range rounding policy consistently in the public docs and
   examples. The `round32Core` result above `maxFinite32` is not an overflow specification.

Deliver a small independently buildable change with kernel regressions and CLI checks.
Coordinate only the F1 documentation with B; B owns the scalar-helper implementation.

### A2. Choose the application contract, then build certification (F2–F4)

Default application: an ordered FP16 dot product representing one row-column contribution
of a matrix multiplication, with finite FP32 initial accumulator, symbolic length, bounded
encoded operand values, and an absolute accuracy requirement. Retain arbitrary operand
signs where possible; include nonzero rounding error and an accumulator that changes.
Use the existing partition and encoded-boundary semantics. A tile language is unnecessary
for this first application.

Before designing the frontend, write down the mathematical ideal, input bounds, length
regime, derived error budget, and a quantitative tolerance that a useful regime can meet.
The final theorem must derive acceptance and `abs(ideal - rawOutput) <= tolerance` from
those inputs. Successful execution, exact prefix values, and the desired final error bound
must not be supplied as application hypotheses. Range restrictions derived from magnitude
and length bounds are legitimate and must be explained.

Implement in this order within A's track:

1. Add a program-level certificate contract and sound AST-to-schedule bridge in a new
   `TensorCore/Programs/CertifiedProgram.lean`. It must include successful execution and a
   bound for the uncorrected final output against the independent ideal. A tolerance form
   must additionally establish that the derived budget is at most the requested tolerance.
2. Implement `tc_certify` in a new `TensorCore/Meta/Certify.lean`, reusing
   `staticCheck_sound` for the first concrete path. Clearly label this path as a check on
   concrete inputs that computes exact ideal prefixes. Do not execute `Program.VC`, the
   hardware model, or the residual ledger to certify it.
3. Extend the analysis with a reusable invariant for changing accumulator state and
   accumulated error. Prove initialization and preservation from operand bounds for a
   symbolic iteration count. Reuse `runBlocks_static` or strengthen it as needed. This
   family proof must avoid enumerating iterations or computing exact input prefixes.
4. Apply the invariant and certificate to the chosen dot product. Provide a direct Lean
   theorem for the input family and a concrete frontend example. If the existing fixed-input
   AST cannot express the family, add a proved bridge to the family/schedule representation;
   a detached numerical theorem does not close the program application.
5. Measure certification time, error, budget tightness, and rejection reasons at multiple
   sizes and input regimes. Include cancellation, partial tails, and rounding loss. Keep
   rejection of a sufficient certificate distinct from an incorrect execution.

Acceptance is F2, F3, and F4 separately: a working command alone closes only F2, and an
unchanged-state cycle does not close F3. The application's raw accuracy proof must remain
usable without EFT extraction or an exact final correction.

### A3. Integrate the two tracks (F8)

Agent A owns shared imports, build registration, aggregate audit coverage, and final public
documentation. Incorporate B's completed modules and evidence as they arrive. Record the
final theorem hypotheses, executable behavior, validation, and remaining limitations.
Compare the delivered result with the source papers and the prior formalization identified
in PLAN; do not substitute theorem counts for a comparison of contributions.

## Agent B work package

### B1. Protect the scalar interface and preserve baseline coverage (F1, F6)

First fix the public unchecked helper. Prefer a public API that requires the predicate or
checks it; retain an explicitly named unchecked implementation only where needed to state
and reproduce the counterexample. Keep `tceft`'s partial contract and existing successful
results. Preserve the subnormal example: unchecked `0x3f800000`, correct `0x3f800001`, and
guarded failure. This API fix does not count as implementing extraction.

Add `scripts/check_eft_coverage.py` and a durable report, using the reproduction recipe in
PLAN. Initially evaluate the actual Lean baseline predicate, not a Python replacement.
Record model rejection, scalar acceptance, each failed condition, corrected bits against
the independent original-input oracle, and cases where correction changes the output.

The reviewed baseline is 5,000/5,000 published rows and 1,000/1,000 near-one cases accepted
per profile, versus 73/1,000, 13/1,000, and 0/1,000 broad finite-bit cases. All broad-cohort
predicate rejections failed the coefficient budget. Preserve these distributions when
evaluating improvements; label changed behavior and retain a baseline comparison.

### B2. Implement bounded extraction and prove refinement (F6)

Use new modules such as `TensorCore/Programs/EFMachine/` and
`TensorCore/Theory/EFMachine/` to isolate the implementation from the exact reference.

1. Define an executable interface taking encoded operand pairs, encoded `c`, encoded output
   `D`, and supported profile parameters. It must not require `BlockTrace`, extracted
   reference residuals, or the exact ideal as runtime inputs. State the finite/shape/range
   contract and signed-zero policy explicitly.
2. Choose bounded integer/bit-vector representations and derive their widths from format
   and group bounds. Implement decoding, product representation, component extraction,
   signed overlap computation, representability/support checks, and final correction.
   Prove shift bounds, absence of wrap, and representability at every machine operation.
   Unbounded `Rat` or `Int` remains valid on the specification side, not as hidden executable
   arithmetic in a claimed bounded implementation.
3. Prove that each machine component denotes the independently specified exact component,
   then connect successful correction to `NearestEven32` of the original-input ideal.
   Prove that the machine guard establishes the scalar prerequisites. Separately prove
   success for a useful input family; partial correctness alone allows universal failure.
4. Investigate a less conservative support grid based on actual nonzero low components.
   Any broadened predicate requires a new soundness argument. Keep the subnormal failure
   and other adversarial cases, unless a proved new algorithm correctly handles them.
5. Measure extraction, guard, and consolidation costs separately, including all integer
   operations. Compare with appropriate alternatives and application-like inputs.

An arbitrary supplied finite `D` may be handled by a recovery contract if justified; a
hardware claim still needs conformance. A refinement premise that simply assumes the
extractor's desired component equality is not a refinement proof. Reconstructing the
entire ideal to test range, hiding exact correction under a new name, or wrapping the
reference trace in a machine-looking structure does not satisfy F6.

### B3. Optional targeted hardware evidence (F5)

The preparation below has been delivered. Under the updated scope, running it on
real GPUs is optional and does not block the formalization or integration.

Add a dedicated harness under `tensor-core/hardware/` with input/output records under
`tensor-core/data/hardware/` and separate generation/replay scripts. Use the pinned source
harness as a reference, preserving provenance; do not edit the vendored measurements.

Cover multiple nonzero groups and ordering-sensitive cancellation on V100 and Ampere,
later-group population, signed zeros, and subnormal inputs/accumulators on the claimed
paths. Reuse the instruction-order regression when constructing distinguishable cases.
Store model expectations separately from measured outputs. Record device, instruction,
compiler and settings, and raw operand/output bits for actual runs.

Retain vector generation, harness preparation, replay, and run instructions, with
every unmeasured case labeled. New device experiments are optional external
validation. Continue the formalization and B2 without requiring hardware access.

## File ownership

Paths in this table are relative to `tensor-core/` unless prefixed with `/`.
An owner may change its listed files and add files in its reserved directories. Request an
explicit handoff before editing another owner's file. Existing files outside the table are
read-only until ownership is assigned; imports do not confer write ownership.

| Owner | Files and directories |
| --- | --- |
| A: domains and program theory | `Semantics/Invocation.lean` and `Semantics/Canonical.lean` under `TensorCore/`; `TensorCore/Theory/{Canonical,Compatibility,Invocation,StaticBudget}.lean`; `TensorCore/Programs/{Composition,DotProduct,ErrorBounds,Loops,Partition,Program,Report,StaticCertificate}.lean` |
| A: new certification/application code | `TensorCore/Programs/CertifiedProgram.lean`; `TensorCore/Programs/Certification/`; `TensorCore/Theory/ProgramBounds/`; `TensorCore/Applications/`; `TensorCore/Meta/{Syntax,Certify}.lean` |
| A: program regressions and tools | `TensorCore/Regression/{Programs,DotProduct,StaticBudget,Features,PublicDomains,Certification,Application}.lean`; existing examples except new B examples; `FeatureMain.lean`; `scripts/check_{features,dot_products,programs,certificates,application}.py`; corresponding feature, dot-product, program, certificate, and application reports |
| B: EFT specification and machine implementation | `TensorCore/Programs/EFT.lean`; `TensorCore/Theory/ScalarSum.lean`; `TensorCore/Programs/EFMachine/`; `TensorCore/Theory/EFMachine/`; new `TensorCore/Foundations/EFMachine/` |
| B: EFT and hardware evidence | `TensorCore/Regression/EFT.lean`; new `TensorCore/Regression/EFMachine/` and `TensorCore/Regression/HardwareEvidence/`; `examples/EFT*.lean`; `scripts/check_eft*.py`; new hardware generation/replay scripts; `data/regressions/eft*.json`; `hardware/`; `data/hardware/` |
| A: integration files, single writer | `/README.md`; `/split.md`; `docs/*.md`; `TensorCore.lean`; `Main.lean`; `lakefile.toml`; `Audit.lean`; `scripts/check_axioms.py`; `scripts/check_clean_build.py`; `docs/axioms.txt`; `data/regressions/clean-build.json` |
| Shared read-only baseline | Existing foundations other than assigned new files; `Semantics/Block.lean`, `Semantics/Accumulator.lean`, and `Programs/Instruction.lean` under `TensorCore/`; existing rounding/encoding/refinement proofs; `Regression/Cases.lean`; pinned vendor sources and original vectors |

Brace notation lists individual filenames; proposed paths may not yet exist. B sends A the
exact required imports, target registrations, and documentation facts rather than editing
integration files concurrently. New proof modules must be reachable from `TensorCore.lean`
for the final environment audit. If a new executable root is added, A also extends the
source scan; the current scanner explicitly lists `Main.lean` and `FeatureMain.lean`.

## Parallel execution and integration checkpoints

Use separate worktrees/checkouts with separate `.lake` caches. Both must start from the
same snapshot containing the updated PLAN and this file, not just `95d5f62`; those plan
changes were uncommitted when this split was prepared. Preserve unrelated working changes.
Do not create branches from an older plan and assume the review requirements are included.

1. **Start together.** A begins A1 and writes the application contract. B begins B1 and
   records the proposed machine interface/width strategy. Both can proceed immediately.
2. **Integrate API fixes early.** A incorporates B1's buildable helper fix and registers its
   exports. B receives A1's domain changes. Check positive-product model compatibility;
   resume A2 and B2 independently. Neither track waits for the other track's full proof.
3. **Integrate substantive milestones.** A delivers concrete certification, then the
   changing-state family/application theorem. B delivers baseline coverage, then bounded
   primitives, extractor refinement, and a success family; B3 proceeds as time/hardware
   allows. Import only complete, checked modules; no placeholder theorem enters the build.
4. **Review across tracks.** A checks that B's executable dependency path contains no exact
   ideal/trace shortcut. B checks that A derives its application conditions and tolerance
   without exact-prefix enumeration or an unchanged-state cycle. Report concrete theorem
   statements, assumptions, and counterexamples rather than proof length.
5. **Final integration by A.** Register every new module and check, regenerate shared
   reports once, and update each F item separately. Hardware measurement, extraction,
   frontend, and symbolic application completion are distinct statuses.

Each handoff includes changed files, theorem statements and hypotheses, executable changes,
commands/results, rejection behavior, unresolved obligations, and requested shared-file
edits. Avoid broad refactors or renames outside the owned track. If a foundational defect
requires a shared change, assign one writer, land it as a small checked change, then update
both checkouts before continuing dependent work.

## Validation and completion

During development, compile new modules explicitly with Lake until integrated into the
default target. Audit their theorem dependencies using an audit entry point importing those
modules; an unchanged whole-repo audit does not cover unimported declarations. Keep
branch-local audit/report outputs separate; in a shared checkout only A writes aggregate
reports and the shared build cache.

A runs the relevant public-domain, frontend, partition, certificate, loop, and application
checks. B runs EFT interface/counterexample, bounded-operation/refinement, independent
corrected-output, coverage, and hardware-replay checks. Concrete numerical regressions
remain kernel-checked; runtime comparisons remain test evidence.

After integration, A runs from `tensor-core/`:

```sh
lake build
python3 scripts/check_axioms.py
python3 scripts/validate.py
python3 scripts/check_features.py
python3 scripts/check_dot_products.py
python3 scripts/check_device.py
python3 scripts/check_device_formats.py
python3 scripts/check_programs.py
python3 scripts/check_clean_build.py
```

Also run every delivered certificate/application/EFT/hardware-replay check and all relevant
examples. Extend `check_clean_build.py` to include the delivered new checks and examples;
its existing command list will not discover them automatically. Preserve all baseline
adversarial regressions and source hashes. Report current warning and theorem counts from
the actual run, not the old baseline.

The combined delivery is complete only for the required F items whose implementation,
theorem, discharged assumptions, and software validation meet PLAN. F5 is optional:
record absent GPU measurements as unmeasured, without blocking completion. Keep F6
open if only its API or coverage portion is finished. F7 remains deferred. A clean
build alone does not change those statuses.

## Agent A completion handoff — 6 September 2026

A1 and the A2/F2–F4 implementation are complete and validated in the isolated A source
copy. The delivery is copied to the shared workspace; the independent merge monitor owns
`merge.md` and the final combined snapshot. A does not modify B-owned files or claim that
its isolated validation includes B's delivery.

- **Domains:** aligned `K = 0` agrees with block evaluation; fused calls remain `K = 1`.
  Public empty dots reject nonfinite initial c. Guarded machine equality and the finite
  low-level guarantee are both retained. The public rounding range guard is unchanged.
- **Certification:** `Program.Accurate`, `Program.staticCertificate_sound`, `tc_certify`,
  and `tc_certificate` establish/inspect successful raw execution and requested tolerance.
  The concrete path computes exact ideal prefixes; executable dependency tests rule out
  model or ledger execution.
- **Symbolic analysis:** `runBlocks_of_scale_bound`, `Program.accurate_of_scales`, and
  `Program.repeat_accurate_of_scales` derive the prefix/state/error invariant from operand
  scales and total count. The proof does not enumerate symbolic iterations or require an
  unchanged accumulator.
- **Application:** `boundedDot_accurate_of_bits` covers up to 256 signed FP16 pairs below
  magnitude 1/16 and a finite FP32 initial magnitude at most 1. AST execution agrees with
  the public ordered partition; the ideal uses original unpadded inputs. Derived absolute
  raw error is at most `2^-11`. `boundedDotCheck_sound` uses only family membership checks.
- **Validation:** fresh build 142 jobs, audit 746 roots / 454 written in source, standard
  Lean axioms only. Zero Lean warnings; two `ld64.lld` missing-`/usr/local/lib` warnings.
  Eight certificate rejection cases and the dependency negative control pass. Application
  checks: 87 cases, zero oracle mismatches, 52 family acceptances, 69 concrete acceptances,
  29 accepted nonzero-error cases and 26 accepted partial tails. All baseline suites and
  all six A/baseline standalone examples pass in the fresh source copy.
- **Criticisms retained:** bounds are conservative, rejection is sufficient-condition
  failure, operands cannot depend on rounded state, CLI timings include diagnostics,
  and no CUDA/kernel-layout/hardware theorem follows. F5/F6 and final F8 remain separate.

New imports are already in A's `TensorCore.lean`. `FeatureMain` adds `certificate family`
and `certificate concrete`; no new executable target is required. The clean-build script
now runs both new checks, both independent oracles, every existing replay, and all standalone
examples. Its linker-warning matcher handles `ld`, `ld64.lld`, and `ld.lld`.

For final integration: retain B's owned delivery, add B's `scripts/check_eft.py` to the
combined clean-build gate, regenerate aggregate reports/counts, and update B-specific shared
documentation from `eft-handoff.json`. The A report/counts are isolated-track evidence, not
combined counts. The full A manifest and validation contract are recorded in
`tensor-core/data/regressions/application-handoff.json`.
