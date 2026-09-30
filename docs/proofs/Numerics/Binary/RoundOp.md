# TensorCore.Numerics.Binary.RoundOp

[Index](../../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-00a7255be9b19e5a"></a>

<details>
<summary><code>TensorCore.BinaryRoundingMode</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L8)

```lean
inductive BinaryRoundingMode where
  | towardZero
  | nearestEven
  | towardNegative
  | towardPositive
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec](RoundingContract.md#decl-88c3ff9da8e0df3a), [TensorCore.BinaryRoundSpec.finite](RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.ConversionStage](../Conversion.md#decl-19660b95e076faa1), [TensorCore.IEEE.Context](../../Scalar/Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.IntegerRound](../../Scalar/Precision.md#decl-c1146843cf5e28a6), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../../Scalar/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](../../Scalar/LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](../../Scalar/LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../../Scalar/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../../Scalar/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_eq](../../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.round32_finiteValue32](../../Scalar/LeanFiniteAddition.md#decl-4eefaec604b419ba), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](../../Scalar/LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.PrecisionRound](../../Scalar/Precision.md#decl-ac46ea0f0a5d7f56), [TensorCore.IEEE.coefficient_correct](../../Scalar/Precision.md#decl-9de0c69639190f6d), [TensorCore.IEEE.finiteBits](../../Scalar/Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](../../Scalar/Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](../../Scalar/Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.integerRound_unique](../../Scalar/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.overflowToInfinity](../../Scalar/Rounding.md#decl-060b290d21f2ceee), [TensorCore.IEEE.precisionMagnitude](../../Scalar/Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.precisionMagnitude_correct](../../Scalar/Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionMagnitude_le_max](../../Scalar/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](../../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionMagnitude_positive](../../Scalar/Precision.md#decl-1150eb9378a6cdaf), [TensorCore.IEEE.precisionRound_unique](../../Scalar/Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](../../Scalar/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../../Scalar/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.sumZeroSign](../../Scalar/Operations.md#decl-e76da8ff91860117), [TensorCore.PaperSpec.round32_rounds](../../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.Profile.toInvocation](../../TC/Invocation.md#decl-b30efe02b0f3acb9), [TensorCore.Regression.bf16_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.binary_all_modes_exact](../../Tests/TC/DirectedBinary.md#decl-4111f505a7465413), [TensorCore.Regression.binary_rounding_boundaries](../../Tests/TC/BinaryRounding.md#decl-7732df0c849d56c9), [TensorCore.Regression.binary_rounding_ties](../../Tests/TC/BinaryRounding.md#decl-91e4669037d12352), [TensorCore.Regression.directed_binary_formats](../../Tests/TC/DirectedBinary.md#decl-c538fbb1a39bf7b6), [TensorCore.Regression.directed_binary_negative_and_carry](../../Tests/TC/DirectedBinary.md#decl-2af499bff498a1cf), [TensorCore.Regression.directed_binary_range](../../Tests/TC/DirectedBinary.md#decl-094ebf81b6307879), [TensorCore.Regression.directed_binary_subnormal](../../Tests/TC/DirectedBinary.md#decl-f495329299faba81), [TensorCore.Regression.directed_unusual_format](../../Tests/TC/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.finite_bijection_endpoints](../../Tests/TC/DirectedBinary.md#decl-b74680eb28ad51fd), [TensorCore.Regression.finite_bijection_signed_zeros](../../Tests/TC/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.Regression.fma64Bits](../../Tests/TC/DirectedBinary.md#decl-6693e0fc3635ac42), [TensorCore.Regression.fma64_directed_half_ulp](../../Tests/TC/DirectedBinary.md#decl-746fc7a28c7ab90a), [TensorCore.Regression.fma64_fused_boundaries](../../Tests/TC/DirectedBinary.md#decl-6a45eabffa62d664), [TensorCore.Regression.fma64_subnormal](../../Tests/TC/DirectedBinary.md#decl-2416711161dfbff9), [TensorCore.Regression.fp16_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp32_generic_agrees](../../Tests/TC/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.fp64_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.negative_subnormal_lower_contract](../../Tests/TC/DirectedBinary.md#decl-6ef36ec120fedf99), [TensorCore.Regression.negative_subnormal_upper_contract](../../Tests/TC/DirectedBinary.md#decl-7cbd49d6e0ce38c4), [TensorCore.Regression.scalar64_double_rounding_incorrect](../../Tests/EFT/ScalarEFT.md#decl-75316677317adbed), [TensorCore.Regression.tf19_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.Regression.zero_product_canonical](../../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.RoundingMode.toBinary](RoundOp.md#decl-812d25a411978fe0), [TensorCore.alignedInvocation](../../TC/Profiles.md#decl-08059dfea19f5f55), [TensorCore.binary64Fma](../../TC/Profiles.md#decl-8bfe46830da92086), [TensorCore.binary64Fma_correct](../../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_exact_input](../../TC/Conversion.md#decl-e9ea2eb0949990ef), [TensorCore.binary64Fma_nearestEven](../../TC/Conversion.md#decl-d04a4eaaeb5ab283), [TensorCore.binary64Fma_success](../../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binary64Fma_towardNegative](../../TC/Conversion.md#decl-14d955da110e6975), [TensorCore.binary64Fma_towardPositive](../../TC/Conversion.md#decl-0c17a7e9421cc1e8), [TensorCore.binary64Fma_towardZero](../../TC/Conversion.md#decl-73cb656a116a886e), [TensorCore.binaryAdd](ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.binaryAdd_exact](ScalarSum.md#decl-3e2f947ce0bc4931), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryCoefficient_bounds](ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.binaryCoefficient_intCast](RoundTrip.md#decl-b8f8bffe28447932), [TensorCore.binaryCoefficient_le_integer](ConversionBounds.md#decl-e41347a8800b8463), [TensorCore.binaryCoefficient_nearestEven](CorrectRounding.md#decl-72bfac3090586308), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binarySignedRounded](CorrectRounding.md#decl-d04cb97895a8bf6c), [TensorCore.binarySignedRounded_nearest](CorrectRounding.md#decl-8b4b18fd2c76f51e), [TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binarySignedRounded_towardNegative](DirectedRounding.md#decl-5da226e78b7a9948), [TensorCore.binarySignedRounded_towardPositive](DirectedRounding.md#decl-4864dc665967ec3b), [TensorCore.binaryValue_injective_nonzero](RoundTrip.md#decl-0ab63ba315dd3cca), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.conversionStage_nearestEven_correct](../../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_towardNegative_correct](../../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_output_nearestEven](../../TC/Conversion.md#decl-ba61a0c4e133bd9a), [TensorCore.evalInvocation_output_towardNegative](../../TC/Conversion.md#decl-e2792a3384716247), [TensorCore.evalInvocation_output_towardPositive](../../TC/Conversion.md#decl-4ddbb479bc9e21d6), [TensorCore.evalInvocation_output_towardZero](../../TC/Conversion.md#decl-91e16db9cb9f47c2), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.exactFiniteWord_value](SignedBijection.md#decl-25318fd4bd410e4c), [TensorCore.legacy_invocation_bits](../../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareInvocation_legacy](../../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.representableBinary](ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.representableBinary_finite](ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_isSome_iff](RoundingContract.md#decl-9083817d3e897973), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](RoundingContract.md#decl-765cac64e8b78cf4), [TensorCore.tf32_invocation_bits](../../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1)

</details>

</details>

<a id="decl-812d25a411978fe0"></a>

<details>
<summary><code>TensorCore.RoundingMode.toBinary</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L15)

```lean
abbrev RoundingMode.toBinary : RoundingMode → BinaryRoundingMode
  | .towardZero => .towardZero
  | .nearestEven => .nearestEven
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.RoundingMode](../RoundOp.md#decl-3d487bd4115d0af1)

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp32_generic_agrees](../../Tests/TC/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.legacy_prepared_bits](../../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.roundBinary_fp32](RoundOp.md#decl-11e910ef6ebcee78)

</details>

</details>

<a id="decl-f5dc97045520b8c7"></a>

<details>
<summary><code>TensorCore.binaryCoefficient</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L20)

