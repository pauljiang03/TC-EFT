# TensorCore.TC.Regression.DirectedBinary

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-2af499bff498a1cf"></a>

<details>
<summary><code>TensorCore.Regression.directed_binary_negative_and_carry</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L12)

```lean
theorem directed_binary_negative_and_carry :
    (roundBinary fp16 .towardNegative (1 / 3)).map BitVec.toNat = some 0x3555 ∧
    (roundBinary fp16 .towardPositive (1 / 3)).map BitVec.toNat = some 0x3556 ∧
    (roundBinary fp16 .towardNegative (-1 / 3)).map BitVec.toNat = some 0xb556 ∧
    (roundBinary fp16 .towardPositive (-1 / 3)).map BitVec.toNat = some 0xb555 ∧
    (roundBinary fp16 .towardNegative (2 - 1 / 2048)).map BitVec.toNat = some 0x3fff ∧
    (roundBinary fp16 .towardPositive (2 - 1 / 2048)).map BitVec.toNat = some 0x4000 ∧
    (roundBinary fp16 .towardNegative (-(2 - 1 / 2048))).map BitVec.toNat = some 0xc000 ∧
    (roundBinary fp16 .towardPositive (-(2 - 1 / 2048))).map BitVec.toNat = some 0xbfff := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-f495329299faba81"></a>

<details>
<summary><code>TensorCore.Regression.directed_binary_subnormal</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L23)

```lean
theorem directed_binary_subnormal :
    (roundBinary fp16 .towardNegative (1 / 33554432)).map BitVec.toNat = some 0 ∧
    (roundBinary fp16 .towardPositive (1 / 33554432)).map BitVec.toNat = some 1 ∧
    (roundBinary fp16 .towardNegative (-1 / 33554432)).map BitVec.toNat = some 0x8001 ∧
    (roundBinary fp16 .towardPositive (-1 / 33554432)).map BitVec.toNat = some 0x8000 ∧
    (roundBinary fp16 .towardNegative (2047 / 33554432)).map BitVec.toNat = some 0x03ff ∧
    (roundBinary fp16 .towardPositive (2047 / 33554432)).map BitVec.toNat = some 0x0400 ∧
    (roundBinary fp16 .towardNegative (-2047 / 33554432)).map BitVec.toNat = some 0x8400 ∧
    (roundBinary fp16 .towardPositive (-2047 / 33554432)).map BitVec.toNat = some 0x83ff := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-094ebf81b6307879"></a>

<details>
<summary><code>TensorCore.Regression.directed_binary_range</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L34)

```lean
theorem directed_binary_range :
    (roundBinary fp16 .towardNegative 65503).map BitVec.toNat = some 0x7bfe ∧
    (roundBinary fp16 .towardPositive 65503).map BitVec.toNat = some 0x7bff ∧
    (roundBinary fp16 .towardNegative (-65503)).map BitVec.toNat = some 0xfbff ∧
    (roundBinary fp16 .towardPositive (-65503)).map BitVec.toNat = some 0xfbfe ∧
    roundBinary fp16 .towardNegative 65505 = none ∧
    roundBinary fp16 .towardPositive 65505 = none ∧
    roundBinary fp16 .towardNegative (-65505) = none ∧
    roundBinary fp16 .towardPositive (-65505) = none := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4111f505a7465413"></a>

<details>
<summary><code>TensorCore.Regression.binary_all_modes_exact</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L45)

```lean
theorem binary_all_modes_exact (mode : BinaryRoundingMode) :
    (roundBinary fp16 mode 0).map BitVec.toNat = some 0 ∧
    (roundBinary fp16 mode (1 / 16777216)).map BitVec.toNat = some 1 ∧
    (roundBinary fp16 mode (-1 / 16777216)).map BitVec.toNat = some 0x8001 ∧
    (roundBinary fp16 mode (3 / 2)).map BitVec.toNat = some 0x3e00 ∧
    (roundBinary fp16 mode (-3 / 2)).map BitVec.toNat = some 0xbe00 ∧
    (roundBinary fp16 mode 65504).map BitVec.toNat = some 0x7bff ∧
    (roundBinary fp16 mode (-65504)).map BitVec.toNat = some 0xfbff := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-c538fbb1a39bf7b6"></a>

