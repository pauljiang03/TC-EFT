# Current evaluation

Updated 9 September 2026. This evaluation covers the IEEE scalar extension and
the proved migration of selected operations and EFT scalar accumulation to
Lean's native floats, following the finite-theory baseline
`6406712e456c8d36f662a70be8065d7022e14566`. Validated source fingerprints are
recorded in the linked reports. Prepared by Codex, which also implemented these
changes; this is not an independent human review or author sign-off.

**Assessment:** the new scalar layer has general Lean correctness contracts and
passes independent numerical and exception-flag comparisons. The original finite
tensor-core theory and exact IEEE reference are retained. The native wrappers
and native EFT path have universal full-result preservation proofs. Full IEEE 754
coverage and hardware verification remain outside this work.

## What changed

The new `TensorCore.IEEE` API implements FP16/FP32/FP64 format conversion,
addition, subtraction, multiplication, and single-rounding FMA. It accepts every
input encoding, preserves operation-specific zero signs, handles infinities and
quiet/signaling NaNs, and reports invalid, overflow, underflow, and inexact flags.
The divide-by-zero flag is represented but is never raised by these operations.
`Result.accumulate` supplies sticky flag accumulation.

The command `./tc ieee FILE` exposes these operations as JSON Lines. Both
before-rounding and after-rounding tininess are supported; a computation should
use one policy consistently. NaN propagation selects the first signaling NaN,
otherwise the first quiet NaN, with a documented sign/payload policy. See the
[guide and scope](../README.md) and [input schema](../data/schemas/ieee.schema.json).

The old finite `roundBinary`, tensor-core invocations, and GEMM pipelines keep
their existing behavior. IEEE scalar calls use the separately named API. In
particular, IEEE exceptions have not been inserted into GEMM epilogues or their
accuracy predicates. Their current contracts require finite decoded ideals.

The original EFT definitions remain independent references. `tc eft` now calls
`algorithm1WithLean`, whose residual fold, overlap subtraction, and final scalar
addition use Lean's native FP32 addition. Bounded decoding, extraction, guards,
and exact fallback retain their existing definitions. General theorems preserve
the entire EFT result, including branch tags and errors, and transfer correctness,
success, and exact range equivalence for all eight paths. The generic FP64 scalar
model and GEMM arithmetic remain in their original implementations. Certificate
arithmetic contracts and source-fingerprint checks remain in force.

The EFT native adapter accepts finite encoded operands whose exact sum is in
the original finite range; it normalizes `-0 + -0` to `+0`. These are the existing
finite EFT policies, separate from the complete IEEE scalar API's status and
zero-sign contract. The execution path uses bounded words for guards and native
addition for result bits, without rational intermediates or a duplicate reference
rounding. Exact extraction and the fallback still use 576-bit words.

The scalar support conditions make the residual accumulation exact. The final
FP32 result can still require rounding, and arbitrary naive accumulation outside
those conditions need not be exact. Kernel witnesses explicitly distinguish
left-to-right rounding from summing all terms exactly and rounding only once.

The CLI now uses Lean's native FP32/FP64 nearest-even addition, subtraction, and
multiplication when both operands are nonzero and finite and the exact result
is within the maximum finite magnitude. Kernel-checked bridges establish this
domain; total wrapper theorems preserve every result bit and flag for all inputs,
including reference fallbacks. FP16, other modes, zero operands, nonfinite inputs,
out-of-range exact results, FMA, and conversions retain the original implementation.
Lean 4.33.1's format-conversion APIs are opaque, and its native NaN policy differs
from ours. See the [compatibility audit](../docs/lean-ieee-compatibility.md).

## Mathematical content and trust

- [Precision rounding](../TensorCore/IEEE/Precision.lean) is specified by
  binade inequalities and integer optimality, including even tie breaking.
  Existence and uniqueness are proved. Additional nearest, greatest-lower-bound,
  and least-upper-bound theorems quantify over dyadic competitors with unrestricted
  exponents. These results support the exception conditions.
