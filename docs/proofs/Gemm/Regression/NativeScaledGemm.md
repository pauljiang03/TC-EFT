# TensorCore.Gemm.Regression.NativeScaledGemm

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e5ee01baed4b1c83"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.cfg</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L10)

```lean
def cfg (mode : BinaryRoundingMode) : GemmEpilogue := ⟨mode, mode, ⟨fp32, mode⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.exact_scaled](NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.intermediate_overflow_rejected](NativeScaledGemm.md#decl-6d29392f8e156c74), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.NativeScaled.selected_accuracy](NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](NativeScaledGemm.md#decl-71f349d7e00dbf7d)

</details>

</details>

<a id="decl-a60de336610ac4a3"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.exact_scaled</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L12)

```lean
theorem exact_scaled (model : NativeGemmModel p) (mode : BinaryRoundingMode) :
    (nativeConvertedGemm fp32 mode model (cfg mode) 0x40000000 0xbf800000
      #v[#v[0x3f800000]] #v[#v[0x40400000]] #v[#v[0x3f800000]]).bind
      (fun D => D[0][0].map fun t => (t.product.output.bits, t.scaledProduct.bits, t.scaledC.bits, t.output.bits)) =
      some (0x40400000, 0x40c00000, 0xbf800000, 0x40a00000) := by
  cases p <;> cases model <;> cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.Regression.NativeScaled.cfg](NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.nativeConvertedGemm](../NativeScaledGemm.md#decl-fffa475379689f33)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.empty_and_rejected_inputs](NativeScaledGemm.md#decl-02f98a27315f65cd), [TensorCore.Regression.NativeScaled.intermediate_overflow_rejected](NativeScaledGemm.md#decl-6d29392f8e156c74), [TensorCore.Regression.NativeScaled.native_range_exceeds_fp16](NativeScaledGemm.md#decl-f1e9b800fa93c148), [TensorCore.Regression.NativeScaled.raw_scaled_order_differs](NativeScaledGemm.md#decl-0218da495949df95), [TensorCore.Regression.NativeScaled.selected_accuracy](NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](NativeScaledGemm.md#decl-71f349d7e00dbf7d)

</details>

</details>

<a id="decl-f1e9b800fa93c148"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.native_range_exceeds_fp16</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L19)

```lean
theorem native_range_exceeds_fp16 (model : NativeGemmModel p) :
    (nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0x3f800000 0
      #v[#v[0x47800000]] #v[#v[0x3f800000]] #v[#v[0]]).bind
      (fun D => D[0][0].map fun t => t.output.value) = some 65536 ∧
    convertGemmWord fp32 fp16 .nearestEven 0x47800000 = none := by
  cases p <;> cases model <;> decide +kernel
```

