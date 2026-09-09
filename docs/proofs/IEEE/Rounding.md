# TensorCore.IEEE.Rounding

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-1cdd013ea2ce0dce"></a>

<details>
<summary><code>TensorCore.IEEE.finiteBits</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L10)

```lean
/-- The old finite converter is total on its proved domain; no default output is used. -/
def finiteBits (f : BinaryFormat) (mode : BinaryRoundingMode) (x : ℚ)
    (hr : absQ x ≤ f.layout.maxFinite) : Word f :=
  (roundBinary f.layout mode x).get ((roundBinary_isSome_iff _ _ _).mpr ⟨f.valid, hr⟩)
```

**Supporting proofs:** [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.roundBinary_isSome_iff](../Core/Binary/RoundingContract.md#decl-9083817d3e897973)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.finiteBits32_encode](LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.finiteBits_correct](Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-00e71abfcdfd8abb"></a>

<details>
<summary><code>TensorCore.IEEE.finiteBits_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L14)

```lean
theorem finiteBits_eq (f : BinaryFormat) (mode : BinaryRoundingMode) (x : ℚ)
    (hr : absQ x ≤ f.layout.maxFinite) :
    roundBinary f.layout mode x = some (finiteBits f mode x hr) := by
  exact (Option.some_get _).symm
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.finiteBits32_encode](LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.finiteBits_correct](Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

</details>

</details>

<a id="decl-95af8d895fd749ac"></a>

<details>
<summary><code>TensorCore.IEEE.finiteBits_correct</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L19)

```lean
theorem finiteBits_correct (f : BinaryFormat) (mode : BinaryRoundingMode) (x : ℚ)
    (hr : absQ x ≤ f.layout.maxFinite) :
    BinaryRoundSpec f.layout mode x (finiteBits f mode x hr) := by
  obtain ⟨b, hb, hs⟩ := roundBinary_correct f.layout f.valid mode x hr
  have he := Option.some.inj (hb.symm.trans (finiteBits_eq f mode x hr))
  simpa [← he] using hs
```

**Supporting proofs:** [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.roundBinary_correct](../Core/Binary/RoundingContract.md#decl-12a22af180d3ad5e)

**Definitions and types:** [TensorCore.BinaryRoundSpec](../Core/Binary/RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

</details>

</details>

<a id="decl-060b290d21f2ceee"></a>

<details>
<summary><code>TensorCore.IEEE.overflowToInfinity</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L26)

```lean
def overflowToInfinity (mode : BinaryRoundingMode) (negative : Bool) : Bool :=
  match mode with
  | .nearestEven => true
  | .towardZero => false
  | .towardNegative => negative
  | .towardPositive => !negative
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-33fe2598430cb212"></a>

<details>
<summary><code>TensorCore.IEEE.tiny</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L33)

```lean
def tiny (f : BinaryFormat) (cfg : Context) (m u : ℚ) : Bool :=
  let a := match cfg.tininess with
    | .beforeRounding => m
    | .afterRounding => u
  decide (0 < a ∧ a < pow2 f.layout.emin)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-e686eb7fa2b669b5"></a>

<details>
<summary><code>TensorCore.IEEE.round</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L39)

```lean
def round (f : BinaryFormat) (cfg : Context) (zeroSign : Bool) (x : ℚ) : Result f :=
  if x = 0 then ⟨zero f zeroSign, {}⟩ else
  let negative := decide (x < 0)
  let m := absQ x
  let u := precisionMagnitude f.layout cfg.mode negative m
  if hr : m ≤ f.layout.maxFinite then
    let b := finiteBits f cfg.mode x hr
    let inexact := decide (binaryValue f.layout b ≠ some x)
    ⟨b, { inexact, underflow := tiny f cfg m u && inexact }⟩
  else
    let overflow := decide (f.layout.maxFinite < u)
    ⟨if overflow && overflowToInfinity cfg.mode negative then infinity f negative
      else maxFiniteWord f negative,
     { overflow, inexact := true }⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.Regression.directed_overflow](Tests/Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.gradual_underflow](Tests/Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.near_overflow](Tests/Regression.md#decl-c37522c37f5d3371), [TensorCore.IEEE.Regression.normal_output_underflow](Tests/Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.sticky_flags](Tests/Regression.md#decl-6f46397e23c85174), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-b049ff2d5079187f"></a>

<details>
<summary><code>TensorCore.IEEE.RoundSpec</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L57)

