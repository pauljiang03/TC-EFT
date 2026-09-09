# TensorCore.TC.Program.Partition

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-4082e3bf596a58d7"></a>

<details>
<summary><code>TensorCore.partitionExact</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L8)

```lean
/-- Construct an ordered partition when the original length is exactly n groups. -/
def partitionExact (p : Profile) (n : ℕ) (xs : List (p.Word × p.Word))
    (hlen : xs.length = n * p.products) : OrderedPartition p xs :=
  match n with
  | 0 => ⟨[], by
      have hx : xs = [] := List.length_eq_zero_iff.mp (by simpa using hlen)
      simp [hx]⟩
  | n + 1 =>
    let first : BlockOperands p := ⟨xs.take p.products, by
      have hle : p.products ≤ xs.length := by rw [Nat.add_mul] at hlen; omega
      simp [List.length_take, Nat.min_eq_left hle]⟩
    let rest := partitionExact p n (xs.drop p.products) (by
      simp only [List.length_drop]
      rw [Nat.add_mul] at hlen
      omega)
    ⟨first :: rest.groups, by
      simp only [List.map_cons, List.flatten_cons]
      rw [rest.covers]
      exact List.take_append_drop p.products xs⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](../../Gemm/Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.partitionExact_inputs_chunks](../../Gemm/Specification/GemmEquivalence.md#decl-2c86a9b78704d3ca), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.familyCheck_sound](../../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.nativeGemmCell_blocks_length](../../Gemm/NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativePartition](../../Gemm/NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.partitionExact_count](Partition.md#decl-f23e6df7073e6ba8)

</details>

</details>

<a id="decl-f23e6df7073e6ba8"></a>

<details>
<summary><code>TensorCore.partitionExact_count</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L27)

```lean
theorem partitionExact_count (p : Profile) (n : ℕ) (xs : List (p.Word × p.Word))
    (hlen : xs.length = n * p.products) : (partitionExact p n xs hlen).groups.length = n := by
  induction n generalizing xs with
  | zero => rfl
  | succ n ih => simp only [partitionExact, List.length_cons, ih]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.partitionExact](Partition.md#decl-4082e3bf596a58d7)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.nativeGemmCell_blocks_length](../../Gemm/NativeGemm.md#decl-3e7365cc3e663fc5)

</details>

</details>

<a id="decl-139b8e76e9854993"></a>

<details>
<summary><code>TensorCore.tailPadding</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L34)

