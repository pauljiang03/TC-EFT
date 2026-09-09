# TensorCore.Gemm.Regression.DecisionExtensions

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-dc66e6e5ce7975e9"></a>

<details>
<summary><code>TensorCore.Regression.exact_scalar_budgets</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L11)

```lean
theorem exact_scalar_budgets (mode : BinaryRoundingMode) :
    checkFiniteMultiply mode 1 fp32.maxFinite (-999) = some ⟨fp32.maxFinite, 0⟩ ∧
    checkFiniteMultiply mode (-1) (pow2 (-149)) (-999) = some ⟨pow2 (-149), 0⟩ ∧
    checkFiniteAdd mode 0 fp32.maxFinite (-999) = some ⟨fp32.maxFinite, 0⟩ := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.ScalarBound](../ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.checkFiniteAdd](../ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkFiniteMultiply](../ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ce4806500b961d68"></a>

<details>
<summary><code>TensorCore.Regression.identity_epilogue_tight</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L17)

```lean
theorem identity_epilogue_tight (mode : BinaryRoundingMode) :
    (analyzeScaledCell .ampere ⟨mode, mode, ⟨fp32, mode⟩⟩ 0x3f800000 0 0 [(0xbc00, 0x3c00)]).map
      (fun a => a.bound.alphaRounding + a.bound.betaRounding + a.bound.addRounding + a.bound.outputRounding) = some 0 := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PipelineBound](../ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeScaledCell](../ScaledGemmAnalysis.md#decl-41a297c61c8a49d2), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0c0badea6a26af57"></a>

<details>
<summary><code>TensorCore.Regression.native_empty_domain</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L22)

```lean
theorem native_empty_domain (model : NativeGemmModel p) :
    (nativeGemmCell model [] 0x80000000).map (fun c => c.output.bits) = some 0x80000000 ∧
    (nativeGemmCell model [] 0x7f7fffff).map (fun c => c.output.bits) = some 0x7f7fffff ∧
    nativeGemmCell model [] 0x7f800000 = none := by
  cases p <;> cases model <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](../NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.nativeGemmCell](../NativeGemm.md#decl-74e63a5f52eb41d5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-38aebe2520c2a30b"></a>

<details>
<summary><code>TensorCore.Regression.native_bf16_cases</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L28)

```lean
theorem native_bf16_cases (model : NativeGemmModel .bf16) :
    (nativeGemmCell model [(0xbf80, 0x4000)] 0).map (fun c => c.output.bits) = some 0xc0000000 ∧
    (nativeGemmCell model [(0x8001, 0x3f80)] 0).map (fun c => c.output.bits) = some 0x80010000 ∧
    (nativeGemmCell model (List.replicate 17 (0x3f80, 0x3f80)) 0).map (fun c => c.output.bits) = some 0x41880000 ∧
    nativeGemmCell model [(0x7f7f, 0x7f7f)] 0 = none ∧
    nativeGemmCell model [(0x7fc0, 0)] 0 = none := by
  cases model <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](../NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.nativeGemmCell](../NativeGemm.md#decl-74e63a5f52eb41d5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-519be474ddd83571"></a>

<details>
<summary><code>TensorCore.Regression.native_tf32_cases</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L36)

```lean
theorem native_tf32_cases (model : NativeGemmModel .tf32) :
    (nativeGemmCell model [(0x5fc00, 0x20000)] 0).map (fun c => c.output.bits) = some 0xc0000000 ∧
    (nativeGemmCell model [(0x40001, 0x1fc00)] 0).map (fun c => c.output.bits) = some 0x80002000 ∧
    (nativeGemmCell model (List.replicate 9 (0x1fc00, 0x1fc00)) 0).map (fun c => c.output.bits) = some 0x41100000 ∧
    nativeGemmCell model [(0x3fc00, 0)] 0 = none := by
  cases model <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](../NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.nativeGemmCell](../NativeGemm.md#decl-74e63a5f52eb41d5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6a0e42d96957e12a"></a>

<details>
<summary><code>TensorCore.Regression.costProblem</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L43)

```lean
def costProblem : GemmProblem 1 1 17 :=
  .raw #v[Vector.replicate 17 0x0c00] (Vector.replicate 17 #v[0x0c00]) #v[#v[0x3f800000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.chosen_decision](ReviewClaims.md#decl-052834c8a8a0db8b), [TensorCore.Regression.minimum_cost_skips_uncertified](DecisionExtensions.md#decl-b69d2d7611c1550d), [TensorCore.Regression.minimum_cost_ties](DecisionExtensions.md#decl-8dfd56f09e57d26a)

</details>

</details>

<a id="decl-bc632cc65faf1783"></a>

<details>
<summary><code>TensorCore.Regression.pricedModels</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L46)

