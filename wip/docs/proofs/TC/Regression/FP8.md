> Archived proof page from `050b50734a9cc9cb4fe6c229b676042874c87f79`. Links refer to that revision.

# TensorCore.TC.Regression.FP8

[Index](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-0b7a950b2e31a1ef"></a>

<details>
<summary><code>TensorCore.Regression.l40sE4M3Row</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L12)

```lean
def l40sE4M3Row : List (BitVec 8 × BitVec 8) :=
  [(0x37, 0x31), (0x38, 0xb2), (0xaa, 0x2d), (0x3b, 0x29), (0xb3, 0xbf), (0x2a, 0x2f), (0x38, 0xbc), (0x3e, 0xb9), (0x36, 0x1b), (0x35, 0xb3), (0xb8, 0xb5), (0x2b, 0x40), (0x0f, 0x87), (0x29, 0x41), (0x38, 0x21), (0x35, 0xaa), (0xb8, 0xb7), (0x37, 0x3f), (0x03, 0xb2), (0xba, 0x31), (0xae, 0xad), (0xa6, 0x9d), (0x3a, 0xb8), (0x3d, 0x3a), (0x92, 0x3d), (0x26, 0x3b), (0xb0, 0x9b), (0xaf, 0x86), (0xb3, 0xbc), (0x33, 0xac), (0x42, 0x12), (0x2d, 0x83)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.l40s_e4m3_group_order](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-e82ac8c050018571), [TensorCore.Regression.l40s_e4m3_published_row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5a82486ca62db36a)

</details>

</details>

<a id="decl-5a82486ca62db36a"></a>

<details>
<summary><code>TensorCore.Regression.l40s_e4m3_published_row</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L15)

```lean
theorem l40s_e4m3_published_row :
    l40sFP8Bits .e4m3 .source13 l40sE4M3Row 0x3e93ca5a = some 0x40827800 ∧
    l40sFP8Bits .e4m3 .paper l40sE4M3Row 0x3e93ca5a = some 0x40827b00 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.l40sE4M3Row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-0b7a950b2e31a1ef), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e82ac8c050018571"></a>

<details>
<summary><code>TensorCore.Regression.l40s_e4m3_group_order</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L20)

```lean
theorem l40s_e4m3_group_order :
    l40sFP8Bits .e4m3 .source13 (l40sE4M3Row.drop 16 ++ l40sE4M3Row.take 16)
      0x3e93ca5a = some 0x40827c00 ∧
    (0x40827800 : F32) ≠ 0x40827c00 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.l40sE4M3Row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-0b7a950b2e31a1ef), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1f34f9b6dfc285e8"></a>

<details>
<summary><code>TensorCore.Regression.l40sE5M2Row</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L25)

```lean
def l40sE5M2Row : List (BitVec 8 × BitVec 8) :=
  [(0x3b, 0x38), (0x3c, 0xb9), (0xb5, 0x36), (0x3d, 0x34), (0xb9, 0xbf), (0x35, 0x37), (0x3c, 0xbe), (0x3f, 0xbc), (0x3b, 0x2d), (0x3a, 0xb9), (0xbc, 0xba), (0x35, 0x40), (0x27, 0xa3), (0x34, 0x40), (0x3c, 0x30), (0x3a, 0xb5), (0xbc, 0xbb), (0x3b, 0x3f), (0x1e, 0xb9), (0xbd, 0x38), (0xb7, 0xb6), (0xb3, 0xae), (0x3d, 0xbc), (0x3e, 0x3d), (0xa9, 0x3e), (0x33, 0x3d), (0xb8, 0xad), (0xb7, 0xa2), (0xb9, 0xbe), (0x39, 0xb6), (0x41, 0x29), (0x36, 0x9e)]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.l40s_e5m2_group_order](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-321185f5fa7cfdba), [TensorCore.Regression.l40s_e5m2_published_row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-3f757599746339b2)

</details>

</details>

<a id="decl-3f757599746339b2"></a>

<details>
<summary><code>TensorCore.Regression.l40s_e5m2_published_row</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L28)