- [Total rounding](../TensorCore/IEEE/Rounding.lean) extends the existing
  finite optimality results to signed zero and out-of-range inputs. The overflow
  flag is proved equivalent to exceeding the finite endpoint after rounding with
  an unbounded exponent range. In-range rounding cannot signal overflow.
- [Operation contracts](../TensorCore/IEEE/Specification.lean) cover every
  encoded input and every implemented rounding/tininess mode. Finite cases use
  exact decoded arithmetic and the rounding relation; nonfinite cases specify
  results and flags. No successful-execution or desired-accuracy premise is assumed.
- [Compatibility](../TensorCore/IEEE/Compatibility.lean) proves that
  same-format finite conversion preserves every encoding, including both zeros,
  with no flags. Quiet NaN payloads survive widening/narrowing. Nonzero in-range
  rounding agrees with the previous finite converter.
- [Native equivalence](../TensorCore/IEEE/LeanBridge.lean) and its
  [FP64 specialization](../TensorCore/IEEE/LeanBridge64.lean) connect raw
  fields, alignment, round/sticky metadata, exponent selection, carries, and
  packing to the exact reference. These are general proofs, not enumeration of
  samples. The [wrappers](../TensorCore/IEEE/NativeOperations.lean) prove
  full result equality and inherit the existing operation specifications.
- [Native EFT addition](../TensorCore/IEEE/LeanFiniteAddition.lean)
  covers finite zero operands as well as nonzero operands. The
  [EFT preservation proofs](../TensorCore/EFT/Native.lean) lift
  primitive equality through the complete encoded fold and Algorithm 1, then
  transfer the original finite-input correctness, success, and range contracts.

The finite rounder's option is eliminated using its existing totality theorem,
not a default result. Proofs use Lean's kernel and standard library. The exact
reference remains independent of native float operations. The migrated paths use
Lean's native backend for result bits and exact rational arithmetic for domain
checks and software exception flags. SoftFloat is a separate test reference.
Agreement with Lean's logical model does not verify its compiler or native backend,
and no performance advantage or entirely fixed-width implementation is established.

## What the agreement establishes

The evidence answers two separate questions. The universal wrapper theorems
establish that this migration preserves the original public results. On the
selected finite domains, the bridges additionally establish agreement between
our exact IEEE reference and Lean's independently defined logical arithmetic.
Outside those domains, preservation follows from keeping the original computation;
it is not a theorem identifying every special-value policy with Lean's policy.

Independent ordered-encoding and SoftFloat comparisons provide further evidence
that the reference's numerical results and flags implement the intended rules.
These comparisons are samples over the implemented operations, with exhaustive
FP16 conversion inputs. Their counts do not turn them into universal proofs.
The general proofs and independent comparisons together strongly support the
implementation, while human review of the written specification remains open.

The EFT results retain their existing shape, finiteness, profile, and range
hypotheses. Scalar IEEE agreement supplies no new evidence that a physical GPU
uses a particular tensor-core alignment precision or instruction schedule. GPU
correspondence and the correctness of compiled native execution remain separate
obligations.

## Validation

| Check | Result |
| --- | --- |
| Independent IEEE oracle | 341,472 cases passed; zero mismatches |
| SoftFloat 3e comparison | Same numeric results and every flag; 119 permitted NaN-selection differences, separately checked against the declared policy |
| Lean logical/native comparison | 28,032 FP32/FP64 nearest-even add/sub/mul cases passed; public bits and flags preserved; Lean NaNs compared under explicit canonicalization |
| Universal native-wrapper contracts | `addWithLean_eq`, `subWithLean_eq`, and `mulWithLean_eq` preserve the full result for every input and context; bridges justify the selected native domains |
| Native EFT accumulation | 7,988 native/reference/oracle comparisons passed, including 1,000 exact-grid lists; ties, ordering, signed zeros, and rejection cases covered |
| Complete native EFT result | 3,953 original/native comparisons passed, including three error controls; 290 scalar, 2,786 bounded-exact, 8 all-zero, and 866 out-of-range blocks |
| Bounded EFT execution audit | 12 roots have no rational/model/ideal execution dependencies; negative controls passed; 3,167 converter boundary cases passed |
| EFT and GEMM preservation | Original references retained; native EFT has complete preservation proofs; all EFT and GEMM clean-suite checks passed |
| Exhaustive FP16 conversion inputs | All 65,536 encodings converted to each of FP16, FP32, and FP64 |
| Other IEEE cases | 110,976 edge combinations, 17,280 random requests, 11,088 conversions, 5,472 rounding-threshold probes, 48 fused-boundary cases |
| Kernel witnesses | Signed zeros, NaNs, overflow thresholds, gradual underflow, tininess policies, FMA single rounding, and cancellation after an out-of-range product |
| Fresh build and full regression suite | All 53 gates passed from an empty build cache; 420 build jobs; zero Lean warnings |
| Theorem dependency audit | 2,354 public theorem roots; a separate module audit covered 9,225 declarations and 5,618 theorems, including private/generated declarations; zero project axioms |
| Original independent regression probes (7 September rerun) | 284,735 exact-value cases and 144 matrix requests passed; archived numerical summaries reproduced exactly |
| Original library preservation | All 183 files in the independent review's library manifest remain byte-for-byte unchanged |

