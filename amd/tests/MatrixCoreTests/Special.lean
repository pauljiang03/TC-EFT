import MatrixCoreTests.Support

/-! # Special values

Infinities and NaN detected at the input, including products that overflow before accumulation.
These cases arise in chained inner products, where an earlier block's infinity becomes `c`. -/

namespace MatrixCoreTests.Special

open MatrixCore

/-- `p = 2^65 · (−2^65) = −2^130`. -/
abbrev negOverflow : In × In := (.v (p2 65), .v (-p2 65))

/-- CDNA 3: `c = +∞` with a product `≤ −2^128` gives NaN. -/
example : observe cdna3BF16 [negOverflow] (.inf false) = some .nan := by decide +kernel

/-- CDNA 3: the infinity takes the sign of the overflowing product, not of the largest product. -/
example : observe cdna3BF16 [negOverflow, (1, 1)] (0 : ℚ) = some (.inf true) := by decide +kernel

/-- CDNA 3: a NaN `c` stays NaN when a product overflows; an infinite `c` and an overflowing
product of the same sign give that infinity. -/
example : observe cdna3BF16 [negOverflow] .nan = some .nan ∧
    observe cdna3BF16 [((p2 65 : ℚ), (p2 65 : ℚ))] (.inf false) = some (.inf false) ∧
    observe cdna3BF16 [negOverflow] (.inf true) = some (.inf true) := by decide +kernel

/-- NaN operands in every format. -/
example : observe cdna3F16 [(.nan, 1)] (0 : ℚ) = some .nan ∧
    observe (cdna3FP8 e4m3fnuz e4m3fnuz) [(.nan, 1)] (0 : ℚ) = some .nan ∧
    observe cdna3XF32 [(1, .nan)] (0 : ℚ) = some .nan := by decide +kernel

/-- CDNA 2: the binary32 conversion of `−2^130` overflows; with `c = +∞` the result is NaN. -/
example : observe cdna2BF16 [negOverflow] (.inf false) = some .nan := by decide +kernel

/-- CDNA 1: products may exceed `2^128`; with `c = +∞` the result is `+∞`. -/
example : observe cdna1BF16 [negOverflow] (.inf false) = some (.inf false) := by decide +kernel

/-- A chained inner product: the first block overflows to `+∞`, which meets an overflowing
negative product in the second block. -/
example : observe cdna3BF16
    ((In.v (p2 65), In.v (p2 65)) :: List.replicate 7 ((0 : In), (0 : In)) ++ [negOverflow])
    (0 : ℚ) =
    some .nan := by decide +kernel

end MatrixCoreTests.Special
