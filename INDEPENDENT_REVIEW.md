**Independent mathematical and Lean review, 7 September 2026**

Reviewed commit: `49e8768ed087385382cc8f6f8f823e55756d60ed`, cloned from `pauljiang03/tensor-core-arithmetic`. Toolchain: Lean 4.33.1. The review focuses on the mathematical definitions, proof obligations, executable semantics, and substantive content. It does not evaluate the EFT manuscript or research novelty.

Reviewer: OpenAI Codex (AI-assisted review), commissioned by the repository owner. The assessment used a fresh clone, direct inspection of definitions and hypotheses, independent exact-arithmetic oracles, and attempted counterexamples. "Independent" describes that checking method; it is not a claim of third-party human peer review or author sign-off. The repository's existing human-review status remains pending.

**Verdict:** This is a real, substantial Lean formalization of selected **finite tensor-core arithmetic models and their underlying binary encodings and rounding**. I found no proof admission, project axiom, kernel bypass, or mathematical counterexample in the reviewed core and independently tested paths. The clean suite passed. However, the stronger claim of a complete first-principles verification of physical tensor cores and IEEE floating-point behavior is **not established**. The following limitations are explicit in the repository, and matter for that stronger claim.

**Does it do what the README says?**

The evidence supports the scoped mathematical claims inspected in the README's C01–C16 checklist. I found no confirmed contradiction between those scoped contracts and the implementation. The README explicitly discloses maximum-finite rejection, exact-zero-to-+0 behavior, assumed hardware correspondence, prescribed group schedules, conservative analysis, and deferred formats. The limitations below should therefore not be presented as undisclosed bugs. A blanket statement that every informal intention has been independently verified would exceed this review.

"From first principles" is defensible for the development of exact arithmetic, bit-field encodings, representability, rounding, alignment, and their proofs inside Lean, using Lean's kernel and standard library. The hardware-specific profile constants and scheduling rules are inputs to the model. They are not derived from a circuit, vendor implementation, or verified compiler. Proving consequences of those definitions does not establish that a physical tensor core implements them.

**1. Hardware correspondence remains an assumption — high significance for the requested claim.**

