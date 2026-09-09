# TensorCore.Gemm.Selection

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-633698ca3b748695"></a>

<details>
<summary><code>TensorCore.GemmCandidate</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L9)

```lean
structure GemmCandidate where
  model : WmmaGemmModel
  inputMode : BinaryRoundingMode := .nearestEven
  multiplyMode : BinaryRoundingMode := .nearestEven
  addMode : BinaryRoundingMode := .nearestEven
  nativeMma : Bool := false
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.candidate](Cli/GemmSelection.md#decl-0ce6164bf816c3c9), [TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.CostedCandidate](CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmCandidate.epilogue](Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.NativeScaled.candidates](Regression/NativeScaledGemm.md#decl-bc91542b4d9b5ae6), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](Regression/NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.Regression.ReviewClaims.chosen](Regression/ReviewClaims.md#decl-faca76b37ee54430), [TensorCore.Regression.ReviewClaims.chosen_decision](Regression/ReviewClaims.md#decl-052834c8a8a0db8b), [TensorCore.Regression.minimum_cost_ties](Regression/DecisionExtensions.md#decl-8dfd56f09e57d26a), [TensorCore.Regression.native_selection_certifies](Regression/DecisionExtensions.md#decl-ec5c1612f9785b31), [TensorCore.Regression.pricedModels](Regression/DecisionExtensions.md#decl-bc632cc65faf1783), [TensorCore.Regression.selectionModels](Regression/GemmSelection.md#decl-892e059b2f3fccab), [TensorCore.Regression.selectionModes](Regression/GemmSelection.md#decl-c6149ee3773e3071), [TensorCore.Regression.selection_preference_and_duplicates](Regression/GemmSelection.md#decl-904c1ea57c4ea668), [TensorCore.Regression.selection_source_accuracy](Regression/GemmSelection.md#decl-04a6c70aaf01cddf), [TensorCore.Regression.varied_family_certifies](Regression/DecisionExtensions.md#decl-18eefe337a464c5b), [TensorCore.Regression.varied_family_universal](Regression/DecisionExtensions.md#decl-316ae3e57a6f638f), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b), [TensorCore.selectGemm](Selection.md#decl-ac87128da56c0502), [TensorCore.selectGemm_accuracy](Selection.md#decl-b72d2d5f7d629f7e), [TensorCore.selectGemm_none](Selection.md#decl-c680323aca69a763), [TensorCore.selectGemm_sound](Selection.md#decl-5e96e7835b692828)

</details>

</details>

<a id="decl-be6f4119dc437b5f"></a>

<details>
<summary><code>TensorCore.GemmCandidate.epilogue</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L17)

```lean
def GemmCandidate.epilogue (c : GemmCandidate) : GemmEpilogue :=
  ⟨c.multiplyMode, c.addMode, ⟨fp32, .nearestEven⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269)

</details>

</details>

<a id="decl-a3c28b9398f7ee4f"></a>

<details>
<summary><code>TensorCore.GemmCandidate.nativeEpilogue</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L20)

```lean
def GemmCandidate.nativeEpilogue (c : GemmCandidate) (outputMode : BinaryRoundingMode) : GemmEpilogue :=
  ⟨c.multiplyMode, c.addMode, ⟨fp32, outputMode⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmEpilogue](ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269)

</details>

</details>

<a id="decl-8dc154fd49148f2c"></a>

<details>
<summary><code>TensorCore.GemmCandidate.nativeModel</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L23)

```lean
def GemmCandidate.nativeModel (c : GemmCandidate) (p : NativePrecision) : Option (NativeGemmModel p) :=
  match p, c.model, c.nativeMma with
  | _, .ampere, false => some .ampere
  | _, .hopper, false => some .hopper
  | .tf32, .hopper, true => some .hopperMma
  | _, _, _ => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269)

</details>

</details>

<a id="decl-cbf3e8441a848a8f"></a>

<details>
<summary><code>TensorCore.GemmProblem</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L30)

