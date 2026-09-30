# TensorCoreTests.TC.Monotonicity

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-307d9a4f02913cf8"></a>

<details>
<summary><code>TensorCore.halfDecoded</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L9)

```lean
def halfDecoded (e : ℤ) : Decoded := ⟨1024, e, 10⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350)

<details>
<summary>Used by</summary>

[TensorCore.Regression.flowback_without_increase](../EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.v100_products_not_monotone](../EFT/Flowback.md#decl-725fd4d619d07b0f), [TensorCore.Regression.v100_witness_flowback](../EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.nonmonotone_ampere_family](Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_hopper_family](Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_range_ampere_family](Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_hopper_family](Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](Monotonicity.md#decl-06e754610d570873)

</details>

</details>

<a id="decl-06e754610d570873"></a>

<details>
<summary><code>TensorCore.nonmonotone_v100_family</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L12)

```lean
/-- V100 family: any `K < 2^24` products `2^-12 · 2^-12`. Non-monotone exactly when `K ≥ 3`. -/
theorem nonmonotone_v100_family (K : ℕ) (hK : K < 2 ^ 24) :
    ∃ t t' : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0c00), 0x3f800000⟩ :
        BlockInput (fp16Fp32Profile K 0 none)) = .ok t ∧
      evalBlock (⟨List.replicate K (0x0c00, 0x0c00), 0x3f7fffff⟩ :
        BlockInput (fp16Fp32Profile K 0 none)) = .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ 0 ≤ K) :=
  nonmonotone_encoded K 0 none (by simp) _ _ (halfDecoded (-12)) (halfDecoded (-12))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK
```

**Supporting proofs:** [TensorCore.nonmonotone_encoded](../../TC/Monotonicity.md#decl-7c6c5b1d9751b04f)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.classify](../../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16](../../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.halfDecoded](Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-35f26035cb0e19a5"></a>

<details>
<summary><code>TensorCore.nonmonotone_ampere_family</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L26)

```lean
/-- Ampere family: one extra alignment bit, floor `−132`, products `2^-12 · 2^-13`.
Non-monotone exactly when `K ≥ 6`. -/
theorem nonmonotone_ampere_family (K : ℕ) (hK : K < 2 ^ 25) :
    ∃ t t' : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0800), 0x3f800000⟩ :
        BlockInput (fp16Fp32Profile K 1 (some (-132)))) = .ok t ∧
      evalBlock (⟨List.replicate K (0x0c00, 0x0800), 0x3f7fffff⟩ :
        BlockInput (fp16Fp32Profile K 1 (some (-132)))) = .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ 1 ≤ K) :=
  nonmonotone_encoded K 1 (some (-132)) (by simp) _ _ (halfDecoded (-12)) (halfDecoded (-13))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0800).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK
```

**Supporting proofs:** [TensorCore.nonmonotone_encoded](../../TC/Monotonicity.md#decl-7c6c5b1d9751b04f)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.classify](../../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16](../../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.halfDecoded](Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e74e75c57aaf1e71"></a>

<details>
<summary><code>TensorCore.nonmonotone_hopper_family</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L40)

```lean
/-- Hopper family: two extra alignment bits, floor `−133`, products `2^-12 · 2^-14`.
Non-monotone exactly when `K ≥ 12`. -/
theorem nonmonotone_hopper_family (K : ℕ) (hK : K < 2 ^ 26) :
    ∃ t t' : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0400), 0x3f800000⟩ :
        BlockInput (fp16Fp32Profile K 2 (some (-133)))) = .ok t ∧
      evalBlock (⟨List.replicate K (0x0c00, 0x0400), 0x3f7fffff⟩ :
        BlockInput (fp16Fp32Profile K 2 (some (-133)))) = .ok t' ∧
      t.output.value = 1 ∧ (1 < t'.output.value ↔ 3 * 2 ^ 2 ≤ K) :=
  nonmonotone_encoded K 2 (some (-133)) (by simp) _ _ (halfDecoded (-12)) (halfDecoded (-14))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0400).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK
```

**Supporting proofs:** [TensorCore.nonmonotone_encoded](../../TC/Monotonicity.md#decl-7c6c5b1d9751b04f)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.classify](../../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16](../../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.halfDecoded](Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-28d0c042c0f25900"></a>

<details>
<summary><code>TensorCore.nonmonotone_range_v100_family</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L55)

```lean
/-- V100 family, Theorem III.5: with `c_j = 3f800000 − j`, the output exceeds `1` exactly for
`1 ≤ j ≤ min(2^23, K − 2)`, equals `1 + 2^-23·⌊(K − j)/2⌋` whenever `j ≤ K`, and never
exceeds the `j = 1` value. -/
theorem nonmonotone_range_v100_family (K j : ℕ) (hK : K < 2 ^ 24) (hj1 : 1 ≤ j)
    (hj2 : j ≤ 2 ^ 23) :
    ∃ t : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0c00), BitVec.ofNat 32 (0x3f800000 - j)⟩ :
        BlockInput (fp16Fp32Profile K 0 none)) = .ok t ∧
      (1 < t.output.value ↔ j ≤ min (2 ^ 23) (K / 2 ^ 0 - 2)) ∧
      (j * 2 ^ 0 ≤ K →
        t.output.value = 1 + (((K - j * 2 ^ 0) / 2 ^ (0 + 1) : ℕ) : ℚ) * pow2 (-23)) ∧
      t.output.value ≤ 1 + (((K - 2 ^ 0) / 2 ^ (0 + 1) : ℕ) : ℚ) * pow2 (-23) :=
  nonmonotone_range_encoded K 0 j none (by simp) _ _ (halfDecoded (-12)) (halfDecoded (-12))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK hj1 hj2