The precise boundary is [Instruction.lean:305](https://github.com/pauljiang03/tensor-core-arithmetic/blob/49e8768ed087385382cc8f6f8f823e55756d60ed/tensor-core/TensorCore/Programs/Instruction.lean#L305). `Conforms p device` means:

```text
for every c, pairs, out:
  model(c, pairs) = some out  →  device(c, pairs) = some out
```

`conforms_uncorrected_error` takes this proposition as a hypothesis. No theorem establishes it for an actual GPU. Alignment precision, floors, product counts, and increasing-k group order are supplied by profile and schedule definitions. `InstructionPath.evidence` is a string; its proof fields establish positive group width and divisibility, not device behavior.

This is legitimate conditional mathematics. It leaves a hardware obligation open. Equivalence to the separate `PaperSpec` definitions establishes agreement between two formalizations of the numerical model; both can still share an incorrect interpretation of hardware. NVIDIA itself leaves accumulation order, rounding, and subnormal handling unspecified for the relevant FP16/BF16/TF32 matrix instructions. [NVIDIA PTX specification](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#warp-level-matrix-instructions-wmma-mma).

The fresh validation run matched the 35,000 archived FP16/BF16/TF32 rows in seven datasets. These are useful empirical evidence, not universal proofs. The V100 dataset has no zero or subnormal operands/accumulators; the four BF16/TF32 datasets do not exercise active alignment floors. There is no separate published Hopper TF32 MMA dataset in those comparisons. The CUDA fixture was neither compiled nor executed in this review. [Archived-vector coverage](reviews/2026-09-07/validation-reports/device-report.json), [format coverage](reviews/2026-09-07/validation-reports/device-formats-report.json).

The CUTLASS result is also a manual arithmetic projection, with K restricted to positive multiples of 16. It does not verify C++, memory operations, lane/register transport, compilation, or GPU execution. [CutlassWmma.lean:4](https://github.com/pauljiang03/tensor-core-arithmetic/blob/49e8768ed087385382cc8f6f8f823e55756d60ed/tensor-core/TensorCore/Kernels/CutlassWmma.lean#L4).

To support a hardware-verification claim, specify a concrete target and discharge the correspondence obligation against an appropriate hardware/ISA implementation model. Additional device tests strengthen empirical confidence but do not discharge a universal theorem.

**2. The floating-point contract deliberately differs from full IEEE behavior — high significance for the requested claim.**

[roundBinary:42](https://github.com/pauljiang03/tensor-core-arithmetic/blob/49e8768ed087385382cc8f6f8f823e55756d60ed/tensor-core/TensorCore/Foundations/BinaryRounding.lean#L42) rejects every exact magnitude above the largest finite destination value, regardless of mode. It also returns positive zero for every exact rational zero. Decoding for arithmetic forgets the sign of encoded zero.

I added and kernel-checked concrete witnesses:

| Operation | Actual model behavior | Implication |
| --- | --- | --- |
| FP16 nearest conversion of 65505 | Rejected | The finite reference domain excludes values just above 65504, even below the usual nearest-overflow threshold. |
| FP16 toward-zero conversion of 65536 | Rejected | Directed overflow saturation is not modeled. |
| Same-format FP32 conversion of encoded −0 | Returns +0 | The signed encoding bijection does not imply arithmetic preserves zero signs. |
| FP64 downward-rounded `1 × 1 + (−1)` | Returns +0 | This differs from the NVIDIA FMA contract, which requires −0 for this cancellation. |

The last example uses only finite, exactly representable operands and an in-range result. It is therefore a discrepancy even within finite arithmetic if the intended claim is IEEE bit-for-bit compatibility. NVIDIA documents the negative-zero result for exact cancellation in `__fma_rd`. [NVIDIA double-precision intrinsics](https://docs.nvidia.com/cuda/archive/12.5.0/cuda-math-api/cuda_math_api/group__CUDA__MATH__INTRINSIC__DOUBLE.html).

The Lean theorem [binary64Fma_correct:88](https://github.com/pauljiang03/tensor-core-arithmetic/blob/49e8768ed087385382cc8f6f8f823e55756d60ed/tensor-core/TensorCore/Theory/Binary/RoundingContract.lean#L88) remains correct: its conclusion uses the project's numerical rounding relation and explicitly fixes the sign to strict negativity of the rational result. It does not prove the stronger IEEE claim. NaN/infinity propagation, IEEE overflow behavior, exception state, and operation-specific zero-sign rules are absent from this contract.

To close this gap, preserve signed-zero information through scalar operations, specify IEEE special/overflow behavior, and prove correspondence to that specification. The existing finite numerical theory is a useful foundation for that work. [Kernel-checked scope witnesses](reviews/2026-09-07/ScopeWitnesses.lean).

**3. Format and operation coverage is substantial but incomplete.**

The uniform rounding theorem covers well-formed IEEE-style layouts, rational inputs, four rounding directions, and the declared finite range. This includes the FP16, BF16, packed TF32, FP32, FP64, and E5M2 instances. Rational arithmetic is sufficient to express the exact additions and products of finite binary operands used here.

E4M3 has a separate finite-top encoding: its decoder correctly returns 448 for `0x7e`, while `roundBinary e4m3.layout ... 448` rejects it because the generic IEEE-style layout has a different finite range. I proved this distinction in the scope witnesses. FP8 and FP16 tensor-core output paths have separately named candidates or deferred coverage. General encoded division, square root, and a complete IEEE scalar-operation library are not present. These omissions do not invalidate the supported finite FP32-output results, but prevent a claim of complete floating-point or tensor-core coverage.

**4. Some recovery lemmas are elementary identities; the main theory is not trivial.**

The theorem [block_residual_identity:32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/49e8768ed087385382cc8f6f8f823e55756d60ed/tensor-core/TensorCore/Theory/StageResiduals.lean#L32) proves exact recovery for **any supplied output**. Algebraically, it splits `S − D` into alignment and output residuals. I constructed a block with exact sum 4, supplied the unrelated output 123, and proved its reference residual is −119. This recovery identity cannot establish that 123 is a correct tensor-core result. Similarly, `corrected_eq_round_exactDot` is substitution into a converter; the repository correctly documents that distinction.

The substantive results go further:

- **Encoding and rounding:** field-level decoding/encoding proofs, signed finite bijections, binade/subnormal geometry, carries, and nearest-even or directed optimality against *every* representable finite competitor. The rounder also has an exact success-domain theorem. These specifications do not merely restate the implementation output.
- **Tensor-core behavior:** raw product scales are retained, alignment uses signed magnitude truncation, floors are explicit, and final conversion has a separate loss bound. The resulting bound is `|S − D| < (K + 1)·q_align + q_output`, with successful execution made explicit. The proof accounts for both sources of loss.
- **Machine refinement:** fixed-width modular addition is connected to integer accumulation through proved coefficient and carry bounds. The reference equivalences give sufficient widths of 29, 31, and 33 bits for the selected V100/Ampere/Hopper FP16 models. These are mathematical sufficient widths, not claims about measured register widths.
- **Bounded correction and extraction:** the correction algorithm proves that a fixed 576-bit workspace suffices for the supported finite block inputs, with the exact final range condition exposed. This is more than the residual identity, but it establishes no GPU acceleration or practical speed advantage. The extraction-grid exact-summation theorem derives its coefficient budget from an explicit inequality; grid, range, and component-representability assumptions remain necessary.
- **Composition and matrices:** encoded accumulator boundaries, ordered groups, padding/cropping, scalar epilogues, and original-source conversion error are connected to independently defined ideals. Conversion bounds retain both operand perturbations, including their interaction.
- **Nonvacuity:** `GemmAccurate` requires an existing successful cell and a defined ideal. `gemmAnalysisCheck_sound` derives those obligations from an input-derived check. It does not assume the desired final error inequality. Quantified families have finite-value membership predicates and nonempty, distinct witnesses. Empty output dimensions still have the expected vacuous entrywise guarantees.
- **Distinguishing behavior:** I kernel-checked increasing-input/decreasing-output behavior for V100 and a nonempty 19-term accuracy certificate. The independent matrix tests included 207 cells with nonzero numerical error.

The presence of routine algebra, definitional equalities, and fixed-case computational proofs is normal. Theorem counts alone would overstate substance; the quantified rounding, capacity, composition, and soundness results provide the substantive content.

**What is still missing?**

| Intended claim or use | Missing work | Effect on the current scoped results |
| --- | --- | --- |
| Verified physical tensor cores | Specify a concrete device/instruction and prove model correspondence, including alignment precision, floors, stage order, and zero policy. Strengthen device coverage at subnormal, floor, carry, cancellation, and overflow boundaries. | The current hardware result remains conditional; archived tests do not discharge it. |
| Complete underlying IEEE floating point | Add operation-specific signed zeros, nonfinite values, overflow semantics, exception behavior, and their correctness specifications. Add general encoded scalar operations if a complete scalar library is intended. | Finite rational rounding is proved under a narrower, explicitly stated contract. |
| All tensor-core formats and paths | Resolve FP16-output stage-order ambiguity, finish FP8 families and their special encodings, and validate the remaining schedules and outputs. | The selected FP16/BF16/TF32-to-FP32 results are unaffected. |
| Verified compiled GPU kernels | Connect source semantics, memory and lane/register behavior, compilation, and device execution to the arithmetic projection. | The CUTLASS result concerns a manual arithmetic projection only. |
| Established practical usefulness | Measure certification rates and costs on representative workloads, compare useful alternatives, and justify supplied costs used by selection. | Sound certificates and minimum supplied cost do not imply competitive performance. |
| Broader analysis and program support | Scaled/native input families, selection across product precisions for the same source workload, adaptive control flow, and globally corrected GEMM remain extensions. | These are documented extensions, not requirements of the current contracts. |
| Completed independent human assessment | A qualified human should inspect the specifications and assumptions, review these checks, and record their own sign-off. | This AI-assisted review is evidence, not human certification or an exhaustive specification audit. |

There is no missing proof admission to patch in the audited imported theory. The largest gaps concern correspondence and scope, rather than an observed failure of a Lean proof. Neither additional theorem counts nor additional random tests alone would close those gaps.

**Validation performed**

| Check | Fresh result |
| --- | --- |
| `./tc build` and the fresh-copy `./tc check` | Passed; 383 build jobs, all 50 gates and standalone examples. |
| Warnings | Zero Lean warnings; five linker warnings about a missing `/usr/local/lib` search directory. Executables and tests succeeded. |
| Repository axiom audit | 2,008 public theorem roots; 1,216 marked as written in source. Only standard Lean axioms. |
| Independent declaration audit, run with `lean -t 0` | 7,995 project declarations, including 4,714 private/generated/public theorems; zero project axiom declarations; only `propext`, `Classical.choice`, `Quot.sound` dependencies. |
| Source/dependency coverage | 183 of 184 library source modules reachable from the root import; the remaining `PaperSpec.Audit` module is exercised separately by the full suite. |
| Independent exact-value probes | 284,735 cases, zero mismatches. All FP16 and BF16 encodings; 36 small formats with adjacent rounding boundaries; wide-format samples; 3,312 block cases across eight profiles. |
| Independent matrix execution and analysis | 144 execution requests, 312 cells, 256 scalar stages; 144 analysis requests, 120 accepted. Every accepted result met the original-input tolerance; zero mismatches. |
| Fresh exported certificate | Kernel replay passed for a nonempty Hopper workload at tolerance `10⁻⁶`; derived bound `5/16777216`. |
| Certificate negative control | Tightening the tolerance to `10⁻⁹` made the accuracy proof fail. A separate kernel proof establishes that the tightened checker condition is false. |

The independent Python oracles import no repository test code. Rounding is selected by searching ordered finite encodings, without reusing the Lean logarithm/coefficient/carry algorithm. Block alignment uses integer shifts. These execution tests supplement the proofs and check the declared semantics; they do not constitute hardware proofs.

Evidence: [fresh clean-suite report](reviews/2026-09-07/validation-reports/clean-build.json), [independent trust audit](reviews/2026-09-07/trust-audit.log), [rounding/block results](reviews/2026-09-07/independent-results.json), [matrix results](reviews/2026-09-07/matrix-checks.json), [replayable certificate](reviews/2026-09-07/AccuracyCertificate.lean), [refusal witness](reviews/2026-09-07/RefusalWitness.lean).

**Reproduction and review limits**

From the clone root, run `./tc build` and `./tc check` for the repository suite, then `python3 reviews/2026-09-07/run_review.py` for the additional independent checks. The latter verifies the reviewed source hashes, builds the probe, runs both independent oracles, checks the trust/scope/refusal proofs, replays the valid certificate, and requires the deliberately invalid certificate to fail in Lean. See the [reproduction instructions](reviews/2026-09-07/README.md) for individual commands and generated files.

Manual inspection concentrated on the encoding/rounding foundations, aligned semantics, key capacity/error/monotonicity proofs, and matrix/certificate contracts. Compilation and dependency auditing covered the complete imported theory. This is a bounded review, not a proof that every intended informal claim is correct. It uses the normal Lean kernel and standard-library trust foundation; no custom axiom of tensor-core correctness was found.

No implementation or library proof source was changed. Fresh generated validation evidence was saved separately and the original tracked validation reports were restored before adding this review. This publication adds documentation and independent review checks only. [Review provenance](reviews/2026-09-07/review-provenance.json).

A defensible description is: **a kernel-checked finite arithmetic theory for explicitly specified tensor-core models, built on proved binary encoding and rounding foundations, with verified accumulation refinements and sound GEMM accuracy certificates; physical hardware correspondence remains external.**
