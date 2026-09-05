# Parameterized invocation contract

The numerical unit is one dot product, not a tile or a multi-group instruction. This is the
full interface the generalized model should satisfy. The active subset, per
[PLAN.md](PLAN.md), is FP16 inputs, FP32 c in the common alignment, raw products,
`F = 23 + extraBits`, any positive `K`, an optional floor, and one final FP32 truncation.
Everything else below describes deferred interfaces, and each increment must state the
subset it actually proves.

## Inputs and descriptions

A description fixes the operand value format and storage, the c format, the product count
`K`, preparation policies, the accumulation variant, and ordered output stages. Encoded input
holds exactly `K` pairs and one c word. Formats need a nonempty normal exponent interval, a
positive significand precision, and a specified special-encoding policy. Storage conversion
is separate from value decoding: TF32 register bits are not a packed 19-bit encoding.

The finite reference rejects nonfinite encodings and invalid parameters. It does not
implement NaN propagation, saturation, exception flags, or the full overflow interval of
IEEE arithmetic. Each conversion boundary requires its exact input magnitude to be at most
that format's maximum finite value. Underflow uses subnormals and a stated signed-zero policy.

The independently decoded ideal is

```text
S = value(c_original) + Σ value(a_original_i) · value(b_original_i)
```

and must not call the raw-product, alignment, output, or correction code. Preparation has its
own ideal `S_prepared` and loss `S − S_prepared`. Exact format changes have zero loss but can
change raw scale metadata, and the prepared representation determines alignment.

## Accumulation variants

**Aligned block.** Multiply signed integer significands and add raw scales and fractional
widths, keeping that metadata. Select η from the nonzero member terms, then apply the
optional floor. c belongs either to this group or to an explicit later stage. The all-zero
group uses a dummy grid and a proved zero result.

For each member term `T`, `z = sign(T)·floor(|T| / qA)` with `qA = 2^(η − F)`, and
`A = Σ z · qA` in exact signed integers with no hidden normalization. Every alignment loss
`T − z·qA` is recorded and has magnitude strictly below `qA`.

Integer capacity is a refinement obligation, not a knob that wraps the reference. A w-bit
implementation uses explicit signed `BitVec` words and additions; prove equivalence under
the signed range condition, derive a conservative width from the member count and per-term
bounds, and prove safe prefixes as well as the final sum, since cancellation cannot justify
intermediate capacity.

**Fused scalar.** For `K = 1`, form the exact prepared `a·b + c` and convert once, with no
truncating alignment stage. FP64 FMA uses this variant with its chosen rounding direction.
Chains of such invocations are downstream work.

## Ordered boundaries and c

An output stage names a format and rounding direction, converts, and decodes the returned
bits; the next stage receives the decoded value. A sequence is never collapsed into a direct
conversion without an equivalence proof. For late c, the product-sum conversion precedes the
exact addition of prepared c, then a separately specified conversion follows. Every stage has
its own finite-range condition; a final in-range answer does not establish intermediate range.

The trace exposes accepted prepared operands, raw terms, η and grid, integer coefficients,
and every conversion or addition boundary. Its public output has the declared final format.
Retained exact residuals are a reference construction, not a scalar EFT or an efficient
hardware extractor.

## Required theorem layers

1. **Representation.** Decoding values, raw-product preservation, bounded encoding, round
   trips and fixed points, output representability, and finite-domain correctness for each
   rounding mode. Numerical zero equivalence is distinct from bitwise equality.
2. **Execution.** Successful evaluation certifies parameter and input validity,
   original-to-prepared correspondence, the prescribed exponent selection and accumulation,
   every actual encoded stage, and the final output. V100 is recovered from `evalBlock` by
   proof, including rejection behavior.
3. **Local arithmetic.** Common-grid sum, signed-capacity refinement, alignment loss bounds,
   output-stage rounding bounds, and their composed error bound.
4. **Exact loss accounting.** The original ideal equals the returned value plus the sum of
   preparation, alignment, and output-stage losses. This telescoping identity accompanies the
   execution and rounding theorems; on its own it constrains no output.
5. **Evidence.** Independent numerical checks over formats, precision and floor, zero and
   subnormal branches, carries and cancellation, c placement, and output-stage order. Device
   comparisons carry their own path and input-domain provenance.

A row of the feature matrix counts as supported only when all applicable layers exist for
it, not when the generic record can name it.
