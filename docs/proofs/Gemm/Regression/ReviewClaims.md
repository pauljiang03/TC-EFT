# TensorCore.Gemm.Regression.ReviewClaims

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-6fc7deeceb491c94"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.tinyA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L10)

```lean
def tinyA : DenseMatrix F16 1 17 := #v[Vector.replicate 17 0x0c00]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.tiny_ideal](ReviewClaims.md#decl-e1a821af196f19ca), [TensorCore.Regression.ReviewClaims.tiny_outputs](ReviewClaims.md#decl-d3401f2e29412655)

</details>

</details>

<a id="decl-3cea97b48597e14b"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.tinyB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L11)

```lean
def tinyB : DenseMatrix F16 17 1 := Vector.replicate 17 #v[0x0c00]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.secondFamilyA](ReviewClaims.md#decl-e600282cd4caf388), [TensorCore.Regression.ReviewClaims.tiny_ideal](ReviewClaims.md#decl-e1a821af196f19ca), [TensorCore.Regression.ReviewClaims.tiny_outputs](ReviewClaims.md#decl-d3401f2e29412655)

</details>

</details>

<a id="decl-8d73556a17396225"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.unitC</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L12)

```lean
def unitC : DenseMatrix F32 1 1 := #v[#v[0x3f800000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.native_accuracy](ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.ReviewClaims.tiny_ideal](ReviewClaims.md#decl-e1a821af196f19ca), [TensorCore.Regression.ReviewClaims.tiny_outputs](ReviewClaims.md#decl-d3401f2e29412655)

</details>

</details>

<a id="decl-e1a821af196f19ca"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.tiny_ideal</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L14)

```lean
theorem tiny_ideal : (gemmIdeal tinyA tinyB unitC)[0][0] = some (1 + 17 / 16777216) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Regression.ReviewClaims.tinyA](ReviewClaims.md#decl-6fc7deeceb491c94), [TensorCore.Regression.ReviewClaims.tinyB](ReviewClaims.md#decl-3cea97b48597e14b), [TensorCore.Regression.ReviewClaims.unitC](ReviewClaims.md#decl-8d73556a17396225), [TensorCore.gemmIdeal](../Defs.md#decl-1f55842952d81ccc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](ReviewClaims.md#decl-35f427838887ea29), [TensorCore.Regression.ReviewClaims.native_accuracy](ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.ReviewClaims.tiny_outputs](ReviewClaims.md#decl-d3401f2e29412655)

</details>

</details>

<a id="decl-d3401f2e29412655"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.tiny_outputs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L17)

```lean
theorem tiny_outputs :
    ((gemm .v100 tinyA tinyB unitC)[0][0]).toOption.map (fun c => c.output.value) = some 1 ∧
    ((gemm .ampere tinyA tinyB unitC)[0][0]).toOption.map (fun c => c.output.value) = some (1 + 1 / 1048576) ∧
    ((gemm .hopper tinyA tinyB unitC)[0][0]).toOption.map (fun c => c.output.value) = some (1 + 1 / 1048576) := by
  decide +kernel
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.tiny_ideal](ReviewClaims.md#decl-e1a821af196f19ca)

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.ReviewClaims.tinyA](ReviewClaims.md#decl-6fc7deeceb491c94), [TensorCore.Regression.ReviewClaims.tinyB](ReviewClaims.md#decl-3cea97b48597e14b), [TensorCore.Regression.ReviewClaims.unitC](ReviewClaims.md#decl-8d73556a17396225), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](ReviewClaims.md#decl-35f427838887ea29)

</details>

</details>

<a id="decl-503df615928e2452"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.positive_error_separates_models</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L23)

```lean
theorem positive_error_separates_models :
    absQ ((1 + 17 / 16777216) - (1 + 1 / 1048576)) = 1 / 16777216 ∧
    (0 : ℚ) < 1 / 16777216 ∧ (1 / 16777216 : ℚ) ≤ 1 / 1000000 ∧
    (1 / 1000000 : ℚ) < absQ ((1 + 17 / 16777216) - 1) := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate](ReviewClaims.md#decl-35f427838887ea29)

</details>

</details>

<a id="decl-35f427838887ea29"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.cheaper_model_is_inaccurate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L29)

