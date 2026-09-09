# TensorCore.EFT.Scalar

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-41be156bbdd880fc"></a>

<details>
<summary><code>TensorCore.BlockTrace.scalarPredicateIn</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L14)

```lean
/-- The paper's component predicate with separate minimum-grid, coefficient, and absolute
range budgets. This is a separately named general predicate; the FP32 baseline is unchanged.
The final range is FP32, even when the correction format is FP64. -/
def BlockTrace.scalarPredicateIn (t : BlockTrace) (f : Format) : Bool :=
  decide f.WellFormed && decide (f.emin - f.fractionBits ≤ t.supportExponent) &&
  (t.lowParts == t.lowCoefficients.map fun (z : ℤ) => (z : ℚ) * pow2 t.supportExponent) &&
  decide (magnitudeSum t.lowCoefficients < 2 ^ (f.fractionBits + 1)) &&
  decide ((magnitudeSum t.lowCoefficients : ℚ) * pow2 t.supportExponent ≤ f.maxFinite) &&
  representableBinary f t.output.value && representableBinary f t.overlap &&
  representableBinary f t.retainedSum &&
  decide (absQ (t.retainedSum + sumQ t.lowParts) ≤ maxFinite32)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Core/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.Regression.scalar64_corrects_midpoint](Regression/ScalarEFT.md#decl-18ee9a4ee42888ea), [TensorCore.Regression.scalar64_subnormal_guard_rejects](Regression/ScalarEFT.md#decl-6132856fad76f2bb), [TensorCore.defaultExtraction_scalar](ExtractionGrid.md#decl-b88738f25d94e135), [TensorCore.evalBlock_scalarCorrectedIn_correct](Scalar.md#decl-f06458fcf778275c), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_eq](Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrectedIn_isSome_iff](Scalar.md#decl-a76f1dddc089a764), [TensorCore.scalarCorrectedIn_rejects](Scalar.md#decl-135cb7a9f7ad6ebe), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4)

</details>

</details>

<a id="decl-a22da99ec6e9edd7"></a>

<details>
<summary><code>TensorCore.BlockTrace.scalarCorrectedInUnchecked</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L25)

```lean
/-- Scalar residual additions and overlap subtraction in f, then direct nearest-even FP32
rounding of the exact final sum. No rounded addition in f occurs at the final boundary. -/
def BlockTrace.scalarCorrectedInUnchecked (t : BlockTrace) (f : Format) : Option F32 :=
  (naiveSumBinary f t.lowParts).bind fun etot =>
    (binaryAdd f t.output.value (-t.overlap)).bind fun h =>
      round32 .nearestEven (h + etot)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.binaryAdd](../Core/Binary/ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.naiveSumBinary](../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedIn_eq](Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrectedIn_isSome_iff](Scalar.md#decl-a76f1dddc089a764), [TensorCore.scalarCorrectedIn_rejects](Scalar.md#decl-135cb7a9f7ad6ebe)

</details>

</details>

<a id="decl-d0c6f5b79e887f69"></a>

<details>
<summary><code>TensorCore.BlockTrace.scalarCorrectedIn</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L30)

```lean
def BlockTrace.scalarCorrectedIn (t : BlockTrace) (f : Format) : Option F32 :=
  if t.scalarPredicateIn f then t.scalarCorrectedInUnchecked f else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.Regression.scalar64_corrects_midpoint](Regression/ScalarEFT.md#decl-18ee9a4ee42888ea), [TensorCore.Regression.scalar64_subnormal_guard_rejects](Regression/ScalarEFT.md#decl-6132856fad76f2bb), [TensorCore.Regression.scalar_generic_invalid_format_rejects](Regression/ScalarEFT.md#decl-f7a094e3217d8fda), [TensorCore.defaultExtraction_scalar](ExtractionGrid.md#decl-b88738f25d94e135), [TensorCore.evalBlock_scalarCorrectedIn_correct](Scalar.md#decl-f06458fcf778275c), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_eq](Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrectedIn_fp32_of_predicate](Scalar.md#decl-b9151e7be93b8672), [TensorCore.scalarCorrectedIn_isSome_iff](Scalar.md#decl-a76f1dddc089a764), [TensorCore.scalarCorrectedIn_rejects](Scalar.md#decl-135cb7a9f7ad6ebe)

</details>

</details>

<a id="decl-56c2b8a041adc97f"></a>

<details>
<summary><code>TensorCore.scalarOverlap_exact</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L34)

```lean
/-- Lemma IV.10 in any well-formed correction format. -/
theorem scalarOverlap_exact (t : BlockTrace) (f : Format) (hf : f.WellFormed)
    (hH : f.FiniteValue t.retainedSum) :
    binaryAdd f t.output.value (-t.overlap) = some t.retainedSum := by
  have hr : t.output.value + -t.overlap = t.retainedSum := by
    unfold BlockTrace.overlap; grind
  rw [binaryAdd_exact f hf _ _ (by rw [hr]; exact hH), hr]
