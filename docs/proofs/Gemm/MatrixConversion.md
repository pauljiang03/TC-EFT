# TensorCore.Gemm.MatrixConversion

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ebb9bf1ec4c6ff34"></a>

<details>
<summary><code>TensorCore.convertMatrixTo</code></summary>

[Lean source](../../../TensorCore/Gemm/MatrixConversion.lean#L7)

```lean
def convertMatrixTo (source target : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) : Option (DenseMatrix (BitVec target.width) m n) :=
  if ∀ i : Fin m, ∀ j : Fin n, (convertGemmWord source target mode A[i.val][j.val]).isSome then
    some (DenseMatrix.ofFn fun i j => (convertGemmWord source target mode A[i.val][j.val]).getD 0)
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.PaperSpec.convertMatrixToLayout_eq](Specification/NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](Specification/NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.analyzeNativeConvertedGemm](NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.analyzeNativeConvertedGemm_matrix_error](NativeConvertedAnalysis.md#decl-9e1e0b7ef35671a4), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.convertMatrixTo_entry](MatrixConversion.md#decl-d6a9de60120b6e01), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.nativeConvertedAnalysisCheck](NativeConvertedAnalysis.md#decl-5abbeacff71576c1), [TensorCore.nativeConvertedAnalysisCheck_sound](NativeConvertedAnalysis.md#decl-bcd2971126fa98b6), [TensorCore.nativeConvertedGemm](NativeScaledGemm.md#decl-fffa475379689f33)

</details>

</details>

<a id="decl-d6a9de60120b6e01"></a>

<details>
<summary><code>TensorCore.convertMatrixTo_entry</code></summary>

[Lean source](../../../TensorCore/Gemm/MatrixConversion.lean#L13)

```lean
theorem convertMatrixTo_entry (source target : Format) (mode : BinaryRoundingMode)
    (A : DenseMatrix (BitVec source.width) m n) (B : DenseMatrix (BitVec target.width) m n)
    (h : convertMatrixTo source target mode A = some B) (i : Fin m) (j : Fin n) :
    convertGemmWord source target mode A[i.val][j.val] = some B[i.val][j.val] := by
  unfold convertMatrixTo at h
  split at h
  · rename_i hs
    cases Option.some.inj h
    have hi := hs i j
    cases hv : convertGemmWord source target mode A[i.val][j.val] with
    | none => simp [hv] at hi
    | some v => simp [DenseMatrix.ofFn, hv]
  · contradiction
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.convertMatrixTo](MatrixConversion.md#decl-ebb9bf1ec4c6ff34)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da)

</details>

</details>

<a id="decl-79dff1e7ec8731f0"></a>

<details>
<summary><code>TensorCore.inputDatumTo</code></summary>

[Lean source](../../../TensorCore/Gemm/MatrixConversion.lean#L27)

```lean
def inputDatumTo (source target : Format) (mode : BinaryRoundingMode)
    (bits : BitVec source.width) : Option GemmInputDatum := do
  let x ← binaryValue source bits
  let y ← (ConversionStage.mk target mode).convert x
  return ⟨x, y.value⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.inputDatumTo_of_conversion](MatrixConversion.md#decl-d34ea96a86529b47), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b)

</details>

</details>

<a id="decl-d34ea96a86529b47"></a>

<details>
<summary><code>TensorCore.inputDatumTo_of_conversion</code></summary>

[Lean source](../../../TensorCore/Gemm/MatrixConversion.lean#L33)

```lean
theorem inputDatumTo_of_conversion (source target : Format) (mode : BinaryRoundingMode)
    (input : BitVec source.width) (output : BitVec target.width)
    (h : convertGemmWord source target mode input = some output) :
    ∃ d, inputDatumTo source target mode input = some d ∧
      binaryValue source input = some d.value ∧ binaryValue target output = some d.converted := by
  simp only [convertGemmWord, bind, pure, Option.bind_eq_some_iff] at h
  obtain ⟨x, hx, y, hy, he⟩ := h
  cases Option.some.inj he
  refine ⟨⟨x, y.value⟩, by simp [inputDatumTo, hx, hy], hx, ?_⟩
  simp [binaryValue, y.valid, FiniteBinary.value]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.inputDatumTo](MatrixConversion.md#decl-79dff1e7ec8731f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b)

</details>

</details>

<a id="decl-eeb239136bf20190"></a>

<details>
<summary><code>TensorCore.inputProductErrorTo</code></summary>

[Lean source](../../../TensorCore/Gemm/MatrixConversion.lean#L44)

```lean
def inputProductErrorTo (source target : Format) (mode : BinaryRoundingMode) :
    List (BitVec source.width × BitVec source.width) → Option ℚ
  | [] => some 0
  | (a, b) :: rest => do
    let av ← inputDatumTo source target mode a
    let bv ← inputDatumTo source target mode b
    let tail ← inputProductErrorTo source target mode rest
    return gemmInputPairTightError av bv + tail
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83), [TensorCore.inputDatumTo](MatrixConversion.md#decl-79dff1e7ec8731f0)

<details>
<summary>Used by</summary>

[TensorCore.Cli.NativePipeline.execution](Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.analyzeNativeConvertedGemm_checked](NativeConvertedAnalysis.md#decl-94b16087f568439c), [TensorCore.checkNativeConvertedCell](NativeConvertedAnalysis.md#decl-391b325129d3f272), [TensorCore.checkNativeConvertedCell_sound](NativeConvertedAnalysis.md#decl-fe18412a5491e109), [TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da), [TensorCore.inputProductErrorTo_bound](MatrixConversion.md#decl-b9c5e5986779238b), [TensorCore.nativeSourceAnalysisCell](NativeConvertedAnalysis.md#decl-1fde80241417645a)

</details>

</details>

<a id="decl-b9c5e5986779238b"></a>

<details>
<summary><code>TensorCore.inputProductErrorTo_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/MatrixConversion.lean#L53)

```lean
theorem inputProductErrorTo_bound (source target : Format) (mode : BinaryRoundingMode)
    (xs : List ι) (input : ι → BitVec source.width × BitVec source.width)
    (output : ι → BitVec target.width × BitVec target.width)
    (h : ∀ x ∈ xs,
      convertGemmWord source target mode (input x).1 = some (output x).1 ∧
      convertGemmWord source target mode (input x).2 = some (output x).2) :
    ∃ s p e, sourceGemmProducts source (xs.map input) = some s ∧
      sourceGemmProducts target (xs.map output) = some p ∧
      inputProductErrorTo source target mode (xs.map input) = some e ∧ absQ (s - p) ≤ e := by
  induction xs with
  | nil => exact ⟨0, 0, 0, rfl, rfl, rfl, by decide +kernel⟩
  | cons x xs ih =>
    obtain ⟨ha, hb⟩ := h x (by simp)
    obtain ⟨a, had, hav, hac⟩ := inputDatumTo_of_conversion source target mode _ _ ha
    obtain ⟨b, hbd, hbv, hbc⟩ := inputDatumTo_of_conversion source target mode _ _ hb
    obtain ⟨s, p, e, hs, hp, he, hbnd⟩ := ih (by intro y hy; exact h y (by simp [hy]))
    refine ⟨a.value * b.value + s, a.converted * b.converted + p,
      gemmInputPairTightError a b + e, ?_, ?_, ?_, ?_⟩
    · simp [sourceGemmProducts, hav, hbv, hs]
    · simp [sourceGemmProducts, hac, hbc, hp]
    · simp [inputProductErrorTo, had, hbd, he]
    · have ht := absQ_add_le (a.value * b.value - a.converted * b.converted) (s - p)
      have hx := gemmInputPairTightError_bound a b
      grind
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.gemmInputPairTightError_bound](TightInputBounds.md#decl-251c676d4c121cd6), [TensorCore.inputDatumTo_of_conversion](MatrixConversion.md#decl-d34ea96a86529b47)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmInputDatum](InputBounds.md#decl-8b1ea358e6bcaa87), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.convertGemmWord](ScaledGemm.md#decl-90caef944befb68d), [TensorCore.gemmInputPairTightError](TightInputBounds.md#decl-1a5881f86db47f83), [TensorCore.inputDatumTo](MatrixConversion.md#decl-79dff1e7ec8731f0), [TensorCore.inputProductErrorTo](MatrixConversion.md#decl-eeb239136bf20190), [TensorCore.sourceGemmProducts](InputBounds.md#decl-143ccf0aa454df6c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.convertNativeInput_products_error](NativeConvertedAnalysis.md#decl-aa9a1f5af4f849da)

</details>

</details>
