# Lean IEEE compatibility and migration

Audited against the pinned Lean 4.33.1 sources on 9 September 2026.

`tc ieee` now uses `addWithLean`, `subWithLean`, and `mulWithLean`. These wrappers
call Lean's native `Float32` or `Float` operation when both operands are nonzero
and finite, the mode is nearest-even, and the absolute exact result is at most
the destination's maximum finite value. They use the existing reference on all
other inputs. Cancellation to zero and multiplication underflow are covered by
the native paths; zero *operands* take the reference path.

Theorems `addWithLean_eq`, `subWithLean_eq`, and `mulWithLean_eq` prove equality of
the **entire result**, including bits and every flag, for every input encoding,
format, rounding mode, and tininess policy accepted by the existing API. The
underlying native-operation equivalence theorems have the finite-domain
preconditions above. No equality test between two computed answers is used to
select an implementation at runtime.

## Which results are preserved

| Layer | Preservation guarantee | Evidence |
| --- | --- | --- |
| IEEE scalar add/sub/mul wrappers | Same encoded result and every exception flag for every accepted format, input, rounding mode, and tininess policy | Universal `addWithLean_eq`, `subWithLean_eq`, and `mulWithLean_eq` theorems |
| Other IEEE operations and fallback cases | Existing computation and policy retained | Original specification proofs and IEEE regression suite |
| Tensor-core blocks and programs | Same grouping, alignment, output rounding, residuals, and recovered values | Existing definitions retained; proofs and program regressions replayed |
| Executable bounded EFT | Native FP32 scalar consolidation preserves corrected outputs, branch tags, errors, and range restrictions | `algorithm1WithLean_eq`, transferred correctness/success theorems, and complete original/native comparisons |
| EFT reference models | Original extraction, scalar FP32/FP64 models, and bounded reference retained | Existing proofs remain the independent targets of refinement |
| GEMM and accuracy certificates | Same arithmetic pipelines, error predicates, and certificate soundness contracts | Existing definitions retained; GEMM, analysis, selection, and certificate gates passed |

The migration changes the IEEE CLI's add/sub/mul dispatch and executable EFT
scalar additions. GEMM retains its original finite arithmetic. Tensor-core groups
keep their alignment and grouped-accumulation semantics; EFT's subsequent scalar
consolidation uses ordinary nearest-even FP32 additions. Existing finiteness,
shape, profile, and range hypotheses still apply. Exported certificates retain
their existing source-fingerprint requirements.

For the changed API paths, preservation is a theorem for every input, rather
than an inference from a test sample. Agreement with Lean's native logical
operations has the narrower domain stated above; on other inputs, the wrapper
uses the original reference. The original definitions remain separate, so the
equivalence proof compares distinct implementations.

## Native EFT accumulation

`tc eft` executes
[`EFMachine.algorithm1WithLean`](../TensorCore/Programs/NativeEFT.lean). Residuals
are checked for exact FP32 representability and added left to right using
`naiveSum32WithLeanFrom`. Overlap subtraction and the final scalar addition use
the same `add32WithLean` primitive. Bounded extraction, scalar guards, and exact
fallback consolidation remain in the existing 576-bit model.

The [finite-addition bridge](../TensorCore/IEEE/LeanFiniteAddition.lean) covers
all finite FP32 operand encodings, including zeros. The EFT adapter retains the
exact-range rejection policy and maps `-0 + -0` to `+0`. Ordinary IEEE RNE would
return `-0` in that case; EFT's original numerical contract identifies exact zero
with `+0`. These policies are separate from the IEEE scalar API's signed-zero
and exception-flag contract. The native EFT path uses bounded words for range
checks and native addition for result bits, without computing a reference-rounded
result or using rational intermediates in execution.

