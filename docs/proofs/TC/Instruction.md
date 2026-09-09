# TensorCore.TC.Instruction

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-3eda2673db5b65b7"></a>

<details>
<summary><code>TensorCore.chunks</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L15)

```lean
/-- `m` consecutive groups of `n` elements. -/
def chunks (n : ℕ) : ℕ → List α → List (List α)
  | 0, _ => []
  | m + 1, xs => xs.take n :: chunks n m (xs.drop n)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](../Gemm/Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.PaperSpec.chunks_eq_matrixChunks](../Gemm/Specification/GemmEquivalence.md#decl-d259480c970e3a94), [TensorCore.PaperSpec.gemmInstructions_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](../Gemm/Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeProductCell_eq_independent](../Gemm/Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.PaperSpec.partitionExact_inputs_chunks](../Gemm/Specification/GemmEquivalence.md#decl-2c86a9b78704d3ca), [TensorCore.chunks_first_group](Instruction.md#decl-201a1eebaa3facb8), [TensorCore.chunks_flatten](Instruction.md#decl-0e5864e5ebfec510), [TensorCore.chunks_replicate](Instruction.md#decl-a5c4eefbf4ca4630), [TensorCore.gemmBlocks_count](../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_shape](../Gemm/Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.nativeProductTrace](../Gemm/NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](../Gemm/NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.native_instruction_trace_covers](../Gemm/NativeGemm.md#decl-fd3ddc25e4345bca), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.chunks_shape](../Gemm/Bounds.md#decl-1053388273074842)

</details>

</details>

<a id="decl-0e5864e5ebfec510"></a>

<details>
<summary><code>TensorCore.chunks_flatten</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L19)

```lean
theorem chunks_flatten (n m : ℕ) (xs : List α) (h : xs.length = m * n) :
    (chunks n m xs).flatten = xs := by
  induction m generalizing xs with
  | zero =>
    have hx : xs = [] := List.length_eq_zero_iff.mp (by simpa using h)
    subst hx
    rfl
  | succ m ih =>
    simp only [chunks, List.flatten_cons]
    rw [Nat.succ_mul] at h
    rw [ih (xs.drop n) (by simp only [List.length_drop]; omega)]
    exact List.take_append_drop n xs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.chunks](Instruction.md#decl-3eda2673db5b65b7)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.schedule_flatten](Instruction.md#decl-2652b6482c26797c), [TensorCore.native_instruction_trace_covers](../Gemm/NativeGemm.md#decl-fd3ddc25e4345bca)

</details>

</details>

<a id="decl-201a1eebaa3facb8"></a>

<details>
<summary><code>TensorCore.chunks_first_group</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L32)

```lean
theorem chunks_first_group (n m : ℕ) (g rest : List α) (hg : g.length = n) :
    chunks n (m + 1) (g ++ rest) = g :: chunks n m rest := by
  simp only [chunks]
  rw [← hg, List.take_left, List.drop_left]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.chunks](Instruction.md#decl-3eda2673db5b65b7)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-a5c4eefbf4ca4630"></a>

<details>
<summary><code>TensorCore.chunks_replicate</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L37)

```lean
theorem chunks_replicate (n m : ℕ) (a : α) :
    chunks n m (List.replicate (m * n) a) = List.replicate m (List.replicate n a) := by
  induction m with
  | zero => rfl
  | succ m ih =>
    simp only [chunks, List.take_replicate, List.drop_replicate, List.replicate_succ]
    rw [Nat.succ_mul]
    have h1 : min n (m * n + n) = n := by omega
    have h2 : m * n + n - n = m * n := by omega
    rw [h1, h2, ih]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.chunks](Instruction.md#decl-3eda2673db5b65b7)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-922f2f0fa043267c"></a>

<details>
<summary><code>TensorCore.lastOutput_bits</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L48)

```lean
theorem lastOutput_bits (initial : Finite32) (ts : List BlockTrace) :
    ((ts.getLast?.map fun t => t.output.bits).getD initial.bits) =
      (lastOutput initial ts).bits := by
  induction ts generalizing initial with
  | nil => rfl
  | cons t ts ih =>
    cases ts with
    | nil => rfl
    | cons u us => exact ih t.output
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.lastOutput](Program/Composition.md#decl-59a9e0884980f32b)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.mapped_lastOutput](../Gemm/Specification/GemmEquivalence.md#decl-6966179b65962514), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e)

</details>

</details>

<a id="decl-9b8508cbc5447ef1"></a>

<details>
<summary><code>TensorCore.getD_of_cons</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L58)

```lean
theorem getD_of_cons (f : α → β) (u : α) (us : List α) (d₁ d₂ : β) :
    (((u :: us).getLast?).map f).getD d₁ = (((u :: us).getLast?).map f).getD d₂ := by
  induction us generalizing u with
  | nil => rfl
  | cons v vs ih =>
    simp only [List.getLast?_cons_cons]
    exact ih v
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

[TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-4ce47d530733607b"></a>

<details>
<summary><code>TensorCore.finite32_self</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L66)

