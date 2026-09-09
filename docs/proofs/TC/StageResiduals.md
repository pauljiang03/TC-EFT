# TensorCore.TC.StageResiduals

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-fec712a2169085b5"></a>

<details>
<summary><code>TensorCore.sum_stage_residuals</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L7)

```lean
theorem sum_stage_residuals (ts : List ℚ) (align : ℚ → ℚ) :
    sumQ ts = sumQ (ts.map align) + sumQ (ts.map fun x => x - align x) := by
  induction ts with
  | nil => change (0 : ℚ) = 0 + 0; grind
  | cons t ts ih =>
    simp only [List.map_cons, sumQ]
    grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e)

</details>

</details>

<a id="decl-7b530e0eb36f1f90"></a>

<details>
<summary><code>TensorCore.terms_value</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L15)

```lean
theorem terms_value (b : PreparedBlock) :
    sumQ (b.terms.map RawProduct.value) = b.exactDot := by
  simp only [PreparedBlock.terms, PreparedBlock.exactDot,
    PreparedBlock.exactProducts, List.map_cons, List.map_map, sumQ]
  have h : (fun (p : Decoded × Decoded) => (rawMul p.1 p.2).value) =
      (fun p => p.1.value * p.2.value) := by
    funext p
    exact rawProduct_value p.1 p.2
  simp only [Function.comp_def] at *
  rw [h]
  rfl
```

**Supporting proofs:** [TensorCore.rawProduct_value](../Core/RawProduct.md#decl-f5273efeebd6d86f)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.retained_add_low](../EFT/ExtractionGrid.md#decl-613cd2d8bf397127), [TensorCore.allZeroTerms_exactDot](../EFT/Encoded.md#decl-44b53cd75ce37005), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.checkGroup_sound](Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e)

</details>

</details>

<a id="decl-ea47979aa889a3dd"></a>

<details>
<summary><code>TensorCore.accumulator_value</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L27)

```lean
theorem accumulator_value (b : PreparedBlock) :
    b.accumulator = sumQ (b.terms.map fun t => truncGrid t.value b.quantumExponent) := by
  unfold PreparedBlock.accumulator PreparedBlock.coefficients
  rw [← sum_coefficients]
  simp [List.map_map, Function.comp_def, truncGrid]
```

**Supporting proofs:** [TensorCore.sum_coefficients](../Core/Exact.md#decl-005e2ad99fe60fa3)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff), [TensorCore.truncCoeff](../Core/Exact.md#decl-282a0db962f1b274), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.accumulator_eq_retained](../EFT/ExtractionGrid.md#decl-8a8af9009921f9cf), [TensorCore.accumulator_abs_le_mass](Program/Bounds/Local.md#decl-97266aac0ec35351), [TensorCore.accumulator_abs_lt](StaticBudget.md#decl-a5c9d0f9181e3641), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9), [TensorCore.exact_alignment_accumulator](ExactAlignment.md#decl-42bb343ddba6bc20), [TensorCore.perturbed_accumulator](Flowback.md#decl-d8db235e56c7f3c2)

</details>

</details>

<a id="decl-5e3d1020cd5a64d9"></a>

<details>
<summary><code>TensorCore.block_residual_identity</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L34)

```lean
/-- Exact recovery applies to any supplied finite value, independently of model conformance. -/
theorem block_residual_identity (b : PreparedBlock) (d : ℚ) :
    b.exactDot = d + b.extractReference d := by
  have h := sum_stage_residuals (b.terms.map RawProduct.value)
    (fun t => truncGrid t b.quantumExponent)
  rw [terms_value] at h
  simp only [List.map_map, Function.comp_def] at h
  rw [← accumulator_value] at h
  change b.exactDot = d + ((b.accumulator - d) + sumQ b.alignmentResiduals)
  change b.exactDot = b.accumulator + sumQ b.alignmentResiduals at h
  grind
```

**Supporting proofs:** [TensorCore.accumulator_value](StageResiduals.md#decl-ea47979aa889a3dd), [TensorCore.sum_stage_residuals](StageResiduals.md#decl-fec712a2169085b5), [TensorCore.terms_value](StageResiduals.md#decl-7b530e0eb36f1f90)

**Definitions and types:** [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.extractReference](Block.md#decl-6cc810f8061e66a0), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.truncGrid](../Core/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.block_error_bound](ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.block_local_error](Program/Bounds/Local.md#decl-fb42d2d152a56c63), [TensorCore.block_static_error_bound](StaticBudget.md#decl-b5c964df86fc73b4), [TensorCore.returned_residual_identity](StageResiduals.md#decl-51c1f1398611023e), [TensorCore.aligned_recovery](InvocationProperties.md#decl-f6828402db94c42c)

</details>

</details>

<a id="decl-51c1f1398611023e"></a>

<details>
<summary><code>TensorCore.returned_residual_identity</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L45)

```lean
theorem returned_residual_identity (t : BlockTrace) :
    t.block.exactDot = t.output.value + t.residual :=
  block_residual_identity t.block t.output.value
