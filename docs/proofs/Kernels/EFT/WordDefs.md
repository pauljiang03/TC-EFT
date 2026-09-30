# TensorCore.Kernels.EFT.WordDefs

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-666b5ba9cbd0ae62"></a>

<details>
<summary><code>TensorCore.EFMachine.Magnitude</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L12)

```lean
abbrev Magnitude := BitVec 576
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.add_coefficient](Word.md#decl-8e4d668108a43518), [TensorCore.EFMachine.Word.add_exists](Word.md#decl-72199538c51a73d2), [TensorCore.EFMachine.Word.add_magnitude](Word.md#decl-53b494a56c2c7d9a), [TensorCore.EFMachine.Word.neg_coefficient](Word.md#decl-eb624cca7c61f035), [TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.sameValue](Defs.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.Word.sameValue_value](Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.Word.sign_value](Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80), [TensorCore.EFMachine.Word.split_sign](Word.md#decl-2477bb5e600645f0), [TensorCore.EFMachine.Word.value_zero_iff](Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.Word.zero](WordDefs.md#decl-6c4317a5e83370fa), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.encodeAtGrid](WordDefs.md#decl-b26e55426fdd0ef8), [TensorCore.EFMachine.encodeAtGrid_spec](Round.md#decl-825e23e32bfda2dc), [TensorCore.EFMachine.encodeRounded](WordDefs.md#decl-4eec0d2f438b9d92), [TensorCore.EFMachine.encodeRounded_spec](Round.md#decl-6aa1647dc1e12481), [TensorCore.EFMachine.magnitudeExponent_word](Round.md#decl-47a33e7a1a646083), [TensorCore.EFMachine.magnitudeSumWords](Defs.md#decl-5320305128099272), [TensorCore.EFMachine.magnitudeValue](Round.md#decl-2b5385df9c0fc552), [TensorCore.EFMachine.magnitude_add_no_wrap](Word.md#decl-89220ff5bda6d20c), [TensorCore.EFMachine.maxMagnitude32](WordDefs.md#decl-e1240926dd0c8785), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.EFMachine.rawMaximum](Grid.md#decl-3faa58580e24b52d), [TensorCore.EFMachine.rawMaximum_eq](Grid.md#decl-97a05462cd1ee144), [TensorCore.EFMachine.roundingCoefficient](WordDefs.md#decl-69d5af16c3511326), [TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingCoefficient_spec](Round.md#decl-23d703ce50cbcf2a), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.EFMachine.roundingGrid_bounds](Round.md#decl-cc1256a8c795226c), [TensorCore.EFMachine.roundingGrid_convExp](Round.md#decl-cf575f3a4700f276), [TensorCore.EFMachine.roundingGrid_div](Round.md#decl-73afe430816bd696), [TensorCore.EFMachine.roundingGrid_quotient_bound](Round.md#decl-b883f762f9c3cb78), [TensorCore.EFMachine.roundingGrid_toNat](Round.md#decl-cab4fbf103e63d2a), [TensorCore.EFMachine.selectedGrid](Defs.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769), [TensorCore.EFMachine.shift_magnitude](Decode.md#decl-ea20685fae2dfeb2), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c), [TensorCore.EFMachine.zeroWord_value](Decode.md#decl-4c8297f8c50b7d91), [TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries](../../Tests/EFT/BoundedEFT.md#decl-94ac05b809d0614c), [TensorCore.Regression.BoundedEFT.single_bit_scans](../../Tests/EFT/BoundedEFT.md#decl-e61b364a168e9302), [TensorCore.Regression.BoundedEFT.zero_and_dense_scans](../../Tests/EFT/BoundedEFT.md#decl-244a495c7ceef46f)

</details>

</details>

<a id="decl-3aba51db6b46c8eb"></a>

<details>
<summary><code>TensorCore.EFMachine.Grid</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L13)

```lean
abbrev Grid := BitVec 10
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator](DecodeDefs.md#decl-976ce481e6dcd532), [TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Accumulator.term_grid](Decode.md#decl-95f7733aa20f6632), [TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.Factor](DecodeDefs.md#decl-a7fb4111affbc435), [TensorCore.EFMachine.Path.alignmentBits](DecodeDefs.md#decl-409758bc0f53f8d1), [TensorCore.EFMachine.Path.floor](DecodeDefs.md#decl-cb3a933d840dd12f), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80), [TensorCore.EFMachine.Word.split_low_bound](Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.Word.split_magnitude](Word.md#decl-c8c834f6a1821fc0), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.split_sign](Word.md#decl-2477bb5e600645f0), [TensorCore.EFMachine.decode32Fields](DecodeDefs.md#decl-715bf8a9ec915fb2), [TensorCore.EFMachine.decode32Fields_asDecoded](Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.decodeFactor](DecodeDefs.md#decl-0667ade36b139bc7), [TensorCore.EFMachine.decodeFactor_asDecoded](Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.extract_component](Extraction.md#decl-f7b97097f702b90a), [TensorCore.EFMachine.outputGrid](WordDefs.md#decl-060f999f83e9c7c6), [TensorCore.EFMachine.outputGrid_spec](Grid.md#decl-966f710cc75730bb), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.EFMachine.product_grid](Decode.md#decl-d5e8311dc2c362b6), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.EFMachine.rawMaximum_eq](Grid.md#decl-97a05462cd1ee144), [TensorCore.EFMachine.selectedGrid](Defs.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769), [TensorCore.EFMachine.shift_magnitude](Decode.md#decl-ea20685fae2dfeb2), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c), [TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries](../../Tests/EFT/BoundedEFT.md#decl-94ac05b809d0614c)

</details>

</details>

<a id="decl-df353d912dc0da43"></a>

<details>
<summary><code>TensorCore.EFMachine.Word</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L15)

