# TensorCore.TC.Regression.BinaryRounding

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-91e4669037d12352"></a>

<details>
<summary><code>TensorCore.Regression.binary_rounding_ties</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L14)

```lean
/-- Midpoints round to even in every format; truncation keeps the lower neighbor. -/
theorem binary_rounding_ties :
    (roundBinary fp16 .nearestEven (1 + 1 / 2048)).map BitVec.toNat = some 0x3c00 ∧
    (roundBinary fp16 .nearestEven (1 + 3 / 2048)).map BitVec.toNat = some 0x3c02 ∧
    (roundBinary fp16 .towardZero (1 + 3 / 2048)).map BitVec.toNat = some 0x3c01 ∧
    (roundBinary bf16 .nearestEven (1 + 1 / 256)).map BitVec.toNat = some 0x3f80 ∧
    (roundBinary bf16 .nearestEven (1 + 3 / 256)).map BitVec.toNat = some 0x3f82 ∧
    (roundBinary tf19 .nearestEven (1 + 1 / 2048)).map BitVec.toNat = some 0x1fc00 ∧
    (roundBinary tf19 .towardZero (-(1 + 3 / 2048))).map BitVec.toNat = some 0x5fc01 ∧
    (roundBinary fp64 .nearestEven (1 / 3)).map BitVec.toNat = some 0x3fd5555555555555 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7732df0c849d56c9"></a>

<details>
<summary><code>TensorCore.Regression.binary_rounding_boundaries</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L28)

```lean
/-- The finite-range guard rejects `65520`, which IEEE FP16 would round to infinity, and
accepts the largest finite value; `2^-25` is a tie below the smallest subnormal and rounds
to zero in both modes. -/
theorem binary_rounding_boundaries :
    roundBinary fp16 .nearestEven 65520 = none ∧
    (roundBinary fp16 .nearestEven 65504).map BitVec.toNat = some 0x7bff ∧
    fp16.maxFinite = 65504 ∧
    (roundBinary fp16 .nearestEven (1 / 33554432)).map BitVec.toNat = some 0 ∧
    (roundBinary fp16 .towardZero (1 / 33554432)).map BitVec.toNat = some 0 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-cc89177db091b528"></a>

<details>
<summary><code>TensorCore.Regression.formats_wellFormed</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L36)

```lean
theorem formats_wellFormed : fp16.WellFormed ∧ bf16.WellFormed ∧ tf19.WellFormed ∧ fp64.WellFormed := by
  decide
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-00b226cd62b0c941"></a>

<details>
<summary><code>TensorCore.Regression.fp16_rounding_correct</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L40)

```lean
/-- Nearest-even and toward-zero correctness on the four formats of the source paths. -/
theorem fp16_rounding_correct (x : ℚ) (hr : absQ x ≤ fp16.maxFinite) :
    (∃ b, roundBinary fp16 .nearestEven x = some b ∧ NearestEven fp16 x b) ∧
    (∃ b, roundBinary fp16 .towardZero x = some b ∧ TowardZero fp16 x b) :=
  ⟨roundBinary_nearestEven_correct fp16 (by decide) x hr,
    roundBinary_towardZero_correct fp16 (by decide) x hr⟩
```

**Supporting proofs:** [TensorCore.roundBinary_nearestEven_correct](../../Core/Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardZero_correct](../../Core/Binary/CorrectRounding.md#decl-7cd93a19048f4025)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](../../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardZero](../../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a1e4399a2a4d855e"></a>

<details>
<summary><code>TensorCore.Regression.bf16_rounding_correct</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L46)

```lean
theorem bf16_rounding_correct (x : ℚ) (hr : absQ x ≤ bf16.maxFinite) :
    (∃ b, roundBinary bf16 .nearestEven x = some b ∧ NearestEven bf16 x b) ∧
    (∃ b, roundBinary bf16 .towardZero x = some b ∧ TowardZero bf16 x b) :=
  ⟨roundBinary_nearestEven_correct bf16 (by decide) x hr,
    roundBinary_towardZero_correct bf16 (by decide) x hr⟩
```

**Supporting proofs:** [TensorCore.roundBinary_nearestEven_correct](../../Core/Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardZero_correct](../../Core/Binary/CorrectRounding.md#decl-7cd93a19048f4025)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](../../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardZero](../../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.bf16](../../Core/Defs.md#decl-10da45ae98cf5fcc), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-612a1b643914598f"></a>

<details>
<summary><code>TensorCore.Regression.tf19_rounding_correct</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L52)

```lean
theorem tf19_rounding_correct (x : ℚ) (hr : absQ x ≤ tf19.maxFinite) :
    (∃ b, roundBinary tf19 .nearestEven x = some b ∧ NearestEven tf19 x b) ∧
    (∃ b, roundBinary tf19 .towardZero x = some b ∧ TowardZero tf19 x b) :=
  ⟨roundBinary_nearestEven_correct tf19 (by decide) x hr,
    roundBinary_towardZero_correct tf19 (by decide) x hr⟩