```lean
/-- Zero pairs added to the final group. Exact multiples and empty inputs add none. -/
def tailPadding (K n : ℕ) : ℕ := if n % K = 0 then 0 else K - n % K
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.Regression.constructed_partition_boundaries](../Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.boundedDot_scales](../Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.gemmBlocks_pair_origin](../../Gemm/Family.md#decl-4a51beeb4d271239), [TensorCore.idealProducts_padFp16Pairs](Partition.md#decl-78a2a3efb15b0ed0), [TensorCore.nativeBlocks_ideal](../../Gemm/NativeGemm.md#decl-0c5bde18a7b3d55b), [TensorCore.nativePadded](../../Gemm/NativeGemm.md#decl-68c397c28ec873bf), [TensorCore.nativePartition](../../Gemm/NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.padded_length](Partition.md#decl-61da2d73822bd178), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.tailPadding_lt](Partition.md#decl-32a9924d3466057d), [TensorCore.gemm_tileIndex_lt](../../Gemm/Defs.md#decl-e8122c22357e0edd)

</details>

</details>

<a id="decl-b7760ff5c737d355"></a>

<details>
<summary><code>TensorCore.groupCount</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L36)

```lean
def groupCount (K n : ℕ) : ℕ := n / K + if n % K = 0 then 0 else 1
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.ExtendedAnalysis.nativeExecution](../../Gemm/Cli/ExtendedAnalysis.md#decl-4c0e68b9ad67fac0), [TensorCore.Cli.NativePipeline.execution](../../Gemm/Cli/NativePipeline.md#decl-414b6224be4a4b0a), [TensorCore.PaperSpec.gemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.PaperSpec.nativeGemmCell_eq_paper](../../Gemm/Specification/NativeGemmEquivalence.md#decl-ad9e45da7765a5c5), [TensorCore.PaperSpec.nativeProductCell_eq_independent](../../Gemm/Specification/NativeScaledGemmEquivalence.md#decl-dc12a18524533ebe), [TensorCore.Regression.constructed_partition_boundaries](../Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_group_limit](../Examples/BoundedDot.md#decl-1753bf8bca4d3679), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.familyCheck_sound](../../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemm](../../Gemm/Defs.md#decl-9b05da03dbb16cdd), [TensorCore.gemmBlockCount](../../Gemm/Bounds.md#decl-1d5bfb769b6d463d), [TensorCore.gemmBlocks_count](../../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmTileSchedule](../../Gemm/Defs.md#decl-0f85cf51aeea8448), [TensorCore.gemmTiles](../../Gemm/Defs.md#decl-374eb9f948a3f6da), [TensorCore.gemm_entry](../../Gemm/Defs.md#decl-e24588ca0d6e9549), [TensorCore.gemm_entry_count](../../Gemm/Defs.md#decl-7f36b4999e122577), [TensorCore.nativeGemmCell_blocks_length](../../Gemm/NativeGemm.md#decl-3e7365cc3e663fc5), [TensorCore.nativePartition](../../Gemm/NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.nativeProductTrace](../../Gemm/NativeScaledGemm.md#decl-33acf60ccf6fd24f), [TensorCore.nativeProductTrace_output](../../Gemm/NativeScaledGemm.md#decl-bbcadd81514a3d7e), [TensorCore.native_instruction_trace_covers](../../Gemm/NativeGemm.md#decl-fd3ddc25e4345bca), [TensorCore.padded_length](Partition.md#decl-61da2d73822bd178), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_count](../../Gemm/Defs.md#decl-fa30d201f6e3a65f), [TensorCore.gemm_tileIndex_lt](../../Gemm/Defs.md#decl-e8122c22357e0edd)

</details>

</details>

<a id="decl-61da2d73822bd178"></a>

<details>
<summary><code>TensorCore.padded_length</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L38)

```lean
theorem padded_length (K n : ℕ) (hK : 0 < K) :
    n + tailPadding K n = groupCount K n * K := by
  have hdiv := Nat.div_add_mod n K
  have hmod := Nat.mod_lt n hK
  unfold tailPadding groupCount
  split <;> simp only [Nat.add_mul, Nat.one_mul, Nat.add_zero]
  all_goals rw [Nat.mul_comm (n / K) K]; omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.groupCount](Partition.md#decl-b7760ff5c737d355), [TensorCore.tailPadding](Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.nativePartition](../../Gemm/NativeGemm.md#decl-f6682c5a0b1f9312), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.gemm_tileIndex_lt](../../Gemm/Defs.md#decl-e8122c22357e0edd)

</details>

</details>

<a id="decl-32a9924d3466057d"></a>

<details>
<summary><code>TensorCore.tailPadding_lt</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L46)

```lean
theorem tailPadding_lt (K n : ℕ) (hK : 0 < K) : tailPadding K n < K := by
  have hmod := Nat.mod_lt n hK
  unfold tailPadding
  split <;> omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.tailPadding](Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-69dc55e3030be48b"></a>

<details>
<summary><code>TensorCore.padFp16Pairs</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L51)

