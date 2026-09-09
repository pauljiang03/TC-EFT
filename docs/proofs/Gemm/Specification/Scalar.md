# TensorCore.Gemm.Specification.Scalar

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5298f17d3e63db4e"></a>

<details>
<summary><code>TensorCore.PaperSpec.ScalarMode</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L12)

```lean
inductive ScalarMode where
  | towardZero | nearestEven | towardNegative | towardPositive
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.convertMatrix](Scalar.md#decl-c0712e73fc64ca5f), [TensorCore.PaperSpec.convertMatrixToLayout](NativeScaledMatrix.md#decl-ba133c7a4812ff93), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.scalarCoefficient](Scalar.md#decl-8418bbbe47ded436), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66), [TensorCore.PaperSpec.scalarGridValue](Scalar.md#decl-62d8dcb806cf0800), [TensorCore.PaperSpec.scalarModeOf](ScalarRounding.md#decl-d2db74b0263bc16a), [TensorCore.PaperSpec.scalarRound](Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.Regression.independent_scalar_directions](../../Regression/FoundationCompletion.md#decl-ac87bcf2ff18868c)

</details>

</details>

<a id="decl-e1c152549472c20f"></a>

<details>
<summary><code>TensorCore.PaperSpec.Layout.scalarValid</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L16)

```lean
def Layout.scalarValid (f : Layout) : Prop := 0 < f.fraction ∧ 1 < f.exponent
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45)

</details>

</details>

<a id="decl-2937477b30ef6eb0"></a>

<details>
<summary><code>TensorCore.PaperSpec.Layout.minimumExponent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L17)

```lean
def Layout.minimumExponent (f : Layout) : ℤ := 1 - f.bias
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarExponent](Scalar.md#decl-0788d44f38690792), [TensorCore.PaperSpec.scalarExponent_unique](ScalarRounding.md#decl-dc1d766095dea794)

</details>

</details>

<a id="decl-5d3f38169613a858"></a>

<details>
<summary><code>TensorCore.PaperSpec.Layout.maximumExponent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L18)

```lean
def Layout.maximumExponent (f : Layout) : ℤ := ((2 ^ f.exponent - 2 : ℕ) : ℤ) - f.bias
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Layout.maximumFinite](Scalar.md#decl-4205908460964844), [TensorCore.PaperSpec.ScalarExponent](Scalar.md#decl-0788d44f38690792), [TensorCore.PaperSpec.scalarExponent_unique](ScalarRounding.md#decl-dc1d766095dea794)

</details>

</details>

<a id="decl-4205908460964844"></a>

<details>
<summary><code>TensorCore.PaperSpec.Layout.maximumFinite</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L19)

```lean
def Layout.maximumFinite (f : Layout) : ℚ :=
  ((2 ^ (f.fraction + 1) - 1 : ℕ) : ℚ) * (2 : ℚ) ^ (f.maximumExponent - f.fraction)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.maximumExponent](Scalar.md#decl-5d3f38169613a858)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45)

</details>

</details>

<a id="decl-686feb9702b6dc49"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarValue</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L22)

```lean
def scalarValue (f : Layout) (b : BitVec f.width) : Option ℚ :=
  (decode f b.toNat).map Term.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Term](../../TC/Specification/Defs.md#decl-707444d6b10bb80c), [TensorCore.PaperSpec.decode](../../TC/Specification/Defs.md#decl-1951e6871669c329)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.scalarConvert](Scalar.md#decl-7cff21b148b8dfab), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66), [TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45), [TensorCore.PaperSpec.scalarValue32_finite](ScaledGemmEquivalence.md#decl-13d680b591b379ba), [TensorCore.PaperSpec.scalarValue32_of_finite](ScaledGemmEquivalence.md#decl-4bd57b05007ab0d1), [TensorCore.PaperSpec.scalarValue_eq](ScalarRounding.md#decl-5f6e455aabd909c4)

</details>

</details>

<a id="decl-bbecaf1f5b504db0"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarSign</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L25)

```lean
def scalarSign (f : Layout) (b : BitVec f.width) : Bool :=
  b.toNat / 2 ^ (f.fraction + f.exponent) != 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45), [TensorCore.PaperSpec.scalarSign_eq](ScalarRounding.md#decl-8b6a74aaa17139cc)

</details>

</details>

<a id="decl-0788d44f38690792"></a>

<details>
<summary><code>TensorCore.PaperSpec.ScalarExponent</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L28)

```lean
def ScalarExponent (f : Layout) (m : ℚ) (e : ℤ) : Prop :=
  f.minimumExponent ≤ e ∧ e ≤ f.maximumExponent ∧
    m < (2 : ℚ) ^ (e + 1) ∧ ((2 : ℚ) ^ e ≤ m ∨ e = f.minimumExponent)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.maximumExponent](Scalar.md#decl-5d3f38169613a858), [TensorCore.PaperSpec.Layout.minimumExponent](Scalar.md#decl-2937477b30ef6eb0)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.scalarExponent_unique](ScalarRounding.md#decl-dc1d766095dea794), [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45)

</details>

</details>

<a id="decl-8418bbbe47ded436"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarCoefficient</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L33)

