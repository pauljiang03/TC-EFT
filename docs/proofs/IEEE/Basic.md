# TensorCore.IEEE.Basic

[Index](../README.md)

Expand a declaration to read its Lean code, then follow the links to its dependencies.

<a id="decl-d560501f21a28c67"></a>

<details>
<summary><code>TensorCore.IEEE.BinaryFormat</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L9)

```lean
inductive BinaryFormat where
  | binary16 | binary32 | binary64
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.Cli.IEEE.format](../Cli/IEEE.md#decl-bed3fc591f28b9f9), [TensorCore.Cli.IEEE.word](../Cli/IEEE.md#decl-25ed82ecf72c63cc), [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.encodeZero32_eq](LeanBridge.md#decl-98d0f6338db37912), [TensorCore.IEEE.LeanBridge.encodeZero64_eq](LeanBridge64.md#decl-9db9d280d3c864b3), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.LeanBridge.native_nan_payload_differs](Tests/NativeRegression.md#decl-0ba4789c10c4d857), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.packZero32_eq](LeanBridge.md#decl-884838ead8d1b1ab), [TensorCore.IEEE.LeanBridge.packZero64_eq](LeanBridge64.md#decl-25839643d33202cf), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Regression.directed_overflow](Tests/Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.fused_single_rounding](Tests/Regression.md#decl-7b5a3ce3bbe533ba), [TensorCore.IEEE.Regression.fused_without_intermediate_overflow](Tests/Regression.md#decl-3089d50d2664c88b), [TensorCore.IEEE.Regression.fused_zero_sign](Tests/Regression.md#decl-a4e45279d595ebe5), [TensorCore.IEEE.Regression.gradual_underflow](Tests/Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.nan_payload_conversion](Tests/Regression.md#decl-c125c286409c41d9), [TensorCore.IEEE.Regression.near_overflow](Tests/Regression.md#decl-c37522c37f5d3371), [TensorCore.IEEE.Regression.nonfinite_and_payload](Tests/Regression.md#decl-3e3bfb1038fb1ac0), [TensorCore.IEEE.Regression.normal_output_underflow](Tests/Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.sticky_flags](Tests/Regression.md#decl-6f46397e23c85174), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.Regression.zero_signs](Tests/Regression.md#decl-c69dca8aa8f614cd), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Result.accumulate](Basic.md#decl-e2a38f7ec363b4bf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_correct](NativeOperations.md#decl-1d95790ca0574f94), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.addWithLean_native](NativeOperations.md#decl-fd6a11fc2eaba885), [TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.convertPayload_bounded](Compatibility.md#decl-78bff6c53f7ce3d2), [TensorCore.IEEE.convertPayload_roundtrip](Compatibility.md#decl-9386b7dd0de650fe), [TensorCore.IEEE.convert_correct](Specification.md#decl-b4246bf9e7d785bb), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_infinity](Basic.md#decl-a61646dd7f66db74), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.decode_zero](Basic.md#decl-42224d8ca5e35406), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.maxFiniteWord_sign](Basic.md#decl-ca049339b8b107f4), [TensorCore.IEEE.maxFiniteWord_value](Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.maxFinite_positive](Basic.md#decl-33b32196fb355d13), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_correct](NativeOperations.md#decl-67cfb7377bb37ad8), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mulWithLean_native](NativeOperations.md#decl-fbd7d0b915acb4bd), [TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.subWithLean_native](NativeOperations.md#decl-7f93d5f56de6f401), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.IEEE.zero_sign](Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](Basic.md#decl-42575e26b6696b19)

</details>

</details>

<a id="decl-a8e62c5be0ff5328"></a>

<details>
<summary><code>TensorCore.IEEE.BinaryFormat.layout</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L13)

```lean
def BinaryFormat.layout : BinaryFormat → Format
  | .binary16 => fp16
  | .binary32 => fp32
  | .binary64 => fp64
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.fp16](../Core/Defs.md#decl-2f0f377d9e2ae7dd), [TensorCore.fp32](../Core/Defs.md#decl-1a6343dd8d7b7ab4), [TensorCore.fp64](../Core/Defs.md#decl-a9439171a8dcf9cb)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.Cli.IEEE.word](../Cli/IEEE.md#decl-25ed82ecf72c63cc), [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.LeanBridge.native_nan_payload_differs](Tests/NativeRegression.md#decl-0ba4789c10c4d857), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.Regression.directed_overflow](Tests/Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.fused_single_rounding](Tests/Regression.md#decl-7b5a3ce3bbe533ba), [TensorCore.IEEE.Regression.fused_without_intermediate_overflow](Tests/Regression.md#decl-3089d50d2664c88b), [TensorCore.IEEE.Regression.fused_zero_sign](Tests/Regression.md#decl-a4e45279d595ebe5), [TensorCore.IEEE.Regression.gradual_underflow](Tests/Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.nan_payload_conversion](Tests/Regression.md#decl-c125c286409c41d9), [TensorCore.IEEE.Regression.near_overflow](Tests/Regression.md#decl-c37522c37f5d3371), [TensorCore.IEEE.Regression.nonfinite_and_payload](Tests/Regression.md#decl-3e3bfb1038fb1ac0), [TensorCore.IEEE.Regression.normal_output_underflow](Tests/Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.Regression.zero_signs](Tests/Regression.md#decl-c69dca8aa8f614cd), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.convertPayload](Operations.md#decl-e35efe8a503f3ae3), [TensorCore.IEEE.convertPayload_bounded](Compatibility.md#decl-78bff6c53f7ce3d2), [TensorCore.IEEE.convertPayload_roundtrip](Compatibility.md#decl-9386b7dd0de650fe), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.maxFiniteWord_value](Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.maxFinite_positive](Basic.md#decl-33b32196fb355d13), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.IEEE.zero_sign](Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](Basic.md#decl-42575e26b6696b19)

</details>

</details>

<a id="decl-bb1825a12b957cb8"></a>

<details>
<summary><code>TensorCore.IEEE.BinaryFormat.valid</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L18)

