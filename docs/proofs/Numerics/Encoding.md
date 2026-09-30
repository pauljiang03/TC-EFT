# TensorCore.Numerics.Encoding

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-52d401d7433cac5a"></a>

<details>
<summary><code>TensorCore.classifyNat</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L8)

```lean
/-- Classification of a bit pattern given as a natural number below `2 ^ f.width`. -/
def classifyNat (f : Format) (n : ℕ) : Classification :=
  let fraction := n % 2 ^ f.fractionBits
  let exponent := n / 2 ^ f.fractionBits % 2 ^ f.exponentBits
  let negative := n / 2 ^ (f.fractionBits + f.exponentBits) != 0
  let signed (m : ℕ) : ℤ := if negative then -(m : ℤ) else m
  if exponent = 2 ^ f.exponentBits - 1 then
    if fraction = 0 then .infinity negative else .nan
  else if exponent = 0 then
    if fraction = 0 then .zero negative
    else .subnormal ⟨signed fraction, 1 - f.bias, f.fractionBits⟩
  else .normal ⟨signed (2 ^ f.fractionBits + fraction),
    (exponent : ℤ) - f.bias, f.fractionBits⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Format](Defs.md#decl-db780180792c6817)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.decodeFactor_asDecoded](../Kernels/EFT/Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.decodeFactor_bounds](../Kernels/EFT/Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](../Kernels/EFT/Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.PaperSpec.decode_eq](../TC/Specification/Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.decode_products_eq](../TC/Specification/Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.terms_eq](../TC/Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.value32_eq](../TC/Specification/Rounding.md#decl-4158336941743c50), [TensorCore.ValueFormat.classifyNat](Format.md#decl-dfd30a62134c847e), [TensorCore.binaryValue_zero](Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.classifyNat32_finite](EncodingProperties.md#decl-2559eed0b9bbddd9), [TensorCore.classifyNat_bounded](FormatProperties.md#decl-210634dc2026dbec), [TensorCore.classifyNat_finiteValue](Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.classifyNat_fp32](EncodingProperties.md#decl-e78f14689117d01e), [TensorCore.classifyNat_metadata](FormatProperties.md#decl-939dd915424f2515), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.classifyNat_scale_lower](FormatProperties.md#decl-f92353957f44c1cf), [TensorCore.decode32_below](../TC/MonotonicityRange.md#decl-a811310312b96b08), [TensorCore.decode32_eq](Encoding.md#decl-d61e64a2750bda68), [TensorCore.decode32_fields](RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.decode32_finite](EncodingProperties.md#decl-bb951033d1fed7f8), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.encodeBinary_value](Binary/Encoding.md#decl-4c3ec26630f2de66), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.tf32Register_decode](../TC/CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32Register_decode_unpadded](../TC/CanonicalFormats.md#decl-8289f6bd2846d909), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2)

</details>

</details>

<a id="decl-793c375a3325b7e3"></a>

<details>
<summary><code>TensorCore.classify</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L21)

```lean
def classify (f : Format) (bits : BitVec f.width) : Classification := classifyNat f bits.toNat
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Format](Defs.md#decl-db780180792c6817), [TensorCore.Format.width](Defs.md#decl-950f9d663ce32954), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec.finite](Binary/RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinaryWord](Binary/Defs.md#decl-b1ebef5bf580ea01), [TensorCore.IEEE.convert_self_finite](../Scalar/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode](../Scalar/Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.decode_finite_iff](../Scalar/Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_nan](../Scalar/Basic.md#decl-4f5c3082603585a7), [TensorCore.Profile.decode](../TC/Defs.md#decl-178599198b2d538e), [TensorCore.Regression.finite_bijection_signed_zeros](../Tests/TC/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.Regression.negativeZero16](../Tests/TC/DirectedBinary.md#decl-886728ef6cdfd42e), [TensorCore.Regression.positiveZero16](../Tests/TC/DirectedBinary.md#decl-7640a0640949b17b), [TensorCore.Regression.zero_product_canonical](../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binaryValue](Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.binaryValue_roundBinary](Binary/RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](Binary/SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](Binary/SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.binaryValue_zero](Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.decode16](Encoding.md#decl-09c456448c5633d0), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.decodeBinaryRep](Binary/Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.decodeBinaryRep_value](Binary/Bijection.md#decl-35db687909729831), [TensorCore.decodeSignedBinary](Binary/SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.decode_encodeBinaryRep](Binary/Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.decode_encodeSignedBinary](Binary/SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encodeBinaryRep](Binary/Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeBinary_value](Binary/Encoding.md#decl-4c3ec26630f2de66), [TensorCore.encodeSignedBinary_sign](Binary/SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](Binary/SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeBinaryRep](Binary/Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.exactFiniteWord](Binary/SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.exactFiniteWord_value](Binary/SignedBijection.md#decl-25318fd4bd410e4c), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.finiteBinaryWord_exponent](Binary/Bijection.md#decl-9da98bc2392e0660), [TensorCore.finiteBinary_none](Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](Conversion.md#decl-66e4132ec74cac83), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91), [TensorCore.prepareInvocation](../TC/Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.representableBinary_finite](Binary/ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-cfa2987aba5ba75a"></a>

<details>
<summary><code>TensorCore.Classification.finite</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L23)