<details>
<summary><code>TensorCore.Regression.directed_binary_formats</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L55)

```lean
theorem directed_binary_formats :
    (roundBinary bf16 .towardNegative (-1 / 3)).map BitVec.toNat = some 0xbeab ∧
    (roundBinary bf16 .towardPositive (-1 / 3)).map BitVec.toNat = some 0xbeaa ∧
    (roundBinary tf19 .towardNegative (-1 / 3)).map BitVec.toNat = some 0x5f556 ∧
    (roundBinary tf19 .towardPositive (-1 / 3)).map BitVec.toNat = some 0x5f555 ∧
    (roundBinary fp32 .towardNegative (-1 / 3)).map BitVec.toNat = some 0xbeaaaaab ∧
    (roundBinary fp32 .towardPositive (-1 / 3)).map BitVec.toNat = some 0xbeaaaaaa ∧
    (roundBinary fp64 .towardNegative (-1 / 3)).map BitVec.toNat = some 0xbfd5555555555556 ∧
    (roundBinary fp64 .towardPositive (-1 / 3)).map BitVec.toNat = some 0xbfd5555555555555 ∧
    (roundBinary e5m2 .towardNegative (-1 / 3)).map BitVec.toNat = some 0xb6 ∧
    (roundBinary e5m2 .towardPositive (-1 / 3)).map BitVec.toNat = some 0xb5 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.e5m2](../../Core/Defs.md#decl-e90066ecba9097ee), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7cbd49d6e0ce38c4"></a>

<details>
<summary><code>TensorCore.Regression.negative_subnormal_upper_contract</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L68)

```lean
theorem negative_subnormal_upper_contract : TowardPositive fp16 (-1 / 33554432) 0x8000 := by
  obtain ⟨b, hb, hc⟩ := roundBinary_towardPositive_correct fp16 (by decide)
    (-1 / 33554432) (by decide +kernel)
  have he : roundBinary fp16 .towardPositive (-1 / 33554432) = some 0x8000 := by decide +kernel
  rw [he] at hb
  cases Option.some.inj hb
  exact hc
```

**Supporting proofs:** [TensorCore.roundBinary_towardPositive_correct](../../Core/Binary/DirectedRounding.md#decl-a0d617c51646227e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.TowardPositive](../../Core/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6ef36ec120fedf99"></a>

<details>
<summary><code>TensorCore.Regression.negative_subnormal_lower_contract</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L76)

```lean
theorem negative_subnormal_lower_contract : TowardNegative fp16 (-1 / 33554432) 0x8001 := by
  obtain ⟨b, hb, hc⟩ := roundBinary_towardNegative_correct fp16 (by decide)
    (-1 / 33554432) (by decide +kernel)
  have he : roundBinary fp16 .towardNegative (-1 / 33554432) = some 0x8001 := by decide +kernel
  rw [he] at hb
  cases Option.some.inj hb
  exact hc
```

**Supporting proofs:** [TensorCore.roundBinary_towardNegative_correct](../../Core/Binary/DirectedRounding.md#decl-3b3e5c3213c35d5f)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.TowardNegative](../../Core/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-eaae17864f8d0089"></a>

<details>
<summary><code>TensorCore.Regression.directed_unusual_format</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L85)

```lean
/-- An unusual bias and minimum permitted field sizes exercise the unrestricted format theorem. -/
theorem directed_unusual_format (x : ℚ) (hr : absQ x ≤ (Format.mk 1 2 (-7)).maxFinite) :
    (∃ b, roundBinary ⟨1, 2, -7⟩ .towardNegative x = some b ∧ TowardNegative ⟨1, 2, -7⟩ x b) ∧
    (∃ b, roundBinary ⟨1, 2, -7⟩ .towardPositive x = some b ∧ TowardPositive ⟨1, 2, -7⟩ x b) :=
  ⟨roundBinary_towardNegative_correct _ (by decide) x hr,
    roundBinary_towardPositive_correct _ (by decide) x hr⟩
