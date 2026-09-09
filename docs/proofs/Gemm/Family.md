# TensorCore.Gemm.Family

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-af56fb1d41ab54f1"></a>

<details>
<summary><code>TensorCore.GemmFamily</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L9)

```lean
structure GemmFamily where
  aBound : ℚ
  bBound : ℚ
  cBound : ℚ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.Gemm.evaluate](Cli/Gemm.md#decl-a984a36184ce8479), [TensorCore.Cli.PipelineAnalysis.familyReport](Cli/PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.Cli.Selection.analysis](Cli/GemmSelection.md#decl-d9ed69e91d255373), [TensorCore.Cli.Selection.problem](Cli/GemmSelection.md#decl-2fb1639c2044a112), [TensorCore.EntryFamily.cell](EntryFamily.md#decl-33fd8cf1e08ae145), [TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.GemmFamily.productScale](Family.md#decl-aeb1e19f08190a57), [TensorCore.GemmFamilyAccurate](Family.md#decl-6a51b2e27db67ff4), [TensorCore.GemmProblem](Selection.md#decl-cbf3e8441a848a8f), [TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.GemmProblem.Witness](Selection.md#decl-86b28bea33c8f64a), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.empty_family_accuracy](Regression/GemmFamily.md#decl-df50441d5d2cb648), [TensorCore.Regression.family_membership_signed_subnormal](Regression/GemmFamily.md#decl-a3201c4c5fa5173c), [TensorCore.Regression.family_witness_controls](Regression/GemmFamily.md#decl-4b7acaae99672922), [TensorCore.Regression.selection_family](Regression/GemmSelection.md#decl-dfcf9fc60b19226e), [TensorCore.Regression.unitFamily](Regression/GemmFamily.md#decl-e34f5ac08cbdf2e5), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.family_pair_scale](Family.md#decl-797e6af7a549f294), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848), [TensorCore.inferFamily_valid](Family.md#decl-01c631b0665f69f3)

</details>

</details>

<a id="decl-71221945e17a1cdc"></a>

<details>
<summary><code>TensorCore.MatrixWithin</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L15)

```lean
def MatrixWithin (f : Format) (M : ℚ) (A : DenseMatrix (BitVec f.width) m n) : Prop :=
  ∀ i : Fin m, ∀ j : Fin n, ∃ d, (classify f A[i.val][j.val]).finite = some d ∧ absQ d.value ≤ M
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.Regression.family_membership_signed_subnormal](Regression/GemmFamily.md#decl-a3201c4c5fa5173c), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf)

</details>

</details>

<a id="decl-eaee8494d54b2afc"></a>

<details>
<summary><code>TensorCore.GemmFamily.Contains</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L18)