```lean
theorem l40s_e5m2_published_row :
    l40sFP8Bits .e5m2 .source13 l40sE5M2Row 0x3f503bf0 = some 0x4073ec00 ∧
    l40sFP8Bits .e5m2 .paper l40sE5M2Row 0x3f503bf0 = some 0x4073ec00 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.l40sE5M2Row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-1f34f9b6dfc285e8), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-321185f5fa7cfdba"></a>

<details>
<summary><code>TensorCore.Regression.l40s_e5m2_group_order</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L33)

```lean
theorem l40s_e5m2_group_order :
    l40sFP8Bits .e5m2 .source13 (l40sE5M2Row.drop 16 ++ l40sE5M2Row.take 16)
      0x3f503bf0 = some 0x4073f000 ∧
    (0x4073ec00 : F32) ≠ 0x4073f000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.l40sE5M2Row](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-1f34f9b6dfc285e8), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-946dbd9d54f6390b"></a>

<details>
<summary><code>TensorCore.Regression.fp8PrecisionWitness</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L40)

```lean
/-- Three nonzero products suffice: the last group sums to 2 + 2^-13.
Its alignment retains the low bit; normalized 13-fraction-bit truncation loses it. -/
def fp8PrecisionWitness : List (BitVec 8 × BitVec 8) :=
  List.replicate 16 (0, 0) ++ [(0x38, 0x38), (0x38, 0x38), (0x08, 0x04)] ++
    List.replicate 13 (0, 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8_normalized_precision_discrepancy](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-cb21b0591273445d)

</details>

</details>

<a id="decl-cb21b0591273445d"></a>

<details>
<summary><code>TensorCore.Regression.fp8_normalized_precision_discrepancy</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L44)

```lean
theorem fp8_normalized_precision_discrepancy :
    l40sFP8Ideal .e4m3 fp8PrecisionWitness 0 = some (2 + pow2 (-13)) ∧
    l40sFP8Bits .e4m3 .paper fp8PrecisionWitness 0 = some 0x40000200 ∧
    l40sFP8Bits .e4m3 .source13 fp8PrecisionWitness 0 = some 0x40000000 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.fp8PrecisionWitness](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-946dbd9d54f6390b), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.l40sFP8Ideal](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-2edcb7111d5346e0), [TensorCore.pow2](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8e88f76e54239b4f"></a>

<details>
<summary><code>TensorCore.Regression.fp8_e4m3_top_exponent</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L51)

