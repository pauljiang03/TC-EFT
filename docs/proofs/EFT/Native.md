# TensorCore.EFT.Native

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-5badba3cc64a61b4"></a>

<details>
<summary><code>TensorCore.EFMachine.value32_finite_exponent</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L15)

```lean
theorem value32_finite_exponent {a : F32} {x : ℚ} (h : TensorCore.value32 a = some x) :
    a.toNat / 8388608 % 256 < 255 := by
  have he : a.toNat / 8388608 % 256 < 256 := Nat.mod_lt _ (by decide)
  by_cases hf : a.toNat / 8388608 % 256 < 255
  · exact hf
  have hz : a.toNat / 8388608 % 256 = 255 := by omega
  by_cases hm : a.toNat % 8388608 = 0 <;>
    simp [TensorCore.value32, TensorCore.decode32, classify, classifyNat, fp32, hz, hm,
      Classification.finite] at h
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312)

</details>

</details>

<a id="decl-d54ee0a869d0df69"></a>

<details>
<summary><code>TensorCore.EFMachine.add32WithLean</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L27)

```lean
/-- One native nearest-even addition behind the original finite-input and exact
range checks. The bounded reference rounder is not executed to obtain the result. -/
def add32WithLean (a b : F32) : Option F32 := do
  if ha : a.toNat / 8388608 % 256 < 255 then
    if hb : b.toNat / 8388608 % 256 < 255 then
      let x ← decode32Word a
      let y ← decode32Word b
      let s ← x.add y
      if s.magnitude ≤ maxMagnitude32 then
        some (nativeFiniteAdd32 a b ha hb)
      else none
    else none
  else none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](Machine/WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](Machine/WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.decode32Word](Machine/DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.maxMagnitude32](Machine/WordDefs.md#decl-e1240926dd0c8785), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32](../IEEE/LeanFiniteAddition.md#decl-f0674d78ec7d02c2)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.naiveSum32WithLeanFrom](Native.md#decl-8840f9876c0a9452), [TensorCore.EFMachine.naiveSum32WithLeanFrom_eq](Native.md#decl-0301e5d588c478f8), [TensorCore.Regression.NativeEFT.cancellation](Regression/NativeEFT.md#decl-930dda5cb1894be0), [TensorCore.Regression.NativeEFT.exact_range_rejection](Regression/NativeEFT.md#decl-cf11a49dc1ee98a2), [TensorCore.Regression.NativeEFT.nan_rejection](Regression/NativeEFT.md#decl-1dc392af8475ca8d), [TensorCore.Regression.NativeEFT.nonfinite_rejection](Regression/NativeEFT.md#decl-973f944c128871db), [TensorCore.Regression.NativeEFT.signed_zeros](Regression/NativeEFT.md#decl-3071ab2d5754b0bc), [TensorCore.Regression.NativeEFT.subnormal_boundary](Regression/NativeEFT.md#decl-720a137e57ae3e91), [TensorCore.Regression.NativeEFT.tie_even](Regression/NativeEFT.md#decl-48dab98648ef1601), [TensorCore.Regression.NativeEFT.tie_odd](Regression/NativeEFT.md#decl-da66c5c7c6f4fdb9), [TensorCore.Regression.NativeEFT.zero_then_negative](Regression/NativeEFT.md#decl-0d3f5bc8fb58156f)

</details>

</details>

<a id="decl-606ce6330a627312"></a>

<details>
<summary><code>TensorCore.EFMachine.add32WithLean_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L41)