`add32WithLean_eq` proves primitive equality with the original bounded addition.
`naiveSum32WithLeanFrom_eq` lifts it through every list and starting accumulator.
`algorithm1WithLean_eq` preserves the entire Algorithm 1 result for all inputs,
including branch tags and errors. `algorithm1WithLean_correct`,
`algorithm1WithLean_success`, and `algorithm1WithLean_range_iff` transfer the
original finite-input, shape, and range guarantees for all eight supported paths.
These proofs preserve the scalar branch as well as the bounded exact fallback.

The generic FP64 scalar consolidation model remains a reference implementation.
This EFT migration concerns the executable FP32 scalar branch; it introduces no
intermediate FP64 rounding at the final FP32 boundary.

## Compatibility decisions

| Feature | Lean 4.33.1 interface | Repository decision |
| --- | --- | --- |
| FP32/FP64 nearest-even add/sub/mul | Defined logical models and native operations | Migrate the proved finite domains; preserve reference fallbacks |
| FP16 operations | No counterpart in the audited `Float`/`Float32` API | Keep the existing implementation |
| Directed rounding | The native operations above use nearest-even in their logical models | Keep the existing four-mode reference for other modes |
| Signed zeros | Represented in Lean's logical model | Bit-preserving adapters; prove cancellation and underflow output signs; keep zero-operand fallbacks |
| Subnormals | Gradual underflow in the logical model | Covered by the bridges, including negative rounded zero and status flags |
| Overflow and infinities | Representable in Lean's model | Keep reference paths for nonfinite inputs and exact results outside the finite reference range |
| NaNs | Canonical NaN representation in Lean's model | Preserve our sign, payload, and signaling policy through reference paths |
| Exception flags | Native scalar result does not expose our flag record | Compute flags from exact arithmetic and the supplied native result bits; prove equality with the reference |
| Tininess before/after rounding | Not a status interface provided by the native scalar operations | Retain both existing policies and their specification |
| FP32/FP64 format conversions | `Float32.toFloat` and `Float.toFloat32` are opaque in this toolchain | Keep our proved converters; no extra assumptions introduced to identify opaque conversions |
| One-rounding FMA | No corresponding fused operation in the audited native scalar interface | Keep our FMA; separate multiplication and addition would change its semantics |
| Executable EFT scalar addition | Ordinary native FP32 nearest-even addition | Proved finite adapter, zero normalization, bounded range guards, and complete Algorithm 1 preservation |
| Tensor-core grouping, alignment, and residuals | Not ordinary scalar IEEE arithmetic | Keep the tensor-core model and its proofs |

`native_nan_payload_differs` is a kernel-checked counterexample to identifying
our payload-preserving result bits with Lean's canonical-NaN interface. Existing
IEEE regression theorems also distinguish fused arithmetic from two roundings.

## Proof structure

1. [Shared rounding proofs](../TensorCore/IEEE/LeanRounding.lean) give exact
   rational meanings to Lean's round/sticky metadata. They prove that any number
   of right shifts preserves that meaning and yields the same nearest-even
   integer as our independent reference. Left shifts preserve exact value.
2. [FP32 bridges](../TensorCore/IEEE/LeanBridge.lean) connect encoded fields,
   signed significands, exponent selection, rounding carries, and packing to
   the rational model, then prove addition/subtraction/multiplication agreement.
3. [FP64 bridges](../TensorCore/IEEE/LeanBridge64.lean) and
   [FP64 exponent/carry lemmas](../TensorCore/IEEE/LeanRounding64.lean) specialize
   the format-dependent parts while reusing the generic rounding and alignment
   lemmas.
4. [Native wrappers](../TensorCore/IEEE/NativeOperations.lean) preserve the full
   `Result`, transfer the existing operation specifications, and retain fallbacks.
   The CLI calls these wrappers. The original `IEEE.add`, `IEEE.sub`, `IEEE.mul`,
   decoding, and rounding definitions remain independent references.
5. [Finite EFT addition](../TensorCore/IEEE/LeanFiniteAddition.lean) extends the
   addition bridge to zero operands with EFT's numerical zero convention.
   [Native EFT](../TensorCore/Programs/NativeEFT.lean) proves primitive, fold,
   scalar-branch, and complete Algorithm 1 preservation, then transfers the
   existing correctness and success theorems.

