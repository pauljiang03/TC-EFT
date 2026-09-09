# TensorCore.EFT.Machine.Round

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2b5385df9c0fc552"></a>

<details>
<summary><code>TensorCore.EFMachine.magnitudeValue</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L11)

```lean
def magnitudeValue (m : Magnitude) : ℚ := (m.toNat : ℚ) * pow2 (-272)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.abs_value](Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.sign_value](Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.value_zero_iff](Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.magnitudeExponent_word](Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.maxMagnitude32_value](Round.md#decl-246fd8187438ee97), [TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingGrid_convExp](Round.md#decl-cf575f3a4700f276), [TensorCore.EFMachine.roundingGrid_div](Round.md#decl-73afe430816bd696)

</details>

</details>

<a id="decl-8e9c8ffd317bb724"></a>

<details>
<summary><code>TensorCore.EFMachine.pow2_common</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L13)

```lean
theorem pow2_common (n : ℕ) :
    pow2 ((n : ℤ) - 272) = ((2 ^ n : ℕ) : ℚ) * pow2 (-272) := by
  rw [Int.sub_eq_add_neg, pow2_add, pow2_natCast]
```

**Supporting proofs:** [TensorCore.pow2_add](../../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../../Core/Exact.md#decl-997b22af00ef82dd)

**Definitions and types:** [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.magnitudeExponent_word](Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c)

</details>

</details>

<a id="decl-47a33e7a1a646083"></a>

<details>
<summary><code>TensorCore.EFMachine.magnitudeExponent_word</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L17)

```lean
theorem magnitudeExponent_word (m : Magnitude) (hm : m ≠ 0) :
    magnitudeExponent (magnitudeValue m) = ((575 - m.clz.toNat : ℕ) : ℤ) - 272 := by
  have hc : m.clz.toNat < 576 := by
    simpa [BitVec.lt_def] using (BitVec.clz_lt_iff_ne_zero.mpr hm)
  have hl := BitVec.two_pow_sub_clz_le_toNat_of_ne_zero (x := m) (by decide) hm
  have hu := BitVec.toNat_lt_two_pow_sub_clz (x := m)
  apply magnitudeExponent_eq_of_bounds
  · rw [pow2_common]
    exact Rat.mul_le_mul_of_nonneg_right (Rat.natCast_le_natCast.mpr hl)
      (Rat.le_of_lt (pow2_pos _))
  · have he : (((575 - m.clz.toNat : ℕ) : ℤ) - 272) + 1 =
        ((576 - m.clz.toNat : ℕ) : ℤ) - 272 := by omega
    rw [he, pow2_common]
    exact Rat.mul_lt_mul_of_pos_right (Rat.natCast_lt_natCast.mpr hu) (pow2_pos _)
```

**Supporting proofs:** [TensorCore.EFMachine.pow2_common](Round.md#decl-8e9c8ffd317bb724), [TensorCore.magnitudeExponent_eq_of_bounds](../../Core/Rounding.md#decl-bf009f29f695c88d), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.magnitudeExponent](../../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingGrid_convExp](Round.md#decl-cf575f3a4700f276)

</details>

</details>

<a id="decl-cab4fbf103e63d2a"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingGrid_toNat</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L32)

```lean
theorem roundingGrid_toNat (m : Magnitude) :
    (roundingGrid m).toNat = max 123 (576 - m.clz.toNat - 24) := by
  have hc : m.clz ≤ (576 : Magnitude) := BitVec.clz_le
  have hl : ((576 : Magnitude) - m.clz).toNat = 576 - m.clz.toNat := by
    rw [BitVec.toNat_sub_of_le hc]; rfl
  unfold roundingGrid
  rw [leadingZeros_eq]
  dsimp only
  split
  · rename_i hs
    have hs' : 576 - m.clz.toNat ≤ 147 := by
      change ((576 : Magnitude) - m.clz).toNat ≤ 147 at hs
      rwa [hl] at hs
    change 123 = _
    omega
  · rename_i hs
    have hs' : 147 < 576 - m.clz.toNat := by
      simp only [BitVec.le_def, hl] at hs
      change ¬576 - m.clz.toNat ≤ 147 at hs
      omega
    rw [BitVec.toNat_sub_of_le (by change 24 ≤ ((576 : Magnitude) - m.clz).toNat; rw [hl]; omega)]
    rw [hl]
    change 576 - m.clz.toNat - 24 = _
    omega