```lean
theorem BinaryFormat.valid (f : BinaryFormat) : f.layout.WellFormed := by
  cases f <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.WellFormed](../Core/Defs.md#decl-2c4f4aa8dae0f1d6), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.maxFiniteWord_value](Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.IEEE.zero_sign](Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](Basic.md#decl-42575e26b6696b19)

</details>

</details>

<a id="decl-b814ad4fc9e848f5"></a>

<details>
<summary><code>TensorCore.IEEE.Word</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L21)

```lean
abbrev Word (f : BinaryFormat) := BitVec f.layout.width
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.Cli.IEEE.word](../Cli/IEEE.md#decl-25ed82ecf72c63cc), [TensorCore.IEEE.LeanBridge.finiteBits32_encode](LeanBridge.md#decl-d657870ed44b83fa), [TensorCore.IEEE.LeanBridge.finiteBits64_encode](LeanBridge64.md#decl-6e29d2958e392228), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.LeanBridge.native_nan_payload_differs](Tests/NativeRegression.md#decl-0ba4789c10c4d857), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.Regression.directed_overflow](Tests/Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.fused_single_rounding](Tests/Regression.md#decl-7b5a3ce3bbe533ba), [TensorCore.IEEE.Regression.fused_without_intermediate_overflow](Tests/Regression.md#decl-3089d50d2664c88b), [TensorCore.IEEE.Regression.fused_zero_sign](Tests/Regression.md#decl-a4e45279d595ebe5), [TensorCore.IEEE.Regression.gradual_underflow](Tests/Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.nan_payload_conversion](Tests/Regression.md#decl-c125c286409c41d9), [TensorCore.IEEE.Regression.near_overflow](Tests/Regression.md#decl-c37522c37f5d3371), [TensorCore.IEEE.Regression.nonfinite_and_payload](Tests/Regression.md#decl-3e3bfb1038fb1ac0), [TensorCore.IEEE.Regression.normal_output_underflow](Tests/Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.Regression.zero_signs](Tests/Regression.md#decl-c69dca8aa8f614cd), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_correct](NativeOperations.md#decl-1d95790ca0574f94), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convert_correct](Specification.md#decl-b4246bf9e7d785bb), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.finiteBits](Rounding.md#decl-1cdd013ea2ce0dce), [TensorCore.IEEE.finiteBits_correct](Rounding.md#decl-95af8d895fd749ac), [TensorCore.IEEE.finiteBits_eq](Rounding.md#decl-00e71abfcdfd8abb), [TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_correct](NativeOperations.md#decl-67cfb7377bb37ad8), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419)

</details>

</details>

<a id="decl-f3f376a13829bc9f"></a>

<details>
<summary><code>TensorCore.IEEE.sign</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L23)

```lean
def sign (f : BinaryFormat) (b : Word f) : Bool := binarySign f.layout b
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.binarySign](../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.maxFiniteWord_sign](Basic.md#decl-ca049339b8b107f4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.zero_sign](Basic.md#decl-a55f8f28a95986bc)

</details>

</details>

<a id="decl-8e1c4a10ad1ad419"></a>

<details>
<summary><code>TensorCore.IEEE.zero</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L25)

```lean
def zero (f : BinaryFormat) (negative : Bool) : Word f :=
  (BinaryRep.zero f.layout f.valid negative).encode
```

**Supporting proofs:** [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8)

**Definitions and types:** [TensorCore.BinaryRep.encode](../Core/Binary/Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.zero](../Core/Binary/SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.encodeZero32_eq](LeanBridge.md#decl-98d0f6338db37912), [TensorCore.IEEE.LeanBridge.encodeZero64_eq](LeanBridge64.md#decl-9db9d280d3c864b3), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_eq](LeanBridge.md#decl-e787875815969d2e), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_eq](LeanBridge64.md#decl-0c708a8abb7275bb), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.packZero32_eq](LeanBridge.md#decl-884838ead8d1b1ab), [TensorCore.IEEE.LeanBridge.packZero64_eq](LeanBridge64.md#decl-25839643d33202cf), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode_zero](Basic.md#decl-42224d8ca5e35406), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.zero_sign](Basic.md#decl-a55f8f28a95986bc), [TensorCore.IEEE.zero_value](Basic.md#decl-42575e26b6696b19)

</details>

</details>

<a id="decl-6135d610bb0efb93"></a>

<details>
<summary><code>TensorCore.IEEE.infinity</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L28)

```lean
def infinity (f : BinaryFormat) (negative : Bool) : Word f :=
  BitVec.ofNat _ ((if negative then 2 ^ (f.layout.fractionBits + f.layout.exponentBits) else 0) +
    (2 ^ f.layout.exponentBits - 1) * 2 ^ f.layout.fractionBits)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode_infinity](Basic.md#decl-a61646dd7f66db74), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-7fc4ab022f9af5d1"></a>

<details>
<summary><code>TensorCore.IEEE.quietBit</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L32)

```lean
def quietBit (f : BinaryFormat) : ℕ := 2 ^ (f.layout.fractionBits - 1)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convertPayload_bounded](Compatibility.md#decl-78bff6c53f7ce3d2), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b)

</details>

</details>

<a id="decl-3fa748041e6ba03e"></a>

<details>
<summary><code>TensorCore.IEEE.nan</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L34)

```lean
def nan (f : BinaryFormat) (negative : Bool) (payload : ℕ) : Word f :=
  BitVec.ofNat _ ((infinity f negative).toNat + quietBit f + payload % quietBit f)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e)

</details>

</details>

<a id="decl-6ddaa725b7fd2551"></a>

<details>
<summary><code>TensorCore.IEEE.maxFiniteWord</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L37)