```lean
theorem cheaper_model_is_inaccurate : ¬ GemmAccurate .v100 tinyA tinyB unitC (1 / 1000000) := by
  intro h
  obtain ⟨cell, z, hc, hz, he⟩ := h 0 0
  change (gemm .v100 tinyA tinyB unitC)[0][0] = .ok cell at hc
  change (gemmIdeal tinyA tinyB unitC)[0][0] = some z at hz
  have ho := tiny_outputs.1
  rw [hc] at ho
  have hv : cell.output.value = 1 := Option.some.inj ho
  have hi : z = 1 + 17 / 16777216 := Option.some.inj (hz.symm.trans tiny_ideal)
  rw [hv, hi] at he
  exact (Rat.not_le.mpr positive_error_separates_models.2.2.2) he
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.positive_error_separates_models](ReviewClaims.md#decl-503df615928e2452), [TensorCore.Regression.ReviewClaims.tiny_ideal](ReviewClaims.md#decl-e1a821af196f19ca), [TensorCore.Regression.ReviewClaims.tiny_outputs](ReviewClaims.md#decl-d3401f2e29412655)

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmAccurate](../Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.ReviewClaims.tinyA](ReviewClaims.md#decl-6fc7deeceb491c94), [TensorCore.Regression.ReviewClaims.tinyB](ReviewClaims.md#decl-3cea97b48597e14b), [TensorCore.Regression.ReviewClaims.unitC](ReviewClaims.md#decl-8d73556a17396225), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](../Analysis.md#decl-8b640af4e4509e78), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmIdeal](../Defs.md#decl-1f55842952d81ccc)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-faca76b37ee54430"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.chosen</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L41)

```lean
def chosen : CostedCandidate := ⟨{model := .hopper}, 2, 2⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.chosen_decision](ReviewClaims.md#decl-052834c8a8a0db8b)

</details>

</details>

<a id="decl-052834c8a8a0db8b"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.chosen_decision</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L43)

