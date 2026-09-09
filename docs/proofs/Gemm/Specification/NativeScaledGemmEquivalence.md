# TensorCore.Gemm.Specification.NativeScaledGemmEquivalence

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0835735bf484ace3"></a>

<details>
<summary><code>TensorCore.PaperSpec.matrixChunks_map</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledGemmEquivalence.lean#L10)

```lean
theorem matrixChunks_map (f : α → β) (width count : ℕ) (xs : List α) :
    (matrixChunks width count xs).map (List.map f) = matrixChunks width count (xs.map f) := by
  induction count generalizing xs with
  | zero => rfl
  | succ count ih => simp [matrixChunks, List.map_take, List.map_drop, ih]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe)

</details>

</details>

<a id="decl-dc12a18524533ebe"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeProductCell_eq_independent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledGemmEquivalence.lean#L16)

```lean
theorem nativeProductCell_eq_independent (model : NativeGemmModel p)
    (pairs : List (NativeWord p × NativeWord p)) :
    (nativeProductCell model pairs).map gemmCellObservation =
      nativeProductMatrixCell (parametersOf model.profile) p.inner pairs := by
  unfold nativeProductMatrixCell
  rw [← nativeGemmCell_eq_paper model pairs 0]
  cases hp : nativeGemmCell model pairs 0 with
  | none => unfold nativeProductCell; rw [hp]; rfl
  | some cell =>
    have hz : cell.initial.bits = 0 := by
      simp only [nativeGemmCell, bind, pure, Option.bind_eq_some_iff, Option.some.injEq] at hp
      obtain ⟨initial, hi, ts, _, rfl⟩ := hp
      exact finite32_bits hi
    simp only [nativeProductCell, hp, Option.map_some, bind, pure, Option.bind_some, Option.some.injEq]
    simp only [gemmCellObservation, nativeProductTrace, chunks_eq_matrixChunks, matrixChunks_map, hz]
    rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.chunks_eq_matrixChunks](GemmEquivalence.md#decl-d259480c970e3a94), [TensorCore.PaperSpec.matrixChunks_map](NativeScaledGemmEquivalence.md#decl-0835735bf484ace3), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.finite32_bits](../../TC/Program/Defs.md#decl-08ec57f1c290b572)

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](../NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativeGemmModel.profile](../NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](../NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.matrixChunks](Matrix.md#decl-4b229a112eae4f8a), [TensorCore.PaperSpec.nativeMatrixCell](NativeMatrix.md#decl-a26286392090ff3e), [TensorCore.PaperSpec.nativeProductMatrixCell](NativeScaledMatrix.md#decl-d9bdf4b9d079ae28), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.chunks](../../TC/Instruction.md#decl-3eda2673db5b65b7), [TensorCore.finite32](../../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.groupCount](../../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.nativeBlocks](../NativeGemm.md#decl-ae9fa1eae5c4de10), [TensorCore.nativeGemmCell](../NativeGemm.md#decl-74e63a5f52eb41d5), [TensorCore.nativeProductCell](../NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeProductTrace](../NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.runBlocks](../../TC/Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f)

</details>

</details>

<a id="decl-3e0fc41a9ec7970f"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeScaledGemm_eq_independent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledGemmEquivalence.lean#L33)

```lean
theorem nativeScaledGemm_eq_independent (model : NativeGemmModel p) (cfg : GemmEpilogue)
    (alpha beta : F32) (A : DenseMatrix (NativeWord p) m k) (B : DenseMatrix (NativeWord p) k n)
    (C : DenseMatrix F32 m n) :
    (nativeScaledGemm model cfg alpha beta A B C).map (fun row => row.map fun cell =>
      cell.map scaledCellObservation) =
      nativeScaledMatrix (parametersOf model.profile) p.inner (epilogueOf cfg) alpha beta A B C := by
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [nativeScaledGemm, nativeScaledMatrix, DenseMatrix.ofFn, Vector.getElem_map, Vector.getElem_ofFn]
  change ((nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).bind
    (gemmEpilogue cfg alpha beta C[i][j])).map scaledCellObservation =
    ((nativeProductMatrixCell (parametersOf model.profile) p.inner (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
  calc
    _ = ((nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩)).map gemmCellObservation).bind
        (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]) := by
      cases nativeProductCell model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩) with
      | none => rfl
      | some product => exact (scalarEpilogue_eq cfg alpha beta C[i][j] product).symm
    _ = _ := congrArg (fun product : Option MatrixCell => product.bind
      (scalarEpilogue (epilogueOf cfg) alpha beta C[i][j]))
      (nativeProductCell_eq_independent model (nativePairs A B ⟨i, hi⟩ ⟨j, hj⟩))
```

**Supporting proofs:** [TensorCore.PaperSpec.nativeProductCell_eq_independent](NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

**Definitions and types:** [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.profile](../NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.inner](../NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.gemmCellObservation](GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.nativeProductMatrixCell](NativeScaledMatrix.md#decl-d9bdf4b9d079ae28), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.gemmEpilogue](../ScaledGemm.md#decl-830c6be1cd273929), [TensorCore.nativePairs](../NativeGemm.md#decl-160e768b2358c84f), [TensorCore.nativeProductCell](../NativeScaledGemm.md#decl-b4ad7b6a1c2586e6), [TensorCore.nativeScaledGemm](../NativeScaledGemm.md#decl-727eddedc05f8257)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a)

</details>

</details>

<a id="decl-0c4aad986b36989b"></a>

<details>
<summary><code>TensorCore.PaperSpec.convertMatrixToLayout_eq</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledGemmEquivalence.lean#L58)

```lean
theorem convertMatrixToLayout_eq (source target : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) :
    convertMatrixToLayout (layoutOf source) (layoutOf target) (scalarModeOf mode) A =
      convertMatrixTo source target mode A := by
  classical
  unfold convertMatrixToLayout convertMatrixTo
  simp only [scalarConvertWord_eq]
  rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.convertMatrixToLayout](NativeScaledMatrix.md#decl-ba133c7a4812ff93), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.convertGemmWord](../ScaledGemm.md#decl-90caef944befb68d), [TensorCore.convertMatrixTo](../MatrixConversion.md#decl-ebb9bf1ec4c6ff34)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a)

</details>

</details>

<a id="decl-2e75264013becf7a"></a>

<details>
<summary><code>TensorCore.PaperSpec.nativeConvertedGemm_eq_independent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/NativeScaledGemmEquivalence.lean#L67)

```lean
theorem nativeConvertedGemm_eq_independent (source : Format) (mode : BinaryRoundingMode)
    (model : NativeGemmModel p) (cfg : GemmEpilogue) (alpha beta : F32)
    (A : DenseMatrix (BitVec source.width) m k) (B : DenseMatrix (BitVec source.width) k n)
    (C : DenseMatrix F32 m n) :
    (nativeConvertedGemm source mode model cfg alpha beta A B C).map
      (fun D => D.map fun row => row.map fun cell => cell.map scaledCellObservation) =
      nativeConvertedMatrix (layoutOf source) (scalarModeOf mode) (parametersOf model.profile)
        p.inner (epilogueOf cfg) alpha beta A B C := by
  simp only [nativeConvertedGemm, nativeConvertedMatrix, parametersOf, NativeGemmModel.profile, convertMatrixToLayout_eq]
  cases ha : convertMatrixTo source p.format mode A <;> cases hb : convertMatrixTo source p.format mode B <;>
    simp [bind, pure, nativeScaledGemm_eq_independent] <;> rfl
```

**Supporting proofs:** [TensorCore.PaperSpec.convertMatrixToLayout_eq](NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativeGemmModel.products](../NativeGemm.md#decl-ac6b62d5b4f2d47b), [TensorCore.NativeGemmModel.profile](../NativeGemm.md#decl-55e737716812459e), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativePrecision.inner](../NativeGemm.md#decl-9b4f9f60884163ac), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.Parameters](../../TC/Specification/Defs.md#decl-26a9e9dc96610178), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.convertMatrixToLayout](NativeScaledMatrix.md#decl-ba133c7a4812ff93), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.layoutOf](../../TC/Specification/Stages.md#decl-04255acd1d57f3f3), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.parametersOf](../../TC/Specification/Stages.md#decl-91b93bf798baf8df), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.convertMatrixTo](../MatrixConversion.md#decl-ebb9bf1ec4c6ff34), [TensorCore.nativeConvertedGemm](../NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativeScaledGemm](../NativeScaledGemm.md#decl-727eddedc05f8257)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>