```lean
def GemmFamily.Contains (f : GemmFamily) (A : DenseMatrix F16 m k)
    (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) : Prop :=
  MatrixWithin fp16 f.aBound A ∧ MatrixWithin fp16 f.bBound B ∧ MatrixWithin fp32 f.cBound C
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.MatrixWithin](Family.md#decl-71221945e17a1cdc), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.GemmFamilyAccurate](Family.md#decl-6a51b2e27db67ff4), [TensorCore.Regression.family_membership_signed_subnormal](Regression/GemmFamily.md#decl-a3201c4c5fa5173c), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf)

</details>

</details>

<a id="decl-c5db35b2aa0f8491"></a>

<details>
<summary><code>TensorCore.familyOperandScale</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L22)

```lean
def familyOperandScale (M : ℚ) : ℤ := max fp16.emin (magnitudeScale M)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.magnitudeScale](../TC/Program/GroupAnalysis.md#decl-f9bf1f8eba9679a8)

<details>
<summary>Used by</summary>

[TensorCore.GemmFamily.productScale](Family.md#decl-aeb1e19f08190a57), [TensorCore.Regression.family_subnormal_scales](Regression/GemmFamily.md#decl-604135b609aa95d6), [TensorCore.familyOperandScale_spec](Family.md#decl-82f743426dfee31b), [TensorCore.family_pair_scale](Family.md#decl-797e6af7a549f294)

</details>

</details>

<a id="decl-82f743426dfee31b"></a>

<details>
<summary><code>TensorCore.familyOperandScale_spec</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L24)

```lean
theorem familyOperandScale_spec (M : ℚ) (h : 0 ≤ M) :
    fp16.emin ≤ familyOperandScale M ∧ M < pow2 (familyOperandScale M + 1) := by
  have hm := magnitudeScale_spec M h
  have he : magnitudeScale M ≤ familyOperandScale M := by unfold familyOperandScale; omega
  have hp := pow2_le_of_le (show magnitudeScale M + 1 ≤ familyOperandScale M + 1 by omega)
  constructor
  · unfold familyOperandScale; omega
  · grind
```

**Supporting proofs:** [TensorCore.magnitudeScale_spec](../TC/Program/GroupAnalysis.md#decl-d51d916c1a50ab6d), [TensorCore.pow2_le_of_le](../Core/Exact.md#decl-064be6edf8651285)

**Definitions and types:** [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.familyOperandScale](Family.md#decl-c5db35b2aa0f8491), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.magnitudeScale](../TC/Program/GroupAnalysis.md#decl-f9bf1f8eba9679a8), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.family_pair_scale](Family.md#decl-797e6af7a549f294)

</details>

</details>

<a id="decl-aeb1e19f08190a57"></a>

<details>
<summary><code>TensorCore.GemmFamily.productScale</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L33)

```lean
def GemmFamily.productScale (f : GemmFamily) : ℤ :=
  familyOperandScale f.aBound + familyOperandScale f.bBound
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.familyOperandScale](Family.md#decl-c5db35b2aa0f8491)

<details>
<summary>Used by</summary>

[TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.family_pair_scale](Family.md#decl-797e6af7a549f294), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848), [TensorCore.inferFamily_valid](Family.md#decl-01c631b0665f69f3)

</details>

</details>

<a id="decl-b456e480e468a315"></a>

<details>
<summary><code>TensorCore.familyConditions</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L36)

```lean
def familyConditions (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) : Bool :=
  let p := model.path.profile
  let E := cfg.accumulatorScale
  let P := cfg.productScale
  let L := cfg.carryBits
  decide (0 ≤ f.aBound ∧ 0 ≤ f.bBound ∧ 0 ≤ f.cBound ∧
    f.productScale ≤ P ∧ cfg.initialBound = f.cBound ∧
    -126 ≤ E ∧ P ≤ E ∧ (∀ q ∈ p.alignFloor, q ≤ E) ∧
    p.products + 1 ≤ 2 ^ L ∧ E + 2 + L ≤ 127 ∧
    f.cBound + (gemmBlockCount model k : ℚ) *
      ((p.products : ℚ) * (4 * pow2 P) +
        staticBudget (p.products + 1) p.alignFraction E L) < pow2 (E + 1))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.productScale](Family.md#decl-aeb1e19f08190a57), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d)

<details>
<summary>Used by</summary>

[TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848), [TensorCore.inferFamily_valid](Family.md#decl-01c631b0665f69f3)

</details>

</details>

<a id="decl-966b1b857128f203"></a>

<details>
<summary><code>TensorCore.familyError</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L50)

```lean
def familyError (model : WmmaGemmModel) (k : ℕ) (cfg : GemmBoundConfig) : ℚ :=
  if k = 0 then 0 else gemmStaticError model cfg k
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf)

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.entryReport](Cli/ExtendedAnalysis.md#decl-c1a2fb433c69cc2d), [TensorCore.Cli.PipelineAnalysis.familyReport](Cli/PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.familyError_nonneg](Family.md#decl-810b5bd68276af9d)

</details>

</details>

<a id="decl-43a043749bf35c52"></a>

<details>
<summary><code>TensorCore.familyCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L53)

```lean
def familyCheck (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) (tol : ℚ) : Bool :=
  decide (0 ≤ f.aBound ∧ 0 ≤ f.bBound ∧ 0 ≤ f.cBound ∧ 0 ≤ tol) &&
  (k == 0 || familyConditions model k f cfg) && decide (familyError model k cfg ≤ tol)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyError](Family.md#decl-966b1b857128f203)

<details>
<summary>Used by</summary>

[TensorCore.Cli.PipelineAnalysis.familyReport](Cli/PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.GemmProblem.check](Selection.md#decl-32e80897e0e6f460), [TensorCore.Regression.empty_family_accuracy](Regression/GemmFamily.md#decl-df50441d5d2cb648), [TensorCore.Regression.family_witness_controls](Regression/GemmFamily.md#decl-4b7acaae99672922), [TensorCore.Regression.unit_family_accuracy](Regression/GemmFamily.md#decl-276ef0fbf20b36cf), [TensorCore.entryFamilyCheck](EntryFamily.md#decl-83587c4b60dbe91d), [TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544), [TensorCore.entryFamilyCheck_sound](EntryFamily.md#decl-5ccddaa83f68c97e), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e)

</details>

</details>

<a id="decl-868633a6b6bbc848"></a>

<details>
<summary><code>TensorCore.inferFamily</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L58)

```lean
def inferFamily (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily) : Option GemmBoundConfig :=
  let L := match model with | .v100 => 3 | .ampere => 4 | .hopper => 5
  if k = 0 then some ⟨0, f.productScale, L, f.cBound⟩ else
    ((List.range 254).map fun (i : ℕ) => (⟨(i : ℤ) - 126, f.productScale, L, f.cBound⟩ : GemmBoundConfig)).find?
      (familyConditions model k f)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.productScale](Family.md#decl-aeb1e19f08190a57), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315)

<details>
<summary>Used by</summary>

[TensorCore.Cli.PipelineAnalysis.familyReport](Cli/PipelineAnalysis.md#decl-984f12645fbbbd44), [TensorCore.GemmProblem.infer](Selection.md#decl-7ff8c50195c18269), [TensorCore.Regression.family_witness_controls](Regression/GemmFamily.md#decl-4b7acaae99672922), [TensorCore.Regression.unitFamilyWitness](Regression/GemmFamily.md#decl-6f4d7edf02c5d4d3), [TensorCore.inferEntryFamily](EntryFamily.md#decl-5e36ba2c223b5587), [TensorCore.inferFamily_valid](Family.md#decl-01c631b0665f69f3)

</details>

</details>

<a id="decl-797e6af7a549f294"></a>

<details>
<summary><code>TensorCore.family_pair_scale</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L64)

```lean
theorem family_pair_scale (model : WmmaGemmModel) (f : GemmFamily)
    (hA : 0 ≤ f.aBound) (hB : 0 ≤ f.bBound) (a b : F16)
    (ha : ∃ d, (classify fp16 a).finite = some d ∧ absQ d.value ≤ f.aBound)
    (hb : ∃ d, (classify fp16 b).finite = some d ∧ absQ d.value ≤ f.bBound) :
    ∃ da db, model.path.profile.decode a = some da ∧ model.path.profile.decode b = some db ∧
      ((rawMul da db).significand ≠ 0 → (rawMul da db).rawScale ≤ f.productScale) := by
  obtain ⟨da, hda, ham⟩ := ha
  obtain ⟨db, hdb, hbm⟩ := hb
  refine ⟨da, db, hda, hdb, ?_⟩
  intro hn
  have hna : da.significand ≠ 0 := by intro hz; apply hn; simp [rawMul, hz]
  have hnb : db.significand ≠ 0 := by intro hz; apply hn; simp [rawMul, hz]
  have hsa := familyOperandScale_spec f.aBound hA
  have hsb := familyOperandScale_spec f.bBound hB
  have hea := classifyNat_scale_le_of_magnitude fp16 a.toNat da hda _ hsa.1 (by grind) hna
  have heb := classifyNat_scale_le_of_magnitude fp16 b.toNat db hdb _ hsb.1 (by grind) hnb
  change da.rawScale + db.rawScale ≤ familyOperandScale f.aBound + familyOperandScale f.bBound
  omega
```

**Supporting proofs:** [TensorCore.classifyNat_scale_le_of_magnitude](../Core/Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.familyOperandScale_spec](Family.md#decl-82f743426dfee31b)

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.productScale](Family.md#decl-aeb1e19f08190a57), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.Profile.decode](../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.familyOperandScale](Family.md#decl-c5db35b2aa0f8491), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf)

</details>

</details>

<a id="decl-4a51beeb4d271239"></a>

<details>
<summary><code>TensorCore.gemmBlocks_pair_origin</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L83)

```lean
theorem gemmBlocks_pair_origin (model : WmmaGemmModel) (pairs : List (F16 × F16))
    (g : List (F16 × F16)) (hg : g ∈ gemmBlocks model pairs) (pair : F16 × F16) (hp : pair ∈ g) :
    pair ∈ pairs ∨ pair = (0, 0) := by
  obtain ⟨instruction, hi, hgi⟩ := List.mem_flatMap.mp hg
  have hmem : pair ∈ (model.path.schedule instruction).flatten := List.mem_flatten.mpr ⟨g, hgi, hp⟩
  rw [model.path.schedule_flatten instruction
    ((gemmInstructions_shape pairs instruction hi).trans (WmmaGemmModel.k model).symm)] at hmem
  have hflat : pair ∈ (gemmInstructions pairs).flatten := List.mem_flatten.mpr ⟨instruction, hi, hmem⟩
  rw [gemmInstructions_flatten, padFp16Pairs, List.mem_append] at hflat
  rcases hflat with h | h
  · exact Or.inl h
  · exact Or.inr (List.mem_replicate.mp h).2
```

**Supporting proofs:** [TensorCore.InstructionPath.schedule_flatten](../TC/Instruction.md#decl-2652b6482c26797c), [TensorCore.WmmaGemmModel.k](Defs.md#decl-d7ce31e450277fbc), [TensorCore.gemmInstructions_flatten](Defs.md#decl-353da63dd578fcb7), [TensorCore.gemmInstructions_shape](Defs.md#decl-863019b6c0164a66)

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](../TC/Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.tailPadding](../TC/Program/Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf)

</details>

</details>

<a id="decl-56c849a6d64aa7bf"></a>

<details>
<summary><code>TensorCore.familyConditions_gemmCheck</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L96)

```lean
theorem familyConditions_gemmCheck (model : WmmaGemmModel) (f : GemmFamily)
    (cfg : GemmBoundConfig) (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n)
    (C : DenseMatrix F32 m n) (hf : familyConditions model k f cfg = true)
    (h : f.Contains A B C) : gemmCheck model cfg A B C = true := by
  simp only [familyConditions, decide_eq_true_eq] at hf
  obtain ⟨ha0, hb0, _, hP, hC, hE, hPE, hfloor, hL, hrange, hroom⟩ := hf
  apply decide_eq_true (p := ∀ i : Fin m, ∀ j : Fin n,
    gemmCellCheck model cfg (gemmPairs A B i j) C[i.val][j.val] = true)
  intro i j
  obtain ⟨dc, hdc, hcm⟩ := h.2.2 i j
  change decode32 C[i.val][j.val] = some dc at hdc
  have hcv : value32 C[i.val][j.val] = some dc.value := by simp [value32, hdc]
  have hs : (gemmBlocks model (gemmPairs A B i j)).all
      (groupScaleCheck model.path.profile cfg.productScale) = true := by
    apply List.all_eq_true.mpr
    intro g hg
    apply List.all_eq_true.mpr
    intro pair hp
    have hpair : ∃ da db, model.path.profile.decode pair.1 = some da ∧
        model.path.profile.decode pair.2 = some db ∧
        ((rawMul da db).significand ≠ 0 → (rawMul da db).rawScale ≤ f.productScale) := by
      rcases gemmBlocks_pair_origin model (gemmPairs A B i j) g hg pair hp with hm | hz
      · simp only [gemmPairs, List.mem_ofFn] at hm
        obtain ⟨l, rfl⟩ := hm
        exact family_pair_scale model f ha0 hb0 _ _ (h.1 i l) (h.2.1 l j)
      · rw [hz]
        have hz0 : (classify fp16 (0 : F16)).finite = some (Decoded.mk 0 0 0) := by decide +kernel
        apply family_pair_scale model f ha0 hb0
        · exact ⟨⟨0, 0, 0⟩, hz0, by simpa [Decoded.value, absQ] using ha0⟩
        · exact ⟨⟨0, 0, 0⟩, hz0, by simpa [Decoded.value, absQ] using hb0⟩
    obtain ⟨da, db, hda, hdb, hscale⟩ := hpair
    simp only [hda, hdb, Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq]
    by_cases hz : (rawMul da db).significand = 0
    · exact Or.inl hz
    · exact Or.inr (Int.le_trans (hscale hz) hP)
  simp only [gemmCellCheck, hs, hcv, Bool.and_eq_true, decide_eq_true_eq, gemmPairs_length]
  exact ⟨⟨⟨hE, hPE, hfloor, hL, hrange⟩, True.intro⟩, by simpa [hC] using hcm, by simpa [hC] using hroom⟩
```

**Supporting proofs:** [TensorCore.family_pair_scale](Family.md#decl-797e6af7a549f294), [TensorCore.gemmBlocks_pair_origin](Family.md#decl-4a51beeb4d271239), [TensorCore.gemmPairs_length](Defs.md#decl-5e4e68c0669cd541)

**Definitions and types:** [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.GemmFamily.productScale](Family.md#decl-aeb1e19f08190a57), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.MatrixWithin](Family.md#decl-71221945e17a1cdc), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../TC/Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks](Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmCellCheck](Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.groupScaleCheck](../TC/Program/StaticCertificate.md#decl-66820a4a9870af93), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e)

</details>

</details>

<a id="decl-6a51b2e27db67ff4"></a>

<details>
<summary><code>TensorCore.GemmFamilyAccurate</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L134)

```lean
def GemmFamilyAccurate (model : WmmaGemmModel) (f : GemmFamily) (m n k : ℕ) (tol : ℚ) : Prop :=
  ∀ (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n),
    f.Contains A B C → GemmAccurate model A B C tol
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.GemmAccurate](Analysis.md#decl-3560e57078a6df2b), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b)

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.Accurate](Selection.md#decl-8c9d3458097dac77), [TensorCore.Regression.empty_family_accuracy](Regression/GemmFamily.md#decl-df50441d5d2cb648), [TensorCore.Regression.unit_family_accuracy](Regression/GemmFamily.md#decl-276ef0fbf20b36cf), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e)

</details>

</details>

<a id="decl-f329ec5471dc4d5e"></a>

<details>
<summary><code>TensorCore.familyCheck_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L138)

```lean
theorem familyCheck_sound (model : WmmaGemmModel) (f : GemmFamily) (cfg : GemmBoundConfig)
    (m n k : ℕ) (tol : ℚ) (h : familyCheck model k f cfg tol = true) :
    GemmFamilyAccurate model f m n k tol := by
  simp only [familyCheck, Bool.and_eq_true, Bool.or_eq_true, beq_iff_eq, decide_eq_true_eq] at h
  intro A B C hmem i j
  by_cases hk : k = 0
  · subst k
    obtain ⟨dc, hdc, _⟩ := hmem.2.2 i j
    change decode32 C[i.val][j.val] = some dc at hdc
    have hcv : value32 C[i.val][j.val] = some dc.value := by simp only [value32, hdc, Option.map_some]
    obtain ⟨initial, hf, _, hv⟩ := finite32_of_value32 C[i.val][j.val] dc.value hcv
    have hp : gemmPairs A B i j = [] := by simp [gemmPairs]
    refine ⟨⟨initial, []⟩, initial.value, ?_, ?_, ?_⟩
    · rw [gemm_entry, hp]
      simp [simulateGemmCell, hf, gemmInstructions, canonicalPartition, partitionExact,
        OrderedPartition.inputs, padFp16Pairs, groupCount, tailPadding, runGemmInstructions]
    · simp only [gemmIdeal, DenseMatrix.ofFn, Vector.getElem_ofFn, hp, hcv, bind, pure, Option.bind_some]
      change some (dc.value + 0) = some initial.value
      rw [hv, Rat.add_zero]
    · change absQ (initial.value - initial.value) ≤ tol
      simpa [Rat.sub_self, absQ] using h.1.1.2.2.2
  · have hc := h.1.2.resolve_left hk
    obtain ⟨cell, z, hr, hi, he⟩ := gemmCheck_sound model cfg A B C
      (familyConditions_gemmCheck model f cfg A B C hc hmem) i j
    refine ⟨cell, z, hr, hi, Rat.le_trans he ?_⟩
    simpa [familyError, hk] using h.2
```

**Supporting proofs:** [TensorCore.familyConditions_gemmCheck](Family.md#decl-56c849a6d64aa7bf), [TensorCore.finite32_of_value32](../Core/Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.gemmCheck_sound](Bounds.md#decl-3d79dbcc8fc2e521), [TensorCore.gemm_entry](Defs.md#decl-e24588ca0d6e9549)

**Definitions and types:** [TensorCore.BlockOperands](../TC/Program/Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.GemmFamilyAccurate](Family.md#decl-6a51b2e27db67ff4), [TensorCore.MatrixWithin](Family.md#decl-71221945e17a1cdc), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition](../TC/Program/DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.canonicalPartition](../TC/Program/Partition.md#decl-7e49132d90b040d5), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyError](Family.md#decl-966b1b857128f203), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../TC/CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.gemmInstructions](Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmPairs](Defs.md#decl-5a2664b8ab0c94ef), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.groupCount](../TC/Program/Partition.md#decl-b7760ff5c737d355), [TensorCore.idealProducts](../TC/Program/Defs.md#decl-5d908ac035267580), [TensorCore.padFp16Pairs](../TC/Program/Partition.md#decl-69dc55e3030be48b), [TensorCore.partitionExact](../TC/Program/Partition.md#decl-4082e3bf596a58d7), [TensorCore.runGemmInstructions](Defs.md#decl-fa58899497fedd29), [TensorCore.simulateGemmCell](Defs.md#decl-f667f4469749d691), [TensorCore.v100F16F32](../TC/Defs.md#decl-71711e48d14142e0), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.GemmProblem.check_sound](Selection.md#decl-ae06390f648648a8), [TensorCore.Regression.empty_family_accuracy](Regression/GemmFamily.md#decl-df50441d5d2cb648), [TensorCore.Regression.unit_family_accuracy](Regression/GemmFamily.md#decl-276ef0fbf20b36cf), [TensorCore.entryFamily_cell_sound](EntryFamily.md#decl-b68ab7db018b70c1), [TensorCore.familyCheck_matrix_error](Family.md#decl-9ce69637da870c42), [TensorCore.familyCheck_paper](Family.md#decl-0234d61782492f02)

</details>

</details>

<a id="decl-01c631b0665f69f3"></a>

<details>
<summary><code>TensorCore.inferFamily_valid</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L165)

```lean
theorem inferFamily_valid (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) (h : inferFamily model k f = some cfg) :
    k = 0 ∨ familyConditions model k f cfg = true := by
  by_cases hk : k = 0
  · exact Or.inl hk
  · simp only [inferFamily, hk, ↓reduceIte] at h
    exact Or.inr (List.find?_some h)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.productScale](Family.md#decl-aeb1e19f08190a57), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.inferFamily](Family.md#decl-868633a6b6bbc848)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-9ce69637da870c42"></a>

<details>
<summary><code>TensorCore.familyCheck_matrix_error</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L173)

```lean
theorem familyCheck_matrix_error (model : WmmaGemmModel) (f : GemmFamily) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (tol : ℚ)
    (h : familyCheck model k f cfg tol = true) (hmem : f.Contains A B C)
    (D Z : DenseMatrix ℚ m n)
    (hd : ∀ i : Fin m, ∀ j : Fin n, ∀ cell,
      (gemm model A B C)[i.val][j.val] = .ok cell → D[i.val][j.val] = cell.output.value)
    (hz : ∀ i : Fin m, ∀ j : Fin n, (gemmIdeal A B C)[i.val][j.val] = some Z[i.val][j.val]) :
    matrixAbsSum (DenseMatrix.ofFn fun (i : Fin m) (j : Fin n) => Z[i.val][j.val] - D[i.val][j.val]) ≤
      (m : ℚ) * (n : ℚ) * tol := by
  apply matrixAbsSum_bound
  intro i j
  obtain ⟨cell, z, hr, hi, he⟩ := familyCheck_sound model f cfg m n k tol h A B C hmem i j
  rw [hz i j] at hi
  cases Option.some.inj hi
  simpa [DenseMatrix.ofFn, hd i j cell hr] using he
```

**Supporting proofs:** [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e), [TensorCore.matrixAbsSum_bound](Bounds.md#decl-485a6ec947a4e04d)

**Definitions and types:** [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.DenseMatrix.ofFn](Matrix.md#decl-5bd40ba4904179d3), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.MatrixWithin](Family.md#decl-71221945e17a1cdc), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmCheck](Bounds.md#decl-6dd15d2054647056), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.matrixAbsSum](Bounds.md#decl-3500b8a4ffeefc9e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-0234d61782492f02"></a>

<details>
<summary><code>TensorCore.familyCheck_paper</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L189)

```lean
theorem familyCheck_paper (model : WmmaGemmModel) (f : GemmFamily) (cfg : GemmBoundConfig)
    (A : DenseMatrix F16 m k) (B : DenseMatrix F16 k n) (C : DenseMatrix F32 m n) (tol : ℚ)
    (h : familyCheck model k f cfg tol = true) (hmem : f.Contains A B C) (i : Fin m) (j : Fin n) :
    ∃ bits d z,
      (PaperSpec.wmmaGemmBits (PaperSpec.wmmaModel model) A B C)[i.val][j.val] = some bits ∧
      value32 bits = some d ∧ (gemmIdeal A B C)[i.val][j.val] = some z ∧ absQ (z - d) ≤ tol := by
  obtain ⟨cell, z, hr, hi, he⟩ := familyCheck_sound model f cfg m n k tol h A B C hmem i j
  refine ⟨cell.output.bits, cell.output.value, z, ?_, ?_, hi, he⟩
  · rw [← PaperSpec.gemmBits_eq_paper]
    simp [gemmBits, hr, Except.toOption, Except.map]
  · simp [value32, cell.output.valid, Finite32.value]
```

**Supporting proofs:** [TensorCore.PaperSpec.gemmBits_eq_paper](Specification/GemmEquivalence.md#decl-e1a406fea7ba091b), [TensorCore.familyCheck_sound](Family.md#decl-f329ec5471dc4d5e)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.DenseMatrix](Matrix.md#decl-b089377bd907619f), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmCell](Defs.md#decl-36e8239d9f1fd59e), [TensorCore.GemmCell.output](Defs.md#decl-d8688321b8d2ae7f), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.GemmFamily.Contains](Family.md#decl-eaee8494d54b2afc), [TensorCore.MatrixWithin](Family.md#decl-71221945e17a1cdc), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PaperSpec.Matrix](Specification/Matrix.md#decl-0b93e30a9665e8db), [TensorCore.PaperSpec.wmmaGemmBits](Specification/Matrix.md#decl-50cf3300dfca2e74), [TensorCore.PaperSpec.wmmaModel](Specification/GemmEquivalence.md#decl-419ac65204c32de1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.analyzeGemm](Analysis.md#decl-8b640af4e4509e78), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.gemm](Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmBits](Defs.md#decl-adba0115aad6bb7b), [TensorCore.gemmIdeal](Defs.md#decl-1f55842952d81ccc), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-810b5bd68276af9d"></a>

<details>
<summary><code>TensorCore.familyError_nonneg</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L201)

```lean
theorem familyError_nonneg (model : WmmaGemmModel) (k : ℕ) (cfg : GemmBoundConfig) :
    0 ≤ familyError model k cfg := by
  unfold familyError
  split
  · exact Rat.le_refl
  · exact Rat.mul_nonneg Rat.natCast_nonneg
      (Rat.le_of_lt (staticBudget_positive _ _ _ _))
```

**Supporting proofs:** [TensorCore.staticBudget_positive](../TC/Program/Bounds/Scales.md#decl-52e870bce380a2a2)

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.InstructionPath](../TC/Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](../TC/Instruction.md#decl-edd55ab325073d15), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.WmmaGemmModel.path](Defs.md#decl-860954743cbdf9bb), [TensorCore.familyError](Family.md#decl-966b1b857128f203), [TensorCore.gemmBlockCount](Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmStaticError](Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.staticBudget](../TC/StaticBudget.md#decl-2759d010c1c6063d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.familyCheck_at_bound](Family.md#decl-d941bddfda43e9d1)

</details>

</details>

<a id="decl-d941bddfda43e9d1"></a>

<details>
<summary><code>TensorCore.familyCheck_at_bound</code></summary>

[Lean source](../../../TensorCore/Gemm/Family.lean#L209)

```lean
theorem familyCheck_at_bound (model : WmmaGemmModel) (k : ℕ) (f : GemmFamily)
    (cfg : GemmBoundConfig) (tol : ℚ) (h : familyCheck model k f cfg tol = true) :
    familyCheck model k f cfg (familyError model k cfg) = true := by
  simp only [familyCheck, Bool.and_eq_true, decide_eq_true_eq] at h ⊢
  exact ⟨⟨⟨h.1.1.1, h.1.1.2.1, h.1.1.2.2.1, familyError_nonneg model k cfg⟩, h.1.2⟩, Rat.le_refl⟩
```

**Supporting proofs:** [TensorCore.familyError_nonneg](Family.md#decl-810b5bd68276af9d)

**Definitions and types:** [TensorCore.GemmBoundConfig](Bounds.md#decl-67b679b61e10d595), [TensorCore.GemmFamily](Family.md#decl-af56fb1d41ab54f1), [TensorCore.WmmaGemmModel](Defs.md#decl-a44ab2c261ff842b), [TensorCore.familyCheck](Family.md#decl-43a043749bf35c52), [TensorCore.familyConditions](Family.md#decl-b456e480e468a315), [TensorCore.familyError](Family.md#decl-966b1b857128f203)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.entryFamilyCheck_matrix_error](EntryFamily.md#decl-989115036d6b8544)

</details>

</details>
