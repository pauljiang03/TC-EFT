# TensorCore.Scalar.Specification

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-f0f3666a2c4cb86b"></a>

<details>
<summary><code>TensorCore.IEEE.InfinitySpec</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L9)

```lean
def InfinitySpec (f : BinaryFormat) (s : Bool) (r : Result f) : Prop :=
  decode f r.bits = .infinity s ∧ r.flags = {}
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-50a2ffd22287e912"></a>

<details>
<summary><code>TensorCore.IEEE.InvalidSpec</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L12)

```lean
def InvalidSpec (f : BinaryFormat) (r : Result f) : Prop :=
  (∃ s p, decode f r.bits = .nan s false p) ∧ r.flags = { invalid := true }
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-bf6736b83a880066"></a>

<details>
<summary><code>TensorCore.IEEE.NaNSpec</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L15)

```lean
def NaNSpec (f : BinaryFormat) (xs : List Datum) (extra : Bool) (r : Result f) : Prop :=
  let n := (chooseNaN xs).getD ⟨false, false, 0⟩
  decode f r.bits = .nan n.negative false (n.payload % quietBit f) ∧
  r.flags = { invalid := extra || xs.any Datum.isSignaling }
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isSignaling](Basic.md#decl-bb70a4a9636bee68), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.NaNInfo](Operations.md#decl-439f715d97b47f4b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.chooseNaN](Operations.md#decl-6747b80965c25567), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b)

</details>

</details>

<a id="decl-31a79d9ef7df4d0a"></a>

<details>
<summary><code>TensorCore.IEEE.infinityResult_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L20)

```lean
theorem infinityResult_correct (f : BinaryFormat) (s : Bool) :
    InfinitySpec f s (infinityResult f s) := ⟨decode_infinity f s, rfl⟩
```

**Supporting proofs:** [TensorCore.IEEE.decode_infinity](Basic.md#decl-a61646dd7f66db74)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-5ef2a9f5f3d8b53b"></a>

<details>
<summary><code>TensorCore.IEEE.nanResult_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L23)

```lean
theorem nanResult_correct (f : BinaryFormat) (xs : List Datum) (extra : Bool) :
    NaNSpec f xs extra (nanResult f xs extra) := ⟨decode_nan _ _ _, rfl⟩
```

**Supporting proofs:** [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isSignaling](Basic.md#decl-bb70a4a9636bee68), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.NaNInfo](Operations.md#decl-439f715d97b47f4b), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.chooseNaN](Operations.md#decl-6747b80965c25567), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-f2ace675f60bca9f"></a>

<details>
<summary><code>TensorCore.IEEE.invalidResult_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L26)

```lean
theorem invalidResult_correct (f : BinaryFormat) : InvalidSpec f (invalidResult f) :=
  ⟨⟨false, 0, by simpa [invalidResult, nanResult, chooseNaN] using decode_nan f false 0⟩, rfl⟩
```

**Supporting proofs:** [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isSignaling](Basic.md#decl-bb70a4a9636bee68), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.NaNInfo](Operations.md#decl-439f715d97b47f4b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.chooseNaN](Operations.md#decl-6747b80965c25567), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-03d998fb20725223"></a>

<details>
<summary><code>TensorCore.IEEE.AddSpec</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L30)

```lean
/-- Complete addition case table, including nonfinite inputs. -/
def AddSpec (f : BinaryFormat) (cfg : Context) (a b : Datum) (r : Result f) : Prop :=
  if a.isNaN || b.isNaN then NaNSpec f [a, b] false r else
  match a, b with
  | .finite sa x, .finite sb y => RoundSpec f cfg (sumZeroSign cfg.mode sa sb) (x + y) r
  | .infinity sa, .infinity sb =>
      if sa = sb then InfinitySpec f sa r else InvalidSpec f r
  | .infinity s, _ | _, .infinity s => InfinitySpec f s r
  | _, _ => False
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229)

</details>

</details>

<a id="decl-19709ea904a2d2db"></a>

<details>
<summary><code>TensorCore.IEEE.MulSpec</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L39)

