# Program language

A term elaborator and verification/diagnostic commands sit on top of the ordinary block semantics. The verified
object is a schedule of normalization groups. It is not a PTX instruction, a fragment
layout, or a kernel; see [COMPOSITION.md](COMPOSITION.md).

## Writing and verifying a program

```lean
import TensorCore.Meta.Syntax
open TensorCore

def threeAdds : Program v100F16F32 := tc%{
  repeat (3) {
    block "add 1" [(0x3c00, 0x3c00), (0, 0), (0, 0), (0, 0)];
  }
}

tc_verify threeAdds_correct : threeAdds from 0
tc_inspect threeAdds from 0
```

Each pair is two encoded FP16 operands; the initial accumulator and every block output are
FP32. `block` checks that literals fit the profile's word width and that the group has the
required number of pairs; malformed groups fail at elaboration. A typed `BlockOperands p`
value can be passed with `call "label" operands;`. `tc_verify` bounds-checks a bare or
parenthesized initial numeral before building its FP32 bits; any other initial expression
keeps its ordinary Lean meaning.

`lake env lean examples/SingleInvocation.lean` runs one V100 group: raw output `4107ffff`,
ideal `17/2 − 2^-24`, residual `15 · 2^-24`, corrected `41080000`.
`lake env lean examples/Verify.lean` runs the two-block cancellation example: outputs
`4107ffff`, `b5800000`; recovered ideal −2^-24; corrected `b3800000`.

## Meaning of the generated theorem

`Program p` has `skip`, `block`, `seq`, and `repeat`. `Program.blocks` exposes the ordered
schedule and `Program.run` executes it with `runBlocks`, feeding each output's bits to the
next call. For the `tc_verify` contract, the program runs its blocks first; one final reference correction combines all
residuals with the last output in exact `Rat` arithmetic and applies nearest-even FP32
conversion. Nothing corrects an intermediate accumulator or replaces an operation with a
scalar FP32 addition.

`Program.ideal` decodes the original operand bits and sums the exact products; it never reads
model outputs. `Program.VC program c` requires a finite initial encoding, success of every
executed call, and a recovered exact sum with magnitude at most `maxFinite32`.
`Program.vc_sound` proves these conditions imply `Program.Correct`: execution succeeds, the
ledger recovers the original-input ideal, and the correction returns its nearest-even FP32
encoding. The theorem keeps the model's domain; it says nothing about GPU conformance or an
efficient scalar correction.

## Certifying raw-output accuracy

`import TensorCore.Meta.Certify` adds:

```lean
tc_certify dot_accurate : dot from 0x3f800000 scale 1 carry 3 within (1 / 2048)
tc_certificate dot from 0x3f800000 scale 1 carry 3 within (1 / 2048)
```

The first command emits `Program.Accurate dot initial tolerance`: there is a successful
run, an independently decoded ideal, and the final uncorrected output differs from that
ideal by at most the requested absolute tolerance. It applies
`Program.staticCertificate_sound` to a kernel reduction proof, or a supplied proof after
`using`. Initial numeral width is checked before conversion. Failure removes the generated
declaration and reports **Not certified**. A failed sufficient certificate does not imply
that executing the program is incorrect.

The concrete checker decodes operands and computes exact ideal prefixes. Its budget is
`groupCount * staticBudget (K+1) F E L`; it checks both the sufficient input conditions and
`budget ≤ tolerance`. `tc_certificate` reports `inputConditionsPass` and `tolerancePass`
separately, together with group count, scale, carry bits, budget and tolerance. This path
does not execute the model, `Program.VC`, or the residual ledger. The dependency test walks
compiled definition bodies, with a deliberately contaminated negative control.
See [examples/Certify.lean](../examples/Certify.lean) for passing accuracy and a refused tighter
tolerance on a changing-state program with rounding loss.

## Bounded dot-product application and symbolic loops

`boundedDot xs` builds an AST from contiguous groups of four FP16 operand pairs, padding
only the final group with zeros. `boundedDot_run` identifies its execution with the public
ordered dot wrapper for finite initial c. `boundedDot_ideal` proves that its mathematical
ideal is `value(c) + Σ value(a_i)*value(b_i)` over the **unpadded original list**.

The input family has at most 256 pairs, arbitrary signs, and unsigned magnitude words below
`0x2c00` (magnitudes below 1/16, including zeros and subnormals). The initial FP32 accumulator
is finite with magnitude at most 1. `small16_of_bits` derives the decoded scale condition
from that encoded interval; `small16_value` proves its numerical magnitude bound.
`boundedDot_accurate_of_bits` guarantees successful execution and absolute error at most
`1/2048`. This is a normalized row-column contribution with a tolerance finer than FP16
spacing at magnitude 1; it does not promise FP32 relative accuracy near cancellation.

