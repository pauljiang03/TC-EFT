# TensorCore.Numerics.Binary.ResidualBudget

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-19d0467f0a8a4946"></a>

<details>
<summary><code>TensorCore.extraction_coefficient_bound</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ResidualBudget.lean#L11)

```lean
/-- Equation 20: each residual is smaller than `2^b` and lies on grid `2^ℓ`.
The subtraction of one uses the integer nature of its coefficient. -/
theorem extraction_coefficient_bound (zs : List ℤ) (b ℓ : ℤ) (P : ℕ)
    (hgrid : ℓ ≤ b)
    (hterm : ∀ z ∈ zs, absQ ((z : ℚ) * pow2 ℓ) < pow2 b)
    (hbudget : zs.length * (2 ^ (b - ℓ).toNat - 1) < 2 ^ P) :
    magnitudeSum zs < 2 ^ P := by
  have he : ((b - ℓ).toNat : ℤ) + ℓ = b := by omega
  have hcoeff : ∀ z ∈ zs, z.natAbs ≤ 2 ^ (b - ℓ).toNat - 1 := by
    intro z hz
    have h := hterm z hz
    rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast, Rat.intCast_natCast,
      ← he, pow2_add, pow2_natCast] at h
    have hc := Rat.natCast_lt_natCast.mp
      (Rat.lt_of_mul_lt_mul_right h (Rat.le_of_lt (pow2_pos ℓ)))
    omega
  exact Nat.lt_of_le_of_lt (magnitudeSum_le_length_mul zs _ hcoeff) hbudget
```

**Supporting proofs:** [TensorCore.absQ_intCast](../Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](../Exact.md#decl-5608efce37c35b7f), [TensorCore.magnitudeSum_le_length_mul](../Sum.md#decl-65d6fdeb3de8e2f3), [TensorCore.pow2_add](../Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Sum.md#decl-87fa253b5e1d3c24), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_coefficients](../../EFT/ExtractionGrid.md#decl-98cbe3951ade59c5), [TensorCore.naiveSumBinary_exact_of_extraction_bound](ResidualBudget.md#decl-bdd286d7badcc19f)

</details>

</details>

<a id="decl-bdd286d7badcc19f"></a>

<details>
<summary><code>TensorCore.naiveSumBinary_exact_of_extraction_bound</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ResidualBudget.lean#L29)

```lean
/-- Exact scalar consolidation from Equation 20, with the paper's independent
minimum-grid and finite-range requirements retained. Includes empty/all-zero lists. -/
theorem naiveSumBinary_exact_of_extraction_bound (f : Format) (hf : f.WellFormed)
    (b ℓ : ℤ) (hmin : f.emin - f.fractionBits ≤ ℓ) (hgrid : ℓ ≤ b)
    (zs : List ℤ) (hterm : ∀ z ∈ zs, absQ ((z : ℚ) * pow2 ℓ) < pow2 b)
    (hbudget : zs.length * (2 ^ (b - ℓ).toNat - 1) < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum zs : ℚ) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f (zs.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) =
      some ((sumZ zs : ℚ) * pow2 ℓ) :=
  naiveSumBinary_exact f hf ℓ hmin zs
    (extraction_coefficient_bound zs b ℓ _ hgrid hterm hbudget) hrange
```

**Supporting proofs:** [TensorCore.extraction_coefficient_bound](ResidualBudget.md#decl-19d0467f0a8a4946), [TensorCore.naiveSumBinary_exact](ScalarSum.md#decl-415a2ea1e64c6184)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
