# TensorCore.EFT.Machine.Decode

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-ecc0485e43e051ac"></a>

<details>
<summary><code>TensorCore.EFMachine.Factor.decoded</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L13)

```lean
def Factor.decoded (x : Factor) : Decoded :=
  ⟨if x.negative then -(x.magnitude.toNat : ℤ) else x.magnitude.toNat,
    (x.raw.toNat : ℤ) - 256, x.fraction.toNat⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d)

</details>

</details>

<a id="decl-06e4f872dfe5c3b7"></a>

<details>
<summary><code>TensorCore.EFMachine.field_toNat</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L17)

```lean
theorem field_toNat (bits : F32) (shift width outWidth : ℕ)
    (hw : width ≤ outWidth) (hw' : width < 32) :
    (((bits >>> shift) &&& (((1 : F32) <<< width) - 1)).setWidth outWidth).toNat =
      bits.toNat / 2 ^ shift % 2 ^ width := by
  have hp : (2 ^ width : ℕ) < 2 ^ 32 :=
    Nat.pow_lt_pow_right (by decide) (by omega)
  have hm : (((1 : F32) <<< width) - 1).toNat = 2 ^ width - 1 := by
    rw [BitVec.toNat_sub_of_le]
    · rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
      change (1 * 2 ^ width) % 2 ^ 32 - 1 = _
      rw [Nat.one_mul, Nat.mod_eq_of_lt hp]
    · change 1 ≤ ((1 : F32) <<< width).toNat
      rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq]
      change 1 ≤ (1 * 2 ^ width) % 2 ^ 32
      rw [Nat.one_mul, Nat.mod_eq_of_lt hp]
      exact Nat.one_le_two_pow
  rw [BitVec.toNat_setWidth, BitVec.toNat_and, hm, BitVec.toNat_ushiftRight,
    Nat.shiftRight_eq_div_pow, Nat.and_two_pow_sub_one_eq_mod]
  exact Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le (Nat.mod_lt _ (Nat.two_pow_pos _))
    (Nat.pow_le_pow_right (by decide) hw))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.fp32_fraction24_toNat](Decode.md#decl-9872cce85e573dff), [TensorCore.EFMachine.fraction_toNat](Decode.md#decl-524099577ddabd02)

</details>

</details>

<a id="decl-524099577ddabd02"></a>

<details>
<summary><code>TensorCore.EFMachine.fraction_toNat</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L38)

```lean
theorem fraction_toNat (bits : F32) (width : ℕ) (hw : width ≤ 10) :
    ((bits &&& (((1 : F32) <<< width) - 1)).setWidth 11).toNat = bits.toNat % 2 ^ width := by
  simpa only [BitVec.ushiftRight_zero, Nat.pow_zero, Nat.div_one] using
    field_toNat bits 0 width 11 (by omega) (by omega)
```

**Supporting proofs:** [TensorCore.EFMachine.field_toNat](Decode.md#decl-06e4f872dfe5c3b7)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a)

</details>

</details>

<a id="decl-dc533ad804fd849a"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeFactor_asDecoded</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L43)

```lean
theorem decodeFactor_asDecoded (kind : InputKind) (bits : F32) :
    (decodeFactor kind bits).map Factor.decoded = (classifyNat kind.format bits.toNat).finite := by
  have he5 := field_toNat bits 10 5 10 (by decide) (by decide)
  have he8 := field_toNat bits 7 8 10 (by decide) (by decide)
  have he8' := field_toNat bits 10 8 10 (by decide) (by decide)
  have hm10 := fraction_toNat bits 10 (by decide)
  have hm7 := fraction_toNat bits 7 (by decide)
  by_cases ht : bits.toNat / 2 ^ kind.format.fractionBits % 2 ^ kind.format.exponentBits =
      2 ^ kind.format.exponentBits - 1 <;>
    by_cases he : bits.toNat / 2 ^ kind.format.fractionBits % 2 ^ kind.format.exponentBits = 0 <;>
    by_cases hm : bits.toNat % 2 ^ kind.format.fractionBits = 0 <;>
    by_cases hs : bits.toNat / 2 ^ (kind.format.fractionBits + kind.format.exponentBits) = 0 <;>
    cases kind <;>
    dsimp +instances only [decodeFactor, InputKind.format, fp16, bf16, tf19,
      Option.map, Factor.decoded, classifyNat] at * <;>
    simp only [beq_iff_eq, BitVec.toNat_eq, he5, he8, he8', hm10, hm7] <;>
    simp_all [Classification.finite, BitVec.toNat_add, BitVec.toNat_ushiftRight,
      Nat.shiftRight_eq_div_pow,
      bne_iff_ne, BitVec.toNat_eq] <;> omega
```

