# TensorCoreTests.TC.Cases

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-909afd874533ccae"></a>

<details>
<summary><code>TensorCore.Regression.V100Input</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L7)

```lean
abbrev V100Input := BlockInput v100F16F32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.broadFiniteCounterexample](../EFT/EFT.md#decl-80f4870bbf3f2f51), [TensorCore.Regression.cancellationExample](../EFT/EFT.md#decl-b223f0d33aab3dd5), [TensorCore.Regression.r1a](Cases.md#decl-e1107d0ad35081f3), [TensorCore.Regression.r1b](Cases.md#decl-5f69a6e568d8f739), [TensorCore.Regression.r2](Cases.md#decl-35d8f7ec1d3b4b93), [TensorCore.Regression.r3](Cases.md#decl-0419be5c38ea4116), [TensorCore.Regression.scalar64DoubleRound](../EFT/ScalarEFT.md#decl-80912967825ad7ba), [TensorCore.Regression.subnormalAccumulator](../EFT/EFT.md#decl-5abbb5145c17d893), [TensorCore.Regression.supportOverflow](../EFT/EFT.md#decl-5b2dcd48a837249a)

</details>

</details>

<a id="decl-e1107d0ad35081f3"></a>

<details>
<summary><code>TensorCore.Regression.r1a</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L9)

```lean
def r1a : V100Input := ⟨[(0x3e00, 0x3e00), (0x1000, 0x0c00),
  (0x1000, 0x0c00), (0, 0)], 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.premature_normalization_detected](../Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.Regression.r1_equal_ideal](Cases.md#decl-268c5214225a8657), [TensorCore.Regression.r1_equal_product_values](Cases.md#decl-a77fdb2904fd7d75), [TensorCore.Regression.r1_factorization_changes_output](Cases.md#decl-3b1ab9cc47cd7125), [TensorCore.Regression.r1_first_output](Cases.md#decl-16960547aa45240b), [TensorCore.Regression.r1a_trace](Cases.md#decl-603c1bb56fa4a12b)

</details>

</details>

<a id="decl-5f69a6e568d8f739"></a>

<details>
<summary><code>TensorCore.Regression.r1b</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L11)

```lean
def r1b : V100Input := ⟨[(0x3c00, 0x4080), (0x1000, 0x0c00),
  (0x1000, 0x0c00), (0, 0)], 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.Controls.ieee_alignment_detected](../Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.Regression.r1_equal_ideal](Cases.md#decl-268c5214225a8657), [TensorCore.Regression.r1_equal_product_values](Cases.md#decl-a77fdb2904fd7d75), [TensorCore.Regression.r1_factorization_changes_output](Cases.md#decl-3b1ab9cc47cd7125), [TensorCore.Regression.r1_second_output](Cases.md#decl-9c6bafbcc319e9e9), [TensorCore.Regression.r1b_trace](Cases.md#decl-8231a2638d7ee001)

</details>

</details>

<a id="decl-35d8f7ec1d3b4b93"></a>

<details>
<summary><code>TensorCore.Regression.r2</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L13)

```lean
def r2 : V100Input := ⟨[(0x3e00, 0x3e00), (0x3c01, 0x3001),
  (0x3c01, 0x3001), (0x3c00, 0x3000)], 0x3e000000⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.r2_correction_unchanged](Cases.md#decl-2dfb188506a87c9a), [TensorCore.Regression.r2_eft](../EFT/EFT.md#decl-d690dacbfcf7c018), [TensorCore.Regression.r2_trace](Cases.md#decl-bd812c9c48613529)

</details>

</details>

<a id="decl-0419be5c38ea4116"></a>

<details>
<summary><code>TensorCore.Regression.r3</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L15)

