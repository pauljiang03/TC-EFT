# TensorCore.Scalar.Operations

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-439f715d97b47f4b"></a>

<details>
<summary><code>TensorCore.IEEE.NaNInfo</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L11)

```lean
structure NaNInfo where
  negative : Bool
  signaling : Bool
  payload : ℕ
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.Datum.nanInfo](Operations.md#decl-4731f592ede9f980), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.chooseNaN](Operations.md#decl-6747b80965c25567), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b)

</details>

</details>

<a id="decl-4731f592ede9f980"></a>

<details>
<summary><code>TensorCore.IEEE.Datum.nanInfo</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L17)

```lean
def Datum.nanInfo : Datum → Option NaNInfo
  | .nan s sig p => some ⟨s, sig, p⟩
  | _ => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.NaNInfo](Operations.md#decl-439f715d97b47f4b)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.chooseNaN](Operations.md#decl-6747b80965c25567)

</details>

</details>

<a id="decl-6747b80965c25567"></a>

<details>
<summary><code>TensorCore.IEEE.chooseNaN</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L21)

```lean
def chooseNaN (xs : List Datum) : Option NaNInfo :=
  let ns := xs.filterMap Datum.nanInfo
  (ns.find? (·.signaling)).or ns.head?
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.nanInfo](Operations.md#decl-4731f592ede9f980), [TensorCore.IEEE.NaNInfo](Operations.md#decl-439f715d97b47f4b)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b)

</details>

</details>

<a id="decl-c0ed43c28229a37e"></a>

<details>
<summary><code>TensorCore.IEEE.nanResult</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L25)

```lean
def nanResult (f : BinaryFormat) (xs : List Datum) (extraInvalid : Bool := false) : Result f :=
  let n := (chooseNaN xs).getD ⟨false, false, 0⟩
  ⟨nan f n.negative n.payload, { invalid := extraInvalid || xs.any Datum.isSignaling }⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isSignaling](Basic.md#decl-bb70a4a9636bee68), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.NaNInfo](Operations.md#decl-439f715d97b47f4b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.chooseNaN](Operations.md#decl-6747b80965c25567), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b)

</details>

</details>

<a id="decl-14941c0c62b980d6"></a>

<details>
<summary><code>TensorCore.IEEE.infinityResult</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L29)

```lean
def infinityResult (f : BinaryFormat) (s : Bool) : Result f := ⟨infinity f s, {}⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-07769958a12ce9c8"></a>

<details>
<summary><code>TensorCore.IEEE.invalidResult</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L31)

```lean
def invalidResult (f : BinaryFormat) : Result f := nanResult f [] true
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-e76da8ff91860117"></a>

<details>
<summary><code>TensorCore.IEEE.sumZeroSign</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L35)

```lean
/-- Used only for an exact zero sum. Equal zero signs survive; cancellation of
opposite signs selects negative zero precisely in the downward mode. -/
def sumZeroSign (mode : BinaryRoundingMode) (a b : Bool) : Bool :=
  if a == b then a else mode == .towardNegative
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Numerics/Binary/RoundOp.md#decl-00a7255be9b19e5a)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954)

</details>

</details>

<a id="decl-0794933f4c870994"></a>

<details>
<summary><code>TensorCore.IEEE.addDatum</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L38)

```lean
def addDatum (f : BinaryFormat) (cfg : Context) (a b : Datum) : Result f :=
  if a.isNaN || b.isNaN then nanResult f [a, b] else
  match a, b with
  | .finite sa x, .finite sb y => round f cfg (sumZeroSign cfg.mode sa sb) (x + y)
  | .infinity sa, .infinity sb =>
      if sa == sb then infinityResult f sa else invalidResult f
  | .infinity s, _ | _, .infinity s => infinityResult f s
  | _, _ => invalidResult f
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b)

</details>

</details>

<a id="decl-af85367bf8208a72"></a>

<details>
<summary><code>TensorCore.IEEE.mulDatum</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L47)

```lean
def mulDatum (f : BinaryFormat) (cfg : Context) (a b : Datum) : Result f :=
  if a.isNaN || b.isNaN then nanResult f [a, b] else
  match a, b with
  | .finite sa x, .finite sb y => round f cfg (xor sa sb) (x * y)
  | .infinity sa, .infinity sb => infinityResult f (xor sa sb)
  | .infinity sa, .finite sb y =>
      if y = 0 then invalidResult f else infinityResult f (xor sa sb)
  | .finite sa x, .infinity sb =>
      if x = 0 then invalidResult f else infinityResult f (xor sa sb)
  | _, _ => invalidResult f
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-b2f471fe29e20659"></a>

<details>
<summary><code>TensorCore.IEEE.invalidProduct</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L58)

```lean
def invalidProduct (a b : Datum) : Bool :=
  (a.isInfinite && b.isZero) || (a.isZero && b.isInfinite)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isInfinite](Basic.md#decl-850c48dc8c3c08ec), [TensorCore.IEEE.Datum.isZero](Basic.md#decl-27e8c7bd0f45da0e)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954)

</details>

</details>

<a id="decl-facf9b59e1cbf7de"></a>

<details>
<summary><code>TensorCore.IEEE.fmaDatum</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L61)