```lean
/-- The numerical specification refers to the previously proved optimality
relations on the finite domain. Beyond it, the precision-only result determines
overflow; a non-overflowing excess rounds to the signed endpoint. -/
def RoundSpec (f : BinaryFormat) (cfg : Context) (zeroSign : Bool) (x : ℚ)
    (r : Result f) : Prop :=
  if x = 0 then r.bits = zero f zeroSign ∧ r.flags = {} else
  ∃ u : ℚ, PrecisionRound f.layout cfg.mode (decide (x < 0)) (absQ x) u ∧
    if absQ x ≤ f.layout.maxFinite then
      BinaryRoundSpec f.layout cfg.mode x r.bits ∧
      sign f r.bits = decide (x < 0) ∧
      r.flags.invalid = false ∧ r.flags.divideByZero = false ∧ r.flags.overflow = false ∧
      (r.flags.inexact = true ↔ binaryValue f.layout r.bits ≠ some x) ∧
      (r.flags.underflow = true ↔ tiny f cfg (absQ x) u = true ∧ r.flags.inexact = true)
    else
      (r.flags.overflow = true ↔ f.layout.maxFinite < u) ∧
      r.flags.invalid = false ∧ r.flags.divideByZero = false ∧ r.flags.underflow = false ∧
      r.flags.inexact = true ∧
      r.bits = if f.layout.maxFinite < u ∧ overflowToInfinity cfg.mode (decide (x < 0)) = true
        then infinity f (decide (x < 0)) else maxFiniteWord f (decide (x < 0))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundSpec](../Core/Binary/RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.PrecisionRound](Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac)

</details>

</details>

<a id="decl-c507d7376a5b55ac"></a>

<details>
<summary><code>TensorCore.IEEE.round_correct</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L76)

```lean
/-- All finite rational inputs have a specified result, including zero,
overflow, gradual underflow, and precision loss; no success premise is assumed. -/
theorem round_correct (f : BinaryFormat) (cfg : Context) (zeroSign : Bool) (x : ℚ) :
    RoundSpec f cfg zeroSign x (round f cfg zeroSign x) := by
  by_cases hz : x = 0
  · simp [RoundSpec, round, hz]
  · simp only [RoundSpec, round, hz, ↓reduceIte]
    refine ⟨precisionMagnitude f.layout cfg.mode (decide (x < 0)) (absQ x),
      precisionMagnitude_correct _ _ _ _ (absQ_nonneg x), ?_⟩
    split
    · rename_i hr
      dsimp only
      have hs := roundBinary_sign f.layout cfg.mode x (finiteBits f cfg.mode x hr)
        (finiteBits_eq f cfg.mode x hr)
      exact ⟨finiteBits_correct f cfg.mode x hr, hs, rfl, rfl, rfl,
        by simp, by simp⟩
    · dsimp only
      simp
```

**Supporting proofs:** [TensorCore.IEEE.finiteBits_correct](Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.precisionMagnitude_correct](Precision.md#decl-248cb65f71cd879e), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd), [TensorCore.roundBinary_sign](../Core/Binary/RoundingContract.md#decl-89538250b2c31eac)

**Definitions and types:** [TensorCore.BinaryRoundSpec](../Core/Binary/RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.PrecisionRound](Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binarySign](../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2)

</details>

</details>

<a id="decl-8c10d9eec6663da4"></a>

<details>
<summary><code>TensorCore.IEEE.round_agrees_finite</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L95)

```lean
/-- On the original domain the new and old numeric encodings coincide whenever
the exact result is nonzero. IEEE zero signs are governed by the operation. -/
theorem round_agrees_finite (f : BinaryFormat) (cfg : Context) (s : Bool) (x : ℚ)
    (hx : x ≠ 0) (hr : absQ x ≤ f.layout.maxFinite) :
    roundBinary f.layout cfg.mode x = some (round f cfg s x).bits := by
  simpa [round, hx, hr] using finiteBits_eq f cfg.mode x hr
