# TensorCore.Gemm.Regression.Gemm

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-cd0883f1e38ef115"></a>

<details>
<summary><code>TensorCore.Regression.gemmA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L10)

```lean
def gemmA : DenseMatrix F16 2 5 :=
  #v[#v[0x3c00, 0x4000, 0x4200, 0x4400, 0x4500],
     #v[0xbc00, 0xc000, 0xc200, 0xc400, 0xc500]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.gemm_certificate_rejects](GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_rectangular](Gemm.md#decl-eede3fdd46c21165), [TensorCore.Regression.gemm_tile_layout](Gemm.md#decl-6e703ef4fc6e510e), [TensorCore.Regression.paper_gemm_rectangular](GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.Regression.scaled_rectangular](GemmExtensions.md#decl-94ac378f052b4fa8)

</details>

</details>

<a id="decl-6218aaffd17d1302"></a>

<details>
<summary><code>TensorCore.Regression.gemmB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L14)

```lean
def gemmB : DenseMatrix F16 5 3 :=
  #v[#v[0x3c00, 0x3c00, 0xbc00], #v[0x3c00, 0x4000, 0xbc00],
     #v[0x3c00, 0x4200, 0xbc00], #v[0x3c00, 0x4400, 0xbc00],
     #v[0x3c00, 0x4500, 0xbc00]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.gemm_certificate_rejects](GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_rectangular](Gemm.md#decl-eede3fdd46c21165), [TensorCore.Regression.gemm_tile_layout](Gemm.md#decl-6e703ef4fc6e510e), [TensorCore.Regression.paper_gemm_rectangular](GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.Regression.scaled_rectangular](GemmExtensions.md#decl-94ac378f052b4fa8)

</details>

</details>

<a id="decl-ab7c3d001b056c5e"></a>

<details>
<summary><code>TensorCore.Regression.gemmC</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L19)

```lean
def gemmC : DenseMatrix F32 2 3 :=
  #v[#v[0x3f800000, 0x40000000, 0x40400000], #v[0x40800000, 0x40a00000, 0x40c00000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.gemm_certificate_rejects](GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_rectangular](Gemm.md#decl-eede3fdd46c21165), [TensorCore.Regression.paper_gemm_rectangular](GemmSpecification.md#decl-a60bf69e12cce69b), [TensorCore.Regression.scaled_rectangular](GemmExtensions.md#decl-94ac378f052b4fa8)

</details>

</details>

<a id="decl-eede3fdd46c21165"></a>

<details>
<summary><code>TensorCore.Regression.gemm_rectangular</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L24)

```lean
/-- Rectangular indexing, signs, nonzero C, and all three edge dimensions need padding.
The exact integer matrix is [[16,57,-12],[-11,-50,21]]. -/
theorem gemm_rectangular :
    gemmBits .v100 gemmA gemmB gemmC =
      #v[#v[.ok 0x41800000, .ok 0x42640000, .ok 0xc1400000],
         #v[.ok 0xc1300000, .ok 0xc2480000, .ok 0x41a80000]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.gemmA](Gemm.md#decl-cd0883f1e38ef115), [TensorCore.Regression.gemmB](Gemm.md#decl-6218aaffd17d1302), [TensorCore.Regression.gemmC](Gemm.md#decl-ab7c3d001b056c5e), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0f102c9773dce5da"></a>

<details>
<summary><code>TensorCore.Regression.gemmTinyA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L29)

```lean
def gemmTinyA : DenseMatrix F16 1 17 := DenseMatrix.ofFn fun _ _ => 0x0c00
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_improves_minimal_static](GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.analysis_tolerance_certified](GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.Regression.analysis_tolerance_inconclusive](GemmAnalysis.md#decl-9f010dd9c59fddca), [TensorCore.Regression.certified_tiny](GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.gemm_architecture_rounding](Gemm.md#decl-20028f6cbef3dc31), [TensorCore.Regression.gemm_certificate_rejects](GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_certifies_all_profiles](GemmExtensions.md#decl-04b959ba551a2db5), [TensorCore.Regression.gemm_instruction_boundaries](Gemm.md#decl-060ec72439234e38), [TensorCore.Regression.paper_gemm_boundaries](GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.scaled_c_placement](GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.Regression.scaled_certificate_rejects_stages](GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](GemmExtensions.md#decl-8c37b22a932158df)

</details>

</details>

<a id="decl-b3d2db426390406e"></a>

<details>
<summary><code>TensorCore.Regression.gemmTinyB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L30)

```lean
def gemmTinyB : DenseMatrix F16 17 1 := DenseMatrix.ofFn fun _ _ => 0x0c00
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_improves_minimal_static](GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.analysis_tolerance_certified](GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.Regression.analysis_tolerance_inconclusive](GemmAnalysis.md#decl-9f010dd9c59fddca), [TensorCore.Regression.certified_tiny](GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.gemm_architecture_rounding](Gemm.md#decl-20028f6cbef3dc31), [TensorCore.Regression.gemm_certificate_rejects](GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_certifies_all_profiles](GemmExtensions.md#decl-04b959ba551a2db5), [TensorCore.Regression.gemm_instruction_boundaries](Gemm.md#decl-060ec72439234e38), [TensorCore.Regression.paper_gemm_boundaries](GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.scaled_c_placement](GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.Regression.scaled_certificate_rejects_stages](GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](GemmExtensions.md#decl-8c37b22a932158df)

</details>

</details>

<a id="decl-5924bb947ea9cb7c"></a>

<details>
<summary><code>TensorCore.Regression.gemmOne</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L31)

