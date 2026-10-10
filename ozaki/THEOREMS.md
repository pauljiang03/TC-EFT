# What is proven

This page lists the main results that Lean has checked, in plain language, with the label of the
matching check in the Z3 models where there is one
(`[Z.n]` for a Z3 proof, other labels for runtime assertions). Labels refer to `ozaki1/` in the
Ozaki-I sections, `ozaki2/` in the Ozaki-II sections, and `ozaki-NVIDIA/` in the ADP section; in
the hardware sections they carry a prefix `I:`, `II:` or `ADP:`. The linked file has the exact
statement and every assumption. Every theorem depends only on Lean's standard axioms (`propext`,
`Classical.choice`, `Quot.sound`); both test libraries audit this.

A Z3 runtime assertion checks one fact on the test matrices; the Lean theorem states it for every
input. A Z3 lemma is proved for one format or exponent range; the Lean theorem is stated for the
general case where that costs nothing.

Several sections go beyond the Z3 models: [correct rounding](#correct-rounding),
[long dot products and FP64](#long-dot-products-fp64-and-binary-formats), and the
[ADP pipeline](#the-adp-pipeline-on-the-int8-engine) with its Grade-A guarantee. The
[last section](#not-proved) lists what is not proved.

## The schemes, independent of the hardware

### Ozaki-I: slicing

| What it says | Z3 | Lean name | File |
| --- | --- | --- | --- |
| The slices and the residual add up to the vector exactly, against every `y`. | `[S1.13]` | `Ozaki.split_dot` | [Ozaki/Split.lean](Ozaki/Split.lean) |
| Every slice coefficient is an integer of magnitude at most `2^b`. | `[S1.9]`, `[S1.10]` | `Ozaki.split_coeff_bound` | [Ozaki/Split.lean](Ozaki/Split.lean) |
| Slice `t` lies on a grid at least `t (b + 1)` bits below the first; the residual after `s` slices is at most `2^(E − s(b+1))`. | `[S1.12]` | `Ozaki.split_grid_le`, `Ozaki.split_residual_le` | [Ozaki/Split.lean](Ozaki/Split.lean) |
| `E = ⌈log₂ max\|x\|⌉`, so `2^(E−1) < max\|x\| ≤ 2^E`. | `[H.3]` | `Ozaki.splitExp_spec` | [Ozaki/Split.lean](Ozaki/Split.lean) |

### Ozaki-I: products and recombination

| What it says | Z3 | Lean name | File |
| --- | --- | --- | --- |
| With `s` slices there are `s (s + 1) / 2` slice products. | `[S3.1]` | `Ozaki.trianglePairs_length` | [Ozaki/Ozaki1.lean](Ozaki/Ozaki1.lean) |
| With an engine exact on `b`-bit slices, Ozaki-I adds exactly the scaled exact slice products. | `[S2.1]` | `Ozaki.ozaki1_eq_sumWith` | [Ozaki/Ozaki1.lean](Ozaki/Ozaki1.lean) |
| A slice product has magnitude at most `k 2^(2b)`, which is `2^24` in the Z3 configuration. | `[S2.2]` | `Ozaki.slice_product_bound`, `Ozaki.z3_slice_product_bound` | [Ozaki/Checks.lean](Ozaki/Checks.lean) |
| Error identity: `x · y − Σ terms = r · y + Σₜ 2^gₜ (qₜ · r'ₛ₋ₜ)`, where `r'ₖ` is the residual of `y` after `k` slices. | `[S3.4]` | `Ozaki.dot_eq_exactTerms_add` | [Ozaki/Ozaki1.lean](Ozaki/Ozaki1.lean) |
| The slicing error is at most `(s + 1) k 2^(E + F − s(b+1))`, and at most `4 (s + 1) k max\|x\| max\|y\| 2^(−s(b+1))`. | | `Ozaki.exactTerms_error`, `Ozaki.exactTerms_error_normwise` | [Ozaki/Ozaki1.lean](Ozaki/Ozaki1.lean) |
| `n` additions with relative error `u` and absolute error `η` lose at most `((1 + u)^n − 1) Σ\|tⱼ\| + n (1 + u)^n η`. | `[S3.3]` | `Ozaki.sumWith_error` | [Ozaki/Summation.lean](Ozaki/Summation.lean) |
| The whole of Ozaki-I: the result is within the recombination bound plus the slicing bound of `x · y`. | | `Ozaki.ozaki1_error` | [Ozaki/Ozaki1.lean](Ozaki/Ozaki1.lean) |
| Ozaki-I returns a value (never Inf or NaN) when the sum of the scaled products and its rounding errors stays within the format's range. | `[H.1]` | `Ozaki.ozaki1_isSome`, `Ozaki.sumWith_isSome` | [Ozaki/Success.lean](Ozaki/Success.lean) |
| Native GEMM (products rounded, then added left to right) is within `γₖ Σ\|xᵢyᵢ\|` plus a subnormal term, `γₖ = k u / (1 − k u)`. | `[M.1]`, `ADP:[N.1]` | `Ozaki.nativeDot_error`, `Ozaki.nativeDot_error_gamma` | [Ozaki/Native.lean](Ozaki/Native.lean) |

### Ozaki-II

| What it says | Z3 | Lean name | File |
| --- | --- | --- | --- |
| The scaled, truncated integers have magnitude at most `2^P`. | `[S1.3]`, `[S1.4]` | `Ozaki.scaleTrunc_bound` | [Ozaki/Ozaki2.lean](Ozaki/Ozaki2.lean) |
| The scaled row maximum lies in `(2^(P−1), 2^P]`. | `[S1.1]`, `[H.4]` | `Ozaki.scaleShift_spec`, `Ozaki.ceilLog2_spec` | [Ozaki/Checks.lean](Ozaki/Checks.lean), [Ozaki/Rounding.lean](Ozaki/Rounding.lean) |
| Truncation loses less than one and never increases the magnitude; the truncated product is at most `k 2^(2P)`. | `[S1.5]`, `[S1.6]` | `Ozaki.truncInt_spec`, `Ozaki.natAbs_truncProduct_le` | [Ozaki/Rounding.lean](Ozaki/Rounding.lean), [Ozaki/Checks.lean](Ozaki/Checks.lean) |
| A residue product is at most `k ⌊m/2⌋²`. | `[S3.2]` | `Ozaki.natAbs_residueProduct_le` | [Ozaki/Checks.lean](Ozaki/Checks.lean) |
| Symmetric residues lie in `(−m/2, m/2]`, and products of residues are congruent to the product. | `[H.5]`, `[S3.3]` | `Ozaki.symMod_bounds`, `Ozaki.dvd_dotZ_symMod` | [Ozaki/CRT.lean](Ozaki/CRT.lean), [Ozaki/Ozaki2.lean](Ozaki/Ozaki2.lean) |
| CRT reconstruction with any valid basis returns every `c` with `−M < 2c ≤ M` from residues congruent to it. | `[Z.4]`, `[S4.3]` | `Ozaki.crt_eq` | [Ozaki/CRT.lean](Ozaki/CRT.lean) |
| The reconstruction matches every residue: `mⱼ ∣ crt B rs − rⱼ`. | `[S4.2]` | `Ozaki.crt_dvd_sub` | [Ozaki/Checks.lean](Ozaki/Checks.lean) |
| With an engine exact on `b`-bit residues and `2 k 2^(2P) < M`, Ozaki-II is one rounding of the truncated product. | `[S4.3]` | `Ozaki.ozaki2_eq` | [Ozaki/Ozaki2.lean](Ozaki/Ozaki2.lean) |
| Truncation error `\|x · y − 2^(−sₓ−s_y) (a · c)\| ≤ Σᵢ (2^(−sₓ)\|yᵢ\| + 2^(−sₓ−s_y)\|aᵢ\|)`, at most `8 k max\|x\| max\|y\| 2^(−P)`. | `[S5.1]` | `Ozaki.truncProduct_error`, `Ozaki.truncProduct_error_normwise` | [Ozaki/Ozaki2.lean](Ozaki/Ozaki2.lean) |
| The whole of Ozaki-II: one rounding plus the truncation bound. | | `Ozaki.ozaki2_error` | [Ozaki/Ozaki2.lean](Ozaki/Ozaki2.lean) |
| Ozaki-II returns a value when `k 2^((P−sₓ)+(P−s_y))` is within range. | `[H.1]` | `Ozaki.ozaki2_isSome` | [Ozaki/Success.lean](Ozaki/Success.lean) |

### The Z3 models' parameters

| What it says | Z3 | Lean name | File |
| --- | --- | --- | --- |
| Four products of `11`-bit integers total at most `2^24`. | `[M.0]` | `Ozaki.z3_slice_budget` | [Ozaki/Parameters.lean](Ozaki/Parameters.lean) |
| The computed weights for `{4096, 4095, 4093, 4091}` form a valid CRT basis. | `[S0.1]`, `[S0.2]`, `[S4.1]` | `Ozaki.z3Basis_valid` | [Ozaki/Parameters.lean](Ozaki/Parameters.lean) |
| `P = 22` is the largest precision with `2 k 2^(2P) < M`. | `[S0.3]`, `[S0.4]` | `Ozaki.z3_bits` | [Ozaki/Parameters.lean](Ozaki/Parameters.lean) |
| `k ⌊m/2⌋² ≤ 2^24` for the Z3 moduli. | `[S0.5]` | `Ozaki.z3_residue_budget` | [Ozaki/Checks.lean](Ozaki/Checks.lean) |
| At `P = 23`, `c = M` is within reach and reconstructs as `0`. | `[Z.5]` | `Ozaki.crt_fails_at_23` | [Ozaki/Parameters.lean](Ozaki/Parameters.lean) |

### ADP and ESC (INT8 engines)

| What it says | Z3 | Lean name | File |
| --- | --- | --- | --- |
| The unsigned-slice remap reconstructs every integer. | `[U.5]` | `Ozaki.ADP.remap_value` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| Remapped slices are signed bytes exactly on `[−128 (256^s − 1)/255, 127 (256^s − 1)/255]`. | `[Z.3]` | `Ozaki.ADP.remap_s8` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| A remapped digit keeps the unsigned digit's bit pattern. | `[Z.5]` | `Ozaki.ADP.remap_bit_pattern` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| The remap range is smaller than the prototype's: `2^23 − 129` fits three floor/u8 slices but not three remapped ones. | `[Z.4]` | `Ozaki.ADP.remap_range_smaller` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| `53`-bit integers need `8` naive signed slices and `7` remapped ones. | `[T.3]` | `Ozaki.ADP.slices_53` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| The coarsened estimate never exceeds the exact `exp(z_r)` when zeros have exponent `−∞`, for any block size. | `[Z.6]` | `Ozaki.ADP.coarseEst_le` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| Skipping zeros, or giving them exponent `−1022`, can overestimate it. | `[Z.7]`, `[Z.8]` | `Ozaki.ADP.skipZeros_unsafe`, `Ozaki.ADP.field0_unsafe` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| Full fidelity with `W = 53 + ESC + 1`, and also without the `+1`. | `[Z.9]`, `[Z.9b]` | `Ozaki.ADP.full_fidelity`, `Ozaki.ADP.full_fidelity_without_plus_one` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| `\|ab − ãb̃\| ≤ δa\|b\| + \|ã\|δb`; with the `+1` each half is at most `2^(F−52)`, and without it that fails. | `[Z.10]`–`[Z.12]` | `Ozaki.ADP.term_error`, `Ozaki.ADP.funnel`, `Ozaki.ADP.funnel_needs_plus_one` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| The `s²` slice products, weighted by `256^(t+u)`, add up to the fixed-point product. | `[R.1]` | `Ozaki.ADP.slice_recombination` | [Ozaki/ADP.lean](Ozaki/ADP.lean) |
| Floor digits: the low digits are unsigned bytes, the lead digit a signed byte, and they reconstruct `N`. | `[U.1]`, `[U.2]` | `Ozaki.ADP.floorDigits_bytes`, `Ozaki.ADP.floorDigits_value` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| A nonzero binary64 value lies in `[2^e, 2^(e+1))` for its exponent `e` (normals). | `[D.2]` | `Ozaki.ADP.abs_lt_exp64`, `Ozaki.ADP.exp64_le_abs` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| Fixed point: `0 ≤ a 2^s − N < 1`, `N ∈ [−2^W, 2^W)`, and on-grid entries convert exactly. | `[F.1]`, `[F.2]` | `Ozaki.ADP.fixed_floor`, `Ozaki.ADP.fixed_range`, `Ozaki.ADP.fixed_exact` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| Both factors of a dominant product convert exactly (full fidelity on the data). | `[F.3]` | `Ozaki.ADP.dominant_exact` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| Each product's fixed-point error is at most `2^(F−52)` (the Z3 check allows `2^(F−51)`). | `[F.4]` | `Ozaki.ADP.term_bound` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| The exact ESC is attained, is at least `0`, and the coarsened ESC is at least the exact one. | `[X.1]`, `[X.2]`, `[X.5]` | `Ozaki.ADP.fExact_attained`, `Ozaki.ADP.fExact_le`, `Ozaki.ADP.escCoarse_ge` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| Block representatives bound every member. | `[X.3]` | `Ozaki.ADP.blockRep_bounds` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| The fixed-point product is within `k 2^(F−52)` of `x · y`, on ADP's own shifts and coarsened ESC. | `[P.1]` | `Ozaki.ADP.fixedPoint_error`, `Ozaki.ADP.fixedProduct_error` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |
| **Grade A.** After one rounding, `\|C − x · y\| ≤ (4k + 1) 2^-53 Σ\|xᵢyᵢ\| + η`, for normal or zero entries and `2ku ≤ 1`. Subnormal entries can violate it (see the README's findings). | `[P.2]` | `Ozaki.ADP.emulated_gradeA` | [Ozaki/ADPError.lean](Ozaki/ADPError.lean) |

### Correct rounding

Each scheme holds an exact value `H` before its last rounding and a proved bound `B ≥ |x · y − H|`.
If `H − B` and `H + B` round to the same value, so does `x · y`; otherwise more slices or moduli are
tried, then an exact path. No Z3 model has a counterpart. `ozaki1CR` and `ozaki2CR` fall back to the
exact rational `x · y`, so their theorems would hold without the engine; the `CRE` variants take the
exact path on the engine. The monotonicity of rounding to nearest is classical (Flocq's
`Rnd_N_pt_monotone`); it is proved here for the framework.

| What it says | Lean name | File |
| --- | --- | --- |
| Rounding to nearest is monotone; this needs only that results are nearest values, not the tie rule. | `Ozaki.round_monotone` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |
| If `\|v − H\| ≤ B` and both `H ± B` round to `w`, then `v` rounds to `w`. | `Ozaki.round_eq_of_enclosure` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |
| Trying enclosures in turn and then the exact value returns the rounding of the exact value. | `Ozaki.certify_eq` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |
| `\|x · y − x' · y'\| ≤ max\|x − x'\| Σ\|y\| + max\|y − y'\| Σ\|x'\|`. | `Ozaki.dot_approx_error` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |
| Ozaki-I and Ozaki-II, correctly rounded, on any engine exact on their slices or residues. | `Ozaki.ozaki1CR_eq`, `Ozaki.ozaki2CR_eq` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |
| Inputs on a grid `2^m` leave nothing over once the slicing bound is below `2^m`; with nothing left over, Ozaki-I with all `s²` slice products is exact. | `Ozaki.split_residual_zero`, `Ozaki.ozaki1Full_eq` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |
| Correctly rounded Ozaki-I and Ozaki-II whose exact path also runs on the engine (Ozaki-I with all `s²` slice products). | `Ozaki.ozaki1CRE_eq`, `Ozaki.ozaki2CRE_eq` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |
| **What the check achieves:** an enclosure settles an entry whenever `x · y` is `2B` from every rounding boundary; for Ozaki-I with its slicing bound. | `Ozaki.roundEnclosure_of_margin`, `Ozaki.ozaki1Enclosure_settles` | [Ozaki/Correct.lean](Ozaki/Correct.lean) |

### Long dot products, FP64 and binary formats

| What it says | Lean name | File |
| --- | --- | --- |
| **Split-K.** Chunks of `m` terms, each an exact engine call, added exactly: exact on vectors of every length when `m · 2^(2b)` fits the engine's budget. | `Ozaki.chunked_exactOn`, `Ozaki.chunksAux_pairs`, `Ozaki.chunkLen_budget` | [Ozaki/SplitK.lean](Ozaki/SplitK.lean) |
| A hardware-independent IEEE round to nearest even for any binary format, with IEEE overflow: nearest, succeeds on intervals, error `2^-p\|q\| + 2^(emin−p)`. Instances `rne32Q` and `rne64`. | `Ozaki.roundRNE_nearest`, `Ozaki.roundRNE_intervals`, `Ozaki.roundRNE_within`, `Ozaki.rne64_nearest`, `Ozaki.rne32Q_nearest` | [Ozaki/Binary.lean](Ozaki/Binary.lean) |
| Binary32 and binary64 values are multiples of `2^-149` and `2^-1074`; inputs leave nothing over after `smax` slices with `smax (b+1) > 277` (binary32) or `> 2098` (binary64). | `Ozaki.binary64Value_gridMultiple`, `Ozaki.vanish32Q`, `Ozaki.vanish64` | [Ozaki/Binary.lean](Ozaki/Binary.lean), [Ozaki/Exact64.lean](Ozaki/Exact64.lean) |
| **The exact sum's register** (needed only by an exact path that adds the slice products exactly; the bounded one below does not): for inputs on a grid `2^m` the exact slice sum is `N · 2^(2(m−b))` with `\|N\| ≤ (s(s+1)/2) k 2^(E+F−2(m−b))`; for binary32 and `11`-bit slices about `580` bits. | `Ozaki.exactTerms_sum_register`, `Ozaki.exactTerms_sum_register32` | [Ozaki/Width.lean](Ozaki/Width.lean), [Ozaki/Exact64.lean](Ozaki/Exact64.lean) |
| **A two-word accumulator suffices for the check.** Each scaled slice product rounded down to a `W`-bit window and added exactly: within `n 2^q` of the exact sum, an integer multiple of `2^q` with `\|N\| ≤ (s(s+1)/2)(k 2^W + 1)`; correct rounding holds with it, on both vendors, for binary32 and FP64. | `Ozaki.windowSum_error`, `Ozaki.ozaki1CRW_eq`, `Ozaki.ozaki1Window_register`, `Ozaki.ozaki1WindowEnclosure_settles`, `Ozaki.TC.tcOzaki1CRDW_eq`, `Ozaki.TC.tcOzaki1CRLW_eq`, `Ozaki.TC.v100_fp64CRW`, `Ozaki.MC.mcOzaki1CRDW_eq`, `Ozaki.MC.mcOzaki1CRLW_eq` | [Ozaki/Window.lean](Ozaki/Window.lean), [OzakiTC/LongDot.lean](OzakiTC/LongDot.lean), [OzakiMC/LongDot.lean](OzakiMC/LongDot.lean) |
| Split-K on Tensor Core blocks, exact for every length; with the chunk results in a `w`-bit register, exact while the products total less than `2^(w−1)`. | `Ozaki.TC.tcSplitK_exactOn`, `Ozaki.TC.tcSplitKReg_exactOn` | [OzakiTC/LongDot.lean](OzakiTC/LongDot.lean) |
| Ozaki-I's binary32 error bound for every `k`; FP64 emulation by Ozaki-I with binary64 recombination (`u = 2^-53`). | `Ozaki.TC.tcOzaki1L_error`, `Ozaki.TC.tcOzaki1D_error`, `Ozaki.MC.mcOzaki1L_error`, `Ozaki.MC.mcOzaki1D_error` | [OzakiTC/LongDot.lean](OzakiTC/LongDot.lean), [OzakiMC/LongDot.lean](OzakiMC/LongDot.lean) |
| **Correctly rounded binary32 GEMM of any inner dimension**, Ozaki-I and Ozaki-II, every engine product on the hardware model, the IEEE `rne32Q` on both vendors. | `Ozaki.TC.tcOzaki1CRL_eq`, `Ozaki.TC.tcOzaki2CRL_eq`, `Ozaki.MC.mcOzaki1CRL_eq`, `Ozaki.MC.mcOzaki2CRL_eq` | [OzakiTC/LongDot.lean](OzakiTC/LongDot.lean), [OzakiMC/LongDot.lean](OzakiMC/LongDot.lean) |
| **Correctly rounded FP64 GEMM** on fp16, bf16 and tf32 Tensor Cores and AMD matrix cores, binary64 inputs of any length, the IEEE `rne64` on both vendors. | `Ozaki.TC.tcOzaki1CRD_eq`, `Ozaki.TC.tcOzaki2CRD_eq`, `Ozaki.TC.v100_fp64CR`, `Ozaki.TC.a100BF16_fp64CR`, `Ozaki.MC.mcOzaki1CRD_eq`, `Ozaki.MC.mcOzaki2CRD_eq`, `Ozaki.MC.cdna3F16_fp64CR`, `Ozaki.MC.cdna3BF16_fp64CR` | [OzakiTC/LongDot.lean](OzakiTC/LongDot.lean), [OzakiMC/LongDot.lean](OzakiMC/LongDot.lean) |
| TensorCore's and MatrixCore's binary32 values, and TensorCore's binary64 values, are those of `Ozaki.Binary`. | `Ozaki.TC.finiteValue32_binary32`, `Ozaki.TC.fp64_binary64`, `Ozaki.MC.finiteValue32_binary32` | [OzakiTC/Rounding.lean](OzakiTC/Rounding.lean), [OzakiTC/LongDot.lean](OzakiTC/LongDot.lean), [OzakiMC/LongDot.lean](OzakiMC/LongDot.lean) |
| **Bounded registers.** A `w`-bit two's-complement register adds a list exactly when the magnitudes total less than `2^(w−1)`. Round to nearest even of `N 2^q` by a few integer comparisons, for every `N` and `q`. The sign and the round to nearest even of a sum of terms `v 2^e` by a top-down descent over windows of `W` bits, with ties, underflow and overflow, whenever `W > bitlen(n + 1) + p + 3`; the descent visits at most `E − m + 1` windows. | `Ozaki.fixedSum_eq`, `Ozaki.fixedSum_natAbs_le`, `Ozaki.roundExact_eq`, `Ozaki.roundByCmp_spec`, `Ozaki.signSum_eq`, `Ozaki.roundSum_eq`, `Ozaki.descend_sound`, `Ozaki.descend_parts_lt`, `Ozaki.query_natAbs_lt`, `Ozaki.descendAll_fuel_le` | [Ozaki/Bounded.lean](Ozaki/Bounded.lean), [Ozaki/SignOracle.lean](Ozaki/SignOracle.lean) |
| **Correctly rounded Ozaki-I in bounded integer arithmetic.** The check on a window sum in a register of `W + bitlen(n(k+2)) + 1` bits that never wraps, the exact path by the descent with windows of `bitlen(s² + 1) + p + 4` bits over terms at most the engine's budget, and the final rounding by comparisons. Each equals its rational counterpart, so the scheme is correctly rounded, on both vendors, for binary32 and FP64 inputs of any length. | `Ozaki.ozaki1CheckB_eq`, `Ozaki.ozaki1CheckB_register`, `Ozaki.ozaki1ExactPathB_eq`, `Ozaki.ozaki1ExactPathB_terms`, `Ozaki.ozaki1CRB_eq_CRW`, `Ozaki.ozaki1CRB_eq`, `Ozaki.ozaki1CRB64_eq`, `Ozaki.ozaki1CRB32_eq`, `Ozaki.TC.tcOzaki1CRBD_eq`, `Ozaki.TC.tcOzaki1CRBL_eq`, `Ozaki.TC.v100_fp64CRB`, `Ozaki.MC.mcOzaki1CRBD_eq`, `Ozaki.MC.mcOzaki1CRBL_eq` | [Ozaki/BoundedOzaki.lean](Ozaki/BoundedOzaki.lean), [OzakiTC/Bounded.lean](OzakiTC/Bounded.lean), [OzakiMC/Bounded.lean](OzakiMC/Bounded.lean) |
| **One rounding on both vendors.** Every scheme rounds with IEEE's round to nearest even. TensorCore's binary32 and binary64 roundings compute the same value (the same exponent, grid and ties-to-even step) and differ only in overflow: they return no result above the largest finite value, where IEEE rounds values within half an ulp of it down to it. So they agree with IEEE's up to the largest finite value, and every result they return is IEEE's. MatrixCore's binary32 rounding is IEEE's on every input. | `Ozaki.TC.signedRounded_eq_rneU`, `Ozaki.TC.round32ValueTC_eq`, `Ozaki.TC.add32_of_fp32Add`, `Ozaki.TC.binarySignedRounded_eq_rneU`, `Ozaki.TC.fp64RoundTC_eq`, `Ozaki.TC.fp64Round_of_TC`, `Ozaki.MC.rneValue_eq_rneU`, `Ozaki.MC.round32Value_eq_rne32Q` | [OzakiTC/Rounding.lean](OzakiTC/Rounding.lean), [OzakiTC/IEEE.lean](OzakiTC/IEEE.lean), [OzakiMC/IEEE.lean](OzakiMC/IEEE.lean) |
| **Slicing with integer operations, for every grid.** A binary vector given as significands and exponents `(m, e)` is sliced with integer shifts, a round-half-even division and exponent arithmetic, and the result equals the scheme's split for every vector, slice count and grid. Every coefficient is at most `2^b`, the remaining significands never grow (below `2^24` for binary32, `2^53` for binary64), and a division never needs more than `p + 2` bits: the widths depend on the format and `b`, never on the exponents. | `Ozaki.rneShift_eq`, `Ozaki.gridInt_eq`, `Ozaki.coeffInt_eq`, `Ozaki.splitInt_eq`, `Ozaki.splitInt_width`, `Ozaki.shiftPow_le`, `Ozaki.split_binary32_int`, `Ozaki.split_binary64_int` | [Ozaki/SliceInt.lean](Ozaki/SliceInt.lean) |
| **Signed zeros.** The specification is IEEE's: the correctly rounded sum, `−0` when a nonzero exact sum rounds to zero from below, and for an exact zero `−0` only when every product is `−0`. The signed check settles the sign from the enclosure when it lies on one side of zero, and otherwise from the exact path; correctly rounded Ozaki-I with a window accumulator returns the specified signed value on both vendors, for binary32 and FP64. | `Ozaki.certifySigned_eq`, `Ozaki.ozaki1CRWS_eq`, `Ozaki.TC.tcOzaki1CRDS_eq`, `Ozaki.TC.tcOzaki1CRLS_eq`, `Ozaki.MC.mcOzaki1CRDS_eq`, `Ozaki.MC.mcOzaki1CRLS_eq` | [Ozaki/SignedZero.lean](Ozaki/SignedZero.lean), [OzakiTC/Signed.lean](OzakiTC/Signed.lean), [OzakiMC/Signed.lean](OzakiMC/Signed.lean) |

## On the NVIDIA Tensor Core model

| What it says | Z3 | Lean name | File |
| --- | --- | --- | --- |
| Alignment loses nothing when every nonzero term is a multiple of `2^g` with exponent at most `g + F`. | | `Ozaki.TC.accumulator_eq_exactDot_of_grid` | [OzakiTC/Exactness.lean](OzakiTC/Exactness.lean) |
| A block of `b`-bit integers (`2b ≤ F`, `F ≥ 23`) with an integer `c` and `\|c\| + Σ\|aᵢbᵢ\| ≤ 2^24` returns `c + Σ aᵢbᵢ` exactly. | `I:[Z.4]`, `I:[E.4]` | `Ozaki.TC.evalBlock_int` | [OzakiTC/Exactness.lean](OzakiTC/Exactness.lean) |
| The same for a chain of blocks through their binary32 outputs. | | `Ozaki.TC.runBlocks_int` | [OzakiTC/Exactness.lean](OzakiTC/Exactness.lean) |
| Every integer of magnitude at most `2^(m+1)` is encoded exactly in a format with `m` stored bits. | `I:[Z.2]`, `I:[S1.11]` | `Ozaki.TC.encodeInt_spec` | [OzakiTC/Engine.lean](OzakiTC/Engine.lean) |
| The Tensor Core engine is exact on `b`-bit vectors whose products total at most `2^24`. | `I:[S2.1]`, `II:[S3.1]` | `Ozaki.TC.tcEngine_exactOn` | [OzakiTC/Engine.lean](OzakiTC/Engine.lean) |
| Every `\|z\| ≤ 2^11` (and every symmetric residue modulo `m ≤ 4096`) encodes to an fp16 word and back; products of fp16 values are binary32, so their multiplication is exact; binary32 addition of integers whose sum is at most `2^24` is exact. | `I:[E.1]`–`I:[E.4]`, `I:[Z.2]`–`I:[Z.4]`, `II:[E.1]`–`II:[E.4]`, `II:[Z.1]`–`II:[Z.3]`, `II:[S2.1]` | `Ozaki.TC.fp16_encodes_int`, `Ozaki.TC.fp16_encodes_residue`, `Ozaki.TC.fp16_product_exact`, `Ozaki.TC.fp32Add_int_exact` | [OzakiTC/Checks.lean](OzakiTC/Checks.lean) |
| The same on all eight GPU paths, with `b = 11` (fp16, tf32) or `b = 8` (bf16). | | `Ozaki.TC.v100_exactOn`, … | [OzakiTC/Profiles.lean](OzakiTC/Profiles.lean) |
| Binary32 round to nearest (IEEE's, and TensorCore's): `\|fl(q) − q\| ≤ 2^-24 \|q\| + 2^-150`. | `I:[S3.3]`, `II:[H.2]` | `Ozaki.TC.round32Value_within`, `Ozaki.TC.add32_within`, `Ozaki.TC.fp32Add_within` | [OzakiTC/Rounding.lean](OzakiTC/Rounding.lean) |
| The σ-trick computes `rne(a / 2^g) · 2^g` and an exact remainder for every binary32 `a` with `\|a\| ≤ 2^(g+b)`, grid `−149 ≤ g ≤ 104`, and `b ≤ 21`. | `I:[Z.1]`, `I:[S1.1]`–`I:[S1.8]` | `Ozaki.TC.sigma_split`, `Ozaki.TC.sigma_slice` | [OzakiTC/Split32.lean](OzakiTC/Split32.lean) |
| The remainder `a − rne(a/2^g) 2^g` is binary32 for every grid, so every residual of a binary32 vector is binary32. | `I:[S1.7]` | `Ozaki.TC.finiteValue32_sub_round`, `Ozaki.TC.splitFrom_binary32` | [OzakiTC/Split32.lean](OzakiTC/Split32.lean) |
| The whole split computed with binary32 σ-trick operations equals the scheme's split when every grid lies in `[−149, 104]`. | `I:[S1.13]` | `Ozaki.TC.splitFrom32_eq` | [OzakiTC/Split32.lean](OzakiTC/Split32.lean) |
| `2^e` is binary32 for `−149 ≤ e ≤ 127`; a scaled slice product and the Ozaki-II input scaling are binary32 when in range, so these multiplications are exact. | `I:[H.2]`, `I:[S3.2]`, `II:[H.3]`, `II:[S1.2]` | `Ozaki.TC.pow2_finiteValue32`, `Ozaki.TC.scaled_slice_product_exact`, `Ozaki.TC.exactTerm_finiteValue32`, `Ozaki.TC.scaleShift_exact32` | [OzakiTC/Scaling.lean](OzakiTC/Scaling.lean) |
| Ozaki-I and Ozaki-II on any path: exact Tensor Core calls, and the error bounds. | | `Ozaki.TC.tcOzaki1_eq`, `Ozaki.TC.tcOzaki1_error`, `Ozaki.TC.tcOzaki2_eq`, `Ozaki.TC.tcOzaki2_error` | [OzakiTC/Schemes.lean](OzakiTC/Schemes.lean) |
| The Z3 models' configuration on V100. | | `Ozaki.TC.v100_ozaki1_z3`, `Ozaki.TC.v100_ozaki2_z3` | [OzakiTC/Schemes.lean](OzakiTC/Schemes.lean) |
| Both schemes return a value: on any exact path under a magnitude bound, and in the Z3 configuration for entries up to `2^60`. | `I:[H.1]`, `II:[H.1]` | `Ozaki.TC.tcOzaki1_isSome`, `Ozaki.TC.tcOzaki2_isSome`, `Ozaki.TC.v100_ozaki1_z3_isSome`, `Ozaki.TC.v100_ozaki2_z3_isSome` | [OzakiTC/Success.lean](OzakiTC/Success.lean) |
| Native binary32 GEMM meets the classical bound `γₖ Σ\|xᵢyᵢ\|` (plus a subnormal term). | `I:[M.1]` | `Ozaki.TC.native32_error` | [OzakiTC/Native.lean](OzakiTC/Native.lean) |
| Binary32 and binary64 round to nearest return a nearest representable value and succeed on intervals. | | `Ozaki.TC.round32Value_nearest`, `Ozaki.TC.round32Value_intervals`, `Ozaki.TC.fp64Round_nearest`, `Ozaki.TC.fp64Round_intervals` | [OzakiTC/Correct.lean](OzakiTC/Correct.lean) |
| **Correctly rounded** Ozaki-I and Ozaki-II on any exact path; Ozaki-I with its exact path on Tensor Core blocks too, for binary32 inputs (`24` slices of `11` bits suffice). | | `Ozaki.TC.tcOzaki1CR_eq`, `Ozaki.TC.tcOzaki2CR_eq`, `Ozaki.TC.tcOzaki1CRE_eq`, `Ozaki.TC.v100_ozaki1CRE` | [OzakiTC/Correct.lean](OzakiTC/Correct.lean) |
| **Two passes recover a full group exactly**: pass 1 from `c = 0` gives `D1`, pass 2 from `c = −D1` gives `D2`, and `D1 + D2 = Σ aᵢbᵢ` whenever `K · 2^(2b) ≤ 2^(F+1)`; the engine built on it is exact for every length, with full groups on all eight paths (`11`-bit slices on fp16 and tf32, `8`-bit on bf16); Ozaki-I on it meets its error bound for every `k`. | | `Ozaki.TC.twoPass_exact`, `Ozaki.TC.tcEngine2_exactOn`, `Ozaki.TC.v100F16_exactOn2`, `Ozaki.TC.a100F16_exactOn2`, `Ozaki.TC.h100F16_exactOn2`, `Ozaki.TC.a100BF16_exactOn2`, `Ozaki.TC.h100BF16_exactOn2`, `Ozaki.TC.a100TF32_exactOn2`, `Ozaki.TC.h100TF32Wmma_exactOn2`, `Ozaki.TC.h100TF32Mma_exactOn2`, `Ozaki.TC.h100_ozaki1TP_error` | [OzakiTC/TwoPass.lean](OzakiTC/TwoPass.lean) |
| fp16 holds `2048` but not `4095`; `12`-bit magnitudes exceed the budget on V100; a full A100 group of `11`-bit products can exceed it; an A100 block is exact where binary32 additions are not. | `I:[Z.5]` | `Ozaki.TC.fp16_not_4095`, `Ozaki.TC.v100_twelve_bit_magnitudes`, `Ozaki.TC.a100_full_group`, `Ozaki.TC.a100_exact_where_binary32_is_not` | [OzakiTC/Limits.lean](OzakiTC/Limits.lean) |
| INT8 × INT8 → INT32 in a 32-bit wrapping register (TC-EFT's `machineAccumulate`) over exact integer products is exact on byte operands; a 16-bit register wraps. This is not a model of an INT8 Tensor Core instruction. | `ADP:[Z.1]`, `ADP:[Z.2]` | `Ozaki.TC.int8Dot_bytes`, `Ozaki.TC.int8Dot_16_wraps` | [OzakiTC/Int8.lean](OzakiTC/Int8.lean) |
| Ozaki-I on the INT8 engine: the slice products recombine exactly to the fixed-point product, so the result is one binary64 rounding of it. | `ADP:[E.3]`, `ADP:[R.1]` | `Ozaki.TC.int8Recombine_eq`, `Ozaki.TC.int8Ozaki_eq` | [OzakiTC/Int8.lean](OzakiTC/Int8.lean) |

### The ADP pipeline on the INT8 engine

`Ozaki.TC.adp` is the routine of the Z3 model `adp.py`, in its order: scan for non-finite inputs,
matrix ESC (unbounded sends the product to native binary64), `W = 53 + ESC + 1`, the slice count,
the heuristic `s² ≤ ratio`, then emulation on TC-EFT's INT8 engine, or native binary64 otherwise. On
the five cases recorded from the unmodified Z3 model (three emulated, one sent to native binary64 by
its ESC, one non-finite) it returns the same path and values ([tests](tests/README.md)).

| What it says | Z3 | Lean name |
| --- | --- | --- |
| A binary64 word is `m 2^(e−52)` with `\|m\| < 2^53`, and `\|v\| < 2^(e+1)`. | `ADP:[D.1]`–`ADP:[D.3]` | `Ozaki.TC.value64_onGrid`, `Ozaki.TC.value64_bound` |
| Binary64 round to nearest (IEEE's): `\|fl(q) − q\| ≤ 2^-53 \|q\| + 2^-1075`; it fails exactly when the rounded magnitude exceeds the largest finite value, as in IEEE. | `ADP:[R.2]` | `Ozaki.TC.fp64Round_within`, `Ozaki.TC.fp64Round_none_iff` |
| `W = 53 + ESC + 1`, and the slice count is the least that holds `W` bits. | `ADP:[B.1]`, `ADP:[B.2]` | `Ozaki.TC.adpWidth`, `Ozaki.TC.slicesNeeded_spec` |
| The matrix ESC is at least every entry's ESC. | `ADP:[X.6]` | `Ozaki.TC.matrixEsc_ge` |
| A slice is an 8-bit pattern; one emulated entry is the binary64 rounding of the fixed-point product. | `ADP:[E.1]`, `ADP:[E.3]`, `ADP:[R.1]` | `Ozaki.TC.int8_pattern`, `Ozaki.TC.emulEntry_eq` |
| An emulated entry meets P.1 and Grade A; a native entry meets the `γₖ` bound. | `ADP:[P.1]`, `ADP:[P.2]`, `ADP:[N.1]` | `Ozaki.TC.emulEntry_P1`, `Ozaki.TC.emulEntry_gradeA`, `Ozaki.TC.nativeEntry_error` |
| The guardrails: non-finite inputs go to the native path, and emulation runs only on finite inputs with a finite ESC and `s² ≤ ratio`. | `ADP:[G.1]`–`ADP:[G.3]` | `Ozaki.TC.adp_nonfinite_iff`, `Ozaki.TC.adp_emulated` |
| **The whole routine.** Whenever `adp` returns values, on normal or zero entries of matching shapes with `k · 2^14 < 2^31`, every entry meets Grade A on the emulated path and the `γₖ` bound on the native path. | `ADP:[P.2]`, `ADP:[N.1]` | `Ozaki.TC.adp_accuracy` |
| **A guardrail for subnormal inputs.** `adpSafe` sends inputs with a nonzero entry below `2^-1022` to the native path; whenever it emulates, every entry is normal or zero, and whenever it returns values, every entry meets Grade A on the emulated path and the `γₖ` bound on the native path, with no normality hypothesis. On the five recorded Z3 cases it returns what `adp` returns. | `ADP:[P.2]`, `ADP:[N.1]` | `Ozaki.TC.adpSafe_emulated_normal`, `Ozaki.TC.nativeGemm64_accuracy`, `Ozaki.TC.adpSafe_accuracy` |
| **The routine returns values** for finite inputs of matching shapes with `k · 2^14 < 2^31` and every `Σ\|xᵢyᵢ\| ≤ 2^1000` (a sufficient bound, not a sharp one); `adp` needs normal or zero entries, `adpSafe` does not. | | `Ozaki.TC.adp_isSome`, `Ozaki.TC.adpSafe_isSome` |
| **Correctly rounded fixed-point Ozaki-I as in ADP**: with given `(s, W)` that fit and `k · 2^14 < 2^31`, `adpCR` returns the binary64 round to nearest of `x · y` for every input; it falls back to the exact rational product, and it is not the ESC-driven routine. | | `Ozaki.TC.adpCR_eq` |
| **The same with every product on the INT8 engine, any length.** The INT8 engine with split-K is exact on `6`-bit slices for every length; the fixed-point enclosures run on it with split-K too; and the exact path is Ozaki-I with all slice products of `6`-bit slices on it, at most `smax` slices with `7 smax > 2098`. | | `Ozaki.TC.int8SplitK_exactOn`, `Ozaki.TC.int8DotK_exact`, `Ozaki.TC.adpEnclosureK_sound`, `Ozaki.TC.adpCRE_eq` |

All of these are in [OzakiTC/ADP.lean](OzakiTC/ADP.lean), except `adpCR_eq` in
[OzakiTC/Correct.lean](OzakiTC/Correct.lean) and the guardrail, success and `adpCRE` results in
[OzakiTC/ADPFix.lean](OzakiTC/ADPFix.lean).

## On the AMD matrix-core model

| What it says | Z3 | Lean name | File |
| --- | --- | --- | --- |
| Binary32 round to nearest returns every binary32 value, and every integer of magnitude at most `2^24`, unchanged, with or without flushing subnormals. | | `Ozaki.MC.rneValue_of_finite`, `Ozaki.MC.flValue_int` | [OzakiMC/Exactness.lean](OzakiMC/Exactness.lean) |
| CDNA 2's pairwise tree on integers within `2^24` is their exact sum. | | `Ozaki.MC.pairTree_int` | [OzakiMC/Exactness.lean](OzakiMC/Exactness.lean) |
| On `correct_rounding`, `pair_wise_sum` and `global_alignment`, `S_acc` of integer operands is the exact sum. | | `Ozaki.MC.accumulate_int` | [OzakiMC/Exactness.lean](OzakiMC/Exactness.lean) |
| A block, a chain of blocks, and an inner product of any length return `c + Σ aᵢbᵢ` exactly when `\|c\| + Σ\|aᵢbᵢ\| ≤ 2^24`. | `I:[Z.4]`, `I:[E.4]` | `Ozaki.MC.evalBlock_int`, `Ozaki.MC.runBlocks_int`, `Ozaki.MC.dotBits_int` | [OzakiMC/Exactness.lean](OzakiMC/Exactness.lean) |
| `encodeExact` encodes every integer of magnitude at most `2^(p+1)`; XF32 keeps every integer up to `2^11`. | `I:[Z.2]`, `I:[S1.11]` | `Ozaki.MC.encodeExact_int`, `Ozaki.MC.xf32_encodesInts` | [OzakiMC/Engine.lean](OzakiMC/Engine.lean) |
| The matrix-core engine is exact on `b`-bit vectors whose products total at most `2^24`. | `I:[S2.1]`, `II:[S3.1]` | `Ozaki.MC.mcEngine_exactOn` | [OzakiMC/Engine.lean](OzakiMC/Engine.lean) |
| The same on SFMA (`b ≤ 24`), CDNA 1, 2 and 3 fp16 and CDNA 3 XF32 (`b ≤ 11`), and the bf16 paths (`b ≤ 8`). | | `Ozaki.MC.cdna3F16_exactEngine`, … | [OzakiMC/Profiles.lean](OzakiMC/Profiles.lean) |
| Binary32 round to nearest: `\|fl(q) − q\| ≤ 2^-24 \|q\| + 2^-150`. | `I:[S3.3]`, `II:[H.2]` | `Ozaki.MC.round32Value_within`, `Ozaki.MC.fp32Add_within` | [OzakiMC/Rounding.lean](OzakiMC/Rounding.lean) |
| Scaled slice products and the Ozaki-II input scaling are exact in range. | `I:[S3.2]`, `II:[S1.2]` | `Ozaki.MC.scaled_slice_product_exact`, `Ozaki.MC.scaleShift_exact32` | [OzakiMC/Scaling.lean](OzakiMC/Scaling.lean) |
| Both schemes return a value under a magnitude bound, and in the Z3 configuration on CDNA 3 fp16. | `I:[H.1]`, `II:[H.1]` | `Ozaki.MC.mcOzaki1_isSome`, `Ozaki.MC.mcOzaki2_isSome`, `Ozaki.MC.cdna3F16_ozaki1_z3_isSome` | [OzakiMC/Success.lean](OzakiMC/Success.lean) |
| Native binary32 GEMM meets the classical bound. | `I:[M.1]` | `Ozaki.MC.native32_error` | [OzakiMC/Native.lean](OzakiMC/Native.lean) |
| **Correctly rounded** Ozaki-I and Ozaki-II on any exact path, and Ozaki-I with its exact path on matrix-core blocks for binary32 inputs. MatrixCore's rounding is IEEE's, the rounding the Tensor Core side uses (`Ozaki.MC.round32Value_eq_rne32Q`). | | `Ozaki.MC.round32Value_nearest`, `Ozaki.MC.mcOzaki1CR_eq`, `Ozaki.MC.mcOzaki2CR_eq`, `Ozaki.MC.mcOzaki1CRE_eq` | [OzakiMC/Correct.lean](OzakiMC/Correct.lean) |
| Ozaki-I and Ozaki-II on any exact path, and the Z3 models' configuration on CDNA 1, 2 and 3 fp16. | | `Ozaki.MC.mcOzaki1_eq`, `Ozaki.MC.mcOzaki1_error`, `Ozaki.MC.mcOzaki2_eq`, `Ozaki.MC.mcOzaki2_error`, `Ozaki.MC.cdna3F16_ozaki1_z3`, … | [OzakiMC/Schemes.lean](OzakiMC/Schemes.lean) |
| bf16 holds `256` but not `2047`; a full CDNA 3 group of `11`-bit products can exceed the budget; the fp16 paths are exact where the SFMA is not. | | `Ozaki.MC.bfloat16_holds_256`, `Ozaki.MC.cdna3F16_full_group`, `Ozaki.MC.fp16_exact_where_sfma_is_not` | [OzakiMC/Limits.lean](OzakiMC/Limits.lean) |

## Not proved

- That real GPUs behave like the models; see TC-EFT's and Matrix-Core's validation.
- FP8 paths: CDNA 3's `odd_even_grouping`, and no FP8 Tensor Core path exists in `TensorCore`. The
  INT8 engine is a wrapping register over exact integer products, not an INT8 instruction model,
  and there is no INT8 engine on the AMD side.
- The Z3 models' measured comparisons (`I:[M.2]`, `I:[M.3]`, `II:[M.2]`, `II:[M.3]`) are checked
  on their test matrices ([tests](tests/README.md)), not proved: they are not true for every input.
- ADP: the naive signed-byte encoding (`[U.6]`, only slice counts), and the Z3 model's test-level
  checks `[T.1]`–`[T.14]`, of which the recorded cases cover `[T.6]`, `[T.8]` and `[T.9]`. Grade A
  fails for some subnormal inputs of `adp` as modelled; the extra guardrail of `adpSafe` restores
  it, but cuBLAS's own handling of subnormals is not modelled.
- TensorCore's own binary32 and binary64 roundings fail above the largest finite value, where
  IEEE rounds values below `2^128 − 2^103` (binary64: `2^1024 − 2^970`) down to it. The schemes use
  IEEE's rounding, so this affects only the statements made with TensorCore's operations: the
  σ-trick (`splitFrom32_eq`, with `fp32Add`) and `int8Ozaki`, which returns TensorCore's binary64
  word.
- The integer side, partly. `ozaki1CRB` runs Ozaki-I's check, exact path and final rounding in
  bounded integer registers and is proved equal to the rational scheme, but it slices with the
  rational `split`; the integer slicing `splitInt` is proved equal to `split` separately, not
  composed with it into one function. No single theorem bounds every intermediate integer of
  `ozaki1CRB`: the widths are proved register by register (window sums, residuals, window parts,
  query terms), and the comparison rounding's internal integers (about `p + 3` bits) only inside
  its proof. Exponents and grids are unbounded integers in the model, and the number of windows
  the descent visits grows with the exponent range. Ozaki-II's and ADP's checks are exact rational
  arithmetic. The binary32 σ-trick is proved only for grids in `[2^-149, 2^104]`.
- Signed zeros are modelled for correctly rounded Ozaki-I with a window accumulator
  (`ozaki1CRWS`); the other variants return rationals, which have one zero.

These blocks keep every name above connected to the actual API. `TensorCore` and `MatrixCore`
cannot be imported together, so there is one block for each model:

```lean
import OzakiTC

open Ozaki Ozaki.TC Ozaki.ADP

#check @split_dot
#check @split_coeff_bound
#check @split_grid_le
#check @split_residual_le
#check @splitExp_spec
#check @trianglePairs_length
#check @ozaki1_eq_sumWith
#check @dot_eq_exactTerms_add
#check @exactTerms_error
#check @exactTerms_error_normwise
#check @sumWith_error
#check @ozaki1_error
#check @scaleTrunc_bound
#check @symMod_bounds
#check @dvd_dotZ_symMod
#check @crt_eq
#check @ozaki2_eq
#check @truncProduct_error
#check @truncProduct_error_normwise
#check @ozaki2_error
#check @z3_slice_budget
#check @z3Basis_valid
#check @z3_bits
#check @crt_fails_at_23
#check @remap_value
#check @remap_s8
#check @remap_bit_pattern
#check @remap_range_smaller
#check @slices_53
#check @coarseEst_le
#check @skipZeros_unsafe
#check @field0_unsafe
#check @full_fidelity
#check @full_fidelity_without_plus_one
#check @term_error
#check @funnel
#check @funnel_needs_plus_one
#check @slice_recombination
#check @accumulator_eq_exactDot_of_grid
#check @evalBlock_int
#check @runBlocks_int
#check @encodeInt_spec
#check @tcEngine_exactOn
#check @v100_exactOn
#check @round32Value_within
#check @fp32Add_within
#check @sigma_split
#check @sigma_slice
#check @finiteValue32_sub_round
#check @splitFrom_binary32
#check @splitFrom32_eq
#check @tcOzaki1_eq
#check @tcOzaki1_error
#check @tcOzaki2_eq
#check @tcOzaki2_error
#check @v100_ozaki1_z3
#check @v100_ozaki2_z3
#check @fp16_not_4095
#check @v100_twelve_bit_magnitudes
#check @a100_full_group
#check @a100_exact_where_binary32_is_not
#check @int8Dot_bytes
#check @int8Dot_16_wraps
#check @int8Ozaki_eq
#check @slice_product_bound
#check @scaleShift_spec
#check @natAbs_truncProduct_le
#check @natAbs_residueProduct_le
#check @z3_residue_budget
#check @crt_dvd_sub
#check @ozaki1_isSome
#check @ozaki2_isSome
#check @nativeDot_error
#check @nativeDot_error_gamma
#check @Ozaki.ADP.floorDigits_bytes
#check @Ozaki.ADP.fixed_range
#check @Ozaki.ADP.dominant_exact
#check @Ozaki.ADP.term_bound
#check @Ozaki.ADP.escCoarse_ge
#check @Ozaki.ADP.blockRep_bounds
#check @Ozaki.ADP.fixedPoint_error
#check @Ozaki.ADP.emulated_gradeA
#check @round_monotone
#check @round_eq_of_enclosure
#check @certify_eq
#check @dot_approx_error
#check @ozaki1CR_eq
#check @ozaki2CR_eq
#check @split_residual_zero
#check @ozaki1Full_eq
#check @ozaki1CRE_eq
#check @fp16_encodes_int
#check @fp16_product_exact
#check @fp32Add_int_exact
#check @scaled_slice_product_exact
#check @scaleShift_exact32
#check @tcOzaki1_isSome
#check @v100_ozaki1_z3_isSome
#check @native32_error
#check @round32Value_nearest
#check @fp64Round_nearest
#check @tcOzaki1CR_eq
#check @tcOzaki2CR_eq
#check @tcOzaki1CRE_eq
#check @v100_ozaki1CRE
#check @Ozaki.TC.value64_onGrid
#check @Ozaki.TC.fp64Round_within
#check @Ozaki.TC.slicesNeeded_spec
#check @Ozaki.TC.matrixEsc_ge
#check @Ozaki.TC.emulEntry_gradeA
#check @Ozaki.TC.nativeEntry_error
#check @Ozaki.TC.adp_emulated
#check @Ozaki.TC.adp_accuracy
#check @adpCR_eq
#check @chunked_exactOn
#check @roundEnclosure_of_margin
#check @ozaki1Enclosure_settles
#check @ozaki2CRE_eq
#check @roundRNE_nearest
#check @rne64_nearest
#check @rne32Q_nearest
#check @vanish32Q
#check @vanish64
#check @exactTerms_sum_register
#check @exactTerms_sum_register32
#check @tcSplitK_exactOn
#check @tcSplitKReg_exactOn
#check @tcOzaki1L_error
#check @tcOzaki1D_error
#check @tcOzaki1CRL_eq
#check @tcOzaki2CRL_eq
#check @tcOzaki1CRD_eq
#check @tcOzaki2CRD_eq
#check @v100_fp64CR
#check @a100BF16_fp64CR
#check @finiteValue32_binary32
#check @fp64_binary64
#check @twoPass_exact
#check @tcEngine2_exactOn
#check @a100F16_exactOn2
#check @h100F16_exactOn2
#check @h100_ozaki1TP_error
#check @windowSum_error
#check @ozaki1CRW_eq
#check @ozaki1Window_register
#check @ozaki1WindowEnclosure_settles
#check @tcOzaki1CRDW_eq
#check @tcOzaki1CRLW_eq
#check @v100_fp64CRW
#check @round32ValueTC_eq
#check @add32_of_fp32Add
#check @fp64RoundTC_eq
#check @fp64Round_of_TC
#check @fp64Round_none_iff
#check @v100F16_exactOn2
#check @h100TF32Mma_exactOn2
#check @int8Recombine_eq
#check @adpSafe_accuracy
#check @adp_isSome
#check @adpSafe_isSome
#check @int8SplitK_exactOn
#check @adpCRE_eq
#check @splitInt_eq
#check @splitInt_width
#check @split_binary32_int
#check @split_binary64_int
#check @certifySigned_eq
#check @ozaki1CRWS_eq
#check @tcOzaki1CRDS_eq
#check @tcOzaki1CRLS_eq
#check @fixedSum_eq
#check @roundExact_eq
#check @signSum_eq
#check @roundSum_eq
#check @descendAll_fuel_le
#check @ozaki1CheckB_eq
#check @ozaki1CheckB_register
#check @ozaki1ExactPathB_eq
#check @ozaki1CRB_eq_CRW
#check @ozaki1CRB_eq
#check @ozaki1CRB64_eq
#check @ozaki1CRB32_eq
#check @tcOzaki1CRBD_eq
#check @tcOzaki1CRBL_eq
#check @v100_fp64CRB
```

```lean
import OzakiMC

open Ozaki Ozaki.MC

#check @rneValue_of_finite
#check @flValue_int
#check @pairTree_int
#check @accumulate_int
#check @evalBlock_int
#check @runBlocks_int
#check @dotBits_int
#check @encodeExact_int
#check @xf32_encodesInts
#check @mcEngine_exactOn
#check @cdna3F16_exactEngine
#check @round32Value_within
#check @fp32Add_within
#check @mcOzaki1_eq
#check @mcOzaki1_error
#check @mcOzaki2_eq
#check @mcOzaki2_error
#check @cdna3F16_ozaki1_z3
#check @bfloat16_holds_256
#check @cdna3F16_full_group
#check @fp16_exact_where_sfma_is_not
#check @scaled_slice_product_exact
#check @mcOzaki1_isSome
#check @native32_error
#check @round32Value_nearest
#check @mcOzaki1CR_eq
#check @mcOzaki2CR_eq
#check @mcOzaki1CRE_eq
#check @mcSplitK_exactOn
#check @mcOzaki1L_error
#check @mcOzaki1D_error
#check @mcOzaki1CRL_eq
#check @mcOzaki2CRL_eq
#check @mcOzaki1CRD_eq
#check @mcOzaki2CRD_eq
#check @cdna3F16_fp64CR
#check @cdna3BF16_fp64CR
#check @mcOzaki1CRDW_eq
#check @mcOzaki1CRLW_eq
#check @round32Value_eq_rne32Q
#check @mcOzaki1CRDS_eq
#check @mcOzaki1CRLS_eq
#check @mcOzaki1CRBD_eq
#check @mcOzaki1CRBL_eq
```