```lean
/-- Direction is applied to a nonnegative magnitude, with the original sign available. -/
def binaryCoefficient (mode : BinaryRoundingMode) (negative : Bool) (m : ℚ) : ℤ :=
  match mode with
  | .towardZero => m.floor
  | .nearestEven => rneInt m
  | .towardNegative => if negative then m.ceil else m.floor
  | .towardPositive => if negative then m.floor else m.ceil
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.rneInt](../RoundOp.md#decl-c2651a1e8f74a14a)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.finiteBits32_encode](../../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.packRound32_eq](../../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.coefficient_correct](../../Scalar/Precision.md#decl-9de0c69639190f6d), [TensorCore.IEEE.integerRound_unique](../../Scalar/Precision.md#decl-5643af5ce25bcc8c), [TensorCore.IEEE.precisionMagnitude](../../Scalar/Precision.md#decl-273af52c676de10a), [TensorCore.IEEE.precisionMagnitude_correct](../../Scalar/Precision.md#decl-248cb65f71cd879e), [TensorCore.IEEE.precisionMagnitude_le_max](../../Scalar/Precision.md#decl-c4d94067e704664f), [TensorCore.IEEE.precisionMagnitude_lower](../../Scalar/Precision.md#decl-01aabfab31a5714d), [TensorCore.IEEE.precisionRound_unique](../../Scalar/Precision.md#decl-a293a5d8f23d9070), [TensorCore.IEEE.precision_ceil_all](../../Scalar/Precision.md#decl-8c61542341b05489), [TensorCore.IEEE.precision_floor_all](../../Scalar/Precision.md#decl-bc21de7fff02bb8b), [TensorCore.IEEE.precision_nearest_all](../../Scalar/Precision.md#decl-1c14649b5fbd1fc1), [TensorCore.IEEE.round_overflow_iff](../../Scalar/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.binaryCoefficient_bounds](ConversionBounds.md#decl-627eb6051536ce43), [TensorCore.binaryCoefficient_intCast](RoundTrip.md#decl-b8f8bffe28447932), [TensorCore.binaryCoefficient_le_integer](ConversionBounds.md#decl-e41347a8800b8463), [TensorCore.binaryCoefficient_nearestEven](CorrectRounding.md#decl-72bfac3090586308), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](RoundingContract.md#decl-765cac64e8b78cf4)

</details>

</details>

<a id="decl-d8cef04fa85eeb47"></a>

<details>
<summary><code>TensorCore.encodeBinary</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L27)

```lean
def encodeBinary (f : Format) (negative : Bool) (e k : ℤ) : BitVec f.width :=
  BitVec.ofNat f.width ((if negative then 2 ^ (f.fractionBits + f.exponentBits) else 0) +
    (if k < (2 ^ f.fractionBits : ℕ) then k.toNat
     else (e + f.bias).toNat * 2 ^ f.fractionBits + (k - (2 ^ f.fractionBits : ℕ)).toNat))
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.encode](Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.IEEE.LeanBridge.encodeZero32_eq](../../Scalar/LeanBridge.md#decl-98d0f6338db37912), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.packFinite32_eq](../../Scalar/LeanBridge.md#decl-cb2a2e247f1137bf), [TensorCore.IEEE.LeanBridge.packRound32_eq](../../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.pack_unpack32_nonzero](../../Scalar/LeanFiniteAddition.md#decl-343e8c9e056e8d78), [TensorCore.IEEE.maxFiniteWord](../../Scalar/Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.maxFiniteWord_value](../../Scalar/Basic.md#decl-798b937fdff5abb2), [TensorCore.encodeBinary_fields](Bijection.md#decl-bcffec0f99ba4510), [TensorCore.encodeBinary_fp32](RoundOp.md#decl-28f15cc4c036f614), [TensorCore.encodeBinary_parity](Encoding.md#decl-9ed3eec562cea40c), [TensorCore.encodeBinary_toNat](Encoding.md#decl-0082d54957605cf4), [TensorCore.encodeBinary_value](Encoding.md#decl-4c3ec26630f2de66), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](RoundingContract.md#decl-765cac64e8b78cf4)

</details>

</details>

<a id="decl-627946dba132da21"></a>

<details>
<summary><code>TensorCore.binaryConvExp</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L32)

