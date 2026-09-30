# TensorCore.Numerics.Binary.ScalarSum

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-6753e48a8fc8af99"></a>

<details>
<summary><code>TensorCore.Format.finiteValue_abs_le</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L11)

```lean
theorem Format.finiteValue_abs_le (f : Format) {z : ℚ} (h : f.FiniteValue z) :
    absQ z ≤ f.maxFinite := by
  obtain ⟨k, e, _, he, hk, rfl⟩ := h
  rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast]
  have hk' : ((k.natAbs : ℤ) : ℚ) ≤ ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) := by
    rw [Rat.intCast_natCast]
    exact Rat.natCast_le_natCast.mpr (by omega)
  exact Rat.le_trans
    (Rat.mul_le_mul_of_nonneg_left (pow2_le_of_le (by omega))
      (Rat.intCast_nonneg.mpr (by omega)))
    (Rat.mul_le_mul_of_nonneg_right hk' (Rat.le_of_lt (pow2_pos _)))
```

**Supporting proofs:** [TensorCore.absQ_intCast](../Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](../Exact.md#decl-5608efce37c35b7f), [TensorCore.pow2_le_of_le](../Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10)

</details>

</details>

<a id="decl-b12a2c49a9878d10"></a>

<details>
<summary><code>TensorCore.roundBinary_exact_of_finite</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L24)

```lean
/-- Correct rounding fixes a representable exact result (Lemma IV.7). -/
theorem roundBinary_exact_of_finite (f : Format) (hf : f.WellFormed) {s : ℚ}
    (h : f.FiniteValue s) :
    ∃ b, roundBinary f .nearestEven s = some b ∧ binaryValue f b = some s := by
  obtain ⟨b, hb, d, hd, hn, _⟩ := roundBinary_nearestEven_correct f hf s (f.finiteValue_abs_le h)
  have hz := hn s h
  have h0 : absQ (s - s) = 0 := by
    rw [show s - s = 0 by grind]; simp [absQ]
  rw [h0] at hz
  have hle := (absQ_le_iff _ _).mp hz
  have hds : d = s := by grind
  subst hds
  exact ⟨b, hb, hd⟩
```

**Supporting proofs:** [TensorCore.Format.finiteValue_abs_le](ScalarSum.md#decl-6753e48a8fc8af99), [TensorCore.absQ_le_iff](../Exact.md#decl-3513a75c8e3035b2), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.binaryAdd_exact](ScalarSum.md#decl-3e2f947ce0bc4931), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.exactFiniteWord_value](SignedBijection.md#decl-25318fd4bd410e4c)

</details>

</details>

<a id="decl-9bdd2a014e05d482"></a>

<details>
<summary><code>TensorCore.binaryAdd</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L38)

```lean
/-- Scalar nearest-even addition on values, rejecting exact sums outside the finite range. -/
def binaryAdd (f : Format) (x y : ℚ) : Option ℚ :=
  (roundBinary f .nearestEven (x + y)).bind (binaryValue f)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrectedInUnchecked](../../EFT/Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](../../EFT/ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_eq](../../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.Regression.scalar64_finite_boundary](../../Tests/EFT/ScalarEFT.md#decl-2400fe596e80a925), [TensorCore.binaryAdd_exact](ScalarSum.md#decl-3e2f947ce0bc4931), [TensorCore.binaryAdd_fp32](ScalarSum.md#decl-be66ffdd3fa0d467), [TensorCore.naiveSumBinaryFrom](ScalarSum.md#decl-a219f2ced8b0589e), [TensorCore.naiveSumBinaryFrom_exact](ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.scalarCorrectedInUnchecked_eq](../../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarOverlap_exact](../../EFT/Scalar.md#decl-56c2b8a041adc97f)

</details>

</details>

<a id="decl-3e2f947ce0bc4931"></a>

<details>
<summary><code>TensorCore.binaryAdd_exact</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L41)

```lean
theorem binaryAdd_exact (f : Format) (hf : f.WellFormed) (x y : ℚ)
    (h : f.FiniteValue (x + y)) : binaryAdd f x y = some (x + y) := by
  obtain ⟨b, hb, hv⟩ := roundBinary_exact_of_finite f hf h
  unfold binaryAdd
  rw [hb]
  exact hv