**Supporting proofs:** [TensorCore.EFMachine.field_toNat](Decode.md#decl-06e4f872dfe5c3b7), [TensorCore.EFMachine.fraction_toNat](Decode.md#decl-524099577ddabd02)

**Definitions and types:** [TensorCore.Classification](../../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Factor.decoded](Decode.md#decl-ecc0485e43e051ac), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.InputKind](DecodeDefs.md#decl-9498861c9dad175b), [TensorCore.EFMachine.InputKind.format](DecodeDefs.md#decl-d36240df515f4d1e), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.classifyNat](../../Core/Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor_bounds](Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](Preparation.md#decl-2cf39080c6dc39f5)

</details>

</details>

<a id="decl-59de8d575604c3fc"></a>

<details>
<summary><code>TensorCore.EFMachine.decodeFactor_bounds</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L63)

```lean
theorem decodeFactor_bounds {kind : InputKind} {bits : F32} {a : Factor}
    (h : decodeFactor kind bits = some a) :
    130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 10 := by
  have hd : (classifyNat kind.format bits.toNat).finite = some a.decoded := by
    rw [← decodeFactor_asDecoded, h]; rfl
  cases kind <;>
    dsimp +instances only [InputKind.format, fp16, bf16, tf19, classifyNat] at hd <;>
    repeat' (split at hd)
  all_goals
    simp only [Classification.finite, Option.some.injEq, Factor.decoded, Decoded.mk.injEq] at hd
    first | contradiction | omega
```

**Supporting proofs:** [TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a)

**Definitions and types:** [TensorCore.Classification](../../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Factor.decoded](Decode.md#decl-ecc0485e43e051ac), [TensorCore.EFMachine.InputKind](DecodeDefs.md#decl-9498861c9dad175b), [TensorCore.EFMachine.InputKind.format](DecodeDefs.md#decl-d36240df515f4d1e), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.classifyNat](../../Core/Encoding.md#decl-52d401d7433cac5a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4)

</details>

</details>

<a id="decl-ea20685fae2dfeb2"></a>

<details>
<summary><code>TensorCore.EFMachine.shift_magnitude</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L75)

```lean
theorem shift_magnitude (m : Magnitude) (g : Grid)
    (hm : m.toNat < 2 ^ 24) (hg : g.toNat ≤ 550) :
    (m <<< g).toNat = m.toNat * 2 ^ g.toNat ∧ (m <<< g).toNat < 2 ^ 574 := by
  have hmul : m.toNat * 2 ^ g.toNat < 2 ^ (24 + g.toNat) := by
    rw [Nat.pow_add]
    exact Nat.mul_lt_mul_of_pos_right hm (Nat.two_pow_pos _)
  have hp : 2 ^ (24 + g.toNat) ≤ 2 ^ 574 := Nat.pow_le_pow_right (by decide) (by omega)
  have hwide : m.toNat * 2 ^ g.toNat < 2 ^ 576 := by omega
  change (m <<< g.toNat).toNat = _ ∧ (m <<< g.toNat).toNat < _
  rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, Nat.mod_eq_of_lt hwide]
  exact ⟨rfl, by omega⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c)

</details>

</details>

<a id="decl-c7dc56eb3d6d341c"></a>

<details>
<summary><code>TensorCore.EFMachine.shiftedWord_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L87)

```lean
theorem shiftedWord_value (negative : Bool) (m : Magnitude) (g : Grid)
    (hm : m.toNat < 2 ^ 24) (hg : g.toNat ≤ 550) :
    (Word.mk negative (m <<< g)).value =
      (if negative then -(m.toNat : ℚ) else (m.toNat : ℚ)) * pow2 ((g.toNat : ℤ) - 272) := by
  have h := (shift_magnitude m g hm hg).1
  cases negative <;>
    simp only [Word.value, Word.coefficient, h, Bool.false_eq_true, if_false, if_true,
      Rat.intCast_neg, Rat.intCast_natCast, Rat.natCast_mul, pow2_common] <;> grind
```

**Supporting proofs:** [TensorCore.EFMachine.pow2_common](Round.md#decl-8e9c8ffd317bb724), [TensorCore.EFMachine.shift_magnitude](Decode.md#decl-ea20685fae2dfeb2)

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d)

</details>

</details>

<a id="decl-d5e8311dc2c362b6"></a>

<details>
<summary><code>TensorCore.EFMachine.product_grid</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L96)

```lean
theorem product_grid {a b : Factor}
    (ha : 130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 10)
    (hb : 130 ≤ b.raw.toNat ∧ b.raw.toNat ≤ 383 ∧ b.fraction.toNat ≤ 10) :
    (product a b).raw.toNat = a.raw.toNat + b.raw.toNat ∧
    ((product a b).support.toNat : ℤ) =
      (a.raw.toNat : ℤ) + b.raw.toNat - a.fraction.toNat - b.fraction.toNat - 240 ∧
    (product a b).support.toNat ≤ 526 := by
  have hr : (a.raw + b.raw).toNat = a.raw.toNat + b.raw.toNat := by
    rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
  have hf : (a.fraction + b.fraction).toNat = a.fraction.toNat + b.fraction.toNat := by
    rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
  have hsub : (a.raw + b.raw - (a.fraction + b.fraction)).toNat =
      a.raw.toNat + b.raw.toNat - (a.fraction.toNat + b.fraction.toNat) := by
    rw [BitVec.toNat_sub_of_le (by change (a.fraction + b.fraction).toNat ≤ _; rw [hf, hr]; omega), hr, hf]
  have hsub' : (a.raw + b.raw - (a.fraction + b.fraction) - 240).toNat =
      a.raw.toNat + b.raw.toNat - (a.fraction.toNat + b.fraction.toNat) - 240 := by
    rw [BitVec.toNat_sub_of_le (by
      change 240 ≤ (a.raw + b.raw - (a.fraction + b.fraction)).toNat
      rw [hsub]; omega), hsub]
    rfl
  simp only [product]
  exact ⟨hr, by rw [hsub']; omega, by rw [hsub']; omega⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d)