```

**Supporting proofs:** [TensorCore.roundBinary_towardNegative_correct](../../Core/Binary/DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](../../Core/Binary/DirectedRounding.md#decl-a0d617c51646227e)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.TowardNegative](../../Core/Binary/DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.TowardPositive](../../Core/Binary/DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6693e0fc3635ac42"></a>

<details>
<summary><code>TensorCore.Regression.fma64Bits</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L91)

```lean
def fma64Bits (mode : BinaryRoundingMode) (a b c : BitVec 64) : Option ℕ :=
  (evalInvocation (p := binary64Fma mode) ⟨[(a, b)], c⟩).toOption.map fun t => t.output.bits.toNat
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.ConversionStage](../../Core/Conversion.md#decl-19660b95e076faa1), [TensorCore.FiniteBinary](../../Core/Conversion.md#decl-819c01227290b53b), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InvocationError](../Invocation.md#decl-4afa1dfc6f87e57d), [TensorCore.InvocationInput](../Invocation.md#decl-6320316242fc8f99), [TensorCore.InvocationSpec](../Invocation.md#decl-686e1fb8fa675688), [TensorCore.InvocationTrace](../Invocation.md#decl-b63a56d7a7c92388), [TensorCore.OperandEncoding.Word](../../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.binary64Fma](../Profiles.md#decl-8bfe46830da92086), [TensorCore.evalInvocation](../Invocation.md#decl-d69509a8df45ebe4)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fma64_directed_half_ulp](DirectedBinary.md#decl-746fc7a28c7ab90a), [TensorCore.Regression.fma64_fused_boundaries](DirectedBinary.md#decl-6a45eabffa62d664), [TensorCore.Regression.fma64_subnormal](DirectedBinary.md#decl-2416711161dfbff9)

</details>

</details>

<a id="decl-746fc7a28c7ab90a"></a>

<details>
<summary><code>TensorCore.Regression.fma64_directed_half_ulp</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L94)

```lean
theorem fma64_directed_half_ulp :
    fma64Bits .towardNegative 0x3ff0000000000000 0x3ff0000000000000 0x3ca0000000000000 = some 0x3ff0000000000000 ∧
    fma64Bits .towardPositive 0x3ff0000000000000 0x3ff0000000000000 0x3ca0000000000000 = some 0x3ff0000000000001 ∧
    fma64Bits .towardNegative 0xbff0000000000000 0x3ff0000000000000 0xbca0000000000000 = some 0xbff0000000000001 ∧
    fma64Bits .towardPositive 0xbff0000000000000 0x3ff0000000000000 0xbca0000000000000 = some 0xbff0000000000000 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Regression.fma64Bits](DirectedBinary.md#decl-6693e0fc3635ac42)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2416711161dfbff9"></a>

<details>
<summary><code>TensorCore.Regression.fma64_subnormal</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L101)

```lean
theorem fma64_subnormal :
    fma64Bits .towardNegative 0x8000000000000001 0x3fe0000000000000 0 = some 0x8000000000000001 ∧
    fma64Bits .towardPositive 0x8000000000000001 0x3fe0000000000000 0 = some 0x8000000000000000 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Regression.fma64Bits](DirectedBinary.md#decl-6693e0fc3635ac42)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-6a45eabffa62d664"></a>

<details>
<summary><code>TensorCore.Regression.fma64_fused_boundaries</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L107)