```

**Supporting proofs:** [TensorCore.block_residual_identity](StageResiduals.md#decl-5e3d1020cd5a64d9)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.encoded_trace_ledger](Program/Composition.md#decl-775280e15ad44086), [TensorCore.evalBlock_residual_bound](Program/ErrorBounds.md#decl-74198f50c769d497), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.recovered_eq_exactDot](StageResiduals.md#decl-8de6ec1e79d4f44f)

</details>

</details>

<a id="decl-8de6ec1e79d4f44f"></a>

<details>
<summary><code>TensorCore.recovered_eq_exactDot</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L49)

```lean
theorem recovered_eq_exactDot (t : BlockTrace) : t.recovered = t.block.exactDot :=
  (returned_residual_identity t).symm
```

**Supporting proofs:** [TensorCore.returned_residual_identity](StageResiduals.md#decl-51c1f1398611023e)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.recovered](Block.md#decl-3d1b2fa71193a56d), [TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.corrected_eq_round_exactDot](StageResiduals.md#decl-4f25be9ce5c88c41)

</details>

</details>

<a id="decl-4f25be9ce5c88c41"></a>

<details>
<summary><code>TensorCore.corrected_eq_round_exactDot</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L53)

```lean
/-- This is substitution into the executable converter, not a nearest-value correctness proof. -/
theorem corrected_eq_round_exactDot (t : BlockTrace) :
    t.corrected = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.corrected
  rw [recovered_eq_exactDot]
```

**Supporting proofs:** [TensorCore.recovered_eq_exactDot](StageResiduals.md#decl-8de6ec1e79d4f44f)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.recovered](Block.md#decl-3d1b2fa71193a56d), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.algorithm1_bits_eq_round](../EFT/Encoded.md#decl-ff78455708a6f933), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.algorithm1_correct](../EFT/Algorithm1.md#decl-7c971273335df3a8), [TensorCore.corrected_correct](Program/Correction.md#decl-ee6543cdd6791a37), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.tceft_eq_corrected](../EFT/Extraction.md#decl-942f125d26cb2d1b)

</details>

</details>

<a id="decl-9203b66f7c8059ba"></a>

<details>
<summary><code>TensorCore.evalPrepared_block</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L58)

```lean
theorem evalPrepared_block {b : PreparedBlock} {t : BlockTrace}
    (h : evalPrepared b = .ok t) : t.block = b := by
  unfold evalPrepared at h
  cases hr : round32 .towardZero b.accumulator with
  | none => simp [hr] at h
  | some bits =>
    cases hd : finite32 bits with
    | none => simp [hr, hd] at h
    | some d =>
      simp [hr, hd] at h
      cases h
      rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.evalPrepared_error_bound](ErrorBounds.md#decl-6a51cec1858cd298)

</details>

</details>

<a id="decl-7b1107ad8e7189d9"></a>

<details>
<summary><code>TensorCore.evalBlock_prepared</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L71)

```lean
theorem evalBlock_prepared {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : prepare x = some t.block := by
  unfold evalBlock at h
  split at h
  · simp at h
  · cases hp : prepare x with
    | none => simp [hp] at h
    | some b =>
      simp [hp] at h
      rw [evalPrepared_block h]
```

**Supporting proofs:** [TensorCore.evalPrepared_block](StageResiduals.md#decl-9203b66f7c8059ba)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.canonical_padding_output](Padding.md#decl-2108e38788477de9), [TensorCore.canonical_source_padding_output](Padding.md#decl-5bdc8050550eb3f9), [TensorCore.checkGroup_sound](Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.evalBlock_c](StageResiduals.md#decl-02be11fb27fe1a11), [TensorCore.evalBlock_coefficient_capacity](AlignmentScale.md#decl-7692a0e5a779d42b), [TensorCore.evalBlock_corrected_correct](Program/Correction.md#decl-ef83bbb5f9a12398), [TensorCore.evalBlock_evalPrepared](StageResiduals.md#decl-e818d9197d4da76d), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_idealProducts](Program/Defs.md#decl-18057f2f716ca715), [TensorCore.evalBlock_profile](StageResiduals.md#decl-62ff3f8872735af6), [TensorCore.evalBlock_residual_identity](StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalBlock_scalarCorrectedIn_correct](../EFT/Scalar.md#decl-f06458fcf778275c), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalBlock_tceft_correct](../EFT/Extraction.md#decl-c42bf0d990e653f7), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

</details>

</details>

<a id="decl-e818d9197d4da76d"></a>

<details>
<summary><code>TensorCore.evalBlock_evalPrepared</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L82)