```lean
theorem chosen_decision : selectGemmCost costProblem pricedModels (1 / 1000000) = some chosen := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.Regression.ReviewClaims.chosen](ReviewClaims.md#decl-faca76b37ee54430), [TensorCore.Regression.costProblem](DecisionExtensions.md#decl-6a0e42d96957e12a), [TensorCore.Regression.pricedModels](DecisionExtensions.md#decl-bc632cc65faf1783), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.selectGemmCost](../CostSelection.md#decl-11498eca158bf117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](ReviewClaims.md#decl-48d32b8ae011d0c9)

</details>

</details>

<a id="decl-48d32b8ae011d0c9"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L46)

```lean
theorem chosen_accuracy_and_minimum : chosen ∈ pricedModels ∧
    GemmAccurate .hopper tinyA tinyB unitC (1 / 1000000) ∧
    ∀ c ∈ pricedModels, candidateCertified costProblem (1 / 1000000) c.configuration = true → chosen.cost ≤ c.cost :=
  selectGemmCost_sound costProblem pricedModels (1 / 1000000) chosen chosen_decision
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.chosen_decision](ReviewClaims.md#decl-052834c8a8a0db8b), [TensorCore.selectGemmCost_sound](../CostSelection.md#decl-aa59b068120a3e6e)

**Definitions and types:** [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmAccurate](../Analysis.md#decl-3560e57078a6df2b), [TensorCore.Regression.ReviewClaims.chosen](ReviewClaims.md#decl-faca76b37ee54430), [TensorCore.Regression.ReviewClaims.tinyA](ReviewClaims.md#decl-6fc7deeceb491c94), [TensorCore.Regression.ReviewClaims.tinyB](ReviewClaims.md#decl-3cea97b48597e14b), [TensorCore.Regression.ReviewClaims.unitC](ReviewClaims.md#decl-8d73556a17396225), [TensorCore.Regression.costProblem](DecisionExtensions.md#decl-6a0e42d96957e12a), [TensorCore.Regression.pricedModels](DecisionExtensions.md#decl-bc632cc65faf1783), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.candidateCertified](../Selection.md#decl-658719161ad7081e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-80e9eadb0c11a7c4"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.nativeTiny</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L51)

```lean
def nativeTiny : (p : NativePrecision) → NativeWord p
  | .bf16 => 0x3980
  | .tf32 => 0x1cc00
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.nativeA](ReviewClaims.md#decl-4c34aadebeebde79), [TensorCore.Regression.ReviewClaims.nativeB](ReviewClaims.md#decl-547d89a71879883e)

</details>

</details>

<a id="decl-4c34aadebeebde79"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.nativeA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L55)

```lean
def nativeA (p : NativePrecision) : DenseMatrix (NativeWord p) 1 9 :=
  #v[Vector.replicate 9 (nativeTiny p)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.Regression.ReviewClaims.nativeTiny](ReviewClaims.md#decl-80e9eadb0c11a7c4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.native_accuracy](ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](ReviewClaims.md#decl-52ed72d6dde90c2c)

</details>

</details>

<a id="decl-547d89a71879883e"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.nativeB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L57)

```lean
def nativeB (p : NativePrecision) : DenseMatrix (NativeWord p) 9 1 :=
  Vector.replicate 9 #v[nativeTiny p]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.Regression.ReviewClaims.nativeTiny](ReviewClaims.md#decl-80e9eadb0c11a7c4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.native_accuracy](ReviewClaims.md#decl-a842143479a55b27), [TensorCore.Regression.ReviewClaims.native_positive_error](ReviewClaims.md#decl-52ed72d6dde90c2c)

</details>

</details>

<a id="decl-52ed72d6dde90c2c"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.native_positive_error</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L60)

```lean
theorem native_positive_error (model : NativeGemmModel p) :
    let A := nativeA p
    let B := nativeB p
    (nativeGemmIdeal model A B unitC)[0][0] = some (1 + 9 / 16777216) ∧
    ((nativeGemm model A B unitC)[0][0]).map (fun c => c.output.value) = some (1 + 1 / 2097152) ∧
    nativeAnalysisCheck model A B unitC
      ((analyzeNativeGemm model A B unitC).map fun row => row.map fun a => (a.map (·.witness)).getD [])
      (1 / 1000000) = true := by
  cases p <;> cases model <;> decide +kernel
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.tiny_ideal](ReviewClaims.md#decl-e1a821af196f19ca)

**Definitions and types:** [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](../NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.Regression.ReviewClaims.nativeA](ReviewClaims.md#decl-4c34aadebeebde79), [TensorCore.Regression.ReviewClaims.nativeB](ReviewClaims.md#decl-547d89a71879883e), [TensorCore.Regression.ReviewClaims.unitC](ReviewClaims.md#decl-8d73556a17396225), [TensorCore.analyzeNativeGemm](../NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.nativeAnalysisCheck](../NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeGemm](../NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmIdeal](../NativeGemm.md#decl-b9b24fce99a6a8c6)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.native_accuracy](ReviewClaims.md#decl-a842143479a55b27)

</details>

</details>

<a id="decl-8619ffd6d743c4c4"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.native_error_value</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L70)

```lean
theorem native_error_value :
    absQ ((1 + 9 / 16777216) - (1 + 1 / 2097152)) = 1 / 16777216 ∧
    (0 : ℚ) < 1 / 16777216 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a842143479a55b27"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.native_accuracy</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L74)

```lean
theorem native_accuracy (model : NativeGemmModel p) :
    NativeGemmAccurate model (nativeA p) (nativeB p) unitC (1 / 1000000) :=
  nativeAnalysisCheck_sound model _ _ _ _ _ (native_positive_error model).2.2
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.native_positive_error](ReviewClaims.md#decl-52ed72d6dde90c2c), [TensorCore.Regression.ReviewClaims.tiny_ideal](ReviewClaims.md#decl-e1a821af196f19ca), [TensorCore.nativeAnalysisCheck_sound](../NativeGemm.md#decl-f6bddcc98d97f99f)

**Definitions and types:** [TensorCore.CellAnalysis](../Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GroupWitness](../../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmAccurate](../NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](../NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.Regression.ReviewClaims.nativeA](ReviewClaims.md#decl-4c34aadebeebde79), [TensorCore.Regression.ReviewClaims.nativeB](ReviewClaims.md#decl-547d89a71879883e), [TensorCore.Regression.ReviewClaims.unitC](ReviewClaims.md#decl-8d73556a17396225), [TensorCore.analyzeNativeGemm](../NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.nativeAnalysisCheck](../NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeGemm](../NativeGemm.md#decl-0dc3f0675850245e), [TensorCore.nativeGemmIdeal](../NativeGemm.md#decl-b9b24fce99a6a8c6)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-214e69f3f1822dcd"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.familyA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L78)

```lean
def familyA : DenseMatrix F16 2 1 := #v[#v[0x3c00], #v[0x8c00]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_member](ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.family_members_accurate](ReviewClaims.md#decl-5a504b60d62ca03e), [TensorCore.Regression.ReviewClaims.family_members_distinct](ReviewClaims.md#decl-59263c7648711759)

</details>

</details>

<a id="decl-e600282cd4caf388"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.secondFamilyA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L79)

```lean
def secondFamilyA : DenseMatrix F16 2 1 := #v[#v[0xbc00], #v[0x0c00]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Regression.ReviewClaims.tinyB](ReviewClaims.md#decl-3cea97b48597e14b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_members_accurate](ReviewClaims.md#decl-5a504b60d62ca03e), [TensorCore.Regression.ReviewClaims.family_members_distinct](ReviewClaims.md#decl-59263c7648711759), [TensorCore.Regression.ReviewClaims.second_family_member](ReviewClaims.md#decl-d565737a82ea57ef)

</details>

</details>

<a id="decl-a4ba91514ad50c21"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.familyB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L80)

```lean
def familyB : DenseMatrix F16 1 2 := #v[#v[0x3c00, 0x0c00]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_member](ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.family_members_accurate](ReviewClaims.md#decl-5a504b60d62ca03e), [TensorCore.Regression.ReviewClaims.second_family_member](ReviewClaims.md#decl-d565737a82ea57ef)

</details>

</details>

<a id="decl-f8e0eb8955e24f2f"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.familyC</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L81)

```lean
def familyC : DenseMatrix F32 2 2 := #v[#v[0x3f800000, 0], #v[0x80000000, 0]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_member](ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.family_members_accurate](ReviewClaims.md#decl-5a504b60d62ca03e), [TensorCore.Regression.ReviewClaims.second_family_member](ReviewClaims.md#decl-d565737a82ea57ef)

</details>

</details>

<a id="decl-1c7e1d8a6330eda3"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.within_of_checks</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L83)