```lean
def binaryConvExp (f : Format) (m : ℚ) : ℤ := max (magnitudeExponent m) f.emin
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Defs.md#decl-af48d9057baa67b0), [TensorCore.magnitudeExponent](../RoundOp.md#decl-d0b00fe98f5e4d15)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.finiteBits32_encode](../../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.firstPass32](../../Scalar/LeanRounding.md#decl-1f3110087e3c2f88), [TensorCore.IEEE.LeanBridge.packRound32_eq](../../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.targetExponent32_eq](../../Scalar/LeanRounding.md#decl-fe597c4119872d5a), [TensorCore.IEEE.precisionMagnitude_le_max](../../Scalar/Precision.md#decl-c4d94067e704664f), [TensorCore.binaryConvCoeff_bounds](ConversionBounds.md#decl-0ab451f72fcbedb6), [TensorCore.binaryConvExp_bounds](ConversionBounds.md#decl-47b4c2534b697b64), [TensorCore.binaryMagnitudeRounded](CorrectRounding.md#decl-bc28d8b9cd0c1242), [TensorCore.binaryMagnitudeRounded_lower](CorrectRounding.md#decl-5a9bc5842c8ce296), [TensorCore.binarySignedRounded_tie_even](CorrectRounding.md#decl-18fdd18d08f1b0b0), [TensorCore.binary_ceil_magnitude_spec](DirectedRounding.md#decl-d0e5c511048746ec), [TensorCore.binary_rne_lower_binade_strict](CorrectRounding.md#decl-b59c1df23dc23823), [TensorCore.binary_rne_magnitude_nearest](CorrectRounding.md#decl-c16cdcb9f5fea95b), [TensorCore.binary_rne_magnitude_tie_even](CorrectRounding.md#decl-2c3656de977c4db1), [TensorCore.binary_rtz_magnitude_spec](CorrectRounding.md#decl-9bf23e7c9d56beaa), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](RoundingContract.md#decl-765cac64e8b78cf4)

</details>

</details>

<a id="decl-ae1aaac3088affc4"></a>

<details>
<summary><code>TensorCore.binaryCarry</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L34)

```lean
def binaryCarry (f : Format) (e k : ℤ) : ℤ × ℤ :=
  if k = (2 ^ (f.fractionBits + 1) : ℕ) then (e + 1, k / 2) else (e, k)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.finiteBits32_encode](../../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.packRound32_eq](../../Scalar/LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](../../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.binaryCarry_spec](ConversionBounds.md#decl-9bdec62f2ae623aa), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](RoundingContract.md#decl-765cac64e8b78cf4)

</details>

</details>

<a id="decl-8ffd5ccdcdd7afed"></a>

<details>
<summary><code>TensorCore.roundBinary</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L39)