```lean
structure Word where
  negative : Bool
  magnitude : Magnitude
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term](DecodeDefs.md#decl-33ffb7ad2d432805), [TensorCore.EFMachine.Accumulator.term_magnitude](Decode.md#decl-8bf0521da8ce8cd8), [TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.Components](Defs.md#decl-cbab83ff033f2778), [TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Prepared](Defs.md#decl-60336b9775817f9a), [TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.Term](DecodeDefs.md#decl-fa1797d418dbd302), [TensorCore.EFMachine.Word.abs_value](Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.add_coefficient](Word.md#decl-8e4d668108a43518), [TensorCore.EFMachine.Word.add_exists](Word.md#decl-72199538c51a73d2), [TensorCore.EFMachine.Word.add_magnitude](Word.md#decl-53b494a56c2c7d9a), [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3), [TensorCore.EFMachine.Word.neg_coefficient](Word.md#decl-eb624cca7c61f035), [TensorCore.EFMachine.Word.neg_value](Word.md#decl-2d5527f4636e4785), [TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.round32_correct](Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.Word.sameValue](Defs.md#decl-6e80ed513eb0dad8), [TensorCore.EFMachine.Word.sameValue_value](Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.Word.sign_value](Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80), [TensorCore.EFMachine.Word.split_low_bound](Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.Word.split_magnitude](Word.md#decl-c8c834f6a1821fc0), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.split_sign](Word.md#decl-2477bb5e600645f0), [TensorCore.EFMachine.Word.sub](WordDefs.md#decl-31dba9dd75052db7), [TensorCore.EFMachine.Word.sub_value](Word.md#decl-0b550b776f4cac6a), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.Word.value_zero_iff](Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.Word.zero](WordDefs.md#decl-6c4317a5e83370fa), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.decode32Word](DecodeDefs.md#decl-811ace041b8ae4f8), [TensorCore.EFMachine.decode32Word_magnitude](Decode.md#decl-3bfadee11b9c0f75), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.decodeProduct_magnitude](Preparation.md#decl-257008ca3f331f86), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare](Defs.md#decl-795b364db94203eb), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.product](DecodeDefs.md#decl-0ddb52306171dbe9), [TensorCore.EFMachine.product_magnitude](Decode.md#decl-7ab036600e4da4d8), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.EFMachine.rawMaximum](Grid.md#decl-3faa58580e24b52d), [TensorCore.EFMachine.rawMaximum_eq](Grid.md#decl-97a05462cd1ee144), [TensorCore.EFMachine.scalarSum](Defs.md#decl-e15921640df89f0b), [TensorCore.EFMachine.scalarSumWithLean](Native.md#decl-e4ccd3078c932ff1), [TensorCore.EFMachine.scalarSumWithLean_eq](Native.md#decl-068a2eb7a865b141), [TensorCore.EFMachine.selectedGrid](Defs.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c), [TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91), [TensorCore.EFMachine.sumWordsAdds](Cost.md#decl-ec1a0c99d64fdbc4), [TensorCore.EFMachine.sumWordsAdds_eq](Cost.md#decl-92bd9b3866278153), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4), [TensorCore.EFMachine.wordBudget](Word.md#decl-0632d0aa311c3d92), [TensorCore.EFMachine.zeroWord_value](Decode.md#decl-4c8297f8c50b7d91), [TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries](../../Tests/EFT/BoundedEFT.md#decl-94ac05b809d0614c)

</details>

</details>

<a id="decl-6c4317a5e83370fa"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.zero</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L20)

```lean
def Word.zero : Word := ⟨false, 0⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4)