```lean
inductive GemmProblem (m n k : ℕ) where
  | raw (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
  | scaled (source : Format) (alpha beta : F32)
      (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
      (C : DenseMatrix F32 m n)
  | family (bounds : GemmFamily)
  | entryFamily (bounds : EntryFamily m n k)
  | native (precision : NativePrecision) (A : DenseMatrix (NativeWord precision) m k)
      (B : DenseMatrix (NativeWord precision) k n) (C : DenseMatrix F32 m n)
  | nativeScaled (precision : NativePrecision) (source : Format) (outputMode : BinaryRoundingMode) (alpha beta : F32)
      (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
      (C : DenseMatrix F32 m n)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.Cli.Selection.problem](Cli/GemmSelection.md#decl-2fb1639c2044a112), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.NativeScaled.sourceProblem](Regression/NativeScaledGemm.md#decl-8b6ac1fc2c8cb122), [TensorCore.Regression.costProblem](Regression/DecisionExtensions.md#decl-6a0e42d96957e12a), [TensorCore.Regression.native_selection_certifies](Regression/DecisionExtensions.md#decl-ec5c1612f9785b31), [TensorCore.Regression.selectionSource](Regression/GemmSelection.md#decl-ed8f5ad53159d062), [TensorCore.Regression.selectionTiny](Regression/GemmSelection.md#decl-3a56fc0e834e875f), [TensorCore.Regression.selection_family](Regression/GemmSelection.md#decl-dfcf9fc60b19226e), [TensorCore.Regression.selection_rejection_policy](Regression/GemmSelection.md#decl-6bec8bea89cb74e8), [TensorCore.Regression.selection_signed_zero_subnormal_and_boundary](Regression/GemmSelection.md#decl-eb5d3b0bfd127365), [TensorCore.Regression.varied_family_certifies](Regression/DecisionExtensions.md#decl-18eefe337a464c5b), [TensorCore.Regression.varied_family_universal](Regression/DecisionExtensions.md#decl-316ae3e57a6f638f), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b), [TensorCore.selectGemm](Selection.md#decl-ac87128da56c0502), [TensorCore.selectGemmCost](CostSelection.md#decl-11498eca158bf117), [TensorCore.selectGemmCost_sound](CostSelection.md#decl-aa59b068120a3e6e), [TensorCore.selectGemm_accuracy](Selection.md#decl-b72d2d5f7d629f7e), [TensorCore.selectGemm_none](Selection.md#decl-c680323aca69a763), [TensorCore.selectGemm_sound](Selection.md#decl-5e96e7835b692828)

</details>

</details>

<a id="decl-8c9d3458097dac77"></a>

<details>
<summary><code>TensorCore.GemmProblem.Accurate</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L43)

```lean
def GemmProblem.Accurate (p : GemmProblem m n k) (c : GemmCandidate) (tol : ℚ) : Prop :=
  match p with
  | .raw A B C => GemmAccurate c.model A B C tol
  | .scaled source alpha beta A B C =>
    ConvertedGemmAccurate source c.inputMode c.model c.epilogue alpha beta A B C tol
  | .family f => GemmFamilyAccurate c.model f m n k tol
  | .entryFamily f => EntryFamilyAccurate c.model f tol
  | .native precision A B C => ∃ model, c.nativeModel precision = some model ∧ NativeGemmAccurate model A B C tol
  | .nativeScaled precision source outputMode alpha beta A B C => ∃ model,
    c.nativeModel precision = some model ∧
    NativeConvertedGemmAccurate source c.inputMode model (c.nativeEpilogue outputMode) alpha beta A B C tol
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConvertedGemmAccurate](ConvertedGemmAnalysis.md#decl-63f5f66fca4e28d5), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamilyAccurate](EntryFamily.md#decl-22c40ef3de1a8d0f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmCandidate.epilogue](Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamilyAccurate](Family.md#decl-6a51b2e27db67ff4), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.selection_source_accuracy](Regression/GemmSelection.md#decl-04a6c70aaf01cddf), [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b), [TensorCore.selectGemmCost_sound](CostSelection.md#decl-aa59b068120a3e6e), [TensorCore.selectGemm_accuracy](Selection.md#decl-b72d2d5f7d629f7e), [TensorCore.selectGemm_sound](Selection.md#decl-5e96e7835b692828)

</details>

</details>

<a id="decl-86b28bea33c8f64a"></a>

<details>
<summary><code>TensorCore.GemmProblem.Witness</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L55)

