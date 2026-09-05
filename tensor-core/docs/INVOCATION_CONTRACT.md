# Parameterized single-invocation contract

The numerical unit is one dot product, not a tile or a multiple-group instruction.
This contract refines [CURRENT_PLAN.md](CURRENT_PLAN.md) and the source decisions
in [FEATURE_COVERAGE.md](FEATURE_COVERAGE.md). It describes the required full
interface; each implementation increment must identify the subset actually proved.

## Inputs and supported descriptions

A description fixes the operand **value format and storage**, c format, product
count K, preparation policies, accumulation variant, and ordered output stages.
Encoded input contains exactly K pairs and one c word. Formats must have a
nonempty normal exponent interval, a positive significand precision, and a
specified special-encoding policy. Storage conversion is separate from value
decoding. In particular, TF32 register bits cannot be treated as packed tf19.

The finite reference rejects nonfinite encodings and invalid parameters. It
does not implement NaN propagation, saturation, exception flags, or the full
overflow acceptance interval of IEEE arithmetic. Conversion at each boundary
requires its exact input magnitude to be at most that format's maximum finite
value. Underflow uses subnormals and a specified signed-zero policy.

The independently decoded ideal is

`S = value(c_original) + sum(value(a_original_i) * value(b_original_i))`.

It must not call the raw-product, alignment, output, or correction evaluator.
Preparation has a separately defined ideal S_prepared and loss S-S_prepared.
Exact format changes have zero numerical loss but may change raw scale metadata;
the prepared representation determines subsequent alignment.

## Accumulation variants

**Aligned block.** Multiply signed integer significands, add raw scales and
fractional widths. Preserve that metadata. Select eta from nonzero member terms,
then apply the optional floor. c belongs either to this group or to an explicit
later stage. For the all-zero group use a dummy grid and prove zero result.

For each member term T, set `z = sign(T) floor(abs(T)/qA)` and
`qA = 2^(eta-F)`. Set `A = sum(z) * qA` using exact signed integers. No
intermediate normalization is hidden in this sum. Record every alignment loss
`T-z*qA`, with absolute value strictly less than qA.

Integer capacity is a refinement obligation, not a numerical knob that silently
wraps the reference. A w-bit implementation uses explicit signed BitVec words
and additions. Prove equivalence under the signed range condition and derive a
conservative width from member count and per-term magnitude bounds. Prove safe
prefixes as well as final sum: cancellation cannot justify intermediate capacity.

**Fused scalar.** For K=1, compute the exact prepared a*b+c and then convert once.
There is no truncating alignment stage. FP64 FMA consumes this variant, with its
chosen rounding direction. A serial chain of such invocations is downstream work.

## Ordered boundaries and c

An output stage specifies a format and rounding direction, executes conversion,
and decodes the returned bits. The next stage receives that decoded value. A
sequence is never collapsed to direct conversion without an equivalence proof.
For late c, product-sum conversion precedes the exact addition of prepared c,
then a separately specified conversion follows. Every stage has its own finite
range condition; a final in-range answer does not establish intermediate range.

The returned trace must expose accepted prepared operands, raw terms, eta/grid,
integer coefficients, and all conversion/addition boundaries. Its public output
has the declared final format. Traces may retain exact reference residuals;
that is not an implementation of a scalar FP EFT or efficient hardware extractor.

## Required theorem layers

1. **Representation.** Classification/decoding values, raw-product preservation,
   bounded encoding, round trips/fixed points, output representability, and
   finite-domain correctness for each rounding mode. Distinguish numerical zero
   equivalence from bitwise equality.
2. **Execution.** Successful evaluation certifies parameter/input validity,
   original-to-prepared correspondence, prescribed exponent selection and
   accumulation, every actual encoded stage, and final output. Prove V100
   specialization against `evalBlock`, including rejection behavior.
3. **Local arithmetic.** Common-grid sum, signed-capacity refinement, alignment
   loss bounds, output-stage rounding bounds, and their composed error bound.
4. **Exact loss accounting.** Original ideal equals returned value plus the sum
   of preparation, alignment, and all output-stage losses. This telescoping
   identity must accompany execution and rounding theorems: it alone places
   no constraint on which output an evaluator returns.
5. **Evidence.** Independent numerical checks exercise formats, precision/floor,
   zero/subnormal branches, carries/cancellation, c placement, and output-stage
   order. Device comparisons have their own path/input-domain provenance.

The full gate is closed only when the coverage matrix's claimed supported rows
have all applicable layers, not when the generic record can name them. Unresolved
architecture profiles remain visible while generic mathematical stages can be
implemented and proved without assigning them to a GPU.