```lean
/-- E4M3 maximum finite value 448, including its finite top exponent. -/
theorem fp8_e4m3_top_exponent :
    l40sFP8Bits .e4m3 .source13 ([(0x7e, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x43e00000 ∧
    l40sFP8Bits .e4m3 .paper ([(0x7e, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x43e00000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.OperandEncoding.Word](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-0e24771a882ef6eb), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b1bb8f3ca4418b7a"></a>

<details>
<summary><code>TensorCore.Regression.fp8_subnormal_preserved</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L57)

```lean
theorem fp8_subnormal_preserved :
    l40sFP8Bits .e4m3 .source13 ([(1, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x3b000000 ∧
    l40sFP8Bits .e5m2 .source13 ([(1, 0x3c)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x37800000 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.OperandEncoding.Word](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-0e24771a882ef6eb), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9799addbb566d2bf"></a>

<details>
<summary><code>TensorCore.Regression.fp8_zero_and_rejections</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L63)

```lean
theorem fp8_zero_and_rejections :
    l40sFP8Bits .e4m3 .source13 (List.replicate 32 (0, 0)) 0x80000000 = some 0 ∧
    runL40SFP8 .e4m3 .source13 (List.replicate 31 (0, 0)) 0 = .error .wrongProductCount ∧
    runL40SFP8 .e4m3 .source13 ([(0x7f, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      .error .nonfiniteOrInvalidEncoding ∧
    runL40SFP8 .e5m2 .source13 (List.replicate 16 (0, 0) ++ [(0x7c, 0x3c)] ++
      List.replicate 15 (0, 0)) 0 = .error .nonfiniteOrInvalidEncoding ∧
    runL40SFP8 .e5m2 .paper (List.replicate 32 (0, 0)) 0x7f800000 =
      .error .nonfiniteOrInvalidEncoding := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.ConversionEvent](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-4715b3224a6fd37c), [TensorCore.ConversionRun](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-ed5a81cbcde403d2), [TensorCore.ConversionStage](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.Decoded](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationSpec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.L40SFP8Trace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-d69c3bd866542897), [TensorCore.LocalAccumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-a84c087ad8e27576), [TensorCore.OperandEncoding.Word](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.width](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-0e24771a882ef6eb), [TensorCore.PreparedInvocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-f9bfc73e05dc3dce), [TensorCore.classify](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.l40sFP8Bits](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-43b12a8a8cae2536), [TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.runL40SFP8](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-e991942d01778b03)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2374fcf020170b26"></a>

<details>
<summary><code>TensorCore.Regression.fp8Words</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L73)

```lean
def fp8Words (f : FP8Format) (ps : List (BitVec 8 × BitVec 8)) :
    List (f.encoding.Word × f.encoding.Word) := by cases f <;> exact ps
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Format.encoding](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7d4020de8dd132ce), [TensorCore.OperandEncoding.Word](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Format.md#decl-3024ce1c6868fc17)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.Regression.fp8_first_group_precision_absorbed](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5ab8cf23366a16c9)

</details>

</details>

<a id="decl-10b75dc919cc7909"></a>

<details>
<summary><code>TensorCore.Regression.fp8BlockObservation</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L78)

```lean
/-- (eta, alignment loss, accumulated value, conversion loss, FP32 output).
Project the actual trace so the precision witness locates the lost bit. -/
def fp8BlockObservation (f : FP8Format) (reading : FP8Reading)
    (ps : List (BitVec 8 × BitVec 8)) (c : F32) :
    Option (Option ℤ × ℚ × ℚ × ℚ × F32) :=
  (evalInvocation (p := l40sFP8Invocation f reading) ⟨fp8Words f ps, c⟩).toOption.map fun t =>
    ((t.prepared.alignedBlock 13 none true).eta, t.accumulation.alignmentLoss,
      t.accumulation.value, t.intermediate.loss, t.output.bits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionRun.loss](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-29f602efd8dc0504), [TensorCore.ConversionStage](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-819c01227290b53b), [TensorCore.InvocationError](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.LocalAccumulation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-a84c087ad8e27576), [TensorCore.PreparedBlock.eta](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedInvocation.alignedBlock](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-f7d09369ac3f398e), [TensorCore.Regression.fp8Words](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-2374fcf020170b26), [TensorCore.evalInvocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-d69509a8df45ebe4), [TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8_carry_loss_location](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-76941f28bab96ef3), [TensorCore.Regression.fp8_negative_carry_loss](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-6c159cd63c367ede), [TensorCore.Regression.fp8_paper_alignment_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-84347f748f0310f4), [TensorCore.Regression.fp8_paper_early_c_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-cd54f684b17fecf1)

</details>

</details>

<a id="decl-4ff560fd1ef23469"></a>

<details>
<summary><code>TensorCore.Regression.fp8ProbeFactors</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L86)

```lean
/-- Encoded factors for 1 and 2^-13, in both native FP8 formats. -/
def fp8ProbeFactors : FP8Format → BitVec 8 × (BitVec 8 × BitVec 8)
  | .e4m3 => (0x38, (0x08, 0x04))
  | .e5m2 => (0x3c, (0x20, 0x24))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8CarryGroup](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-73888eadcc082064), [TensorCore.Regression.fp8_paper_alignment_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-84347f748f0310f4)

</details>

</details>

<a id="decl-73888eadcc082064"></a>

<details>
<summary><code>TensorCore.Regression.fp8CarryGroup</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L90)

```lean
def fp8CarryGroup (f : FP8Format) : List (BitVec 8 × BitVec 8) :=
  let (one, small) := fp8ProbeFactors f
  [(one, one), (one, one), small] ++ List.replicate 13 (0, 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.Regression.fp8ProbeFactors](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-4ff560fd1ef23469)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp8_carry_loss_location](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-76941f28bab96ef3), [TensorCore.Regression.fp8_first_group_precision_absorbed](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-5ab8cf23366a16c9), [TensorCore.Regression.fp8_negative_carry_loss](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-6c159cd63c367ede), [TensorCore.Regression.fp8_paper_alignment_probe](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-84347f748f0310f4)

</details>

</details>

<a id="decl-76941f28bab96ef3"></a>

<details>
<summary><code>TensorCore.Regression.fp8_carry_loss_location</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L96)

```lean
/-- A carry changes the normalized grid from 2^-13 to 2^-12. Alignment loses
nothing; only the source13 conversion drops the low bit. This holds for E5M2 too. -/
theorem fp8_carry_loss_location (f : FP8Format) :
    fp8BlockObservation f .paper (fp8CarryGroup f) 0 =
      some (some 0, 0, 2 + pow2 (-13), 0, 0x40000200) ∧
    fp8BlockObservation f .source13 (fp8CarryGroup f) 0 =
      some (some 0, 0, 2 + pow2 (-13), pow2 (-13), 0x40000000) := by
  cases f <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.Regression.fp8CarryGroup](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-73888eadcc082064), [TensorCore.pow2](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6c159cd63c367ede"></a>

<details>
<summary><code>TensorCore.Regression.fp8_negative_carry_loss</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L104)