```lean
def padFp16Pairs (K : ℕ) (xs : List (F16 × F16)) : List (F16 × F16) :=
  xs ++ List.replicate (tailPadding K xs.length) (0, 0)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.tailPadding](Partition.md#decl-139b8e76e9854993)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.Regression.constructed_partition_boundaries](../Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.Regression.constructed_partition_tail](../Regression/DotProduct.md#decl-571ad9339f4b196c), [TensorCore.boundedDot](../Examples/BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.boundedDot_inputs](../Examples/BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.boundedDot_scales](../Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.familyCheck_sound](../../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmBlocks_count](../../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmBlocks_ideal](../../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.gemmBlocks_pair_origin](../../Gemm/Family.md#decl-4a51beeb4d271239), [TensorCore.gemmInstructions](../../Gemm/Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmInstructions_flatten](../../Gemm/Defs.md#decl-353da63dd578fcb7), [TensorCore.gemmInstructions_shape](../../Gemm/Defs.md#decl-863019b6c0164a66), [TensorCore.idealProducts_padFp16Pairs](Partition.md#decl-78a2a3efb15b0ed0), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890), [TensorCore.runCanonicalDotMachine](Partition.md#decl-17379ac1513b54b1), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_finite](Partition.md#decl-70d7bcd0619569bf), [TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_count](../../Gemm/Defs.md#decl-fa30d201f6e3a65f), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-7e49132d90b040d5"></a>

<details>
<summary><code>TensorCore.canonicalPartition</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L56)

```lean
/-- Group an arbitrary FP16 pair list in order, adding fewer than K zero pairs
only at the end. These zero operands are distinct from fractional alignment bits. -/
def canonicalPartition (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) : OrderedPartition (fp16Fp32Profile K extra floor) (padFp16Pairs K xs) :=
  partitionExact (fp16Fp32Profile K extra floor) (groupCount K xs.length) (padFp16Pairs K xs)
    (by simpa [padFp16Pairs, fp16Fp32Profile] using padded_length K xs.length hK)
```

**Supporting proofs:** [TensorCore.padded_length](Partition.md#decl-61da2d73822bd178)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.fp16](../../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.groupCount](Partition.md#decl-b7760ff5c737d355), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.partitionExact](Partition.md#decl-4082e3bf596a58d7), [TensorCore.tailPadding](Partition.md#decl-139b8e76e9854993)

<details>
<summary>Used by</summary>

[TensorCore.PaperSpec.gemmInstructions_eq_paper](../../Gemm/Specification/GemmEquivalence.md#decl-41f04782d116be19), [TensorCore.Regression.constructed_partition_boundaries](../Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.Regression.constructed_partition_tail](../Regression/DotProduct.md#decl-571ad9339f4b196c), [TensorCore.boundedDot](../Examples/BoundedDot.md#decl-78fed1d70f5dfbd1), [TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.boundedDot_inputs](../Examples/BoundedDot.md#decl-2b3fe7bf5d27756f), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.boundedDot_scales](../Examples/BoundedDot.md#decl-d931c783bf455abe), [TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.familyCheck_sound](../../Gemm/Family.md#decl-f329ec5471dc4d5e), [TensorCore.gemmBlocks_count](../../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.gemmInstructions](../../Gemm/Defs.md#decl-20dedfe15b3a55c3), [TensorCore.gemmInstructions_flatten](../../Gemm/Defs.md#decl-353da63dd578fcb7), [TensorCore.gemmInstructions_shape](../../Gemm/Defs.md#decl-863019b6c0164a66), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890), [TensorCore.runCanonicalDotMachine](Partition.md#decl-17379ac1513b54b1), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_finite](Partition.md#decl-70d7bcd0619569bf), [TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_count](../../Gemm/Defs.md#decl-fa30d201f6e3a65f)

</details>

</details>

<a id="decl-1992fedc2c2443e2"></a>

<details>
<summary><code>TensorCore.canonicalPartition_count</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L61)

```lean
theorem canonicalPartition_count (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) :
    (canonicalPartition K extra floor hK xs).groups.length = groupCount K xs.length :=
  partitionExact_count _ _ _ _
