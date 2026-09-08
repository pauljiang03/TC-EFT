# Current evaluation

Updated 7 September 2026. This evaluation covers the IEEE scalar extension on top
of `6406712e456c8d36f662a70be8065d7022e14566`. Final source fingerprints are recorded
in the linked validation reports. Prepared by Codex, which also implemented this
extension; this is not an independent human review or author sign-off.

**Assessment:** the new scalar layer has general Lean correctness contracts and
passes independent numerical and exception-flag comparisons. The original finite
tensor-core theory is retained. The result is a substantive extension for five
binary scalar operations, not full IEEE 754 coverage or hardware verification.

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
[guide and scope](README.md) and [input schema](tensor-core/data/schemas/ieee.schema.json).

The old finite `roundBinary`, tensor-core invocations, and GEMM pipelines keep
their existing behavior. IEEE scalar calls use the separately named API. In
particular, IEEE exceptions have not been inserted into GEMM epilogues or their
accuracy predicates. Their current contracts require finite decoded ideals.

## Mathematical content and trust

- [Precision rounding](tensor-core/TensorCore/IEEE/Precision.lean) is specified by
  binade inequalities and integer optimality, including even tie breaking.
  Existence and uniqueness are proved. Additional nearest, greatest-lower-bound,
  and least-upper-bound theorems quantify over dyadic competitors with unrestricted
  exponents. These results support the exception conditions.
- [Total rounding](tensor-core/TensorCore/IEEE/Rounding.lean) extends the existing
  finite optimality results to signed zero and out-of-range inputs. The overflow
  flag is proved equivalent to exceeding the finite endpoint after rounding with
  an unbounded exponent range. In-range rounding cannot signal overflow.
- [Operation contracts](tensor-core/TensorCore/IEEE/Specification.lean) cover every
  encoded input and every implemented rounding/tininess mode. Finite cases use
  exact decoded arithmetic and the rounding relation; nonfinite cases specify
  results and flags. No successful-execution or desired-accuracy premise is assumed.
- [Compatibility](tensor-core/TensorCore/IEEE/Compatibility.lean) proves that
  same-format finite conversion preserves every encoding, including both zeros,
  with no flags. Quiet NaN payloads survive widening/narrowing. Nonzero in-range
  rounding agrees with the previous finite converter.

The finite rounder's option is eliminated using its existing totality theorem,
not a default result. Proofs use Lean's kernel and standard library. There is no
foreign floating-point call in the arithmetic implementation; SoftFloat is a
separate test reference. The reference implementation computes exact rational
intermediates, so these theorems do not establish an optimized fixed-width IEEE
machine implementation or a performance advantage.

## Validation

| Check | Result |
| --- | --- |
| Independent IEEE oracle | 341,472 cases passed; zero mismatches |
| SoftFloat 3e comparison | Same numeric results and every flag; 119 permitted NaN-selection differences, separately checked against the declared policy |
| Exhaustive FP16 conversion inputs | All 65,536 encodings converted to each of FP16, FP32, and FP64 |
| Other IEEE cases | 110,976 edge combinations, 17,280 random requests, 11,088 conversions, 5,472 rounding-threshold probes, 48 fused-boundary cases |
| Kernel witnesses | Signed zeros, NaNs, overflow thresholds, gradual underflow, tininess policies, FMA single rounding, and cancellation after an out-of-range product |
| Fresh build and full regression suite | 402 build jobs; all 51 gates passed; zero Lean warnings |
| Theorem dependency audit | 2,162 public theorem roots; a separate module audit covered 8,603 declarations and 5,066 theorems, including private/generated declarations; zero project axioms |
| Original independent regression probes | 284,735 exact-value cases and 144 matrix requests passed again; archived numerical summaries reproduced exactly |
| Original library preservation | All 183 files in the independent review's library manifest remain byte-for-byte unchanged |

The fresh build emitted six linker warnings about the missing local search
directory `/usr/local/lib`; all executables and checks succeeded. Both source
snapshot stability checks passed. The broader module audit used the retained
[TrustAudit.lean](reviews/2026-09-07/TrustAudit.lean); every audited dependency
belonged to `propext`, `Classical.choice`, or `Quot.sound`.

The [IEEE report](tensor-core/data/regressions/ieee-report.json),
[SoftFloat report](tensor-core/data/regressions/ieee-softfloat-report.json), and
[clean-suite report](tensor-core/data/regressions/clean-build.json) carry the
machine-readable evidence and source fingerprints. The Python oracle searches
ordered encodings and imports no repository arithmetic/test oracle. Its comparison
includes the implemented NaN sign/payload policy. SoftFloat comparisons require
exact numeric bits, NaN quietness, and all flags; only NaN sign/payload choices
permitted by the differing policies are excluded from bitwise equality.

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
python3 tensor-core/scripts/check_ieee_softfloat.py --fetch
```

The last command requires network access for the initial download and a C compiler
and make. The ordinary suite remains offline once Lean is installed. The test-only
reference and generated executables live under ignored `tmp/` directories.

The additional legacy regression and module-audit pass can be repeated on the
current checkout with these individual checks:

```sh
python3 reviews/2026-09-07/build_probe.py
python3 reviews/2026-09-07/check_independent.py
python3 reviews/2026-09-07/check_gemm_independent.py
cd tensor-core
lake env lean -t 0 ../reviews/2026-09-07/TrustAudit.lean
```

These reruns provide regression evidence. They do not repin or extend the archived
independent review's assessment to new code.

## Critical cases

The [kernel-checked regressions](tensor-core/TensorCore/IEEE/Regression.lean)
include cases that rule out several plausible incorrect implementations:

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
   remain outside this milestone. The existing tensor-core/GEMM APIs still use
   their documented finite policy. Full IEEE 754 conformance is not claimed.
3. **Hardware:** scalar IEEE semantics do not discharge tensor-core device
   conformance. Alignment precision, floors, instruction order, memory/lane
   behavior, and compiler correspondence remain separate obligations. No new GPU
   run or CUDA compilation was performed.
4. **Tensor formats:** FP8 families and FP16-output stage order remain partial or
   ambiguous. The generic IEEE layout does not describe E4M3's finite top encoding.
5. **Practicality:** previous evaluations identified conservative source-conversion
   bounds and slow concrete certificate replay. Quantified families amortize
   verification but still require membership proofs. No new application workload,
   production certification rate, or measured GPU cost model is established here.
   Selection still minimizes supplied cost among certified candidates.
6. **Execution trust:** the parser, native compiler, and executable are tested;
   they are not verified end-to-end by the mathematical operation theorems.
   Kernel replay is distinct from executing a compiled reference calculation.

## Review history and document consolidation

The earlier [independent finite-theory review at 6406712](https://github.com/pauljiang03/tensor-core-arithmetic/blob/6406712e456c8d36f662a70be8065d7022e14566/INDEPENDENT_REVIEW.md)
found no admitted proof, project axiom, or mathematical counterexample in its
reviewed scope. Its tests and scope witnesses remain under
[reviews/2026-09-07](reviews/2026-09-07/README.md), pinned to that baseline.
The new IEEE layer addresses the reviewed scalar special-value restrictions;
it does not change that historical review into an independent review of new code.

Superseded standalone manual, accuracy-bound, runtime, family, and practicality
Markdown reports have been consolidated here and removed from the current tree.
Their historical measurements remain available in Git history; the old unpublished
benchmark harness is not presented as a current reproducible evaluation. The guide
now links to the live declarations instead of duplicating a lengthy technical and
paper-coverage appendix. This document preserves the unresolved mathematical,
hardware, and practical concerns.