```

**Supporting proofs:** [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryAdd](ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.scalarCorrected_eq](../../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.naiveSumBinaryFrom_exact](ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.scalarOverlap_exact](../../EFT/Scalar.md#decl-56c2b8a041adc97f)

</details>

</details>

<a id="decl-f22e396ecf09e13e"></a>

<details>
<summary><code>TensorCore.grid_finiteValue</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L48)

```lean
theorem grid_finiteValue (f : Format) (k ℓ : ℤ)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (h2 : ℓ ≤ f.emax - f.fractionBits)
    (hk : k.natAbs < 2 ^ (f.fractionBits + 1)) : f.FiniteValue ((k : ℚ) * pow2 ℓ) := by
  refine ⟨k, ℓ + f.fractionBits, by omega, by omega, hk, ?_⟩
  rw [show ℓ + f.fractionBits - f.fractionBits = ℓ by omega]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.grid_finiteValue_of_range](ScalarSum.md#decl-e550bdcb926669d5)

</details>

</details>

<a id="decl-e550bdcb926669d5"></a>

<details>
<summary><code>TensorCore.grid_finiteValue_of_range</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L55)

```lean
/-- The full grid/range condition of Theorem IV.8; no artificial upper bound on ℓ. -/
theorem grid_finiteValue_of_range (f : Format) (hf : f.WellFormed) (k ℓ : ℤ)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (hk : k.natAbs < 2 ^ (f.fractionBits + 1))
    (hr : absQ ((k : ℚ) * pow2 ℓ) ≤ f.maxFinite) : f.FiniteValue ((k : ℚ) * pow2 ℓ) := by
  by_cases h2 : ℓ ≤ f.emax - f.fractionBits
  · exact grid_finiteValue f k ℓ h1 h2 hk
  · let g := f.emax - f.fractionBits
    let n := (ℓ - g).toNat
    have hn : ℓ = g + (n : ℤ) := by dsimp [n, g]; omega
    have hv : (k : ℚ) * pow2 ℓ = ((k * (2 ^ n : ℕ) : ℤ) : ℚ) * pow2 g := by
      rw [hn, pow2_add, pow2_natCast, Rat.intCast_mul, Rat.intCast_natCast]
      grind
    rw [hv, absQ_mul_pos _ _ (pow2_pos _), absQ_intCast] at hr
    change (((k * (2 ^ n : ℕ)).natAbs : ℤ) : ℚ) * pow2 g ≤
      ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) * pow2 g at hr
    have hcoeff := Rat.le_of_mul_le_mul_right hr (pow2_pos g)
    rw [Rat.intCast_natCast] at hcoeff
    have hcoeff' := Rat.natCast_le_natCast.mp hcoeff
    rw [hv]
    exact grid_finiteValue f _ g (by have := f.emin_le_emax hf; dsimp [g]; omega)
      (Int.le_refl _) (by omega)
```

**Supporting proofs:** [TensorCore.Format.emin_le_emax](Encoding.md#decl-f21f4f9c313ac4d5), [TensorCore.absQ_intCast](../Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](../Exact.md#decl-5608efce37c35b7f), [TensorCore.grid_finiteValue](ScalarSum.md#decl-f22e396ecf09e13e), [TensorCore.pow2_add](../Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSumBinaryFrom_exact](ScalarSum.md#decl-1aba1a50159ac256)

</details>

</details>

<a id="decl-a219f2ced8b0589e"></a>

<details>
<summary><code>TensorCore.naiveSumBinaryFrom</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L76)