```lean
def pricedModels : List CostedCandidate :=
  [⟨{model := .v100}, 0, 0⟩, ⟨{model := .ampere}, 3, 1⟩, ⟨{model := .hopper}, 2, 2⟩]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.ReviewClaims.chosen_decision](ReviewClaims.md#decl-052834c8a8a0db8b), [TensorCore.Regression.minimum_cost_skips_uncertified](DecisionExtensions.md#decl-b69d2d7611c1550d)

</details>

</details>

<a id="decl-b69d2d7611c1550d"></a>

<details>
<summary><code>TensorCore.Regression.minimum_cost_skips_uncertified</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L49)

```lean
theorem minimum_cost_skips_uncertified :
    (selectGemmCost costProblem pricedModels (1 / 1000000)).map (·.index) = some 2 ∧
    selectGemmCost costProblem pricedModels 0 = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.Regression.costProblem](DecisionExtensions.md#decl-6a0e42d96957e12a), [TensorCore.Regression.pricedModels](DecisionExtensions.md#decl-bc632cc65faf1783), [TensorCore.selectGemmCost](../CostSelection.md#decl-11498eca158bf117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8dfd56f09e57d26a"></a>

<details>
<summary><code>TensorCore.Regression.minimum_cost_ties</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L53)

```lean
theorem minimum_cost_ties :
    (selectGemmCost costProblem [⟨{model := .hopper}, 2, 7⟩, ⟨{model := .ampere}, 2, 9⟩]
      (1 / 1000000)).map (·.index) = some 7 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.Regression.costProblem](DecisionExtensions.md#decl-6a0e42d96957e12a), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.selectGemmCost](../CostSelection.md#decl-11498eca158bf117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-41ec4e2a2fbe2115"></a>

<details>
<summary><code>TensorCore.Regression.variedFamily</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L57)

```lean
def variedFamily : EntryFamily 2 2 1 :=
  ⟨#v[#v[1], #v[1 / 4096]], #v[#v[1, 1 / 4096]], #v[#v[1, 0], #v[0, 0]]⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EntryFamily](../EntryFamily.md#decl-36d7465bd66a40c1)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_member](ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.second_family_member](ReviewClaims.md#decl-d565737a82ea57ef), [TensorCore.Regression.varied_family_certifies](DecisionExtensions.md#decl-18eefe337a464c5b), [TensorCore.Regression.varied_family_universal](DecisionExtensions.md#decl-316ae3e57a6f638f)

</details>

</details>

<a id="decl-18eefe337a464c5b"></a>

<details>
<summary><code>TensorCore.Regression.varied_family_certifies</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L60)

```lean
theorem varied_family_certifies :
    candidateCertified (.entryFamily variedFamily) (1 / 1000) {model := .hopper} = true := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.Regression.variedFamily](DecisionExtensions.md#decl-41ec4e2a2fbe2115), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.candidateCertified](../Selection.md#decl-658719161ad7081e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.varied_family_universal](DecisionExtensions.md#decl-316ae3e57a6f638f)

</details>

</details>

<a id="decl-316ae3e57a6f638f"></a>

<details>
<summary><code>TensorCore.Regression.varied_family_universal</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L63)

```lean
theorem varied_family_universal : EntryFamilyAccurate .hopper variedFamily (1 / 1000) :=
  candidateCertified_sound (.entryFamily variedFamily) (1 / 1000) {model := .hopper} varied_family_certifies
```

**Supporting proofs:** [TensorCore.Regression.varied_family_certifies](DecisionExtensions.md#decl-18eefe337a464c5b), [TensorCore.candidateCertified_sound](../Selection.md#decl-a02dc0d0ac1bf80b)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.EntryFamilyAccurate](../EntryFamily.md#decl-22c40ef3de1a8d0f), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.Regression.variedFamily](DecisionExtensions.md#decl-41ec4e2a2fbe2115), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.ReviewClaims.family_members_accurate](ReviewClaims.md#decl-5a504b60d62ca03e)

</details>

</details>

<a id="decl-ec5c1612f9785b31"></a>

<details>
<summary><code>TensorCore.Regression.native_selection_certifies</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/DecisionExtensions.lean#L66)

```lean
theorem native_selection_certifies :
    candidateCertified (.native .bf16 #v[#v[0xbf80]] #v[#v[0x4000]] #v[#v[0]])
      (1 / 1000) {model := .ampere} = true ∧
    candidateCertified (.native .tf32 #v[#v[0x5fc00]] #v[#v[0x20000]] #v[#v[0]])
      (1 / 1000) {model := .hopper, nativeMma := true} = true := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.candidateCertified](../Selection.md#decl-658719161ad7081e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