```lean
theorem finite32_self (f : Finite32) : finite32 f.bits = some f := by
  unfold finite32
  split
  · rename_i h; rw [f.valid] at h; contradiction
  · rename_i d h; rw [f.valid] at h; cases Option.some.inj h; rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-f684c66c118692c8"></a>

<details>
<summary><code>TensorCore.zero_value_bits</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L73)

```lean
/-- The bits of a finite encoding of value zero, other than `−0`, are `0`. -/
theorem zero_value_bits (c : F32) (d : Decoded) (hd : decode32 c = some d)
    (hz : d.significand = 0) (hneg : c ≠ 0x80000000) : c = 0 := by
  have hlt := c.isLt
  rcases decode32_fields c d hd with ⟨hE, hm, rfl⟩ | ⟨_, hm, rfl⟩ | ⟨_, _, rfl⟩
  · apply BitVec.eq_of_toNat_eq
    have hq : c.toNat / 2147483648 = 0 ∨ c.toNat / 2147483648 = 1 := by omega
    rcases hq with hq | hq
    · show c.toNat = 0
      omega
    · exfalso
      apply hneg
      apply BitVec.eq_of_toNat_eq
      show c.toNat = 2147483648
      omega
  · exfalso
    try dsimp only at hz
    split at hz <;> omega
  · exfalso
    try dsimp only at hz
    split at hz <;> omega
```

**Supporting proofs:** [TensorCore.decode32_fields](../Core/RoundTrip.md#decl-b49162d7ac8baacf)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-411ba01d7f55e7d1"></a>

<details>
<summary><code>TensorCore.Decoded.value_ne_zero</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L94)

```lean
theorem Decoded.value_ne_zero (d : Decoded) (h : d.significand ≠ 0) : d.value ≠ 0 := by
  intro h0
  unfold Decoded.value at h0
  have hq := pow2_pos (d.rawScale - d.fractionalBits)
  have hne := Rat.ne_of_gt hq
  have h1 : (d.significand : ℚ) = ((0 : ℤ) : ℚ) := by
    rw [Rat.intCast_zero]
    calc (d.significand : ℚ) = (d.significand : ℚ) * pow2 (d.rawScale - d.fractionalBits) /
          pow2 (d.rawScale - d.fractionalBits) := (Rat.mul_div_cancel hne).symm
      _ = 0 / pow2 (d.rawScale - d.fractionalBits) := by rw [h0]
      _ = 0 := by rw [Rat.div_def, Rat.zero_mul]
  exact h (Rat.intCast_inj.mp h1)
```

**Supporting proofs:** [TensorCore.pow2_pos](../Core/Exact.md#decl-8f231b6648575120)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-7cd0d6b0b17d9032"></a>

<details>
<summary><code>TensorCore.zero_products_eta</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L109)

```lean
/-- With only zero products, the alignment exponent is the accumulator input's raw scale,
whenever the floor is at most `−126`. -/
theorem zero_products_eta (K extra : ℕ) (floor : Option ℤ) (hfl : ∀ f ∈ floor, f ≤ -126)
    (c : Decoded) (hc : c.significand ≠ 0) (hlow : -126 ≤ c.rawScale) :
    (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).eta = some c.rawScale := by
  have hterms : (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).terms =
      ⟨c.significand, c.rawScale, c.fractionalBits⟩ :: List.replicate K ⟨0, 0, 0⟩ := by
    simp [PreparedBlock.terms, List.map_replicate, rawMul]
  have hmem : (⟨c.significand, c.rawScale, c.fractionalBits⟩ : RawProduct) ∈
      (PreparedBlock.mk (fp16Fp32Profile K extra floor)
        (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).terms := by
    rw [hterms]; simp
  obtain ⟨e, he, hle⟩ := alignmentScale_term _ _ hmem hc
  have hle' : c.rawScale ≤ e := hle
  have hup := alignmentScale_upper (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) c).terms c.rawScale (by
        intro t ht hnz
        rw [hterms] at ht
        simp only [List.mem_cons, List.mem_replicate] at ht
        rcases ht with rfl | ⟨_, rfl⟩
        · exact Int.le_refl _
        · exact absurd rfl hnz) e (by rw [he]; simp)
  have heq : e = c.rawScale := by omega
  subst heq
  unfold PreparedBlock.eta
  rw [he]
  unfold Profile.applyFloor
  have hfloor : (fp16Fp32Profile K extra floor).alignFloor = floor := rfl
  simp only [hfloor]
  cases hf : floor with
  | none => rfl
  | some f =>
    have := hfl f (by rw [hf]; simp)
    simp [Int.max_eq_left (by omega : f ≤ c.rawScale)]