```

**Supporting proofs:** [TensorCore.partitionExact_count](Partition.md#decl-f23e6df7073e6ba8)

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.groupCount](Partition.md#decl-b7760ff5c737d355), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_count](../Examples/BoundedDot.md#decl-6434984f6678b1a1), [TensorCore.gemmBlocks_count](../../Gemm/Bounds.md#decl-d19f053063b09c78), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0), [TensorCore.simulateGemmCell_count](../../Gemm/Defs.md#decl-fa30d201f6e3a65f)

</details>

</details>

<a id="decl-19d8614714352936"></a>

<details>
<summary><code>TensorCore.ideal_zero_pairs</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L66)

```lean
private theorem ideal_zero_pairs (K extra : ℕ) (floor : Option ℤ) (n : ℕ) :
    idealProducts (fp16Fp32Profile K extra floor) (List.replicate n (0, 0)) = some 0 := by
  have hz : (fp16Fp32Profile K extra floor).decode (BitVec.ofNat _ 0) = some ⟨0, 0, 0⟩ := by
    change decode16 0 = some ⟨0, 0, 0⟩
    decide +kernel
  have hprep : prepareProducts (fp16Fp32Profile K extra floor) (List.replicate n (0, 0)) =
      some (List.replicate n (Decoded.mk 0 0 0, Decoded.mk 0 0 0)) := by
    induction n with
    | zero => rfl
    | succ n ih =>
      simp [prepareProducts] at ih
      simp [prepareProducts, List.replicate_succ, List.mapM_cons, hz, ih]
  simp only [idealProducts, hprep, Option.map_some]
  congr 1
  clear hprep
  induction n with
  | zero => rfl
  | succ n ih =>
    simp [Decoded.value] at ih
    simp [List.replicate_succ, sumQ, ih, Decoded.value]
    grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../../Core/Defs.md#decl-c988858af545448a), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.Profile.decode](../Defs.md#decl-178599198b2d538e), [TensorCore.decode16](../../Core/Encoding.md#decl-09c456448c5633d0), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.pow2](../../Core/Exact.md#decl-b52a0281b35514e3), [TensorCore.prepareProducts](../Block.md#decl-90abac48864edcd2), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.idealProducts_padFp16Pairs](Partition.md#decl-78a2a3efb15b0ed0)

</details>

</details>

<a id="decl-78a2a3efb15b0ed0"></a>

<details>
<summary><code>TensorCore.idealProducts_padFp16Pairs</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L88)

```lean
theorem idealProducts_padFp16Pairs (K extra : ℕ) (floor : Option ℤ) (xs : List (F16 × F16)) :
    idealProducts (fp16Fp32Profile K extra floor) (padFp16Pairs K xs) =
      idealProducts (fp16Fp32Profile K extra floor) xs := by
  rw [padFp16Pairs, idealProducts_append, ideal_zero_pairs]
  cases h : idealProducts (fp16Fp32Profile K extra floor) xs <;> simp <;> grind
```

**Supporting proofs:** [TensorCore.idealProducts_append](DotProduct.md#decl-623f08595b227aca), [TensorCore.ideal_zero_pairs](Partition.md#decl-19d8614714352936)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Format.width](../../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.Profile](../Defs.md#decl-a2404f64f289a40a), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.tailPadding](Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.gemmBlocks_ideal](../../Gemm/Bounds.md#decl-a31501016f14518c), [TensorCore.simulateGemmCell_error](../../Gemm/Defs.md#decl-0dd9b9d7ce010319)

</details>

</details>

<a id="decl-a4ecaffa5e5880bb"></a>

<details>
<summary><code>TensorCore.canonicalPartition_ideal</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L94)

```lean
theorem canonicalPartition_ideal (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) :
    idealContributions (fp16Fp32Profile K extra floor) (canonicalPartition K extra floor hK xs).inputs =
      idealProducts (fp16Fp32Profile K extra floor) xs := by
  rw [OrderedPartition.ideal, idealProducts_padFp16Pairs]
```