```lean
def GemmProblem.Witness : GemmProblem m n k → Type
  | .raw .. => DenseMatrix (List GroupWitness) m n
  | .scaled .. | .nativeScaled .. => DenseMatrix ScaledWitness m n
  | .family .. => GemmBoundConfig
  | .entryFamily .. => DenseMatrix GemmBoundConfig m n
  | .native .. => DenseMatrix (List GroupWitness) m n
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b)

</details>

</details>

<a id="decl-7ff8c50195c18269"></a>

<details>
<summary><code>TensorCore.GemmProblem.infer</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L62)

```lean
def GemmProblem.infer (p : GemmProblem m n k) (c : GemmCandidate) : Option p.Witness :=
  match p with
  | .raw A B C =>
    let cells := analyzeGemm c.model A B C
    if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
      some (cells.map fun row => row.map fun a => (a.map (·.witness)).getD [])
    else none
  | .scaled source alpha beta A B C => do
    let cells ← analyzeConvertedGemm source c.inputMode c.model c.epilogue alpha beta A B C
    if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
      some (cells.map fun row => row.map fun a => (a.map (·.witness)).getD ⟨[], ⟨0, 0, 0, 0⟩⟩)
    else none
  | .family f => inferFamily c.model k f
  | .entryFamily f => inferEntryFamily c.model f
  | .native precision A B C => do
    let model ← c.nativeModel precision
    let cells := analyzeNativeGemm model A B C
    if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
      some (cells.map fun row => row.map fun a => (a.map (·.witness)).getD [])
    else none
  | .nativeScaled precision source outputMode alpha beta A B C => do
    let model ← c.nativeModel precision
    let cells ← analyzeNativeConvertedGemm source c.inputMode model (c.nativeEpilogue outputMode) alpha beta A B C
    if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
      some (cells.map fun row => row.map fun a => (a.map (·.witness)).getD ⟨[], ⟨0, 0, 0, 0⟩⟩)
    else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CellAnalysis](Analysis.md#decl-440d2015df04ff83), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EpilogueWitness](ScaledGemmAnalysis.md#decl-3e3379db8d7cd6f8), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmCandidate.epilogue](Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GroupWitness](../TC/Program/GroupAnalysis.md#decl-f08d46262601f09c), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.ScaledAnalysis](ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.ScaledWitness](ScaledGemmAnalysis.md#decl-689b6d14860c84bb), [TensorCore.analyzeConvertedGemm](ConvertedGemmAnalysis.md#decl-373563c7ab17b86a), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeGemm](NativeGemm.md#decl-7ea04ca33432bb35), [TensorCore.inferEntryFamily](EntryFamily.md#decl-5e36ba2c223b5587), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848)

<details>
<summary>Used by</summary>

[TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b)

</details>

</details>

<a id="decl-32e80897e0e6f460"></a>

<details>
<summary><code>TensorCore.GemmProblem.check</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L89)

```lean
def GemmProblem.check (p : GemmProblem m n k) (c : GemmCandidate) (w : p.Witness)
    (tol : ℚ) : Bool :=
  match p with
  | .raw A B C => gemmAnalysisCheck c.model A B C w tol
  | .scaled source alpha beta A B C =>
    convertedAnalysisCheck source c.inputMode c.model c.epilogue alpha beta A B C w tol
  | .family f => familyCheck c.model k f w tol
  | .entryFamily f => entryFamilyCheck c.model f w tol
  | .native precision A B C =>
    ((c.nativeModel precision).map fun model => nativeAnalysisCheck model A B C w tol).getD false
  | .nativeScaled precision source outputMode alpha beta A B C =>
    ((c.nativeModel precision).map fun model =>
      nativeConvertedAnalysisCheck source c.inputMode model (c.nativeEpilogue outputMode) alpha beta A B C w tol).getD false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmCandidate.epilogue](Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.convertedAnalysisCheck](ConvertedGemmAnalysis.md#decl-bc39b43acd1fa4bf), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.gemmAnalysisCheck](Analysis.md#decl-6640feb1a0c523f2), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b)

</details>

</details>

<a id="decl-ae06390f648648a8"></a>

<details>
<summary><code>TensorCore.GemmProblem.check_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L103)

```lean
theorem GemmProblem.check_sound (p : GemmProblem m n k) (c : GemmCandidate) (w : p.Witness)
    (tol : ℚ) (h : p.check c w tol = true) : p.Accurate c tol := by
  cases p with
  | raw A B C => exact gemmAnalysisCheck_sound c.model A B C w tol h
  | scaled source alpha beta A B C =>
    exact convertedAnalysisCheck_sound source c.inputMode c.model c.epilogue alpha beta A B C w tol h
  | family f => exact familyCheck_sound c.model f w m n k tol h
  | entryFamily f => exact entryFamilyCheck_sound c.model f w tol h
  | native precision A B C =>
    cases hm : c.nativeModel precision with
    | none => simp [check, hm] at h
    | some model => exact ⟨model, hm, nativeAnalysisCheck_sound model A B C w tol (by simpa [check, hm] using h)⟩
  | nativeScaled precision source outputMode alpha beta A B C =>
    cases hm : c.nativeModel precision with
    | none => simp [check, hm] at h
    | some model => exact ⟨model, hm, nativeConvertedAnalysisCheck_sound source c.inputMode model
        (c.nativeEpilogue outputMode) alpha beta A B C w tol (by simpa [check, hm] using h)⟩