```lean
def r3 : V100Input := ⟨List.replicate 4 (0x3e00, 0x3d00), 0x3f7fffff⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.V100Input](Cases.md#decl-909afd874533ccae), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

<details>
<summary>Used by</summary>

[TensorCore.Regression.BoundedEFT.consolidation_branches](../EFT/BoundedEFT.md#decl-7ab8f7f39dc32a3e), [TensorCore.Regression.algorithm1_cases](../EFT/Flowback.md#decl-a60fb69ed62b3b2b), [TensorCore.Regression.encoded_eft_branches](../EFT/EncodedEFT.md#decl-5458dc9dc7e0d9ae), [TensorCore.Regression.r3_eft](../EFT/EFT.md#decl-1bb37a5fcad699a9), [TensorCore.Regression.r3_trace](Cases.md#decl-cc0eab369e2b2bd7), [TensorCore.Regression.scalar_generic_invalid_format_rejects](../EFT/ScalarEFT.md#decl-f7a094e3217d8fda), [TensorCore.Regression.scalar_public_r3](../EFT/EFT.md#decl-deb2ed8170b801e3), [TensorCore.Regression.twoBlockCorrection](Composition.md#decl-ce09e036dcdb2b94), [TensorCore.Regression.twoBlockSummary](Composition.md#decl-27d6915f955ce3fa), [TensorCore.Regression.v100_instruction_single_group](Instruction.md#decl-47a66c36f1e33146)

</details>

</details>

<a id="decl-cbc8908708a1e1bf"></a>

<details>
<summary><code>TensorCore.Regression.Snapshot</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L18)

```lean
/-- Proof-free projection: traces come exclusively from the evaluator. c is term zero. -/
structure Snapshot where
  bits : ℕ
  eta : Option ℤ
  qExponent : ℤ
  rawScales : List ℤ
  coefficients : List ℤ
  ideal : ℚ
  accumulator : ℚ
  alignmentResiduals : List ℚ
  outputResidual : ℚ
  residual : ℚ
  correctedBits : Option ℕ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.predicate_rejected](../EFT/EFT.md#decl-bf8ce5f4bd10756f), [TensorCore.Regression.r1a_trace](Cases.md#decl-603c1bb56fa4a12b), [TensorCore.Regression.r1b_trace](Cases.md#decl-8231a2638d7ee001), [TensorCore.Regression.r2_trace](Cases.md#decl-bd812c9c48613529), [TensorCore.Regression.r3_trace](Cases.md#decl-cc0eab369e2b2bd7), [TensorCore.Regression.snapshot](Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.subnormal_accumulator_rejected](../EFT/EFT.md#decl-4c5672a5730106f4)

</details>

</details>

<a id="decl-1cfadf5c18c42fc5"></a>

<details>
<summary><code>TensorCore.Regression.snapshot</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L32)

```lean
def snapshot {p : Profile} (x : BlockInput p) : Except ModelError Snapshot := do
  let t ← evalBlock x
  return ⟨t.output.bits.toNat, t.block.eta, t.block.quantumExponent,
    t.block.products.map (fun (a, b) => (rawMul a b).rawScale),
    t.block.coefficients, t.block.exactDot, t.block.accumulator,
    t.block.alignmentResiduals, t.outputResidual, t.residual,
    t.corrected.map BitVec.toNat⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](../../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.outputResidual](../../TC/Block.md#decl-d1c97ba3515d5cad), [TensorCore.BlockTrace.residual](../../TC/Block.md#decl-29503c8290420b97), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../../TC/Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.alignmentResiduals](../../TC/Block.md#decl-36e297929b24e234), [TensorCore.PreparedBlock.coefficients](../../TC/Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](../../TC/Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.exactDot](../../TC/Block.md#decl-32d061749cae163e), [TensorCore.PreparedBlock.quantumExponent](../../TC/Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.Regression.Snapshot](Cases.md#decl-cbc8908708a1e1bf), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

<details>
<summary>Used by</summary>

[TensorCore.Regression.predicate_rejected](../EFT/EFT.md#decl-bf8ce5f4bd10756f), [TensorCore.Regression.r1_equal_product_values](Cases.md#decl-a77fdb2904fd7d75), [TensorCore.Regression.r1a_trace](Cases.md#decl-603c1bb56fa4a12b), [TensorCore.Regression.r1b_trace](Cases.md#decl-8231a2638d7ee001), [TensorCore.Regression.r2_trace](Cases.md#decl-bd812c9c48613529), [TensorCore.Regression.r3_trace](Cases.md#decl-cc0eab369e2b2bd7), [TensorCore.Regression.subnormal_accumulator_rejected](../EFT/EFT.md#decl-4c5672a5730106f4)

</details>

</details>

<a id="decl-a837d7435701ef2b"></a>

<details>
<summary><code>TensorCore.Regression.outputBits</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L40)

```lean
def outputBits {p : Profile} (x : BlockInput p) : Except ModelError ℕ :=
  (evalBlock x).map fun t => t.output.bits.toNat
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Finite32](../../Numerics/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58)