```lean
/-- Full scalar primitive preservation, including nonfinite rejection, exact
range rejection, signed underflow, and normalization of exact zero. -/
theorem add32WithLean_eq (a b : F32) : add32WithLean a b = add32 a b := by
  cases hx : decode32Word a with
  | none =>
    simp only [add32WithLean, add32, hx]
    split <;> (try rfl)
    split <;> rfl
  | some x =>
    have hxa : TensorCore.value32 a = some x.value := by rw [← decode32Word_value, hx]; rfl
    have ha := value32_finite_exponent hxa
    cases hy : decode32Word b with
    | none => simp [add32WithLean, add32, ha, hx, hy]
    | some y =>
      have hyb : TensorCore.value32 b = some y.value := by rw [← decode32Word_value, hy]; rfl
      have hb := value32_finite_exponent hyb
      simp only [add32WithLean, add32, ha, hb, ↓reduceDIte, hx, hy, Bind.bind, Option.bind]
      cases hs : x.add y with
      | none => rfl
      | some s =>
        simp only
        by_cases hr : s.magnitude ≤ maxMagnitude32
        · rw [if_pos hr, Word.round32_eq, Word.add_value hs]
          exact (nativeFiniteAdd32_round a b ha hb x.value y.value hxa hyb (by
            have h := s.range_iff.mpr hr
            rwa [Word.add_value hs] at h)).symm
        · have hgt : s.magnitude > maxMagnitude32 := by
            change ¬ s.magnitude.toNat ≤ maxMagnitude32.toNat at hr
            exact Nat.lt_of_not_ge hr
          simp [hr, Word.round32, hgt]
```

**Supporting proofs:** [TensorCore.EFMachine.Word.add_value](Machine/Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.range_iff](Machine/Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_eq](Machine/Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.decode32Word_value](Machine/Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.value32_finite_exponent](Native.md#decl-5badba3cc64a61b4), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](../IEEE/LeanFiniteAddition.md#decl-ee1136b3a2cc3036)

**Definitions and types:** [TensorCore.EFMachine.Magnitude](Machine/WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](Machine/WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.round32](Machine/WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.value](Machine/WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.add32](Machine/DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.decode32Word](Machine/DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.encodeRounded](Machine/WordDefs.md#decl-4eec0d2f438b9d92), [TensorCore.EFMachine.maxMagnitude32](Machine/WordDefs.md#decl-e1240926dd0c8785), [TensorCore.EFMachine.roundingCoefficient](Machine/WordDefs.md#decl-69d5af16c3511326), [TensorCore.EFMachine.roundingGrid](Machine/WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32](../IEEE/LeanFiniteAddition.md#decl-f0674d78ec7d02c2), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.naiveSum32WithLeanFrom_eq](Native.md#decl-0301e5d588c478f8)

</details>

</details>

<a id="decl-8840f9876c0a9452"></a>

<details>
<summary><code>TensorCore.EFMachine.naiveSum32WithLeanFrom</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L71)

```lean
/-- Encoded, left-to-right naive accumulation with rounding at every addition. -/
def naiveSum32WithLeanFrom (acc : F32) (xs : List F32) : Option F32 :=
  xs.foldlM add32WithLean acc
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.naiveSum32WithLeanFrom_eq](Native.md#decl-0301e5d588c478f8), [TensorCore.EFMachine.scalarSumWithLean](Native.md#decl-e4ccd3078c932ff1), [TensorCore.EFMachine.scalarSumWithLean_eq](Native.md#decl-068a2eb7a865b141), [TensorCore.Regression.NativeEFT.every_step_rounds](Regression/NativeEFT.md#decl-1dae0023c1d953c1), [TensorCore.Regression.NativeEFT.exact_residual_sum](Regression/NativeEFT.md#decl-c73a68794427db72), [TensorCore.Regression.NativeEFT.intermediate_range_rejection](Regression/NativeEFT.md#decl-a559ac394785e8f8), [TensorCore.Regression.NativeEFT.order_keeps_one](Regression/NativeEFT.md#decl-7140319c6bf416e5), [TensorCore.Regression.NativeEFT.order_loses_one](Regression/NativeEFT.md#decl-28c95db87f81e51e)

</details>

</details>

<a id="decl-0301e5d588c478f8"></a>

<details>
<summary><code>TensorCore.EFMachine.naiveSum32WithLeanFrom_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L74)

```lean
theorem naiveSum32WithLeanFrom_eq (acc : F32) (xs : List F32) :
    naiveSum32WithLeanFrom acc xs = xs.foldlM add32 acc := by
  simp only [naiveSum32WithLeanFrom, show add32WithLean = add32 from by funext a b; exact add32WithLean_eq a b]
```

**Supporting proofs:** [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312)

**Definitions and types:** [TensorCore.EFMachine.add32](Machine/DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.naiveSum32WithLeanFrom](Native.md#decl-8840f9876c0a9452), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.scalarSumWithLean_eq](Native.md#decl-068a2eb7a865b141)

</details>

</details>

<a id="decl-e4ccd3078c932ff1"></a>

<details>
<summary><code>TensorCore.EFMachine.scalarSumWithLean</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L78)

```lean
def scalarSumWithLean (xs : List Word) : Option F32 := do
  let bs ← xs.mapM Word.exact32
  naiveSum32WithLeanFrom 0 bs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Bounded.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.naiveSum32WithLeanFrom](Native.md#decl-8840f9876c0a9452), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.scalarSumWithLean_eq](Native.md#decl-068a2eb7a865b141)

</details>

</details>

<a id="decl-068a2eb7a865b141"></a>

<details>
<summary><code>TensorCore.EFMachine.scalarSumWithLean_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L82)

