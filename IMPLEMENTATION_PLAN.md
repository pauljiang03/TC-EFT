# Repository implementation plan

## IEEE equivalence and migration to Lean operations

Status: scalar IEEE migration and native FP32 EFT accumulation completed, with
complete preservation proofs and a passing fresh full-suite validation.
This is repository engineering work, separate from the research proposal
intended for PI review.

See [compatibility decisions and proof structure](tensor-core/docs/lean-ieee-compatibility.md).
The original reference remains in place. Zero operands, special values, exact
results outside the finite reference range, other rounding modes, FP16, FMA,
and conversions retain their existing implementation. Conversion APIs in
Lean 4.33.1 are opaque; this audit does not justify replacing them.

Prove that our standard IEEE operations agree with Lean's built-in logical
floating-point model on precisely matched semantics, then replace the
corresponding implementation paths with Lean operations behind proved adapters.
Keep the tensor-core model, including its alignment, grouped accumulation,
rounding stages, and residual semantics. EFT and GEMM references retain their
definitions and arithmetic contracts. The executable EFT scalar branch now uses
native FP32 addition through a separate proved adapter.

The trust benefit is proved agreement between two definitions. The migrated
paths delegate result-bit computation to Lean, while retaining custom computation
for the domain checks and flags. Both logical models are checked by the same
Lean kernel; switching implementations does not itself strengthen the kernel
or prove the native runtime, compiler, or physical GPU correct.

The completed result is preservation of the entire scalar `Result` for every
wrapper input and context, plus agreement with Lean's logical arithmetic on the
documented native domains. Together with independent oracle comparisons, this
is strong evidence for the implementation. The native EFT bridge also proves
complete result preservation and transfers the original correctness/success
contracts. The EFT/GEMM checks supplement those proofs; they do not broaden the
hypotheses or establish new hardware conformance.

### 1. Establish the compatibility contract

- [x] Pin the comparison to the repository's Lean 4.33.1 toolchain and inspect
  the actual `Float32.Model`/`Float.Model` definitions and native interfaces.
- [x] Record an operation-by-operation compatibility table: input/output
  formats, rounding mode, signed zeros, subnormals, overflow, infinities,
  NaN sign/payload/signaling behavior, exception flags, and tininess policy.
- [x] Start with binary32 addition under round-to-nearest, ties-to-even.
  Extend to subtraction and multiplication after the first migration passes.
  Audit binary64 and format conversions as subsequent milestones.
- [x] State the exact supported input domain for each bridge, including
  exceptional outputs that can arise from ordinary finite inputs.

Our IEEE API exposes flags and preserves selected NaN payloads. Lean's native
interface canonicalizes NaNs and does not supply that complete result contract.
The migration must retain proved handling of those differences. FP16, directed
rounding, and one-rounding FMA remain custom wherever an equivalent Lean
primitive has not been established. Separate multiplication and addition must
not replace fused multiply-add.

### 2. Prove representation and operation equivalence

- [x] Add dedicated bridge modules, starting with
  `tensor-core/TensorCore/IEEE/LeanBridge.lean`, with explicit adapters between
  our encoded words and Lean's logical float representation.
- [x] Prove bit-preserving round trips on the supported domain, including
  both zero signs. State NaN canonicalization separately from bit equality.
- [x] Prove each operation agrees for every input satisfying its compatibility
  preconditions. Compare against the existing exact-arithmetic reference;
  preserve that reference definition after migration to avoid a circular
  comparison between aliases of the same implementation.
- [x] Audit each bridge theorem's dependencies with the repository's proof
  audit. Accept no new unproved assumptions or native-evaluation shortcuts.

For a binary operation, the initial bridge has the schematic contract:

```text
compatible(x, y) ->
  encodeResult(customOperation(x, y)) =
    leanLogicalOperation(encodeInput(x), encodeInput(y))
```

`encodeResult` must document any information it drops. Numerical equality or
equality after NaN canonicalization is insufficient to authorize replacing an
API that exposes differing bits or flags.

### 3. Migrate one operation while preserving its public contract

- [x] Implement a small wrapper using Lean's corresponding operation on the
  proved domain, with proved handling or the existing path for unmatched cases.