</details>

</details>

<a id="decl-e40213c7b865a797"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.coefficient</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L23)

```lean
/-- Mathematical interpretation; never used to execute the bounded procedure. -/
def Word.coefficient (x : Word) : ℤ :=
  if x.negative then -(x.magnitude.toNat : ℤ) else x.magnitude.toNat
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.Word.abs_value](Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.add_coefficient](Word.md#decl-8e4d668108a43518), [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.neg_coefficient](Word.md#decl-eb624cca7c61f035), [TensorCore.EFMachine.Word.neg_value](Word.md#decl-2d5527f4636e4785), [TensorCore.EFMachine.Word.sameValue_value](Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.Word.sign_value](Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.value](WordDefs.md#decl-15b8cbf513110381), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4), [TensorCore.EFMachine.zeroWord_value](Decode.md#decl-4c8297f8c50b7d91)

</details>

</details>

<a id="decl-15b8cbf513110381"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.value</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L26)

```lean
def Word.value (x : Word) : ℚ := (x.coefficient : ℚ) * pow2 (-272)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.coefficient](WordDefs.md#decl-e40213c7b865a797), [TensorCore.pow2](../../Numerics/Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Accumulator.term_value](Decode.md#decl-e6412c0d9fe39337), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Prepared.ideal](Preparation.md#decl-be7f298d110d502f), [TensorCore.EFMachine.Prepared.ideal_allZero](Correctness.md#decl-7f72f2542f0b2f93), [TensorCore.EFMachine.Word.abs_value](Round.md#decl-5922e66553898d4e), [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.Word.neg_value](Word.md#decl-2d5527f4636e4785), [TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32_correct](Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.Word.sameValue_value](Scalar.md#decl-9875615749ec7179), [TensorCore.EFMachine.Word.sign_value](Round.md#decl-c87aa48d8d80178d), [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low_bound](Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.sub_value](Word.md#decl-0b550b776f4cac6a), [TensorCore.EFMachine.Word.value_zero_iff](Round.md#decl-5a2494bde76c4d91), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.algorithm1_correct](Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.decode32Word_value](Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.decodeProduct_value](Preparation.md#decl-72fa6f01d649afc4), [TensorCore.EFMachine.decodeProducts_values](Preparation.md#decl-db0d4ea753e99da4), [TensorCore.EFMachine.extract_component](Extraction.md#decl-f7b97097f702b90a), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_capacity](Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.product_value](Decode.md#decl-3bf8dee7f9bfc91d), [TensorCore.EFMachine.shiftedWord_value](Decode.md#decl-c7dc56eb3d6d341c), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4), [TensorCore.EFMachine.zeroWord_value](Decode.md#decl-4c8297f8c50b7d91)

</details>

</details>

<a id="decl-1fe4d2aea1b80ed3"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.neg</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L28)