**Supporting proofs:** [TensorCore.Regression.NativeScaled.exact_scaled](NativeScaledGemm.md#decl-a60de336610ac4a3)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.Regression.NativeScaled.cfg](NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.convertGemmWord](../ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.nativeConvertedGemm](../NativeScaledGemm.md#decl-fffa475379689f33)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e7e7e2b3bee0ac7e"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.directed_input_conversion</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L26)

```lean
theorem directed_input_conversion (mode : BinaryRoundingMode) :
    convertGemmWord fp32 bf16 mode 0xbf808000 =
      some (if mode = .towardNegative then 0xbf81 else 0xbf80) ∧
    convertGemmWord fp32 tf19 mode 0xbf801000 =
      some (if mode = .towardNegative then 0x5fc01 else 0x5fc00) ∧
    convertGemmWord fp32 bf16 mode 0x3f808000 =
      some (if mode = .towardPositive then 0x3f81 else 0x3f80) ∧
    convertGemmWord fp32 tf19 mode 0x3f801000 =
      some (if mode = .towardPositive then 0x1fc01 else 0x1fc00) := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.convertGemmWord](../ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bc504f6ac48ae017"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.subnormal_zero_boundaries</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L37)

```lean
theorem subnormal_zero_boundaries (mode : BinaryRoundingMode) :
    convertGemmWord fp32 bf16 mode 0x80000001 =
      some (if mode = .towardNegative then 0x8001 else 0x8000) ∧
    convertGemmWord fp32 tf19 mode 0x80000001 =
      some (if mode = .towardNegative then 0x40001 else 0x40000) ∧
    convertGemmWord fp32 bf16 mode 0x80000000 = some 0 ∧
    convertGemmWord fp32 tf19 mode 0x80000000 = some 0 ∧
    convertGemmWord fp32 bf16 mode 0x7f7f0000 = some 0x7f7f ∧
    convertGemmWord fp32 bf16 mode 0x7f7f0001 = none ∧
    convertGemmWord fp32 tf19 mode 0x7f7fe000 = some 0x3fbff ∧
    convertGemmWord fp32 tf19 mode 0x7f7fe001 = none := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.convertGemmWord](../ScaledGemm.md#decl-90caef944befb68d), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9de6ebab37ab361d"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.tiny</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L50)

```lean
def tiny (p : NativePrecision) : NativeWord p :=
  match p with | .bf16 => 0x3980 | .tf32 => 0x1cc00
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativePrecision.format](../NativeGemm.md#decl-837815a482deb8b3), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395)

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.raw_scaled_order_differs](NativeScaledGemm.md#decl-0218da495949df95)

</details>

</details>

<a id="decl-0218da495949df95"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.raw_scaled_order_differs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L53)

```lean
theorem raw_scaled_order_differs (model : NativeGemmModel p) :
    (nativeGemmCell model (List.replicate 15 (tiny p, tiny p)) 0x3f800000).map
      (fun t => t.output.bits) = some 0x3f800007 ∧
    (nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0x3f800000 0x3f800000
      #v[Vector.replicate 15 0x39800000] (Vector.replicate 15 #v[0x39800000]) #v[#v[0x3f800000]]).bind
      (fun D => D[0][0].map fun t => t.output.bits) = some 0x3f800008 := by
  cases p <;> cases model <;> decide +kernel
```

**Supporting proofs:** [TensorCore.Regression.NativeScaled.exact_scaled](NativeScaledGemm.md#decl-a60de336610ac4a3)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmCell](../NativeGemm.md#decl-7bd05491f02ceac8), [TensorCore.NativeGemmCell.output](../NativeGemm.md#decl-270e5e5e51ac1063), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.NativeWord](../NativeGemm.md#decl-adb4602de4a52395), [TensorCore.Regression.NativeScaled.cfg](NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.Regression.NativeScaled.tiny](NativeScaledGemm.md#decl-9de6ebab37ab361d), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.nativeConvertedGemm](../NativeScaledGemm.md#decl-fffa475379689f33), [TensorCore.nativeGemmCell](../NativeGemm.md#decl-74e63a5f52eb41d5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6d29392f8e156c74"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.intermediate_overflow_rejected</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L61)

```lean
theorem intermediate_overflow_rejected (model : NativeGemmModel p) (mode : BinaryRoundingMode) :
    (nativeConvertedGemm fp32 mode model (cfg mode) 0x7f7fffff 0xbf800000
      #v[#v[0x40000000]] #v[#v[0x3f800000]] #v[#v[0x7f7fffff]]).bind (fun D => D[0][0]) = none := by
  cases p <;> cases model <;> cases mode <;> decide +kernel
```

**Supporting proofs:** [TensorCore.Regression.NativeScaled.exact_scaled](NativeScaledGemm.md#decl-a60de336610ac4a3)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.Regression.NativeScaled.cfg](NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.nativeConvertedGemm](../NativeScaledGemm.md#decl-fffa475379689f33)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-02f98a27315f65cd"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.empty_and_rejected_inputs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L66)

```lean
theorem empty_and_rejected_inputs (model : NativeGemmModel p) :
    (nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0x3f800000 0x40000000
      (#v[#v[]] : DenseMatrix F32 1 0) (#v[] : DenseMatrix F32 0 1) #v[#v[0x3f800000]]).bind
      (fun D => D[0][0].map fun t => t.output.bits) = some 0x40000000 ∧
    nativeConvertedGemm fp32 .nearestEven model (cfg .nearestEven) 0 0
      (#v[] : DenseMatrix F32 0 1) #v[#v[0x7f800000]] (#v[] : DenseMatrix F32 0 1) = none := by
  cases p <;> cases model <;> decide +kernel
```

**Supporting proofs:** [TensorCore.Regression.NativeScaled.exact_scaled](NativeScaledGemm.md#decl-a60de336610ac4a3)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.Regression.NativeScaled.cfg](NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.nativeConvertedGemm](../NativeScaledGemm.md#decl-fffa475379689f33)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8b6ac1fc2c8cb122"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.sourceProblem</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L74)

```lean
def sourceProblem (p : NativePrecision) : GemmProblem 1 1 1 :=
  .nativeScaled p fp32 .nearestEven 0x3f800000 0 #v[#v[0x3f800001]] #v[#v[0x3f800000]] #v[#v[0]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmProblem](../Selection.md#decl-cbf3e8441a848a8f), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.selected_accuracy](NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](NativeScaledGemm.md#decl-71f349d7e00dbf7d)

</details>

</details>

<a id="decl-bc91542b4d9b5ae6"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.candidates</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L77)

```lean
def candidates : List CostedCandidate :=
  [⟨{model := .ampere, inputMode := .towardPositive}, 0, 0⟩,
   ⟨{model := .hopper}, 1, 1⟩]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.selected_accuracy](NativeScaledGemm.md#decl-d048ae943d023022), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](NativeScaledGemm.md#decl-71f349d7e00dbf7d)

</details>

</details>

<a id="decl-71f349d7e00dbf7d"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.source_loss_changes_selection</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L81)

```lean
theorem source_loss_changes_selection (p : NativePrecision) :
    selectGemmCost (sourceProblem p) candidates (1 / 1000000) = some ⟨{model := .hopper}, 1, 1⟩ ∧
    (analyzeNativeConvertedGemm fp32 .nearestEven (NativeGemmModel.hopper (p := p))
      (cfg .nearestEven) 0x3f800000 0 #v[#v[0x3f800001]] #v[#v[0x3f800000]] #v[#v[0]]).bind
      (fun D => D[0][0].map fun a => a.bound.inputConversion) = some (1 / 8388608) := by
  cases p <;> decide +kernel
```

**Supporting proofs:** [TensorCore.Regression.NativeScaled.exact_scaled](NativeScaledGemm.md#decl-a60de336610ac4a3)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.PipelineBound](../ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.Regression.NativeScaled.candidates](NativeScaledGemm.md#decl-bc91542b4d9b5ae6), [TensorCore.Regression.NativeScaled.cfg](NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.Regression.NativeScaled.sourceProblem](NativeScaledGemm.md#decl-8b6ac1fc2c8cb122), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeNativeConvertedGemm](../NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.selectGemmCost](../CostSelection.md#decl-11498eca158bf117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.NativeScaled.selected_accuracy](NativeScaledGemm.md#decl-d048ae943d023022)

</details>

</details>

<a id="decl-d048ae943d023022"></a>

<details>
<summary><code>TensorCore.Regression.NativeScaled.selected_accuracy</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/NativeScaledGemm.lean#L88)

```lean
theorem selected_accuracy (p : NativePrecision) : (sourceProblem p).Accurate {model := .hopper} (1 / 1000000) :=
  (selectGemmCost_sound (sourceProblem p) candidates (1 / 1000000) _ (source_loss_changes_selection p).1).2.1
```

**Supporting proofs:** [TensorCore.Regression.NativeScaled.exact_scaled](NativeScaledGemm.md#decl-a60de336610ac4a3), [TensorCore.Regression.NativeScaled.source_loss_changes_selection](NativeScaledGemm.md#decl-71f349d7e00dbf7d), [TensorCore.selectGemmCost_sound](../CostSelection.md#decl-aa59b068120a3e6e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.CostedCandidate](../CostSelection.md#decl-9ac085fec2b9defd), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmCandidate](../Selection.md#decl-633698ca3b748695), [TensorCore.GemmProblem.Accurate](../Selection.md#decl-8c9d3458097dac77), [TensorCore.NativeGemmModel](../NativeGemm.md#decl-a3abe0ff1ca91653), [TensorCore.NativePrecision](../NativeGemm.md#decl-1b7c099e42422b0b), [TensorCore.PipelineBound](../ScaledGemmAnalysis.md#decl-6cb812882dfa62f2), [TensorCore.Regression.NativeScaled.candidates](NativeScaledGemm.md#decl-bc91542b4d9b5ae6), [TensorCore.Regression.NativeScaled.cfg](NativeScaledGemm.md#decl-e5ee01baed4b1c83), [TensorCore.Regression.NativeScaled.sourceProblem](NativeScaledGemm.md#decl-8b6ac1fc2c8cb122), [TensorCore.ScaledAnalysis](../ScaledGemmAnalysis.md#decl-e3e466f30da2b9b7), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.analyzeNativeConvertedGemm](../NativeConvertedAnalysis.md#decl-c0dcde0fbb1acc93), [TensorCore.candidateCertified](../Selection.md#decl-658719161ad7081e), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.selectGemmCost](../CostSelection.md#decl-11498eca158bf117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