```lean
def Classification.finite : Classification → Option Decoded
  | .zero _ => some ⟨0, 0, 0⟩
  | .subnormal x | .normal x => some x
  | .infinity _ | .nan => none
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350)

<details>
<summary>Used by</summary>

[TensorCore.BinaryRoundSpec.finite](Binary/RoundingContract.md#decl-5fa4e1dc58d238c5), [TensorCore.EFMachine.decode32Fields_asDecoded](../Kernels/EFT/Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.decode32Fields_bounds](../Kernels/EFT/Decode.md#decl-b184c06b3493779e), [TensorCore.EFMachine.decodeFactor_asDecoded](../Kernels/EFT/Decode.md#decl-dc533ad804fd849a), [TensorCore.EFMachine.decodeFactor_bounds](../Kernels/EFT/Decode.md#decl-59de8d575604c3fc), [TensorCore.EFMachine.decodeFactor_profile](../Kernels/EFT/Preparation.md#decl-2cf39080c6dc39f5), [TensorCore.EFMachine.value32_finite_exponent](../Kernels/EFT/Native.md#decl-5badba3cc64a61b4), [TensorCore.FiniteBinary](Conversion.md#decl-819c01227290b53b), [TensorCore.FiniteBinaryWord](Binary/Defs.md#decl-b1ebef5bf580ea01), [TensorCore.IEEE.convert_self_finite](../Scalar/Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode_finite_iff](../Scalar/Basic.md#decl-e921ec9072a7db34), [TensorCore.OperandEncoding.decode](Format.md#decl-54e57bd4e5755510), [TensorCore.PaperSpec.decode_eq](../TC/Specification/Stages.md#decl-16342b2304718371), [TensorCore.PaperSpec.decode_products_eq](../TC/Specification/Stages.md#decl-cee1625271ace0f4), [TensorCore.PaperSpec.terms_eq](../TC/Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.PaperSpec.value32_eq](../TC/Specification/Rounding.md#decl-4158336941743c50), [TensorCore.Profile.decode](../TC/Defs.md#decl-178599198b2d538e), [TensorCore.Regression.finite_bijection_signed_zeros](../Tests/TC/DirectedBinary.md#decl-8a62c9179ae2403a), [TensorCore.Regression.negativeZero16](../Tests/TC/DirectedBinary.md#decl-886728ef6cdfd42e), [TensorCore.Regression.positiveZero16](../Tests/TC/DirectedBinary.md#decl-7640a0640949b17b), [TensorCore.Regression.zero_product_canonical](../Tests/TC/PublicDomains.md#decl-d277804bf4bb3c58), [TensorCore.ValueFormat.decode](Format.md#decl-6d84b56a4c29f326), [TensorCore.binary64Fma_success](../TC/FusedRounding.md#decl-b369329edfc5a2cd), [TensorCore.binaryValue](Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.binaryValue_roundBinary](Binary/RoundTrip.md#decl-9a5b73ab13b18c71), [TensorCore.binaryValue_sign](Binary/SignedBijection.md#decl-4764d57fcda6ba1e), [TensorCore.binaryValue_sign_injective](Binary/SignedBijection.md#decl-9cff42a1aec63f03), [TensorCore.binaryValue_zero](Binary/CorrectRounding.md#decl-316323365131d605), [TensorCore.classifyNat32_finite](EncodingProperties.md#decl-2559eed0b9bbddd9), [TensorCore.classifyNat_bounded](FormatProperties.md#decl-210634dc2026dbec), [TensorCore.classifyNat_finiteValue](Binary/Encoding.md#decl-1caf128b0fdea826), [TensorCore.classifyNat_metadata](FormatProperties.md#decl-939dd915424f2515), [TensorCore.classifyNat_scale_le_of_magnitude](Binary/MagnitudeScale.md#decl-ca3faee92dc85564), [TensorCore.classifyNat_scale_lower](FormatProperties.md#decl-f92353957f44c1cf), [TensorCore.conversionStage_output](Conversion.md#decl-3479ab5362b59148), [TensorCore.decode16](Encoding.md#decl-09c456448c5633d0), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.decode32_below](../TC/MonotonicityRange.md#decl-a811310312b96b08), [TensorCore.decode32_eq](Encoding.md#decl-d61e64a2750bda68), [TensorCore.decode32_fields](RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.decode32_finite](EncodingProperties.md#decl-bb951033d1fed7f8), [TensorCore.decodeBinaryRep](Binary/Bijection.md#decl-dd7db11ae1e1ea80), [TensorCore.decodeBinaryRep_value](Binary/Bijection.md#decl-35db687909729831), [TensorCore.decodeSignedBinary](Binary/SignedBijection.md#decl-cb2fcf99d19b6a37), [TensorCore.decode_encodeBinaryRep](Binary/Bijection.md#decl-2b92b9b7bcfc34f3), [TensorCore.decode_encodeSignedBinary](Binary/SignedBijection.md#decl-2c11097025d8ee97), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.encodeBinaryRep](Binary/Bijection.md#decl-abc077f61bbca602), [TensorCore.encodeBinary_value](Binary/Encoding.md#decl-4c3ec26630f2de66), [TensorCore.encodeSignedBinary_sign](Binary/SignedBijection.md#decl-a3ba45d9a3c47498), [TensorCore.encodeSignedBinary_value](Binary/SignedBijection.md#decl-7432a4a377dff8e3), [TensorCore.encode_decodeBinaryRep](Binary/Bijection.md#decl-0ef3a70fffcc866c), [TensorCore.exactFiniteWord](Binary/SignedBijection.md#decl-6b99b2e3d470fe06), [TensorCore.exactFiniteWord_value](Binary/SignedBijection.md#decl-25318fd4bd410e4c), [TensorCore.finiteBinary](Conversion.md#decl-4947fce7ecea0c20), [TensorCore.finiteBinaryWord_exponent](Binary/Bijection.md#decl-9da98bc2392e0660), [TensorCore.finiteBinary_none](Conversion.md#decl-ec8059a2865c017f), [TensorCore.finiteBinary_some](Conversion.md#decl-66e4132ec74cac83), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.packedIEEE_decode](Format.md#decl-bf7a7c5a29f4ca91), [TensorCore.padded_decode_requires_zero](Format.md#decl-8eec2d89dbf9d22f), [TensorCore.padded_decode_value](Format.md#decl-481771923e8baaab), [TensorCore.prepareInvocation](../TC/Invocation.md#decl-4c327b22c0823d02), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.representableBinary_finite](Binary/ScalarSum.md#decl-d4d92bf55b290375), [TensorCore.tf32Register_decode](../TC/CanonicalFormats.md#decl-a7966016f7fa63bf), [TensorCore.tf32Register_decode_unpadded](../TC/CanonicalFormats.md#decl-8289f6bd2846d909), [TensorCore.valueFormat_decode_bounded](FormatProperties.md#decl-e40ee371a7256cc2), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-09c456448c5633d0"></a>

<details>
<summary><code>TensorCore.decode16</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L28)

```lean
@[implicit_reducible] def decode16 (x : F16) : Option Decoded := (classify fp16 x).finite
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.F16](Defs.md#decl-7a3b8058d443c561), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.fp16](Defs.md#decl-2f0f377d9e2ae7dd)

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a4001029898e709f"></a>

<details>
<summary><code>TensorCore.decode32</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L29)