</details>

</details>

<a id="decl-3bf8dee7f9bfc91d"></a>

<details>
<summary><code>TensorCore.EFMachine.product_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L119)

```lean
theorem product_value {a b : Factor}
    (ha : 130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 10)
    (hb : 130 ≤ b.raw.toNat ∧ b.raw.toNat ≤ 383 ∧ b.fraction.toNat ≤ 10) :
    (product a b).word.value = (rawMul a.decoded b.decoded).value := by
  have hg := product_grid ha hb
  have hm : ((multiplySignificands a.magnitude b.magnitude).zeroExtend 576).toNat =
      a.magnitude.toNat * b.magnitude.toNat := by
    rw [BitVec.toNat_setWidth_of_le (by decide), multiplySignificands_exact]
  have hmb : ((multiplySignificands a.magnitude b.magnitude).zeroExtend 576).toNat < 2 ^ 24 := by
    rw [BitVec.toNat_setWidth_of_le (by decide)]
    exact (multiplySignificands _ _).isLt
  change (Word.mk (a.negative != b.negative)
      (((multiplySignificands a.magnitude b.magnitude).zeroExtend 576) <<< (product a b).support)).value = _
  rw [shiftedWord_value _ _ _ hmb (by omega), hm]
  have he : ((product a b).support.toNat : ℤ) - 272 =
      ((a.raw.toNat : ℤ) - 256 + ((b.raw.toNat : ℤ) - 256)) -
        ((a.fraction.toNat : ℤ) + b.fraction.toNat) := by omega
  rw [he]
  cases ha' : a.negative <;> cases hb' : b.negative <;>
    simp only [RawProduct.value, rawMul, Factor.decoded, ha', hb', Bool.false_eq_true,
      if_false, if_true, bne_self_eq_false, bne_iff_ne, Bool.false_eq_true,
      Rat.intCast_mul, Rat.intCast_neg, Rat.intCast_natCast, Rat.natCast_mul] <;> grind
```

**Supporting proofs:** [TensorCore.EFMachine.multiplySignificands_exact](Split.md#decl-7154e65664b6f748), [TensorCore.EFMachine.product_grid](Decode.md#decl-d5e8311dc2c362b6), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Factor.decoded](Decode.md#decl-ecc0485e43e051ac), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.multiplySignificands](SplitDefs.md#decl-fa9d1dd91a2047b7), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.RawProduct](../../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rawMul](../../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4)

</details>

</details>

<a id="decl-7ab036600e4da4d8"></a>

<details>
<summary><code>TensorCore.EFMachine.product_magnitude</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L142)