```lean
def naiveSumBinaryFrom (f : Format) : ℚ → List ℚ → Option ℚ
  | acc, [] => some acc
  | acc, t :: ts => (binaryAdd f acc t).bind fun s => naiveSumBinaryFrom f s ts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.binaryAdd](ScalarSum.md#decl-9bdd2a014e05d482)

<details>
<summary>Used by</summary>

[TensorCore.naiveSumBinary](ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.naiveSumBinaryFrom_exact](ScalarSum.md#decl-1aba1a50159ac256), [TensorCore.naiveSumBinaryFrom_fp32](ScalarSum.md#decl-33f05aff01d9a068), [TensorCore.naiveSumBinary_exact](ScalarSum.md#decl-415a2ea1e64c6184)

</details>

</details>

<a id="decl-1f7bd75282742e86"></a>

<details>
<summary><code>TensorCore.naiveSumBinary</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L80)

```lean
def naiveSumBinary (f : Format) (ts : List ℚ) : Option ℚ := naiveSumBinaryFrom f 0 ts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.naiveSumBinaryFrom](ScalarSum.md#decl-a219f2ced8b0589e)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrectedInUnchecked](../../EFT/Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.ExtractionGrid.eq20_exact_sum](../../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](../../EFT/ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_eq](../../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.Regression.scalar64_coarse_grid](../../Tests/EFT/ScalarEFT.md#decl-71ebab7703c3a1c5), [TensorCore.Regression.scalar64_prefix_overflow](../../Tests/EFT/ScalarEFT.md#decl-07c0da524b066707), [TensorCore.Regression.scalar64_preserves_low_component](../../Tests/EFT/ScalarEFT.md#decl-04af8db10d4464ca), [TensorCore.Regression.scalar64_subnormal_sum](../../Tests/EFT/ScalarEFT.md#decl-cb03ef10bf4e4cbd), [TensorCore.naiveSum64_exact](ScalarSum.md#decl-d74afdeb99860469), [TensorCore.naiveSumBinary_exact](ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.naiveSumBinary_exact_of_bitSpan](ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.naiveSumBinary_exact_perm](ScalarSum.md#decl-f78af6692d4089d7), [TensorCore.naiveSumBinary_fp32](ScalarSum.md#decl-b47c7749eb2a817a), [TensorCore.scalarCorrectedInUnchecked_eq](../../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](../../EFT/Scalar.md#decl-b8105d432e4f8983)

</details>

</details>

<a id="decl-1aba1a50159ac256"></a>

<details>
<summary><code>TensorCore.naiveSumBinaryFrom_exact</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L83)

```lean
/-- Every prefix remains representable, including under cancellation and gradual underflow. -/
theorem naiveSumBinaryFrom_exact (f : Format) (hf : f.WellFormed) (ℓ : ℤ)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (a : ℤ) (zs : List ℤ)
    (hbound : a.natAbs + magnitudeSum zs < 2 ^ (f.fractionBits + 1))
    (hrange : ((a.natAbs + magnitudeSum zs : ℕ) : ℚ) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinaryFrom f ((a : ℚ) * pow2 ℓ) (zs.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) =
      some (((a + sumZ zs : ℤ) : ℚ) * pow2 ℓ) := by
  induction zs generalizing a with
  | nil => simp [naiveSumBinaryFrom, sumZ]
  | cons z zs ih =>
    have hsum : (a : ℚ) * pow2 ℓ + (z : ℚ) * pow2 ℓ = ((a + z : ℤ) : ℚ) * pow2 ℓ := by
      rw [Rat.intCast_add]; grind
    have habs := Int.natAbs_add_le a z
    have hnext : (a + z).natAbs + magnitudeSum zs ≤ a.natAbs + magnitudeSum (z :: zs) := by
      simp only [magnitudeSum]; omega
    have hrnext : (((a + z).natAbs + magnitudeSum zs : ℕ) : ℚ) * pow2 ℓ ≤ f.maxFinite :=
      Rat.le_trans (Rat.mul_le_mul_of_nonneg_right (Rat.natCast_le_natCast.mpr hnext)
        (Rat.le_of_lt (pow2_pos _))) hrange
    have hrstep : absQ (((a + z : ℤ) : ℚ) * pow2 ℓ) ≤ f.maxFinite := by
      rw [absQ_mul_pos _ _ (pow2_pos _), absQ_intCast, Rat.intCast_natCast]
      exact Rat.le_trans (Rat.mul_le_mul_of_nonneg_right
        (Rat.natCast_le_natCast.mpr (Nat.le_add_right _ _)) (Rat.le_of_lt (pow2_pos _))) hrnext
    have hstep : binaryAdd f ((a : ℚ) * pow2 ℓ) ((z : ℚ) * pow2 ℓ) =
        some (((a + z : ℤ) : ℚ) * pow2 ℓ) := by
      rw [← hsum]
      apply binaryAdd_exact f hf
      rw [hsum]
      exact grid_finiteValue_of_range f hf _ ℓ h1 (by omega) hrstep
    have ih' := ih (a + z) (by omega) hrnext
    simp only [List.map_cons, naiveSumBinaryFrom, hstep, Option.bind_some, ih']
    rw [show a + z + sumZ zs = a + sumZ (z :: zs) by simp only [sumZ]; omega]
```

