# Context handoff — 5 September 2026

## User intent and stopping point

The user requested a plan review and then explicitly replaced implementation
with preparing the repository for a new context. This increment changes
documentation only. No new Lean definitions, proofs, profile instances, or
scalar EFT implementation were added during this handoff preparation.

Latest scope decisions, in order of authority:

- One invocation is **one dot product with unnormalized products and a block
  accumulation**, including its specified alignment/output behavior. It is not
  being redefined as a whole PTX instruction, matrix tile, or multi-group chain.
- Complete that invocation's general parameterized feature model and proofs
  first. The target is reusable results across supported feature sets, not
  merely a V100 theorem or changing a few architecture constants.
- EFT is another local result to formalize, not the organizing purpose of all
  later work. Uncorrected output/error/equivalence contracts are useful too.
- Downstream composition must remain concretely planned and eventually
  implemented, after the invocation gate. [CURRENT_PLAN.md](CURRENT_PLAN.md)
  gives the sequence and exit criteria, including hardware mapping.

When asked to resume, start with **the feature coverage matrix and precise
single-invocation contract**, then implement/prove the generalization in
reviewable increments. Do not jump straight to scalar EFT, more DSL syntax,
or PTX mapping based on older next-step lists.

## Current implementation

Work from `tensor-core/` for Lean commands. Lean is pinned to **4.33.1**;
there are no external Lean dependencies. Exact values use `Int` and `Rat`.
The full working tree matters: HEAD is `c20e688` (Fable's profile record),
and substantial later code is modified or untracked. Preserve it; HEAD alone
does not contain the current result. No commit/reset/cleanup was performed
for this handoff.

| Area | Entry points and actual scope |
| --- | --- |
| Exact arithmetic and bits | `TensorCore/Foundations/{Exact,Encoding,Rounding}.lean`: custom field decoding and explicit finite FP32 conversion; no reliance on native Float for tensor arithmetic. |
| Feature schema | `TensorCore/Semantics/Profile.lean`: input format, product count, alignment fraction, optional floor only. `v100F16F32` is the only instantiated profile. |
| One dot-product invocation | `TensorCore/Semantics/{RawProduct,Block}.lean`: decode, raw significand product/scale sum, global alignment, exact signed accumulation, encoded FP32 RTZ result. c/output are fixed FP32; c participates in the same alignment. |
| Representation/rounding | `TensorCore/Theory/{Encoding,Rounding,ConversionBounds,CorrectRounding}.lean`: finite FP32 representation, bounded encoding, general finite-range RNE nearest-value/even-tie correctness. General format/converse/fixed-point APIs remain incomplete. |
| Arithmetic contracts | `TensorCore/Theory/{Alignment,StageResiduals,ErrorBounds}.lean`: signed alignment loss, exact stage recovery, strict two-stage output error bound. No machine-width refinement. |
| Existing composition | `TensorCore/Programs/{Composition,Correction,Program,Report,Loops}.lean`: supplied fixed-input schedules, exact rational ledger, independent original-bit ideal, sequence/cycle induction, and diagnostics. |
| DSL | `TensorCore/Meta/Syntax.lean`, `docs/DSL.md`: typed calls, sequence/repeat, `tc_verify`, `tc_inspect`; proof production via proved conditions. No general scalar/program/GPU semantics. |
| Checked examples | `TensorCore/Regression/`, `examples/Verify.lean`, `examples/SingleInvocation.lean`. The standalone single-invocation example is not imported by `TensorCore.lean` or the 83-root audit. |

`round32_nearestEven_correct` and `finalRound_correct` are general proofs, not
just regression results. `Program.recovery` connects execution to the ideal
sum decoded independently from original operands. `Program.vc_sound` proves
successful reference correction under its conditions. Neither theorem makes
that correction into an FP32 residual-accumulation algorithm.

## Essential semantic decisions

- Preserve unnormalized raw product scales. Equal product values from
  different factors can yield different outputs (R1).
- Truncate signed values toward zero by truncating magnitude and restoring
  sign. Do not replace this with negative arithmetic shift without a proof.
- Nonzero subnormal c contributes raw scale -126. Ignore zero terms in eta;
  handle all-zero separately. Floors apply to the nonempty maximum.
- The V100 block has four products plus c, F=23, and no relevant floor.
  Its exact signed accumulator is unbounded `Int`, not a modeled register.
- Public `round32` rejects `abs(x) > maxFinite32`. `round32Core` is a proof
  helper, not a complete IEEE overflow policy. Final exact-sum range is a
  separate condition from successful intermediate model evaluation.
- Exact cancellation outputs +0; negative nonzero values rounded to zero keep
  their sign. Numerical nearest-value proofs do not distinguish the two zeros.
- The original R4 midpoint expectation was wrong: `1 - 3*2^-25` rounds to
  **0x3f7ffffe = 1 - 2^-23**. Keep the corrected regression.

## Composition answer already given to the user

`runBlocks` follows an explicit supplied list. Each call receives the preceding
call's returned FP32 bits. With local law `d_(j-1) + P_j = d_j + e_j`, induction
proves `c0 + sum(P_j) = d_m + sum(e_j)`. All residual summation is exact `Rat`.
This is a model schedule theorem, not a discovery of GPU ordering or a proof
that reordering leaves uncorrected outputs unchanged.

The intended general approach is to compose encoded-state transitions and
their arithmetic/error contracts, with separate contracts for scalar steps.
Dependent calls pass results; independent calls can form a dependency graph.
That structure can reflect GPU execution, but the actual grouping, rounding
boundaries, and ordering must be connected to a chosen instruction path.
No such complete hardware mapping is currently proved. See
[PTX_BOUNDARY.md](PTX_BOUNDARY.md) for the inspected source evidence.

## EFT status and paper details

**The actual scalar FP EFT in the revised paper is not yet formalized.**
The existing reference recovers the ideal sum from exact alignment/output
residuals and rounds it once. That is useful but does not implement the
paper's coarse components, overlap subtraction, or naive scalar additions.

For later local EFT work: IV.1–IV.5 define qE=max(qA,qD), exact h_i/epsilon_i,
H=sum(h_i), and epsilon_o=D-H. IV.8 bounds the sum of absolute integer
coefficients on a common grid to prove every scalar prefix representable.
IV.10 needs D, epsilon_o, and H representable; IV.11 then justifies one final
correctly rounded addition. Algorithm 1 includes a predicate-selected FP32
branch and exact-dyadic fallback. FP64 addition then FP32 conversion may
double-round. VIII explicitly leaves efficient multi-group ledger storage and
consolidation as future work. No cheap extractor or four-invocation scheme
follows from the reference identity alone.

R2 exercises nonzero coarse overlap despite zero total stage residual. R3 has
model output `4107ffff`, exact residual `15*2^-24`, and corrected `41080000`.
The two-group cancellation example returns `b5800000` before correction and
recovers `b3800000` using the exact rational ledger.

## Sources and navigation

- [Accurate Models v4](../../2512.07004v4.pdf): controls tensor arithmetic;
  §§2, 4.1–4.2, architecture figures, Tables 2–4 are central to generalization.
- [Revised TC-EFT](../../tc-eft-corrected.pdf): local arithmetic/EFT contracts;
  II–IV, Algorithm 1 (p. 12), and VIII distinguish the claims above.
- [SPECIFICATION.md](SPECIFICATION.md) pins both PDF SHA-256 hashes and
  v0.5 commit `bbcf00a273868172494eaacaa8d6128ab0fb8704`.
- `vendor/SOURCES.json` hashes the unmodified selected MATLAB source and
  published V100 vectors. Additional source is in the unpacked release at
  `../../tmp/matlab-tensor-core-v0.5-full/` and its tarball; this full archive
  is not a Lean build dependency.
- Extracted paper text is in `../../tmp/pdfs/2512.07004v4.txt` and
  `../../tmp/pdfs/tc-eft-corrected.txt`, with page markers. Two-column text can
  interleave; consult the PDF/available page PNGs for ambiguous formulas.
- [THEOREM_MAP.md](THEOREM_MAP.md) and [ASSUMPTIONS.md](ASSUMPTIONS.md) identify
  declarations and proof domains. Historical Fable and plan reviews are
  background; [CURRENT_PLAN.md](CURRENT_PLAN.md) governs future ordering.

## Verification at the handoff

Rerun successfully during this documentation checkpoint:

```sh
lake build
python3 scripts/check_axioms.py
lake env lean examples/SingleInvocation.lean
```

Build: 51 jobs. Audit: 83 roots, only `propext`, `Classical.choice`, and
`Quot.sound`. The standalone example also printed only standard dependencies.
The audit scans Lean source for forbidden proof shortcuts even in comments;
inspect `scripts/check_axioms.py` before adding explanatory proof comments.

Existing recorded runs, not repeated during this documentation-only revision:

- `scripts/validate.py`: 715 blocks, 2,918 rounding cases, zero mismatches,
  three intended nonfinite rejections.
- `scripts/check_device.py`: 5,000 published V100 FP16/FP32 vectors, zero
  mismatches. These lack zero/subnormal operands/c. No GPU was run here.
- `scripts/check_programs.py`: public DSL example and ten intended rejection
  cases pass, including rollback of failed generated declarations.
- `scripts/check_clean_build.py`: fresh source copy builds 51 targets, audits
  83 roots, and passes frontend checks without preexisting `.lake` artifacts.

Reports are in `data/regressions/`; details are in [VALIDATION.md](VALIDATION.md).
For future code changes, import new modules, add meaningful theorem roots to
`Audit.lean`, and run the affected checks. Keep proof, numerical comparison,
and device evidence separate when reporting progress.
