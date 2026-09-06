# Program language

A term elaborator and two commands sit on top of the ordinary block semantics. The verified
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
next call. The program runs its blocks first; one final reference correction combines all
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
semantics. The theorems about a path (`single_group_output`, `conforms_uncorrected_error`)
take hardware conformance as an explicit premise.

Lean 4.33.1 ships `mvcgen`/`vcgen` with Hoare-style specification databases and loop
invariant support. This fragment applies the schedule theorems directly instead of adding a
general verification-condition framework; that decision should be revisited when scalar state
and relational loop invariants arrive.

## Limits

- Programs are typed by a `Profile`; the validated family is `fp16Fp32Profile K extraBits`,
  and the examples use V100.
- Operands are fixed; they cannot depend on rounded program state.
- Repetition can be symbolic in proofs; `tc_inspect` and automatic checking materialize
  finite schedules.
- Scalar add/subtract, casts, scaling, intermediate corrections, matrix indexing, and
  adaptive operands need new AST operations and contracts.
- Range and support propagation, invariant generation, and architecture declaration commands
  are future work.

`python3 scripts/check_programs.py` compiles the public example and ten negative examples;
see [VALIDATION.md](VALIDATION.md).