```

**Supporting proofs:** [TensorCore.alignmentScale_term](AlignmentScale.md#decl-b69cdabe679ea4e6), [TensorCore.alignmentScale_upper](AlignmentScale.md#decl-4c48f1374c92ea89)

**Definitions and types:** [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.exactProducts](Block.md#decl-1f40b290e956d863), [TensorCore.PreparedBlock.terms](Block.md#decl-5c50cde42f4cd44c), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.applyFloor](Defs.md#decl-d4a79527e066b037), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.alignmentScale](Block.md#decl-2785502e5e4cba7a), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-882b366cdb8ff9e3"></a>

<details>
<summary><code>TensorCore.zero_products_passthrough</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L146)

```lean
/-- A group whose products are all zero pairs returns its accumulator input unchanged, for
every finite input other than `−0`. Floors at or below `−126` are inactive on FP16 paths. -/
theorem zero_products_passthrough (K extra : ℕ) (floor : Option ℤ)
    (hfl : ∀ f ∈ floor, f ≤ -126) (c : F32) (f : Finite32) (hf : finite32 c = some f)
    (hneg : c ≠ 0x80000000) :
    ∃ t : BlockTrace,
      evalBlock (⟨List.replicate K (0, 0), c⟩ : BlockInput (fp16Fp32Profile K extra floor)) =
        .ok t ∧ t.output.bits = c := by
  have hbits := finite32_bits hf
  have hc : decode32 c = some f.decoded := by rw [← hbits]; exact f.valid
  have hz : (fp16Fp32Profile K extra floor).decode 0 = some ⟨0, 0, 0⟩ := by
    show (classify fp16 0).finite = some _
    decide +kernel
  have hps := prepareProducts_replicate (fp16Fp32Profile K extra floor) 0 0 ⟨0, 0, 0⟩ ⟨0, 0, 0⟩
    K hz hz
  have hlen : ¬ ((List.replicate K ((0 : F16), (0 : F16))).length !=
      (fp16Fp32Profile K extra floor).products) = true := by simp [fp16Fp32Profile]
  have hcoef := construction_coefficients (fp16Fp32Profile K extra floor) K ⟨0, 0, 0⟩ ⟨0, 0, 0⟩
    f.decoded
  have hprod : ∀ q : ℤ, truncCoeff (rawMul ⟨0, 0, 0⟩ ⟨0, 0, 0⟩).value q = 0 := by
    intro q
    simp [rawMul, RawProduct.value, truncCoeff, Rat.div_def]
    all_goals decide +kernel
  have hacc : (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded).accumulator = f.value := by
    by_cases hsig : f.decoded.significand = 0
    · have hv : f.decoded.value = 0 := by simp [Decoded.value, hsig]
      have hcz : ∀ q : ℤ, truncCoeff f.decoded.value q = 0 := by
        intro q; rw [hv]; simp [truncCoeff, Rat.div_def]
        all_goals decide +kernel
      unfold PreparedBlock.accumulator
      rw [hcoef]
      simp only [sumZ, hcz, hprod, sumZ_replicate, Int.mul_zero, Int.add_zero]
      unfold Finite32.value
      rw [hv]
      simp
    · obtain ⟨hfrac, hlow⟩ : f.decoded.fractionalBits = 23 ∧ -126 ≤ f.decoded.rawScale := by
        rcases decode32_fields c f.decoded hc with ⟨_, _, h0⟩ | ⟨_, _, h0⟩ | ⟨hE1, _, h0⟩
        · rw [h0] at hsig; exact absurd rfl hsig
        · rw [h0]; exact ⟨rfl, Int.le_refl _⟩
        · rw [h0]; exact ⟨rfl, by simp; omega⟩
      have heta := zero_products_eta K extra floor hfl f.decoded hsig hlow
      have hq : (PreparedBlock.mk (fp16Fp32Profile K extra floor)
          (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded).quantumExponent =
          f.decoded.rawScale - ((23 + extra : ℕ) : ℤ) := by
        unfold PreparedBlock.quantumExponent
        rw [heta]
        rfl
      rw [hq] at hcoef
      have hcval : f.decoded.value =
          ((f.decoded.significand * ((2 ^ extra : ℕ) : ℤ) : ℤ) : ℚ) *
            pow2 (f.decoded.rawScale - ((23 + extra : ℕ) : ℤ)) := by
        unfold Decoded.value
        rw [hfrac, Rat.intCast_mul, Rat.intCast_natCast, ← pow2_natCast, Rat.mul_assoc, ← pow2_add]
        congr 2
        omega
      have hcc : truncCoeff f.decoded.value (f.decoded.rawScale - ((23 + extra : ℕ) : ℤ)) =
          f.decoded.significand * ((2 ^ extra : ℕ) : ℤ) := by
        rw [hcval, truncCoeff_of_grid]
      unfold PreparedBlock.accumulator
      rw [hcoef, hq]
      simp only [sumZ, hcc, hprod, sumZ_replicate, Int.mul_zero, Int.add_zero]
      rw [← hcval]
      rfl
  have hrun : evalPrepared (PreparedBlock.mk (fp16Fp32Profile K extra floor)
      (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded) =
      .ok ⟨PreparedBlock.mk (fp16Fp32Profile K extra floor)
        (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded, f⟩ := by
    by_cases hsig : f.decoded.significand = 0
    · have hc0 : c = 0 := zero_value_bits c f.decoded hc hsig hneg
      have hv : f.value = 0 := by simp [Finite32.value, Decoded.value, hsig]
      have hr : round32 .towardZero 0 = some (0 : F32) := by decide +kernel
      have hf0 : finite32 (0 : F32) = some f := by rw [← hc0]; exact hf
      simp only [evalPrepared, hacc, hv, hr, hf0]
    · have hv : f.value ≠ 0 := Decoded.value_ne_zero f.decoded hsig
      have hval32 : value32 c = some f.value := by
        unfold value32; rw [hc]; rfl
      have hr := value32_round32 .towardZero c f.value hval32 hv
      simp only [evalPrepared, hacc, hr, hf]
  refine ⟨⟨PreparedBlock.mk (fp16Fp32Profile K extra floor)
    (List.replicate K (⟨0, 0, 0⟩, ⟨0, 0, 0⟩)) f.decoded, f⟩, ?_, hbits⟩
  unfold evalBlock
  rw [if_neg hlen]
  simp only [prepare, hc, hps]
  exact hrun
```

**Supporting proofs:** [TensorCore.Decoded.value_ne_zero](Instruction.md#decl-411ba01d7f55e7d1), [TensorCore.construction_coefficients](Block.md#decl-8e67b4eed923de99), [TensorCore.decode32_fields](../Core/RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.finite32_bits](Program/Defs.md#decl-08ec57f1c290b572), [TensorCore.pow2_add](../Core/Exact.md#decl-7127823e49ce5599), [TensorCore.pow2_natCast](../Core/Exact.md#decl-997b22af00ef82dd), [TensorCore.prepareProducts_replicate](Block.md#decl-3ef93e2d1a862b59), [TensorCore.sumZ_replicate](../Core/Sum.md#decl-515e106ddee189db), [TensorCore.truncCoeff_of_grid](../Core/Truncation.md#decl-03b847921a9aec6d), [TensorCore.value32_round32](../Core/RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_eta](Instruction.md#decl-7cd0d6b0b17d9032), [TensorCore.zero_value_bits](Instruction.md#decl-f684c66c118692c8)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.PreparedBlock](Block.md#decl-703939eff806d883), [TensorCore.PreparedBlock.accumulator](Block.md#decl-a7916980cd8ee13e), [TensorCore.PreparedBlock.coefficients](Block.md#decl-c0369f010f61825c), [TensorCore.PreparedBlock.eta](Block.md#decl-e0fb0ac9eab867d5), [TensorCore.PreparedBlock.quantumExponent](Block.md#decl-43c39ff5fd4eef64), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](Defs.md#decl-178599198b2d538e), [TensorCore.RawProduct](../Core/RawProduct.md#decl-48ce8d4df2fad1f4), [TensorCore.RawProduct.value](../Core/RawProduct.md#decl-549312d8d1563679), [TensorCore.RoundingMode](../Core/RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.decode32](../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.evalPrepared](Block.md#decl-700b85398ddd8f12), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepare](Block.md#decl-32c2d7273540d876), [TensorCore.prepareProducts](Block.md#decl-90abac48864edcd2), [TensorCore.rawMul](../Core/RawProduct.md#decl-ebe5dd867373b275), [TensorCore.round32](../Core/RoundOp.md#decl-11a6489236dbb65b), [TensorCore.sumZ](../Core/Exact.md#decl-eba77bb372c3b3ff), [TensorCore.truncCoeff](../Core/Exact.md#decl-282a0db962f1b274), [TensorCore.value32](../Core/Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139)

</details>

</details>

<a id="decl-90841dab8cd37139"></a>

<details>
<summary><code>TensorCore.runBlocks_zero_groups</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L231)

```lean
/-- Zero groups pass a finite accumulator, other than `−0`, through unchanged. -/
theorem runBlocks_zero_groups (K extra : ℕ) (floor : Option ℤ)
    (hfl : ∀ f ∈ floor, f ≤ -126) (m : ℕ) (c : F32) (f : Finite32) (hf : finite32 c = some f)
    (hneg : c ≠ 0x80000000) :
    ∃ ts : List BlockTrace,
      runBlocks (fp16Fp32Profile K extra floor) c
        (List.replicate m (List.replicate K (0, 0))) = .ok ts ∧
      ((ts.getLast?.map fun t => t.output.bits).getD c) = c := by
  induction m generalizing c f with
  | zero => exact ⟨[], rfl, rfl⟩
  | succ m ih =>
    obtain ⟨t, ht, hbits⟩ := zero_products_passthrough K extra floor hfl c f hf hneg
    have hf' : finite32 t.output.bits = some t.output := finite32_self t.output
    obtain ⟨ts, hts, hlast⟩ := ih t.output.bits t.output hf' (by rw [hbits]; exact hneg)
    refine ⟨t :: ts, ?_, ?_⟩
    · simp only [List.replicate_succ, runBlocks, ht, hts]
    · cases ts with
      | nil => simpa using hbits
      | cons u us =>
        simp only [List.getLast?_cons_cons] at hlast ⊢
        rw [hbits] at hlast
        exact hlast
```

**Supporting proofs:** [TensorCore.finite32_self](Instruction.md#decl-4ce47d530733607b), [TensorCore.zero_products_passthrough](Instruction.md#decl-882b366cdb8ff9e3)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.finite32](../Core/Encoding.md#decl-82d0e30146423be5), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.runBlocks](Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-6cf18dea2a1c7db8"></a>

<details>
<summary><code>TensorCore.InstructionPath</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L255)

```lean
/-- A pinned instruction path: inner dimension `k`, products per group, extra alignment bits,
floor, and the source of these parameters. The grouping is contiguous in increasing k. -/
structure InstructionPath where
  name : String
  k : ℕ
  products : ℕ
  extraBits : ℕ
  floor : Option ℤ
  evidence : String
  productsPos : 0 < products
  kDiv : products ∣ k
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Conforms](Instruction.md#decl-f0ccefd86423633e), [TensorCore.InstructionPath.describe](Instruction.md#decl-10e5a541d745814c), [TensorCore.InstructionPath.groups](Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.output](Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.run_blocks](Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](Instruction.md#decl-812320a0c4dc3b22), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.InstructionPath.schedule_flatten](Instruction.md#decl-2652b6482c26797c), [TensorCore.PaperSpec.instructionGroups_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.WmmaGemmModel.k](../Gemm/Defs.md#decl-d7ce31e450277fbc), [TensorCore.WmmaGemmModel.path](../Gemm/Defs.md#decl-860954743cbdf9bb), [TensorCore.ampereWmma16](Instruction.md#decl-b62114cc7439c99c), [TensorCore.checkGemmCell_sound](../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.familyError_nonneg](../Gemm/Family.md#decl-810b5bd68276af9d), [TensorCore.gemmBlocks_count](../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](../Gemm/Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](../Gemm/Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck_product_bound](../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmProductMagnitude](../Gemm/ScaledGemmBounds.md#decl-6b8a518e5f4fda2f), [TensorCore.gemmStaticError](../Gemm/Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.hopperWmma16](Instruction.md#decl-7464b2b22b93945c), [TensorCore.runGemmInstructions](../Gemm/Defs.md#decl-fa58899497fedd29), [TensorCore.runGemmInstructions_blocks](../Gemm/Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_complete](../Gemm/Bounds.md#decl-5e1cd17f4e8c0bf4), [TensorCore.runGemmInstructions_count](../Gemm/Defs.md#decl-f9db8f5ae7e28a9c), [TensorCore.runGemmInstructions_coverage](../Gemm/Defs.md#decl-ebd5f42a485ed596), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.v100Wmma16](Instruction.md#decl-4d5414e366b3073f)

</details>

</details>

<a id="decl-edd55ab325073d15"></a>

<details>
<summary><code>TensorCore.InstructionPath.profile</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L265)

```lean
abbrev InstructionPath.profile (p : InstructionPath) : Profile :=
  fp16Fp32Profile p.products p.extraBits p.floor
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212)

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.run_blocks](Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](Instruction.md#decl-812320a0c4dc3b22), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.InstructionPath.schedule_flatten](Instruction.md#decl-2652b6482c26797c), [TensorCore.PaperSpec.instructionGroups_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.PaperSpec.wmma_parameters](../Gemm/Specification/GemmEquivalence.md#decl-193ac1310155f18d), [TensorCore.analyzeGemmCell](../Gemm/Analysis.md#decl-6eee488b36c50d94), [TensorCore.analyzeGemmCell_checked](../Gemm/Analysis.md#decl-8f79134186f502df), [TensorCore.analyzeGemmCell_complete](../Gemm/Analysis.md#decl-e410d155f5952501), [TensorCore.checkGemmCell](../Gemm/Analysis.md#decl-b2d9a6ca1b8ee691), [TensorCore.checkGemmCell_sound](../Gemm/Analysis.md#decl-623f3bbd7dca9d5a), [TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.familyConditions](../Gemm/Family.md#decl-b456e480e468a315), [TensorCore.familyConditions_gemmCheck](../Gemm/Family.md#decl-56c849a6d64aa7bf), [TensorCore.familyError_nonneg](../Gemm/Family.md#decl-810b5bd68276af9d), [TensorCore.family_pair_scale](../Gemm/Family.md#decl-797e6af7a549f294), [TensorCore.gemmBlocks](../Gemm/Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmBlocks_count](../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](../Gemm/Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](../Gemm/Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.gemmCellCheck](../Gemm/Bounds.md#decl-a52f6a5d0ea4462e), [TensorCore.gemmCellCheck_product_bound](../Gemm/ScaledGemmBounds.md#decl-53971d1e0a79bd4b), [TensorCore.gemmCellCheck_sound](../Gemm/Bounds.md#decl-0e3a8c7f2edd1ebd), [TensorCore.gemmStaticError](../Gemm/Bounds.md#decl-f2b1a703f1fc6bcf), [TensorCore.runGemmInstructions_blocks](../Gemm/Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_complete](../Gemm/Bounds.md#decl-5e1cd17f4e8c0bf4), [TensorCore.runGemmInstructions_coverage](../Gemm/Defs.md#decl-ebd5f42a485ed596), [TensorCore.simulateGemmCell_error](../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095), [TensorCore.gemm_ideal_profile](../Gemm/Defs.md#decl-d3150262da998973)

</details>

</details>

<a id="decl-ba04a91cb7e3476c"></a>

<details>
<summary><code>TensorCore.InstructionPath.groups</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L268)

```lean
def InstructionPath.groups (p : InstructionPath) : ℕ := p.k / p.products
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8)

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.describe](Instruction.md#decl-10e5a541d745814c), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.InstructionPath.schedule_flatten](Instruction.md#decl-2652b6482c26797c), [TensorCore.PaperSpec.instructionGroups_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.Regression.ampere_instruction_two_groups](Regression/Instruction.md#decl-1435a1f58deeec4d), [TensorCore.Regression.hopper_instruction_one_group](Regression/Instruction.md#decl-9eabdf6fc3230629), [TensorCore.gemmBlockCount](../Gemm/Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks_count](../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_shape](../Gemm/Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-0ac6b4cf1e325257"></a>

<details>
<summary><code>TensorCore.InstructionPath.schedule</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L271)