```

**Supporting proofs:** [TensorCore.convertedAnalysisCheck_sound](ConvertedGemmAnalysis.md#decl-4fef0511ab9972bb), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmAnalysisCheck_sound](Analysis.md#decl-9853d7ce970a5d1d), [TensorCore.nativeAnalysisCheck_sound](NativeGemm.md#decl-f6bddcc98d97f99f), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmCandidate.epilogue](Selection.md#decl-be6f4119dc437b5f), [TensorCore.GemmCandidate.nativeEpilogue](Selection.md#decl-a3c28b9398f7ee4f), [TensorCore.GemmCandidate.nativeModel](Selection.md#decl-8dc154fd49148f2c), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.NativeConvertedGemmAccurate](NativeConvertedAnalysis.md#decl-ea71efe82ee92d2a), [TensorCore.NativeGemmAccurate](NativeGemm.md#decl-05565e34f54e5d74), [TensorCore.NativeGemmModel](NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](NativeGemm.md#decl-adb4602de4a52395), [TensorCore.nativeAnalysisCheck](NativeGemm.md#decl-10bee9068a09e5e3), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b)

</details>

</details>

<a id="decl-658719161ad7081e"></a>

<details>
<summary><code>TensorCore.candidateCertified</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L121)

```lean
def candidateCertified (p : GemmProblem m n k) (tol : ℚ) (c : GemmCandidate) : Bool :=
  ((p.infer c).map fun w => p.check c w tol).getD false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269)

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.selected_accuracy](Regression/NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.ReviewClaims.chosen_accuracy_and_minimum](Regression/ReviewClaims.md#decl-48d32b8ae011d0c9), [TensorCore.Regression.native_selection_certifies](Regression/DecisionExtensions.md#decl-ec5c1612f9785b31), [TensorCore.Regression.varied_family_certifies](Regression/DecisionExtensions.md#decl-18eefe337a464c5b), [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b), [TensorCore.selectGemm](Selection.md#decl-ac87128da56c0502), [TensorCore.selectGemmCost](CostSelection.md#decl-11498eca158bf117), [TensorCore.selectGemmCost_sound](CostSelection.md#decl-aa59b068120a3e6e), [TensorCore.selectGemm_accuracy](Selection.md#decl-b72d2d5f7d629f7e), [TensorCore.selectGemm_none](Selection.md#decl-c680323aca69a763), [TensorCore.selectGemm_sound](Selection.md#decl-5e96e7835b692828)

</details>

</details>

<a id="decl-a02dc0d0ac1bf80b"></a>

<details>
<summary><code>TensorCore.candidateCertified_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L124)

```lean
theorem candidateCertified_sound (p : GemmProblem m n k) (tol : ℚ) (c : GemmCandidate)
    (h : candidateCertified p tol c = true) : p.Accurate c tol := by
  cases hi : p.infer c with
  | none => simp [candidateCertified, hi] at h
  | some w => exact p.check_sound c w tol (by simpa [candidateCertified, hi] using h)
```

