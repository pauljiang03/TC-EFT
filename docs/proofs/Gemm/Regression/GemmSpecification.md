# TensorCore.Gemm.Regression.GemmSpecification

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-a60bf69e12cce69b"></a>

<details>
<summary><code>TensorCore.Regression.paper_gemm_rectangular</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L13)

```lean
theorem paper_gemm_rectangular :
    wmmaGemmBits .v100 gemmA gemmB gemmC =
      #v[#v[some 0x41800000, some 0x42640000, some 0xc1400000],
         #v[some 0xc1300000, some 0xc2480000, some 0x41a80000]] := by
  rw [← gemmBits_eq_paper .v100]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmBits_eq_paper](../Specification/GemmEquivalence.md#decl-e1a406fea7ba091b)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.wmmaGemmBits](../Specification/Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](../Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Regression.gemmA](Gemm.md#decl-cd0883f1e38ef115), [TensorCore.Regression.gemmB](Gemm.md#decl-6218aaffd17d1302), [TensorCore.Regression.gemmC](Gemm.md#decl-ab7c3d001b056c5e), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7e99f654c1b12fb7"></a>

<details>
<summary><code>TensorCore.Regression.paper_gemm_boundaries</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L20)

```lean
theorem paper_gemm_boundaries :
    ((wmmaGemm .v100 gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = some [4, 4] ∧
    ((wmmaGemm .ampere gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = some [2, 2] ∧
    ((wmmaGemm .hopper gemmTinyA gemmTinyB gemmOne)[0][0]).map
      (fun c => c.instructions.map List.length) = some [1, 1] := by
  rw [← gemm_eq_paper .v100, ← gemm_eq_paper .ampere, ← gemm_eq_paper .hopper]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.gemm_eq_paper](../Specification/GemmEquivalence.md#decl-5c9e12476c94c50c)

**Definitions and types:** [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](../Specification/Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.gemmCellObservation](../Specification/GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.wmmaGemm](../Specification/Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](../Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.gemmTinyA](Gemm.md#decl-0f102c9773dce5da), [TensorCore.Regression.gemmTinyB](Gemm.md#decl-b3d2db426390406e), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-19e69582e00c6cc9"></a>

<details>
<summary><code>TensorCore.Regression.paper_gemm_empty_and_nonfinite</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L30)

```lean
theorem paper_gemm_empty_and_nonfinite :
    wmmaGemmBits .v100 (#v[#v[]] : DenseMatrix F16 1 0) (#v[] : DenseMatrix F16 0 3)
      #v[#v[0x80000000, 0x3f800000, 0x7fc00000]] = #v[#v[some 0x80000000, some 0x3f800000, none]] ∧
    wmmaGemmBits .hopper (#v[#v[0x7c00], #v[0x3c00]] : DenseMatrix F16 2 1)
      #v[#v[0x3c00]] #v[#v[0], #v[0]] = #v[#v[none], #v[some 0x3f800000]] := by
  rw [← gemmBits_eq_paper .v100, ← gemmBits_eq_paper .hopper]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmBits_eq_paper](../Specification/GemmEquivalence.md#decl-e1a406fea7ba091b)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.wmmaGemmBits](../Specification/Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](../Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f27090983a42c796"></a>

<details>
<summary><code>TensorCore.Regression.paper_gemm_empty_outputs</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L38)

```lean
theorem paper_gemm_empty_outputs :
    wmmaGemmBits .ampere (#v[] : DenseMatrix F16 0 1) #v[#v[0x7c00]] #v[] = #v[] ∧
    wmmaGemmBits .hopper #v[#v[0x7c00]] (#v[#v[]] : DenseMatrix F16 1 0) #v[#v[]] = #v[#v[]] := by
  rw [← gemmBits_eq_paper .ampere, ← gemmBits_eq_paper .hopper]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmBits_eq_paper](../Specification/GemmEquivalence.md#decl-e1a406fea7ba091b)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.wmmaGemmBits](../Specification/Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](../Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-3572d1ef7d9e34e9"></a>

<details>
<summary><code>TensorCore.Regression.paperOrderA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L44)

```lean
def paperOrderA (reverse : Bool) : DenseMatrix F16 1 17 := DenseMatrix.ofFn fun _ l =>
  if l.val = 0 then if reverse then 1 else 0xbc00
  else if l.val = 16 then if reverse then 0xbc00 else 1 else 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_gemm_instruction_order](GemmSpecification.md#decl-44dd811c9537c054)

</details>

</details>

<a id="decl-19a0e55989a841c6"></a>

<details>
<summary><code>TensorCore.Regression.paperOrderB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L48)

```lean
def paperOrderB : DenseMatrix F16 17 1 := DenseMatrix.ofFn fun _ _ => 0x3c00
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_gemm_instruction_order](GemmSpecification.md#decl-44dd811c9537c054)

</details>

</details>

<a id="decl-44dd811c9537c054"></a>

<details>
<summary><code>TensorCore.Regression.paper_gemm_instruction_order</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L51)

```lean
/-- The same exact terms in a different instruction order have different bits. -/
theorem paper_gemm_instruction_order :
    wmmaGemmBits .ampere (paperOrderA false) paperOrderB gemmOne = #v[#v[some 0x33800000]] ∧
    wmmaGemmBits .ampere (paperOrderA true) paperOrderB gemmOne = #v[#v[some 0]] := by
  rw [← gemmBits_eq_paper .ampere, ← gemmBits_eq_paper .ampere]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmBits_eq_paper](../Specification/GemmEquivalence.md#decl-e1a406fea7ba091b)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.wmmaGemmBits](../Specification/Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](../Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Regression.gemmOne](Gemm.md#decl-5924bb947ea9cb7c), [TensorCore.Regression.paperOrderA](GemmSpecification.md#decl-3572d1ef7d9e34e9), [TensorCore.Regression.paperOrderB](GemmSpecification.md#decl-19a0e55989a841c6), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-23119d1df7a7e567"></a>

<details>
<summary><code>TensorCore.Regression.paperEdgeA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L57)

```lean
def paperEdgeA : DenseMatrix F16 17 1 := DenseMatrix.ofFn fun i _ => if i.val = 16 then 0xc000 else 0x3c00
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_gemm_output_crop](GemmSpecification.md#decl-bbeccaa9fc02f1b3)

</details>

</details>

<a id="decl-abeabd6a7c04a5bf"></a>

<details>
<summary><code>TensorCore.Regression.paperEdgeB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L58)

```lean
def paperEdgeB : DenseMatrix F16 1 17 := DenseMatrix.ofFn fun _ j => if j.val = 16 then 0x4200 else 0x3c00
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_gemm_output_crop](GemmSpecification.md#decl-bbeccaa9fc02f1b3)

</details>

</details>

<a id="decl-58937c167d2369e2"></a>

<details>
<summary><code>TensorCore.Regression.paperEdgeC</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L59)

```lean
def paperEdgeC : DenseMatrix F32 17 17 := DenseMatrix.ofFn fun _ _ => 0
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.Regression.paper_gemm_output_crop](GemmSpecification.md#decl-bbeccaa9fc02f1b3)

</details>

</details>

<a id="decl-bbeccaa9fc02f1b3"></a>

<details>
<summary><code>TensorCore.Regression.paper_gemm_output_crop</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L62)

```lean
/-- Crossing both output-tile boundaries retains the intended row and column. -/
theorem paper_gemm_output_crop :
    (wmmaGemmBits .hopper paperEdgeA paperEdgeB paperEdgeC)[0][16] = some 0x40400000 ∧
    (wmmaGemmBits .hopper paperEdgeA paperEdgeB paperEdgeC)[16][16] = some 0xc0c00000 := by
  rw [← gemmBits_eq_paper .hopper]
  decide +kernel
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmBits_eq_paper](../Specification/GemmEquivalence.md#decl-e1a406fea7ba091b)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.wmmaGemmBits](../Specification/Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](../Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.Regression.paperEdgeA](GemmSpecification.md#decl-23119d1df7a7e567), [TensorCore.Regression.paperEdgeB](GemmSpecification.md#decl-abeabd6a7c04a5bf), [TensorCore.Regression.paperEdgeC](GemmSpecification.md#decl-58937c167d2369e2), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmBits](../Defs.md#decl-adba0115aad6bb7b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-718309cb9b0ed958"></a>

<details>
<summary><code>TensorCore.Regression.paper_source_certificate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Regression/GemmSpecification.lean#L69)

```lean
/-- The combined public contract is obtained solely from input-check acceptance. -/
theorem paper_source_certificate :
    ∃ a b' D, convertGemmInput fp32 .nearestEven sourceNearOne = some a ∧
      convertGemmInput fp32 .nearestEven sourceNearOne = some b' ∧
      InputConversionContract fp32 .nearestEven sourceNearOne a ∧
      InputConversionContract fp32 .nearestEven sourceNearOne b' ∧
      convertedGemm fp32 .nearestEven .v100 {} 0x3f800000 0 sourceNearOne sourceNearOne sourceZero = some D ∧
      ∀ i : Fin 1, ∀ j : Fin 1, ∃ t z E, D[i.val][j.val] = some t ∧
        (sourceGemmIdeal fp32 0x3f800000 0 sourceNearOne sourceNearOne sourceZero)[i.val][j.val] = some z ∧
        (convertedGemmSourceError fp32 .nearestEven .v100 {} sourceGemmBounds
          0x3f800000 sourceNearOne sourceNearOne)[i.val][j.val] = some E ∧
        absQ (z - t.output.value) ≤ E ∧
        (wmmaGemm .v100 a b' (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] =
          some (gemmCellObservation t.product) ∧
        t.product.initial.bits = 0 ∧ EpilogueContract {} 0x3f800000 0 sourceZero[i.val][j.val] t :=
  convertedGemmCheck_paper_sound fp32 .nearestEven .v100 {} sourceGemmBounds
    0x3f800000 0 sourceNearOne sourceNearOne sourceZero (by decide +kernel)
```

**Supporting proofs:** [TensorCore.PaperSpec.convertedGemmCheck_paper_sound](../Specification/GemmComposition.md#decl-463c7ce44999fc94)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.FiniteBinary.value](../../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmEpilogue](../ScaledGemm.md#decl-88c6d32ebe9ea7bf), [TensorCore.PaperSpec.EpilogueContract](../Specification/GemmComposition.md#decl-4ca3d97c3fa1daf2), [TensorCore.PaperSpec.InputConversionContract](../Specification/GemmComposition.md#decl-8e4b3aa57a1c71a3), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](../Specification/Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.gemmCellObservation](../Specification/GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.wmmaGemm](../Specification/Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.Regression.sourceGemmBounds](GemmInputConversion.md#decl-f489ee27debc3a73), [TensorCore.Regression.sourceNearOne](GemmInputConversion.md#decl-8df9b91930d685ed), [TensorCore.Regression.sourceZero](GemmInputConversion.md#decl-010876357b47a5ed), [TensorCore.ScaledGemmCell](../ScaledGemm.md#decl-37e2cfa554d68ad1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.convertGemmInput](../ScaledGemm.md#decl-02d35e3c713c1e24), [TensorCore.convertedGemm](../ScaledGemm.md#decl-f354aa226c12ed99), [TensorCore.convertedGemmCheck](../ScaledGemmBounds.md#decl-2dc2798c7ad94c7b), [TensorCore.convertedGemmSourceError](../InputBounds.md#decl-b36e79035e2aa2b4), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.sourceGemmIdeal](../InputBounds.md#decl-f22289384470bd38)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
