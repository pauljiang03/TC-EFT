# TensorCore.Core.EncodingProperties

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-e78f14689117d01e"></a>

<details>
<summary><code>TensorCore.classifyNat_fp32</code></summary>

[Lean source](../../../TensorCore/Core/EncodingProperties.lean#L8)

```lean
/-- `classifyNat fp32` with every format constant evaluated. -/
theorem classifyNat_fp32 (n : ℕ) : classifyNat fp32 n =
    if n / 8388608 % 256 = 255 then
      (if n % 8388608 = 0 then .infinity (n / 2147483648 != 0) else .nan)
    else if n / 8388608 % 256 = 0 then
      (if n % 8388608 = 0 then .zero (n / 2147483648 != 0)
       else .subnormal ⟨if (n / 2147483648 != 0) then -((n % 8388608 : ℕ) : ℤ)
         else ((n % 8388608 : ℕ) : ℤ), -126, 23⟩)
    else .normal ⟨if (n / 2147483648 != 0) then -((8388608 + n % 8388608 : ℕ) : ℤ)
      else ((8388608 + n % 8388608 : ℕ) : ℤ), ((n / 8388608 % 256 : ℕ) : ℤ) - 127, 23⟩ :=
  rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a), [TensorCore.fp32](Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.classifyNat32_finite](EncodingProperties.md#decl-2559eed0b9bbddd9), [TensorCore.decode32_below](../TC/MonotonicityRange.md#decl-a811310312b96b08), [TensorCore.decode32_fields](RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56)

</details>

</details>

<a id="decl-2559eed0b9bbddd9"></a>

<details>
<summary><code>TensorCore.classifyNat32_finite</code></summary>

[Lean source](../../../TensorCore/Core/EncodingProperties.lean#L19)

```lean
theorem classifyNat32_finite (n : ℕ) (d : Decoded)
    (h : (classifyNat fp32 n).finite = some d) : FiniteValue32 d.value := by
  rw [classifyNat_fp32] at h
  by_cases h1 : n / 8388608 % 256 = 255
  · by_cases h3 : n % 8388608 = 0 <;> simp [h1, h3, Classification.finite] at h
  · by_cases h2 : n / 8388608 % 256 = 0
    · by_cases h3 : n % 8388608 = 0
      · simp [h2, h3, Classification.finite] at h
        subst h
        exact ⟨0, -126, by decide, by decide, by decide, by simp [Decoded.value]⟩
      · simp [h2, h3, Classification.finite] at h
        subst h
        refine ⟨if (n / 2147483648 != 0) then -((n % 8388608 : ℕ) : ℤ)
          else ((n % 8388608 : ℕ) : ℤ), -126, by decide, by decide, ?_, ?_⟩
        · split <;> simp <;> omega
        · simp [Decoded.value]
    · simp [h1, h2, Classification.finite] at h
      subst h
      refine ⟨if (n / 2147483648 != 0) then -((8388608 + n % 8388608 : ℕ) : ℤ)
        else ((8388608 + n % 8388608 : ℕ) : ℤ),
        ((n / 8388608 % 256 : ℕ) : ℤ) - 127, ?_, ?_, ?_, ?_⟩
      · omega
      · omega
      · split <;> simp <;> omega
      · simp [Decoded.value]
```

**Supporting proofs:** [TensorCore.classifyNat_fp32](EncodingProperties.md#decl-e78f14689117d01e)

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a), [TensorCore.fp32](Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.decode32_finite](EncodingProperties.md#decl-bb951033d1fed7f8)

</details>

</details>

<a id="decl-bb951033d1fed7f8"></a>

<details>
<summary><code>TensorCore.decode32_finite</code></summary>

[Lean source](../../../TensorCore/Core/EncodingProperties.lean#L45)

```lean
theorem decode32_finite (b : F32) (d : Decoded) (h : decode32 b = some d) :
    FiniteValue32 d.value := by
  rw [decode32_eq] at h
  exact classifyNat32_finite b.toNat d h
```

**Supporting proofs:** [TensorCore.classifyNat32_finite](EncodingProperties.md#decl-2559eed0b9bbddd9), [TensorCore.decode32_eq](Encoding.md#decl-d61e64a2750bda68)

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.value32_finite](EncodingProperties.md#decl-a66b8320dd17a2c9)

</details>

</details>

<a id="decl-a66b8320dd17a2c9"></a>

<details>
<summary><code>TensorCore.value32_finite</code></summary>

[Lean source](../../../TensorCore/Core/EncodingProperties.lean#L51)

```lean
/-- Every value of a finite encoding has the arithmetic form. -/
theorem value32_finite (b : F32) (z : ℚ) (h : value32 b = some z) : FiniteValue32 z := by
  unfold value32 at h
  cases hd : decode32 b with
  | none => simp [hd] at h
  | some d =>
    simp [hd] at h
    subst h
    exact decode32_finite b d hd
```

**Supporting proofs:** [TensorCore.decode32_finite](EncodingProperties.md#decl-bb951033d1fed7f8)

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.FiniteValue32](Defs.md#decl-916e7e459d399e32), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.representable32_finite](ScalarSum.md#decl-04f29e613917ad68)

</details>

</details>

<a id="decl-69d2d972fbf20b0d"></a>

<details>
<summary><code>TensorCore.encode32_toNat</code></summary>

[Lean source](../../../TensorCore/Core/EncodingProperties.lean#L60)

```lean
theorem encode32_toNat (negative : Bool) (e k : ℤ) (hk0 : 0 ≤ k) (hk1 : k < 2 ^ 24)
    (he1 : -126 ≤ e) (he2 : e ≤ 127) :
    (encode32 negative e k).toNat = (if negative then 2 ^ 31 else 0) +
      (if k < 2 ^ 23 then k.toNat else (e + 127).toNat * 2 ^ 23 + (k - 2 ^ 23).toNat) := by
  unfold encode32
  rw [BitVec.toNat_ofNat]
  apply Nat.mod_eq_of_lt
  simp only [Nat.reducePow]
  split <;> split <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.encode32](RoundOp.md#decl-2d041a1e685373ec)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.encode32_quantum](EncodingProperties.md#decl-6f10a9a038e29fd3), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.PaperSpec.encode32_sign](../TC/Specification/Rounding.md#decl-b87aa592b2f7ce0a)

</details>

</details>

<a id="decl-e3ab18687cdc8f56"></a>

<details>
<summary><code>TensorCore.encode32_value</code></summary>

[Lean source](../../../TensorCore/Core/EncodingProperties.lean#L72)

```lean
/-- The constructed encoding decodes to the intended finite value, and its low bit is the
parity of the coefficient. -/
theorem encode32_value (negative : Bool) (e k : ℤ)
    (he1 : -126 ≤ e) (he2 : e ≤ 127) (hk0 : 0 ≤ k) (hk1 : k < 2 ^ 24)
    (hsub : 2 ^ 23 ≤ k ∨ e = -126) :
    value32 (encode32 negative e k) =
      some ((if negative then -(k : ℚ) else (k : ℚ)) * pow2 (e - 23)) ∧
    (encode32 negative e k).toNat % 2 = k.toNat % 2 := by
  have htoNat := encode32_toNat negative e k hk0 hk1 he1 he2
  unfold value32
  rw [decode32_eq, htoNat, classifyNat_fp32]
  simp only [Nat.reducePow, Int.reducePow] at *
  generalize hpay : (if k < 8388608 then k.toNat
    else (e + 127).toNat * 8388608 + (k - 8388608).toNat) = pay
  generalize hsgn : (if negative then 2147483648 else 0) = sgn
  have hsgn' : sgn = 0 ∨ sgn = 2147483648 := by
    rw [← hsgn]; cases negative <;> simp
  have hpay' : pay < 2147483648 := by
    rw [← hpay]; split <;> omega
  by_cases hk : k < 8388608
  · have hpk : pay = k.toNat := by rw [← hpay]; simp [hk]
    have hsubn : e = -126 := by rcases hsub with h | h <;> omega
    subst hsubn
    have hexp : (sgn + pay) / 8388608 % 256 = 0 := by
      rcases hsgn' with h | h <;> subst h <;> omega
    have hfrac : (sgn + pay) % 8388608 = pay := by
      rcases hsgn' with h | h <;> subst h <;> omega
    have hneg : ((sgn + pay) / 2147483648 != 0) = negative := by
      cases negative <;> simp at hsgn <;> subst hsgn <;> simp <;> omega
    simp only [hexp, hfrac, hneg]
    by_cases hz : pay = 0
    · have hk0' : k = 0 := by omega
      subst hk0'
      simp [hz, Decoded.value, Classification.finite]
      rcases hsgn' with h | h <;> subst h <;> simp
    · simp only [hz, if_false, Nat.reduceEqDiff]
      simp [Decoded.value, hpk, Classification.finite]
      constructor
      · cases negative <;> simp [Int.max_eq_left hk0]
      · rcases hsgn' with h | h <;> subst h <;> omega
  · have hk' : 8388608 ≤ k := by omega
    have hpk : pay = (e + 127).toNat * 8388608 + (k - 8388608).toNat := by
      rw [← hpay]; simp [hk]
    have hexp : (sgn + pay) / 8388608 % 256 = (e + 127).toNat := by
      rcases hsgn' with h | h <;> subst h <;> omega
    have hexp1 : (e + 127).toNat ≠ 255 := by omega
    have hexp0 : (e + 127).toNat ≠ 0 := by omega
    have hfrac : (sgn + pay) % 8388608 = (k - 8388608).toNat := by
      rcases hsgn' with h | h <;> subst h <;> omega
    have hneg : ((sgn + pay) / 2147483648 != 0) = negative := by
      cases negative <;> simp at hsgn <;> subst hsgn <;> simp <;> omega
    simp only [hexp, hfrac, hneg, hexp1, hexp0, if_false]
    simp [Decoded.value, Classification.finite]
    constructor
    · have he0 : 0 ≤ e + 127 := by omega
      have hk0' : 0 ≤ k - 8388608 := by omega
      have hk' : 8388608 + (k - 8388608) = k := by omega
      cases negative <;> simp [Int.max_eq_left he0, Int.max_eq_left hk0', hk']
    · rcases hsgn' with h | h <;> subst h <;> omega
```

**Supporting proofs:** [TensorCore.classifyNat_fp32](EncodingProperties.md#decl-e78f14689117d01e), [TensorCore.decode32_eq](Encoding.md#decl-d61e64a2750bda68), [TensorCore.encode32_toNat](EncodingProperties.md#decl-69d2d972fbf20b0d)

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.encode32](RoundOp.md#decl-2d041a1e685373ec), [TensorCore.fp32](Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](Exact.md#decl-b52a0281b35514e3), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64)

</details>

</details>

<a id="decl-6f10a9a038e29fd3"></a>

<details>
<summary><code>TensorCore.encode32_quantum</code></summary>

[Lean source](../../../TensorCore/Core/EncodingProperties.lean#L131)

```lean
/-- The output quantum agrees with the encoding exponent, including subnormal/zero. -/
theorem encode32_quantum (negative : Bool) (e k : ℤ)
    (he1 : -126 ≤ e) (he2 : e ≤ 127) (hk0 : 0 ≤ k) (hk1 : k < 2 ^ 24)
    (hsub : 2 ^ 23 ≤ k ∨ e = -126) :
    outputQuantumExponent (encode32 negative e k) = e - 23 := by
  unfold outputQuantumExponent
  rw [encode32_toNat negative e k hk0 hk1 he1 he2]
  simp only [Nat.reducePow, Int.reducePow, emin32] at *
  cases negative <;> by_cases hk : k < 8388608 <;>
    simp only [hk, Bool.false_eq_true, ↓reduceIte] <;> omega
```

**Supporting proofs:** [TensorCore.encode32_toNat](EncodingProperties.md#decl-69d2d972fbf20b0d)

**Definitions and types:** [TensorCore.emin32](RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.encode32](RoundOp.md#decl-2d041a1e685373ec), [TensorCore.outputQuantumExponent](RoundOp.md#decl-70bb2de461b51682)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64)

</details>

</details>
