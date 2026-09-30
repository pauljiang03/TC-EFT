# Paper-scope equivalence: original implementation and FloatLib

The FP32-output TC model and reference EFT now have **kernel-checked universal equivalence**, including output bits, EFT branch choices, and distinct validation errors. This is a theorem about the actual implementations, not an inference from matching tests.

The scope is the FP16, BF16 and packed TF32 inputs in the paper, FP32 output, and profiles with alignment precision `F = 23 + p`, where `p` is any natural number. Product count and alignment floor remain parameters. Other repository applications and backends are not part of this comparison.

## Main theorem and the two-way correspondence

See [`paper_one_to_one`](TCFloat/Equivalence/Representations.lean) and `paper_one_to_one_inverse`. For every profile in that scope, every encoded block, and every supplied FP32 word D:

- The FloatLib TC interface returns the same output word or the same validation error as `TensorCore.evalBlock`.
- The FloatLib EFT interface returns the same branch and word, or the same validation error, as `TensorCore.algorithm1Encoded`.
- D need not be the model's output. Invalid product counts and nonfinite operands/D are included in the comparison.

The statement uses the independent `Paper.tcChecked` and `Paper.eftChecked` functions. The simpler `universal_equivalence` theorem in [`Encoded.lean`](TCFloat/Equivalence/Encoded.lean) proves the same numerical/branch behavior for the Option interfaces; that earlier statement collapses validation errors to `none`. The checked theorem preserves the error constructors as well.

“1:1” has explicit representation proofs:

| Representation | Proved correspondence |
|---|---|
| Encoded words | `wordEquiv`: `BitVec w ≃ Fin (2^w)`, preserving every bit |
| Complete encoded blocks | `inputEquiv`, with both inverse laws; includes arbitrary product-list lengths |
| Decoded numerical terms | `termEquiv`: original `Decoded` is equivalent to canonical, metadata-consistent FloatLib terms |
| Validation errors | `errorEquiv`: all four constructors correspond |
| Tagged EFT outcomes | `eftResultEquiv`: a bijection onto legitimate `(optional bits, branch)` outcomes; `encodedResult_injective` proves no two source outcomes are merged |

This does not identify unrestricted raw implementation types. A raw port `Term` can contain inconsistent metadata, and a raw `Trace` can contain inconsistent bits/value fields. The encoded constructors establish the required invariants. The term equivalence canonicalizes zero sign, matching the source's numerical representation; the word equivalence retains signed-zero bits. These distinctions are still checked in `tests/RepresentationFacts.lean`.

## Every arithmetic stage is connected

The following equalities are universal under the stated representation invariants. They do not assume that the arithmetic implementations agree.

| Stage | Bridge theorem(s) |
|---|---|
| Format fields, finite decoding and metadata | `decode_project`, `decode_value`, `value32_eq` |
| Exact multiplication and original-input sum | `rawTerm_mul`, `mul_valid`, `terms_eq`, `ideal_eq` |
| Zero-aware maximum, floor and alignment grid | `alignment_eq`, `eta_eq`, `q_eq` |
| Signed truncation, retained accumulator and alignment residuals | `truncCoeff_eq`, `truncGrid_eq`, `accumulator_eq`, `residuals_eq` |
| Actual RTZ/RNE conversion, including ties, subnormals, signed underflow and finite-range rejection | `round32_eq` for **every rational input** and both modes |
| FP32 representability, addition and sequential summation | `representable_eq`, `add_eq`, `naiveSum_eq` |
| Extraction grid, coarse/low parts, retained sum and overlap | `extraction_eq`, `coarse_eq`, `lows_eq`, `retained_eq`, `overlap_eq` |
| Support grid, coefficients and exact executable guard | `support_eq`, `lowCoefficients_eq`, `guard_eq` |
| Scalar correction, exact fallback, branch and zero shortcut | `scalarUnchecked_eq`, `scalar_eq`, `consolidation_eq`, `algorithm_eq`, `encoded_trace_eq` |
| Encoded preparation and full entry points | `prepare_eq`, `prepare_valid`, `tc_checked_eq`, `eft_checked_eq` |

Files are under [`TCFloat/Equivalence/`](TCFloat/Equivalence/). In particular, the hard converter bridge proves equality of the original custom converter and FloatLib's actual quotient/packing code; it does not replace one converter with the other.

## Correspondence to the paper's FP32 statements

The numbering below follows `arith_2027_tc_eft (4).pdf`. Source identifiers containing `eq20` refer to the input-budget inequality numbered (17) in this manuscript.