**Supporting proofs:** [TensorCore.absQ_intCast](../Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](../Exact.md#decl-5608efce37c35b7f), [TensorCore.binaryAdd_exact](ScalarSum.md#decl-3e2f947ce0bc4931), [TensorCore.grid_finiteValue_of_range](ScalarSum.md#decl-e550bdcb926669d5), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryAdd](ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.magnitudeSum](../Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinaryFrom](ScalarSum.md#decl-a219f2ced8b0589e), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSumBinary_exact](ScalarSum.md#decl-415a2ea1e64c6184)

</details>

</details>

<a id="decl-415a2ea1e64c6184"></a>

<details>
<summary><code>TensorCore.naiveSumBinary_exact</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L116)

```lean
/-- Theorem IV.8 with exactly the paper's minimum-grid, coefficient, and absolute-range
conditions. Applied to any ordering of the coefficient list, this proves exact naive sum. -/
theorem naiveSumBinary_exact (f : Format) (hf : f.WellFormed) (ℓ : ℤ)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (zs : List ℤ)
    (hbound : magnitudeSum zs < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum zs : ℚ) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f (zs.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) = some ((sumZ zs : ℚ) * pow2 ℓ) := by
  simpa [naiveSumBinary] using naiveSumBinaryFrom_exact f hf ℓ h1 0 zs
    (by simpa using hbound) (by simpa using hrange)
```

**Supporting proofs:** [TensorCore.naiveSumBinaryFrom_exact](ScalarSum.md#decl-1aba1a50159ac256)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.magnitudeSum](../Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.naiveSumBinaryFrom](ScalarSum.md#decl-a219f2ced8b0589e), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.eq20_exact_sum](../../EFT/ExtractionGrid.md#decl-802e16aa4b0d2cbf), [TensorCore.ExtractionGrid.scalarCorrected_eq](../../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.naiveSum64_exact](ScalarSum.md#decl-d74afdeb99860469), [TensorCore.naiveSumBinary_exact_of_bitSpan](ScalarSum.md#decl-a4f3aa81e29db78c), [TensorCore.naiveSumBinary_exact_of_extraction_bound](ResidualBudget.md#decl-bdd286d7badcc19f), [TensorCore.naiveSumBinary_exact_perm](ScalarSum.md#decl-f78af6692d4089d7), [TensorCore.scalarCorrectedInUnchecked_eq](../../EFT/Scalar.md#decl-ced7339afa66e1f2)

</details>

</details>

<a id="decl-427e226844e8fe51"></a>

<details>
<summary><code>TensorCore.coefficient_range_of_grid</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L125)

```lean
/-- A convenient grid upper bound discharges the separate absolute-range obligation. -/
theorem coefficient_range_of_grid (f : Format) (ℓ : ℤ) (L : ℕ)
    (h2 : ℓ ≤ f.emax - f.fractionBits) (hL : L < 2 ^ (f.fractionBits + 1)) :
    (L : ℚ) * pow2 ℓ ≤ f.maxFinite := by
  have hL' : (L : ℚ) ≤ ((2 ^ (f.fractionBits + 1) - 1 : ℕ) : ℚ) :=
    Rat.natCast_le_natCast.mpr (by omega)
  exact Rat.le_trans (Rat.mul_le_mul_of_nonneg_left (pow2_le_of_le h2) Rat.natCast_nonneg)
    (Rat.mul_le_mul_of_nonneg_right hL' (Rat.le_of_lt (pow2_pos _)))
```