The fresh build emitted six linker warnings about the missing local search
directory `/usr/local/lib`; all executables and checks succeeded. Both source
snapshot stability checks passed. The broader module audit used the retained
[TrustAudit.lean](../reviews/2026-09-07/TrustAudit.lean); every audited dependency
belonged to `propext`, `Classical.choice`, or `Quot.sound`.

The [IEEE report](../data/regressions/ieee-report.json),
[Lean/native comparison](../data/regressions/lean-ieee-report.json),
[native EFT accumulation](../data/regressions/lean-eft-report.json),
[bounded EFT comparison](../data/regressions/bounded-eft-report.json),
[SoftFloat report](../data/regressions/ieee-softfloat-report.json), and
[clean-suite report](../data/regressions/clean-build.json) carry the
machine-readable evidence and source fingerprints. The Python oracle searches
ordered encodings and imports no repository arithmetic/test oracle. Its comparison
includes the implemented NaN sign/payload policy. SoftFloat comparisons require
exact numeric bits, NaN quietness, and all flags; only NaN sign/payload choices
permitted by the differing policies are excluded from bitwise equality.
The Lean/native comparison likewise canonicalizes NaNs only when comparing
against Lean's differing policy, while separately requiring the public wrapper's
full bits and flags to match the original reference and independent oracle.

The clean suite checks source-copy stability and workspace agreement before
publishing reports. Fingerprints identify the actual validated implementation,
tests, and included documentation; they are not rewritten independently of a run.
The README's expanded theorem-code catalog was added after that run and checked
verbatim against the current Lean sources; this documentation update changes no
arithmetic implementation or proof.

The external reference is unmodified Berkeley SoftFloat 3e at
`f74b1e48110ac3a27dd49b787d164e55e42d81d1`, built with the ARM-VFPv2 specialization.
Its same-format conversion identity/NaN-quieting check is provided by the test
runner because SoftFloat exposes no same-format conversion API. That behavior
also has the general Lean compatibility proof and independent Python checks.

Reproduce from the root:

```sh
./tc build
./tc audit
./tc check
python3 scripts/check_ieee_softfloat.py --fetch
python3 scripts/check_lean_eft.py
python3 scripts/check_bounded_eft.py
```

The SoftFloat command requires network access for the initial download and a C compiler
and make. The ordinary suite remains offline once Lean is installed. The test-only
reference and generated executables live under ignored `tmp/` directories.

The additional legacy regression and module-audit pass can be repeated on the
current checkout with these individual checks:

```sh
python3 reviews/2026-09-07/build_probe.py
python3 reviews/2026-09-07/check_independent.py
python3 reviews/2026-09-07/check_gemm_independent.py
cd .
lake env lean -t 0 ../reviews/2026-09-07/TrustAudit.lean
```

These reruns provide regression evidence. They do not repin or extend the archived
independent review's assessment to new code.

## Critical cases

The [reference regressions](../TensorCore/IEEE/Tests/Regression.lean) and
[native-wrapper regressions](../TensorCore/IEEE/Tests/NativeRegression.lean)
include cases that rule out several plausible incorrect implementations:

- FP32 `1 + 2^-24` rounds to 1 with inexact under nearest-even; a midpoint
  above an odd low significand bit rounds to the even neighbor instead.
- Negative minimum-subnormal multiplication by one half returns negative zero
  with underflow and inexact in both FP32 and FP64 native paths.
- FP16 nearest rounding of 65505 returns 65504 with inexact, without overflow;
  65520 rounds to infinity with overflow and inexact.
- FP16 toward-zero rounding of 65535 does not signal overflow; 65536 does,
  while still returning the maximum finite value.
- A delivered minimum-normal result can carry underflow. Testing only the final
  exponent field would get this wrong. Exact subnormal results raise no flags.
- FP64 downward FMA `1 * 1 + (-1)` returns negative zero.
- FP64 `maxFinite * 2 - maxFinite` returns maxFinite exactly without flags.
  Rounding or rejecting the product before adding the accumulator would be wrong.
- Signaling NaNs are quieted and raise invalid; quiet NaNs normally do not.
  The chosen policy signals invalid for FMA `0 * infinity + quietNaN`.

These cases reflect IEEE 754-2019's binary rounding, sign, special-value, and
default-exception rules. Reference interpretation was checked against the standard
and [SoftFloat's documentation](https://www.jhauser.us/arithmetic/SoftFloat-3/doc/SoftFloat.html),
including its [underflow explanation](https://www.jhauser.us/arithmetic/SoftFloat-3/doc/SoftFloat-FAQ.html).

## Remaining concerns

1. **Specification review:** this extension was implemented and evaluated by the
   same agent. General kernel proofs establish the written contracts; a qualified
   human should still check that those contracts express the intended standard
   clauses and permitted policies. No independent human sign-off is claimed.
2. **Coverage:** division, square root, comparisons, integer/text conversions,
   decimal formats, additional IEEE operations, traps, and alternate handling
   remain outside this milestone. The existing GEMM APIs still use
   their documented finite policy. Full IEEE 754 conformance is not claimed.
3. **Hardware:** scalar IEEE semantics do not discharge tensor-core device
   conformance. Alignment precision, floors, instruction order, memory/lane
   behavior, and compiler correspondence remain separate obligations. No new GPU
   run or CUDA compilation was performed.
4. **Archived tensor formats:** FP8 families and FP16-output tensor-core candidates
   are in [`wip/`](../wip/README.md), outside the active build and regression suite.
   FP8 normalized precision and FP16-output stage order remain unresolved.
5. **Practicality:** previous evaluations identified conservative source-conversion
   bounds and slow concrete certificate replay. Quantified families amortize
   verification but still require membership proofs. No new application workload,
   production certification rate, or measured GPU cost model is established here.
   Selection still minimizes supplied cost among certified candidates.
6. **Execution trust:** the parser, native compiler, and executable are tested;
   they are not verified end-to-end by the mathematical operation theorems.
   The migrated paths also inherit Lean's native floating-point backend's rounding
   and subnormal-environment assumptions. Kernel replay is distinct from executing
   a compiled calculation.

## Review history and document consolidation

The earlier [independent finite-theory review at 6406712](https://github.com/pauljiang03/tensor-core-arithmetic/blob/6406712e456c8d36f662a70be8065d7022e14566/INDEPENDENT_REVIEW.md)
found no admitted proof, project axiom, or mathematical counterexample in its
reviewed scope. Its tests and scope witnesses remain under
[reviews/2026-09-07](../reviews/2026-09-07/README.md), pinned to that baseline.
The new IEEE layer addresses the reviewed scalar special-value restrictions.
The native bridges add proved agreement with Lean's logical models. Neither
addition changes that historical review into an independent review of new code.

Superseded standalone manual, accuracy-bound, runtime, family, and practicality
Markdown reports have been consolidated here and removed from the current tree.
Their historical measurements remain available in Git history; the old unpublished
benchmark harness is not presented as a current reproducible evaluation. The guide
now links to the live declarations instead of duplicating a lengthy technical and
paper-coverage appendix. This document preserves the unresolved mathematical,
hardware, and practical concerns.