```lean
/-- Integer rounding on a nonnegative grid coordinate, with signed directions. -/
def scalarCoefficient (mode : ScalarMode) (negative : Bool) (x : ℚ) : ℤ :=
  match mode with
  | .towardZero => x.floor
  | .towardNegative => if negative then x.ceil else x.floor
  | .towardPositive => if negative then x.floor else x.ceil
  | .nearestEven =>
    if 1 < 2 * (x - x.floor) ∨ (2 * (x - x.floor) = 1 ∧ x.floor % 2 = 1)
    then x.floor + 1 else x.floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarCoefficient_eq](ScalarRounding.md#decl-2089a73178eb37e6), [TensorCore.PaperSpec.scalarGridValue](Scalar.md#decl-62d8dcb806cf0800), [TensorCore.PaperSpec.scalarGridValue_eq](ScalarRounding.md#decl-b4fe8f74d8aee01a)

</details>

</details>

<a id="decl-62d8dcb806cf0800"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarGridValue</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L42)

```lean
def scalarGridValue (f : Layout) (mode : ScalarMode) (x : ℚ) (e : ℤ) : ℚ :=
  let q := (2 : ℚ) ^ (e - f.fraction)
  let v := (scalarCoefficient mode (decide (x < 0)) (magnitude x / q) : ℚ) * q
  if x < 0 then -v else v
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.scalarCoefficient](Scalar.md#decl-8418bbbe47ded436)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0), [TensorCore.PaperSpec.scalarGridValue_eq](ScalarRounding.md#decl-b4fe8f74d8aee01a), [TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45)

</details>

</details>

<a id="decl-578534046cd031f0"></a>

<details>
<summary><code>TensorCore.PaperSpec.ScalarResult</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L47)

```lean
def ScalarResult (f : Layout) (mode : ScalarMode) (x : ℚ) (b : BitVec f.width) : Prop :=
  f.scalarValid ∧ magnitude x ≤ f.maximumFinite ∧ scalarSign f b = decide (x < 0) ∧
    if x = 0 then scalarValue f b = some 0
    else ∃ e, ScalarExponent f (magnitude x) e ∧ scalarValue f b = some (scalarGridValue f mode x e)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.maximumFinite](Scalar.md#decl-4205908460964844), [TensorCore.PaperSpec.Layout.scalarValid](Scalar.md#decl-e1c152549472c20f), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarExponent](Scalar.md#decl-0788d44f38690792), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.magnitude](../../TC/Specification/Defs.md#decl-4528aade7540d418), [TensorCore.PaperSpec.scalarGridValue](Scalar.md#decl-62d8dcb806cf0800), [TensorCore.PaperSpec.scalarSign](Scalar.md#decl-bbecaf1f5b504db0), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarResult_iff](ScalarRounding.md#decl-950c566a7a363185), [TensorCore.PaperSpec.scalarResult_of_roundBinary](ScalarRounding.md#decl-00aa06dd6d65901b), [TensorCore.PaperSpec.scalarResult_unique](ScalarRounding.md#decl-4b9521bc6b0ebd45), [TensorCore.PaperSpec.scalarRound](Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.PaperSpec.scalarRound_eq](ScalarRounding.md#decl-dac12f3fa291169b)

</details>

</details>

<a id="decl-aec01f04b5c2bdfc"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarRound</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L52)

```lean
noncomputable def scalarRound (f : Layout) (mode : ScalarMode) (x : ℚ) : Option (BitVec f.width) := by
  classical
  exact if h : ∃ b, ScalarResult f mode x b then some (Classical.choose h) else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.ScalarResult](Scalar.md#decl-578534046cd031f0)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarConvert](Scalar.md#decl-7cff21b148b8dfab), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66), [TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57), [TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarRound_eq](ScalarRounding.md#decl-dac12f3fa291169b), [TensorCore.Regression.independent_scalar_directions](../../Regression/FoundationCompletion.md#decl-ac87bcf2ff18868c)

</details>

</details>

<a id="decl-cd13f1ba691467e5"></a>

<details>
<summary><code>TensorCore.PaperSpec.ScalarStage</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L56)