**Supporting proofs:** [TensorCore.pow2_le_of_le](../Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarPredicate_implies_in_fp32](../../EFT/Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-d74afdeb99860469"></a>

<details>
<summary><code>TensorCore.naiveSum64_exact</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L134)

```lean
/-- Table IV, FP64 instance: precision 53 and minimum grid `2^-1074`. -/
theorem naiveSum64_exact (ℓ : ℤ) (h1 : -1074 ≤ ℓ) (zs : List ℤ)
    (hbound : magnitudeSum zs < 2 ^ 53)
    (hrange : (magnitudeSum zs : ℚ) * pow2 ℓ ≤ fp64.maxFinite) :
    naiveSumBinary fp64 (zs.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) =
      some ((sumZ zs : ℚ) * pow2 ℓ) :=
  naiveSumBinary_exact fp64 (by decide) ℓ h1 zs hbound hrange
```

**Supporting proofs:** [TensorCore.naiveSumBinary_exact](ScalarSum.md#decl-415a2ea1e64c6184)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.fp64](../Defs.md#decl-a9439171a8dcf9cb), [TensorCore.magnitudeSum](../Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.scalar64_coarse_grid](../../Tests/EFT/ScalarEFT.md#decl-71ebab7703c3a1c5)

</details>

</details>

<a id="decl-be66ffdd3fa0d467"></a>

<details>
<summary><code>TensorCore.binaryAdd_fp32</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L144)

```lean
/-- The generic executor specializes to the existing FP32 API, including failures.
These bridges live here because generic rounding already depends on FP32 scalar theory. -/
theorem binaryAdd_fp32 (x y : ℚ) : binaryAdd fp32 x y = fp32Add x y := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.binaryAdd](ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.fp32](../Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp32Add](../ScalarSum.md#decl-c4f5ccdb5e5b9b02)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-33f05aff01d9a068"></a>

<details>
<summary><code>TensorCore.naiveSumBinaryFrom_fp32</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L146)

```lean
theorem naiveSumBinaryFrom_fp32 (a : ℚ) (ts : List ℚ) :
    naiveSumBinaryFrom fp32 a ts = naiveSum32From a ts := by
  induction ts generalizing a with
  | nil => rfl
  | cons t ts ih =>
    simp only [naiveSumBinaryFrom, naiveSum32From, binaryAdd_fp32]
    congr 1
    funext s
    exact ih s
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.fp32](../Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp32Add](../ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.naiveSum32From](../ScalarSum.md#decl-6050fef9f9f84b05), [TensorCore.naiveSumBinaryFrom](ScalarSum.md#decl-a219f2ced8b0589e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSumBinary_fp32](ScalarSum.md#decl-b47c7749eb2a817a)

</details>

</details>

<a id="decl-b47c7749eb2a817a"></a>

<details>
<summary><code>TensorCore.naiveSumBinary_fp32</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L156)

```lean
theorem naiveSumBinary_fp32 (ts : List ℚ) : naiveSumBinary fp32 ts = naiveSum32 ts :=
  naiveSumBinaryFrom_fp32 0 ts
```