```

**Supporting proofs:** [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb)

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.roundBinary](../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e)

</details>

</details>

<a id="decl-99b995352bd4bae1"></a>

<details>
<summary><code>TensorCore.IEEE.round_zero</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L100)

```lean
theorem round_zero (f : BinaryFormat) (cfg : Context) (s : Bool) :
    round f cfg s 0 = ⟨zero f s, {}⟩ := by simp [round]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e)

</details>

</details>

<a id="decl-a2f2823564beb359"></a>

<details>
<summary><code>TensorCore.IEEE.round_no_invalid</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L103)

```lean
theorem round_no_invalid (f : BinaryFormat) (cfg : Context) (s : Bool) (x : ℚ) :
    (round f cfg s x).flags.invalid = false ∧
    (round f cfg s x).flags.divideByZero = false := by
  by_cases hz : x = 0 <;> by_cases hr : absQ x ≤ f.layout.maxFinite <;> simp [round, hz, hr]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2fcf4462ca5a069c"></a>

<details>
<summary><code>TensorCore.IEEE.round_overflow_inexact</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L108)

```lean
theorem round_overflow_inexact (f : BinaryFormat) (cfg : Context) (s : Bool) (x : ℚ) :
    (round f cfg s x).flags.overflow = true → (round f cfg s x).flags.inexact = true := by
  by_cases hz : x = 0 <;> by_cases hr : absQ x ≤ f.layout.maxFinite <;> simp [round, hz, hr]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d69c07e73f191e1a"></a>

<details>
<summary><code>TensorCore.IEEE.round_underflow_inexact</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L112)

```lean
theorem round_underflow_inexact (f : BinaryFormat) (cfg : Context) (s : Bool) (x : ℚ) :
    (round f cfg s x).flags.underflow = true → (round f cfg s x).flags.inexact = true := by
  by_cases hz : x = 0 <;> by_cases hr : absQ x ≤ f.layout.maxFinite <;> simp [round, hz, hr]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-fd83276c6eaa7219"></a>

<details>
<summary><code>TensorCore.IEEE.round_overflow_iff</code></summary>

[Lean source](../../../TensorCore/IEEE/Rounding.lean#L118)

```lean
/-- The overflow flag exactly matches unbounded-exponent precision rounding,
including inputs just above the largest finite value that do not overflow. -/
theorem round_overflow_iff (f : BinaryFormat) (cfg : Context) (s : Bool) (x : ℚ) :
    (round f cfg s x).flags.overflow = true ↔
      f.layout.maxFinite < precisionMagnitude f.layout cfg.mode (decide (x < 0)) (absQ x) := by
  by_cases hz : x = 0
  · have hp := maxFinite_positive f
    simp [round, hz, precisionMagnitude, absQ, Rat.not_lt.mpr (Rat.le_of_lt hp)]
  · by_cases hr : absQ x ≤ f.layout.maxFinite
    · have hu := precisionMagnitude_le_max f.layout f.valid cfg.mode (decide (x < 0))
        (absQ x) (absQ_nonneg x) hr
      simp [round, hz, hr, Rat.not_lt.mpr hu]
    · simp [round, hz, hr]
```

**Supporting proofs:** [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.IEEE.maxFinite_positive](Basic.md#decl-33b32196fb355d13), [TensorCore.IEEE.precisionMagnitude_le_max](Precision.md#decl-c4d94067e704664f), [TensorCore.absQ_nonneg](../Core/Exact.md#decl-137ea017d6c4d0cd)

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCoefficient](../Core/Binary/RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.magnitudeExponent](../Core/RoundOp.md#decl-d0b00fe98f5e4d15), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