```lean
theorem evalBlock_evalPrepared {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : evalPrepared t.block = .ok t := by
  have hp := evalBlock_prepared h
  unfold evalBlock at h
  split at h
  · simp at h
  · rw [hp] at h
    exact h
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.checkGroup_sound](Program/GroupAnalysis.md#decl-0eb9c5d6e9fead1f), [TensorCore.evalBlock_error_bound](ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_exact_alignment](ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_static](StaticBudget.md#decl-9aa42bb13a9657f0), [TensorCore.evalBlock_success_iff](AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.fp16Fp32_contract](Canonical.md#decl-cf62ece4228e9418), [TensorCore.profile_contract](CanonicalFormats.md#decl-ccfc8f82aa7974cb)

</details>

</details>

<a id="decl-f7335275dbf94126"></a>

<details>
<summary><code>TensorCore.evalBlock_residual_identity</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L92)

```lean
/-- End-to-end local recovery, connected to the executable encoded-input evaluator. -/
theorem evalBlock_residual_identity {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) :
    exactDot x = some (t.output.value + t.residual) := by
  simp only [exactDot, evalBlock_prepared h, Option.map_some]
  rw [returned_residual_identity]
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.returned_residual_identity](StageResiduals.md#decl-51c1f1398611023e)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.residual](Block.md#decl-29503c8290420b97), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](Block.md#decl-32d061749cae163e), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](Block.md#decl-451fb68e7faa00f3), [TensorCore.prepare](Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-49dbce3f95e00cef"></a>

<details>
<summary><code>TensorCore.prepare_c</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L98)

```lean
theorem prepare_c {p : Profile} {x : BlockInput p} {b : PreparedBlock}
    (h : prepare x = some b) : decode32 x.c = some b.c := by
  unfold prepare at h
  cases hc : decode32 x.c with
  | none => simp [hc] at h
  | some c =>
    cases hp : prepareProducts p x.products with
    | none => simp [hc, hp] at h
    | some ps =>
      simp [hc, hp] at h
      cases h
      rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.evalBlock_c](StageResiduals.md#decl-02be11fb27fe1a11)

</details>

</details>

<a id="decl-02be11fb27fe1a11"></a>

<details>
<summary><code>TensorCore.evalBlock_c</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L111)

```lean
theorem evalBlock_c {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : decode32 x.c = some t.block.c :=
  prepare_c (evalBlock_prepared h)
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.prepare_c](StageResiduals.md#decl-49dbce3f95e00cef)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_chain](Program/Composition.md#decl-4a9736f9c5dc068b)

</details>

</details>

<a id="decl-b234945333f4196c"></a>

<details>
<summary><code>TensorCore.prepare_profile</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L116)

```lean
/-- Preparation retains the encoded input's profile, even if later evaluation rejects it. -/
theorem prepare_profile {p : Profile} {x : BlockInput p} {b : PreparedBlock}
    (hp : prepare x = some b) : b.profile = p := by
  unfold prepare at hp
  cases hc : decode32 x.c with
  | none => simp [hc] at hp
  | some c =>
    cases hps : prepareProducts p x.products with
    | none => simp [hc, hps] at hp
    | some ps =>
      simp [hc, hps] at hp
      rw [← hp]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.result_of_eval](Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.valid_iff](Specification/Stages.md#decl-82012b713a8f17aa), [TensorCore.canonical_padding_exact](Padding.md#decl-29f3596b590b969d), [TensorCore.canonical_source_padding_exact](Padding.md#decl-9c7b63268cdf83a8), [TensorCore.evalBlock_profile](StageResiduals.md#decl-62ff3f8872735af6), [TensorCore.prepare_coefficient_capacity](AlignmentScale.md#decl-c04538f02bc7d682)

</details>

</details>

<a id="decl-62ff3f8872735af6"></a>

<details>
<summary><code>TensorCore.evalBlock_profile</code></summary>

[Lean source](../../../TensorCore/TC/StageResiduals.lean#L129)

```lean
/-- The profile of a successful trace is the profile of its input. -/
theorem evalBlock_profile {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : t.block.profile = p :=
  prepare_profile (evalBlock_prepared h)
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.prepare_profile](StageResiduals.md#decl-b234945333f4196c)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
