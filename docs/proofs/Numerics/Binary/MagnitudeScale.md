# TensorCore.Numerics.Binary.MagnitudeScale

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-bdac2b758fe29d65"></a>

<details>
<summary><code>TensorCore.decoded_normal_magnitude_lower</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/MagnitudeScale.lean#L7)

```lean
theorem decoded_normal_magnitude_lower (negative : Bool) (fraction : ℕ) (f : ℕ) (e : ℤ) :
    pow2 e ≤ absQ (Decoded.mk
      (if negative then -((2 ^ f + fraction : ℕ) : ℤ) else (2 ^ f + fraction : ℕ)) e f).value := by
  have hq := pow2_pos (e - f)
  have hm : ((2 ^ f : ℕ) : ℚ) ≤ ((2 ^ f + fraction : ℕ) : ℚ) :=
    Rat.natCast_le_natCast.mpr (by omega)
  have hmul := Rat.mul_le_mul_of_nonneg_right hm (Rat.le_of_lt hq)
  have heq : ((2 ^ f : ℕ) : ℚ) * pow2 (e - f) = pow2 e := by
    rw [← pow2_natCast, ← pow2_add]
    congr 1
    omega
  rw [heq] at hmul
  unfold Decoded.value
  cases negative <;> simp only [Bool.false_eq_true, ↓reduceIte, Rat.intCast_neg,
    Rat.intCast_natCast, Rat.neg_mul]
  · rw [absQ_mul_pos _ _ hq, absQ_of_nonneg Rat.natCast_nonneg]
    exact hmul
  · rw [absQ_neg, absQ_mul_pos _ _ hq, absQ_of_nonneg Rat.natCast_nonneg]
    exact hmul
```

**Supporting proofs:** [TensorCore.absQ_mul_pos](../Exact.md#decl-5608efce37c35b7f), [TensorCore.absQ_neg](../Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_add](../Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Exact.md#decl-997b22af00ef82dd), [TensorCore.pow2_pos](../Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.classifyNat_scale_le_of_magnitude](MagnitudeScale.md#decl-ca3faee92dc85564)

</details>

</details>

<a id="decl-ca3faee92dc85564"></a>

<details>
<summary><code>TensorCore.classifyNat_scale_le_of_magnitude</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/MagnitudeScale.lean#L27)

```lean
theorem classifyNat_scale_le_of_magnitude (f : Format) (n : ℕ) (d : Decoded)
    (hd : (classifyNat f n).finite = some d) (E : ℤ) (hE : f.emin ≤ E)
    (hm : absQ d.value < pow2 (E + 1)) (hn : d.significand ≠ 0) : d.rawScale ≤ E := by
  unfold classifyNat at hd
  dsimp only at hd
  split at hd
  · split at hd <;> simp [Classification.finite] at hd
  · split at hd
    · split at hd
      · simp only [Classification.finite, Option.some.injEq] at hd
        subst d
        exact absurd rfl hn
      · simp only [Classification.finite, Option.some.injEq] at hd
        subst d
        exact hE
    · simp only [Classification.finite, Option.some.injEq] at hd
      subst d
      have hl := decoded_normal_magnitude_lower
        (n / 2 ^ (f.fractionBits + f.exponentBits) != 0) (n % 2 ^ f.fractionBits)
        f.fractionBits (((n / 2 ^ f.fractionBits % 2 ^ f.exponentBits : ℕ) : ℤ) - f.bias)
      change ((n / 2 ^ f.fractionBits % 2 ^ f.exponentBits : ℕ) : ℤ) - f.bias ≤ E
      apply Classical.byContradiction
      intro hne
      have hp := pow2_le_of_le (show E + 1 ≤
        ((n / 2 ^ f.fractionBits % 2 ^ f.exponentBits : ℕ) : ℤ) - f.bias by omega)
      grind
```

**Supporting proofs:** [TensorCore.decoded_normal_magnitude_lower](MagnitudeScale.md#decl-bdac2b758fe29d65), [TensorCore.pow2_le_of_le](../Exact.md#decl-064be6edf8651285)

**Definitions and types:** [TensorCore.Classification](../Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.classifyNat](../Encoding.md#decl-52d401d7433cac5a), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