The native IEEE paths no longer compute the reference's rounded bit encoding merely
to obtain flags. They still use exact rationals for domain checks and exception
conditions. The reference implementation remains useful for proofs, special
policies, and independent comparisons; no performance improvement is claimed.

## Trust and interpretation

The bridges are checked by the Lean kernel and included in the repository's
standard-axiom audit. Agreement with Lean's definitions is an additional formal
cross-check, not a change to the kernel or a proof of the compiler, runtime, or
GPU. Compiled execution inherits Lean's native floating-point backend assumptions,
including its rounding and subnormal environment. Reported exception flags are
computed and proved in Lean; they are not read from the host floating-point status.

Agreement between the two definitions, supported by independent numerical and
flag comparisons, is strong evidence for the standard scalar implementation.
It does not establish that every written specification matches the intended
IEEE standard or that the tensor-core profile describes a physical NVIDIA GPU.
Those require specification review and device/compiler correspondence evidence.
The existing EFT proofs remain the justification for EFT correctness under their
stated hypotheses; the native IEEE bridge does not broaden those hypotheses.

## Validation and reproduction

From the repository root:

```sh
./tc build
./tc audit
./tc check
python3 tensor-core/scripts/check_lean_ieee.py
python3 tensor-core/scripts/check_lean_eft.py
python3 tensor-core/scripts/check_bounded_eft.py
python3 tensor-core/scripts/check_ieee_softfloat.py --fetch
```

The standalone Lean comparison is also included in `./tc check`; it can be run
separately when reviewing the bridge. SoftFloat is optional and test-only. Its
first download needs network access; the build needs a C compiler and make.

`check_lean_ieee.py` compares the exact reference, the public
wrappers, Lean's logical models, and native execution on boundary and random
cases. Non-NaN numeric results are compared bit for bit, including signed zeros.
NaN results are compared after explicit canonicalization only for the Lean-value
comparison; our exact NaN bits and all flags are separately checked against the
independent ordered-encoding oracle. The public wrapper must also match the
reference's complete result. These samples supplement the universal proofs.

The native EFT comparison checks 7,988 sequences, including ties, ordering,
cancellation, signed zeros, exact-range rejection, and 1,000 exact-grid residual
lists. The bounded EFT gate additionally compares 3,953 complete original/native
results, including three error controls, and checks 3,167 converter boundaries.
It audits 12 execution roots to reject rational/model/ideal dependencies. The
complete-result comparison prevents an unexpected fallback from hiding a scalar
path difference.

The Lean logical/native IEEE comparison covers 28,032 cases. The independent
IEEE/SoftFloat comparison covers 341,472 cases, accounting for 119 documented
NaN-selection differences. See the [evaluation](../../EVALUATION.md) for the
latest clean-suite counts and theorem audit; these sampled comparisons supplement
the universal preservation and correctness proofs.

Kernel boundary witnesses are in
[NativeRegression.lean](../TensorCore/IEEE/NativeRegression.lean) and
[NativeEFT.lean](../TensorCore/Regression/NativeEFT.lean). The reports
retain the actual run's results and source fingerprints:
[lean-ieee-report.json](../data/regressions/lean-ieee-report.json),
[ieee-report.json](../data/regressions/ieee-report.json),
[ieee-softfloat-report.json](../data/regressions/ieee-softfloat-report.json), and
[clean-build.json](../data/regressions/clean-build.json).
EFT-specific evidence is in [lean-eft-report.json](../data/regressions/lean-eft-report.json)
and [bounded-eft-report.json](../data/regressions/bounded-eft-report.json).
The clean run checks source-copy stability and workspace agreement before
publishing reports. Fingerprints identify the actual validated sources.

Recheck the bridges and compiled regressions on every toolchain upgrade. Extending
the native domains to zero operands, nonfinite operands, out-of-range exact
results, or format conversions requires additional preservation proofs.