```lean
def MulSpec (f : BinaryFormat) (cfg : Context) (a b : Datum) (r : Result f) : Prop :=
  if a.isNaN || b.isNaN then NaNSpec f [a, b] false r else
  match a, b with
  | .finite sa x, .finite sb y => RoundSpec f cfg (xor sa sb) (x * y) r
  | .infinity sa, .infinity sb => InfinitySpec f (xor sa sb) r
  | .infinity sa, .finite sb y =>
      if y = 0 then InvalidSpec f r else InfinitySpec f (xor sa sb) r
  | .finite sa x, .infinity sb =>
      if x = 0 then InvalidSpec f r else InfinitySpec f (xor sa sb) r
  | _, _ => False
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557)

</details>

</details>

<a id="decl-25cf556b40ff39bc"></a>

<details>
<summary><code>TensorCore.IEEE.FmaSpec</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L50)

```lean
def FmaSpec (f : BinaryFormat) (cfg : Context) (a b c : Datum) (r : Result f) : Prop :=
  if a.isNaN || b.isNaN || c.isNaN then NaNSpec f [a, b, c] (invalidProduct a b) r else
  match a, b, c with
  | .finite sa x, .finite sb y, .finite sc z =>
      RoundSpec f cfg (sumZeroSign cfg.mode (xor sa sb) sc) (x * y + z) r
  | .finite _ _, .finite _ _, .infinity sc => InfinitySpec f sc r
  | .infinity sa, .finite sb y, c =>
      if y = 0 then InvalidSpec f r else
      if c.isInfinite && xor sa sb != c.negative then InvalidSpec f r
      else InfinitySpec f (xor sa sb) r
  | .finite sa x, .infinity sb, c =>
      if x = 0 then InvalidSpec f r else
      if c.isInfinite && xor sa sb != c.negative then InvalidSpec f r
      else InfinitySpec f (xor sa sb) r
  | .infinity sa, .infinity sb, c =>
      if c.isInfinite && xor sa sb != c.negative then InvalidSpec f r
      else InfinitySpec f (xor sa sb) r
  | _, _, _ => False
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isInfinite](Basic.md#decl-850c48dc8c3c08ec), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.negative](Basic.md#decl-75faab7c3bc85104), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.invalidProduct](Operations.md#decl-b2f471fe29e20659), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954)

</details>

</details>

<a id="decl-e9f80536d82b3d98"></a>

<details>
<summary><code>TensorCore.IEEE.ConvertSpec</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L69)

```lean
def ConvertSpec (source target : BinaryFormat) (cfg : Context) (a : Datum) (r : Result target) : Prop :=
  match a with
  | .finite s x => RoundSpec target cfg s x r
  | .infinity s => InfinitySpec target s r
  | .nan s sig p =>
      decode target r.bits = .nan s false (convertPayload source target p % quietBit target) ∧
      r.flags = { invalid := sig }
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_correct](Specification.md#decl-b4246bf9e7d785bb)

</details>

</details>

<a id="decl-e6d467aa78f03a70"></a>

<details>
<summary><code>TensorCore.IEEE.addDatum_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L77)

```lean
theorem addDatum_correct (f : BinaryFormat) (cfg : Context) (a b : Datum) :
    AddSpec f cfg a b (addDatum f cfg a b) := by
  cases a <;> cases b <;>
    simp only [AddSpec, addDatum, Datum.isNaN, Bool.or_self, Bool.or_false,
      Bool.or_true, Bool.false_eq_true, ↓reduceIte, beq_iff_eq,
      round_correct, infinityResult_correct, nanResult_correct]
  split <;> first | exact infinityResult_correct _ _ | exact invalidResult_correct _
```

**Supporting proofs:** [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

**Definitions and types:** [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229)

</details>

</details>

<a id="decl-360e50b0170b46a2"></a>

<details>
<summary><code>TensorCore.IEEE.mulDatum_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L85)

```lean
theorem mulDatum_correct (f : BinaryFormat) (cfg : Context) (a b : Datum) :
    MulSpec f cfg a b (mulDatum f cfg a b) := by
  cases a <;> cases b <;>
    simp only [MulSpec, mulDatum, Datum.isNaN, Bool.or_self, Bool.or_false,
      Bool.or_true, Bool.false_eq_true, ↓reduceIte,
      round_correct, infinityResult_correct, nanResult_correct]
  all_goals split <;> first | exact infinityResult_correct _ _ | exact invalidResult_correct _