```lean
/-- The schedule of one instruction: `k / N_FMA` contiguous groups in increasing k. -/
def InstructionPath.schedule (p : InstructionPath) (pairs : List (F16 × F16)) :
    List (List (p.profile.Word × p.profile.Word)) :=
  chunks p.products p.groups pairs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.groups](Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.chunks](Instruction.md#decl-3eda2673db5b65b7)

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.run_blocks](Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](Instruction.md#decl-812320a0c4dc3b22), [TensorCore.InstructionPath.schedule_flatten](Instruction.md#decl-2652b6482c26797c), [TensorCore.PaperSpec.instructionGroups_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-1dc4cea76ce0c1e5), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.gemmBlocks](../Gemm/Bounds.md#decl-46e34ca627b0c0a9), [TensorCore.gemmBlocks_count](../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](../Gemm/Family.md#decl-4a51beeb4d271239), [TensorCore.gemmBlocks_shape](../Gemm/Bounds.md#decl-4e35c27fc2ec0cb1), [TensorCore.runGemmInstructions_blocks](../Gemm/Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_complete](../Gemm/Bounds.md#decl-5e1cd17f4e8c0bf4), [TensorCore.runGemmInstructions_coverage](../Gemm/Defs.md#decl-ebd5f42a485ed596), [TensorCore.simulateGemmCell_error](../Gemm/Defs.md#decl-0dd9b9d7ce010319), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-70072ebede7f95c1"></a>

<details>
<summary><code>TensorCore.InstructionPath.run</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L277)

```lean
/-- Execute the instruction. Inputs that are not exactly `k` pairs are rejected; nothing is
padded or discarded. -/
def InstructionPath.run (p : InstructionPath) (c : F32) (pairs : List (F16 × F16)) :
    Except ModelError (List BlockTrace) :=
  if pairs.length != p.k then .error .wrongProductCount
  else runBlocks p.profile c (p.schedule pairs)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.runBlocks](Program/Composition.md#decl-d4b070b6697e01f0)

<details>
<summary>Used by</summary>

[TensorCore.InstructionPath.output](Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.InstructionPath.run_blocks](Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](Instruction.md#decl-812320a0c4dc3b22), [TensorCore.PaperSpec.runGemmInstructions_eq_paper](../Gemm/Specification/GemmEquivalence.md#decl-f35ca03e91855ea8), [TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.runGemmInstructions](../Gemm/Defs.md#decl-fa58899497fedd29), [TensorCore.runGemmInstructions_blocks](../Gemm/Defs.md#decl-eb60bf287a9ae3b9), [TensorCore.runGemmInstructions_complete](../Gemm/Bounds.md#decl-5e1cd17f4e8c0bf4), [TensorCore.runGemmInstructions_count](../Gemm/Defs.md#decl-f9db8f5ae7e28a9c), [TensorCore.runGemmInstructions_coverage](../Gemm/Defs.md#decl-ebd5f42a485ed596), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-9187c2a117e2bdd6"></a>

<details>
<summary><code>TensorCore.InstructionPath.output</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L284)

```lean
/-- The instruction's FP32 result: the last group's output, or the accumulator input when
there are no groups. `none` when a group is rejected by the finite model. -/
def InstructionPath.output (p : InstructionPath) (c : F32) (pairs : List (F16 × F16)) :
    Option F32 :=
  match p.run c pairs with
  | .ok ts => some ((ts.getLast?.map fun t => t.output.bits).getD c)
  | .error _ => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d)

<details>
<summary>Used by</summary>

[TensorCore.Conforms](Instruction.md#decl-f0ccefd86423633e), [TensorCore.Regression.ampere_instruction_order_matters](Regression/Instruction.md#decl-da07bffcaef55092), [TensorCore.Regression.ampere_instruction_two_groups](Regression/Instruction.md#decl-1435a1f58deeec4d), [TensorCore.Regression.hopper_instruction_one_group](Regression/Instruction.md#decl-9eabdf6fc3230629), [TensorCore.Regression.instruction_wrong_width](Regression/Instruction.md#decl-3792d821cd97ac97), [TensorCore.Regression.v100_instruction_single_group](Regression/Instruction.md#decl-47a66c36f1e33146), [TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.single_group_output](Instruction.md#decl-7737e9081be84095)

</details>

</details>

<a id="decl-10e5a541d745814c"></a>

<details>
<summary><code>TensorCore.InstructionPath.describe</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L290)

```lean
def InstructionPath.describe (p : InstructionPath) : String :=
  s!"{p.name}: k = {p.k}, N_FMA = {p.products}, extra alignment bits = {p.extraBits}, " ++
  s!"floor = {repr p.floor}, groups per instruction = {p.groups}; evidence: {p.evidence}"
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.groups](Instruction.md#decl-ba04a91cb7e3476c)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-2652b6482c26797c"></a>

<details>
<summary><code>TensorCore.InstructionPath.schedule_flatten</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L294)