```lean
def maxFiniteWord (f : BinaryFormat) (negative : Bool) : Word f :=
  encodeBinary f.layout negative f.layout.emax ((2 ^ (f.layout.fractionBits + 1) - 1 : ℕ) : ℤ)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.maxFiniteWord_sign](Basic.md#decl-ca049339b8b107f4), [TensorCore.IEEE.maxFiniteWord_value](Basic.md#decl-798b937fdff5abb2), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-85a736cf96780149"></a>

<details>
<summary><code>TensorCore.IEEE.Datum</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L40)

```lean
inductive Datum where
  | finite (negative : Bool) (value : ℚ)
  | infinity (negative : Bool)
  | nan (negative : Bool) (signaling : Bool) (payload : ℕ)
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.Datum.isInfinite](Basic.md#decl-850c48dc8c3c08ec), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33), [TensorCore.IEEE.Datum.isSignaling](Basic.md#decl-bb70a4a9636bee68), [TensorCore.IEEE.Datum.isZero](Basic.md#decl-27e8c7bd0f45da0e), [TensorCore.IEEE.Datum.nanInfo](Operations.md#decl-4731f592ede9f980), [TensorCore.IEEE.Datum.negate](Basic.md#decl-3b85b36e89bf5a7b), [TensorCore.IEEE.Datum.negative](Basic.md#decl-75faab7c3bc85104), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.chooseNaN](Operations.md#decl-6747b80965c25567), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_infinity](Basic.md#decl-a61646dd7f66db74), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.decode_zero](Basic.md#decl-42224d8ca5e35406), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidProduct](Operations.md#decl-b2f471fe29e20659), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-2beaccf900e5635c"></a>

<details>
<summary><code>TensorCore.IEEE.decode</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L46)

```lean
def decode (f : BinaryFormat) (b : Word f) : Datum :=
  match classify f.layout b with
  | .zero _ => .finite (sign f b) 0
  | .subnormal d | .normal d => .finite (sign f b) d.value
  | .infinity s => .infinity s
  | .nan => .nan (sign f b)
      (decide (b.toNat % 2 ^ f.layout.fractionBits < quietBit f)) (b.toNat % quietBit f)
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.LeanBridge.decode32_nonzero](LeanBridge.md#decl-3b4b402af08ad974), [TensorCore.IEEE.LeanBridge.decode64_nonzero](LeanBridge64.md#decl-67377a612a0cb18b), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addWithLean_correct](NativeOperations.md#decl-1d95790ca0574f94), [TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_correct](Specification.md#decl-b4246bf9e7d785bb), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.decode_finite_iff](Basic.md#decl-e921ec9072a7db34), [TensorCore.IEEE.decode_infinity](Basic.md#decl-a61646dd7f66db74), [TensorCore.IEEE.decode_nan](Basic.md#decl-4f5c3082603585a7), [TensorCore.IEEE.decode_zero](Basic.md#decl-42224d8ca5e35406), [TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulWithLean_correct](NativeOperations.md#decl-67cfb7377bb37ad8), [TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229)

</details>

</details>

<a id="decl-b46cd1a1098bad33"></a>

<details>
<summary><code>TensorCore.IEEE.Datum.isNaN</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L54)

```lean
def Datum.isNaN : Datum → Bool
  | .nan .. => true
  | _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.Datum.isSignaling](Basic.md#decl-bb70a4a9636bee68), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2)

</details>

</details>

<a id="decl-bb70a4a9636bee68"></a>

<details>
<summary><code>TensorCore.IEEE.Datum.isSignaling</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L58)

```lean
def Datum.isSignaling : Datum → Bool
  | .nan _ s _ => s
  | _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Datum.isNaN](Basic.md#decl-b46cd1a1098bad33)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b)

</details>

</details>

<a id="decl-27e8c7bd0f45da0e"></a>

<details>
<summary><code>TensorCore.IEEE.Datum.isZero</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L62)

```lean
def Datum.isZero : Datum → Bool
  | .finite _ x => decide (x = 0)
  | _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.invalidProduct](Operations.md#decl-b2f471fe29e20659)

</details>

</details>

<a id="decl-850c48dc8c3c08ec"></a>

<details>
<summary><code>TensorCore.IEEE.Datum.isInfinite</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L66)

```lean
def Datum.isInfinite : Datum → Bool
  | .infinity _ => true
  | _ => false
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.invalidProduct](Operations.md#decl-b2f471fe29e20659)

</details>

</details>

<a id="decl-75faab7c3bc85104"></a>

<details>
<summary><code>TensorCore.IEEE.Datum.negative</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L70)

```lean
def Datum.negative : Datum → Bool
  | .finite s _ | .infinity s | .nan s _ _ => s
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954)

</details>

</details>

<a id="decl-3b85b36e89bf5a7b"></a>

<details>
<summary><code>TensorCore.IEEE.Datum.negate</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L73)