```lean
def Word.neg (x : Word) : Word := ⟨!x.negative, x.magnitude⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar](Defs.md#decl-6c67918db14780c9), [TensorCore.EFMachine.Components.scalarWithLean](Native.md#decl-f2a2e92b799d4090), [TensorCore.EFMachine.Components.scalarWithLean_eq](Native.md#decl-cc00897e3b21cc23), [TensorCore.EFMachine.Components.scalar_correct](Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.neg_coefficient](Word.md#decl-eb624cca7c61f035), [TensorCore.EFMachine.Word.neg_value](Word.md#decl-2d5527f4636e4785), [TensorCore.EFMachine.Word.sub](WordDefs.md#decl-31dba9dd75052db7), [TensorCore.EFMachine.Word.sub_value](Word.md#decl-0b550b776f4cac6a), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f)

</details>

</details>

<a id="decl-536f46716cb00311"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.add</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L32)

```lean
/-- Exact signed addition, rejecting unsigned magnitude overflow. Opposite signs
use an ordered subtraction, so neither subtraction can borrow. -/
def Word.add (x y : Word) : Option Word :=
  if x.negative == y.negative then
    let m := x.magnitude + y.magnitude
    if m < x.magnitude then none else some ⟨x.negative, m⟩
  else if y.magnitude ≤ x.magnitude then
    some ⟨x.negative, x.magnitude - y.magnitude⟩
  else some ⟨y.negative, y.magnitude - x.magnitude⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.add_coefficient](Word.md#decl-8e4d668108a43518), [TensorCore.EFMachine.Word.add_exists](Word.md#decl-72199538c51a73d2), [TensorCore.EFMachine.Word.add_magnitude](Word.md#decl-53b494a56c2c7d9a), [TensorCore.EFMachine.Word.add_value](Word.md#decl-888a94b87381a4b4), [TensorCore.EFMachine.Word.sub](WordDefs.md#decl-31dba9dd75052db7), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.sumWords](WordDefs.md#decl-ba026c3be9cc0f91), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4)

</details>

</details>

<a id="decl-31dba9dd75052db7"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.sub</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L40)

```lean
def Word.sub (x y : Word) : Option Word := x.add y.neg
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.neg](WordDefs.md#decl-1fe4d2aea1b80ed3)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.sub_value](Word.md#decl-0b550b776f4cac6a), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e)

</details>

</details>

<a id="decl-ba026c3be9cc0f91"></a>

<details>
<summary><code>TensorCore.EFMachine.sumWords</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L43)

```lean
/-- The order is explicit; each accepted suffix is represented by a fixed word. -/
def sumWords : List Word → Option Word
  | [] => some Word.zero
  | x :: xs => do x.add (← sumWords xs)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.Word.add](WordDefs.md#decl-536f46716cb00311), [TensorCore.EFMachine.Word.zero](WordDefs.md#decl-6c4317a5e83370fa)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.sumWords_exists](Word.md#decl-3960d51da75c24b0), [TensorCore.EFMachine.sumWords_value](Word.md#decl-c50a82a7014218e4)

</details>

</details>

<a id="decl-8c4b61b7593bc74f"></a>

<details>
<summary><code>TensorCore.EFMachine.WordSplit</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L47)

```lean
structure WordSplit where
  coarse : Word
  low : Word
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split](WordDefs.md#decl-eda28567293135a4), [TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80), [TensorCore.EFMachine.Word.split_low_bound](Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.Word.split_magnitude](Word.md#decl-c8c834f6a1821fc0), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.split_sign](Word.md#decl-2477bb5e600645f0), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_component](Extraction.md#decl-f7b97097f702b90a), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries](../../Tests/EFT/BoundedEFT.md#decl-94ac05b809d0614c)

</details>

</details>

<a id="decl-eda28567293135a4"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.split</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L54)

```lean
/-- Quotient/remainder extraction at 2^(grid-272). Check the full ten-bit gap
before shifting: narrowing a gap such as 256 to eight bits would lose the term. -/
def Word.split (x : Word) (grid : Grid) : WordSplit :=
  if grid ≥ 576 then ⟨⟨x.negative, 0⟩, x⟩
  else
    let m := (x.magnitude >>> grid) <<< grid
    ⟨⟨x.negative, m⟩, ⟨x.negative, x.magnitude - m⟩⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.WordSplit](WordDefs.md#decl-8c4b61b7593bc74f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.split_coarse](Word.md#decl-16bf34f9d85335a9), [TensorCore.EFMachine.Word.split_coarse_value](Dyadic.md#decl-ff27bb512df53e23), [TensorCore.EFMachine.Word.split_low](Word.md#decl-d1e0b15124927d80), [TensorCore.EFMachine.Word.split_low_bound](Dyadic.md#decl-74c80ff9c30d5552), [TensorCore.EFMachine.Word.split_low_value](Dyadic.md#decl-74ccca76d4f48986), [TensorCore.EFMachine.Word.split_magnitude](Word.md#decl-c8c834f6a1821fc0), [TensorCore.EFMachine.Word.split_reconstruct](Word.md#decl-86df21d9c0f746cf), [TensorCore.EFMachine.Word.split_sign](Word.md#decl-2477bb5e600645f0), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.EFMachine.extract](Defs.md#decl-1edcf1bb479bb8a3), [TensorCore.EFMachine.extract_component](Extraction.md#decl-f7b97097f702b90a), [TensorCore.EFMachine.extract_exists](Extraction.md#decl-a81bbb5141b0c42f), [TensorCore.EFMachine.extract_spec](Extraction.md#decl-faa78874821acf9e), [TensorCore.EFMachine.extraction_loop_bounds](Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.split_budget](Extraction.md#decl-a3c7a5b9369e689d), [TensorCore.EFMachine.split_sum](Extraction.md#decl-877b6b47e30b3bf0), [TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries](../../Tests/EFT/BoundedEFT.md#decl-94ac05b809d0614c)

</details>

</details>

<a id="decl-e1240926dd0c8785"></a>

<details>
<summary><code>TensorCore.EFMachine.maxMagnitude32</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L61)