```lean
theorem InstructionPath.schedule_flatten (p : InstructionPath) (pairs : List (F16 × F16))
    (h : pairs.length = p.k) : (p.schedule pairs).flatten = pairs := by
  apply chunks_flatten
  rw [h]
  exact (Nat.div_mul_cancel p.kDiv).symm
```

**Supporting proofs:** [TensorCore.chunks_flatten](Instruction.md#decl-0e5864e5ebfec510)

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.groups](Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.gemmBlocks_ideal](../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](../Gemm/Family.md#decl-4a51beeb4d271239), [TensorCore.runGemmInstructions_coverage](../Gemm/Defs.md#decl-ebd5f42a485ed596)

</details>

</details>

<a id="decl-f0ccefd86423633e"></a>

<details>
<summary><code>TensorCore.Conforms</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L305)

```lean
/-- Conformance of a device function to the modeled path on the model's accepted domain:
whenever the model produces an output, the device produces the same bits. Inputs the finite
model rejects (wrong width, nonfinite operands, out-of-range accumulators) are outside the
modeled domain and leave the device unconstrained. This is the hardware premise; no theorem
below asserts it for any device. -/
def Conforms (p : InstructionPath) (device : F32 → List (F16 × F16) → Option F32) : Prop :=
  ∀ c pairs out, p.output c pairs = some out → device c pairs = some out
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.output](Instruction.md#decl-9187c2a117e2bdd6)

<details>
<summary>Used by</summary>

[TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e)

</details>

</details>

<a id="decl-812320a0c4dc3b22"></a>

<details>
<summary><code>TensorCore.InstructionPath.run_length</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L308)

```lean
theorem InstructionPath.run_length (p : InstructionPath) (c : F32) (pairs : List (F16 × F16))
    (ts : List BlockTrace) (h : p.run c pairs = .ok ts) : pairs.length = p.k := by
  unfold InstructionPath.run at h
  split at h
  · contradiction
  · rename_i hne
    simpa using hne
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.runBlocks](Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.runGemmInstructions_coverage](../Gemm/Defs.md#decl-ebd5f42a485ed596)

</details>

</details>

<a id="decl-7596119277e0d9b0"></a>

<details>
<summary><code>TensorCore.InstructionPath.run_blocks</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L316)

