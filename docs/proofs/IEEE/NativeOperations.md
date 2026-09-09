# TensorCore.IEEE.NativeOperations

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-060949a8c5e93a66"></a>

<details>
<summary><code>TensorCore.IEEE.inRangeResult32</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L12)

```lean
/-- Status for an exact finite result in range, using the supplied rounded bits.
This avoids computing the reference's rounded encoding again to obtain flags. -/
def inRangeResult32 (cfg : Context) (x : ℚ) (bits : F32) : Result .binary32 :=
  if x = 0 then ⟨bits, {}⟩ else
    let inexact := decide (binaryValue fp32 bits ≠ some x)
    let u := precisionMagnitude fp32 cfg.mode (decide (x < 0)) (absQ x)
    ⟨bits, { inexact, underflow := tiny .binary32 cfg (absQ x) u && inexact }⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458)

</details>

</details>

<a id="decl-ef34361af1c0715e"></a>

<details>
<summary><code>TensorCore.IEEE.inRangeResult32_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L18)

```lean
theorem inRangeResult32_eq (cfg : Context) (zeroSign : Bool) (x : ℚ) (bits : F32)
    (hr : absQ x ≤ fp32.maxFinite) (hb : bits = (round .binary32 cfg zeroSign x).bits) :
    inRangeResult32 cfg x bits = round .binary32 cfg zeroSign x := by
  rw [hb]
  by_cases hz : x = 0 <;>
    simp only [inRangeResult32, round, hz, hr, BinaryFormat.layout, ↓reduceIte, ↓reduceDIte]
  rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458)

</details>

</details>

<a id="decl-ec1af70180857547"></a>

<details>
<summary><code>TensorCore.IEEE.nativeAddResult32</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L26)

```lean
def nativeAddResult32 (cfg : Context) (a b : F32)
    (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b) : Result .binary32 :=
  inRangeResult32 cfg (finiteValue32 a + finiteValue32 b)
    (nativeAdd32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1))
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331)

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.Native32Valid](LeanBridge.md#decl-0fe78f96e2dccae0), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.addWithLean_native](NativeOperations.md#decl-fd6a11fc2eaba885), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458)

</details>

</details>

<a id="decl-b351d9aefeea34de"></a>

<details>
<summary><code>TensorCore.IEEE.nativeAddResult32_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L32)

```lean
/-- The native path preserves every observable bit and exception flag. -/
theorem nativeAddResult32_eq (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a + finiteValue32 b) ≤ fp32.maxFinite) :
    nativeAddResult32 cfg a b ha hb = add .binary32 cfg a b := by
  have href : add .binary32 cfg a b = round .binary32 cfg
      (sumZeroSign cfg.mode (sign32 a) (sign32 b)) (finiteValue32 a + finiteValue32 b) := by
    change addDatum .binary32 cfg (decode .binary32 a) (decode .binary32 b) = _
    rw [decode32_nonzero a ha, decode32_nonzero b hb]
    rfl
  have hbits := nativeAdd32_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeAddResult32
  rw [inRangeResult32_eq _ _ _ _ hr hbits, ← href]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeAdd32](LeanBridge.md#decl-dc54f4b7cbcc4fbf), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106)

</details>

</details>

<a id="decl-c4eba725df48223c"></a>

<details>
<summary><code>TensorCore.IEEE.inRangeResult64</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L49)

```lean
def inRangeResult64 (cfg : Context) (x : ℚ) (bits : F64) : Result .binary64 :=
  if x = 0 then ⟨bits, {}⟩ else
    let inexact := decide (binaryValue fp64 bits ≠ some x)
    let u := precisionMagnitude fp64 cfg.mode (decide (x < 0)) (absQ x)
    ⟨bits, { inexact, underflow := tiny .binary64 cfg (absQ x) u && inexact }⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-a4d1869f2183e5d6"></a>

<details>
<summary><code>TensorCore.IEEE.inRangeResult64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L55)

```lean
theorem inRangeResult64_eq (cfg : Context) (zeroSign : Bool) (x : ℚ) (bits : F64)
    (hr : absQ x ≤ fp64.maxFinite) (hb : bits = (round .binary64 cfg zeroSign x).bits) :
    inRangeResult64 cfg x bits = round .binary64 cfg zeroSign x := by
  rw [hb]
  by_cases hz : x = 0 <;>
    simp only [inRangeResult64, round, hz, hr, BinaryFormat.layout, ↓reduceIte, ↓reduceDIte]
  rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.overflowToInfinity](Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-f03febed232c86ff"></a>

<details>
<summary><code>TensorCore.IEEE.nativeAddResult64</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L63)