```lean
/-- Largest finite FP32 magnitude in units of the common dyadic grid. -/
def maxMagnitude32 : Magnitude := (16777215 : Magnitude) <<< 376
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalarGuard](Defs.md#decl-ea76eecb4d404d2c), [TensorCore.EFMachine.Word.range_iff](Round.md#decl-9cf39bb31212af4d), [TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.add32WithLean](Native.md#decl-d54ee0a869d0df69), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.maxMagnitude32_value](Round.md#decl-246fd8187438ee97), [TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries](../../Tests/EFT/BoundedEFT.md#decl-94ac05b809d0614c)

</details>

</details>

<a id="decl-060f999f83e9c7c6"></a>

<details>
<summary><code>TensorCore.EFMachine.outputGrid</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L64)

```lean
/-- The output quantum in common-grid units, including subnormal and zero words. -/
def outputGrid (b : F32) : Grid :=
  let e := ((b >>> 23).setWidth 8).zeroExtend 10
  if e == 0 then 123 else e + 122
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Grid](WordDefs.md#decl-3aba51db6b46c8eb), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.outputGrid_spec](Grid.md#decl-966f710cc75730bb), [TensorCore.EFMachine.selectedGrid](Defs.md#decl-026f0e297cb0d39a), [TensorCore.EFMachine.selectedGrid_spec](Grid.md#decl-31f8d745f2b97769)

</details>

</details>

<a id="decl-ec9093f174d4c36a"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingGrid</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L69)

```lean
/-- Positive FP32 conversion grid, using at most ten leading-support probes. -/
def roundingGrid (m : Magnitude) : Magnitude :=
  let length := (576 : Magnitude) - leadingZeros m
  if length ≤ 147 then 123 else length - 24
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.leadingZeros](BitScanDefs.md#decl-dc7b8bb67a09f476)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingGrid_bounds](Round.md#decl-cc1256a8c795226c), [TensorCore.EFMachine.roundingGrid_convExp](Round.md#decl-cf575f3a4700f276), [TensorCore.EFMachine.roundingGrid_div](Round.md#decl-73afe430816bd696), [TensorCore.EFMachine.roundingGrid_quotient_bound](Round.md#decl-b883f762f9c3cb78), [TensorCore.EFMachine.roundingGrid_toNat](Round.md#decl-cab4fbf103e63d2a)

</details>

</details>

<a id="decl-69d5af16c3511326"></a>

<details>
<summary><code>TensorCore.EFMachine.roundingCoefficient</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L73)

```lean
def roundingCoefficient (m g : Magnitude) : Magnitude :=
  let k := m >>> g
  let r := m - (k <<< g)
  let half := (1 : Magnitude) <<< (g - 1)
  if r > half || (r == half && (k &&& 1) == 1) then k + 1 else k
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.roundingCoefficient_convCoeff](Round.md#decl-a55b48c044a3a9d5), [TensorCore.EFMachine.roundingCoefficient_spec](Round.md#decl-23d703ce50cbcf2a)

</details>

</details>

<a id="decl-b26e55426fdd0ef8"></a>

<details>
<summary><code>TensorCore.EFMachine.encodeAtGrid</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L79)