```lean
theorem product_magnitude {a b : Factor}
    (ha : 130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 10)
    (hb : 130 ≤ b.raw.toNat ∧ b.raw.toNat ≤ 383 ∧ b.fraction.toNat ≤ 10) :
    (product a b).word.magnitude.toNat < 2 ^ 550 := by
  have hg := (product_grid ha hb).2.2
  have hm : ((multiplySignificands a.magnitude b.magnitude).zeroExtend 576).toNat < 2 ^ 24 := by
    rw [BitVec.toNat_setWidth_of_le (by decide)]
    exact (multiplySignificands _ _).isLt
  have hs := shift_magnitude _ (product a b).support hm (by omega)
  change (((multiplySignificands a.magnitude b.magnitude).zeroExtend 576) <<<
    (product a b).support).toNat < _
  rw [hs.1]
  have hmul := Nat.mul_lt_mul_of_pos_right hm (Nat.two_pow_pos (product a b).support.toNat)
  have hp : 2 ^ (24 + (product a b).support.toNat) ≤ 2 ^ 550 :=
    Nat.pow_le_pow_right (by decide) (by omega)
  rw [Nat.pow_add] at hp
  omega
```

**Supporting proofs:** [TensorCore.EFMachine.product_grid](Decode.md#decl-d5e8311dc2c362b6), [TensorCore.EFMachine.shift_magnitude](Decode.md#decl-ea20685fae2dfeb2)

**Definitions and types:** [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.multiplySignificands](SplitDefs.md#decl-fa9d1dd91a2047b7), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86)

</details>

</details>

<a id="decl-54dae6f9ffe34c9d"></a>

<details>
<summary><code>TensorCore.EFMachine.fp32_exponent_toNat</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L160)

```lean
theorem fp32_exponent_toNat (bits : F32) :
    (((bits >>> 23).setWidth 8).zeroExtend 10).toNat = bits.toNat / 8388608 % 256 := by
  rw [BitVec.toNat_setWidth_of_le (by decide), BitVec.toNat_setWidth,
    BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.outputGrid_spec](Grid.md#decl-966f710cc75730bb)

</details>

</details>

<a id="decl-437ea32770f45bed"></a>

<details>
<summary><code>TensorCore.EFMachine.fp32_fraction_toNat</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L165)

```lean
theorem fp32_fraction_toNat (bits : F32) :
    ((bits &&& 0x007fffff).zeroExtend 576).toNat = bits.toNat % 8388608 := by
  rw [BitVec.toNat_setWidth_of_le (by decide), BitVec.toNat_and]
  change bits.toNat &&& (2 ^ 23 - 1) = _
  exact Nat.and_two_pow_sub_one_eq_mod _ _
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-54bae5dadbb92e0f"></a>

<details>
<summary><code>TensorCore.EFMachine.fp32_sign</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L171)

```lean
theorem fp32_sign (bits : F32) : bits.msb = (bits.toNat / 2 ^ 31 != 0) := by
  rw [BitVec.msb_eq_decide]
  apply Bool.eq_iff_iff.mpr
  simp only [decide_eq_true_eq, bne_iff_ne]
  omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67)

</details>

</details>

<a id="decl-4c8297f8c50b7d91"></a>

<details>
<summary><code>TensorCore.EFMachine.zeroWord_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L177)

```lean
theorem zeroWord_value (negative : Bool) : (Word.mk negative 0).value = 0 := by
  cases negative <;> simp [Word.value, Word.coefficient]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-00c9a9a947e59df6"></a>

<details>
<summary><code>TensorCore.EFMachine.Accumulator.decoded</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L180)

```lean
def Accumulator.decoded (x : Accumulator) : Decoded :=
  ⟨if x.negative then -(x.magnitude.toNat : ℤ) else x.magnitude.toNat,
    (x.raw.toNat : ℤ) - 256, x.fraction.toNat⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.decode32Fields_bounds](Decode.md#decl-b184c06b3493779e), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

</details>

</details>

<a id="decl-9872cce85e573dff"></a>

<details>
<summary><code>TensorCore.EFMachine.fp32_fraction24_toNat</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L184)

```lean
theorem fp32_fraction24_toNat (bits : F32) :
    ((bits &&& 0x007fffff).setWidth 24).toNat = bits.toNat % 8388608 := by
  have h := field_toNat bits 0 23 24 (by decide) (by decide)
  simpa using h