```

**Supporting proofs:** [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557)

</details>

</details>

<a id="decl-541a331629cf005e"></a>

<details>
<summary><code>TensorCore.IEEE.fmaDatum_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L93)

```lean
theorem fmaDatum_correct (f : BinaryFormat) (cfg : Context) (a b c : Datum) :
    FmaSpec f cfg a b c (fmaDatum f cfg a b c) := by
  cases a <;> cases b <;> cases c <;>
    simp only [FmaSpec, fmaDatum, invalidProduct, Datum.isNaN, Datum.isInfinite, Datum.isZero,
      Datum.negative, Bool.or_self, Bool.false_or, Bool.or_false, Bool.or_true,
      Bool.false_and, Bool.and_false, Bool.true_and, Bool.and_true, Bool.false_eq_true,
      ↓reduceIte, decide_eq_true_eq, round_correct, infinityResult_correct, nanResult_correct]
  all_goals split <;> (try simp only [infinityResult_correct, invalidResult_correct])
  all_goals split <;> first | exact infinityResult_correct _ _ | exact invalidResult_correct _
```

**Supporting proofs:** [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isInfinite](Basic.md#decl-850c48dc8c3c08ec), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.isZero](Basic.md#decl-27e8c7bd0f45da0e), [TensorCore.IEEE.Datum.negative](Basic.md#decl-75faab7c3bc85104), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidProduct](Operations.md#decl-b2f471fe29e20659), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3)

</details>

</details>

<a id="decl-fe25c16c8855e864"></a>

<details>
<summary><code>TensorCore.IEEE.convertDatum_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L103)

```lean
theorem convertDatum_correct (source target : BinaryFormat) (cfg : Context) (a : Datum) :
    ConvertSpec source target cfg a (convertDatum source target cfg a) := by
  cases a with
  | finite s x => exact round_correct _ _ _ _
  | infinity s => exact infinityResult_correct _ _
  | nan s sig p => exact ⟨decode_nan _ _ _, rfl⟩
```

**Supporting proofs:** [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_correct](Specification.md#decl-b4246bf9e7d785bb)

</details>

</details>

<a id="decl-919fdc4a27c1c36c"></a>

<details>
<summary><code>TensorCore.IEEE.add_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L111)

```lean
/-- Every pair of encoded inputs satisfies the complete addition contract. -/
theorem add_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b) (add f cfg a b) := addDatum_correct _ _ _ _
```

**Supporting proofs:** [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70)

**Definitions and types:** [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-442d19c4ff74e229"></a>

<details>
<summary><code>TensorCore.IEEE.sub_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L114)

```lean
theorem sub_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b).negate (sub f cfg a b) := addDatum_correct _ _ _ _
```

**Supporting proofs:** [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70)

**Definitions and types:** [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e6f4b1f0809e4557"></a>

<details>
<summary><code>TensorCore.IEEE.mul_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L117)

```lean
theorem mul_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    MulSpec f cfg (decode f a) (decode f b) (mul f cfg a b) := mulDatum_correct _ _ _ _
```

**Supporting proofs:** [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-dda77d4975712ce3"></a>

<details>
<summary><code>TensorCore.IEEE.fma_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L121)

```lean
/-- Exactly one rounding of the original decoded product plus addend. -/
theorem fma_correct (f : BinaryFormat) (cfg : Context) (a b c : Word f) :
    FmaSpec f cfg (decode f a) (decode f b) (decode f c) (fma f cfg a b c) :=
  fmaDatum_correct _ _ _ _ _
```

**Supporting proofs:** [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954)

</details>

</details>

<a id="decl-b4246bf9e7d785bb"></a>

<details>
<summary><code>TensorCore.IEEE.convert_correct</code></summary>

[Lean source](../../../TensorCore/Scalar/Specification.lean#L125)

```lean
theorem convert_correct (source target : BinaryFormat) (cfg : Context) (a : Word source) :
    ConvertSpec source target cfg (decode source a) (convert source target cfg a) :=
  convertDatum_correct _ _ _ _
```

**Supporting proofs:** [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