```lean
def encodeAtGrid (negative : Bool) (g k : Magnitude) : F32 :=
  let payload := if k < 8388608 then k else ((g - 122) <<< 23) + (k - 8388608)
  (if negative then (0x80000000 : F32) else 0) + payload.setWidth 32
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.encodeAtGrid_spec](Round.md#decl-825e23e32bfda2dc), [TensorCore.EFMachine.encodeRounded](WordDefs.md#decl-4eec0d2f438b9d92), [TensorCore.EFMachine.encodeRounded_spec](Round.md#decl-6aa1647dc1e12481)

</details>

</details>

<a id="decl-4eec0d2f438b9d92"></a>

<details>
<summary><code>TensorCore.EFMachine.encodeRounded</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L83)

```lean
def encodeRounded (negative : Bool) (g k : Magnitude) : F32 :=
  let (g, k) := if k == 16777216 then (g + 1, k >>> 1) else (g, k)
  encodeAtGrid negative g k
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.encodeAtGrid](WordDefs.md#decl-b26e55426fdd0ef8), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.round32](WordDefs.md#decl-ae96957dae22a7c5), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.encodeRounded_spec](Round.md#decl-6aa1647dc1e12481)

</details>

</details>

<a id="decl-ae96957dae22a7c5"></a>

<details>
<summary><code>TensorCore.EFMachine.Word.round32</code></summary>

[Lean source](../../../../TensorCore/Kernels/EFT/WordDefs.lean#L90)

```lean
/-- Direct integer nearest-even conversion to FP32. Both the discarded remainder
and its halfway threshold stay in the wide word. There is no intermediate FP64
rounding. Exact zero is +0; a negative nonzero underflow retains its sign. -/
def Word.round32 (x : Word) : Option F32 :=
  if x.magnitude > maxMagnitude32 then none
  else if x.magnitude == 0 then some 0
  else
    let g := roundingGrid x.magnitude
    some (encodeRounded x.negative g (roundingCoefficient x.magnitude g))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.EFMachine.Magnitude](WordDefs.md#decl-666b5ba9cbd0ae62), [TensorCore.EFMachine.Word](WordDefs.md#decl-df353d912dc0da43), [TensorCore.EFMachine.encodeRounded](WordDefs.md#decl-4eec0d2f438b9d92), [TensorCore.EFMachine.maxMagnitude32](WordDefs.md#decl-e1240926dd0c8785), [TensorCore.EFMachine.roundingCoefficient](WordDefs.md#decl-69d5af16c3511326), [TensorCore.EFMachine.roundingGrid](WordDefs.md#decl-ec9093f174d4c36a), [TensorCore.F32](../../Numerics/Defs.md#decl-24fa1e63edeb271f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Word.exact32](Defs.md#decl-fb01ec61248a5cab), [TensorCore.EFMachine.Word.exact32_value](Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.Word.round32_correct](Round.md#decl-84e75c815794c328), [TensorCore.EFMachine.Word.round32_eq](Round.md#decl-9fc51118cee048d6), [TensorCore.EFMachine.Word.round32_isSome_iff](Round.md#decl-19f702cd5b682251), [TensorCore.EFMachine.add32](DecodeDefs.md#decl-7ed3fa6d2b144ea7), [TensorCore.EFMachine.add32WithLean_eq](Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.algorithm1](Defs.md#decl-67eeb0773e124575), [TensorCore.EFMachine.algorithm1WithLean](Native.md#decl-e854b34f0fadc9c3), [TensorCore.EFMachine.algorithm1WithLean_eq](Native.md#decl-07076ef7735fa9b8), [TensorCore.EFMachine.algorithm1_prepared](Correctness.md#decl-be5fb7d967856d94), [TensorCore.Regression.BoundedEFT.extraction_and_rounding_boundaries](../../Tests/EFT/BoundedEFT.md#decl-94ac05b809d0614c)

</details>

</details>