```lean
def nativeAddResult64 (cfg : Context) (a b : F64)
    (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) : Result .binary64 :=
  inRangeResult64 cfg (finiteValue64 a + finiteValue64 b)
    (nativeAdd64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1))
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.Native64Valid](LeanBridge64.md#decl-0e67059acc4694a0), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeAdd64](LeanBridge64.md#decl-edb49af988e758ce), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-5c0f5f79d45b4858"></a>

<details>
<summary><code>TensorCore.IEEE.nativeAddResult64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L68)

```lean
theorem nativeAddResult64_eq (cfg : Context) (a b : F64)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (hr : absQ (finiteValue64 a + finiteValue64 b) ≤ fp64.maxFinite) :
    nativeAddResult64 cfg a b ha hb = add .binary64 cfg a b := by
  have href : add .binary64 cfg a b = round .binary64 cfg
      (sumZeroSign cfg.mode (sign64 a) (sign64 b)) (finiteValue64 a + finiteValue64 b) := by
    change addDatum .binary64 cfg (decode .binary64 a) (decode .binary64 b) = _
    rw [decode64_nonzero a ha, decode64_nonzero b hb]
    rfl
  have hbits := nativeAdd64_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeAddResult64
  rw [inRangeResult64_eq _ _ _ _ hr hbits, ← href]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeAdd64](LeanBridge64.md#decl-edb49af988e758ce), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106)

</details>

</details>

<a id="decl-230fd7d0364069c2"></a>

<details>
<summary><code>TensorCore.IEEE.nativeSubResult64</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L85)

```lean
def nativeSubResult64 (cfg : Context) (a b : F64)
    (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) : Result .binary64 :=
  inRangeResult64 cfg (finiteValue64 a - finiteValue64 b)
    (nativeSub64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.nativeSub64](LeanBridge64.md#decl-7e84d1bdfb668472), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b)

</details>

</details>

<a id="decl-6eabc2e456b7b9e2"></a>

<details>
<summary><code>TensorCore.IEEE.nativeSubResult64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L90)

```lean
theorem nativeSubResult64_eq (cfg : Context) (a b : F64)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (hr : absQ (finiteValue64 a - finiteValue64 b) ≤ fp64.maxFinite) :
    nativeSubResult64 cfg a b ha hb = sub .binary64 cfg a b := by
  have href : sub .binary64 cfg a b = round .binary64 cfg
      (sumZeroSign cfg.mode (sign64 a) (!(sign64 b))) (finiteValue64 a - finiteValue64 b) := by
    change addDatum .binary64 cfg (decode .binary64 a) (decode .binary64 b).negate = _
    rw [decode64_nonzero a ha, decode64_nonzero b hb]
    simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
    rw [← Rat.sub_eq_add_neg]
    rfl
  have hbits := nativeSub64_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeSubResult64
  rw [inRangeResult64_eq _ _ _ _ hr hbits, ← href]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.nativeSub64](LeanBridge64.md#decl-7e84d1bdfb668472), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b)

</details>

</details>

<a id="decl-da7d8d0f36814d8f"></a>

<details>
<summary><code>TensorCore.IEEE.nativeMulResult64</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L109)

```lean
def nativeMulResult64 (cfg : Context) (a b : F64)
    (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) : Result .binary64 :=
  inRangeResult64 cfg (finiteValue64 a * finiteValue64 b)
    (nativeMul64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.nativeMul64](LeanBridge64.md#decl-ead2c816910837bb), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5)

</details>

</details>

<a id="decl-a3394de6c86087f5"></a>

<details>
<summary><code>TensorCore.IEEE.nativeMulResult64_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L114)

```lean
theorem nativeMulResult64_eq (cfg : Context) (a b : F64)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (hr : absQ (finiteValue64 a * finiteValue64 b) ≤ fp64.maxFinite) :
    nativeMulResult64 cfg a b ha hb = mul .binary64 cfg a b := by
  have href : mul .binary64 cfg a b = round .binary64 cfg
      (xor (sign64 a) (sign64 b)) (finiteValue64 a * finiteValue64 b) := by
    change mulDatum .binary64 cfg (decode .binary64 a) (decode .binary64 b) = _
    rw [decode64_nonzero a ha, decode64_nonzero b hb]
    rfl
  have hbits := nativeMul64_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeMulResult64
  rw [inRangeResult64_eq _ _ _ _ hr hbits, ← href]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.native64Valid_finite](LeanBridge64.md#decl-f4a4ecb5975d5479), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.exponent64](LeanBridge64.md#decl-ed36d48aa19e3495), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.LeanBridge.nativeMul64](LeanBridge64.md#decl-ead2c816910837bb), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign64](LeanBridge64.md#decl-8986cde2dee9c242), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070)

</details>

</details>

<a id="decl-69353adf32ad8f12"></a>

<details>
<summary><code>TensorCore.IEEE.addWithLean</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L134)