```lean
/-- All formats use the finite reference domain, including every directed mode.
Each conversion boundary decodes these returned bits before further arithmetic. -/
def roundBinary (f : Format) (mode : BinaryRoundingMode) (x : ℚ) : Option (BitVec f.width) :=
  if ¬ f.WellFormed then none
  else if absQ x > f.maxFinite then none
  else if x = 0 then some 0
  else
    let negative := decide (x < 0)
    let e := binaryConvExp f (absQ x)
    let k := binaryCoefficient mode negative (absQ x / pow2 (e - f.fractionBits))
    let (e', k') := binaryCarry f e k
    if e' > f.emax then none else some (encodeBinary f negative e' k')
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3)

<details>
<summary>Used by</summary>

[TensorCore.ConversionStage.convert](../Conversion.md#decl-5e2170b37d7e10f7), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](../../Scalar/LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.convert_self_finite](../../Scalar/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.finiteBits](../../Scalar/Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](../../Scalar/Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](../../Scalar/Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.round_agrees_finite](../../Scalar/Rounding.md#decl-8c10d9eec6663da4), [TensorCore.PaperSpec.round32_rounds](../../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.Regression.bf16_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-a1e4399a2a4d855e), [TensorCore.Regression.binary_all_modes_exact](../../Tests/TC/DirectedBinary.md#decl-4111f505a7465413), [TensorCore.Regression.binary_rounding_boundaries](../../Tests/TC/BinaryRounding.md#decl-7732df0c849d56c9), [TensorCore.Regression.binary_rounding_ties](../../Tests/TC/BinaryRounding.md#decl-91e4669037d12352), [TensorCore.Regression.directed_binary_formats](../../Tests/TC/DirectedBinary.md#decl-c538fbb1a39bf7b6), [TensorCore.Regression.directed_binary_negative_and_carry](../../Tests/TC/DirectedBinary.md#decl-2af499bff498a1cf), [TensorCore.Regression.directed_binary_range](../../Tests/TC/DirectedBinary.md#decl-094ebf81b6307879), [TensorCore.Regression.directed_binary_subnormal](../../Tests/TC/DirectedBinary.md#decl-f495329299faba81), [TensorCore.Regression.directed_unusual_format](../../Tests/TC/DirectedBinary.md#decl-eaae17864f8d0089), [TensorCore.Regression.finite_bijection_endpoints](../../Tests/TC/DirectedBinary.md#decl-b74680eb28ad51fd), [TensorCore.Regression.finite_bijection_signed_zeros](../../Tests/TC/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.Regression.fp16_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-00b226cd62b0c941), [TensorCore.Regression.fp32_generic_agrees](../../Tests/TC/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.Regression.fp64_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-e5bfd4e1909b6694), [TensorCore.Regression.negative_subnormal_lower_contract](../../Tests/TC/DirectedBinary.md#decl-6ef36ec120fedf99), [TensorCore.Regression.negative_subnormal_upper_contract](../../Tests/TC/DirectedBinary.md#decl-7cbd49d6e0ce38c4), [TensorCore.Regression.scalar64_double_rounding_incorrect](../../Tests/EFT/ScalarEFT.md#decl-75316677317adbed), [TensorCore.Regression.tf19_rounding_correct](../../Tests/TC/BinaryRounding.md#decl-612a1b643914598f), [TensorCore.binary64Fma_correct](../../TC/FusedRounding.md#decl-818649bb83af8ab6), [TensorCore.binary64Fma_success](../../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binaryAdd](ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.binaryAdd_exact](ScalarSum.md#decl-3e2f947ce0bc4931), [TensorCore.binaryValue_injective_nonzero](RoundTrip.md#decl-0ab63ba315dd3cca), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.conversionStage_nearestEven_correct](../../TC/Conversion.md#decl-4ce2a113c3a79271), [TensorCore.conversionStage_output](../Conversion.md#decl-3479ab5362b59148), [TensorCore.conversionStage_towardNegative_correct](../../TC/Conversion.md#decl-906d159df48d6e65), [TensorCore.conversionStage_towardPositive_correct](../../TC/Conversion.md#decl-e9bb1af6a9107993), [TensorCore.conversionStage_towardZero_correct](../../TC/Conversion.md#decl-21132c7fe11d05ea), [TensorCore.evalInvocation_output](../../TC/InvocationProperties.md#decl-c5356d6db12f1b4d), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.exactFiniteWord_value](SignedBijection.md#decl-25318fd4bd410e4c), [TensorCore.legacy_prepared_bits](../../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.representableBinary](ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.representableBinary_finite](ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.roundBinary_canonical](RoundTrip.md#decl-3e97bd2100d6f1d3), [TensorCore.roundBinary_correct](RoundingContract.md#decl-12a22af180d3ad5e), [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_fp32](RoundOp.md#decl-11e910ef6ebcee78), [TensorCore.roundBinary_isSome_iff](RoundingContract.md#decl-9083817d3e897973), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_range](RoundOp.md#decl-0877ce0e6eb40a61), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025), [TensorCore.roundBinary_zero](RoundingContract.md#decl-765cac64e8b78cf4)

</details>

</details>

<a id="decl-45dceb4f1deb9b75"></a>

<details>
<summary><code>TensorCore.binaryValue</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L50)

```lean
def binaryValue (f : Format) (bits : BitVec f.width) : Option ℚ :=
  ((classify f bits).finite).map Decoded.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](../Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Defs.md#decl-c988858af545448a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.classify](../Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRep.encode_value](Bijection.md#decl-d81c625dde1b8c14), [TensorCore.BinaryRoundSpec.finite](RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](../../Scalar/LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](../../Scalar/LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](../../Scalar/LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packRound32_reference](../../Scalar/LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.value32_nonzero](../../Scalar/LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.RoundSpec](../../Scalar/Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convert_self_finite](../../Scalar/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode_finite_iff](../../Scalar/Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.maxFiniteWord_value](../../Scalar/Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.round](../../Scalar/Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](../../Scalar/Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](../../Scalar/Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](../../Scalar/Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](../../Scalar/Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](../../Scalar/Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](../../Scalar/Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](../../Scalar/Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.zero_value](../../Scalar/Basic.md#decl-42575e26b6696b19), [TensorCore.NearestEven](CorrectRounding.md#decl-8a557a5be79cc256), [TensorCore.PaperSpec.round32_rounds](../../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.Regression.finite_bijection_endpoints](../../Tests/TC/DirectedBinary.md#decl-b74680eb28ad51fd), [TensorCore.Regression.finite_bijection_signed_zeros](../../Tests/TC/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.Regression.scalar64_double_rounding_incorrect](../../Tests/EFT/ScalarEFT.md#decl-75316677317adbed), [TensorCore.TowardNegative](DirectedRounding.md#decl-1b7bde7add41e53a), [TensorCore.TowardPositive](DirectedRounding.md#decl-1abd95ba8c4ca756), [TensorCore.TowardZero](CorrectRounding.md#decl-ea87f85641f1fbf8), [TensorCore.binaryAdd](ScalarSum.md#decl-9bdd2a014e05d482), [TensorCore.binaryAdd_exact](ScalarSum.md#decl-3e2f947ce0bc4931), [TensorCore.binaryValue_injective_nonzero](RoundTrip.md#decl-0ab63ba315dd3cca), [TensorCore.binaryValue_roundBinary](RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.binaryValue_zero](CorrectRounding.md#decl-316323365131d605), [TensorCore.decodeBinaryRep_value](Bijection.md#decl-35db687909729831), [TensorCore.decode_encodeSignedBinary](SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encodeBinaryRep](Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeBinary_value](Encoding.md#decl-4c3ec26630f2de66), [TensorCore.encodeSignedBinary_value](SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.exactFiniteWord](SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.exactFiniteWord_value](SignedBijection.md#decl-25318fd4bd410e4c), [TensorCore.representableBinary](ScalarSum.md#decl-983cd49dc90d1170), [TensorCore.representableBinary_finite](ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.roundBinary_exact_of_finite](ScalarSum.md#decl-b12a2c49a9878d10), [TensorCore.roundBinary_nearestEven_correct](CorrectRounding.md#decl-56aa49cf9819c893), [TensorCore.roundBinary_nonzero_spec](CorrectRounding.md#decl-8fec043a874087be), [TensorCore.roundBinary_towardNegative_correct](DirectedRounding.md#decl-3b3e5c3213c35d5f), [TensorCore.roundBinary_towardPositive_correct](DirectedRounding.md#decl-a0d617c51646227e), [TensorCore.roundBinary_towardZero_correct](CorrectRounding.md#decl-7cd93a19048f4025)

</details>

</details>

<a id="decl-28f15cc4c036f614"></a>

<details>
<summary><code>TensorCore.encodeBinary_fp32</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L53)