```

**Supporting proofs:** [TensorCore.nonmonotone_range_encoded](../../TC/MonotonicityRange.md#decl-25e9827b84766b38)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32.value](../../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.classify](../../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16](../../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.halfDecoded](Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8cba369caaf2fd69"></a>

<details>
<summary><code>TensorCore.nonmonotone_range_ampere_family</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L70)

```lean
/-- Ampere family, Theorem III.5: witnesses for `1 ≤ j ≤ min(2^23, ⌊K/2⌋ − 2)`. -/
theorem nonmonotone_range_ampere_family (K j : ℕ) (hK : K < 2 ^ 25) (hj1 : 1 ≤ j)
    (hj2 : j ≤ 2 ^ 23) :
    ∃ t : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0800), BitVec.ofNat 32 (0x3f800000 - j)⟩ :
        BlockInput (fp16Fp32Profile K 1 (some (-132)))) = .ok t ∧
      (1 < t.output.value ↔ j ≤ min (2 ^ 23) (K / 2 ^ 1 - 2)) ∧
      (j * 2 ^ 1 ≤ K →
        t.output.value = 1 + (((K - j * 2 ^ 1) / 2 ^ (1 + 1) : ℕ) : ℚ) * pow2 (-23)) ∧
      t.output.value ≤ 1 + (((K - 2 ^ 1) / 2 ^ (1 + 1) : ℕ) : ℚ) * pow2 (-23) :=
  nonmonotone_range_encoded K 1 j (some (-132)) (by simp) _ _ (halfDecoded (-12))
    (halfDecoded (-13))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0800).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK hj1 hj2
```

**Supporting proofs:** [TensorCore.nonmonotone_range_encoded](../../TC/MonotonicityRange.md#decl-25e9827b84766b38)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32.value](../../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.classify](../../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16](../../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.halfDecoded](Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-35b986b32bcab844"></a>

<details>
<summary><code>TensorCore.nonmonotone_range_hopper_family</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L86)

```lean
/-- Hopper family, Theorem III.5: witnesses for `1 ≤ j ≤ min(2^23, ⌊K/4⌋ − 2)`. -/
theorem nonmonotone_range_hopper_family (K j : ℕ) (hK : K < 2 ^ 26) (hj1 : 1 ≤ j)
    (hj2 : j ≤ 2 ^ 23) :
    ∃ t : BlockTrace,
      evalBlock (⟨List.replicate K (0x0c00, 0x0400), BitVec.ofNat 32 (0x3f800000 - j)⟩ :
        BlockInput (fp16Fp32Profile K 2 (some (-133)))) = .ok t ∧
      (1 < t.output.value ↔ j ≤ min (2 ^ 23) (K / 2 ^ 2 - 2)) ∧
      (j * 2 ^ 2 ≤ K →
        t.output.value = 1 + (((K - j * 2 ^ 2) / 2 ^ (2 + 1) : ℕ) : ℚ) * pow2 (-23)) ∧
      t.output.value ≤ 1 + (((K - 2 ^ 2) / 2 ^ (2 + 1) : ℕ) : ℚ) * pow2 (-23) :=
  nonmonotone_range_encoded K 2 j (some (-133)) (by simp) _ _ (halfDecoded (-12))
    (halfDecoded (-14))
    (by show (classify fp16 0x0c00).finite = some _; decide +kernel)
    (by show (classify fp16 0x0400).finite = some _; decide +kernel)
    (by decide +kernel) (by decide +kernel) hK hj1 hj2
