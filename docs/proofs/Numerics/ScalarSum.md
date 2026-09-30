# TensorCore.Numerics.ScalarSum

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-c4f5ccdb5e5b9b02"></a>

<details>
<summary><code>TensorCore.fp32Add</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L10)

```lean
/-- Value of a correctly rounded FP32 addition; `none` outside the finite range. -/
def fp32Add (x y : ℚ) : Option ℚ := (round32 .nearestEven (x + y)).bind value32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrectedUnchecked](../EFT/Extraction.md#decl-b298427558415577), [TensorCore.binaryAdd_fp32](Binary/ScalarSum.md#decl-be66ffdd3fa0d467), [TensorCore.fp32Add_exact](ScalarSum.md#decl-91c0a32b3579d248), [TensorCore.naiveSum32From](ScalarSum.md#decl-6050fef9f9f84b05), [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.naiveSumBinaryFrom_fp32](Binary/ScalarSum.md#decl-33f05aff01d9a068), [TensorCore.scalarCorrectedInUnchecked_fp32](../EFT/Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d)

</details>

</details>

<a id="decl-0d0245dc39441bdb"></a>

<details>
<summary><code>TensorCore.finiteValue32_abs_le</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L13)

```lean
/-- Every finite FP32 value lies within `maxFinite32`. -/
theorem finiteValue32_abs_le {z : ℚ} (h : FiniteValue32 z) : absQ z ≤ maxFinite32 := by
  obtain ⟨k, e, _, he2, hk, rfl⟩ := h
  have hq := pow2_pos (e - 23)
  rw [absQ_mul_pos _ _ hq, absQ_intCast]
  have hk' : ((k.natAbs : ℤ) : ℚ) ≤ (16777215 : ℚ) := by
    have h1 : (k.natAbs : ℤ) ≤ 16777215 := by omega
    have h2 := Rat.intCast_le_intCast.mpr h1
    simpa using h2
  have hgrid : pow2 (e - 23) ≤ pow2 104 := pow2_le_of_le (by omega)
  have hnn : (0 : ℚ) ≤ ((k.natAbs : ℤ) : ℚ) := Rat.intCast_nonneg.mpr (by omega)
  have step : ((k.natAbs : ℤ) : ℚ) * pow2 (e - 23) ≤ 16777215 * pow2 104 :=
    calc ((k.natAbs : ℤ) : ℚ) * pow2 (e - 23)
        ≤ ((k.natAbs : ℤ) : ℚ) * pow2 104 := Rat.mul_le_mul_of_nonneg_left hgrid hnn
      _ ≤ 16777215 * pow2 104 :=
          Rat.mul_le_mul_of_nonneg_right hk' (Rat.le_of_lt (pow2_pos _))
  have hmax : maxFinite32 = (16777215 : ℚ) * pow2 104 := by decide +kernel
  rw [hmax]
  exact step
```

**Supporting proofs:** [TensorCore.absQ_intCast](Exact.md#decl-5369402afa8a06d2), [TensorCore.absQ_mul_pos](Exact.md#decl-5608efce37c35b7f), [TensorCore.pow2_le_of_le](Exact.md#decl-064be6edf8651285), [TensorCore.pow2_pos](Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.round32_canonical](RoundTrip.md#decl-253dec4b19f59f2b), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda)

</details>

</details>

<a id="decl-372249100bf5e929"></a>

<details>
<summary><code>TensorCore.round32_exact_of_finite</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L33)

```lean
/-- Lemma IV.7: a representable exact result is returned exactly by nearest-even conversion. -/
theorem round32_exact_of_finite {s : ℚ} (h : FiniteValue32 s) :
    ∃ b : F32, round32 .nearestEven s = some b ∧ value32 b = some s := by
  obtain ⟨b, hb, d, hd, hnear, _⟩ := round32_nearestEven_correct s (finiteValue32_abs_le h)
  have hz := hnear s h
  have h0 : absQ (s - s) = 0 := by
    have hss : s - s = 0 := by grind
    rw [hss]; simp [absQ]
  rw [h0] at hz
  have hle := (absQ_le_iff _ _).mp hz
  have hds : d = s := by grind
  subst hds
  exact ⟨b, hb, hd⟩
