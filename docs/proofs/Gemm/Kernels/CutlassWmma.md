# TensorCore.Gemm.Kernels.CutlassWmma

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-b7384cd61b69b58d"></a>

<details>
<summary><code>TensorCore.CutlassWmma.revision</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L17)

```lean
/-- Immutable upstream revision, also checked against the vendored source manifest. -/
def revision : String := "f7b19de32c5d1f3cedfc735c2849f12b537522ee"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ef24333303142de0"></a>

<details>
<summary><code>TensorCore.CutlassWmma.warpOf</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L19)

```lean
def warpOf (i j : ℕ) : ℕ := i % 64 / 32 + 2 * (j % 64 / 32)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.loads](CutlassWmma.md#decl-b59b466e5737993b), [TensorCore.CutlassWmma.operand_addresses](CutlassWmma.md#decl-0d677656629336a8), [TensorCore.CutlassWmma.output_coordinates](CutlassWmma.md#decl-97443ecb55b95e94), [TensorCore.CutlassWmma.store_address](CutlassWmma.md#decl-1be222435eb5ace8), [TensorCore.CutlassWmma.warpOf_lt](CutlassWmma.md#decl-edcb86a36bba7edf), [TensorCore.Regression.cutlass_coordinates](../Regression/CutlassWmma.md#decl-e53c82c122ea1f6d)

</details>

</details>

<a id="decl-b5544610edcfb7a2"></a>

<details>
<summary><code>TensorCore.CutlassWmma.outputRow</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L20)

```lean
def outputRow (blockRow warp localRow : ℕ) := blockRow * 64 + (warp % 2) * 32 + localRow
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.loads](CutlassWmma.md#decl-b59b466e5737993b), [TensorCore.CutlassWmma.operand_addresses](CutlassWmma.md#decl-0d677656629336a8), [TensorCore.CutlassWmma.output_coordinates](CutlassWmma.md#decl-97443ecb55b95e94), [TensorCore.CutlassWmma.store_address](CutlassWmma.md#decl-1be222435eb5ace8), [TensorCore.Regression.cutlass_coordinates](../Regression/CutlassWmma.md#decl-e53c82c122ea1f6d)

</details>

</details>

<a id="decl-2a37779a83662108"></a>

<details>
<summary><code>TensorCore.CutlassWmma.outputCol</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L21)

```lean
def outputCol (blockCol warp localCol : ℕ) := blockCol * 64 + (warp / 2) * 32 + localCol
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.loads](CutlassWmma.md#decl-b59b466e5737993b), [TensorCore.CutlassWmma.operand_addresses](CutlassWmma.md#decl-0d677656629336a8), [TensorCore.CutlassWmma.output_coordinates](CutlassWmma.md#decl-97443ecb55b95e94), [TensorCore.CutlassWmma.store_address](CutlassWmma.md#decl-1be222435eb5ace8), [TensorCore.Regression.cutlass_coordinates](../Regression/CutlassWmma.md#decl-e53c82c122ea1f6d)

</details>

</details>

<a id="decl-edcb86a36bba7edf"></a>

<details>
<summary><code>TensorCore.CutlassWmma.warpOf_lt</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L23)

```lean
theorem warpOf_lt (i j : ℕ) : warpOf i j < 4 := by unfold warpOf; omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CutlassWmma.warpOf](CutlassWmma.md#decl-ef24333303142de0)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-97443ecb55b95e94"></a>

<details>
<summary><code>TensorCore.CutlassWmma.output_coordinates</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L25)

```lean
theorem output_coordinates (i j : ℕ) :
    outputRow (i / 64) (warpOf i j) (i % 32) = i ∧
    outputCol (j / 64) (warpOf i j) (j % 32) = j := by
  unfold outputRow outputCol warpOf
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CutlassWmma.outputCol](CutlassWmma.md#decl-2a37779a83662108), [TensorCore.CutlassWmma.outputRow](CutlassWmma.md#decl-b5544610edcfb7a2), [TensorCore.CutlassWmma.warpOf](CutlassWmma.md#decl-ef24333303142de0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.operand_addresses](CutlassWmma.md#decl-0d677656629336a8), [TensorCore.CutlassWmma.store_address](CutlassWmma.md#decl-1be222435eb5ace8)

</details>

</details>

<a id="decl-f24d2711d55bb49a"></a>

<details>
<summary><code>TensorCore.CutlassWmma.addressA</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L32)