```lean
@[implicit_reducible] def decode32 (x : F32) : Option Decoded := (classify fp32 x).finite
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.classify](Encoding.md#decl-793c375a3325b7e3), [TensorCore.fp32](Defs.md#decl-1a6343dd8d7b7ab4)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.decode32Fields_asDecoded](../Kernels/EFT/Decode.md#decl-4aec02d9e6183f67), [TensorCore.EFMachine.decode32Fields_bounds](../Kernels/EFT/Decode.md#decl-b184c06b3493779e), [TensorCore.EFMachine.decode32Word_value](../Kernels/EFT/Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.value32_finite_exponent](../Kernels/EFT/Native.md#decl-5badba3cc64a61b4), [TensorCore.Finite32](Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.PaperSpec.rounds_iff](../TC/Specification/Rounding.md#decl-aec56cebf6fd4fd1), [TensorCore.PaperSpec.terms_eq](../TC/Specification/Stages.md#decl-f5a7848753cbc831), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.canonical_eta_floor_inactive](../TC/CanonicalFloor.md#decl-578fd56536970714), [TensorCore.decode32_below](../TC/MonotonicityRange.md#decl-a811310312b96b08), [TensorCore.decode32_eq](Encoding.md#decl-d61e64a2750bda68), [TensorCore.decode32_fields](RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.decode32_finite](EncodingProperties.md#decl-bb951033d1fed7f8), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.evalBlock_c](../TC/StageResiduals.md#decl-02be11fb27fe1a11), [TensorCore.evalPrepared_output](../TC/ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.finite32](Encoding.md#decl-82d0e30146423be5), [TensorCore.finite32_bits](../TC/Instruction.md#decl-08ec57f1c290b572), [TensorCore.finite32_of_value32](Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.finite32_self](../TC/Instruction.md#decl-4ce47d530733607b), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.monotoneInAccumulator_encoded](../TC/EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_encoded](../TC/Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_range_encoded](../TC/MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepare](../TC/Block.md#decl-32c2d7273540d876), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareInvocation_legacy](../TC/Compatibility.md#decl-be944aa91243ce64), [TensorCore.prepare_c](../TC/StageResiduals.md#decl-49dbce3f95e00cef), [TensorCore.prepare_fp16_products_metadata](../TC/Padding.md#decl-0b52caf572f15b9e), [TensorCore.prepare_fp16_term_metadata](../TC/Padding.md#decl-c6cfd5be70ed4ce2), [TensorCore.prepare_fp16_terms_lower](../TC/CanonicalFloor.md#decl-25e55191ad23626f), [TensorCore.prepare_profile](../TC/StageResiduals.md#decl-b234945333f4196c), [TensorCore.prepare_terms_bounded](../TC/AlignmentScale.md#decl-73a22edb6efb821c), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.runBlocks_chain](../TC/Composition.md#decl-4a9736f9c5dc068b), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.tf32_prepare](../TC/CanonicalFormats.md#decl-23c687067612f3ac), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4), [TensorCore.value32_finite](EncodingProperties.md#decl-a66b8320dd17a2c9), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.zero_value_bits](../TC/Instruction.md#decl-f684c66c118692c8), [TensorCore.finite32_none'](../TC/CanonicalFormats.md#decl-a30754227918210e), [TensorCore.finite32_some'](../TC/CanonicalFormats.md#decl-79bbcee75553afa7), [TensorCore.finite32_none](../TC/Compatibility.md#decl-0abe5f1171cc70cb), [TensorCore.finite32_some](../TC/Compatibility.md#decl-1818e0508a685ca4), [TensorCore.PaperSpec.zero_bits](../TC/Specification/Rounding.md#decl-6c7995fb8803ab3c)

</details>

</details>

<a id="decl-d61e64a2750bda68"></a>

<details>
<summary><code>TensorCore.decode32_eq</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L32)

```lean
/-- Width-free restatement used by the encoding proofs. -/
theorem decode32_eq (x : F32) : decode32 x = (classifyNat fp32 x.toNat).finite := rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification.finite](Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.classifyNat](Encoding.md#decl-52d401d7433cac5a), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.fp32](Defs.md#decl-1a6343dd8d7b7ab4)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.decode32_below](../TC/MonotonicityRange.md#decl-a811310312b96b08), [TensorCore.decode32_fields](RoundTrip.md#decl-b49162d7ac8baacf), [TensorCore.decode32_finite](EncodingProperties.md#decl-bb951033d1fed7f8), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56)

</details>

</details>

<a id="decl-72aed83a98321df4"></a>

<details>
<summary><code>TensorCore.value32</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L35)