**Supporting proofs:** [TensorCore.naiveSumBinaryFrom_fp32](ScalarSum.md#decl-33f05aff01d9a068)

**Definitions and types:** [TensorCore.fp32](../Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.naiveSum32](../ScalarSum.md#decl-928516c1237c62d4), [TensorCore.naiveSumBinary](ScalarSum.md#decl-1f7bd75282742e86)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrectedInUnchecked_fp32](../../EFT/Scalar.md#decl-b8105d432e4f8983)

</details>

</details>

<a id="decl-f78af6692d4089d7"></a>

<details>
<summary><code>TensorCore.naiveSumBinary_exact_perm</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L160)

```lean
/-- Explicit any-order form of Theorem IV.8, relative to the original coefficient sum. -/
theorem naiveSumBinary_exact_perm (f : Format) (hf : f.WellFormed) (ℓ : ℤ)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (xs ys : List ℤ) (hperm : xs.Perm ys)
    (hbound : magnitudeSum xs < 2 ^ (f.fractionBits + 1))
    (hrange : (magnitudeSum xs : ℚ) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f (ys.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) =
      some ((sumZ xs : ℚ) * pow2 ℓ) := by
  rw [magnitudeSum_perm hperm] at hbound hrange
  rw [naiveSumBinary_exact f hf ℓ h1 ys hbound hrange, sumZ_perm hperm]
```

**Supporting proofs:** [TensorCore.magnitudeSum_perm](../Sum.md#decl-7163fe35317eedbf), [TensorCore.naiveSumBinary_exact](ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.sumZ_perm](../Sum.md#decl-e7bd85cdcec165e7)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.magnitudeSum](../Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a4f3aa81e29db78c"></a>

<details>
<summary><code>TensorCore.naiveSumBinary_exact_of_bitSpan</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L169)

```lean
theorem naiveSumBinary_exact_of_bitSpan (f : Format) (hf : f.WellFormed) (b ℓ : ℤ)
    (h1 : f.emin - f.fractionBits ≤ ℓ) (zs : List ℤ)
    (hterm : ∀ z ∈ zs, absQ ((z : ℚ) * pow2 ℓ) < pow2 (b + 1))
    (hspan : b - ℓ + 1 + (ceilLog2 zs.length : ℤ) ≤ f.fractionBits + 1)
    (hrange : (magnitudeSum zs : ℚ) * pow2 ℓ ≤ f.maxFinite) :
    naiveSumBinary f (zs.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) =
      some ((sumZ zs : ℚ) * pow2 ℓ) :=
  naiveSumBinary_exact f hf ℓ h1 zs (bitSpan_coefficient_bound zs b ℓ _ hterm hspan) hrange
```

**Supporting proofs:** [TensorCore.bitSpan_coefficient_bound](../Sum.md#decl-dd359e6ccc782af7), [TensorCore.naiveSumBinary_exact](ScalarSum.md#decl-415a2ea1e64c6184)

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.ceilLog2](../Sum.md#decl-19c2da9023bf4c87), [TensorCore.magnitudeSum](../Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSumBinary](ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](../Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-983cd49dc90d1170"></a>

<details>
<summary><code>TensorCore.representableBinary</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L178)

```lean
def representableBinary (f : Format) (x : ℚ) : Bool :=
  (roundBinary f .nearestEven x).bind (binaryValue f) == some x
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarPredicateIn](../../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.scalarCorrected_correct](../../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.representableBinary_finite](ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.representableBinary_fp32](../../EFT/Scalar.md#decl-b10bfc089342891a), [TensorCore.scalarCorrectedInUnchecked_eq](../../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](../../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarPredicate_implies_in_fp32](../../EFT/Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-d4d92bf55b290375"></a>

<details>
<summary><code>TensorCore.representableBinary_finite</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/ScalarSum.lean#L181)

```lean
theorem representableBinary_finite (f : Format) (hf : f.WellFormed) {x : ℚ}
    (h : representableBinary f x = true) : f.FiniteValue x := by
  unfold representableBinary at h
  cases hr : roundBinary f .nearestEven x with
  | none => simp [hr] at h
  | some b =>
    simp only [hr, Option.bind_some, beq_iff_eq] at h
    unfold binaryValue at h
    cases hd : (classify f b).finite with
    | none => simp [hd] at h
    | some d =>
      simp only [hd, Option.map_some, Option.some.injEq] at h
      rw [← h]
      exact classifyNat_finiteValue f hf b.toNat d hd
```

**Supporting proofs:** [TensorCore.classifyNat_finiteValue](Encoding.md#decl-1caf128b0fdea826)

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3), [TensorCore.representableBinary](ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.ExtractionGrid.scalarCorrected_eq](../../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.scalarCorrectedInUnchecked_eq](../../EFT/Scalar.md#decl-ced7339afa66e1f2)

</details>

</details>