```lean
def gemmOne : DenseMatrix F32 1 1 := #v[#v[0x3f800000]]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.analysis_improves_minimal_static](GemmAnalysis.md#decl-d029cb1810977fd7), [TensorCore.Regression.analysis_tolerance_certified](GemmAnalysis.md#decl-7c66d2624d546e50), [TensorCore.Regression.analysis_tolerance_inconclusive](GemmAnalysis.md#decl-9f010dd9c59fddca), [TensorCore.Regression.certified_tiny](GemmExtensions.md#decl-e72450f7dbc8fe47), [TensorCore.Regression.gemm_architecture_rounding](Gemm.md#decl-20028f6cbef3dc31), [TensorCore.Regression.gemm_certificate_rejects](GemmExtensions.md#decl-36649ed141d65992), [TensorCore.Regression.gemm_certifies_all_profiles](GemmExtensions.md#decl-04b959ba551a2db5), [TensorCore.Regression.gemm_instruction_boundaries](Gemm.md#decl-060ec72439234e38), [TensorCore.Regression.paper_gemm_boundaries](GemmSpecification.md#decl-7e99f654c1b12fb7), [TensorCore.Regression.paper_gemm_instruction_order](GemmSpecification.md#decl-44dd811c9537c054), [TensorCore.Regression.scaled_c_placement](GemmExtensions.md#decl-e35d8dd7f8722081), [TensorCore.Regression.scaled_certificate_rejects_stages](GemmExtensions.md#decl-3f2241a861f287ed), [TensorCore.Regression.scaled_certifies_all_profiles](GemmExtensions.md#decl-8c37b22a932158df), [TensorCore.Regression.scaled_rejections_and_zero](GemmExtensions.md#decl-d1b81d931f9d9b7f)

</details>

</details>

<a id="decl-20028f6cbef3dc31"></a>

<details>
<summary><code>TensorCore.Regression.gemm_architecture_rounding</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L35)

```lean
/-- Seventeen nonzero products require two whole WMMA instructions. The internal
N_FMA groups remain architecture-specific; this does not replace them by one exact sum. -/
theorem gemm_architecture_rounding :
    gemmBits .v100 gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800000]] ∧
    gemmBits .ampere gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800008]] ∧
    gemmBits .hopper gemmTinyA gemmTinyB gemmOne = #v[#v[.ok 0x3f800008]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-060ec72439234e38"></a>

<details>
<summary><code>TensorCore.Regression.gemm_instruction_boundaries</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L41)

```lean
/-- Whole-instruction tail padding retains the extra zero normalization groups. -/
theorem gemm_instruction_boundaries :
    ((gemm .v100 gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = .ok [4, 4] ∧
    ((gemm .ampere gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = .ok [2, 2] ∧
    ((gemm .hopper gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = .ok [1, 1] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0d8cc5e759e48b07"></a>

<details>
<summary><code>TensorCore.Regression.gemm_empty_k</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L49)

```lean
theorem gemm_empty_k :
    gemmBits .v100 (#v[#v[]] : DenseMatrix F16 1 0) (#v[] : DenseMatrix F16 0 2)
      #v[#v[0x80000000, 0x3f800000]] = #v[#v[.ok 0x80000000, .ok 0x3f800000]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f949b3d601cf0ac9"></a>

<details>
<summary><code>TensorCore.Regression.gemm_nonfinite</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L53)

```lean
theorem gemm_nonfinite :
    gemmBits .hopper (#v[#v[0x7c00], #v[0x3c00]] : DenseMatrix F16 2 1)
      #v[#v[0x3c00]] #v[#v[0], #v[0]] =
      #v[#v[.error .nonfiniteInput], #v[.ok 0x3f800000]] ∧
    gemmBits .v100 (#v[#v[]] : DenseMatrix F16 1 0) (#v[] : DenseMatrix F16 0 1)
      #v[#v[0x7fc00000]] = #v[#v[.error .nonfiniteInput]] := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6e703ef4fc6e510e"></a>

<details>
<summary><code>TensorCore.Regression.gemm_tile_layout</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/Gemm.lean#L60)

```lean
theorem gemm_tile_layout :
    (gemmTileOperands gemmA gemmB 0 0 0).1[1][4] = 0xc500 ∧
    (gemmTileOperands gemmA gemmB 0 0 0).1[2][0] = 0 ∧
    (gemmTileOperands gemmA gemmB 0 0 0).2[4][1] = 0x4500 ∧
    (gemmTileOperands gemmA gemmB 0 0 0).2[0][3] = 0 ∧
    (gemmTileSchedule 17 19 33).length = 12 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Regression.gemmA](Gemm.md#decl-cd0883f1e38ef115), [TensorCore.Regression.gemmB](Gemm.md#decl-6218aaffd17d1302), [TensorCore.gemmTileOperands](../Defs.md#decl-bacd4f631a1fc68b), [TensorCore.gemmTileSchedule](../Defs.md#decl-0f85cf51aeea8448)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