```lean
/-- Numerical projection for encoded boundaries. Special encodings have no value. -/
def value32 (x : F32) : Option ℚ := (decode32 x).map Decoded.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.Components.scalar_correct](../Kernels/EFT/Scalar.md#decl-210c33f6f4d2a66b), [TensorCore.EFMachine.Word.exact32_value](../Kernels/EFT/Scalar.md#decl-dc352e235249ad4c), [TensorCore.EFMachine.add32WithLean_eq](../Kernels/EFT/Native.md#decl-606ce6330a627312), [TensorCore.EFMachine.add32_eq](../Kernels/EFT/Scalar.md#decl-098284e6074ca890), [TensorCore.EFMachine.algorithm1WithLean_correct](../Kernels/EFT/Native.md#decl-44b89c4eb1a452d1), [TensorCore.EFMachine.algorithm1WithLean_range_iff](../Kernels/EFT/Native.md#decl-8f27f77556b03c65), [TensorCore.EFMachine.algorithm1WithLean_success](../Kernels/EFT/Native.md#decl-f7716cfd3ea68d35), [TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_correct](../Kernels/EFT/Correctness.md#decl-ec47f9869483c5f4), [TensorCore.EFMachine.algorithm1_range_iff](../Kernels/EFT/Correctness.md#decl-c9a066d91dcbea2c), [TensorCore.EFMachine.algorithm1_success](../Kernels/EFT/Correctness.md#decl-56c6ead02b649bea), [TensorCore.EFMachine.algorithm1_unitInputs_success](../Kernels/EFT/Success.md#decl-5145abbc51875848), [TensorCore.EFMachine.decode32Word_value](../Kernels/EFT/Decode.md#decl-ba759822ef5052ce), [TensorCore.EFMachine.extraction_loop_bounds](../Kernels/EFT/Cost.md#decl-1274b05f6f0d58bd), [TensorCore.EFMachine.prepare_capacity](../Kernels/EFT/Preparation.md#decl-57c6f2c3bcad2604), [TensorCore.EFMachine.prepare_exists](../Kernels/EFT/Correctness.md#decl-437297c158395ecd), [TensorCore.EFMachine.prepare_spec](../Kernels/EFT/Preparation.md#decl-41c187a873ee477f), [TensorCore.EFMachine.value32_finite_exponent](../Kernels/EFT/Native.md#decl-5badba3cc64a61b4), [TensorCore.IEEE.LeanBridge.nativeFiniteAdd32_round](../Scalar/LeanFiniteAddition.md#decl-ee1136b3a2cc3036), [TensorCore.IEEE.LeanBridge.value32_nonzero](../Scalar/LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.MonotoneInEncodedAccumulator](../TC/EncodedMonotonicity.md#decl-2fe557d3c0f04019), [TensorCore.NearestEven32](RoundOp.md#decl-e8aa71a6813779de), [TensorCore.PaperSpec.Controls.ieeeAlignmentBits](../Tests/Specification/NegativeControls.md#decl-823e646d044e757f), [TensorCore.PaperSpec.round32_rounds](../TC/Specification/Rounding.md#decl-04c2440f27285826), [TensorCore.PaperSpec.rounds_unique](../TC/Specification/Rounding.md#decl-ca5813743de21e20), [TensorCore.PaperSpec.value32_eq](../TC/Specification/Rounding.md#decl-4158336941743c50), [TensorCore.Regression.encoded_v100_not_monotone](../Tests/EFT/EncodedEFT.md#decl-83fcbe1b52439ce7), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.encode32_value](EncodingProperties.md#decl-e3ab18687cdc8f56), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.finite32_of_value32](Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.fp32Add](ScalarSum.md#decl-c4f5ccdb5e5b9b02), [TensorCore.fp32Add_exact](ScalarSum.md#decl-91c0a32b3579d248), [TensorCore.monotoneInAccumulator_encoded](../TC/EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.output_residual_bound](RoundingError.md#decl-456564416e37d7c3), [TensorCore.representable32](ScalarSum.md#decl-8d15644ce94eb22f), [TensorCore.representable32_finite](ScalarSum.md#decl-04f29e613917ad68), [TensorCore.round32_exact_of_finite](ScalarSum.md#decl-372249100bf5e929), [TensorCore.round32_finite_exists](../TC/AcceptedDomain.md#decl-13c6e80f5f7e2f5a), [TensorCore.round32_nearestEven_correct](CorrectRounding.md#decl-213324c196c49312), [TensorCore.round32_nonzero_spec](CorrectRounding.md#decl-8b6b01a970bf7f64), [TensorCore.rtz_residual_lt](RoundingError.md#decl-ad79fb234a6a8f53), [TensorCore.signedRounded_rtz_of_finite](../TC/Flowback.md#decl-0e59d06cafb9cfda), [TensorCore.value32_finite](EncodingProperties.md#decl-a66b8320dd17a2c9), [TensorCore.value32_injective](RoundTrip.md#decl-c92b8ed7f76cc40c), [TensorCore.value32_round32](RoundTrip.md#decl-46fb757285084429), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.PaperSpec.zero_bits](../TC/Specification/Rounding.md#decl-6c7995fb8803ab3c)

</details>

</details>

<a id="decl-f23991ff7c5b3c3b"></a>

<details>
<summary><code>TensorCore.Finite32</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L37)

```lean
structure Finite32 where
  bits : F32
  decoded : Decoded
  valid : decode32 bits = some decoded
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace](../TC/Block.md#decl-6e6aa9836448ab93), [TensorCore.BlockTrace.defaultExtraction](../EFT/ExtractionGrid.md#decl-bf2bd98ffc3db444), [TensorCore.BlockTrace.extractionExponent](../EFT/Defs.md#decl-f4644e4a3c22871b), [TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.EFMachine.algorithm1_of_evalBlock](../Kernels/EFT/Refinement.md#decl-9aa1f0996a70d891), [TensorCore.EncodedChain](../TC/Composition.md#decl-ce41b49b9dd434c2), [TensorCore.Finite32.value](Encoding.md#decl-453b2816528e5c77), [TensorCore.InstructionPath.output](../TC/Instruction.md#decl-9187c2a117e2bdd6), [TensorCore.PaperSpec.Controls.all_zero_and_nonfinite_boundaries](../Tests/Specification/NegativeControls.md#decl-927ca5066fffe4ae), [TensorCore.PaperSpec.Controls.ampere_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-570be3c40e93b1c2), [TensorCore.PaperSpec.Controls.group_reversal_detected](../Tests/Specification/NegativeControls.md#decl-34343729ff830b30), [TensorCore.PaperSpec.Controls.hopper_floor_removal_detected](../Tests/Specification/NegativeControls.md#decl-5431b897ba61c21e), [TensorCore.PaperSpec.Controls.ieee_alignment_detected](../Tests/Specification/NegativeControls.md#decl-767d09c4aacc0efe), [TensorCore.PaperSpec.Controls.premature_normalization_detected](../Tests/Specification/NegativeControls.md#decl-6075ac4e18b56d7d), [TensorCore.PaperSpec.implementation_eq_paper](../TC/Specification/Equivalence.md#decl-944384931631e849), [TensorCore.PaperSpec.invocation_eq_paper](../TC/Specification/Supported.md#decl-b626b90584f7679d), [TensorCore.PaperSpec.machine_eq_paper](../TC/Specification/Equivalence.md#decl-a7b3c8171f0fe70d), [TensorCore.PaperSpec.result_iff_eval](../TC/Specification/Equivalence.md#decl-531002177af0522e), [TensorCore.PaperSpec.result_of_eval](../TC/Specification/Equivalence.md#decl-46e00e6d284d09a5), [TensorCore.PaperSpec.runBlocks_eq_paper](../TC/Specification/Composition.md#decl-eaffa3538905399a), [TensorCore.PaperSpec.schedule_last_eq_paper](../TC/Specification/Composition.md#decl-551846c5cac8f668), [TensorCore.PaperSpec.supported_eq_paper](../TC/Specification/Supported.md#decl-13a8bbc2350f91f1), [TensorCore.PaperSpec.supported_valid_success](../TC/Specification/Supported.md#decl-5894ca01e6458495), [TensorCore.PaperSpec.tf32_eq_paper](../TC/Specification/Supported.md#decl-89ffefd02d518c64), [TensorCore.PaperSpec.valid_success](../TC/Specification/Equivalence.md#decl-882143aa8462feae), [TensorCore.Regression.a100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-cdaa9fc7deac3fab), [TensorCore.Regression.broad_finite_unchecked_incorrect](../Tests/EFT/EFT.md#decl-cb45e79b5c259faf), [TensorCore.Regression.canonical_profile_results](../Tests/TC/Features.md#decl-3fccaf18bee4a287), [TensorCore.Regression.extra_alignment_bit_matters](../Tests/TC/Features.md#decl-2bd04552bd096078), [TensorCore.Regression.flowback_without_increase](../Tests/EFT/Flowback.md#decl-a4e884b9b60d7c4f), [TensorCore.Regression.h100_bf16_published_row](../Tests/TC/CanonicalFormats.md#decl-99837dca7e6541e3), [TensorCore.Regression.machine_width_changes_result](../Tests/TC/Features.md#decl-40bf2a8b421b9a65), [TensorCore.Regression.outputBits](../Tests/TC/Cases.md#decl-a837d7435701ef2b), [TensorCore.Regression.padding_range_boundary](../Tests/TC/Features.md#decl-bcc31661cab7eed7), [TensorCore.Regression.scalar64_corrects_midpoint](../Tests/EFT/ScalarEFT.md#decl-18ee9a4ee42888ea), [TensorCore.Regression.snapshot](../Tests/TC/Cases.md#decl-1cfadf5c18c42fc5), [TensorCore.Regression.tf32_published_rows](../Tests/TC/CanonicalFormats.md#decl-1e06fafbd32db00b), [TensorCore.Regression.tf32_row_compatible](../Tests/TC/CanonicalFormats.md#decl-c857f0b8ba84dbc8), [TensorCore.Regression.tf32_unpadded_rejected](../Tests/TC/CanonicalFormats.md#decl-18627a02cd9991c4), [TensorCore.Regression.twoBlockCorrection](../Tests/TC/Composition.md#decl-ce09e036dcdb2b94), [TensorCore.Regression.twoBlockSummary](../Tests/TC/Composition.md#decl-27d6915f955ce3fa), [TensorCore.Regression.v100_witness_flowback](../Tests/EFT/Flowback.md#decl-d132256d0746be26), [TensorCore.accumulator_eq_retained](../EFT/Extraction.md#decl-3d9c70abef819373), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.algorithm1Encoded_of_evalBlock](../EFT/Encoded.md#decl-a76734b92f5db6bb), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.bf16Fp32_invocation_compatible](../TC/CanonicalFormats.md#decl-1dce5cfd225912ec), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.canonical_padding_output](../TC/Padding.md#decl-2108e38788477de9), [TensorCore.canonical_source_padding_output](../TC/Padding.md#decl-5bdc8050550eb3f9), [TensorCore.correctedSchedule](../TC/Correction.md#decl-968ff850f4220ec9), [TensorCore.correctedSchedule_correct](../TC/Correction.md#decl-c5490d1a25901294), [TensorCore.encoded_trace_ledger](../TC/Composition.md#decl-775280e15ad44086), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_exact_alignment](../TC/ExactAlignment.md#decl-dc5077740e6bb58c), [TensorCore.evalBlock_success_iff](../TC/AcceptedDomain.md#decl-67304506aa3d182d), [TensorCore.evalPrepared](../TC/Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](../TC/Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](../TC/MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](../TC/StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output](../TC/ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.finite32](Encoding.md#decl-82d0e30146423be5), [TensorCore.finite32_bits](../TC/Instruction.md#decl-08ec57f1c290b572), [TensorCore.finite32_of_value32](Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.finite32_self](../TC/Instruction.md#decl-4ce47d530733607b), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.fp16Fp32_invocation_compatible](../TC/Canonical.md#decl-77d448deb0e063d7), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.lastOutput](../TC/Composition.md#decl-59a9e0884980f32b), [TensorCore.lastOutput_bits](../TC/Instruction.md#decl-922f2f0fa043267c), [TensorCore.legacy_invocation_bits](../TC/Compatibility.md#decl-c491cc679cfdf68a), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.overlap_window_width](../EFT/Algorithm1.md#decl-b8a661b7258cdacc), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareEncodedEFT](../EFT/Encoded.md#decl-aaaf1649ccd95844), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](../EFT/Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](../EFT/Encoded.md#decl-a3cbd61f8702b171), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.recoveredSchedule](../TC/Correction.md#decl-dd85a41a20883c51), [TensorCore.runBlocks](../TC/Composition.md#decl-d4b070b6697e01f0), [TensorCore.runBlocks_chain](../TC/Composition.md#decl-4a9736f9c5dc068b), [TensorCore.runBlocks_corrected_correct](../TC/Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_residual_ledger](../TC/Composition.md#decl-c73efd4921810886), [TensorCore.runBlocks_zero_groups](../TC/Instruction.md#decl-90841dab8cd37139), [TensorCore.single_group_output](../TC/Instruction.md#decl-7737e9081be84095), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.tf32_input_bits](../TC/CanonicalFormats.md#decl-7d4def66839cf159), [TensorCore.tf32_invocation_bits](../TC/CanonicalFormats.md#decl-28f5d0b989fbf9a1), [TensorCore.v100_invocation_bits](../TC/Compatibility.md#decl-eb86b04e40aea23d), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.finite32_none'](../TC/CanonicalFormats.md#decl-a30754227918210e), [TensorCore.finite32_some'](../TC/CanonicalFormats.md#decl-79bbcee75553afa7), [TensorCore.finite32_none](../TC/Compatibility.md#decl-0abe5f1171cc70cb), [TensorCore.finite32_some](../TC/Compatibility.md#decl-1818e0508a685ca4)

</details>

</details>

<a id="decl-82d0e30146423be5"></a>

<details>
<summary><code>TensorCore.finite32</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L43)