```

**Supporting proofs:** [TensorCore.EFMachine.field_toNat](Decode.md#decl-06e4f872dfe5c3b7)

**Definitions and types:** [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67)

</details>

</details>

<a id="decl-4aec02d9e6183f67"></a>

<details>
<summary><code>TensorCore.EFMachine.decode32Fields_asDecoded</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L189)

```lean
theorem decode32Fields_asDecoded (bits : F32) :
    (decode32Fields bits).map Accumulator.decoded = decode32 bits := by
  have he := fp32_exponent_toNat bits
  have hm := fp32_fraction24_toNat bits
  by_cases ht : bits.toNat / 8388608 % 256 = 255 <;>
    by_cases hz : bits.toNat / 8388608 % 256 = 0 <;>
    by_cases hzm : bits.toNat % 8388608 = 0 <;>
    by_cases hs : bits.toNat / 2147483648 = 0 <;>
    dsimp +instances only [decode32Fields, decode32, classify, fp32,
      Option.map, Accumulator.decoded, classifyNat] <;>
    simp only [beq_iff_eq, BitVec.toNat_eq, he, hm] <;>
    simp_all [Classification.finite, BitVec.toNat_add, fp32_sign,
      bne_iff_ne] <;> omega
```

**Supporting proofs:** [TensorCore.EFMachine.fp32_exponent_toNat](Decode.md#decl-54dae6f9ffe34c9d), [TensorCore.EFMachine.fp32_fraction24_toNat](Decode.md#decl-9872cce85e573dff), [TensorCore.EFMachine.fp32_sign](Decode.md#decl-54bae5dadbb92e0f)

**Definitions and types:** [TensorCore.Classification](../../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.decoded](Decode.md#decl-00c9a9a947e59df6), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.decode32Fields](DecodeDefs.md#decl-715bf8a9ec915fb2), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Fields_bounds](Decode.md#decl-b184c06b3493779e), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

</details>

</details>

<a id="decl-b184c06b3493779e"></a>

<details>
<summary><code>TensorCore.EFMachine.decode32Fields_bounds</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L203)

```lean
theorem decode32Fields_bounds {bits : F32} {a : Accumulator}
    (h : decode32Fields bits = some a) :
    130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 23 := by
  have hd : decode32 bits = some a.decoded := by
    rw [← decode32Fields_asDecoded, h]; rfl
  dsimp +instances only [decode32, classify, fp32, classifyNat] at hd
  repeat' (split at hd)
  all_goals
    simp only [Classification.finite, Option.some.injEq, Accumulator.decoded, Decoded.mk.injEq] at hd
    first | contradiction | omega
```

**Supporting proofs:** [TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67)

**Definitions and types:** [TensorCore.Classification](../../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.decoded](Decode.md#decl-00c9a9a947e59df6), [TensorCore.EFMachine.decode32Fields](DecodeDefs.md#decl-715bf8a9ec915fb2), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

</details>

</details>

<a id="decl-95f7733aa20f6632"></a>

<details>
<summary><code>TensorCore.EFMachine.Accumulator.term_grid</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L214)

```lean
theorem Accumulator.term_grid {a : Accumulator}
    (ha : 130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 23) :
    a.term.raw.toNat = a.raw.toNat + 256 ∧
    (a.term.support.toNat : ℤ) = (a.raw.toNat : ℤ) + 16 - a.fraction.toNat ∧
    123 ≤ a.term.support.toNat ∧ a.term.support.toNat ≤ 399 := by
  have hr : (a.raw + 256).toNat = a.raw.toNat + 256 := by
    rw [BitVec.toNat_add]
    change (a.raw.toNat + 256) % 1024 = _
    exact Nat.mod_eq_of_lt (by omega)
  have hg : (a.raw + 16).toNat = a.raw.toNat + 16 := by
    rw [BitVec.toNat_add]
    change (a.raw.toNat + 16) % 1024 = _
    exact Nat.mod_eq_of_lt (by omega)
  have hs : (a.raw + 16 - a.fraction).toNat = a.raw.toNat + 16 - a.fraction.toNat := by
    rw [BitVec.toNat_sub_of_le (by change a.fraction.toNat ≤ _; rw [hg]; omega), hg]
  simp only [Accumulator.term]
  exact ⟨hr, by rw [hs]; omega, by rw [hs]; omega, by rw [hs]; omega⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337)

</details>

</details>

<a id="decl-e6412c0d9fe39337"></a>

<details>
<summary><code>TensorCore.EFMachine.Accumulator.term_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L232)