```

**Supporting proofs:** [TensorCore.absQ_le_iff](Exact.md#decl-3513a75c8e3035b2), [TensorCore.finiteValue32_abs_le](ScalarSum.md#decl-0d0245dc39441bdb), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.NearestEven32](RoundOp.md#decl-e8aa71a6813779de), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](Exact.md#decl-8dd63ab202e070d3), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.fp32Add_exact](ScalarSum.md#decl-91c0a32b3579d248), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda)

</details>

</details>

<a id="decl-91c0a32b3579d248"></a>

<details>
<summary><code>TensorCore.fp32Add_exact</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L46)

```lean
theorem fp32Add_exact (x y : ℚ) (h : FiniteValue32 (x + y)) : fp32Add x y = some (x + y) := by
  obtain ⟨b, hb, hv⟩ := round32_exact_of_finite h
  unfold fp32Add
  rw [hb]
  exact hv
```

**Supporting proofs:** [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.fp32Add](ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d)

</details>

</details>

<a id="decl-5c5b5245f25f71db"></a>

<details>
<summary><code>TensorCore.grid_finiteValue32</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L54)

```lean
/-- An integer multiple of a grid between `2^-149` and `2^104` with fewer than 24
significant bits is a finite FP32 value. -/
theorem grid_finiteValue32 (k ℓ : ℤ) (h1 : -149 ≤ ℓ) (h2 : ℓ ≤ 104)
    (hk : k.natAbs < 2 ^ 24) : FiniteValue32 ((k : ℚ) * pow2 ℓ) := by
  refine ⟨k, ℓ + 23, by omega, by omega, hk, ?_⟩
  have he : ℓ + 23 - 23 = ℓ := by omega
  rw [he]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155)

</details>

</details>

<a id="decl-6050fef9f9f84b05"></a>

<details>
<summary><code>TensorCore.naiveSum32From</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L61)

```lean
/-- Left-to-right correctly rounded FP32 summation from a starting value (Definition IV.6). -/
def naiveSum32From : ℚ → List ℚ → Option ℚ
  | acc, [] => some acc
  | acc, t :: ts => (fp32Add acc t).bind fun s => naiveSum32From s ts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.fp32Add](ScalarSum.md#decl-c4f5ccdb5e5b9b02)

<details>
<summary>Used by</summary>

[TensorCore.naiveSum32](ScalarSum.md#decl-928516c1237c62d4), [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155), [TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.naiveSumBinaryFrom_fp32](Binary/ScalarSum.md#decl-33f05aff01d9a068)

</details>

</details>

<a id="decl-928516c1237c62d4"></a>

<details>
<summary><code>TensorCore.naiveSum32</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L65)

```lean
def naiveSum32 (ts : List ℚ) : Option ℚ := naiveSum32From 0 ts
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.naiveSum32From](ScalarSum.md#decl-6050fef9f9f84b05)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrectedUnchecked](../EFT/Extraction.md#decl-b298427558415577), [TensorCore.Regression.scalar64_preserves_low_component](../Tests/EFT/ScalarEFT.md#decl-04af8db10d4464ca), [TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52), [TensorCore.naiveSumBinary_fp32](Binary/ScalarSum.md#decl-b47c7749eb2a817a), [TensorCore.scalarCorrectedInUnchecked_fp32](../EFT/Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d)

</details>

</details>

<a id="decl-e7c67e5a35d63155"></a>

<details>
<summary><code>TensorCore.naiveSum32From_exact</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L67)