```lean
/-- Uses native FP32/FP64 addition only on the proved domain. Reference paths retain
zero operands, nonfinite operands, overflowing exact sums, other formats, and
other rounding modes. The reference itself is not removed or redefined. -/
def addWithLean : (f : BinaryFormat) → Context → Word f → Word f → Result f
  | .binary32, cfg, a, b =>
    let a32 : F32 := a
    let b32 : F32 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite32 a32 then
        if hb : NonzeroFinite32 b32 then
          if absQ (finiteValue32 a32 + finiteValue32 b32) ≤ fp32.maxFinite then
            nativeAddResult32 cfg a32 b32 ha hb
          else add .binary32 cfg a b
        else add .binary32 cfg a b
      else add .binary32 cfg a b
    else add .binary32 cfg a b
  | .binary16, cfg, a, b => add .binary16 cfg a b
  | .binary64, cfg, a, b =>
    let a64 : F64 := a
    let b64 : F64 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite64 a64 then
        if hb : NonzeroFinite64 b64 then
          if absQ (finiteValue64 a64 + finiteValue64 b64) ≤ fp64.maxFinite then
            nativeAddResult64 cfg a64 b64 ha hb
          else add .binary64 cfg a b
        else add .binary64 cfg a b
      else add .binary64 cfg a b
    else add .binary64 cfg a b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.addWithLean_correct](NativeOperations.md#decl-1d95790ca0574f94), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.addWithLean_native](NativeOperations.md#decl-fd6a11fc2eaba885), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67)

</details>

</details>

<a id="decl-fd6a11fc2eaba885"></a>

<details>
<summary><code>TensorCore.IEEE.addWithLean_native</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L161)

```lean
theorem addWithLean_native (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a + finiteValue32 b) ≤ fp32.maxFinite) :
    addWithLean .binary32 cfg a b = nativeAddResult32 cfg a b ha hb := by
  simp only [addWithLean, hm, ha, hb, hr, ↓reduceIte, ↓reduceDIte]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2635635840e5f106"></a>

<details>
<summary><code>TensorCore.IEEE.addWithLean_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L168)

```lean
/-- Total public-contract preservation, including every fallback case. -/
theorem addWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    addWithLean f cfg a b = add f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [addWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeAddResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [addWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeAddResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
```

**Supporting proofs:** [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.addWithLean_correct](NativeOperations.md#decl-1d95790ca0574f94)

</details>

</details>

<a id="decl-1d95790ca0574f94"></a>

<details>
<summary><code>TensorCore.IEEE.addWithLean_correct</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L187)

```lean
theorem addWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b) (addWithLean f cfg a b) := by
  rw [addWithLean_eq]
  exact add_correct f cfg a b
```

**Supporting proofs:** [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c)

**Definitions and types:** [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-32af219c859af336"></a>

<details>
<summary><code>TensorCore.IEEE.nativeSubResult32</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L192)

```lean
def nativeSubResult32 (cfg : Context) (a b : F32)
    (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b) : Result .binary32 :=
  inRangeResult32 cfg (finiteValue32 a - finiteValue32 b)
    (nativeSub32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.nativeSub32](LeanBridge.md#decl-d866a0a10fc49206), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.subWithLean_native](NativeOperations.md#decl-7f93d5f56de6f401)

</details>

</details>

<a id="decl-67c867c299bfa458"></a>

<details>
<summary><code>TensorCore.IEEE.nativeSubResult32_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L198)

```lean
/-- The native path preserves every observable bit and exception flag. -/
theorem nativeSubResult32_eq (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a - finiteValue32 b) ≤ fp32.maxFinite) :
    nativeSubResult32 cfg a b ha hb = sub .binary32 cfg a b := by
  have href : sub .binary32 cfg a b = round .binary32 cfg
      (sumZeroSign cfg.mode (sign32 a) (!(sign32 b))) (finiteValue32 a - finiteValue32 b) := by
    change addDatum .binary32 cfg (decode .binary32 a) (decode .binary32 b).negate = _
    rw [decode32_nonzero a ha, decode32_nonzero b hb]
    simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
    rw [← Rat.sub_eq_add_neg]
    rfl
  have hbits := nativeSub32_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeSubResult32
  rw [inRangeResult32_eq _ _ _ _ hr hbits, ← href]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.nativeSub32](LeanBridge.md#decl-d866a0a10fc49206), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.sumZeroSign](Operations.md#decl-e76da8ff91860117), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b)

</details>

</details>

<a id="decl-9d4b383e5cf47f67"></a>

<details>
<summary><code>TensorCore.IEEE.subWithLean</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L220)