```lean
theorem Accumulator.term_value {a : Accumulator}
    (ha : 130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 23) :
    a.term.word.value = a.decoded.value := by
  have hg := a.term_grid ha
  have hm : (a.magnitude.zeroExtend 576).toNat = a.magnitude.toNat :=
    BitVec.toNat_setWidth_of_le (by decide)
  have hb : (a.magnitude.zeroExtend 576).toNat < 2 ^ 24 := by rw [hm]; exact a.magnitude.isLt
  change (Word.mk a.negative (a.magnitude.zeroExtend 576 <<< a.term.support)).value = _
  rw [shiftedWord_value _ _ _ hb (by omega), hm]
  have he : (a.term.support.toNat : ℤ) - 272 = (a.raw.toNat : ℤ) - 256 - a.fraction.toNat := by omega
  rw [he]
  cases hs : a.negative <;>
    simp [Accumulator.decoded, Decoded.value, hs, Rat.intCast_natCast]
```

**Supporting proofs:** [TensorCore.EFMachine.Accumulator.term_grid](Decode.md#decl-95f7733aa20f6632), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.decoded](Decode.md#decl-00c9a9a947e59df6), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce)

</details>

</details>

<a id="decl-8bf0521da8ce8cd8"></a>

<details>
<summary><code>TensorCore.EFMachine.Accumulator.term_magnitude</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L246)

```lean
theorem Accumulator.term_magnitude {a : Accumulator}
    (ha : 130 ≤ a.raw.toNat ∧ a.raw.toNat ≤ 383 ∧ a.fraction.toNat ≤ 23) :
    a.term.word.magnitude.toNat < 2 ^ 424 := by
  have hg := a.term_grid ha
  have hm : (a.magnitude.zeroExtend 576).toNat < 2 ^ 24 := by
    rw [BitVec.toNat_setWidth_of_le (by decide)]; exact a.magnitude.isLt
  have hs := shift_magnitude _ a.term.support hm (by omega)
  change (a.magnitude.zeroExtend 576 <<< a.term.support).toNat < _
  rw [hs.1]
  have hmul := Nat.mul_lt_mul_of_pos_right hm (Nat.two_pow_pos a.term.support.toNat)
  have hp : 2 ^ (24 + a.term.support.toNat) ≤ 2 ^ 424 := Nat.pow_le_pow_right (by decide) (by omega)
  rw [Nat.pow_add] at hp
  omega
```

**Supporting proofs:** [TensorCore.EFMachine.Accumulator.term_grid](Decode.md#decl-95f7733aa20f6632), [TensorCore.EFMachine.shift_magnitude](Decode.md#decl-ea20685fae2dfeb2)

**Definitions and types:** [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75)

</details>

</details>

<a id="decl-ba759822ef5052ce"></a>

<details>
<summary><code>TensorCore.EFMachine.decode32Word_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L260)

```lean
theorem decode32Word_value (bits : F32) :
    (decode32Word bits).map Word.value = TensorCore.value32 bits := by
  simp only [decode32Word, decode32Term, Option.map_map, TensorCore.value32,
    ← decode32Fields_asDecoded]
  cases hd : decode32Fields bits with
  | none => rfl
  | some a =>
    simp only [Option.map_some]
    exact congrArg some (a.term_value (decode32Fields_bounds hd))
```

**Supporting proofs:** [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.decode32Fields_bounds](Decode.md#decl-b184c06b3493779e)

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.decoded](Decode.md#decl-00c9a9a947e59df6), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.decode32Fields](DecodeDefs.md#decl-715bf8a9ec915fb2), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.value32](../../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.add32WithLean_eq](../Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>

<a id="decl-3bfadee11b9c0f75"></a>

<details>
<summary><code>TensorCore.EFMachine.decode32Word_magnitude</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Decode.lean#L270)

```lean
theorem decode32Word_magnitude {bits : F32} {w : Word} (h : decode32Word bits = some w) :
    w.magnitude.toNat < 2 ^ 424 := by
  cases hd : decode32Fields bits with
  | none => simp [decode32Word, decode32Term, hd] at h
  | some a =>
    simp only [decode32Word, decode32Term, hd, Option.map_some, Option.some.injEq] at h
    rw [← h]
    exact a.term_magnitude (decode32Fields_bounds hd)
```

**Supporting proofs:** [TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.decode32Fields_bounds](Decode.md#decl-b184c06b3493779e)

**Definitions and types:** [TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.decode32Fields](DecodeDefs.md#decl-715bf8a9ec915fb2), [TensorCore.EFMachine.decode32Term](DecodeDefs.md#decl-d6ff3b52c79bc67f), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f)

</details>

</details>