```lean
theorem naiveSum32From_exact (ℓ : ℤ) (h1 : -149 ≤ ℓ) (h2 : ℓ ≤ 104)
    (a : ℤ) (zs : List ℤ) (hbound : a.natAbs + magnitudeSum zs < 2 ^ 24) :
    naiveSum32From ((a : ℚ) * pow2 ℓ) (zs.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) =
      some (((a + sumZ zs : ℤ) : ℚ) * pow2 ℓ) := by
  induction zs generalizing a with
  | nil => simp [naiveSum32From, sumZ]
  | cons z zs ih =>
    have hsum : (a : ℚ) * pow2 ℓ + (z : ℚ) * pow2 ℓ = ((a + z : ℤ) : ℚ) * pow2 ℓ := by
      rw [Rat.intCast_add]; grind
    have habs := Int.natAbs_add_le a z
    simp only [magnitudeSum] at hbound
    have hstep : fp32Add ((a : ℚ) * pow2 ℓ) ((z : ℚ) * pow2 ℓ) =
        some (((a + z : ℤ) : ℚ) * pow2 ℓ) := by
      rw [← hsum]
      apply fp32Add_exact
      rw [hsum]
      exact grid_finiteValue32 _ _ h1 h2 (by omega)
    have ih' := ih (a + z) (by omega)
    simp only [List.map_cons, naiveSum32From, hstep, Option.bind_some, ih']
    have hs : a + z + sumZ zs = a + sumZ (z :: zs) := by simp only [sumZ]; omega
    rw [hs]
```

**Supporting proofs:** [TensorCore.fp32Add_exact](ScalarSum.md#decl-91c0a32b3579d248), [TensorCore.grid_finiteValue32](ScalarSum.md#decl-5c5b5245f25f71db)

**Definitions and types:** [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.fp32Add](ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSum32From](ScalarSum.md#decl-6050fef9f9f84b05), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.naiveSum32_exact](ScalarSum.md#decl-48c821bc78dd7d52)

</details>

</details>

<a id="decl-48c821bc78dd7d52"></a>

<details>
<summary><code>TensorCore.naiveSum32_exact</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L93)

```lean
/-- Theorem IV.8: naive FP32 summation of integer multiples of one grid `2^ℓ`, with
`-149 ≤ ℓ ≤ 104`, is exact whenever the sum of absolute coefficients is below `2^24`.
Every prefix is representable, so the statement applies to any ordering by permuting the
input list; the coefficient sum is unchanged by permutation. -/
theorem naiveSum32_exact (ℓ : ℤ) (h1 : -149 ≤ ℓ) (h2 : ℓ ≤ 104) (zs : List ℤ)
    (hbound : magnitudeSum zs < 2 ^ 24) :
    naiveSum32 (zs.map fun (z : ℤ) => (z : ℚ) * pow2 ℓ) = some ((sumZ zs : ℚ) * pow2 ℓ) := by
  have h := naiveSum32From_exact ℓ h1 h2 0 zs (by simpa using hbound)
  unfold naiveSum32
  simpa using h
```

**Supporting proofs:** [TensorCore.naiveSum32From_exact](ScalarSum.md#decl-e7c67e5a35d63155)

**Definitions and types:** [TensorCore.magnitudeSum](Sum.md#decl-87fa253b5e1d3c24), [TensorCore.naiveSum32](ScalarSum.md#decl-928516c1237c62d4), [TensorCore.naiveSum32From](ScalarSum.md#decl-6050fef9f9f84b05), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.sumZ](Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d)

</details>

</details>

<a id="decl-8d15644ce94eb22f"></a>

<details>
<summary><code>TensorCore.representable32</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L101)

```lean
/-- Executable representability: nearest-even conversion returns the value itself. -/
def representable32 (x : ℚ) : Bool := (round32 .nearestEven x).bind value32 == some x
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.representable32_finite](ScalarSum.md#decl-04f29e613917ad68), [TensorCore.representableBinary_fp32](../EFT/Scalar.md#decl-b10bfc089342891a), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-04f29e613917ad68"></a>

<details>
<summary><code>TensorCore.representable32_finite</code></summary>

[Lean source](../../../TensorCore/Numerics/ScalarSum.lean#L103)

```lean
theorem representable32_finite {x : ℚ} (h : representable32 x = true) : FiniteValue32 x := by
  unfold representable32 at h
  cases hr : round32 .nearestEven x with
  | none => simp [hr] at h
  | some b =>
    simp only [hr, Option.bind_some, beq_iff_eq] at h
    exact value32_finite b x h
```

**Supporting proofs:** [TensorCore.value32_finite](EncodingProperties.md#decl-a66b8320dd17a2c9)

**Definitions and types:** [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.RoundingMode](RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.representable32](ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.round32](RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d)

</details>

</details>