```lean
/-- Uses native FP32/FP64 subtraction only on the proved domain. Reference paths retain
zero operands, nonfinite operands, out-of-range exact differences, other formats, and
other rounding modes. The reference itself is not removed or redefined. -/
def subWithLean : (f : BinaryFormat) → Context → Word f → Word f → Result f
  | .binary32, cfg, a, b =>
    let a32 : F32 := a
    let b32 : F32 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite32 a32 then
        if hb : NonzeroFinite32 b32 then
          if absQ (finiteValue32 a32 - finiteValue32 b32) ≤ fp32.maxFinite then
            nativeSubResult32 cfg a32 b32 ha hb
          else sub .binary32 cfg a b
        else sub .binary32 cfg a b
      else sub .binary32 cfg a b
    else sub .binary32 cfg a b
  | .binary16, cfg, a, b => sub .binary16 cfg a b
  | .binary64, cfg, a, b =>
    let a64 : F64 := a
    let b64 : F64 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite64 a64 then
        if hb : NonzeroFinite64 b64 then
          if absQ (finiteValue64 a64 - finiteValue64 b64) ≤ fp64.maxFinite then
            nativeSubResult64 cfg a64 b64 ha hb
          else sub .binary64 cfg a b
        else sub .binary64 cfg a b
      else sub .binary64 cfg a b
    else sub .binary64 cfg a b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.subWithLean_native](NativeOperations.md#decl-7f93d5f56de6f401)

</details>

</details>

<a id="decl-7f93d5f56de6f401"></a>

<details>
<summary><code>TensorCore.IEEE.subWithLean_native</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L247)

```lean
theorem subWithLean_native (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a - finiteValue32 b) ≤ fp32.maxFinite) :
    subWithLean .binary32 cfg a b = nativeSubResult32 cfg a b ha hb := by
  simp only [subWithLean, hm, ha, hb, hr, ↓reduceIte, ↓reduceDIte]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-fe6bb7e80b5ded0b"></a>

<details>
<summary><code>TensorCore.IEEE.subWithLean_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L254)

```lean
/-- Total public-contract preservation, including every fallback case. -/
theorem subWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    subWithLean f cfg a b = sub f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [subWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeSubResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [subWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeSubResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
```

**Supporting proofs:** [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb)

</details>

</details>

<a id="decl-7ab9a6f1a2efdedb"></a>

<details>
<summary><code>TensorCore.IEEE.subWithLean_correct</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L273)

```lean
theorem subWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b).negate (subWithLean f cfg a b) := by
  rw [subWithLean_eq]
  exact sub_correct f cfg a b
```

**Supporting proofs:** [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229)

**Definitions and types:** [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-8a60d5b139a47392"></a>

<details>
<summary><code>TensorCore.IEEE.nativeMulResult32</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L278)

```lean
def nativeMulResult32 (cfg : Context) (a b : F32)
    (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b) : Result .binary32 :=
  inRangeResult32 cfg (finiteValue32 a * finiteValue32 b)
    (nativeMul32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.nativeMul32](LeanBridge.md#decl-93b4e43615f002f9), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mulWithLean_native](NativeOperations.md#decl-fbd7d0b915acb4bd), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f)

</details>

</details>

<a id="decl-b72459f5eb7df15f"></a>

<details>
<summary><code>TensorCore.IEEE.nativeMulResult32_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L284)

```lean
/-- The native path preserves every observable bit and exception flag. -/
theorem nativeMulResult32_eq (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a * finiteValue32 b) ≤ fp32.maxFinite) :
    nativeMulResult32 cfg a b ha hb = mul .binary32 cfg a b := by
  have href : mul .binary32 cfg a b = round .binary32 cfg
      (xor (sign32 a) (sign32 b)) (finiteValue32 a * finiteValue32 b) := by
    change mulDatum .binary32 cfg (decode .binary32 a) (decode .binary32 b) = _
    rw [decode32_nonzero a ha, decode32_nonzero b hb]
    rfl
  have hbits := nativeMul32_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeMulResult32
  rw [inRangeResult32_eq _ _ _ _ hr hbits, ← href]