```lean
def fmaDatum (f : BinaryFormat) (cfg : Context) (a b c : Datum) : Result f :=
  if a.isNaN || b.isNaN || c.isNaN then nanResult f [a, b, c] (invalidProduct a b) else
  if invalidProduct a b then invalidResult f else
  let sp := xor a.negative b.negative
  if a.isInfinite || b.isInfinite then
    if c.isInfinite && sp != c.negative then invalidResult f else infinityResult f sp
  else
    match a, b, c with
    | .finite _ x, .finite _ y, .finite sc z =>
        round f cfg (sumZeroSign cfg.mode sp sc) (x * y + z)
    | _, _, .infinity s => infinityResult f s
    | _, _, _ => invalidResult f
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isInfinite](Basic.md#decl-850c48dc8c3c08ec), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.negative](Basic.md#decl-75faab7c3bc85104), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidProduct](Operations.md#decl-b2f471fe29e20659), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e)

</details>

</details>

<a id="decl-7e1f336bdb43c1b4"></a>

<details>
<summary><code>TensorCore.IEEE.add</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L74)

```lean
def add (f : BinaryFormat) (cfg : Context) (a b : Word f) : Result f :=
  addDatum f cfg (decode f a) (decode f b)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c)

</details>

</details>

<a id="decl-c0ce25b051e73b2b"></a>

<details>
<summary><code>TensorCore.IEEE.sub</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L77)

```lean
def sub (f : BinaryFormat) (cfg : Context) (a b : Word f) : Result f :=
  addDatum f cfg (decode f a) (decode f b).negate
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229)

</details>

</details>

<a id="decl-c121f20d96d6a64e"></a>

<details>
<summary><code>TensorCore.IEEE.mul</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L80)

```lean
def mul (f : BinaryFormat) (cfg : Context) (a b : Word f) : Result f :=
  mulDatum f cfg (decode f a) (decode f b)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557)

</details>

</details>

<a id="decl-5173f8a4ff82ac61"></a>

<details>
<summary><code>TensorCore.IEEE.fma</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L83)

```lean
def fma (f : BinaryFormat) (cfg : Context) (a b c : Word f) : Result f :=
  fmaDatum f cfg (decode f a) (decode f b) (decode f c)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954)

</details>

</details>

<a id="decl-e35efe8a503f3ae3"></a>

<details>
<summary><code>TensorCore.IEEE.convertPayload</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L88)

```lean
/-- Payloads are left aligned, matching their positions following the quiet bit.
Narrowing discards low payload bits; widening followed by narrowing preserves them. -/
def convertPayload (source target : BinaryFormat) (p : ℕ) : ℕ :=
  if source.layout.fractionBits ≤ target.layout.fractionBits then
    p * 2 ^ (target.layout.fractionBits - source.layout.fractionBits)
  else p / 2 ^ (source.layout.fractionBits - target.layout.fractionBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Numerics/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convertPayload_bounded](Compatibility.md#decl-78bff6c53f7ce3d2), [TensorCore.IEEE.convertPayload_roundtrip](Compatibility.md#decl-9386b7dd0de650fe), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c)

</details>

</details>

<a id="decl-ead5be4619d6f294"></a>

<details>
<summary><code>TensorCore.IEEE.convertDatum</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L93)

```lean
def convertDatum (source target : BinaryFormat) (cfg : Context) (a : Datum) : Result target :=
  match a with
  | .finite s x => round target cfg s x
  | .infinity s => infinityResult target s
  | .nan s sig p => ⟨nan target s (convertPayload source target p), { invalid := sig }⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c)

</details>

</details>

<a id="decl-4f62188c5500d3b7"></a>

<details>
<summary><code>TensorCore.IEEE.convert</code></summary>

[Lean source](../../../TensorCore/Scalar/Operations.lean#L99)

```lean
def convert (source target : BinaryFormat) (cfg : Context) (a : Word source) : Result target :=
  convertDatum source target cfg (decode source a)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_correct](Specification.md#decl-b4246bf9e7d785bb), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c)

</details>

</details>