| Paper statement | FloatLib-side theorem(s) |
|---|---|
| II-B: block behavior model | `paper_one_to_one`, plus the individual stage equalities above |
| III.1: total output error bound | `paper_error_bound`, including the final FP32 output quantum |
| III.2–III.3: monotonicity and flowback | `truncGrid_mono`, `paper_output_condition`, `general_flowback_necessary`, `general_flowback_sufficient` |
| III.4: hardware nonmonotonicity family | `nonmonotone_perturbation`, `nonmonotone_encoded`, `construction_not_monotone` |
| III.5: general perturbation range and size | `paper_nonmonotone_range` for arbitrary admissible K, p and j |
| IV.1: extraction identity and low-component bound | `retained_add_low`, `paper_lowPart_bound` |
| IV.2: overlap width | `paper_overlap_window` |
| IV.3–IV.4: overlapping bits and signed correction | `paper_accumulator_eq_retained`, `paper_overlap_correction` |
| IV.5: exact recovery for any finite supplied D | `overlap_recovery` |
| IV.6–IV.7: sequential FP32 addition and exact representable sums | `naiveSumFrom`, `representable_add_exact`, `grid_representable` |
| IV.8: coefficient budget, any order, and bit-span condition (16) | `paper_naiveSum_exact`, `paper_naiveSum_any_order`, `paper_bitSpan_exact` |
| IV.9: common input grid and input-based condition (17) | `paper_lowParts_on_grid`, `paper_input_budget`, `paper_scalar_input_condition` |
| IV.10: exact FP32 overlap subtraction | `paper_overlap_subtraction` |
| IV.11: scalar correction and one final RNE rounding | `paper_scalar_on_grid`, `scalar_correct`, `encodedAlgorithm_nearest` |
| Reference full EFT, including the exact alternative described in IV-B | `algorithm_correct`, `algorithm_range`, `paper_one_to_one` |

Flowback is now proved for an **arbitrary chosen summand** and the actual before/after rounded outputs, not only C. The theorem takes the two alignment grids as parameters, so they may differ. Its sufficient condition retains the required representability assumptions. The original C-specialized theorem is unchanged.

The scalar instruction sequence is also proved under the paper's more general chosen-grid, coefficient-budget and absolute-range conditions. The executable guard remains exactly the original repository guard, using its deterministic support grid and the convenient `-149 ≤ λ ≤ 104` restriction. The manuscript allows choosing a suitable common grid and states broader sufficient conditions; it does not specify a unique guard-search algorithm. Thus equality of repository branch decisions is proved, while the paper's sufficient mathematical conditions are documented separately. Failure of that particular guard does not assert that scalar summation is impossible.

Proofs in the bridge layer may transport original theorems through already-proved equalities. They are not all independent rediscoveries. The independent executable and its existing FloatLib correctness proofs remain separate.

## Reproducible proof boundary

Original revision: `990afac10b94a84f3de24743206756dd7acc3276`. FloatLib revision: `0d91825727839f597fd06b22fdd038ea21480f0c`.

The parent project uses Lean 4.33.1; this isolated project uses Lean 4.34.0. `scripts/prepare_reference.py` verifies the current parent dependencies against their original locations at the pinned Git revision. It permits the documented module-path relocations and deletion of unused imports; all non-import arithmetic and proof bytes remain pinned. It copies the actual current modules into ignored `reference-compat/`. In that compatibility copy, **three notation declarations are renamed and scoped to `TensorCore`** to avoid mathlib parser collisions, with the same Nat, Int and Rat expansions. The generated manifest records current source hashes, original source locations, and deleted imports.

The equivalence modules import those actual source definitions. The port runtime does not: `Main.lean`, `TCFloat/Model.lean` and `TCFloat/Paper.lean` use the FloatLib implementation. A transitive executable-dependency audit verifies this and also verifies that EFT correction does not call TC evaluation or the original-input ideal. Negative controls must fail when those dependencies are deliberately introduced.

From the repository root:

```sh
cd floatlib-port
python3 scripts/check_all.py
python3 scripts/check_equivalence.py
```

The first command prepares the compatibility copy, builds all proofs and the executable, audits allowed axioms, checks representations, and runs the existing regression suites. It rejects unfinished proofs and kernel-bypassing proof shortcuts. The only permitted axioms are `propext`, `Classical.choice` and `Quot.sound`. Original-source deprecation warnings from the newer compiler are allowed; warnings from the new port are rejected.

The second command independently builds the original executable with its own toolchain and compares 115,029 command observations and 668,944 decoder cases. Those finite comparisons supplement the universal proof. Recorded GPU rows are replayed; no new hardware measurements are taken. Equivalence proves the two formal implementations agree. It does not prove that either model describes every physical Tensor Core execution.

Reference preparation permits documented module-path relocations and deletion of unused imports only; all arithmetic/proof bodies still match the revision above. The generated manifest hashes the actual current parent sources used by the equivalence proofs. Differential tests build the current parent snapshot.