<details>
<summary>Used by</summary>

[TensorCore.Regression.below_threshold_monotone](Monotonicity.md#decl-e4f4d875391e40c8), [TensorCore.Regression.cancellation_eft](../EFT/EFT.md#decl-6b77eba48adde1d2), [TensorCore.Regression.nonfinite_rejected](Cases.md#decl-082e7286ba370e3e), [TensorCore.Regression.predicate_rejected](../EFT/EFT.md#decl-bf8ce5f4bd10756f), [TensorCore.Regression.r1_factorization_changes_output](Cases.md#decl-3b1ab9cc47cd7125), [TensorCore.Regression.r1_first_output](Cases.md#decl-16960547aa45240b), [TensorCore.Regression.r1_second_output](Cases.md#decl-9c6bafbcc319e9e9), [TensorCore.Regression.range_extrema_k5](Monotonicity.md#decl-459b27be7be5d321), [TensorCore.Regression.range_witnesses](Monotonicity.md#decl-3051dcc3ac0e7fe4), [TensorCore.Regression.subnormal_accumulator](Cases.md#decl-dda597d7fa9ce35d), [TensorCore.Regression.subnormal_accumulator_rejected](../EFT/EFT.md#decl-4c5672a5730106f4), [TensorCore.Regression.subnormal_multiplicand](Cases.md#decl-d8e79bf46e323fb0), [TensorCore.Regression.table_iii_witnesses](Monotonicity.md#decl-e962265e5ad3d55f), [TensorCore.Regression.v100_instruction_single_group](Instruction.md#decl-47a66c36f1e33146), [TensorCore.Regression.v100_nonmonotonicity_witness](Cases.md#decl-151391338d0d6284), [TensorCore.Regression.wrong_shape_rejected](Cases.md#decl-ec03e234a512bad1), [TensorCore.Regression.zero_block](Cases.md#decl-1a1976da8802c85b)

</details>

</details>

<a id="decl-268c5214225a8657"></a>

<details>
<summary><code>TensorCore.Regression.r1_equal_ideal</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L46)

```lean
theorem r1_equal_ideal : exactDot r1a = exactDot r1b := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Regression.r1a](Cases.md#decl-e1107d0ad35081f3), [TensorCore.Regression.r1b](Cases.md#decl-5f69a6e568d8f739), [TensorCore.exactDot](../../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a77fdb2904fd7d75"></a>

<details>
<summary><code>TensorCore.Regression.r1_equal_product_values</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L47)

```lean
theorem r1_equal_product_values :
    ((prepare r1a).map fun b => b.products.map fun (a, b) => a.value * b.value) =
    ((prepare r1b).map fun b => b.products.map fun (a, b) => a.value * b.value) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Numerics/Defs.md#decl-c988858af545448a), [TensorCore.PreparedBlock](../../TC/Block.md#decl-703939eff806d883), [TensorCore.Regression.r1a](Cases.md#decl-e1107d0ad35081f3), [TensorCore.Regression.r1b](Cases.md#decl-5f69a6e568d8f739), [TensorCore.Regression.snapshot](Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.prepare](../../TC/Block.md#decl-32c2d7273540d876), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-16960547aa45240b"></a>

<details>
<summary><code>TensorCore.Regression.r1_first_output</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L50)

```lean
theorem r1_first_output : outputBits r1a = .ok 0x40100001 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.r1a](Cases.md#decl-e1107d0ad35081f3), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9c6bafbcc319e9e9"></a>

<details>
<summary><code>TensorCore.Regression.r1_second_output</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L51)

```lean
theorem r1_second_output : outputBits r1b = .ok 0x40100000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.r1b](Cases.md#decl-5f69a6e568d8f739), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3b1ab9cc47cd7125"></a>

<details>
<summary><code>TensorCore.Regression.r1_factorization_changes_output</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L52)