```lean
theorem encodeBinary_fp32 (negative : Bool) (e k : ℤ) :
    encodeBinary fp32 negative e k = encode32 negative e k := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.encode32](../RoundOp.md#decl-2d041a1e685373ec), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.fp32](../Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-11e910ef6ebcee78"></a>

<details>
<summary><code>TensorCore.roundBinary_fp32</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L57)

```lean
theorem roundBinary_fp32 (mode : RoundingMode) (x : ℚ) :
    roundBinary fp32 mode.toBinary x = round32 mode x := by
  cases mode <;> rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.RoundingMode](../RoundOp.md#decl-3d487bd4115d0af1), [TensorCore.RoundingMode.toBinary](RoundOp.md#decl-812d25a411978fe0), [TensorCore.fp32](../Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.round32](../RoundOp.md#decl-11a6489236dbb65b), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.Regression.fp32_generic_agrees](../../Tests/TC/BinaryRounding.md#decl-a1a7d122c1f74869), [TensorCore.legacy_prepared_bits](../../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.padded_prepared_bits](../../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6)

</details>

</details>

<a id="decl-0877ce0e6eb40a61"></a>

<details>
<summary><code>TensorCore.roundBinary_range</code></summary>

[Lean source](../../../../TensorCore/Numerics/Binary/RoundOp.lean#L61)

```lean
theorem roundBinary_range {f : Format} {mode : BinaryRoundingMode} {x : ℚ}
    {bits : BitVec f.width} (h : roundBinary f mode x = some bits) :
    f.WellFormed ∧ absQ x ≤ f.maxFinite := by
  unfold roundBinary at h
  split at h
  · simp at h
  · split at h
    · simp at h
    · constructor <;> grind
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.Format](../Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.Format.emax](../Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.maxFinite](../Defs.md#decl-6cac0e89f6135a61), [TensorCore.Format.width](../Defs.md#decl-950f9d663ce32954), [TensorCore.absQ](../Exact.md#decl-8dd63ab202e070d3), [TensorCore.binaryCarry](RoundOp.md#decl-ae1aaac3088affc4), [TensorCore.binaryCoefficient](RoundOp.md#decl-f5dc97045520b8c7), [TensorCore.binaryConvExp](RoundOp.md#decl-627946dba132da21), [TensorCore.encodeBinary](RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Exact.md#decl-b52a0281b35514e3), [TensorCore.roundBinary](RoundOp.md#decl-8ffd5ccdcdd7afed)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](../../Scalar/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.conversionStage_range](../Conversion.md#decl-9878d77fe9422846), [TensorCore.roundBinary_isSome_iff](RoundingContract.md#decl-9083817d3e897973), [TensorCore.roundBinary_sign](RoundingContract.md#decl-89538250b2c31eac)

</details>

</details>