- [x] Preserve result bits, flags, tininess policy, and any exposed failure
  behavior. Prove full result equality with the old implementation:

  ```text
  migratedOperation(context, x, y) = referenceOperation(context, x, y)
  ```

- [x] Transfer existing specification theorems through the equivalence proof
  and update callers only after this preservation theorem is kernel checked.
- [x] Retain the mathematical reference and bridge lemmas. Remove duplicate
  implementation code only when its callers and guarantees have transferred.
- [x] Avoid computing the reference's rounded bit encoding again on the native
  path. Retain exact arithmetic for domain checks and flags, and retain the
  independent reference for proofs, comparisons, and unmatched cases. This
  migration adds bridge proofs; it does not reduce total source size.

### 4. Validate the migration

- [x] Replay affected IEEE, binary-rounding, tensor-core, and EFT proofs.
- [x] Add meaningful adapter and compiled-execution checks covering ties,
  cancellation, subnormal boundaries, overflow, infinities, signaling/quiet
  NaNs, payload selection, and both zero signs. Differential tests supplement
  the universal equivalence proofs.
- [x] Verify that `tc ieee` preserves its JSON result bits and flags and that
  existing tensor-core/EFT/GEMM examples and certificates retain their contracts.
- [x] Run `./tc build`, `./tc audit`, and the relevant regression checks during
  development; run `./tc check` for the completed migration milestone.
- [x] Record the proved scope, remaining fallbacks, and native-execution trust
  assumptions in the repository documentation.

### 5. Expand only after the first operation is complete

- [x] Apply the same proof-first process to binary32 subtraction and
  multiplication, then audit binary64 and conversions.
- [x] Keep unmatched features and tensor-core behavior in their existing
  models; migrate an additional path only with its own preservation theorem.
- [ ] Recheck bridge proofs, adapters, and runtime regressions on Lean upgrades.

### 6. Connect EFT scalar accumulation to native FP32 addition

- [x] Extend the finite addition bridge to zero operands and preserve EFT's
  positive exact-zero convention and exact-range rejection policy.
- [x] Use native FP32 addition for the residual fold, overlap subtraction, and
  final scalar addition; retain bounded extraction, guards, and exact fallback.
- [x] Prove equality of the primitive, complete fold, scalar branch, and complete
  Algorithm 1 result, including branch tags and errors for every input.
- [x] Transfer correctness, success, and range equivalence for all eight paths.
- [x] Switch `tc eft` to the proved native path while retaining the original
  reference and generic FP64 scalar model.
- [x] Add kernel boundary witnesses, 7,988 compiled fold comparisons, and 3,953
  complete original/native comparisons with error controls and dependency audit.
- [x] Complete the fresh full-suite replay and record its source fingerprints.

The FP32/FP64 scalar IEEE migration and native FP32 EFT extension are complete.
The clean suite passed all 53 gates (420 build jobs, zero Lean warnings). The
theorem audit covered 2,354 public roots using only standard Lean axioms. The
independent IEEE/SoftFloat comparison passed 341,472 cases, and the Lean
logical/native comparison passed 28,032 cases. Native EFT passed 7,988 fold
comparisons and 3,953 complete original/native result comparisons. NaN policy
differences are explicitly handled as described in the compatibility document.
See the [evaluation](EVALUATION.md) for reports and execution-trust limits.
The reports retain the fingerprints from the completed native EFT validation
run; source snapshot stability and workspace agreement both passed.

Future toolchain upgrades require revalidation. Any expansion of the native
domains or replacement of the retained operations requires its own preservation
proof; it is not assumed by the completed milestone.

### Existing starting points

- [IEEE representations, contexts, and flags](tensor-core/TensorCore/IEEE/Basic.lean)
- [Current arithmetic and conversions](tensor-core/TensorCore/IEEE/Operations.lean)
- [IEEE specification theorems](tensor-core/TensorCore/IEEE/Specification.lean)
- [Existing compatibility results](tensor-core/TensorCore/IEEE/Compatibility.lean)
- [IEEE regressions](tensor-core/TensorCore/IEEE/Regression.lean)
- [Pinned toolchain](tensor-core/lean-toolchain)

The native bridges now live in `LeanBridge.lean` and `LeanBridge64.lean`;
`NativeOperations.lean` supplies the migrated wrappers and their total
preservation theorems. The original `Compatibility.lean` remains unchanged.