```lean
theorem r1_factorization_changes_output : outputBits r1a ≠ outputBits r1b := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.r1a](Cases.md#decl-e1107d0ad35081f3), [TensorCore.Regression.r1b](Cases.md#decl-5f69a6e568d8f739), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-603c1bb56fa4a12b"></a>

<details>
<summary><code>TensorCore.Regression.r1a_trace</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L54)

```lean
theorem r1a_trace : snapshot r1a = .ok
    ⟨0x40100001, some 0, -23, [0, -23, -23, 0], [0, 18874368, 1, 1, 0],
      9437185 / 4194304, 9437185 / 4194304, [0, 0, 0, 0, 0], 0, 0,
      some 0x40100001⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.Snapshot](Cases.md#decl-cbc8908708a1e1bf), [TensorCore.Regression.r1a](Cases.md#decl-e1107d0ad35081f3), [TensorCore.Regression.snapshot](Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8231a2638d7ee001"></a>

<details>
<summary><code>TensorCore.Regression.r1b_trace</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L59)

```lean
theorem r1b_trace : snapshot r1b = .ok
    ⟨0x40100000, some 1, -22, [1, -23, -23, 0], [0, 9437184, 0, 0, 0],
      9437185 / 4194304, 9 / 4, [0, 0, 1 / 8388608, 1 / 8388608, 0],
      0, 1 / 4194304, some 0x40100001⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.Snapshot](Cases.md#decl-cbc8908708a1e1bf), [TensorCore.Regression.r1b](Cases.md#decl-5f69a6e568d8f739), [TensorCore.Regression.snapshot](Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bd812c9c48613529"></a>

<details>
<summary><code>TensorCore.Regression.r2_trace</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L64)

```lean
theorem r2_trace : snapshot r2 = .ok
    ⟨0x40300801, some 0, -23, [0, -3, -3, -3],
      [1048576, 18874368, 1050625, 1050625, 1048576],
      11536385 / 4194304, 11536385 / 4194304, [0, 0, 0, 0, 0], 0, 0,
      some 0x40300801⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.Snapshot](Cases.md#decl-cbc8908708a1e1bf), [TensorCore.Regression.r2](Cases.md#decl-35d8f7ec1d3b4b93), [TensorCore.Regression.snapshot](Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2dfb188506a87c9a"></a>

<details>
<summary><code>TensorCore.Regression.r2_correction_unchanged</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L70)

```lean
theorem r2_correction_unchanged :
    ((evalV100 r2).map fun t => (t.residual, t.corrected)) =
      .ok (0, some 0x40300801) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.corrected](../../TC/Block.md#decl-f68123201009b874), [TensorCore.BlockTrace.residual](../../TC/Block.md#decl-29503c8290420b97), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.r2](Cases.md#decl-35d8f7ec1d3b4b93), [TensorCore.evalV100](../../TC/Block.md#decl-9844fa72eb15e59b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-cc0eab369e2b2bd7"></a>

<details>
<summary><code>TensorCore.Regression.r3_trace</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L74)

```lean
theorem r3_trace : snapshot r3 = .ok
    ⟨0x4107ffff, some 0, -23, [0, 0, 0, 0],
      [8388607, 15728640, 15728640, 15728640, 15728640],
      142606335 / 16777216, 71303167 / 8388608,
      [1 / 16777216, 0, 0, 0, 0], 7 / 8388608, 15 / 16777216,
      some 0x41080000⟩ := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.Snapshot](Cases.md#decl-cbc8908708a1e1bf), [TensorCore.Regression.r3](Cases.md#decl-0419be5c38ea4116), [TensorCore.Regression.snapshot](Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-dd87c11927efb30e"></a>

<details>
<summary><code>TensorCore.Regression.r4_binade_asymmetry</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L81)

```lean
theorem r4_binade_asymmetry :
    round32 .nearestEven (1 - 3 * pow2 (-25)) = some 0x3f7ffffe := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f5b3a2f370a66b02"></a>

<details>
<summary><code>TensorCore.Regression.r4_cancellation</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L84)

```lean
theorem r4_cancellation :
    round32 .nearestEven (1 - (1 - pow2 (-24))) = some 0x33800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-055774464a138a7b"></a>

<details>
<summary><code>TensorCore.Regression.r4_signed_truncation</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L87)