```

**Supporting proofs:** [TensorCore.nonmonotone_range_encoded](../../TC/MonotonicityRange.md#decl-25e9827b84766b38)

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../../Numerics/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Numerics/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32.value](../../Numerics/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../../Numerics/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Numerics/RawProduct.md#decl-549312d8d1563679), [TensorCore.classify](../../Numerics/Encoding.md#decl-793c375a3325b7e3), [TensorCore.evalBlock](../../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16](../../Numerics/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.halfDecoded](Monotonicity.md#decl-307d9a4f02913cf8), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Numerics/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e962265e5ad3d55f"></a>

<details>
<summary><code>TensorCore.Regression.table_iii_witnesses</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L108)

```lean
/-- TC-EFT Table III: the source block widths `K = 4, 8, 16` all exceed `3·2^p`, and
decreasing the accumulator from `3f800000` to `3f7fffff` raises the output to `3f800001`. -/
theorem table_iii_witnesses :
    outputBits (⟨List.replicate 8 (0x0c00, 0x0800), 0x3f800000⟩ : BlockInput ampereF16F32) =
      .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 8 (0x0c00, 0x0800), 0x3f7fffff⟩ : BlockInput ampereF16F32) =
      .ok 0x3f800001 ∧
    outputBits (⟨List.replicate 16 (0x0c00, 0x0400), 0x3f800000⟩ : BlockInput hopperF16F32) =
      .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 16 (0x0c00, 0x0400), 0x3f7fffff⟩ : BlockInput hopperF16F32) =
      .ok 0x3f800001 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.ampereF16F32](../../TC/CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.hopperF16F32](../../TC/CanonicalDefs.md#decl-3d43fc64b9e4a784)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e4f4d875391e40c8"></a>

<details>
<summary><code>TensorCore.Regression.below_threshold_monotone</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L120)

```lean
/-- Below the threshold the perturbation is monotone: two V100 products (`K = 2 < 3`)
leave the output at `1`, and eleven Hopper products (`K = 11 < 12`) do too. -/
theorem below_threshold_monotone :
    outputBits (⟨List.replicate 2 (0x0c00, 0x0c00), 0x3f7fffff⟩ :
      BlockInput (fp16Fp32Profile 2 0 none)) = .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 11 (0x0c00, 0x0400), 0x3f7fffff⟩ :
      BlockInput (fp16Fp32Profile 11 2 (some (-133)))) = .ok 0x3f800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3051dcc3ac0e7fe4"></a>

<details>
<summary><code>TensorCore.Regression.range_witnesses</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L129)

```lean
/-- Theorem III.5 witness ranges on the source widths: `J = min(2^23, ⌊K/2^p⌋ − 2) = 2` for
V100 (`K = 4`), Ampere (`K = 8`), and Hopper (`K = 16`). `c_2 = 3f7ffffe` still raises the
output to `3f800001`; `c_3 = 3f7ffffd` does not. -/
theorem range_witnesses :
    outputBits (⟨List.replicate 4 (0x0c00, 0x0c00), 0x3f7ffffe⟩ : BlockInput v100F16F32) =
      .ok 0x3f800001 ∧
    outputBits (⟨List.replicate 4 (0x0c00, 0x0c00), 0x3f7ffffd⟩ : BlockInput v100F16F32) =
      .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 8 (0x0c00, 0x0800), 0x3f7ffffe⟩ : BlockInput ampereF16F32) =
      .ok 0x3f800001 ∧
    outputBits (⟨List.replicate 8 (0x0c00, 0x0800), 0x3f7ffffd⟩ : BlockInput ampereF16F32) =
      .ok 0x3f800000 ∧
    outputBits (⟨List.replicate 16 (0x0c00, 0x0400), 0x3f7ffffe⟩ : BlockInput hopperF16F32) =
      .ok 0x3f800001 ∧
    outputBits (⟨List.replicate 16 (0x0c00, 0x0400), 0x3f7ffffd⟩ : BlockInput hopperF16F32) =
      .ok 0x3f800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.ampereF16F32](../../TC/CanonicalDefs.md#decl-ac59b5835ffcc59f), [TensorCore.hopperF16F32](../../TC/CanonicalDefs.md#decl-3d43fc64b9e4a784), [TensorCore.v100F16F32](../../TC/Defs.md#decl-71711e48d14142e0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-459b27be7be5d321"></a>

<details>
<summary><code>TensorCore.Regression.range_extrema_k5</code></summary>

[Lean source](../../../../tests/TensorCoreTests/TC/Monotonicity.lean#L145)

```lean
/-- The paper's `K = 5`, `p = 0` example: the largest output increase `2·2^-23` occurs at
`j = 1`, the largest input decrease `3·2^-24` at `J = 3`, and `j = 4` is monotone. -/
theorem range_extrema_k5 :
    outputBits (⟨List.replicate 5 (0x0c00, 0x0c00), 0x3f7fffff⟩ :
      BlockInput (fp16Fp32Profile 5 0 none)) = .ok 0x3f800002 ∧
    outputBits (⟨List.replicate 5 (0x0c00, 0x0c00), 0x3f7ffffd⟩ :
      BlockInput (fp16Fp32Profile 5 0 none)) = .ok 0x3f800001 ∧
    outputBits (⟨List.replicate 5 (0x0c00, 0x0c00), 0x3f7ffffc⟩ :
      BlockInput (fp16Fp32Profile 5 0 none)) = .ok 0x3f800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../../Numerics/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](../../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Regression.outputBits](Cases.md#decl-a837d7435701ef2b), [TensorCore.fp16Fp32Profile](../../TC/CanonicalDefs.md#decl-00203670fbae3212)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