**Supporting proofs:** [TensorCore.OrderedPartition.ideal](DotProduct.md#decl-b269022d73a4c27d), [TensorCore.idealProducts_padFp16Pairs](Partition.md#decl-78a2a3efb15b0ed0)

**Definitions and types:** [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_ideal](../Examples/BoundedDot.md#decl-d51d031070373d01), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0)

</details>

</details>

<a id="decl-a632fab4c91f1890"></a>

<details>
<summary><code>TensorCore.runCanonicalDot</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L101)

```lean
/-- Public dot-product execution checks the initial encoding even for an empty input. -/
def runCanonicalDot (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) : Except ModelError (List BlockTrace) :=
  match decode32 c with
  | none => .error .nonfiniteInput
  | some _ => (canonicalPartition K extra floor hK xs).run c
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b)

<details>
<summary>Used by</summary>

[TensorCore.Regression.constructed_partition_boundaries](../Regression/DotProduct.md#decl-ca7d093d7fdf14a1), [TensorCore.Regression.constructed_partition_tail](../Regression/DotProduct.md#decl-571ad9339f4b196c), [TensorCore.Regression.empty_dot_finite_policy](../Regression/PublicDomains.md#decl-65fac3dfdaf0d584), [TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.runCanonicalDotMachine](Partition.md#decl-17379ac1513b54b1), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c), [TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_finite](Partition.md#decl-70d7bcd0619569bf), [TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0)

</details>

</details>

<a id="decl-70d7bcd0619569bf"></a>

<details>
<summary><code>TensorCore.runCanonicalDot_finite</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L107)

```lean
theorem runCanonicalDot_finite (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (initial : Finite32) :
    runCanonicalDot K extra floor hK xs initial.bits =
      (canonicalPartition K extra floor hK xs).run initial.bits := by
  simp only [runCanonicalDot, initial.valid]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.boundedDot_run](../Examples/BoundedDot.md#decl-9241fb8f8ed9acc6), [TensorCore.runCanonicalDot_machine_eq_of_finite](Partition.md#decl-a122af29bf2c3029)

</details>

</details>

<a id="decl-7011e2bb23eafa4c"></a>

<details>
<summary><code>TensorCore.runCanonicalDot_blocks</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L113)

```lean
theorem runCanonicalDot_blocks (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) (ts : List BlockTrace)
    (h : runCanonicalDot K extra floor hK xs c = .ok ts) :
    runBlocks (fp16Fp32Profile K extra floor) c
      (canonicalPartition K extra floor hK xs).inputs = .ok ts := by
  unfold runCanonicalDot at h
  split at h
  · contradiction
  · exact h
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runBlocks](Composition.md#decl-d4b070b6697e01f0), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.runCanonicalDot_count](Partition.md#decl-d645d8ecb89a896d), [TensorCore.runCanonicalDot_uncorrected_error](Partition.md#decl-d2f2b4a7acb5a553), [TensorCore.runCanonicalDot_uncorrected_error_strict](Partition.md#decl-4665afff730521a0)

</details>

</details>

<a id="decl-d645d8ecb89a896d"></a>

<details>
<summary><code>TensorCore.runCanonicalDot_count</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L123)

```lean
theorem runCanonicalDot_count (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) (ts : List BlockTrace)
    (h : runCanonicalDot K extra floor hK xs c = .ok ts) :
    ts.length = groupCount K xs.length := by
  have hl := runBlocks_length (fp16Fp32Profile K extra floor) c
    (canonicalPartition K extra floor hK xs).inputs ts
    (runCanonicalDot_blocks K extra floor hK xs c ts h)
  simpa [OrderedPartition.inputs, canonicalPartition_count] using hl
```

**Supporting proofs:** [TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.runBlocks_length](ErrorBounds.md#decl-60cd89558816c4b8), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c)

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.groupCount](Partition.md#decl-b7760ff5c737d355), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-d2f2b4a7acb5a553"></a>

<details>
<summary><code>TensorCore.runCanonicalDot_uncorrected_error</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L134)

```lean
/-- The constructed schedule's error is relative to the unpadded original operands.
Zero padding changes shape but contributes no mathematical products. -/
theorem runCanonicalDot_uncorrected_error (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (initial : Finite32) (ts : List BlockTrace) (products : ℚ)
    (h : runCanonicalDot K extra floor hK xs initial.bits = .ok ts)
    (hi : idealProducts (fp16Fp32Profile K extra floor) xs = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) ≤
      sumQ (ts.map BlockTrace.errorBudget) :=
  (runBlocks_uncorrected_error (fp16Fp32Profile K extra floor) initial
    (canonicalPartition K extra floor hK xs).inputs ts products
    (runCanonicalDot_blocks K extra floor hK xs initial.bits ts h)
    (by rw [canonicalPartition_ideal, hi])).1
```

**Supporting proofs:** [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-4665afff730521a0"></a>

<details>
<summary><code>TensorCore.runCanonicalDot_uncorrected_error_strict</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L145)

```lean
theorem runCanonicalDot_uncorrected_error_strict (K extra : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (hxs : xs ≠ []) (initial : Finite32) (ts : List BlockTrace)
    (products : ℚ) (h : runCanonicalDot K extra floor hK xs initial.bits = .ok ts)
    (hi : idealProducts (fp16Fp32Profile K extra floor) xs = some products) :
    absQ (initial.value + products - (lastOutput initial ts).value) <
      sumQ (ts.map BlockTrace.errorBudget) := by
  have hb := (runBlocks_uncorrected_error (fp16Fp32Profile K extra floor) initial
    (canonicalPartition K extra floor hK xs).inputs ts products
    (runCanonicalDot_blocks K extra floor hK xs initial.bits ts h)
    (by rw [canonicalPartition_ideal, hi])).2
  apply hb
  intro hempty
  have hlen := congrArg List.length hempty
  simp only [OrderedPartition.inputs, List.length_map, List.length_nil,
    canonicalPartition_count] at hlen
  have hpad := padded_length K xs.length hK
  have hx : xs.length ≠ 0 := by intro hz; exact hxs (List.length_eq_zero_iff.mp hz)
  rw [hlen] at hpad
  simp only [Nat.zero_mul] at hpad
  omega
```

**Supporting proofs:** [TensorCore.canonicalPartition_count](Partition.md#decl-1992fedc2c2443e2), [TensorCore.canonicalPartition_ideal](Partition.md#decl-a4ecaffa5e5880bb), [TensorCore.padded_length](Partition.md#decl-61da2d73822bd178), [TensorCore.runBlocks_uncorrected_error](ErrorBounds.md#decl-dc5609ec5819f2da), [TensorCore.runCanonicalDot_blocks](Partition.md#decl-7011e2bb23eafa4c)

**Definitions and types:** [TensorCore.BlockOperands](Defs.md#decl-f76df1e9b7515342), [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.errorBudget](ErrorBounds.md#decl-64924d5a9a13575c), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](../../Core/Encoding.md#decl-453b2816528e5c77), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition](DotProduct.md#decl-282172656fc8b089), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.Profile.Word](../Defs.md#decl-3bca3de3cb04fb71), [TensorCore.absQ](../../Core/Exact.md#decl-8dd63ab202e070d3), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.groupCount](Partition.md#decl-b7760ff5c737d355), [TensorCore.idealContributions](Defs.md#decl-a2ade4bef59291e3), [TensorCore.idealProducts](Defs.md#decl-5d908ac035267580), [TensorCore.lastOutput](Composition.md#decl-59a9e0884980f32b), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890), [TensorCore.sumQ](../../Core/Exact.md#decl-f20062bdc47118bd), [TensorCore.tailPadding](Partition.md#decl-139b8e76e9854993)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-17379ac1513b54b1"></a>

<details>
<summary><code>TensorCore.runCanonicalDotMachine</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L167)

```lean
/-- Machine accumulation with the same public finite-input policy as `runCanonicalDot`. -/
def runCanonicalDotMachine (K extra w : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) : Except ModelError (List BlockTrace) :=
  match decode32 c with
  | none => .error .nonfiniteInput
  | some _ => runBlocksMachine w (fp16Fp32Profile K extra floor) c
      (canonicalPartition K extra floor hK xs).inputs
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runBlocksMachine](DotProduct.md#decl-c7ff918b61ba39eb), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890)

<details>
<summary>Used by</summary>

[TensorCore.Regression.empty_dot_finite_policy](../Regression/PublicDomains.md#decl-65fac3dfdaf0d584), [TensorCore.runCanonicalDot_machine_eq](Partition.md#decl-4c3b83d89062725d)

</details>

</details>

<a id="decl-4c3b83d89062725d"></a>

<details>
<summary><code>TensorCore.runCanonicalDot_machine_eq</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L174)

```lean
theorem runCanonicalDot_machine_eq (K extra carryBits w : ℕ) (floor : Option ℤ) (hK : 0 < K)
    (xs : List (F16 × F16)) (c : F32) (hc : K + 1 ≤ 2 ^ carryBits)
    (hw : 26 + extra + carryBits ≤ w) :
    runCanonicalDotMachine K extra w floor hK xs c = runCanonicalDot K extra floor hK xs c := by
  unfold runCanonicalDotMachine runCanonicalDot
  cases decode32 c with
  | none => rfl
  | some d =>
    exact fp16Fp32_schedule_machine_eq K extra carryBits w floor hc hw c
      (canonicalPartition K extra floor hK xs).inputs
```

**Supporting proofs:** [TensorCore.fp16Fp32_schedule_machine_eq](DotProduct.md#decl-1fc40acc7fd9825c)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.Decoded](../../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.F32](../../Core/Defs.md#decl-24fa1e63edeb271f), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.decode32](../../Core/Encoding.md#decl-a4001029898e709f), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runBlocksMachine](DotProduct.md#decl-c7ff918b61ba39eb), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890), [TensorCore.runCanonicalDotMachine](Partition.md#decl-17379ac1513b54b1)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a122af29bf2c3029"></a>

<details>
<summary><code>TensorCore.runCanonicalDot_machine_eq_of_finite</code></summary>

[Lean source](../../../../TensorCore/TC/Program/Partition.lean#L186)

```lean
/-- The underlying machine schedule still agrees on every finite initial encoding. -/
theorem runCanonicalDot_machine_eq_of_finite (K extra carryBits w : ℕ)
    (floor : Option ℤ) (hK : 0 < K) (xs : List (F16 × F16)) (initial : Finite32)
    (hc : K + 1 ≤ 2 ^ carryBits) (hw : 26 + extra + carryBits ≤ w) :
    runBlocksMachine w (fp16Fp32Profile K extra floor) initial.bits
      (canonicalPartition K extra floor hK xs).inputs =
      runCanonicalDot K extra floor hK xs initial.bits := by
  rw [runCanonicalDot_finite]
  exact fp16Fp32_schedule_machine_eq K extra carryBits w floor hc hw initial.bits
    (canonicalPartition K extra floor hK xs).inputs
```

**Supporting proofs:** [TensorCore.fp16Fp32_schedule_machine_eq](DotProduct.md#decl-1fc40acc7fd9825c), [TensorCore.runCanonicalDot_finite](Partition.md#decl-70d7bcd0619569bf)

**Definitions and types:** [TensorCore.BlockTrace](../Block.md#decl-6e6aa9836448ab93), [TensorCore.F16](../../Core/Defs.md#decl-7a3b8058d443c561), [TensorCore.Finite32](../../Core/Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.ModelError](../Block.md#decl-f7be0c438a4d4d1d), [TensorCore.OrderedPartition.inputs](DotProduct.md#decl-a64d8423ef8287d8), [TensorCore.OrderedPartition.run](DotProduct.md#decl-f44f6497dde77681), [TensorCore.canonicalPartition](Partition.md#decl-7e49132d90b040d5), [TensorCore.fp16Fp32Profile](../CanonicalDefs.md#decl-00203670fbae3212), [TensorCore.padFp16Pairs](Partition.md#decl-69dc55e3030be48b), [TensorCore.runBlocksMachine](DotProduct.md#decl-c7ff918b61ba39eb), [TensorCore.runCanonicalDot](Partition.md#decl-a632fab4c91f1890)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