```

**Supporting proofs:** [TensorCore.binaryAdd_exact](../Core/Binary/ScalarSum.md#decl-3e2f947ce0bc4931)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.FiniteValue](../Core/Defs.md#decl-e3dc9cecad983d99), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.binaryAdd](../Core/Binary/ScalarSum.md#decl-9bdd2a014e05d482)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2)

</details>

</details>

<a id="decl-ced7339afa66e1f2"></a>

<details>
<summary><code>TensorCore.scalarCorrectedInUnchecked_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L41)

```lean
theorem scalarCorrectedInUnchecked_eq (t : BlockTrace) (f : Format)
    (h : t.scalarPredicateIn f = true) :
    t.scalarCorrectedInUnchecked f = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.scalarPredicateIn at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨⟨hf, h1⟩, hgrid⟩, hmag⟩, hrange⟩, _⟩, _⟩, hH⟩, _⟩ := h
  have hsum : naiveSumBinary f t.lowParts = some (sumQ t.lowParts) := by
    rw [hgrid, naiveSumBinary_exact f hf _ h1 _ hmag hrange, sum_coefficients]
  unfold BlockTrace.scalarCorrectedInUnchecked
  rw [hsum, Option.bind_some, scalarOverlap_exact t f hf (representableBinary_finite f hf hH),
    Option.bind_some, retained_add_low]
```

**Supporting proofs:** [TensorCore.naiveSumBinary_exact](../Core/Binary/ScalarSum.md#decl-415a2ea1e64c6184), [TensorCore.representableBinary_finite](../Core/Binary/ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.scalarOverlap_exact](Scalar.md#decl-56c2b8a041adc97f), [TensorCore.sum_coefficients](../Core/Exact.md#decl-005e2ad99fe60fa3)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryAdd](../Core/Binary/ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.naiveSumBinary](../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Core/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrectedIn_eq](Scalar.md#decl-f7acf9a4b4bc62b9)

</details>

</details>

<a id="decl-f7acf9a4b4bc62b9"></a>

<details>
<summary><code>TensorCore.scalarCorrectedIn_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L53)

```lean
theorem scalarCorrectedIn_eq (t : BlockTrace) (f : Format) (h : t.scalarPredicateIn f = true) :
    t.scalarCorrectedIn f = round32 .nearestEven t.block.exactDot := by
  simp only [BlockTrace.scalarCorrectedIn, h, ↓reduceIte, scalarCorrectedInUnchecked_eq t f h]
```

**Supporting proofs:** [TensorCore.scalarCorrectedInUnchecked_eq](Scalar.md#decl-ced7339afa66e1f2)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_fp32_of_predicate](Scalar.md#decl-b9151e7be93b8672)

</details>

</details>

<a id="decl-135cb7a9f7ad6ebe"></a>

<details>
<summary><code>TensorCore.scalarCorrectedIn_rejects</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L57)

```lean
theorem scalarCorrectedIn_rejects (t : BlockTrace) (f : Format)
    (h : t.scalarPredicateIn f = false) : t.scalarCorrectedIn f = none := by
  simp [BlockTrace.scalarCorrectedIn, h]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-339eec1a25f718e9"></a>

<details>
<summary><code>TensorCore.scalarCorrectedIn_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L62)

