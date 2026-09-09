# TensorCore.Gemm.ExactScalarAnalysis

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-9da785799450b67e"></a>

<details>
<summary><code>TensorCore.checkFiniteMultiply</code></summary>

[Lean source](../../../TensorCore/Gemm/ExactScalarAnalysis.lean#L7)

```lean
def checkFiniteMultiply (mode : BinaryRoundingMode) (a M : ℚ) (E : ℤ) : Option ScalarBound :=
  if a = 1 ∨ a = -1 then some ⟨M, 0⟩ else checkScalar ⟨fp32, mode⟩ (absQ a * M) E
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.exact_scalar_budgets](Regression/DecisionExtensions.md#decl-dc66e6e5ce7975e9), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteMultiply_sound](ExactScalarAnalysis.md#decl-77bbe6e519422fdb), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572)

</details>

</details>

<a id="decl-77bbe6e519422fdb"></a>

<details>
<summary><code>TensorCore.checkFiniteMultiply_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ExactScalarAnalysis.lean#L10)

```lean
theorem checkFiniteMultiply_sound (mode : BinaryRoundingMode) (a M : ℚ) (E : ℤ)
    (b : ScalarBound) (h : checkFiniteMultiply mode a M E = some b)
    (x : ℚ) (hf : fp32.FiniteValue x) (hx : absQ x ≤ M) :
    ∃ d, (ConversionStage.mk fp32 mode).convert (a * x) = some d ∧
      absQ d.value ≤ b.magnitude ∧ absQ (a * x - d.value) ≤ b.error := by
  unfold checkFiniteMultiply at h
  split at h
  next ha =>
    cases Option.some.inj h
    have hfinite : fp32.FiniteValue (a * x) := by
      rcases ha with rfl | rfl
      · simpa using hf
      · simpa [Rat.neg_mul] using fp32.finiteValue_neg hf
    obtain ⟨d, hd, hv⟩ := conversion_exact_value ⟨fp32, mode⟩ (by change fp32.WellFormed; decide) (a * x) hfinite
    refine ⟨d, hd, ?_, by simp [hv, Rat.sub_self, absQ]⟩
    rw [hv]
    rcases ha with rfl | rfl <;> simpa [Rat.neg_mul, absQ_neg] using hx
  next _ =>
    exact checkScalar_sound _ _ _ b h (a * x) (by
      rw [gemmAbs_mul]
      exact Rat.mul_le_mul_of_nonneg_left hx (absQ_nonneg a))
```

**Supporting proofs:** [TensorCore.Format.finiteValue_neg](../Core/Binary/CorrectRounding.md#decl-31d0c738bfc17cd1), [TensorCore.absQ_neg](../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.conversion_exact_value](ScalarAnalysis.md#decl-4af01d3e1e19ed79), [TensorCore.gemmAbs_mul](ScaledGemm.md#decl-be05cc60206155ae)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Core/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkFiniteMultiply](ExactScalarAnalysis.md#decl-9da785799450b67e), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332)

</details>

</details>

<a id="decl-6c901d609e08abd9"></a>

<details>
<summary><code>TensorCore.checkFiniteAdd</code></summary>

[Lean source](../../../TensorCore/Gemm/ExactScalarAnalysis.lean#L32)

```lean
def checkFiniteAdd (mode : BinaryRoundingMode) (A B : ℚ) (E : ℤ) : Option ScalarBound :=
  if A = 0 ∨ B = 0 then some ⟨A + B, 0⟩ else checkScalar ⟨fp32, mode⟩ (A + B) E
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.exact_scalar_budgets](Regression/DecisionExtensions.md#decl-dc66e6e5ce7975e9), [TensorCore.checkEpilogue](ScaledGemmAnalysis.md#decl-0bc331b6c15db37e), [TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332), [TensorCore.checkFiniteAdd_sound](ExactScalarAnalysis.md#decl-21c48024d8e4f9e0), [TensorCore.checkNativeScaledCell_inputConversion](NativeScaledGemm.md#decl-2c010389886bef3a), [TensorCore.checkScaledCell_inputConversion](ScaledGemmAnalysis.md#decl-cf8f65ecdf30f25e), [TensorCore.inferEpilogue](ScaledGemmAnalysis.md#decl-c09f0572310ed572)

</details>

</details>

<a id="decl-21c48024d8e4f9e0"></a>

<details>
<summary><code>TensorCore.checkFiniteAdd_sound</code></summary>

[Lean source](../../../TensorCore/Gemm/ExactScalarAnalysis.lean#L35)

```lean
theorem checkFiniteAdd_sound (mode : BinaryRoundingMode) (A B : ℚ) (E : ℤ)
    (b : ScalarBound) (h : checkFiniteAdd mode A B E = some b)
    (x y : FiniteBinary fp32) (hx : absQ x.value ≤ A) (hy : absQ y.value ≤ B) :
    ∃ d, (ConversionStage.mk fp32 mode).convert (x.value + y.value) = some d ∧
      absQ d.value ≤ b.magnitude ∧ absQ (x.value + y.value - d.value) ≤ b.error := by
  have hm : absQ (x.value + y.value) ≤ A + B := by
    have := absQ_add_le x.value y.value
    grind
  unfold checkFiniteAdd at h
  split at h
  next hz =>
    cases Option.some.inj h
    have hf : fp32.FiniteValue (x.value + y.value) := by
      rcases hz with hz | hz
      · have hx0 : x.value = 0 := by have := (absQ_le_iff _ _).mp hx; grind
        rw [hx0, Rat.zero_add]
        exact classifyNat_finiteValue fp32 (by decide) y.bits.toNat y.decoded y.valid
      · have hy0 : y.value = 0 := by have := (absQ_le_iff _ _).mp hy; grind
        rw [hy0, Rat.add_zero]
        exact classifyNat_finiteValue fp32 (by decide) x.bits.toNat x.decoded x.valid
    obtain ⟨d, hd, hv⟩ := conversion_exact_value ⟨fp32, mode⟩ (by change fp32.WellFormed; decide) _ hf
    exact ⟨d, hd, by simpa [hv] using hm, by simp [hv, Rat.sub_self, absQ]⟩
  next _ => exact checkScalar_sound _ _ _ b h _ hm
```

**Supporting proofs:** [TensorCore.absQ_add_le](../Core/Exact.md#decl-5c1117bc0bcece80), [TensorCore.absQ_le_iff](../Core/Exact.md#decl-3513a75c8e3035b2), [TensorCore.checkScalar_sound](ScalarAnalysis.md#decl-fde6315e382f7314), [TensorCore.classifyNat_finiteValue](../Core/Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.conversion_exact_value](ScalarAnalysis.md#decl-4af01d3e1e19ed79)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.ConversionStage.convert](../Core/Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.FiniteBinary](../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinary.value](../Core/Conversion.md#decl-91103d704c4a7c32), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Core/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ScalarBound](ScalarAnalysis.md#decl-4226e8a52e034c11), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.checkFiniteAdd](ExactScalarAnalysis.md#decl-6c901d609e08abd9), [TensorCore.checkScalar](ScalarAnalysis.md#decl-96e8393f74f6c382), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.checkEpilogue_sound](ScaledGemmAnalysis.md#decl-5f865e4aa38a6332)

</details>

</details>