```

**Supporting proofs:** [TensorCore.roundBinary_nearestEven_correct](../../Core/Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardZero_correct](../../Core/Binary/CorrectRounding.md#decl-7cd93a19048f4025)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](../../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardZero](../../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.tf19](../../Core/Defs.md#decl-1b853137564a343d)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-e5bfd4e1909b6694"></a>

<details>
<summary><code>TensorCore.Regression.fp64_rounding_correct</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L58)

```lean
theorem fp64_rounding_correct (x : ℚ) (hr : absQ x ≤ fp64.maxFinite) :
    (∃ b, roundBinary fp64 .nearestEven x = some b ∧ NearestEven fp64 x b) ∧
    (∃ b, roundBinary fp64 .towardZero x = some b ∧ TowardZero fp64 x b) :=
  ⟨roundBinary_nearestEven_correct fp64 (by decide) x hr,
    roundBinary_towardZero_correct fp64 (by decide) x hr⟩
```

**Supporting proofs:** [TensorCore.roundBinary_nearestEven_correct](../../Core/Binary/CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_towardZero_correct](../../Core/Binary/CorrectRounding.md#decl-7cd93a19048f4025)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](../../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.TowardZero](../../Core/Binary/CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp64](../../Core/Defs.md#decl-a9439171a8dcf9cb), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-24384b5d55cf129e"></a>

<details>
<summary><code>TensorCore.Regression.e4m3_outside_generic_rounding</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L67)

```lean
/-- E4M3 is not an IEEE-style `Format`: its decoder accepts `448` (word `7e`) and `256`
(`78`), while the IEEE-style layout `⟨3, 4, 7⟩` has maximum `240` and `roundBinary` on it
rejects `448`. The generic rounding theorems do not cover E4M3. -/
theorem e4m3_outside_generic_rounding :
    (packedE4M3.decode 0x7e).map Decoded.value = some 448 ∧
    (packedE4M3.decode 0x78).map Decoded.value = some 256 ∧
    e4m3.layout.maxFinite = 240 ∧
    roundBinary e4m3.layout .nearestEven 448 = none ∧
    (roundBinary e4m3.layout .nearestEven 240).map BitVec.toNat = some 0x77 := by
  decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format.maxFinite](../../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.OperandEncoding.Word](../../Core/Format.md#decl-3024ce1c6868fc17), [TensorCore.OperandEncoding.decode](../../Core/Format.md#decl-54e57bd4e5755510), [TensorCore.OperandEncoding.width](../../Core/Format.md#decl-0e24771a882ef6eb), [TensorCore.ValueFormat](../../Core/Format.md#decl-5fda6482ff1a70d2), [TensorCore.e4m3](../../Core/Format.md#decl-d51ff46ab3f27e52), [TensorCore.packedE4M3](../../Core/Format.md#decl-d71b628934693ce8), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a1a7d122c1f74869"></a>

<details>
<summary><code>TensorCore.Regression.fp32_generic_agrees</code></summary>

[Lean source](../../../../TensorCore/TC/Regression/BinaryRounding.lean#L76)

```lean
/-- The FP32 instance of the generic theorem is the original FP32 theorem's statement. -/
theorem fp32_generic_agrees (x : ℚ) (hr : absQ x ≤ maxFinite32) :
    ∃ b, round32 .nearestEven x = some b ∧ NearestEven32 x b := by
  have h := roundBinary_nearestEven_correct fp32 (by decide) x hr
  obtain ⟨b, hb, hc⟩ := h
  refine ⟨b, ?_, hc⟩
  rw [← roundBinary_fp32 .nearestEven]
  exact hb
```

**Supporting proofs:** [TensorCore.roundBinary_fp32](../../Core/Binary/RoundOp.md#decl-11e910ef6ebcee78), [TensorCore.roundBinary_nearestEven_correct](../../Core/Binary/CorrectRounding.md#decl-56aa49cf9819c893)

**Definitions and types:** [TensorCore.BinaryRoundingMode](../../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Format](../../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.NearestEven](../../Core/Binary/CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.NearestEven32](../../Core/RoundOp.md#decl-e8aa71a6813779de), [TensorCore.RoundingMode](../../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.RoundingMode.toBinary](../../Core/Binary/RoundOp.md#decl-812d25a411978fe0), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.fp32](../../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.maxFinite32](../../Core/RoundOp.md#decl-49745d9860bef700), [TensorCore.round32](../../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundBinary](../../Core/Binary/RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