```lean
def Datum.negate : Datum → Datum
  | .finite s x => .finite (!s) (-x)
  | .infinity s => .infinity (!s)
  | .nan s sig p => .nan s sig p
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229)

</details>

</details>

<a id="decl-7fb0da58f8de59d1"></a>

<details>
<summary><code>TensorCore.IEEE.Flags</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L78)

```lean
structure Flags where
  invalid : Bool := false
  divideByZero : Bool := false
  overflow : Bool := false
  underflow : Bool := false
  inexact : Bool := false
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.Cli.IEEE.flagsJson](../Cli/IEEE.md#decl-71feae66200bd421), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.Flags.union](Basic.md#decl-82ff2b8736176866), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Regression.directed_overflow](Tests/Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.fused_single_rounding](Tests/Regression.md#decl-7b5a3ce3bbe533ba), [TensorCore.IEEE.Regression.fused_without_intermediate_overflow](Tests/Regression.md#decl-3089d50d2664c88b), [TensorCore.IEEE.Regression.fused_zero_sign](Tests/Regression.md#decl-a4e45279d595ebe5), [TensorCore.IEEE.Regression.gradual_underflow](Tests/Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.nan_payload_conversion](Tests/Regression.md#decl-c125c286409c41d9), [TensorCore.IEEE.Regression.near_overflow](Tests/Regression.md#decl-c37522c37f5d3371), [TensorCore.IEEE.Regression.nonfinite_and_payload](Tests/Regression.md#decl-3e3bfb1038fb1ac0), [TensorCore.IEEE.Regression.normal_output_underflow](Tests/Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.sticky_flags](Tests/Regression.md#decl-6f46397e23c85174), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.Regression.zero_signs](Tests/Regression.md#decl-c69dca8aa8f614cd), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf), [TensorCore.IEEE.Result.accumulate](Basic.md#decl-e2a38f7ec363b4bf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.flags_union_assoc](Basic.md#decl-ee9f3332f5eae317), [TensorCore.IEEE.flags_union_self](Basic.md#decl-73685b744f8d3380), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1)

</details>

</details>

<a id="decl-82ff2b8736176866"></a>

<details>
<summary><code>TensorCore.IEEE.Flags.union</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L86)

```lean
def Flags.union (a b : Flags) : Flags :=
  ⟨a.invalid || b.invalid, a.divideByZero || b.divideByZero,
   a.overflow || b.overflow, a.underflow || b.underflow, a.inexact || b.inexact⟩
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.Result.accumulate](Basic.md#decl-e2a38f7ec363b4bf), [TensorCore.IEEE.flags_union_assoc](Basic.md#decl-ee9f3332f5eae317), [TensorCore.IEEE.flags_union_self](Basic.md#decl-73685b744f8d3380)

</details>

</details>

<a id="decl-8c2ee485764d7350"></a>

<details>
<summary><code>TensorCore.IEEE.Tininess</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L90)

```lean
inductive Tininess where
  | beforeRounding | afterRounding
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** None in this repository.

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.Cli.IEEE.tininess](../Cli/IEEE.md#decl-d5178f5c3b0be28a), [TensorCore.IEEE.Context](Basic.md#decl-72d4c54af38e23b8), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.LeanBridge.native_nan_payload_differs](Tests/NativeRegression.md#decl-0ba4789c10c4d857), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.Regression.rd](Tests/Regression.md#decl-881e982d251120cb), [TensorCore.IEEE.Regression.rn](Tests/Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Regression.ru](Tests/Regression.md#decl-5771e8ec4435398b), [TensorCore.IEEE.Regression.rz](Tests/Regression.md#decl-8c8fb3d8f0c7300e), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212)

</details>

</details>

<a id="decl-72d4c54af38e23b8"></a>

<details>
<summary><code>TensorCore.IEEE.Context</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L94)

```lean
structure Context where
  mode : BinaryRoundingMode := .nearestEven
  tininess : Tininess := .afterRounding
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.BinaryRoundingMode](../Core/Binary/RoundOp.md#decl-00a7255be9b19e5a), [TensorCore.IEEE.Tininess](Basic.md#decl-8c2ee485764d7350)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.LeanBridge.native_nan_payload_differs](Tests/NativeRegression.md#decl-0ba4789c10c4d857), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.Regression.rd](Tests/Regression.md#decl-881e982d251120cb), [TensorCore.IEEE.Regression.rn](Tests/Regression.md#decl-e5e12c7f2e5ab943), [TensorCore.IEEE.Regression.ru](Tests/Regression.md#decl-5771e8ec4435398b), [TensorCore.IEEE.Regression.rz](Tests/Regression.md#decl-8c8fb3d8f0c7300e), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_correct](NativeOperations.md#decl-1d95790ca0574f94), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.addWithLean_native](NativeOperations.md#decl-fd6a11fc2eaba885), [TensorCore.IEEE.add_correct](Specification.md#decl-919fdc4a27c1c36c), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_correct](Specification.md#decl-b4246bf9e7d785bb), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.fma_correct](Specification.md#decl-dda77d4975712ce3), [TensorCore.IEEE.fma_finite_contract](Compatibility.md#decl-bf169c1fd8f96954), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_correct](NativeOperations.md#decl-67cfb7377bb37ad8), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mulWithLean_native](NativeOperations.md#decl-fbd7d0b915acb4bd), [TensorCore.IEEE.mul_correct](Specification.md#decl-e6f4b1f0809e4557), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.subWithLean_native](NativeOperations.md#decl-7f93d5f56de6f401), [TensorCore.IEEE.sub_correct](Specification.md#decl-442d19c4ff74e229), [TensorCore.IEEE.tiny](Rounding.md#decl-33fe2598430cb212)

</details>

</details>

<a id="decl-24fb6631bfd8efcf"></a>

<details>
<summary><code>TensorCore.IEEE.Result</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L99)

```lean
structure Result (f : BinaryFormat) where
  bits : Word f
  flags : Flags := {}
  deriving Repr, DecidableEq
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5)

<details>
<summary>Used by</summary>