```lean
def finite32 (bits : F32) : Option Finite32 :=
  match h : decode32 bits with
  | none => none
  | some d => some ⟨bits, d, h⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f)

<details>
<summary>Used by</summary>

[TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.Regression.twoBlockCorrection](../Tests/TC/Composition.md#decl-ce09e036dcdb2b94), [TensorCore.algorithm1Encoded_bits_isSome_iff](../EFT/Encoded.md#decl-c1f2e040881102c8), [TensorCore.algorithm1Encoded_correct](../EFT/Encoded.md#decl-1519bb799ab513bc), [TensorCore.evalPrepared](../TC/Block.md#decl-700b85398ddd8f12), [TensorCore.evalPreparedMachine](../TC/Accumulator.md#decl-0c49fa80fec5d50f), [TensorCore.evalPreparedMachine_eq](../TC/MachineRefinement.md#decl-d2f2aa91376a054f), [TensorCore.evalPrepared_block](../TC/StageResiduals.md#decl-9203b66f7c8059ba), [TensorCore.evalPrepared_output](../TC/ErrorBounds.md#decl-48e730a73a284cc0), [TensorCore.evalPrepared_total](../TC/AcceptedDomain.md#decl-23e3d05f63684e0c), [TensorCore.finite32_bits](../TC/Instruction.md#decl-08ec57f1c290b572), [TensorCore.finite32_of_value32](Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.finite32_self](../TC/Instruction.md#decl-4ce47d530733607b), [TensorCore.legacy_prepared_bits](../TC/Compatibility.md#decl-50d76905479abf5e), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.padded_prepared_bits](../TC/CanonicalFormats.md#decl-fd4c999fedb8fba6), [TensorCore.prepareEncodedEFT](../EFT/Encoded.md#decl-aaaf1649ccd95844), [TensorCore.prepareEncodedEFT_of_evalBlock](../EFT/Encoded.md#decl-fc4f7a305fbbcda5), [TensorCore.prepareEncodedEFT_spec](../EFT/Encoded.md#decl-926dcc55d35ecae9), [TensorCore.prepareEncodedEFT_success_iff](../EFT/Encoded.md#decl-a3cbd61f8702b171), [TensorCore.runBlocks_zero_groups](../TC/Instruction.md#decl-90841dab8cd37139), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3), [TensorCore.finite32_none'](../TC/CanonicalFormats.md#decl-a30754227918210e), [TensorCore.finite32_some'](../TC/CanonicalFormats.md#decl-79bbcee75553afa7), [TensorCore.finite32_none](../TC/Compatibility.md#decl-0abe5f1171cc70cb), [TensorCore.finite32_some](../TC/Compatibility.md#decl-1818e0508a685ca4)

</details>

</details>

<a id="decl-453b2816528e5c77"></a>

<details>
<summary><code>TensorCore.Finite32.value</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L48)

```lean
def Finite32.value (x : Finite32) : ℚ := x.decoded.value
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.Finite32](Encoding.md#decl-f23991ff7c5b3c3b)

<details>
<summary>Used by</summary>

[TensorCore.BlockTrace.exactConsolidation](../EFT/Algorithm1.md#decl-2c3184ccfe7b5745), [TensorCore.BlockTrace.outputResidual](../TC/Block.md#decl-d1c97ba3515d5cad), [TensorCore.BlockTrace.overlap](../EFT/Defs.md#decl-194a0aec6d268873), [TensorCore.BlockTrace.recovered](../TC/Block.md#decl-3d1b2fa71193a56d), [TensorCore.BlockTrace.residual](../TC/Block.md#decl-29503c8290420b97), [TensorCore.BlockTrace.scalarChecks](../EFT/Extraction.md#decl-8c775638dbe095dd), [TensorCore.BlockTrace.scalarCorrectedInUnchecked](../EFT/Scalar.md#decl-a22da99ec6e9edd7), [TensorCore.BlockTrace.scalarCorrectedUnchecked](../EFT/Extraction.md#decl-b298427558415577), [TensorCore.BlockTrace.scalarPredicate](../EFT/Extraction.md#decl-8144db00332cc0f8), [TensorCore.BlockTrace.scalarPredicateIn](../EFT/Scalar.md#decl-41be156bbdd880fc), [TensorCore.EFMachine.algorithm1_agrees](../Kernels/EFT/Refinement.md#decl-98c4f9688b4f1890), [TensorCore.ExtractionGrid.eq20_scalarPredicate](../EFT/ExtractionGrid.md#decl-d4904f8d22c84319), [TensorCore.ExtractionGrid.overlap](../EFT/ExtractionGrid.md#decl-83babfaeb37f9950), [TensorCore.ExtractionGrid.overlap_eq_retained_sub_outputResidual](../EFT/ExtractionGrid.md#decl-f08a58a2cdf1dea5), [TensorCore.ExtractionGrid.recovery](../EFT/ExtractionGrid.md#decl-7c36a09e78670e2b), [TensorCore.ExtractionGrid.scalarCorrectedUnchecked](../EFT/ExtractionGrid.md#decl-c30f6fdadcf7a711), [TensorCore.ExtractionGrid.scalarCorrected_correct](../EFT/ExtractionGrid.md#decl-b71ff86835e7406b), [TensorCore.ExtractionGrid.scalarCorrected_eq](../EFT/ExtractionGrid.md#decl-f8de0b017f5795de), [TensorCore.ExtractionGrid.scalarPredicate](../EFT/ExtractionGrid.md#decl-555af608d3c6bc2a), [TensorCore.MonotoneInAccumulator](../TC/Flowback.md#decl-bb2cbdd4e98d833c), [TensorCore.Regression.twoBlockSummary](../Tests/TC/Composition.md#decl-27d6915f955ce3fa), [TensorCore.algorithm1_bits_isSome_iff](../EFT/Algorithm1.md#decl-d32d1a35b91d3f50), [TensorCore.ampere_machineAccumulator](../TC/Canonical.md#decl-4e3007238613f1c9), [TensorCore.bf16Fp32_contract](../TC/CanonicalFormats.md#decl-4621731027a9a137), [TensorCore.block_error_bound](../TC/ErrorBounds.md#decl-06d7afabcf00fa63), [TensorCore.construction_not_monotone](../TC/Flowback.md#decl-804334e6bcfbdb8f), [TensorCore.correctedSchedule_correct](../TC/Correction.md#decl-c5490d1a25901294), [TensorCore.encodedBlockValue](../TC/EncodedMonotonicity.md#decl-8001d30e1d0c2ed8), [TensorCore.encoded_trace_ledger](../TC/Composition.md#decl-775280e15ad44086), [TensorCore.evalBlock_error_bound](../TC/ErrorBounds.md#decl-cd49461242c6068b), [TensorCore.evalBlock_residual_identity](../TC/StageResiduals.md#decl-f7335275dbf94126), [TensorCore.evalPrepared_error_bound](../TC/ErrorBounds.md#decl-6a51cec1858cd298), [TensorCore.evalPrepared_output_value](../TC/Flowback.md#decl-17953b6216d0cce0), [TensorCore.exactConsolidation_eq_corrected](../EFT/Algorithm1.md#decl-c3b8d88d2995c695), [TensorCore.finite32_of_value32](Encoding.md#decl-e85cafbe6e246ed5), [TensorCore.flowback_necessary](../TC/Flowback.md#decl-8f48db3103211d06), [TensorCore.flowback_sufficient](../TC/Flowback.md#decl-b0715c384a285eb0), [TensorCore.fp16Fp32_contract](../TC/Canonical.md#decl-cf62ece4228e9418), [TensorCore.hopper_machineAccumulator](../TC/Canonical.md#decl-06a8e4120caf10df), [TensorCore.monotoneInAccumulator_encoded](../TC/EncodedMonotonicity.md#decl-9eb0a74d8892c998), [TensorCore.nonmonotone_ampere_family](../Tests/TC/Monotonicity.md#decl-35f26035cb0e19a5), [TensorCore.nonmonotone_encoded](../TC/Monotonicity.md#decl-7c6c5b1d9751b04f), [TensorCore.nonmonotone_hopper_family](../Tests/TC/Monotonicity.md#decl-e74e75c57aaf1e71), [TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4), [TensorCore.nonmonotone_range_ampere_family](../Tests/TC/Monotonicity.md#decl-8cba369caaf2fd69), [TensorCore.nonmonotone_range_encoded](../TC/MonotonicityRange.md#decl-25e9827b84766b38), [TensorCore.nonmonotone_range_hopper_family](../Tests/TC/Monotonicity.md#decl-35b986b32bcab844), [TensorCore.nonmonotone_range_v100_family](../Tests/TC/Monotonicity.md#decl-28d0c042c0f25900), [TensorCore.nonmonotone_v100_family](../Tests/TC/Monotonicity.md#decl-06e754610d570873), [TensorCore.output_condition](../TC/Flowback.md#decl-5dca5d0c5f0f3b03), [TensorCore.overlap_eq_retained_sub_outputResidual](../EFT/Extraction.md#decl-fc2dcdeff262fd49), [TensorCore.overlap_recovery](../EFT/Extraction.md#decl-9a70c4b963b9ff7e), [TensorCore.profile_contract](../TC/CanonicalFormats.md#decl-ccfc8f82aa7974cb), [TensorCore.recoveredSchedule](../TC/Correction.md#decl-dd85a41a20883c51), [TensorCore.recovered_eq_exactDot](../TC/StageResiduals.md#decl-8de6ec1e79d4f44f), [TensorCore.retained_add_low](../EFT/Extraction.md#decl-da77fbfd62ee1185), [TensorCore.returned_residual_identity](../TC/StageResiduals.md#decl-51c1f1398611023e), [TensorCore.runBlocks_corrected_correct](../TC/Correction.md#decl-5c2f929f60e023e5), [TensorCore.runBlocks_residual_ledger](../TC/Composition.md#decl-c73efd4921810886), [TensorCore.scalarChecks_all](../EFT/Extraction.md#decl-6e6d55a04a30d907), [TensorCore.scalarCorrectedInUnchecked_eq](../EFT/Scalar.md#decl-ced7339afa66e1f2), [TensorCore.scalarCorrectedInUnchecked_fp32](../EFT/Scalar.md#decl-b8105d432e4f8983), [TensorCore.scalarCorrectedIn_correct](../EFT/Scalar.md#decl-339eec1a25f718e9), [TensorCore.scalarCorrectedUnchecked_eq](../EFT/Extraction.md#decl-421b3488061da23d), [TensorCore.scalarCorrected_correct](../EFT/Extraction.md#decl-57f834dbd8f945de), [TensorCore.scalarOverlap_exact](../EFT/Scalar.md#decl-56c2b8a041adc97f), [TensorCore.scalarPredicate_implies_in_fp32](../EFT/Scalar.md#decl-f553bd8760a2c5c4), [TensorCore.tf19Fp32_contract](../TC/CanonicalFormats.md#decl-7fb4e742a5f73478), [TensorCore.zero_products_passthrough](../TC/Instruction.md#decl-882b366cdb8ff9e3)

</details>

</details>

<a id="decl-e85cafbe6e246ed5"></a>

<details>
<summary><code>TensorCore.finite32_of_value32</code></summary>

[Lean source](../../../TensorCore/Numerics/Encoding.lean#L50)

```lean
theorem finite32_of_value32 (b : F32) (v : ℚ) (h : value32 b = some v) :
    ∃ f : Finite32, finite32 b = some f ∧ f.bits = b ∧ f.value = v := by
  unfold value32 at h
  cases hd : decode32 b with
  | none => simp [hd] at h
  | some d =>
    simp only [hd, Option.map_some, Option.some.injEq] at h
    refine ⟨⟨b, d, hd⟩, ?_, rfl, h⟩
    unfold finite32
    split
    · rename_i h'; rw [hd] at h'; contradiction
    · rename_i d' h'; rw [hd] at h'; cases Option.some.inj h'; rfl
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Decoded](Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](Defs.md#decl-c988858af545448a), [TensorCore.F32](Defs.md#decl-24fa1e63edeb271f), [TensorCore.Finite32](Encoding.md#decl-f23991ff7c5b3c3b), [TensorCore.Finite32.value](Encoding.md#decl-453b2816528e5c77), [TensorCore.decode32](Encoding.md#decl-a4001029898e709f), [TensorCore.finite32](Encoding.md#decl-82d0e30146423be5), [TensorCore.value32](Encoding.md#decl-72aed83a98321df4)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.nonmonotone_perturbation](../TC/Monotonicity.md#decl-c02a591e005269f1), [TensorCore.nonmonotone_range](../TC/MonotonicityRange.md#decl-d5c8fadfda678cb4)

</details>

</details>