```lean
theorem InstructionPath.run_blocks (p : InstructionPath) (c : F32) (pairs : List (F16 × F16))
    (ts : List BlockTrace) (h : p.run c pairs = .ok ts) :
    runBlocks p.profile c (p.schedule pairs) = .ok ts := by
  unfold InstructionPath.run at h
  split at h
  · contradiction
  · exact h
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.runBlocks](Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.conforms_uncorrected_error](Instruction.md#decl-89203da1fcc0b32e), [TensorCore.runGemmInstructions_blocks](../Gemm/Defs.md#decl-eb60bf287a9ae3b9)

</details>

</details>

<a id="decl-89203da1fcc0b32e"></a>

<details>
<summary><code>TensorCore.conforms_uncorrected_error</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L326)

```lean
/-- Under conformance, a device result is the model's last group output and satisfies the
composed uncorrected error bound against the original-input ideal. -/
theorem conforms_uncorrected_error (p : InstructionPath)
    (device : F32 → List (F16 × F16) → Option F32) (h : Conforms p device) (initial : Finite32)
    (pairs : List (F16 × F16)) (ts : List BlockTrace)
    (hrun : p.run initial.bits pairs = .ok ts) (products : ℚ)
    (hi : idealProducts p.profile pairs = some products) :
    device initial.bits pairs = some (lastOutput initial ts).bits ∧
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) := by
  have hlen := p.run_length _ _ _ hrun
  have hblocks := p.run_blocks _ _ _ hrun
  constructor
  · apply h
    unfold InstructionPath.output
    rw [hrun]
    show some ((ts.getLast?.map fun t => t.output.bits).getD initial.bits) = _
    rw [lastOutput_bits]
  · have hi' : idealContributions p.profile (p.schedule pairs) = some products := by
      rw [idealContributions_flatten, p.schedule_flatten pairs hlen, hi]
    exact (runBlocks_uncorrected_error p.profile initial (p.schedule pairs) ts products hblocks
      hi').1
```

**Supporting proofs:** [TensorCore.InstructionPath.run_blocks](Instruction.md#decl-7596119277e0d9b0), [TensorCore.InstructionPath.run_length](Instruction.md#decl-812320a0c4dc3b22), [TensorCore.InstructionPath.schedule_flatten](Instruction.md#decl-2652b6482c26797c), [TensorCore.idealContributions_flatten](Program/DotProduct.md#decl-9ddff146f804b161), [TensorCore.lastOutput_bits](Instruction.md#decl-922f2f0fa043267c), [TensorCore.runBlocks_uncorrected_error](Program/ErrorBounds.md#decl-dc5609ec5819f2da)

**Definitions and types:** [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](Program/ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.Conforms](Instruction.md#decl-f0ccefd86423633e), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.output](Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.idealContributions](Program/Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Program/Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](Program/Composition.md#decl-59a9e0884980f32b), [TensorCore.runBlocks](Program/Composition.md#decl-d4b070b6697e01f0), [TensorCore.sumQ](../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-7737e9081be84095"></a>

<details>
<summary><code>TensorCore.single_group_output</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L350)

```lean
/-- A `k`-wide input whose products beyond the first group are zero pairs returns the first
group's output: every later group passes the accumulator through. Published single-group
vectors therefore test the instruction path under the increasing-k rule. -/
theorem single_group_output (p : InstructionPath) (hfl : ∀ f ∈ p.floor, f ≤ -126)
    (hk : p.products ≤ p.k) (c : F32) (g : List (F16 × F16)) (hg : g.length = p.products)
    (t : BlockTrace) (h1 : evalBlock (⟨g, c⟩ : BlockInput p.profile) = .ok t)
    (hneg : t.output.bits ≠ 0x80000000) :
    p.output c (g ++ List.replicate (p.k - p.products) (0, 0)) = some t.output.bits := by
  have hgroups : p.groups = (p.groups - 1) + 1 := by
    have : 1 ≤ p.groups := by
      unfold InstructionPath.groups
      exact (Nat.le_div_iff_mul_le p.productsPos).mpr (by omega)
    omega
  have hrest : p.k - p.products = (p.groups - 1) * p.products := by
    have hkm := Nat.div_mul_cancel p.kDiv
    unfold InstructionPath.groups at hgroups ⊢
    have : p.k = (p.k / p.products - 1 + 1) * p.products := by rw [← hgroups]; exact hkm.symm
    rw [Nat.succ_mul] at this
    omega
  have hsched : p.schedule (g ++ List.replicate (p.k - p.products) (0, 0)) =
      g :: List.replicate (p.groups - 1) (List.replicate p.products (0, 0)) := by
    unfold InstructionPath.schedule
    rw [hgroups, chunks_first_group _ _ _ _ hg, hrest, chunks_replicate]
    simp only [Nat.add_sub_cancel]
  obtain ⟨ts, hts, hlast⟩ := runBlocks_zero_groups p.products p.extraBits p.floor hfl
    (p.groups - 1) t.output.bits t.output (finite32_self t.output) hneg
  have hlenpad : (g ++ List.replicate (p.k - p.products) (0, 0)).length = p.k := by
    simp only [List.length_append, List.length_replicate, hg]
    omega
  unfold InstructionPath.output InstructionPath.run
  rw [if_neg (by rw [hlenpad]; simp), hsched]
  simp only [runBlocks, h1, hts]
  cases ts with
  | nil => rfl
  | cons u us =>
    simp only [List.getLast?_cons_cons]
    rw [getD_of_cons _ u us c t.output.bits, hlast]
```

**Supporting proofs:** [TensorCore.chunks_first_group](Instruction.md#decl-201a1eebaa3facb8), [TensorCore.chunks_replicate](Instruction.md#decl-a5c4eefbf4ca4630), [TensorCore.finite32_self](Instruction.md#decl-4ce47d530733607b), [TensorCore.getD_of_cons](Instruction.md#decl-9b8508cbc5447ef1), [TensorCore.runBlocks_zero_groups](Instruction.md#decl-90841dab8cd37139)

**Definitions and types:** [TensorCore.BlockInput](Block.md#decl-ad6b462d69117cc6), [TensorCore.BlockTrace](Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8), [TensorCore.InstructionPath.groups](Instruction.md#decl-ba04a91cb7e3476c), [TensorCore.InstructionPath.output](Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.InstructionPath.profile](Instruction.md#decl-edd55ab325073d15), [TensorCore.InstructionPath.run](Instruction.md#decl-70072ebede7f95c1), [TensorCore.InstructionPath.schedule](Instruction.md#decl-0ac6b4cf1e325257), [TensorCore.ModelError](Block.md#decl-f7be0c438a4d4d1d), [TensorCore.Profile](Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](Defs.md#decl-3bca3de3cb04fb71), [TensorCore.chunks](Instruction.md#decl-3eda2673db5b65b7), [TensorCore.evalBlock](Block.md#decl-58fdfbbb09a9ba58), [TensorCore.fp16Fp32Profile](CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.runBlocks](Program/Composition.md#decl-d4b070b6697e01f0)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4d5414e366b3073f"></a>

<details>
<summary><code>TensorCore.v100Wmma16</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L386)

```lean
/-- V100: WMMA m16n16k16 FP16 → FP32 lowers to HMMA.844; four groups of four products. -/
def v100Wmma16 : InstructionPath :=
  ⟨"V100 WMMA m16n16k16 FP16->FP32 (HMMA.844)", 16, 4, 0, none,
    "Accurate Models v4 §4.1.1 and Tables 3-4; MATLAB v0.5 GEMM.m increasing-k rule; " ++
    "Jia et al. arXiv:1804.06826 (four sets of four HMMA.884 steps)", by decide, by decide⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8)