[TensorCore.Cli.IEEE.evaluate](../Cli/IEEE.md#decl-33c9f4f09ea726b5), [TensorCore.IEEE.AddSpec](Specification.md#decl-03d998fb20725223), [TensorCore.IEEE.ConvertSpec](Specification.md#decl-e9f80536d82b3d98), [TensorCore.IEEE.FmaSpec](Specification.md#decl-25cf556b40ff39bc), [TensorCore.IEEE.InfinitySpec](Specification.md#decl-f0f3666a2c4cb86b), [TensorCore.IEEE.InvalidSpec](Specification.md#decl-50a2ffd22287e912), [TensorCore.IEEE.LeanBridge.native64_add_overflow_fallback](Tests/NativeRegression.md#decl-264a03a8124d39b4), [TensorCore.IEEE.LeanBridge.native64_add_tie_even](Tests/NativeRegression.md#decl-4e76972a36eefeed), [TensorCore.IEEE.LeanBridge.native64_add_tie_odd](Tests/NativeRegression.md#decl-509dda658fbaa14b), [TensorCore.IEEE.LeanBridge.native64_mul_half_min_subnormal](Tests/NativeRegression.md#decl-18c5a84da5d728f4), [TensorCore.IEEE.LeanBridge.native64_mul_negative_underflow](Tests/NativeRegression.md#decl-0b23ddfcd7aaaa18), [TensorCore.IEEE.LeanBridge.native64_sub_cancellation](Tests/NativeRegression.md#decl-5f0c50d4c0a7d7b8), [TensorCore.IEEE.LeanBridge.nativeAdd32_reference](LeanBridge.md#decl-b1ec0d9884fab564), [TensorCore.IEEE.LeanBridge.nativeAdd32_round](LeanFiniteAddition.md#decl-704bb8c1299ecd92), [TensorCore.IEEE.LeanBridge.nativeAdd64_reference](LeanBridge64.md#decl-33dce507c25c18ec), [TensorCore.IEEE.LeanBridge.nativeMul32_reference](LeanBridge.md#decl-13c80e51e6db1537), [TensorCore.IEEE.LeanBridge.nativeMul64_reference](LeanBridge64.md#decl-3fb33b56bef96519), [TensorCore.IEEE.LeanBridge.nativeSub32_reference](LeanBridge.md#decl-8d9a826fd4c8febf), [TensorCore.IEEE.LeanBridge.nativeSub64_reference](LeanBridge64.md#decl-44c97805468e4e90), [TensorCore.IEEE.LeanBridge.native_add_cancellation](Tests/NativeRegression.md#decl-0d24d41da51d5fb1), [TensorCore.IEEE.LeanBridge.native_add_directed_fallback](Tests/NativeRegression.md#decl-0431fc6ebe0197cb), [TensorCore.IEEE.LeanBridge.native_add_nan_payload_fallback](Tests/NativeRegression.md#decl-9347153f31158d97), [TensorCore.IEEE.LeanBridge.native_add_negative](Tests/NativeRegression.md#decl-9fa4ce1cfef11803), [TensorCore.IEEE.LeanBridge.native_add_negative_zeros](Tests/NativeRegression.md#decl-40190124dd527b0f), [TensorCore.IEEE.LeanBridge.native_add_normal_boundary](Tests/NativeRegression.md#decl-fef2176eaa98e50c), [TensorCore.IEEE.LeanBridge.native_add_overflow_fallback](Tests/NativeRegression.md#decl-6bdd07b1f042e387), [TensorCore.IEEE.LeanBridge.native_add_subnormals](Tests/NativeRegression.md#decl-8130d7b95ed450eb), [TensorCore.IEEE.LeanBridge.native_add_tie_even](Tests/NativeRegression.md#decl-d52724a037d59c51), [TensorCore.IEEE.LeanBridge.native_add_tie_odd](Tests/NativeRegression.md#decl-40fc35ae2a109a6b), [TensorCore.IEEE.LeanBridge.native_mul_half_min_subnormal](Tests/NativeRegression.md#decl-1f68d851a7407949), [TensorCore.IEEE.LeanBridge.native_mul_invalid_fallback](Tests/NativeRegression.md#decl-3bedd6a0f89ab144), [TensorCore.IEEE.LeanBridge.native_mul_negative_underflow](Tests/NativeRegression.md#decl-b3f17b64f004bbd3), [TensorCore.IEEE.LeanBridge.native_mul_signed](Tests/NativeRegression.md#decl-9156056ee2053925), [TensorCore.IEEE.LeanBridge.native_mul_subnormal_exact](Tests/NativeRegression.md#decl-9c67c207afa08825), [TensorCore.IEEE.LeanBridge.native_nan_payload_differs](Tests/NativeRegression.md#decl-0ba4789c10c4d857), [TensorCore.IEEE.LeanBridge.native_sub_cancellation](Tests/NativeRegression.md#decl-ad2f91691620f560), [TensorCore.IEEE.LeanBridge.native_sub_negative](Tests/NativeRegression.md#decl-5ca30f1420f360fe), [TensorCore.IEEE.LeanBridge.packNormalize32_reference](LeanBridge.md#decl-900184c483f9a344), [TensorCore.IEEE.LeanBridge.packNormalize64_reference](LeanBridge64.md#decl-a816cd1acc4bf349), [TensorCore.IEEE.LeanBridge.packRound32_reference](LeanBridge.md#decl-1ae2176a75745348), [TensorCore.IEEE.LeanBridge.packRound64_reference](LeanBridge64.md#decl-de5cd6300d590df4), [TensorCore.IEEE.LeanBridge.round32_ieee_positive_zero](LeanFiniteAddition.md#decl-22752ecea454be9e), [TensorCore.IEEE.MulSpec](Specification.md#decl-19709ea904a2d2db), [TensorCore.IEEE.NaNSpec](Specification.md#decl-bf6736b83a880066), [TensorCore.IEEE.Regression.directed_overflow](Tests/Regression.md#decl-3cdb81d46e18700a), [TensorCore.IEEE.Regression.fused_single_rounding](Tests/Regression.md#decl-7b5a3ce3bbe533ba), [TensorCore.IEEE.Regression.fused_without_intermediate_overflow](Tests/Regression.md#decl-3089d50d2664c88b), [TensorCore.IEEE.Regression.fused_zero_sign](Tests/Regression.md#decl-a4e45279d595ebe5), [TensorCore.IEEE.Regression.gradual_underflow](Tests/Regression.md#decl-27e28c5348b13b43), [TensorCore.IEEE.Regression.nan_payload_conversion](Tests/Regression.md#decl-c125c286409c41d9), [TensorCore.IEEE.Regression.near_overflow](Tests/Regression.md#decl-c37522c37f5d3371), [TensorCore.IEEE.Regression.nonfinite_and_payload](Tests/Regression.md#decl-3e3bfb1038fb1ac0), [TensorCore.IEEE.Regression.normal_output_underflow](Tests/Regression.md#decl-677cac92c14a8565), [TensorCore.IEEE.Regression.tininess_choice](Tests/Regression.md#decl-0c40571e865c8290), [TensorCore.IEEE.Regression.zero_signs](Tests/Regression.md#decl-c69dca8aa8f614cd), [TensorCore.IEEE.Result.accumulate](Basic.md#decl-e2a38f7ec363b4bf), [TensorCore.IEEE.RoundSpec](Rounding.md#decl-b049ff2d5079187f), [TensorCore.IEEE.add](Operations.md#decl-7e1f336bdb43c1b4), [TensorCore.IEEE.addDatum](Operations.md#decl-0794933f4c870994), [TensorCore.IEEE.addDatum_correct](Specification.md#decl-e6d467aa78f03a70), [TensorCore.IEEE.addWithLean](NativeOperations.md#decl-69353adf32ad8f12), [TensorCore.IEEE.addWithLean_correct](NativeOperations.md#decl-1d95790ca0574f94), [TensorCore.IEEE.addWithLean_eq](NativeOperations.md#decl-2635635840e5f106), [TensorCore.IEEE.addWithLean_native](NativeOperations.md#decl-fd6a11fc2eaba885), [TensorCore.IEEE.convert](Operations.md#decl-4f62188c5500d3b7), [TensorCore.IEEE.convertDatum](Operations.md#decl-ead5be4619d6f294), [TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c), [TensorCore.IEEE.fma](Operations.md#decl-5173f8a4ff82ac61), [TensorCore.IEEE.fmaDatum](Operations.md#decl-facf9b59e1cbf7de), [TensorCore.IEEE.fmaDatum_correct](Specification.md#decl-541a331629cf005e), [TensorCore.IEEE.inRangeResult32](NativeOperations.md#decl-060949a8c5e93a66), [TensorCore.IEEE.inRangeResult32_eq](NativeOperations.md#decl-ef34361af1c0715e), [TensorCore.IEEE.inRangeResult64](NativeOperations.md#decl-c4eba725df48223c), [TensorCore.IEEE.inRangeResult64_eq](NativeOperations.md#decl-a4d1869f2183e5d6), [TensorCore.IEEE.infinityResult](Operations.md#decl-14941c0c62b980d6), [TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a), [TensorCore.IEEE.invalidResult](Operations.md#decl-07769958a12ce9c8), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.mul](Operations.md#decl-c121f20d96d6a64e), [TensorCore.IEEE.mulDatum](Operations.md#decl-af85367bf8208a72), [TensorCore.IEEE.mulDatum_correct](Specification.md#decl-360e50b0170b46a2), [TensorCore.IEEE.mulWithLean](NativeOperations.md#decl-13fcf73d5e1341d3), [TensorCore.IEEE.mulWithLean_correct](NativeOperations.md#decl-67cfb7377bb37ad8), [TensorCore.IEEE.mulWithLean_eq](NativeOperations.md#decl-5d277c7bbd841070), [TensorCore.IEEE.mulWithLean_native](NativeOperations.md#decl-fbd7d0b915acb4bd), [TensorCore.IEEE.nanResult](Operations.md#decl-c0ed43c28229a37e), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b), [TensorCore.IEEE.nativeAddResult32](NativeOperations.md#decl-ec1af70180857547), [TensorCore.IEEE.nativeAddResult32_eq](NativeOperations.md#decl-b351d9aefeea34de), [TensorCore.IEEE.nativeAddResult64](NativeOperations.md#decl-f03febed232c86ff), [TensorCore.IEEE.nativeAddResult64_eq](NativeOperations.md#decl-5c0f5f79d45b4858), [TensorCore.IEEE.nativeMulResult32](NativeOperations.md#decl-8a60d5b139a47392), [TensorCore.IEEE.nativeMulResult32_eq](NativeOperations.md#decl-b72459f5eb7df15f), [TensorCore.IEEE.nativeMulResult64](NativeOperations.md#decl-da7d8d0f36814d8f), [TensorCore.IEEE.nativeMulResult64_eq](NativeOperations.md#decl-a3394de6c86087f5), [TensorCore.IEEE.nativeSubResult32](NativeOperations.md#decl-32af219c859af336), [TensorCore.IEEE.nativeSubResult32_eq](NativeOperations.md#decl-67c867c299bfa458), [TensorCore.IEEE.nativeSubResult64](NativeOperations.md#decl-230fd7d0364069c2), [TensorCore.IEEE.nativeSubResult64_eq](NativeOperations.md#decl-6eabc2e456b7b9e2), [TensorCore.IEEE.round](Rounding.md#decl-e686eb7fa2b669b5), [TensorCore.IEEE.round_agrees_finite](Rounding.md#decl-8c10d9eec6663da4), [TensorCore.IEEE.round_correct](Rounding.md#decl-c507d7376a5b55ac), [TensorCore.IEEE.round_no_invalid](Rounding.md#decl-a2f2823564beb359), [TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219), [TensorCore.IEEE.round_overflow_inexact](Rounding.md#decl-2fcf4462ca5a069c), [TensorCore.IEEE.round_underflow_inexact](Rounding.md#decl-d69c07e73f191e1a), [TensorCore.IEEE.round_zero](Rounding.md#decl-99b995352bd4bae1), [TensorCore.IEEE.sub](Operations.md#decl-c0ce25b051e73b2b), [TensorCore.IEEE.subWithLean](NativeOperations.md#decl-9d4b383e5cf47f67), [TensorCore.IEEE.subWithLean_correct](NativeOperations.md#decl-7ab9a6f1a2efdedb), [TensorCore.IEEE.subWithLean_eq](NativeOperations.md#decl-fe6bb7e80b5ded0b), [TensorCore.IEEE.subWithLean_native](NativeOperations.md#decl-7f93d5f56de6f401)

</details>

</details>

<a id="decl-e2a38f7ec363b4bf"></a>

<details>
<summary><code>TensorCore.IEEE.Result.accumulate</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L105)