```

**Supporting proofs:** [TensorCore.EFMachine.leadingZeros_eq](BitScan.md#decl-6a874aca0a7bf352)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.leadingZeros](BitScanDefs.md#decl-dc7b8bb67a09f476), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingGrid_bounds](Round.md#decl-cc1256a8c795226c), [TensorCore.EFMachine.roundingGrid_convExp](Round.md#decl-cf575f3a4700f276), [TensorCore.EFMachine.roundingGrid_quotient_bound](Round.md#decl-b883f762f9c3cb78)

</details>

</details>

<a id="decl-cc1256a8c795226c"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingGrid_bounds</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L57)

```lean
theorem roundingGrid_bounds (m : Magnitude) :
    123 ≤ (roundingGrid m).toNat ∧ (roundingGrid m).toNat ≤ 552 := by
  rw [roundingGrid_toNat]; omega
```

**Supporting proofs:** [TensorCore.EFMachine.roundingGrid_toNat](Round.md#decl-cab4fbf103e63d2a)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5)

</details>

</details>

<a id="decl-cf575f3a4700f276"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingGrid_convExp</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L61)

```lean
theorem roundingGrid_convExp (m : Magnitude) (hm : m ≠ 0) :
    convExp (magnitudeValue m) = ((roundingGrid m).toNat : ℤ) - 249 := by
  have hc : m.clz.toNat < 576 := by
    simpa [BitVec.lt_def] using (BitVec.clz_lt_iff_ne_zero.mpr hm)
  rw [roundingGrid_toNat]
  unfold convExp emin32
  rw [magnitudeExponent_word m hm]
  omega
```

**Supporting proofs:** [TensorCore.EFMachine.magnitudeExponent_word](Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.roundingGrid_toNat](Round.md#decl-cab4fbf103e63d2a)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.convExp](../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.emin32](../../Core/RoundOp.md#decl-db1578f6a47fc8b5), [TensorCore.magnitudeExponent](../../Core/RoundOp.md#decl-d0b00fe98f5e4d15)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.roundingGrid_div](Round.md#decl-73afe430816bd696)

</details>

</details>

<a id="decl-73afe430816bd696"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingGrid_div</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L70)

```lean
theorem roundingGrid_div (m : Magnitude) (hm : m ≠ 0) :
    magnitudeValue m / pow2 (convExp (magnitudeValue m) - 23) =
      (m.toNat : ℚ) / (2 ^ (roundingGrid m).toNat : ℕ) := by
  rw [roundingGrid_convExp m hm]
  have he : ((roundingGrid m).toNat : ℤ) - 249 - 23 =
      -272 + (roundingGrid m).toNat := by omega
  rw [he]
  exact dyadic_div _ _ _
```

**Supporting proofs:** [TensorCore.EFMachine.dyadic_div](Dyadic.md#decl-fd28badee16494f1), [TensorCore.EFMachine.roundingGrid_convExp](Round.md#decl-cf575f3a4700f276)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.convExp](../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5)

</details>

</details>

<a id="decl-b883f762f9c3cb78"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingGrid_quotient_bound</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L79)

```lean
theorem roundingGrid_quotient_bound (m : Magnitude) :
    m.toNat / 2 ^ (roundingGrid m).toNat < 2 ^ 24 := by
  have hu := BitVec.toNat_lt_two_pow_sub_clz (x := m)
  have hg := roundingGrid_toNat m
  have he : 576 - m.clz.toNat ≤ (roundingGrid m).toNat + 24 := by omega
  have hp := Nat.pow_le_pow_right (n := 2) (by decide) he
  have hh : m.toNat < 2 ^ 24 * 2 ^ (roundingGrid m).toNat := by
    rw [← Nat.pow_add, Nat.add_comm 24]
    omega
  exact (Nat.div_lt_iff_lt_mul (Nat.two_pow_pos _)).mpr hh