```lean
structure ScalarStage where
  format : Layout
  mode : ScalarMode
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scalarConvert](Scalar.md#decl-7cff21b148b8dfab), [TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scalarStageOf](ScaledGemmEquivalence.md#decl-0d7d7612b2b29253), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-7cff21b148b8dfab"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarConvert</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L61)

```lean
noncomputable def scalarConvert (stage : ScalarStage) (x : ℚ) :
    Option (BitVec stage.format.width × ℚ) := do
  let bits ← scalarRound stage.format stage.mode x
  let value ← scalarValue stage.format bits
  return (bits, value)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.scalarRound](Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.scalarConvert_eq](ScaledGemmEquivalence.md#decl-f61ab03b10876eb6), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb)

</details>

</details>

<a id="decl-cf56fde55dfdad5a"></a>

<details>
<summary><code>TensorCore.PaperSpec.ScalarEpilogue</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L67)

```lean
structure ScalarEpilogue where
  multiplyMode : ScalarMode
  addMode : ScalarMode
  output : ScalarStage
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.epilogueOf](ScaledGemmEquivalence.md#decl-1e5f134635c2454c), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-1ccbb0740d01c0df"></a>

<details>
<summary><code>TensorCore.PaperSpec.ScaledMatrixCell</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L73)

```lean
structure ScaledMatrixCell (output : Layout) where
  product : MatrixCell
  scaledProduct : BitVec 32
  scaledC : BitVec 32
  sum : BitVec 32
  output : BitVec output.width
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.nativeConvertedGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-2e75264013becf7a), [TensorCore.PaperSpec.nativeConvertedMatrix](NativeScaledMatrix.md#decl-a193a5e500a7adca), [TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledCellObservation](ScaledGemmEquivalence.md#decl-a319b456fbf50ad5), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39), [TensorCore.nativeConvertedAnalysisCheck_paper](../NativeConvertedAnalysis.md#decl-1f1d6e0e7d0c4faa)

</details>

</details>

<a id="decl-f83371a35c17d449"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarEpilogue</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L81)

```lean
noncomputable def scalarEpilogue (cfg : ScalarEpilogue) (alpha beta c : BitVec 32)
    (product : MatrixCell) : Option (ScaledMatrixCell cfg.output.format) := do
  let a ← scalarValue binary32 alpha
  let b ← scalarValue binary32 beta
  let c ← scalarValue binary32 c
  let p ← scalarValue binary32 product.output
  let ad ← scalarConvert ⟨binary32, cfg.multiplyMode⟩ (a * p)
  let bc ← scalarConvert ⟨binary32, cfg.multiplyMode⟩ (b * c)
  let sum ← scalarConvert ⟨binary32, cfg.addMode⟩ (ad.2 + bc.2)
  let out ← scalarConvert cfg.output sum.2
  return ⟨product, ad.1, bc.1, sum.1, out.1⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.MatrixCell.output](Matrix.md#decl-2e5dc86c7c48029c), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.binary32](../../TC/Specification/Defs.md#decl-ce9247c05694abaf), [TensorCore.PaperSpec.scalarConvert](Scalar.md#decl-7cff21b148b8dfab), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.nativeScaledGemm_eq_independent](NativeScaledGemmEquivalence.md#decl-3e0fc41a9ec7970f), [TensorCore.PaperSpec.nativeScaledMatrix](NativeScaledMatrix.md#decl-d8536b49742f0b76), [TensorCore.PaperSpec.scalarEpilogue_eq](ScaledGemmEquivalence.md#decl-80f754dc80ca34eb), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62)

</details>

</details>

<a id="decl-eb73cbc06da59e62"></a>

<details>
<summary><code>TensorCore.PaperSpec.scaledMatrix</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L93)

```lean
noncomputable def scaledMatrix (model : WmmaModel) (cfg : ScalarEpilogue)
    (alpha beta : BitVec 32) (A : Matrix (BitVec 16) m k) (B : Matrix (BitVec 16) k n)
    (C : Matrix (BitVec 32) m n) : Matrix (Option (ScaledMatrixCell cfg.output.format)) m n :=
  let products := wmmaGemm model A B (Vector.ofFn fun _ => Vector.ofFn fun _ => 0)
  Vector.ofFn fun i => Vector.ofFn fun j => do
    let product ← products[i.val][j.val]
    scalarEpilogue cfg alpha beta C[i.val][j.val] product
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.scalarEpilogue](Scalar.md#decl-f83371a35c17d449), [TensorCore.PaperSpec.wmmaGemm](Matrix.md#decl-66a4e74e5f4e4b6c)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrix](Scalar.md#decl-c0712e73fc64ca5f), [TensorCore.PaperSpec.convertMatrix_eq](ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e), [TensorCore.PaperSpec.scaledGemmBits_eq_independent](ScaledGemmEquivalence.md#decl-92020721ef951c58), [TensorCore.PaperSpec.scaledGemm_eq_independent](ScaledGemmEquivalence.md#decl-fcea418441d43028), [TensorCore.Regression.independent_scaled_complete](../../Regression/FoundationCompletion.md#decl-ca2da7cbbbbc9939)

</details>

</details>

<a id="decl-0ef08201bf1c5e66"></a>

<details>
<summary><code>TensorCore.PaperSpec.scalarConvertWord</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L101)