The derivation uses product scale `P = -10`, accumulator scale `E = 1`, and `L = 3` carry
bits for five aligned terms. One group's ideal magnitude is bounded by `G = 1/64` and its
error by `B = 21/4194304`. There are at most 64 groups. At every prefix, the ideal magnitude
plus accumulated error is bounded by `1 + 64*(G+B) = 2 + 21/65536 < 4 = 2^(E+1)`.
This preserves the scale/range invariant for each rounded accumulator. Total error is at
most `64*B = 21/65536 < 1/2048`.

`runBlocks_of_scale_bound` proves this reasoning for general scales and counts by induction,
then applies the existing schedule error theorem. `Program.repeat_accurate_of_scales` and
`small_repeat_accurate` cover symbolic repetition; they do not assume the body returns its
initial state or loses no precision. The fixed body may contain arbitrary bounded operands;
they cannot depend on rounded state. `examples/BoundedDot.lean` instantiates both family and
symbolic-count theorems without executing prefixes.

`boundedDotCheck` checks family membership by length and input decoding alone. It constructs
no exact prefixes and runs no blocks. Its soundness theorem transfers the already proved
family guarantee to concrete input bits. The CLI exposes `certificate family words…` and
`certificate concrete words…` (decimal FP16 operands followed by decimal FP32 c), both with
the application's fixed `E = 1`, `L = 3`, and tolerance `1/2048`.

## Metaprogramming and trust

`tc%{ }` builds an inspectable `Program` term and records each block's file, line, column,
and label. It defines no second arithmetic. Kernel-checked regressions compare the elaborated
operand order, nested-loop order, and output sequence with explicit expectations, because a
checked theorem cannot detect a misinterpreted program.

`tc_verify name : program from initial` proves `Program.Correct program initial` by applying
`Program.vc_sound` to a `decide +kernel` proof of `Program.VC`, then prints the theorem and
its axioms. If elaboration fails, the generated declarations are rolled back and the command
reports that nothing was registered; a timeout is not a counterexample. For symbolic
conditions, `tc_verify name : program from initial using proof` takes a proof of the same
`Program.VC`. `symbolic_cycle_correct (n : Nat)` uses this with `Program.repeat_vc_of_cycle`,
an inductive rule for a body that returns the same encoded state with a zero ledger. The
frontend does not infer loop invariants or unroll symbolic counts.

`tc_inspect` prints the AST, profile, and a numerical report. A call failure reports the
source site and a zero-based invocation index, which distinguishes repeated executions of one
statement. `runLocated_erases` proves diagnostics cannot change execution, and
`Program.report_accepts_iff` proves report success agrees with `Program.VC`.

`tc_instruction "ampere-wmma-k16"` prints a pinned instruction path (`Programs/Instruction.lean`):
its inner dimension, products per group, extra alignment bits, floor, groups per instruction,
and the source of those parameters. The pinned names are `v100-wmma-k16`, `ampere-wmma-k16`,
and `hopper-wmma-k16`; any other name is refused, because naming a path gives it no
semantics. A path runs on exactly `k` operand pairs and rejects any other count. The
theorems about a path (`single_group_output`, `conforms_uncorrected_error`) take hardware
conformance on the model's accepted domain as an explicit premise.

Lean 4.33.1 ships `mvcgen`/`vcgen` with Hoare-style specification databases and loop
invariant support. This fragment applies the schedule theorems directly instead of adding a
general verification-condition framework; that decision should be revisited when scalar state
and relational loop invariants arrive.

## Limits

`tc_verify` uses exact-reference schedule correction. It does not execute the
guarded scalar EFT or the bounded split primitives, and it does not certify an
efficient correction implementation. The separate `scalarCorrected`/`tceft` APIs
guard the sufficient scalar predicate; `scalarCorrectedUnchecked` is diagnostic.

- Programs are typed by a `Profile`; the validated family is `fp16Fp32Profile K extraBits`,
  and the examples use V100.
- Operands are fixed; they cannot depend on rounded program state.
- Repetition can be symbolic in proofs; `tc_inspect` and automatic checking materialize
  finite schedules.
- Scalar add/subtract, casts, scaling, intermediate corrections, matrix indexing, and
  adaptive operands need new AST operations and contracts.
- Scale/count propagation is proved for the fixed-input fragment. Automatic invariant
  generation, support propagation for correction, and architecture declaration commands
  remain future work.

`python3 scripts/check_programs.py` compiles the public example and ten negative examples;
see [VALIDATION.md](VALIDATION.md).