```lean
/-- Explicit sticky status accumulation; an operation only reports newly raised flags. -/
def Result.accumulate (r : Result f) (previous : Flags) : Flags := previous.union r.flags
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Flags.union](Basic.md#decl-82ff2b8736176866), [TensorCore.IEEE.Result](Basic.md#decl-24fb6631bfd8efcf)

<details>
<summary>Used by</summary>

[TensorCore.IEEE.Regression.sticky_flags](Tests/Regression.md#decl-6f46397e23c85174)

</details>

</details>

<a id="decl-42575e26b6696b19"></a>

<details>
<summary><code>TensorCore.IEEE.zero_value</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L107)

```lean
theorem zero_value (f : BinaryFormat) (s : Bool) :
    binaryValue f.layout (zero f s) = some 0 := by
  have h := (BinaryRep.zero f.layout f.valid s).encode_value f.valid
  cases s <;> simpa [zero, BinaryRep.zero, BinaryRep.value] using h
```

**Supporting proofs:** [TensorCore.BinaryRep.encode_value](../Core/Binary/Bijection.md#decl-d81c625dde1b8c14), [TensorCore.Format.emin_le_emax](../Core/Binary/Encoding.md#decl-f21f4f9c313ac4d5), [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8)

**Definitions and types:** [TensorCore.BinaryRep](../Core/Binary/Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](../Core/Binary/Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.value](../Core/Binary/Defs.md#decl-cc6dcf5c8ebfaa31), [TensorCore.BinaryRep.zero](../Core/Binary/SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c)

</details>

</details>

<a id="decl-a55f8f28a95986bc"></a>

<details>
<summary><code>TensorCore.IEEE.zero_sign</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L112)

```lean
theorem zero_sign (f : BinaryFormat) (s : Bool) : sign f (zero f s) = s :=
  (encodeBinary_fields f.layout f.valid (BinaryRep.zero f.layout f.valid s)).1