```lean
noncomputable def scalarConvertWord (source target : Layout) (mode : ScalarMode)
    (word : BitVec source.width) : Option (BitVec target.width) := do
  let x ← scalarValue source word
  scalarRound target mode x
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.scalarRound](Scalar.md#decl-aec01f04b5c2bdfc), [TensorCore.PaperSpec.scalarValue](Scalar.md#decl-686feb9702b6dc49)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrix](Scalar.md#decl-c0712e73fc64ca5f), [TensorCore.PaperSpec.convertMatrixToLayout](NativeScaledMatrix.md#decl-ba133c7a4812ff93), [TensorCore.PaperSpec.convertMatrixToLayout_eq](NativeScaledGemmEquivalence.md#decl-0c4aad986b36989b), [TensorCore.PaperSpec.convertMatrix_eq](ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.scalarConvertWord_eq](ScaledGemmEquivalence.md#decl-b298d005dd377d57)

</details>

</details>

<a id="decl-c0712e73fc64ca5f"></a>

<details>
<summary><code>TensorCore.PaperSpec.convertMatrix</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L106)

```lean
noncomputable def convertMatrix (source : Layout) (mode : ScalarMode)
    (A : Matrix (BitVec source.width) m n) : Option (Matrix (BitVec 16) m n) := by
  classical
  exact if ∀ i : Fin m, ∀ j : Fin n, (scalarConvertWord source ⟨10, 5, 15⟩ mode A[i.val][j.val]).isSome then
    some (Vector.ofFn fun i => Vector.ofFn fun j =>
      (scalarConvertWord source ⟨10, 5, 15⟩ mode A[i.val][j.val]).getD 0)
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.scalarConvertWord](Scalar.md#decl-0ef08201bf1c5e66), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertMatrix_eq](ScaledGemmEquivalence.md#decl-6abc23999fbbbae3), [TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.PaperSpec.convertedMatrix](Scalar.md#decl-e146d465c52d904e)

</details>

</details>

<a id="decl-e146d465c52d904e"></a>

<details>
<summary><code>TensorCore.PaperSpec.convertedMatrix</code></summary>

[Lean source](../../../../TensorCore/Gemm/Specification/Scalar.lean#L114)

```lean
noncomputable def convertedMatrix (source : Layout) (inputMode : ScalarMode)
    (model : WmmaModel) (cfg : ScalarEpilogue) (alpha beta : BitVec 32)
    (A : Matrix (BitVec source.width) m k) (B : Matrix (BitVec source.width) k n)
    (C : Matrix (BitVec 32) m n) : Option (Matrix (Option (ScaledMatrixCell cfg.output.format)) m n) := do
  let a ← convertMatrix source inputMode A
  let b ← convertMatrix source inputMode B
  return scaledMatrix model cfg alpha beta a b C
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.PaperSpec.Layout](../../TC/Specification/Defs.md#decl-3651fca160255c9d), [TensorCore.PaperSpec.Layout.width](../../TC/Specification/Defs.md#decl-b7a731aa48165c61), [TensorCore.PaperSpec.Matrix](Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.ScalarEpilogue](Scalar.md#decl-cf56fde55dfdad5a), [TensorCore.PaperSpec.ScalarMode](Scalar.md#decl-5298f17d3e63db4e), [TensorCore.PaperSpec.ScalarStage](Scalar.md#decl-cd13f1ba691467e5), [TensorCore.PaperSpec.ScaledMatrixCell](Scalar.md#decl-1ccbb0740d01c0df), [TensorCore.PaperSpec.WmmaModel](Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.convertMatrix](Scalar.md#decl-c0712e73fc64ca5f), [TensorCore.PaperSpec.scaledMatrix](Scalar.md#decl-eb73cbc06da59e62)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.convertedGemm_eq_independent](ScaledGemmEquivalence.md#decl-cf7e09c03287eb25), [TensorCore.Regression.independent_converted_rejection](../../Regression/FoundationCompletion.md#decl-2a3011cf657be65d), [TensorCore.convertedAnalysisCheck_paper](../ConvertedGemmAnalysis.md#decl-6a4213fedaaf8e39)

</details>

</details>