```lean
/-- Element offsets (not byte offsets) in the three pinned global layouts. -/
def addressA (lda row k : ℕ) := row * lda + k
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.operand_addresses](CutlassWmma.md#decl-0d677656629336a8), [TensorCore.Regression.cutlass_coordinates](../Regression/CutlassWmma.md#decl-e53c82c122ea1f6d)

</details>

</details>

<a id="decl-321f0efe41b36f2f"></a>

<details>
<summary><code>TensorCore.CutlassWmma.addressB</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L33)

```lean
def addressB (ldb k col : ℕ) := col * ldb + k
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.operand_addresses](CutlassWmma.md#decl-0d677656629336a8), [TensorCore.Regression.cutlass_coordinates](../Regression/CutlassWmma.md#decl-e53c82c122ea1f6d)

</details>

</details>

<a id="decl-2fabf10b25b488c7"></a>

<details>
<summary><code>TensorCore.CutlassWmma.addressD</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L34)

```lean
def addressD (ldd row col : ℕ) := row * ldd + col
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.store_address](CutlassWmma.md#decl-1be222435eb5ace8), [TensorCore.Regression.cutlass_coordinates](../Regression/CutlassWmma.md#decl-e53c82c122ea1f6d)

</details>

</details>

<a id="decl-0d677656629336a8"></a>

<details>
<summary><code>TensorCore.CutlassWmma.operand_addresses</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L36)

```lean
theorem operand_addresses (lda ldb i j step r : ℕ) :
    addressA lda (outputRow (i / 64) (warpOf i j) (i % 32)) (step * 16 + r) =
      i * lda + step * 16 + r ∧
    addressB ldb (step * 16 + r) (outputCol (j / 64) (warpOf i j) (j % 32)) =
      j * ldb + step * 16 + r := by
  rw [(output_coordinates i j).1, (output_coordinates i j).2]
  unfold addressA addressB
  omega
```

**Supporting proofs:** [TensorCore.CutlassWmma.output_coordinates](CutlassWmma.md#decl-97443ecb55b95e94)

**Definitions and types:** [TensorCore.CutlassWmma.addressA](CutlassWmma.md#decl-f24d2711d55bb49a), [TensorCore.CutlassWmma.addressB](CutlassWmma.md#decl-321f0efe41b36f2f), [TensorCore.CutlassWmma.outputCol](CutlassWmma.md#decl-2a37779a83662108), [TensorCore.CutlassWmma.outputRow](CutlassWmma.md#decl-b5544610edcfb7a2), [TensorCore.CutlassWmma.warpOf](CutlassWmma.md#decl-ef24333303142de0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-1be222435eb5ace8"></a>

<details>
<summary><code>TensorCore.CutlassWmma.store_address</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L45)

```lean
theorem store_address (ldd i j : ℕ) :
    addressD ldd (outputRow (i / 64) (warpOf i j) (i % 32))
      (outputCol (j / 64) (warpOf i j) (j % 32)) = i * ldd + j := by
  rw [(output_coordinates i j).1, (output_coordinates i j).2]
  rfl