```lean
private theorem within_of_checks (fmt : Format) (caps : DenseMatrix ℚ m n)
    (A : DenseMatrix (BitVec fmt.width) m n)
    (h : ∀ i : Fin m, ∀ j : Fin n,
      let d := ((classify fmt A[i.val][j.val]).finite).getD ⟨0, 0, 0⟩
      (classify fmt A[i.val][j.val]).finite = some d ∧ absQ d.value ≤ caps[i.val][j.val]) :
    EntryWithin fmt caps A := fun i j => ⟨_, h i j⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily.cell](../EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.EntryWithin](../EntryFamily.md#decl-e603cd759712ff3e), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_member](ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.second_family_member](ReviewClaims.md#decl-d565737a82ea57ef)

</details>

</details>

<a id="decl-7ee5354eacefb07e"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.family_member</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L90)

```lean
theorem family_member : variedFamily.Contains familyA familyB familyC := by
  exact ⟨within_of_checks _ _ _ (by decide +kernel),
    within_of_checks _ _ _ (by decide +kernel), within_of_checks _ _ _ (by decide +kernel)⟩
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.within_of_checks](ReviewClaims.md#decl-1c7e1d8a6330eda3)

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.Contains](../EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.EntryWithin](../EntryFamily.md#decl-e603cd759712ff3e), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Regression.ReviewClaims.familyA](ReviewClaims.md#decl-214e69f3f1822dcd), [TensorCore.Regression.ReviewClaims.familyB](ReviewClaims.md#decl-a4ba91514ad50c21), [TensorCore.Regression.ReviewClaims.familyC](ReviewClaims.md#decl-f8e0eb8955e24f2f), [TensorCore.Regression.variedFamily](DecisionExtensions.md#decl-41ec4e2a2fbe2115), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_members_accurate](ReviewClaims.md#decl-5a504b60d62ca03e)

</details>

</details>

<a id="decl-d565737a82ea57ef"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.second_family_member</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L94)