```lean
theorem r4_signed_truncation :
    truncGrid (1 - 1 / 2) 0 = 0 ∧
    1 + truncGrid (-1 / 2) 0 = 1 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.truncGrid](../../Numerics/Exact.md#decl-104d085b38c6a29b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bc54899e2865dcef"></a>

<details>
<summary><code>TensorCore.Regression.r4_even_tie</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L91)

```lean
theorem r4_even_tie :
    round32 .nearestEven (1 + pow2 (-24)) = some 0x3f800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7d03f05653e1e285"></a>

<details>
<summary><code>TensorCore.Regression.r4_odd_tie</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L93)

```lean
theorem r4_odd_tie :
    round32 .nearestEven (1 + 3 * pow2 (-24)) = some 0x3f800002 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3b313daa3dfd8b27"></a>

<details>
<summary><code>TensorCore.Regression.r4_binade_carry</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L95)

```lean
theorem r4_binade_carry :
    round32 .nearestEven (2 - pow2 (-24)) = some 0x40000000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9a49c360edf3a319"></a>

<details>
<summary><code>TensorCore.Regression.r4_subnormal_boundary</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L97)

```lean
theorem r4_subnormal_boundary :
    round32 .nearestEven (pow2 (-126) - pow2 (-150)) = some 0x00800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-54a7f4f8fbe4a04d"></a>

<details>
<summary><code>TensorCore.Regression.r4_zero_tie</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L99)

```lean
theorem r4_zero_tie :
    round32 .nearestEven (pow2 (-150)) = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1edb476558a306fe"></a>

<details>
<summary><code>TensorCore.Regression.r4_negative_zero</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L101)

```lean
theorem r4_negative_zero :
    round32 .nearestEven (-pow2 (-150)) = some 0x80000000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1a1976da8802c85b"></a>

<details>
<summary><code>TensorCore.Regression.zero_block</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L104)

```lean
theorem zero_block :
    outputBits (⟨List.replicate 4 (0, 0), 0x80000000⟩ : V100Input) = .ok 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d8e79bf46e323fb0"></a>

<details>
<summary><code>TensorCore.Regression.subnormal_multiplicand</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L106)

```lean
theorem subnormal_multiplicand :
    outputBits (⟨[(1, 0x3c00), (0, 0), (0, 0), (0, 0)], 0⟩ : V100Input) =
      .ok 0x33800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-dda597d7fa9ce35d"></a>

<details>
<summary><code>TensorCore.Regression.subnormal_accumulator</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L109)

```lean
theorem subnormal_accumulator :
    outputBits (⟨List.replicate 4 (0, 0), 1⟩ : V100Input) = .ok 1 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-082e7286ba370e3e"></a>

<details>
<summary><code>TensorCore.Regression.nonfinite_rejected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L111)

```lean
theorem nonfinite_rejected :
    outputBits (⟨List.replicate 4 (0x7c00, 0), 0⟩ : V100Input) =
      .error .nonfiniteInput := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-de4d74472a6abfec"></a>

<details>
<summary><code>TensorCore.Regression.out_of_range_rejected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L115)

```lean
/-- The accepted domain remains the explicitly specified finite range. -/
theorem out_of_range_rejected :
    round32 .towardZero (maxFinite32 + 1) = none ∧
    round32 .towardZero (pow2 128) = none ∧
    round32 .nearestEven (maxFinite32 + pow2 102) = none ∧
    round32 .nearestEven (maxFinite32 + pow2 103) = none ∧
    round32 .nearestEven (-(maxFinite32 + pow2 103)) = none := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Numerics/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.maxFinite32](../../Numerics/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Numerics/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ec03e234a512bad1"></a>

<details>
<summary><code>TensorCore.Regression.wrong_shape_rejected</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L122)

```lean
theorem wrong_shape_rejected :
    outputBits (⟨[], 0⟩ : V100Input) = .error .wrongProductCount := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-151391338d0d6284"></a>

<details>
<summary><code>TensorCore.Regression.v100_nonmonotonicity_witness</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Cases.lean#L126)

```lean
/-- Revised TC-EFT III.4, one concrete V100 witness, not a universal threshold. -/
theorem v100_nonmonotonicity_witness :
    outputBits (⟨List.replicate 4 (0x0c00, 0x0c00), 0x3f800000⟩ : V100Input) = .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 4 (0x0c00, 0x0c00), 0x3f7fffff⟩ : V100Input) = .ok 0x3f800001 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