```

**Supporting proofs:** [TensorCore.CutlassWmma.output_coordinates](CutlassWmma.md#decl-97443ecb55b95e94)

**Definitions and types:** [TensorCore.CutlassWmma.addressD](CutlassWmma.md#decl-2fabf10b25b488c7), [TensorCore.CutlassWmma.outputCol](CutlassWmma.md#decl-2a37779a83662108), [TensorCore.CutlassWmma.outputRow](CutlassWmma.md#decl-b5544610edcfb7a2), [TensorCore.CutlassWmma.warpOf](CutlassWmma.md#decl-ef24333303142de0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-04ead765ade3cda7"></a>

<details>
<summary><code>TensorCore.CutlassWmma.instructions</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L54)

```lean
/-- One instruction per output entry per loop iteration; each warp visits
its four independent m/n fragments. The source decrements a remaining
count while the tile iterators advance by 16 along K. -/
def instructions (load : ℕ → α) : ℕ → ℕ → List (List α)
  | _, 0 => []
  | start, count + 1 => (List.ofFn fun r : Fin 16 => load (start + r.val)) ::
      instructions load (start + 16) count
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.project](CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.CutlassWmma.project_eq_gemm](CutlassWmma.md#decl-605b9db02c373842), [TensorCore.CutlassWmma.chunks_tabulate](CutlassWmma.md#decl-0031843440b4c3e1)

</details>

</details>

<a id="decl-0031843440b4c3e1"></a>

<details>
<summary><code>TensorCore.CutlassWmma.chunks_tabulate</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L59)

```lean
private theorem chunks_tabulate (load : ℕ → α) (start count : ℕ) :
    PaperSpec.matrixChunks 16 count (List.ofFn fun r : Fin (16 * count) => load (start + r.val)) =
      instructions load start count := by
  induction count generalizing start with
  | zero => rfl
  | succ count ih =>
    have he : 16 * (count + 1) = 16 + 16 * count := by omega
    have hs : (List.ofFn fun r : Fin (16 * (count + 1)) => load (start + r.val)) =
        (List.ofFn fun r : Fin 16 => load (start + r.val)) ++
        (List.ofFn fun r : Fin (16 * count) => load (start + 16 + r.val)) := by
      conv => lhs; rw [he]
      rw [List.ofFn_add]
      congr 1
      apply congrArg List.ofFn
      funext r
      congr 1
      simp [Fin.natAdd, Nat.add_assoc]
    rw [hs]
    have ht := List.take_append_length
      (l₁ := List.ofFn fun r : Fin 16 => load (start + r.val))
      (l₂ := List.ofFn fun r : Fin (16 * count) => load (start + 16 + r.val))
    have hd := List.drop_append_length
      (l₁ := List.ofFn fun r : Fin 16 => load (start + r.val))
      (l₂ := List.ofFn fun r : Fin (16 * count) => load (start + 16 + r.val))
    simp only [List.length_ofFn] at ht hd
    simp only [PaperSpec.matrixChunks, ht, hd, ih, instructions]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CutlassWmma.instructions](CutlassWmma.md#decl-04ead765ade3cda7), [TensorCore.PaperSpec.matrixChunks](../Specification/Matrix.md#decl-4b229a112eae4f8a)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2)

</details>

</details>

<a id="decl-b59b466e5737993b"></a>

<details>
<summary><code>TensorCore.CutlassWmma.loads</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L88)

```lean
/-- Logical operand reads after the pinned CTA/warp mapping. Out-of-range output
cells are masked; the public projection below keeps only valid rows and columns. -/
def loads (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (i j l : ℕ) : F16 × F16 :=
  (A.padded 0 (outputRow (i / 64) (warpOf i j) (i % 32)) l,
   B.padded 0 l (outputCol (j / 64) (warpOf i j) (j % 32)))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CutlassWmma.outputCol](CutlassWmma.md#decl-2a37779a83662108), [TensorCore.CutlassWmma.outputRow](CutlassWmma.md#decl-b5544610edcfb7a2), [TensorCore.CutlassWmma.warpOf](CutlassWmma.md#decl-ef24333303142de0), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.padded](../Matrix.md#decl-95c7a9b947ecc858), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.CutlassWmma.project](CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.CutlassWmma.project_eq_gemm](CutlassWmma.md#decl-605b9db02c373842)

</details>

</details>

<a id="decl-310bb61e7c6578a2"></a>

<details>
<summary><code>TensorCore.CutlassWmma.instructions_eq_paper</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L92)