```lean
theorem second_family_member : variedFamily.Contains secondFamilyA familyB familyC := by
  exact ⟨within_of_checks _ _ _ (by decide +kernel),
    within_of_checks _ _ _ (by decide +kernel), within_of_checks _ _ _ (by decide +kernel)⟩
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.within_of_checks](ReviewClaims.md#decl-1c7e1d8a6330eda3)

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.Contains](../EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.EntryWithin](../EntryFamily.md#decl-e603cd759712ff3e), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Regression.ReviewClaims.familyB](ReviewClaims.md#decl-a4ba91514ad50c21), [TensorCore.Regression.ReviewClaims.familyC](ReviewClaims.md#decl-f8e0eb8955e24f2f), [TensorCore.Regression.ReviewClaims.secondFamilyA](ReviewClaims.md#decl-e600282cd4caf388), [TensorCore.Regression.variedFamily](DecisionExtensions.md#decl-41ec4e2a2fbe2115), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_members_accurate](ReviewClaims.md#decl-5a504b60d62ca03e)

</details>

</details>

<a id="decl-59263c7648711759"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.family_members_distinct</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L98)

```lean
theorem family_members_distinct : familyA ≠ secondFamilyA := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Regression.ReviewClaims.familyA](ReviewClaims.md#decl-214e69f3f1822dcd), [TensorCore.Regression.ReviewClaims.secondFamilyA](ReviewClaims.md#decl-e600282cd4caf388)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5a504b60d62ca03e"></a>

<details>
<summary><code>TensorCore.Regression.ReviewClaims.family_members_accurate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/ReviewClaims.lean#L100)

```lean
theorem family_members_accurate :
    GemmAccurate .hopper familyA familyB familyC (1 / 1000) ∧
    GemmAccurate .hopper secondFamilyA familyB familyC (1 / 1000) :=
  ⟨varied_family_universal _ _ _ family_member, varied_family_universal _ _ _ second_family_member⟩
```

**Supporting proofs:** [TensorCore.Regression.ReviewClaims.family_member](ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.second_family_member](ReviewClaims.md#decl-d565737a82ea57ef), [TensorCore.Regression.varied_family_universal](DecisionExtensions.md#decl-316ae3e57a6f638f)

**Definitions and types:** [TensorCore.GemmAccurate](../Analysis.md#decl-3560e57078a6df2b), [TensorCore.Regression.ReviewClaims.familyA](ReviewClaims.md#decl-214e69f3f1822dcd), [TensorCore.Regression.ReviewClaims.familyB](ReviewClaims.md#decl-a4ba91514ad50c21), [TensorCore.Regression.ReviewClaims.familyC](ReviewClaims.md#decl-f8e0eb8955e24f2f), [TensorCore.Regression.ReviewClaims.secondFamilyA](ReviewClaims.md#decl-e600282cd4caf388), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