```lean
/-- Negative carry witnesses distinguish signed truncation from rounding down. -/
theorem fp8_negative_carry_loss (f : FP8Format) :
    let ps := (fp8CarryGroup f).map fun (a, b) => (a ^^^ 0x80, b)
    fp8BlockObservation f .paper ps 0 =
      some (some 0, 0, -(2 + pow2 (-13)), 0, 0xc0000200) ∧
    fp8BlockObservation f .source13 ps 0 =
      some (some 0, 0, -(2 + pow2 (-13)), -pow2 (-13), 0xc0000000) := by
  cases f <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.Regression.fp8CarryGroup](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-73888eadcc082064), [TensorCore.pow2](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-84347f748f0310f4"></a>

<details>
<summary><code>TensorCore.Regression.fp8_paper_alignment_probe</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L116)

```lean
/-- Section 4.1.4's reported endpoint: p1=1, p2=p3=2^-13, c=0.
The displayed stopping expression in the prose has inconsistent indices; this
checks its stated numerical endpoint, not an inferred correction of that expression.
With no carry beyond eta, this probe cannot choose the final precision. -/
theorem fp8_paper_alignment_probe (f : FP8Format) (reading : FP8Reading) :
    let (one, small) := fp8ProbeFactors f
    fp8BlockObservation f reading
      ([(one, one), small, small] ++ List.replicate 13 (0, 0)) 0 =
      some (some 0, 0, 1 + pow2 (-12), 0, 0x3f800800) := by
  cases f <;> cases reading <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.Regression.fp8CarryGroup](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-73888eadcc082064), [TensorCore.Regression.fp8ProbeFactors](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-4ff560fd1ef23469), [TensorCore.pow2](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-cd54f684b17fecf1"></a>

<details>
<summary><code>TensorCore.Regression.fp8_paper_early_c_probe</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L125)

```lean
/-- Section 4.1.4's early-c probe also agrees: c=1, p1=p2=2^-14.
The loss already occurs in alignment and says nothing about normalized precision. -/
theorem fp8_paper_early_c_probe (reading : FP8Reading) :
    fp8BlockObservation .e4m3 reading
      ([(0x08, 0x02), (0x08, 0x02)] ++ List.replicate 14 (0, 0)) 0x3f800000 =
      some (some 0, pow2 (-13), 1, 0, 0x3f800000) := by
  cases reading <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.Regression.fp8BlockObservation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-10b75dc919cc7909), [TensorCore.pow2](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5ab8cf23366a16c9"></a>

<details>
<summary><code>TensorCore.Regression.fp8_first_group_precision_absorbed</code></summary>

[Lean source](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/TensorCore/TC/Regression/FP8.lean#L134)

```lean
/-- Moving the carry witness to the first group exposes distinct intermediate
words but the next group's alignment erases the distinction. Final archive bits
alone therefore do not identify every intermediate conversion boundary. -/
theorem fp8_first_group_precision_absorbed (f : FP8Format) :
    let ps := fp8CarryGroup f ++ List.replicate 16 (0, 0)
    ((runL40SFP8 f .paper (fp8Words f ps) 0).toOption.map fun t =>
      (t.first.output.bits, t.second.output.bits)) = some (0x40000200, 0x40000000) ∧
    ((runL40SFP8 f .source13 (fp8Words f ps) 0).toOption.map fun t =>
      (t.first.output.bits, t.second.output.bits)) = some (0x40000000, 0x40000000) := by
  cases f <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.ConversionStage](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.F32](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.FP8Format](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-78e3fc6efd64066b), [TensorCore.FP8Reading](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-7f168fd32dc7bd16), [TensorCore.FiniteBinary](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationSpec](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Invocation.md#decl-b63a56d7a7c92388), [TensorCore.L40SFP8Trace](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-d69c3bd866542897), [TensorCore.Regression.fp8CarryGroup](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-73888eadcc082064), [TensorCore.Regression.fp8Words](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/Regression/FP8.md#decl-2374fcf020170b26), [TensorCore.l40sFP8Invocation](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Defs.md#decl-aaf89d9b9aca6e42), [TensorCore.runL40SFP8](https://github.com/pauljiang03/tensor-core-arithmetic/blob/050b50734a9cc9cb4fe6c229b676042874c87f79/docs/proofs/TC/FP8Program.md#decl-e991942d01778b03)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