```lean
theorem scalarSumWithLean_eq (xs : List Word) : scalarSumWithLean xs = scalarSum xs := by
  simp only [scalarSumWithLean, scalarSum, naiveSum32WithLeanFrom_eq]
```

**Supporting proofs:** [TensorCore.EFMachine.naiveSum32WithLeanFrom_eq](Native.md#decl-0301e5d588c478f8)

**Definitions and types:** [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Bounded.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.add32](Machine/DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.naiveSum32WithLeanFrom](Native.md#decl-8840f9876c0a9452), [TensorCore.EFMachine.scalarSum](Bounded.md#decl-e15921640df89f0b), [TensorCore.EFMachine.scalarSumWithLean](Native.md#decl-e4ccd3078c932ff1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23)

</details>

</details>

<a id="decl-f2a2e92b799d4090"></a>

<details>
<summary><code>TensorCore.EFMachine.Components.scalarWithLean</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L85)

```lean
def Components.scalarWithLean (c : Components) : Option F32 := do
  if !c.scalarGuard then none else do
    let eBits ← scalarSumWithLean c.low
    let e ← decode32Word eBits
    if !e.sameValue c.residualSum then none else do
      let dBits ← c.prepared.output.exact32
      let oBits ← c.overlap.neg.exact32
      let hBits ← add32WithLean dBits oBits
      let h ← decode32Word hBits
      if !h.sameValue c.retained then none else add32WithLean hBits eBits
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Components](Bounded.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalarGuard](Bounded.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Prepared](Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Bounded.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.neg](Machine/WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.sameValue](Bounded.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.decode32Word](Machine/DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.scalarSumWithLean](Native.md#decl-e4ccd3078c932ff1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8)

</details>

</details>

<a id="decl-cc00897e3b21cc23"></a>

<details>
<summary><code>TensorCore.EFMachine.Components.scalarWithLean_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L96)

```lean
theorem Components.scalarWithLean_eq (c : Components) : c.scalarWithLean = c.scalar := by
  simp only [Components.scalarWithLean, Components.scalar, scalarSumWithLean_eq, add32WithLean_eq]
```

**Supporting proofs:** [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.scalarSumWithLean_eq](Native.md#decl-068a2eb7a865b141)

**Definitions and types:** [TensorCore.EFMachine.Components](Bounded.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalar](Bounded.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarGuard](Bounded.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Prepared](Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.exact32](Bounded.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.neg](Machine/WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.sameValue](Bounded.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.add32](Machine/DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.decode32Word](Machine/DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.scalarSum](Bounded.md#decl-e15921640df89f0b), [TensorCore.EFMachine.scalarSumWithLean](Native.md#decl-e4ccd3078c932ff1), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8)

</details>

</details>

<a id="decl-e854b34f0fadc9c3"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1WithLean</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L101)

```lean
/-- Algorithm 1 with native scalar additions, retaining bounded exact consolidation
when the scalar guard or intermediate checks refuse the scalar branch. -/
def algorithm1WithLean (path : Path) (x : BlockInput path.profile) (D : F32) : Except Error Result := do
  let p ← prepare path x D
  if p.terms.all (fun t => t.word.magnitude == 0) then return .allZero
  let some c := extract p | throw .arithmeticOverflow
  match c.scalarWithLean with
  | some b => return .scalar b
  | none =>
    match c.recovered.round32 with
    | some b => return .boundedExact b
    | none => return .outOfRange
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Components](Bounded.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Error](Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Magnitude](Machine/WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Path](Machine/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Result](Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Term](Machine/DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](Machine/WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.extract](Bounded.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.prepare](Bounded.md#decl-795b364db94203eb), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_correct](Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1WithLean_range_iff](Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](Native.md#decl-f7716cfd3ea68d35), [TensorCore.Regression.NativeEFT.single_v100_corrected](Regression/NativeEFT.md#decl-8bc682481480e65b)

</details>

</details>

<a id="decl-07076ef7735fa9b8"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1WithLean_eq</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L113)

