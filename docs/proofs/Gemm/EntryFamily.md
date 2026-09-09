# TensorCore.Gemm.EntryFamily

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-36d7465bd66a40c1"></a>

<details>
<summary><code>TensorCore.EntryFamily</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L7)

```lean
structure EntryFamily (m n k : ℕ) where
  a : DenseMatrix ℚ m k
  b : DenseMatrix ℚ k n
  c : DenseMatrix ℚ m n
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.entryFamily](Cli/ExtendedAnalysis.md#decl-984f320bce724d96), [TensorCore.Cli.ExtendedAnalysis.entryReport](Cli/ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.ExtendedAnalysis.evaluate](Cli/ExtendedAnalysis.md#decl-efc26fc65c10f113), [TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.problem](Cli/GemmSelection.md#decl-2fb1639c2044a112), [TensorCore.EntryFamily.Contains](EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.EntryFamilyAccurate](EntryFamily.md#decl-22c40ef3de1a8d0f), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.ReviewClaims.family_member](Regression/ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.second_family_member](Regression/ReviewClaims.md#decl-d565737a82ea57ef), [TensorCore.Regression.variedFamily](Regression/DecisionExtensions.md#decl-41ec4e2a2fbe2115), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.inferEntryFamily](EntryFamily.md#decl-5e36ba2c223b5587)

</details>

</details>

<a id="decl-bf4ec2c7abc0448d"></a>

<details>
<summary><code>TensorCore.capMaximum</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L13)

```lean
def capMaximum : List ℚ → ℚ
  | [] => 0
  | x :: xs => max x (capMaximum xs)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.le_capMaximum](EntryFamily.md#decl-dc8cd66f854e536a)

</details>

</details>

<a id="decl-dc8cd66f854e536a"></a>

<details>
<summary><code>TensorCore.le_capMaximum</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L17)

```lean
theorem le_capMaximum (xs : List ℚ) (x : ℚ) (h : x ∈ xs) : x ≤ capMaximum xs := by
  induction xs with
  | nil => simp at h
  | cons y ys ih =>
    simp only [List.mem_cons] at h
    rcases h with rfl | h
    · unfold capMaximum; grind
    · have := ih h
      unfold capMaximum; grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.capMaximum](EntryFamily.md#decl-bf4ec2c7abc0448d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1)

</details>

</details>

<a id="decl-33fd8cf1e08ae145"></a>

<details>
<summary><code>TensorCore.EntryFamily.cell</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L27)

```lean
def EntryFamily.cell (f : EntryFamily m n k) (i : Fin m) (j : Fin n) : GemmFamily :=
  ⟨capMaximum (List.ofFn fun l : Fin k => f.a[i.val][l.val]),
   capMaximum (List.ofFn fun l : Fin k => f.b[l.val][j.val]), f.c[i.val][j.val]⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.capMaximum](EntryFamily.md#decl-bf4ec2c7abc0448d)

<details>
<summary>Used by</summary>

[TensorCore.EntryWithin](EntryFamily.md#decl-e603cd759712ff3e), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.inferEntryFamily](EntryFamily.md#decl-5e36ba2c223b5587), [TensorCore.Regression.ReviewClaims.within_of_checks](Regression/ReviewClaims.md#decl-1c7e1d8a6330eda3)

</details>

</details>

<a id="decl-e603cd759712ff3e"></a>

<details>
<summary><code>TensorCore.EntryWithin</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L31)

```lean
def EntryWithin (fmt : Format) (caps : DenseMatrix ℚ m n)
    (A : DenseMatrix (BitVec fmt.width) m n) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ d,
    (classify fmt A[i.val][j.val]).finite = some d ∧ absQ d.value ≤ caps[i.val][j.val]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.EntryFamily.Contains](EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.Regression.ReviewClaims.family_member](Regression/ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.second_family_member](Regression/ReviewClaims.md#decl-d565737a82ea57ef), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.Regression.ReviewClaims.within_of_checks](Regression/ReviewClaims.md#decl-1c7e1d8a6330eda3)

</details>

</details>

<a id="decl-28a8fff314d8cbd1"></a>

<details>
<summary><code>TensorCore.EntryFamily.Contains</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L36)

```lean
def EntryFamily.Contains (f : EntryFamily m n k) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Prop :=
  EntryWithin fp16 f.a A ∧ EntryWithin fp16 f.b B ∧ EntryWithin fp32 f.c C
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryWithin](EntryFamily.md#decl-e603cd759712ff3e), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.EntryFamilyAccurate](EntryFamily.md#decl-22c40ef3de1a8d0f), [TensorCore.Regression.ReviewClaims.family_member](Regression/ReviewClaims.md#decl-7ee5354eacefb07e), [TensorCore.Regression.ReviewClaims.second_family_member](Regression/ReviewClaims.md#decl-d565737a82ea57ef), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1)

</details>

</details>

<a id="decl-83587c4b60dbe91d"></a>

<details>
<summary><code>TensorCore.entryFamilyCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L40)

```lean
def entryFamilyCheck (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : ℚ) : Bool :=
  decide (0 ≤ tol) && decide (∀ i : Fin m, ∀ j : Fin n,
    familyCheck model k (f.cell i j) ws[i.val][j.val] tol = true)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.entryReport](Cli/ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e)

</details>

</details>

<a id="decl-5e36ba2c223b5587"></a>

<details>
<summary><code>TensorCore.inferEntryFamily</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L45)

```lean
def inferEntryFamily (model : WmmaGemmModel) (f : EntryFamily m n k) :
    Option (DenseMatrix GemmBoundConfig m n) :=
  let cells := DenseMatrix.ofFn fun i j => inferFamily model k (f.cell i j)
  if cells.toArray.all (fun row => row.toArray.all Option.isSome) then
    some (cells.map fun row => row.map fun c => c.getD ⟨0, 0, 0, 0⟩)
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.entryReport](Cli/ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269)