```lean
/-- Corollary IV.11: any accepted correction format yields nearest-even FP32 bits of S. -/
theorem scalarCorrectedIn_correct (t : BlockTrace) (f : Format) (h : t.scalarPredicateIn f = true) :
    ∃ b, t.scalarCorrectedIn f = some b ∧ NearestEven32 t.block.exactDot b := by
  rw [scalarCorrectedIn_eq t f h]
  apply round32_nearestEven_correct
  unfold BlockTrace.scalarPredicateIn at h
  simp only [Bool.and_eq_true, decide_eq_true_eq] at h
  rw [← retained_add_low]
  exact h.2
```

**Supporting proofs:** [TensorCore.retained_add_low](Extraction.md#decl-da77fbfd62ee1185), [TensorCore.round32_nearestEven_correct](../Core/CorrectRounding.md#decl-213324c196c49312), [TensorCore.scalarCorrectedIn_eq](Scalar.md#decl-f7acf9a4b4bc62b9)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representableBinary](../Core/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_scalarCorrectedIn_correct](Scalar.md#decl-f06458fcf778275c), [TensorCore.scalarCorrectedIn_isSome_iff](Scalar.md#decl-a76f1dddc089a764)

</details>

</details>

<a id="decl-a76f1dddc089a764"></a>

<details>
<summary><code>TensorCore.scalarCorrectedIn_isSome_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L71)

```lean
theorem scalarCorrectedIn_isSome_iff (t : BlockTrace) (f : Format) :
    (t.scalarCorrectedIn f).isSome = true ↔ t.scalarPredicateIn f = true := by
  constructor
  · intro h
    unfold BlockTrace.scalarCorrectedIn at h
    split at h
    · assumption
    · simp at h
  · intro hp
    obtain ⟨b, hb, _⟩ := scalarCorrectedIn_correct t f hp
    rw [hb]; rfl
```

**Supporting proofs:** [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.evalBlock_scalarCorrectedIn_correct](Scalar.md#decl-f06458fcf778275c)

</details>

</details>

<a id="decl-f06458fcf778275c"></a>

<details>
<summary><code>TensorCore.evalBlock_scalarCorrectedIn_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L84)

```lean
/-- A returned correction rounds the independent original-input ideal. -/
theorem evalBlock_scalarCorrectedIn_correct {p : Profile} {x : BlockInput p} {t : BlockTrace}
    {z : ℚ} {b : F32} (f : Format) (h : evalBlock x = .ok t) (hz : exactDot x = some z)
    (hb : t.scalarCorrectedIn f = some b) : NearestEven32 z b := by
  have hp : t.scalarPredicateIn f = true :=
    (scalarCorrectedIn_isSome_iff t f).mp (by rw [hb]; rfl)
  obtain ⟨b', hb', hn⟩ := scalarCorrectedIn_correct t f hp
  rw [hb] at hb'
  cases Option.some.inj hb'
  simp only [exactDot, evalBlock_prepared h, Option.map_some] at hz
  rw [← Option.some.inj hz]
  exact hn
```

**Supporting proofs:** [TensorCore.evalBlock_prepared](../TC/StageResiduals.md#decl-7b1107ad8e7189d9), [TensorCore.scalarCorrectedIn_correct](Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedIn_isSome_iff](Scalar.md#decl-a76f1dddc089a764)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.ModelError](../TC/Block.md#decl-f7be0c438a4d4d1d), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PreparedBlock](../TC/Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.evalBlock](../TC/Block.md#decl-58fdfbbb09a9ba58), [TensorCore.exactDot](../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b8105d432e4f8983"></a>

<details>
<summary><code>TensorCore.scalarCorrectedInUnchecked_fp32</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L98)

```lean
/-- The FP32 executor retains exactly the existing operation sequence. The generic
predicate is separate because its absolute-range test covers more possible grids. -/
theorem scalarCorrectedInUnchecked_fp32 (t : BlockTrace) :
    t.scalarCorrectedInUnchecked fp32 = t.scalarCorrectedUnchecked := by
  simp only [BlockTrace.scalarCorrectedInUnchecked, BlockTrace.scalarCorrectedUnchecked,
    naiveSumBinary_fp32, binaryAdd_fp32]
```