```

**Supporting proofs:** [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.encodeBinary_fields](../Core/Binary/Bijection.md#decl-bcffec0f99ba4510)

**Definitions and types:** [TensorCore.BinaryRep](../Core/Binary/Defs.md#decl-895d436fd0a35170), [TensorCore.BinaryRep.encode](../Core/Binary/Bijection.md#decl-3a2559ae7dd8fec5), [TensorCore.BinaryRep.zero](../Core/Binary/SignedBijection.md#decl-88b6b09937a229a9), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419), [TensorCore.binaryExponentField](../Core/Binary/Encoding.md#decl-c12aa273bd1bbbb3), [TensorCore.binarySign](../Core/Binary/Encoding.md#decl-a5de0a69a17e78c5)

**Transitive Lean axioms:** `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c)

</details>

</details>

<a id="decl-42224d8ca5e35406"></a>

<details>
<summary><code>TensorCore.IEEE.decode_zero</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L115)

```lean
theorem decode_zero (f : BinaryFormat) (s : Bool) : decode f (zero f s) = .finite s 0 := by
  cases f <;> cases s <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.zero](Basic.md#decl-8e1c4a10ad1ad419)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-a61646dd7f66db74"></a>

<details>
<summary><code>TensorCore.IEEE.decode_infinity</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L118)

```lean
theorem decode_infinity (f : BinaryFormat) (s : Bool) : decode f (infinity f s) = .infinity s := by
  cases f <;> cases s <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.infinityResult_correct](Specification.md#decl-31a79d9ef7df4d0a)

</details>

</details>

<a id="decl-4f5c3082603585a7"></a>

<details>
<summary><code>TensorCore.IEEE.decode_nan</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L121)

```lean
theorem decode_nan (f : BinaryFormat) (s : Bool) (p : ℕ) :
    decode f (nan f s p) = .nan s false (p % quietBit f) := by
  have hc : classify f.layout (nan f s p) = .nan := by
    cases f <;> cases s <;>
      simp [nan, infinity, quietBit, classify, classifyNat,
        BinaryFormat.layout, fp16, fp32, fp64, Format.width, BitVec.toNat_ofNat]
    all_goals split <;> (try omega)
    all_goals split <;> (try omega)
    all_goals rfl
  unfold decode
  rw [hc]
  cases f <;> cases s <;>
    simp [nan, infinity, quietBit, sign, binarySign, BinaryFormat.layout,
      fp16, fp32, fp64, Format.width, BitVec.toNat_ofNat]
  all_goals repeat' apply And.intro
  all_goals omega
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.infinity](Basic.md#decl-6135d610bb0efb93), [TensorCore.IEEE.nan](Basic.md#decl-3fa748041e6ba03e), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.convertDatum_correct](Specification.md#decl-fe25c16c8855e864), [TensorCore.IEEE.convert_quietNaN_roundtrip](Compatibility.md#decl-11ef56fd93e042f2), [TensorCore.IEEE.invalidResult_correct](Specification.md#decl-f2ace675f60bca9f), [TensorCore.IEEE.nanResult_correct](Specification.md#decl-5ef2a9f5f3d8b53b)

</details>

</details>

<a id="decl-798b937fdff5abb2"></a>

<details>
<summary><code>TensorCore.IEEE.maxFiniteWord_value</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L138)

```lean
theorem maxFiniteWord_value (f : BinaryFormat) (s : Bool) :
    binaryValue f.layout (maxFiniteWord f s) =
      some (if s then -f.layout.maxFinite else f.layout.maxFinite) := by
  have h := encodeBinary_value f.layout f.valid s f.layout.emax
    ((2 ^ (f.layout.fractionBits + 1) - 1 : ℕ) : ℤ) (f.layout.emin_le_emax f.valid)
    (Int.le_refl _) (by cases f <;> decide +kernel) (by cases f <;> decide +kernel)
    (Or.inl (by cases f <;> decide +kernel))
  cases s <;> simpa [maxFiniteWord, Format.maxFinite, Rat.neg_mul, Rat.intCast_natCast] using h