</details>

</details>

<a id="decl-22c40ef3de1a8d0f"></a>

<details>
<summary><code>TensorCore.EntryFamilyAccurate</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L52)

```lean
def EntryFamilyAccurate (model : WmmaGemmModel) (f : EntryFamily m n k) (tol : ℚ) : Prop :=
  ∀ A B C, f.Contains A B C → GemmAccurate model A B C tol
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.Contains](EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.Regression.varied_family_universal](Regression/DecisionExtensions.md#decl-316ae3e57a6f638f), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e)

</details>

</details>

<a id="decl-b68ab7db018b70c1"></a>

<details>
<summary><code>TensorCore.entryFamily_cell_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L55)

```lean
theorem entryFamily_cell_sound (model : WmmaGemmModel) (f : EntryFamily m n k)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (hm : f.Contains A B C) (i : Fin m) (j : Fin n) (cfg : GemmBoundConfig) (tol : ℚ)
    (h : familyCheck model k (f.cell i j) cfg tol = true) :
    ∃ cell z, (gemm model A B C)[i.val][j.val] = .ok cell ∧
      (gemmIdeal A B C)[i.val][j.val] = some z ∧ absQ (z - cell.output.value) ≤ tol := by
  let a : DenseMatrix F16 1 k := DenseMatrix.ofFn fun _ l => A[i.val][l.val]
  let b : DenseMatrix F16 k 1 := DenseMatrix.ofFn fun l _ => B[l.val][j.val]
  let c : DenseMatrix F32 1 1 := #v[#v[C[i.val][j.val]]]
  have hc : (f.cell i j).Contains a b c := by
    refine ⟨?_, ?_, ?_⟩
    · intro r l
      obtain ⟨d, hd, hb⟩ := hm.1 i l
      refine ⟨d, by simpa [a, DenseMatrix.ofFn] using hd, Rat.le_trans hb ?_⟩
      exact le_capMaximum _ _ (List.mem_ofFn.mpr ⟨l, rfl⟩)
    · intro l s
      obtain ⟨d, hd, hb⟩ := hm.2.1 l j
      refine ⟨d, by simpa [b, DenseMatrix.ofFn] using hd, Rat.le_trans hb ?_⟩
      exact le_capMaximum _ _ (List.mem_ofFn.mpr ⟨l, rfl⟩)
    · intro r s
      have hr : r = 0 := by omega
      have hs : s = 0 := by omega
      subst r; subst s
      simpa [c, EntryFamily.cell] using hm.2.2 i j
  obtain ⟨cell, z, hr, hz, he⟩ := familyCheck_sound model (f.cell i j) cfg
    1 1 k tol h a b c hc 0 0
  refine ⟨cell, z, ?_, ?_, he⟩
  · rw [gemm_entry] at hr ⊢
    simpa [gemmPairs, a, b, c, DenseMatrix.ofFn] using hr
  · simpa [gemmIdeal, gemmPairs, a, b, c, DenseMatrix.ofFn] using hz
```

**Supporting proofs:** [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549), [TensorCore.le_capMaximum](EntryFamily.md#decl-dc8cd66f854e536a)

**Definitions and types:** [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.Contains](EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.EntryWithin](EntryFamily.md#decl-e603cd759712ff3e), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.MatrixWithin](Family.md#decl-71221945e17a1cdc), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e)

</details>

</details>

<a id="decl-5ccddaa83f68c97e"></a>

<details>
<summary><code>TensorCore.entryFamilyCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L86)

```lean
theorem entryFamilyCheck_sound (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : ℚ)
    (h : entryFamilyCheck model f ws tol = true) : EntryFamilyAccurate model f tol := by
  simp only [entryFamilyCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  intro A B C hm i j
  exact entryFamily_cell_sound model f A B C hm i j ws[i.val][j.val] tol (h.2 i j)
```

**Supporting proofs:** [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.Contains](EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.EntryFamilyAccurate](EntryFamily.md#decl-22c40ef3de1a8d0f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8)

</details>

</details>

<a id="decl-989115036d6b8544"></a>

<details>
<summary><code>TensorCore.entryFamilyCheck_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/EntryFamily.lean#L93)

```lean
theorem entryFamilyCheck_matrix_error (model : WmmaGemmModel) (f : EntryFamily m n k)
    (ws : DenseMatrix GemmBoundConfig m n) (tol : ℚ)
    (h : entryFamilyCheck model f ws tol = true)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n)
    (hm : f.Contains A B C) (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      matrixAbsSum (ws.map fun row => row.map (familyError model k)) := by
  simp only [entryFamilyCheck, Bool.and_eq_true, decide_eq_true_eq] at h
  apply matrixAbsSum_le_entry_bounds
  intro i j
  have hc := familyCheck_at_bound model k (f.cell i j) ws[i.val][j.val] tol (h.2 i j)
  obtain ⟨cell, z, hr, hi, he⟩ := entryFamily_cell_sound model f A B C hm i j ws[i.val][j.val] _ hc
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he
```

**Supporting proofs:** [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1), [TensorCore.matrixAbsSum_le_entry_bounds](InputBounds.md#decl-46e7ff540915c07d)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.EntryFamily](EntryFamily.md#decl-36d7465bd66a40c1), [TensorCore.EntryFamily.Contains](EntryFamily.md#decl-28a8fff314d8cbd1), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyError](Family.md#decl-966b1b857128f203), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e), [TensorCore.sourceGemmPairs](InputBounds.md#decl-2fa90183da38c041)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