<details>
<summary>Used by</summary>

[TensorCore.Regression.instruction_wrong_width](Regression/Instruction.md#decl-3792d821cd97ac97), [TensorCore.Regression.v100_instruction_single_group](Regression/Instruction.md#decl-47a66c36f1e33146), [TensorCore.WmmaGemmModel.path](../Gemm/Defs.md#decl-860954743cbdf9bb)

</details>

</details>

<a id="decl-b62114cc7439c99c"></a>

<details>
<summary><code>TensorCore.ampereWmma16</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L393)

```lean
/-- A100/A2/A30/L40S/Ada: WMMA m16n16k16 FP16 → FP32 lowers to HMMA.1688; two groups of
eight, validated by the paper on k = 16 inputs. -/
def ampereWmma16 : InstructionPath :=
  ⟨"Ampere/Ada WMMA m16n16k16 FP16->FP32 (HMMA.1688)", 16, 8, 1, some (-132),
    "Accurate Models v4 §4.1.2, §4.2 (k = 16 with N_FMA = 8, 10^7-vector validation), Tables 3-4",
    by decide, by decide⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8)

<details>
<summary>Used by</summary>

[TensorCore.Regression.ampere_instruction_order_matters](Regression/Instruction.md#decl-da07bffcaef55092), [TensorCore.Regression.ampere_instruction_two_groups](Regression/Instruction.md#decl-1435a1f58deeec4d), [TensorCore.WmmaGemmModel.path](../Gemm/Defs.md#decl-860954743cbdf9bb)

</details>

</details>

<a id="decl-7464b2b22b93945c"></a>

<details>
<summary><code>TensorCore.hopperWmma16</code></summary>

[Lean source](../../../TensorCore/TC/Instruction.lean#L399)

```lean
/-- H100/H200/B200: WMMA m16n16k16 FP16 → FP32 lowers to HMMA.16816; one group of sixteen. -/
def hopperWmma16 : InstructionPath :=
  ⟨"Hopper/Blackwell WMMA m16n16k16 FP16->FP32 (HMMA.16816)", 16, 16, 2, some (-133),
    "Accurate Models v4 §4.1.6 and Tables 3-4", by decide, by decide⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.InstructionPath](Instruction.md#decl-6cf18dea2a1c7db8)

<details>
<summary>Used by</summary>

[TensorCore.Regression.hopper_instruction_one_group](Regression/Instruction.md#decl-9eabdf6fc3230629), [TensorCore.WmmaGemmModel.path](../Gemm/Defs.md#decl-860954743cbdf9bb)

</details>

</details>