```

**Supporting proofs:** [TensorCore.EFMachine.roundingGrid_toNat](Round.md#decl-cab4fbf103e63d2a)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5)

</details>

</details>

<a id="decl-23d703ce50cbcf2a"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingCoefficient_spec</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L90)

```lean
theorem roundingCoefficient_spec (m g : Magnitude)
    (hg : 1 ≤ g.toNat) (hg' : g.toNat < 576)
    (hk : m.toNat / 2 ^ g.toNat < 2 ^ 24) :
    ((roundingCoefficient m g).toNat : ℤ) =
      rneInt ((m.toNat : ℚ) / (2 ^ g.toNat : ℕ)) := by
  let k := m >>> g
  let r := m - (k <<< g)
  let half := (1 : Magnitude) <<< (g - 1)
  have hk' : k.toNat = m.toNat / 2 ^ g.toNat := by
    change (m >>> g.toNat).toNat = _
    rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow]
  have hcoarse : (k <<< g).toNat = m.toNat / 2 ^ g.toNat * 2 ^ g.toNat := by
    change (k <<< g.toNat).toNat = _
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, hk',
      Nat.mod_eq_of_lt (Nat.lt_of_le_of_lt (Nat.div_mul_le_self _ _) m.isLt)]
  have hr : r.toNat = m.toNat % 2 ^ g.toNat := by
    have hb : k <<< g ≤ m := by
      change (k <<< g).toNat ≤ m.toNat
      rw [hcoarse]; exact Nat.div_mul_le_self _ _
    dsimp only [r]
    rw [BitVec.toNat_sub_of_le hb, hcoarse]
    have hh := Nat.mod_add_div m.toNat (2 ^ g.toNat)
    rw [Nat.mul_comm] at hh
    omega
  have hgap : (g - 1).toNat = g.toNat - 1 := by
    rw [BitVec.toNat_sub_of_le (by exact hg)]; rfl
  have hhalf : half.toNat = 2 ^ (g.toNat - 1) := by
    change ((1 : Magnitude) <<< (g - 1).toNat).toNat = _
    rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, hgap]
    change (1 * 2 ^ (g.toNat - 1)) % 2 ^ 576 = _
    rw [Nat.one_mul, Nat.mod_eq_of_lt (Nat.pow_lt_pow_right (by decide) (by omega))]
  have htwo : 2 ^ g.toNat = 2 * half.toNat := by
    calc
      2 ^ g.toNat = 2 ^ ((g.toNat - 1) + 1) := by congr 1; omega
      _ = 2 * 2 ^ (g.toNat - 1) := by rw [Nat.pow_succ, Nat.mul_comm]
      _ = 2 * half.toNat := by rw [hhalf]
  have hparity : (k &&& 1).toNat = k.toNat % 2 := by
    rw [BitVec.toNat_and]
    change k.toNat &&& 1 = _
    exact Nat.and_one_is_mod _
  have hcond : (r > half || (r == half && (k &&& 1) == 1)) = true ↔
      2 ^ g.toNat < 2 * (m.toNat % 2 ^ g.toNat) ∨
        (2 * (m.toNat % 2 ^ g.toNat) = 2 ^ g.toNat ∧ m.toNat / 2 ^ g.toNat % 2 = 1) := by
    simp only [Bool.or_eq_true, Bool.and_eq_true, beq_iff_eq, BitVec.lt_def,
      BitVec.toNat_eq, hr, hparity, hk', decide_eq_true_eq]
    change half.toNat < m.toNat % 2 ^ g.toNat ∨
      (m.toNat % 2 ^ g.toNat = half.toNat ∧ m.toNat / 2 ^ g.toNat % 2 = 1) ↔ _
    omega
  rw [rneInt_nat_div _ _ (Nat.two_pow_pos _)]
  change ((if r > half || (r == half && (k &&& 1) == 1) then k + 1 else k).toNat : ℤ) = _
  split
  · rename_i hc
    rw [if_pos (hcond.mp hc), BitVec.toNat_add]
    have hkn : k.toNat + 1 < 2 ^ 576 := by rw [hk'] at *; omega
    change (((k.toNat + 1) % 2 ^ 576 : ℕ) : ℤ) = _
    rw [Nat.mod_eq_of_lt hkn, hk']
  · rename_i hc
    rw [if_neg (by intro h; exact hc (hcond.mpr h)), hk']
```

**Supporting proofs:** [TensorCore.EFMachine.rneInt_nat_div](Dyadic.md#decl-a8bf3e6699d80787)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.roundingCoefficient](WordDefs.md#decl-69d5af16c3511326), [TensorCore.rneInt](../../Core/RoundOp.md#decl-c2651a1e8f74a14a)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5)

</details>

</details>

<a id="decl-a55b48c044a3a9d5"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingCoefficient_convCoeff</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L149)

```lean
theorem roundingCoefficient_convCoeff (m : Magnitude) (hm : m ≠ 0) :
    ((roundingCoefficient m (roundingGrid m)).toNat : ℤ) =
      convCoeff .nearestEven (magnitudeValue m) := by
  have hg := roundingGrid_bounds m
  rw [roundingCoefficient_spec _ _ (by omega) (by omega) (roundingGrid_quotient_bound m)]
  unfold convCoeff roundCoefficient
  rw [roundingGrid_div m hm]
```

**Supporting proofs:** [TensorCore.EFMachine.roundingCoefficient_spec](Round.md#decl-23d703ce50cbcf2a), [TensorCore.EFMachine.roundingGrid_bounds](Round.md#decl-cc1256a8c795226c), [TensorCore.EFMachine.roundingGrid_div](Round.md#decl-73afe430816bd696), [TensorCore.EFMachine.roundingGrid_quotient_bound](Round.md#decl-b883f762f9c3cb78)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.roundingCoefficient](WordDefs.md#decl-69d5af16c3511326), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.convCoeff](../../Core/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.rneInt](../../Core/RoundOp.md#decl-c2651a1e8f74a14a), [TensorCore.roundCoefficient](../../Core/RoundOp.md#decl-7662cf06d1725fc5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6)

</details>

</details>

<a id="decl-825e23e32bfda2dc"></a>

<details>
<summary><code>TensorCore.EFMachine.encodeAtGrid_spec</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L157)

```lean
theorem encodeAtGrid_spec (negative : Bool) (g k : Magnitude)
    (hg : 123 ≤ g.toNat) (hg' : g.toNat ≤ 553) (hk : k.toNat < 16777216) :
    encodeAtGrid negative g k = encode32 negative ((g.toNat : ℤ) - 249) k.toNat := by
  have hgs : (g - 122).toNat = g.toNat - 122 := by
    rw [BitVec.toNat_sub_of_le (by change 122 ≤ g.toNat; omega)]; rfl
  have hexp : (((g.toNat : ℤ) - 249) + 127).toNat = g.toNat - 122 := by omega
  unfold encodeAtGrid encode32
  have hsmall : k < (8388608 : Magnitude) ↔ (k.toNat : ℤ) < 2 ^ 23 := by
    change k.toNat < 8388608 ↔ (k.toNat : ℤ) < 8388608
    omega
  split
  · rename_i hs
    rw [if_pos (hsmall.mp hs)]
    apply BitVec.eq_of_toNat_eq
    cases negative <;> simp [BitVec.toNat_add, BitVec.toNat_setWidth, Nat.add_mod]
  · rename_i hs
    simp only [if_neg (mt hsmall.mpr hs), hexp]
    have hklo : 8388608 ≤ k.toNat := by change ¬ k.toNat < 8388608 at hs; omega
    have hks : (k - 8388608).toNat = k.toNat - 8388608 := by
      rw [BitVec.toNat_sub_of_le hklo]; rfl
    have hshift : ((g - 122) <<< 23).toNat = (g.toNat - 122) * 8388608 := by
      rw [BitVec.toNat_shiftLeft, Nat.shiftLeft_eq, hgs]
      change ((g.toNat - 122) * 8388608) % 2 ^ 576 = _
      exact Nat.mod_eq_of_lt (by omega)
    have hp : (((g - 122) <<< 23) + (k - 8388608)).toNat =
        (g.toNat - 122) * 8388608 + (k.toNat - 8388608) := by
      rw [BitVec.toNat_add, hshift, hks, Nat.mod_eq_of_lt (by omega)]
    have hki : ((k.toNat : ℤ) - 2 ^ 23).toNat = k.toNat - 8388608 := by omega
    rw [hki]
    apply BitVec.eq_of_toNat_eq
    simp only [BitVec.toNat_add, BitVec.toNat_setWidth, hp, BitVec.toNat_ofNat]
    cases negative <;> simp [Nat.add_mod]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.encodeAtGrid](WordDefs.md#decl-b26e55426fdd0ef8), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.encode32](../../Core/RoundOp.md#decl-2d041a1e685373ec)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.encodeRounded_spec](Round.md#decl-6aa1647dc1e12481)

</details>

</details>

<a id="decl-6aa1647dc1e12481"></a>

<details>
<summary><code>TensorCore.EFMachine.encodeRounded_spec</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L190)

```lean
theorem encodeRounded_spec (negative : Bool) (g k : Magnitude)
    (hg : 123 ≤ g.toNat) (hg' : g.toNat ≤ 552) (hk : k.toNat ≤ 16777216) :
    encodeRounded negative g k =
      encode32 negative (carry ((g.toNat : ℤ) - 249) k.toNat).1
        (carry ((g.toNat : ℤ) - 249) k.toNat).2 := by
  unfold encodeRounded
  dsimp only
  split
  · rename_i hc
    dsimp only
    have hc' : k.toNat = 16777216 := by
      have hh := congrArg BitVec.toNat (beq_iff_eq.mp hc)
      exact hh
    have hgn : (g + 1).toNat = g.toNat + 1 := by
      rw [BitVec.toNat_add]
      change (g.toNat + 1) % 2 ^ 576 = _
      exact Nat.mod_eq_of_lt (by omega)
    have hkn : (k >>> 1).toNat = 8388608 := by
      rw [BitVec.toNat_ushiftRight, Nat.shiftRight_eq_div_pow, hc']
    rw [encodeAtGrid_spec _ _ _ (by omega) (by omega) (by omega), hgn, hkn]
    simp only [carry, hc', show ((16777216 : ℕ) : ℤ) = 2 ^ 24 by decide, if_true]
    congr 1 <;> omega
  · rename_i hc
    dsimp only
    have hc' : k.toNat ≠ 16777216 := by
      intro h
      apply hc
      exact beq_iff_eq.mpr (BitVec.eq_of_toNat_eq h)
    rw [encodeAtGrid_spec _ _ _ hg (by omega) (by omega)]
    have hn : (k.toNat : ℤ) ≠ 2 ^ 24 := by omega
    simp only [carry, if_neg hn]
```

**Supporting proofs:** [TensorCore.EFMachine.encodeAtGrid_spec](Round.md#decl-825e23e32bfda2dc)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.encodeAtGrid](WordDefs.md#decl-b26e55426fdd0ef8), [TensorCore.EFMachine.encodeRounded](WordDefs.md#decl-4eec0d2f438b9d92), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.carry](../../Core/RoundOp.md#decl-e870a105595fff5f), [TensorCore.encode32](../../Core/RoundOp.md#decl-2d041a1e685373ec)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6)

</details>

</details>

<a id="decl-5922e66553898d4e"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.abs_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L222)

```lean
theorem Word.abs_value (x : Word) : absQ x.value = magnitudeValue x.magnitude := by
  have hp : (0 : ℚ) ≤ magnitudeValue x.magnitude :=
    Rat.mul_nonneg Rat.natCast_nonneg (Rat.le_of_lt (pow2_pos _))
  cases hn : x.negative
  · simpa [Word.value, Word.coefficient, hn, magnitudeValue, Rat.intCast_natCast] using absQ_of_nonneg hp
  · simpa [Word.value, Word.coefficient, hn, magnitudeValue, Rat.intCast_natCast, Rat.neg_mul, absQ_neg] using
      absQ_of_nonneg hp
```

**Supporting proofs:** [TensorCore.absQ_neg](../../Core/Exact.md#decl-5fcbb1ea121d8a53), [TensorCore.absQ_of_nonneg](../../Core/Exact.md#decl-2aceea0008eec277), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.value_zero_iff](Round.md#decl-5a2494bde76c4d91)

</details>

</details>

<a id="decl-5a2494bde76c4d91"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.value_zero_iff</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L230)

```lean
theorem Word.value_zero_iff (x : Word) : x.value = 0 ↔ x.magnitude = 0 := by
  have hp := pow2_pos (-272)
  have hm := x.magnitude.isLt
  have he : (magnitudeValue x.magnitude = 0) ↔ x.magnitude = 0 := by
    unfold magnitudeValue
    rw [Rat.mul_eq_zero]
    simp only [Rat.ne_of_gt hp, or_false, BitVec.toNat_eq]
    change (x.magnitude.toNat : ℚ) = ((0 : ℕ) : ℚ) ↔ x.magnitude.toNat = 0
    exact Rat.natCast_inj
  have ha := x.abs_value
  have hz : absQ x.value = 0 ↔ x.value = 0 := by unfold absQ; split <;> grind
  rw [← hz, ha, he]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.abs_value](Round.md#decl-5922e66553898d4e), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6)

</details>

</details>

<a id="decl-c87aa48d8d80178d"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.sign_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L243)

```lean
theorem Word.sign_value (x : Word) (hx : x.magnitude ≠ 0) :
    decide (x.value < 0) = x.negative := by
  have hm : 0 < x.magnitude.toNat := by
    have hn : x.magnitude.toNat ≠ 0 := by intro h; exact hx (BitVec.eq_of_toNat_eq h)
    omega
  have hp : (0 : ℚ) < magnitudeValue x.magnitude :=
    Rat.mul_pos (Rat.natCast_pos.mpr hm) (pow2_pos _)
  cases hn : x.negative <;>
    simp only [Word.value, Word.coefficient, hn, Bool.false_eq_true, if_false, if_true,
      Rat.intCast_natCast, Rat.intCast_neg, Rat.neg_mul] <;>
    change decide _ = _ <;> unfold magnitudeValue at hp <;> simp_all <;> grind
```

**Supporting proofs:** [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6)

</details>

</details>

<a id="decl-246fd8187438ee97"></a>

<details>
<summary><code>TensorCore.EFMachine.maxMagnitude32_value</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L255)

```lean
theorem maxMagnitude32_value : magnitudeValue maxMagnitude32 = maxFinite32 := by decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.maxMagnitude32](WordDefs.md#decl-e1240926dd0c8785), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d)

</details>

</details>

<a id="decl-9cf39bb31212af4d"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.range_iff</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L257)

```lean
theorem Word.range_iff (x : Word) :
    absQ x.value ≤ maxFinite32 ↔ x.magnitude ≤ maxMagnitude32 := by
  rw [x.abs_value, ← maxMagnitude32_value]
  unfold magnitudeValue
  have hp := pow2_pos (-272)
  constructor
  · intro h
    have hn : (x.magnitude.toNat : ℚ) ≤ (maxMagnitude32.toNat : ℚ) := by
      have hh := Rat.mul_lt_mul_right (a := (maxMagnitude32.toNat : ℚ))
        (b := (x.magnitude.toNat : ℚ)) hp
      grind
    exact Rat.natCast_le_natCast.mp hn
  · intro h
    exact Rat.mul_le_mul_of_nonneg_right (Rat.natCast_le_natCast.mpr h) (Rat.le_of_lt hp)
```

**Supporting proofs:** [TensorCore.EFMachine.Word.abs_value](Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.maxMagnitude32_value](Round.md#decl-246fd8187438ee97), [TensorCore.pow2_pos](../../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.maxMagnitude32](WordDefs.md#decl-e1240926dd0c8785), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.add32WithLean_eq](../Native.md#decl-606ce6330a627312)

</details>

</details>

<a id="decl-9fc51118cee048d6"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.round32_eq</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L274)

```lean
/-- Universal bit-for-bit refinement of the fixed-width final converter, including
range rejection, ties, carries, subnormals, and both signs of underflowed zero. -/
theorem Word.round32_eq (x : Word) :
    x.round32 = TensorCore.round32 .nearestEven x.value := by
  by_cases hr : x.magnitude ≤ maxMagnitude32
  · have hr' := x.range_iff.mpr hr
    have hnr : ¬ x.magnitude > maxMagnitude32 := by
      change ¬ maxMagnitude32.toNat < x.magnitude.toNat
      exact Nat.not_lt.mpr hr
    have hnr' : ¬ absQ x.value > maxFinite32 := by grind
    by_cases hz : x.magnitude = 0
    · have hz' := x.value_zero_iff.mpr hz
      simp only [Word.round32, hz, beq_self_eq_true, if_true, hz']
      exact (show TensorCore.round32 .nearestEven 0 = some 0 by decide +kernel).symm
    · have hz' : x.value ≠ 0 := by intro h; exact hz (x.value_zero_iff.mp h)
      have hp : 0 < magnitudeValue x.magnitude := by
        rw [← x.abs_value]
        exact absQ_pos_of_ne_zero _ hz'
      have hmr : magnitudeValue x.magnitude ≤ maxFinite32 := by rwa [x.abs_value] at hr'
      have hnmr : ¬ magnitudeValue x.magnitude > maxFinite32 := by grind
      obtain ⟨he0, he1, _, _⟩ := convExp_bounds _ hp hmr
      obtain ⟨hk0, hk1, hsub, htop⟩ := convCoeff_bounds .nearestEven _ hp hmr
      have hs := carry_spec _ _ he0 he1 hk0 hk1 hsub htop
      have hcarry : ¬ (carry (convExp (magnitudeValue x.magnitude))
          (convCoeff .nearestEven (magnitudeValue x.magnitude))).1 > 127 := by
        exact Int.not_lt.mpr hs.2.1
      have hg := roundingGrid_bounds x.magnitude
      have hk := roundingCoefficient_convCoeff x.magnitude hz
      have hsign := x.sign_value hz
      simp only [Word.round32, if_neg hnr, beq_iff_eq, if_neg hz]
      rw [encodeRounded_spec _ _ _ hg.1 hg.2 (by omega), hk,
        ← roundingGrid_convExp x.magnitude hz]
      simp only [TensorCore.round32, round32Core, if_neg hz', x.abs_value,
        hsign, if_neg hcarry, if_neg hnmr]
  · have hr' : absQ x.value > maxFinite32 := by
      have h := x.range_iff
      grind
    have hm : x.magnitude > maxMagnitude32 := by
      change maxMagnitude32.toNat < x.magnitude.toNat
      change ¬ x.magnitude.toNat ≤ maxMagnitude32.toNat at hr
      omega
    simp only [Word.round32, if_pos hm, TensorCore.round32, if_pos hr']
```

**Supporting proofs:** [TensorCore.EFMachine.Word.abs_value](Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.sign_value](Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.value_zero_iff](Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.encodeRounded_spec](Round.md#decl-6aa1647dc1e12481), [TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingGrid_bounds](Round.md#decl-cc1256a8c795226c), [TensorCore.EFMachine.roundingGrid_convExp](Round.md#decl-cf575f3a4700f276), [TensorCore.absQ_pos_of_ne_zero](../../Core/CorrectRounding.md#decl-0de5c16329b2da35), [TensorCore.carry_spec](../../Core/ConversionBounds.md#decl-d852b3768f22ee03), [TensorCore.convCoeff_bounds](../../Core/ConversionBounds.md#decl-515c53877d1bedf2), [TensorCore.convExp_bounds](../../Core/ConversionBounds.md#decl-a4885e74ce89d102)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.encodeRounded](WordDefs.md#decl-4eec0d2f438b9d92), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.maxMagnitude32](WordDefs.md#decl-e1240926dd0c8785), [TensorCore.EFMachine.roundingCoefficient](WordDefs.md#decl-69d5af16c3511326), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.carry](../../Core/RoundOp.md#decl-e870a105595fff5f), [TensorCore.convCoeff](../../Core/RoundOp.md#decl-9af925aec44b7c00), [TensorCore.convExp](../../Core/RoundOp.md#decl-712564d4fa452350), [TensorCore.encode32](../../Core/RoundOp.md#decl-2d041a1e685373ec), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.round32Core](../../Core/RoundOp.md#decl-a47adb12319758c3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32_correct](Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_isSome_iff](Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.add32WithLean_eq](../Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94)

</details>

</details>

<a id="decl-84e75c815794c328"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.round32_correct</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L315)

```lean
theorem Word.round32_correct {x : Word} {b : F32} (h : x.round32 = some b) :
    NearestEven32 x.value b := by
  rw [x.round32_eq] at h
  exact finalRound_correct _ _ (TensorCore.round32_range h) h
```

**Supporting proofs:** [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.finalRound_correct](../../Core/CorrectRounding.md#decl-e7b5aad6590aeae4), [TensorCore.round32_range](../../Core/RoundOp.md#decl-cd74c43ff6d7803c)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-19f702cd5b682251"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.round32_isSome_iff</code></summary>

[Lean source](../../../../TensorCore/EFT/Machine/Round.lean#L320)

```lean
theorem Word.round32_isSome_iff (x : Word) :
    x.round32.isSome = true ↔ absQ x.value ≤ maxFinite32 := by
  rw [x.round32_eq]
  constructor
  · cases hh : TensorCore.round32 .nearestEven x.value with
    | none => simp
    | some b => intro _; exact TensorCore.round32_range hh
  · intro h
    obtain ⟨b, hb, _⟩ := round32_nearestEven_correct x.value h
    rw [hb]; rfl
```

**Supporting proofs:** [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.round32_nearestEven_correct](../../Core/CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_range](../../Core/RoundOp.md#decl-cd74c43ff6d7803c)

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
