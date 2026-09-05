# Plan

Written after the 5 September 2026 review of the code, the two papers, and the MATLAB
v0.5 source. It records what is established, an assessment of what is substantive, and the
order of the next steps.

## Where things stand

- V100 FP16 → FP32 executable model with exact traces. R1–R4, rounding boundaries, zero and
  subnormal branches, rejection cases, a non-monotonicity witness, and a two-block
  cancellation example are kernel-checked.
- Raw-product, alignment, accumulation, and output bridges; the stage residual identity; the
  two-stage error bound `abs(S − D) < n·qA + qD`.
- Nearest-even FP32 conversion proved correct for every rational in the finite range;
  corrected block and schedule results.
- Exact residual ledger over any finite chain of invocations through encoded FP32
  boundaries; sequential composition; a symbolic-count cycle invariant.
- Typed program AST, `tc%{ }` syntax, `tc_verify`, `tc_inspect`, with soundness and
  diagnostic-agreement theorems.
- The canonical FP16 → FP32 invocation parameterized by product count `K` and extra
  alignment bits: `fp16Fp32_contract` (recovery, output, error bound, and a machine-width
  refinement for any `K` and extra bits), proved equivalence with the original evaluator,
  and inactivity of any floor at or below −126 on FP16 paths. Ampere (`K = 8`, 1 extra bit)
  and Hopper (`K = 16`, 2 extra bits) instances match the published A100 and H100 FP16
  vectors, 5,000 rows each, bit for bit.
- A generalized `InvocationSpec` evaluator with ordered conversion stages, c placement, and a
  fused variant, with exact loss accounting proved for every specification. Only FP32 output
  has rounding-correctness proofs; other formats are executable specifications without
  device evidence and are not claimed.
- Independent Python oracles (fixed-profile and parameterized), three device-vector families,
  frontend rejection tests, and a standard-axiom audit of 117 theorem roots.

## Assessment

Substantive results so far:

1. `round32_nearestEven_correct`. A general nearest-value and ties-to-even proof for the
   FP32 converter over all rationals in range, including subnormals, carries, and the
   lower-binade argument. This is the one genuinely hard proof in the tree.
2. Fidelity of the executable model. The raw-scale sensitivity (R1), unnormalized products,
   c-in-group alignment, and truncation policy were checked against the paper, the MATLAB
   source, an independent oracle, and 15,000 device vectors across three GPU generations.
   Earlier formal models (Valpey et al.) abstract an instruction as one accumulation in any
   order; this model is finer and is validated where those differ.
3. Composition scaffolding. The ledger over encoded boundaries with symbolic length, the
   cycle invariant, and a program checker whose generated theorems are ordinary kernel-checked
   terms with rollback on failure.
4. The parameterized contract and the floor-inactivity lemma, which turn V100-specific
   results into results over `K` and extra bits with the same proofs.

Bookkeeping, not results: the residual identity (a telescoping sum; the TC-EFT paper says
the same), the definitional bridges, and regression evaluations. Nothing here is a proof
about hardware; every device claim is test evidence.

Where the substance lies ahead: the scalar EFT (TC-EFT IV.8–IV.11, which needs real
FP32 additions and representability arguments), the non-monotonicity theorems (III.4–III.5
as parametric theorems rather than one witness), and instruction composition under explicit
conformance premises. Those are the targets that would make this more than a validated model
with a correct rounding routine.

## Next steps, in order

1. **Close the canonical gate.** Add the ordered `alignmentScale` specification (maximum,
   membership, all-zero) as one theorem; state the V100, Ampere, and Hopper instances with
   their device evidence in the theorem map; and fold `check_device_families.py` into the
   clean-build script. Compare the vendored FP16-output vectors once the FP16 output stage
   exists; the A100 and H100 files include them.
2. **Fix the known issues** listed below.
3. **Scalar EFT.** Define `fp32Add x y := round32 .nearestEven (x + y)` on values, prove
   Theorem IV.8 (every prefix of a naive sum is exact under the coefficient bound) by
   induction with representability, Lemma IV.10, and Corollary IV.11; implement Algorithm 1
   with its predicate and exact-dyadic fallback; check R2, R3, and the paper's cancellation
   example (`449fbe50` to `449fbe62`).
4. **Non-monotonicity as theorems.** Prove III.4 and III.5 over `K` and padding `p` for the
   canonical family, with the realizable operand encodings, rather than the single V100
   witness.
5. **Composition layer.** Boundary operators as data (encoded conversion, unnormalized
   combination, scalar addition), a generic ledger over them, instruction descriptors with a
   k-partition and a `Conforms` premise, a `tc_instruction` command that elaborates a pinned
   path into a schedule, and a symbolic-length long dot product. See COMPOSITION.md.
6. **Evidence for grouping.** The published vectors only ever fill k positions `0..K−1`, so
   they do not test group order. Vectors with nonzero products in later positions and a c
   that makes order visible are needed on a real GPU; the harness in the v0.5 archive is the
   template.
7. **Matrix mapping and one application.** A tile-level `mma` operation elaborated to
   per-cell schedules, a mapping theorem, and one verified application or transformation.

Deferred by decision: BF16, TF32, FP8, FP16 output, FP64 FMA, input conversion and flush
policies, and late-c paths. The `InvocationSpec` scaffolding can describe them, but no proof
or evidence beyond exact loss accounting should be claimed until the reconciliation register
in FEATURE_COVERAGE.md is settled.

## Design rules

- Elaborators produce data and apply existing theorems. They never define a second
  arithmetic, and every generated statement is inspectable.
- A hardware claim is an explicit premise (`Conforms path`), never an axiom.
- Numbers in documentation (roots, vectors, cases) come from the scripts' reports.
- The audit root list should be generated from the environment; the placeholder scan should
  cover every Lean file, not only `TensorCore/`.
- Documentation stays at README, SPECIFICATION, THEOREM_MAP, ASSUMPTIONS, VALIDATION, DSL,
  COMPOSITION, FEATURE_COVERAGE, INVOCATION_CONTRACT, and PLAN. Session narratives do not
  belong in the repository.

## Known issues

1. `tc_verify` rolls back whenever the file already contains any earlier error, because it
   inspects the whole message log. One unrelated error therefore hides every later
   verification. Compare message counts before and after elaboration instead.
2. `round32` rejects magnitudes in `(maxFinite32, 2^128)` under round-toward-zero, where IEEE
   truncation and the MATLAB model both return `maxFinite32`. Either keep the guard as a
   documented restriction or prove the truncation case.
3. `check_axioms.py` scans only `TensorCore/` for placeholders and audits a hand-maintained
   list in `Audit.lean`.
4. `roundBinary` exists for every format and directed mode but is proved only to agree with
   `round32` on FP32. Its general correctness is required before any non-FP32 output stage is
   claimed.
5. The device comparisons contain almost no zero or subnormal operands or c (0 rows for
   V100, 1 for A100, 5 for H100). Those branches follow the MATLAB source and need targeted
   vectors.

## Risks

- Two agents editing one working tree. Publish from a snapshot commit built in a clean copy;
  never push a tree whose default target does not build.
- Documentation drift. Keep claims tied to script output and theorem names.
- Scope creep into every format. The canonical FP16 → FP32 family is the gate; the rest waits.
