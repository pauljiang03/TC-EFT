# TensorCore.TC.Regression.Features

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-dcc5ebcf924fd865"></a>

<details>
<summary><code>TensorCore.Regression.paddingInput</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L12)

```lean
private def paddingInput (extra : ℕ) : BlockInput (fp16Fp32Profile 4 extra) :=
  ⟨[(0x3c00, 0x3c00), (0xc00, 0xc00), (0xc00, 0xc00), (0, 0)], 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212)

<details>
<summary>Used by</summary>

[TensorCore.Regression.extra_alignment_bit_matters](Features.md#decl-2bd04552bd096078)

</details>

</details>

<a id="decl-2bd04552bd096078"></a>

<details>
<summary><code>TensorCore.Regression.extra_alignment_bit_matters</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L16)

```lean
/-- Two individually discarded half-ULP products survive one extra alignment bit. -/
theorem extra_alignment_bit_matters :
    ((evalBlock (paddingInput 0)).toOption.map fun t => t.output.bits) = some (BitVec.ofNat 32 0x3f800000) ∧
    ((evalBlock (paddingInput 1)).toOption.map fun t => t.output.bits) = some (BitVec.ofNat 32 0x3f800001) :=
  by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.Regression.paddingInput](Features.md#decl-dcc5ebcf924fd865)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f38fbd2896b80c60"></a>

<details>
<summary><code>TensorCore.Regression.onesBlock</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L21)

```lean
private def onesBlock (K extra : ℕ) (floor : Option ℤ) :
    BlockInput (fp16Fp32Profile K extra floor) := ⟨List.replicate K (0x3c00, 0x3c00), 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212)

<details>
<summary>Used by</summary>

[TensorCore.Regression.canonical_profile_results](Features.md#decl-3fccaf18bee4a287), [TensorCore.Regression.machine_width_changes_result](Features.md#decl-40bf2a8b421b9a65)

</details>

</details>

<a id="decl-3fccaf18bee4a287"></a>

<details>
<summary><code>TensorCore.Regression.canonical_profile_results</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L24)

```lean
theorem canonical_profile_results :
    ((evalBlock (onesBlock 8 1 (some (-132)))).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0x41000000) ∧
    ((evalBlock (onesBlock 16 2 (some (-133)))).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0x41800000) ∧
    ((evalBlock (onesBlock 37 9 none)).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0x42140000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.Regression.onesBlock](Features.md#decl-f38fbd2896b80c60)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-63bc25b56c070053"></a>

<details>
<summary><code>TensorCore.Regression.signed_capacity_prefix</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L32)

```lean
theorem signed_capacity_prefix :
    (machineAccumulate 8 0 [127, 1, -1]).toInt = 127 ∧
    (machineAccumulate 8 0 [127, 1]).toInt = -128 ∧
    (machineAccumulate 9 0 [127, 1]).toInt = 128 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.machineAccumulate](../Accumulator.md#decl-5ea736d0760d39b4)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-40bf2a8b421b9a65"></a>

<details>
<summary><code>TensorCore.Regression.machine_width_changes_result</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L38)

```lean
/-- An undersized signed accumulator can change the returned FP32 encoding. -/
theorem machine_width_changes_result :
    ((evalBlockMachine 26 (onesBlock 4 0 none)).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0xc0800000) ∧
    ((evalBlockMachine 29 (onesBlock 4 0 none)).toOption.map fun t => t.output.bits) =
      some (BitVec.ofNat 32 0x40800000) := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.evalBlockMachine](../Accumulator.md#decl-ab9031f1fdf12cee), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.Regression.onesBlock](Features.md#decl-f38fbd2896b80c60)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-bcc31661cab7eed7"></a>

<details>
<summary><code>TensorCore.Regression.padding_range_boundary</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L46)

```lean
/-- With enough alignment precision, the finite-domain guard sees maxFinite32 + 1.
This is a reference-domain distinction, not a claim about hardware overflow. -/
theorem padding_range_boundary :
    let x0 : BlockInput (fp16Fp32Profile 1 0) := ⟨[(0x3c00, 0x3c00)], 0x7f7fffff⟩
    let x104 : BlockInput (fp16Fp32Profile 1 104) := ⟨[(0x3c00, 0x3c00)], 0x7f7fffff⟩
    ((evalBlock x0).toOption.map fun t => t.output.bits) = some (BitVec.ofNat 32 0x7f7fffff) ∧
    evalBlock x104 = .error .accumulatorOutOfRange := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](../Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e27f31fdaaf23f2c"></a>

<details>
<summary><code>TensorCore.Regression.source_padding_boundary</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/Features.lean#L54)

```lean
/-- A maximum-scale FP16 product with minimum subnormal c needs the extra bit
between 155 and 156 to retain c during alignment. Output may still discard c. -/
theorem source_padding_boundary :
    let x155 : BlockInput (fp16Fp32Profile 1 155) := ⟨[(0x7800, 0x7800)], 1⟩
    let x156 : BlockInput (fp16Fp32Profile 1 156) := ⟨[(0x7800, 0x7800)], 1⟩
    ((prepare x155).map fun b => b.exactDot - b.accumulator) = some (pow2 (-149)) ∧
    ((prepare x156).map fun b => b.exactDot - b.accumulator) = some 0 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.PreparedBlock](../Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](../Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.exactDot](../Block.md#decl-32d061749cae163e), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](../Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