```lean
/-- Every input preserves the entire result, including branch tags and errors. -/
theorem algorithm1WithLean_eq (path : Path) (x : BlockInput path.profile) (D : F32) :
    algorithm1WithLean path x D = algorithm1 path x D := by
  simp only [algorithm1WithLean, algorithm1, Components.scalarWithLean_eq]
  rfl
```

**Supporting proofs:** [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Components](Bounded.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalar](Bounded.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Error](Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Magnitude](Machine/WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Path](Machine/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Prepared](Bounded.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Result](Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Term](Machine/DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word](Machine/WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.round32](Machine/WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.algorithm1](Bounded.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.extract](Bounded.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.prepare](Bounded.md#decl-795b364db94203eb), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1WithLean_correct](Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_range_iff](Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](Native.md#decl-f7716cfd3ea68d35)

</details>

</details>

<a id="decl-44b89c4eb1a452d1"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1WithLean_correct</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L118)

```lean
theorem algorithm1WithLean_correct {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : ℚ} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    ∃ r, algorithm1WithLean path x D = .ok r ∧ r.bits = TensorCore.round32 .nearestEven s := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_correct hlen hx hD
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_correct](Machine/Correctness.md#decl-ec47f9869483c5f4)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](Machine/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Bounded.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](Bounded.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.exactDot](../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f7716cfd3ea68d35"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1WithLean_success</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L125)

```lean
theorem algorithm1WithLean_success {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : ℚ} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d)
    (hrange : absQ s ≤ maxFinite32) :
    ∃ r b, algorithm1WithLean path x D = .ok r ∧ r.bits = some b ∧ NearestEven32 s b := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_success hlen hx hD hrange
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_success](Machine/Correctness.md#decl-56c6ead02b649bea)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](Machine/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Bounded.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](Bounded.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.NearestEven32](../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.exactDot](../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8f27f77556b03c65"></a>

<details>
<summary><code>TensorCore.EFMachine.algorithm1WithLean_range_iff</code></summary>

[Lean source](../../../TensorCore/EFT/Native.lean#L133)

```lean
theorem algorithm1WithLean_range_iff {path : Path} {x : BlockInput path.profile}
    {D : F32} {s d : ℚ} (hlen : x.products.length = path.profile.products)
    (hx : TensorCore.exactDot x = some s) (hD : TensorCore.value32 D = some d) :
    (∃ r b, algorithm1WithLean path x D = .ok r ∧ r.bits = some b) ↔ absQ s ≤ maxFinite32 := by
  rw [algorithm1WithLean_eq]
  exact algorithm1_range_iff hlen hx hD
```

**Supporting proofs:** [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_range_iff](Machine/Correctness.md#decl-c9a066d91dcbea2c)

**Definitions and types:** [TensorCore.BlockInput](../TC/Block.md#decl-ad6b462d69117cc6), [TensorCore.EFMachine.Error](Bounded.md#decl-ae7458916e66d6a4), [TensorCore.EFMachine.Path](Machine/DecodeDefs.md#decl-2506d95eda2deaf1), [TensorCore.EFMachine.Path.profile](Machine/DecodeDefs.md#decl-ccec848a9e7609d0), [TensorCore.EFMachine.Result](Bounded.md#decl-dbcfe8dff7f13123), [TensorCore.EFMachine.Result.bits](Bounded.md#decl-5da5d1a0f8426a7b), [TensorCore.EFMachine.algorithm1](Bounded.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Profile](../TC/Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../TC/Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.exactDot](../TC/Block.md#decl-451fb68e7faa00f3), [TensorCore.maxFinite32](../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