**Supporting proofs:** [TensorCore.naiveSumBinary_fp32](../Core/Binary/ScalarSum.md#decl-b47c7749eb2a817a)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarCorrectedUnchecked](Extraction.md#decl-b298427558415577), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp32Add](../Core/ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.naiveSum32](../Core/ScalarSum.md#decl-928516c1237c62d4), [TensorCore.naiveSumBinary](../Core/Binary/ScalarSum.md#decl-1f7bd75282742e86), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b10bfc089342891a"></a>

<details>
<summary><code>TensorCore.representableBinary_fp32</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L104)

```lean
theorem representableBinary_fp32 (x : ℚ) : representableBinary fp32 x = representable32 x := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.representable32](../Core/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.representableBinary](../Core/Binary/ScalarSum.md#decl-983cd49dc90d1170)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f553bd8760a2c5c4"></a>

<details>
<summary><code>TensorCore.scalarPredicate_implies_in_fp32</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L108)

```lean
/-- Every accepted baseline FP32 case also satisfies the paper's generic range predicate. -/
theorem scalarPredicate_implies_in_fp32 (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarPredicateIn fp32 = true := by
  unfold BlockTrace.scalarPredicate at h
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq] at h
  obtain ⟨⟨⟨⟨⟨⟨⟨h1, h2⟩, hgrid⟩, hmag⟩, hD⟩, ho⟩, hH⟩, hr⟩ := h
  unfold BlockTrace.scalarPredicateIn
  simp only [Bool.and_eq_true, decide_eq_true_eq, beq_iff_eq, representableBinary_fp32]
  exact ⟨⟨⟨⟨⟨⟨⟨⟨by decide, h1⟩, hgrid⟩, hmag⟩,
    coefficient_range_of_grid fp32 _ _ h2 hmag⟩, hD⟩, ho⟩, hH⟩, hr⟩
```

**Supporting proofs:** [TensorCore.coefficient_range_of_grid](../Core/Binary/ScalarSum.md#decl-427e226844e8fe51)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.lowCoefficients](Extraction.md#decl-a13088cbcb9f6e28), [TensorCore.BlockTrace.lowParts](Defs.md#decl-a1697249f111893d), [TensorCore.BlockTrace.overlap](Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.retainedSum](Defs.md#decl-577bbe4b7295f20a), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](Scalar.md#decl-41be156bbdd880fc), [TensorCore.BlockTrace.supportExponent](Extraction.md#decl-3d45598c93a47213), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.magnitudeSum](../Core/Sum.md#decl-87fa253b5e1d3c24), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.representable32](../Core/ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.representableBinary](../Core/Binary/ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.scalarCorrectedIn_fp32_of_predicate](Scalar.md#decl-b9151e7be93b8672)

</details>

</details>

<a id="decl-b9151e7be93b8672"></a>

<details>
<summary><code>TensorCore.scalarCorrectedIn_fp32_of_predicate</code></summary>

[Lean source](../../../TensorCore/EFT/Scalar.lean#L118)

```lean
theorem scalarCorrectedIn_fp32_of_predicate (t : BlockTrace) (h : t.scalarPredicate = true) :
    t.scalarCorrectedIn fp32 = t.scalarCorrected := by
  rw [scalarCorrectedIn_eq t fp32 (scalarPredicate_implies_in_fp32 t h), scalarCorrected_eq t h]
```

**Supporting proofs:** [TensorCore.scalarCorrectedIn_eq](Scalar.md#decl-f7acf9a4b4bc62b9), [TensorCore.scalarCorrected_eq](Extraction.md#decl-f5da772603f2c94b), [TensorCore.scalarPredicate_implies_in_fp32](Scalar.md#decl-f553bd8760a2c5c4)

**Definitions and types:** [TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.scalarCorrected](Extraction.md#decl-d043d5f94dfed74a), [TensorCore.BlockTrace.scalarCorrectedIn](Scalar.md#decl-d0c6f5b79e887f69), [TensorCore.BlockTrace.scalarPredicate](Extraction.md#decl-8144db00332cc0f8), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.PreparedBlock.exactDot](../TC/Block.md#decl-32d061749cae163e), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