```lean
theorem instructions_eq_paper (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) (i : Fin m) (j : Fin n) :
    instructions (loads A B i.val j.val) 0 tiles =
      PaperSpec.matrixInstructions (PaperSpec.matrixPairs A B i j) := by
  rw [← chunks_tabulate]
  have hloads : (List.ofFn fun r : Fin (16 * tiles) => loads A B i.val j.val (0 + r.val)) =
      PaperSpec.matrixPairs A B i j := by
    apply congrArg List.ofFn
    funext r
    simp [loads, (output_coordinates i.val j.val).1, (output_coordinates i.val j.val).2,
      DenseMatrix.padded, i.isLt, j.isLt, r.isLt]
  rw [hloads]
  have hc : (16 * tiles + 15) / 16 = tiles := by omega
  simp [PaperSpec.matrixInstructions, PaperSpec.matrixPairs, hc]
```

**Supporting proofs:** [TensorCore.CutlassWmma.output_coordinates](CutlassWmma.md#decl-97443ecb55b95e94), [TensorCore.CutlassWmma.chunks_tabulate](CutlassWmma.md#decl-0031843440b4c3e1)

**Definitions and types:** [TensorCore.CutlassWmma.instructions](CutlassWmma.md#decl-04ead765ade3cda7), [TensorCore.CutlassWmma.loads](CutlassWmma.md#decl-b59b466e5737993b), [TensorCore.CutlassWmma.outputCol](CutlassWmma.md#decl-2a37779a83662108), [TensorCore.CutlassWmma.outputRow](CutlassWmma.md#decl-b5544610edcfb7a2), [TensorCore.CutlassWmma.warpOf](CutlassWmma.md#decl-ef24333303142de0), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.padded](../Matrix.md#decl-95c7a9b947ecc858), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.matrixChunks](../Specification/Matrix.md#decl-4b229a112eae4f8a), [TensorCore.PaperSpec.matrixInstructions](../Specification/Matrix.md#decl-41c588bee8af8a91), [TensorCore.PaperSpec.matrixPairs](../Specification/Matrix.md#decl-a2b1744a02af852c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_eq_gemm](CutlassWmma.md#decl-605b9db02c373842)

</details>

</details>

<a id="decl-19db5ceb24fc59f4"></a>

<details>
<summary><code>TensorCore.CutlassWmma.project</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L109)

```lean
/-- Identity epilogue: source C, alpha and beta are not used by ScaleType::Nothing.
Every intermediate WMMA group boundary remains observable in this projection. -/
noncomputable def project (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) : DenseMatrix (Option PaperSpec.MatrixCell) m n :=
  DenseMatrix.ofFn fun i j => do
    let ds ← PaperSpec.runMatrixInstructions .v100 0 (instructions (loads A B i.val j.val) 0 tiles)
    return ⟨0, ds⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.CutlassWmma.instructions](CutlassWmma.md#decl-04ead765ade3cda7), [TensorCore.CutlassWmma.loads](CutlassWmma.md#decl-b59b466e5737993b), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.PaperSpec.MatrixCell](../Specification/Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.runMatrixInstructions](../Specification/Matrix.md#decl-70ab1b5e8c6e625e)

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_check_sound](CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.CutlassWmma.project_eq_gemm](CutlassWmma.md#decl-605b9db02c373842), [TensorCore.Regression.cutlass_fixture_connection](../Regression/CutlassWmma.md#decl-e2a0bcb3a499b023)

</details>

</details>

<a id="decl-605b9db02c373842"></a>

<details>
<summary><code>TensorCore.CutlassWmma.project_eq_gemm</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L118)

```lean
/-- Unconditional finite-model equality for the audited arithmetic projection.
This supplies the arithmetic schedule bridge; physical WMMA conformance and
source-transcription correctness are the explicitly documented external boundary. -/
theorem project_eq_gemm (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) :
    project A B = (gemm .v100 A B (DenseMatrix.ofFn fun _ _ => 0)).map
      (fun row => row.map fun cell => cell.toOption.map PaperSpec.gemmCellObservation) := by
  rw [PaperSpec.gemm_eq_paper]
  apply Vector.ext
  intro i hi
  apply Vector.ext
  intro j hj
  simp only [project, PaperSpec.wmmaGemm, DenseMatrix.ofFn, Vector.getElem_ofFn]
  rw [instructions_eq_paper A B ⟨i, hi⟩ ⟨j, hj⟩]
  rfl
```

**Supporting proofs:** [TensorCore.CutlassWmma.instructions_eq_paper](CutlassWmma.md#decl-310bb61e7c6578a2), [TensorCore.PaperSpec.gemm_eq_paper](../Specification/GemmEquivalence.md#decl-5c9e12476c94c50c)

**Definitions and types:** [TensorCore.CutlassWmma.instructions](CutlassWmma.md#decl-04ead765ade3cda7), [TensorCore.CutlassWmma.loads](CutlassWmma.md#decl-b59b466e5737993b), [TensorCore.CutlassWmma.project](CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](../Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.MatrixCell](../Specification/Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.WmmaModel](../Specification/Matrix.md#decl-9f438a42365ca5b2), [TensorCore.PaperSpec.gemmCellObservation](../Specification/GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.PaperSpec.matrixCell](../Specification/Matrix.md#decl-0760d932c690b0cb), [TensorCore.PaperSpec.matrixInstructions](../Specification/Matrix.md#decl-41c588bee8af8a91), [TensorCore.PaperSpec.matrixPairs](../Specification/Matrix.md#decl-a2b1744a02af852c), [TensorCore.PaperSpec.runMatrixInstructions](../Specification/Matrix.md#decl-70ab1b5e8c6e625e), [TensorCore.PaperSpec.wmmaGemm](../Specification/Matrix.md#decl-66a4e74e5f4e4b6c), [TensorCore.PaperSpec.wmmaModel](../Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.CutlassWmma.project_check_sound](CutlassWmma.md#decl-2566ff4a51e98b33), [TensorCore.Regression.cutlass_fixture_connection](../Regression/CutlassWmma.md#decl-e2a0bcb3a499b023)

</details>

</details>

<a id="decl-2566ff4a51e98b33"></a>

<details>
<summary><code>TensorCore.CutlassWmma.project_check_sound</code></summary>

[Lean source](../../../../TensorCore/Gemm/Kernels/CutlassWmma.lean#L133)

```lean
/-- The existing input-only certificate supplies a complete accuracy guarantee
for this projection, without requiring a successful run or output-error premise. -/
theorem project_check_sound (A : DenseMatrix F16 m (16 * tiles))
    (B : DenseMatrix F16 (16 * tiles) n) (cfg : GemmBoundConfig)
    (h : gemmCheck .v100 cfg A B (DenseMatrix.ofFn fun _ _ => 0) = true)
    (i : Fin m) (j : Fin n) :
    ∃ cell z, (project A B)[i.val][j.val] = some (PaperSpec.gemmCellObservation cell) ∧
      (gemmIdeal A B (DenseMatrix.ofFn fun _ _ => 0))[i.val][j.val] = some z ∧
      absQ (z - cell.output.value) ≤ gemmStaticError .v100 cfg (16 * tiles) := by
  obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound .v100 cfg A B _ h i j
  refine ⟨cell, z, ?_, hi, he⟩
  rw [project_eq_gemm]
  simp only [Vector.getElem_map, hr]
  rfl
```

**Supporting proofs:** [TensorCore.CutlassWmma.project_eq_gemm](CutlassWmma.md#decl-605b9db02c373842), [TensorCore.gemmCheck_sound](../Bounds.md#decl-3d79dbcc8fc2e521)

**Definitions and types:** [TensorCore.CutlassWmma.project](CutlassWmma.md#decl-19db5ceb24fc59f4), [TensorCore.DenseMatrix](../Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](../Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](../Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](../Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](../Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.MatrixCell](../Specification/Matrix.md#decl-78b1933617aed7a4), [TensorCore.PaperSpec.gemmCellObservation](../Specification/GemmEquivalence.md#decl-c61a953641cc1967), [TensorCore.WmmaGemmModel](../Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.gemm](../Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmCheck](../Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](../Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmStaticError](../Bounds.md#decl-f2b1a703f1fc6bcf)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