```

**Supporting proofs:** [TensorCore.Format.emin_le_emax](../Core/Binary/Encoding.md#decl-f21f4f9c313ac4d5), [TensorCore.IEEE.BinaryFormat.valid](Basic.md#decl-bb1825a12b957cb8), [TensorCore.encodeBinary_value](../Core/Binary/Encoding.md#decl-4c3ec26630f2de66)

**Definitions and types:** [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.emax](../Core/Defs.md#decl-dc4afe2b44cdf196), [TensorCore.Format.emin](../Core/Defs.md#decl-af48d9057baa67b0), [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.encodeBinary](../Core/Binary/RoundOp.md#decl-d8cef04fa85eeb47), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ca049339b8b107f4"></a>

<details>
<summary><code>TensorCore.IEEE.maxFiniteWord_sign</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L147)

```lean
theorem maxFiniteWord_sign (f : BinaryFormat) (s : Bool) :
    sign f (maxFiniteWord f s) = s := by
  cases f <;> cases s <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.maxFiniteWord](Basic.md#decl-6ddaa725b7fd2551), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f)

**Transitive Lean axioms:** none.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-33b32196fb355d13"></a>

<details>
<summary><code>TensorCore.IEEE.maxFinite_positive</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L151)

```lean
theorem maxFinite_positive (f : BinaryFormat) : 0 < f.layout.maxFinite := by
  cases f <;> decide +kernel
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Format.maxFinite](../Core/Defs.md#decl-6cac0e89f6135a61), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.round_overflow_iff](Rounding.md#decl-fd83276c6eaa7219)

</details>

</details>

<a id="decl-e921ec9072a7db34"></a>

<details>
<summary><code>TensorCore.IEEE.decode_finite_iff</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L155)

```lean
/-- The IEEE finite projection preserves the old numerical value and adds its sign bit. -/
theorem decode_finite_iff (f : BinaryFormat) (b : Word f) (s : Bool) (v : ℚ) :
    decode f b = .finite s v ↔ binaryValue f.layout b = some v ∧ sign f b = s := by
  cases hc : classify f.layout b <;>
    simp [decode, binaryValue, hc, Classification.finite, Decoded.value, and_comm]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.Classification](../Core/Defs.md#decl-5f9e3ead4db8c4b5), [TensorCore.Classification.finite](../Core/Encoding.md#decl-cfa2987aba5ba75a), [TensorCore.Decoded](../Core/Defs.md#decl-f4e0107ee6679350), [TensorCore.Decoded.value](../Core/Defs.md#decl-c988858af545448a), [TensorCore.Format](../Core/Defs.md#decl-db780180792c6817), [TensorCore.Format.width](../Core/Defs.md#decl-950f9d663ce32954), [TensorCore.IEEE.BinaryFormat](Basic.md#decl-d560501f21a28c67), [TensorCore.IEEE.BinaryFormat.layout](Basic.md#decl-a8e62c5be0ff5328), [TensorCore.IEEE.Datum](Basic.md#decl-85a736cf96780149), [TensorCore.IEEE.Word](Basic.md#decl-b814ad4fc9e848f5), [TensorCore.IEEE.decode](Basic.md#decl-2beaccf900e5635c), [TensorCore.IEEE.quietBit](Basic.md#decl-7fc4ab022f9af5d1), [TensorCore.IEEE.sign](Basic.md#decl-f3f376a13829bc9f), [TensorCore.binaryValue](../Core/Binary/RoundOp.md#decl-45dceb4f1deb9b75), [TensorCore.classify](../Core/Encoding.md#decl-793c375a3325b7e3), [TensorCore.pow2](../Core/Exact.md#decl-b52a0281b35514e3)

**Transitive Lean axioms:** `Classical.choice`, `Quot.sound`, `propext`.

<details>
<summary>Used by</summary>

[TensorCore.IEEE.LeanBridge.value32_nonzero](LeanFiniteAddition.md#decl-6dac9e31f477fbbe), [TensorCore.IEEE.convert_self_finite](Compatibility.md#decl-78bff244af6cfb2c)

</details>

</details>

<a id="decl-73685b744f8d3380"></a>

<details>
<summary><code>TensorCore.IEEE.flags_union_self</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L160)

```lean
theorem flags_union_self (a : Flags) : a.union a = a := by cases a; simp [Flags.union]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Flags.union](Basic.md#decl-82ff2b8736176866)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>

<a id="decl-ee9f3332f5eae317"></a>

<details>
<summary><code>TensorCore.IEEE.flags_union_assoc</code></summary>

[Lean source](../../../TensorCore/IEEE/Basic.lean#L162)

```lean
theorem flags_union_assoc (a b c : Flags) : (a.union b).union c = a.union (b.union c) := by
  cases a; cases b; cases c; simp [Flags.union, Bool.or_assoc]
```

**Supporting proofs:** None in this repository.

**Definitions and types:** [TensorCore.IEEE.Flags](Basic.md#decl-7fb0da58f8de59d1), [TensorCore.IEEE.Flags.union](Basic.md#decl-82ff2b8736176866)

**Transitive Lean axioms:** `propext`.

<details>
<summary>Used by</summary>

No other source declaration in this graph.

</details>

</details>