```

**Supporting proofs:** [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.native32Valid_finite](LeanBridge.md#decl-b3a588347820a331), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.exponent32](LeanBridge.md#decl-0adbaa005ea3261f), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.nativeMul32](LeanBridge.md#decl-93b4e43615f002f9), [TensorCore.IEEE.LeanBridge.nativeSign](LeanBridge.md#decl-853301706a16606f), [TensorCore.IEEE.LeanBridge.sign32](LeanBridge.md#decl-77f60cc9955604c1), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070)

</details>

</details>

<a id="decl-13fcf73d5e1341d3"></a>

<details>
<summary><code>TensorCore.IEEE.mulWithLean</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L304)

```lean
/-- Uses native FP32/FP64 multiplication only on the proved domain. Reference paths retain
zero operands, nonfinite operands, out-of-range exact products, other formats, and
other rounding modes. The reference itself is not removed or redefined. -/
def mulWithLean : (f : BinaryFormat) → Context → Word f → Word f → Result f
  | .binary32, cfg, a, b =>
    let a32 : F32 := a
    let b32 : F32 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite32 a32 then
        if hb : NonzeroFinite32 b32 then
          if absQ (finiteValue32 a32 * finiteValue32 b32) ≤ fp32.maxFinite then
            nativeMulResult32 cfg a32 b32 ha hb
          else mul .binary32 cfg a b
        else mul .binary32 cfg a b
      else mul .binary32 cfg a b
    else mul .binary32 cfg a b
  | .binary16, cfg, a, b => mul .binary16 cfg a b
  | .binary64, cfg, a, b =>
    let a64 : F64 := a
    let b64 : F64 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite64 a64 then
        if hb : NonzeroFinite64 b64 then
          if absQ (finiteValue64 a64 * finiteValue64 b64) ≤ fp64.maxFinite then
            nativeMulResult64 cfg a64 b64 ha hb
          else mul .binary64 cfg a b
        else mul .binary64 cfg a b
      else mul .binary64 cfg a b
    else mul .binary64 cfg a b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.mulWithLean_correct](NativeOperations.md#decl-67cfb7377bb37ad8), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mulWithLean_native](NativeOperations.md#decl-fbd7d0b915acb4bd)

</details>

</details>

<a id="decl-fbd7d0b915acb4bd"></a>

<details>
<summary><code>TensorCore.IEEE.mulWithLean_native</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L331)

```lean
theorem mulWithLean_native (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a * finiteValue32 b) ≤ fp32.maxFinite) :
    mulWithLean .binary32 cfg a b = nativeMulResult32 cfg a b ha hb := by
  simp only [mulWithLean, hm, ha, hb, hr, ↓reduceIte, ↓reduceDIte]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-5d277c7bbd841070"></a>

<details>
<summary><code>TensorCore.IEEE.mulWithLean_eq</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L338)

```lean
/-- Total public-contract preservation, including every fallback case. -/
theorem mulWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    mulWithLean f cfg a b = mul f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [mulWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeMulResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [mulWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeMulResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
```

**Supporting proofs:** [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.F64](LeanBridge64.md#decl-5e4c6b31b1817a74), [TensorCore.IEEE.LeanBridge.NonzeroFinite32](LeanBridge.md#decl-934581d157f94b85), [TensorCore.IEEE.LeanBridge.NonzeroFinite64](LeanBridge64.md#decl-ba104ae2a8389734), [TensorCore.IEEE.LeanBridge.finiteValue32](LeanBridge.md#decl-ec545ce67195b15f), [TensorCore.IEEE.LeanBridge.finiteValue64](LeanBridge64.md#decl-719acb811d540de8), [TensorCore.IEEE.LeanBridge.mantissa32](LeanBridge.md#decl-386e42fa55e98031), [TensorCore.IEEE.LeanBridge.mantissa64](LeanBridge64.md#decl-aae21efd45125e0b), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.mulWithLean_correct](NativeOperations.md#decl-67cfb7377bb37ad8)

</details>

</details>

<a id="decl-67cfb7377bb37ad8"></a>

<details>
<summary><code>TensorCore.IEEE.mulWithLean_correct</code></summary>

[Lean source](../../../TensorCore/IEEE/NativeOperations.lean#L357)

```lean
theorem mulWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    MulSpec f cfg (decode f a) (decode f b) (mulWithLean f cfg a b) := by
  rw [mulWithLean_eq]
  exact mul_correct f cfg a b
```

**Supporting proofs:** [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557)

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
