# TensorCore.IEEE.LeanRounding64

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-459c5dd362ffb581"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.targetExponent64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanRounding64.lean#L10)

```lean
theorem targetExponent64_eq (m : ℕ) (e : ℤ) (hm : 0 < m) :
    Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e) =
      binaryConvExp fp64 ((m : ℚ) * pow2 e) - fp64.fractionBits := by
  rw [binaryConvExp, magnitudeExponent_dyadic m e hm]
  simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
    Float.Model.Format.mantissaBits,
    Float.Model.Format.minExponent, fp64, Format.emin]
  omega
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.magnitudeExponent_dyadic](LeanRounding.md#decl-0ef7cbf9638ce869)

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.firstPass64](LeanRounding64.md#decl-25a14bb65450486f), [TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb)

</details>

</details>

<a id="decl-1b6cc21d58f9cda6"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.secondPass64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanRounding64.lean#L19)

```lean
theorem secondPass64 (k : ℕ) (e : ℤ) (hk : k ≤ 2 ^ 53) (he : -1074 ≤ e) :
    shiftToTargetExponent Float.Model.Format.binary64 k e .exact =
      if k = 2 ^ 53 then (⟨2 ^ 52, false, false⟩, e + 1)
      else (⟨k, false, false⟩, e) := by
  by_cases hc : k = 2 ^ 53
  · subst k
    have ht : Float.Model.Format.binary64.targetExponent
        (Float.Model.totalExponent (2 ^ 53) e) = e + 1 := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Nat.log2_two_pow, Float.Model.Format.mantissaBits,
        Float.Model.Format.minExponent]
      omega
    simp only [shiftToTargetExponent, ht, shiftToExponent, show e + 1 - e = 1 from by omega,
      show (1 : ℤ).toNat = 1 from rfl, HShiftRight.hShiftRight, Nat.repeat,
      ExtendedMantissa.ofMantissaAndAccuracy, ExtendedMantissa.shiftRightOne,
      ↓reduceIte]
    rfl
  · have hl : k.log2 ≤ 52 := by
      by_cases hz : k = 0
      · simp [hz]
      · have := (Nat.log2_lt hz).mpr (show k < 2 ^ 53 by omega)
        omega
    have ht : Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent k e) ≤ e := by
      simp only [Float.Model.Format.targetExponent, Float.Model.totalExponent,
        Float.Model.Format.mantissaBits, Float.Model.Format.minExponent]
      omega
    have hn : (Float.Model.Format.binary64.targetExponent
        (Float.Model.totalExponent k e) - e).toNat = 0 := by omega
    simp [shiftToTargetExponent, shiftToExponent, hn, hc, HShiftRight.hShiftRight,
      Nat.repeat, ExtendedMantissa.ofMantissaAndAccuracy]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb)

</details>

</details>

<a id="decl-25a14bb65450486f"></a>

<details>
<summary><code>TensorCore.IEEE.LeanBridge.firstPass64</code></summary>

[Lean source](../../../TensorCore/IEEE/LeanRounding64.lean#L50)

```lean
theorem firstPass64 (m : ℕ) (e : ℤ) (hm : 0 < m) :
    let q := Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent m e)
    let d := decreaseExponent m e q
    let first := shiftToTargetExponent Float.Model.Format.binary64 d.1 d.2 .exact
    first.2 = q ∧ (first.1.roundedMantissa : ℤ) =
      rneInt ((m : ℚ) * pow2 e / pow2 q) := by
  intro q d first
  have hd : 0 < d.1 := by
    dsimp [d, decreaseExponent]
    rw [Nat.shiftLeft_eq]
    exact Nat.mul_pos hm (Nat.two_pow_pos _)
  have hv := decreaseExponent_value m e q
  have hq : Float.Model.Format.binary64.targetExponent (Float.Model.totalExponent d.1 d.2) = q := by
    rw [targetExponent64_eq d.1 d.2 hd, hv]
    exact (targetExponent64_eq m e hm).symm
  have he : d.2 ≤ q := by dsimp [d, decreaseExponent]; omega
  have hs : first = shiftToExponent d.1 d.2 .exact q := by
    dsimp only [first, shiftToTargetExponent]
    rw [hq]
  rw [hs]
  constructor
  · dsimp [shiftToExponent]; omega
  · rw [shiftToExponent_round_eq _ _ _ he, hv]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decreaseExponent_value](LeanRounding.md#decl-8bceb00d2c5415ab), [TensorCore.IEEE.LeanBridge.shiftToExponent_round_eq](LeanRounding.md#decl-14facc14bbf9c0d8), [TensorCore.IEEE.LeanBridge.targetExponent64_eq](LeanRounding64.md#decl-459c5dd362ffb581)

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.binaryConvExp](../Core/Binary/RoundOp.md#decl-627946dba132da21), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../Core/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb)

</details>

</details>