**Supporting proofs:** [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8)

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.varied_family_universal](Regression/DecisionExtensions.md#decl-316ae3e57a6f638f), [TensorCore.selectGemmCost_sound](CostSelection.md#decl-aa59b068120a3e6e), [TensorCore.selectGemm_sound](Selection.md#decl-5e96e7835b692828)

</details>

</details>

<a id="decl-ac87128da56c0502"></a>

<details>
<summary><code>TensorCore.selectGemm</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L130)

```lean
def selectGemm (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : ℚ) : Option ℕ :=
  candidates.findIdx? (candidateCertified p tol)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e)

<details>
<summary>Used by</summary>

[TensorCore.Cli.Selection.evaluate](Cli/GemmSelection.md#decl-aa21b3bd9b0a9fae), [TensorCore.Regression.selection_family](Regression/GemmSelection.md#decl-dfcf9fc60b19226e), [TensorCore.Regression.selection_preference_and_duplicates](Regression/GemmSelection.md#decl-904c1ea57c4ea668), [TensorCore.Regression.selection_rejection_policy](Regression/GemmSelection.md#decl-6bec8bea89cb74e8), [TensorCore.Regression.selection_signed_zero_subnormal_and_boundary](Regression/GemmSelection.md#decl-eb5d3b0bfd127365), [TensorCore.Regression.selection_source_rounding](Regression/GemmSelection.md#decl-0dd610d44068927b), [TensorCore.Regression.selection_tolerance_changes_choice](Regression/GemmSelection.md#decl-f9fe8538a74a65ec), [TensorCore.selectGemm_accuracy](Selection.md#decl-b72d2d5f7d629f7e), [TensorCore.selectGemm_none](Selection.md#decl-c680323aca69a763), [TensorCore.selectGemm_sound](Selection.md#decl-5e96e7835b692828)

</details>

</details>

<a id="decl-5e96e7835b692828"></a>

<details>
<summary><code>TensorCore.selectGemm_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L133)

```lean
theorem selectGemm_sound (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : ℚ)
    (i : ℕ) (h : selectGemm p candidates tol = some i) :
    ∃ hi : i < candidates.length, p.Accurate candidates[i] tol ∧
      ∀ j (hj : j < i), candidateCertified p tol candidates[j] = false := by
  obtain ⟨hi, hc, hp⟩ := List.findIdx?_eq_some_iff_getElem.mp h
  exact ⟨hi, candidateCertified_sound p tol candidates[i] hc, fun j hj => by simpa using hp j hj⟩
```

**Supporting proofs:** [TensorCore.candidateCertified_sound](Selection.md#decl-a02dc0d0ac1bf80b)

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.selectGemm](Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.selectGemm_accuracy](Selection.md#decl-b72d2d5f7d629f7e)

</details>

</details>

<a id="decl-b72d2d5f7d629f7e"></a>

<details>
<summary><code>TensorCore.selectGemm_accuracy</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L140)

```lean
theorem selectGemm_accuracy (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : ℚ)
    (i : ℕ) (c : GemmCandidate) (h : selectGemm p candidates tol = some i)
    (hc : candidates[i]? = some c) : p.Accurate c tol := by
  obtain ⟨hi, ha, _⟩ := selectGemm_sound p candidates tol i h
  have he : candidates[i] = c := by simpa only [List.getElem?_eq_getElem hi, Option.some.injEq] using hc
  exact he ▸ ha
```

**Supporting proofs:** [TensorCore.selectGemm_sound](Selection.md#decl-5e96e7835b692828)

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.selectGemm](Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.selection_source_accuracy](Regression/GemmSelection.md#decl-04a6c70aaf01cddf)

</details>

</details>

<a id="decl-c680323aca69a763"></a>

<details>
<summary><code>TensorCore.selectGemm_none</code></summary>

[Lean source](../../../TensorCore/Gemm/Selection.lean#L147)

```lean
theorem selectGemm_none (p : GemmProblem m n k) (candidates : List GemmCandidate) (tol : ℚ) :
    selectGemm p candidates tol = none ↔ ∀ c ∈ candidates, candidateCertified p tol c = false := by
  exact List.findIdx?_eq_none_iff
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmCandidate](Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.candidateCertified](Selection.md#decl-658719161ad7081e), [TensorCore.selectGemm](Selection.md#decl-ac87128da56c0502)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