```lean
/-- An out-of-range exact product is allowed when the single fused result is finite. -/
theorem fma64_fused_boundaries (mode : BinaryRoundingMode) :
    fma64Bits mode 0x7fefffffffffffff 0x4000000000000000 0xffefffffffffffff = some 0x7fefffffffffffff ∧
    fma64Bits mode 0xbff0000000000000 0x3ff0000000000000 0x3ff0000000000000 = some 0 ∧
    fma64Bits mode 0x7fefffffffffffff 0x4000000000000000 0 = none ∧
    fma64Bits mode 0x7ff0000000000000 0x3ff0000000000000 0 = none := by
  cases mode <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Regression.fma64Bits](DirectedBinary.md#decl-6693e0fc3635ac42)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7640a0640949b17b"></a>

<details>
<summary><code>TensorCore.Regression.positiveZero16</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L114)

```lean
def positiveZero16 : FiniteBinaryWord fp16 := ⟨0, ⟨⟨0, 0, 0⟩, by decide +kernel⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](../../Core/Binary/Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd)

<details>
<summary>Used by</summary>

[TensorCore.Regression.finite_bijection_signed_zeros](DirectedBinary.md#decl-8a62c9179ae2403a)

</details>

</details>

<a id="decl-886728ef6cdfd42e"></a>

<details>
<summary><code>TensorCore.Regression.negativeZero16</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L115)

```lean
def negativeZero16 : FiniteBinaryWord fp16 := ⟨0x8000, ⟨⟨0, 0, 0⟩, by decide +kernel⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](../../Core/Binary/Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd)

<details>
<summary>Used by</summary>

[TensorCore.Regression.finite_bijection_signed_zeros](DirectedBinary.md#decl-8a62c9179ae2403a)

</details>

</details>

<a id="decl-8a62c9179ae2403a"></a>

<details>
<summary><code>TensorCore.Regression.finite_bijection_signed_zeros</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L117)

```lean
theorem finite_bijection_signed_zeros :
    binaryValue fp16 positiveZero16.val = binaryValue fp16 negativeZero16.val ∧
    positiveZero16 ≠ negativeZero16 ∧
    (decodeSignedBinary fp16 (by decide) positiveZero16).negative = false ∧
    (decodeSignedBinary fp16 (by decide) negativeZero16).negative = true ∧
    (encodeSignedBinary fp16 (by decide)
      (decodeSignedBinary fp16 (by decide) negativeZero16)).val = 0x8000 ∧
    roundBinary fp16 .towardNegative (decodeSignedBinary fp16 (by decide) negativeZero16).value = some 0 := by
  refine ⟨by decide +kernel, by decide +kernel, by decide +kernel, by decide +kernel, ?_, by decide +kernel⟩
  exact congrArg Subtype.val (encode_decodeSignedBinary fp16 (by decide) negativeZero16)
```

**Supporting proofs:** [TensorCore.encode_decodeSignedBinary](../../Core/Binary/SignedBijection.md#decl-c65020fe3f9595ba)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Classification.finite](../../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.FiniteBinaryWord](../../Core/Binary/Defs.md#decl-b1ebef5bf580ea01), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Regression.negativeZero16](DirectedBinary.md#decl-886728ef6cdfd42e), [TensorCore.Regression.positiveZero16](DirectedBinary.md#decl-7640a0640949b17b), [TensorCore.SignedFiniteValue](../../Core/Binary/Defs.md#decl-86fdea2e792bf344), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.decodeSignedBinary](../../Core/Binary/SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.encodeSignedBinary](../../Core/Binary/SignedBijection.md#decl-1ab7a3966bec465c), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-b74680eb28ad51fd"></a>

<details>
<summary><code>TensorCore.Regression.finite_bijection_endpoints</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/DirectedBinary.lean#L128)

```lean
theorem finite_bijection_endpoints (mode : BinaryRoundingMode) :
    roundBinary fp64 mode (pow2 (-1074)) = some 1 ∧
    roundBinary fp64 mode (-fp64.maxFinite) = some 0xffefffffffffffff := by
  constructor
  · exact binaryValue_roundBinary fp64 (by decide) mode 1 _ (by decide +kernel) (by decide +kernel)
  · exact binaryValue_roundBinary fp64 (by decide) mode 0xffefffffffffffff _
      (by decide +kernel) (by decide +kernel)
```

**Supporting proofs:** [TensorCore.binaryValue_roundBinary](../../Core/Binary/RoundTrip.md#decl-9a5b73ab13b18c71)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.binaryValue](../../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
