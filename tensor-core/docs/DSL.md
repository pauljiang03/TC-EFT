# First program language and verification frontend

The project now has a custom Lean term elaborator and proof-producing commands
on top of its ordinary arithmetic definitions. This is the first supported
program fragment, not the complete language in the handoff.

The verified program is the supplied arithmetic-group schedule. No PTX parser,
fragment/register mapping, or verified PTX/SASS lowering connects a GPU program
to that schedule yet. See [the instruction boundary review](PTX_BOUNDARY.md).

## Write and verify a program

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

Each pair is two encoded FP16 operands. The initial accumulator and every
block output are FP32. `block` checks the literal values fit the profile's word
width and that the group has exactly its required number of pairs. Malformed
groups and oversized literals fail during elaboration. An already typed
`BlockOperands p` value can be supplied with `call "label" operands;`.

`tc_verify` also bounds-checks a bare or parenthesized initial numeral before
constructing its FP32 bits. Explicit Lean expressions supplied as already
encoded values retain their ordinary Lean meaning; any deliberate conversion
to `BitVec` in those expressions must be reviewed as part of the program.

For one modeled V100 normalization group, run:

```sh
lake env lean examples/SingleInvocation.lean
```

It checks exactly one invocation, proves the raw output bits `4107ffff`, and
verifies reference correction to `41080000`. The ideal sum is `17/2 - 2^-24`,
and the retained residual is `15 * 2^-24`. This is four FP16 products plus one
FP32 accumulator, not a complete matrix instruction tile.

Run the complete two-block cancellation example with:

```sh
lake env lean examples/Verify.lean
```

That example produces the model output sequence `4107ffff`, `b5800000`,
recovers the original-input ideal sum -2^-24, and returns corrected FP32 bits
`b3800000`. The example prints the expanded AST and numerical report.

## Exact meaning of the generated theorem

`Program p` has `skip`, `block`, `seq`, and `repeat` constructors. Its profile
is a type parameter. Each `BlockOperands p` stores a list and a checked group
size proof. Nested repetition preserves the stated order. `Program.blocks`
exposes the complete ordered schedule; `Program.run` uses the existing
`runBlocks` evaluator on its operands. Each invocation receives its
predecessor's actual output bits.

The program performs its tensor-core blocks first. One final **reference**
correction combines all residuals with the last output using exact `Rat`
arithmetic and applies nearest-even FP32 conversion. The AST does not silently
correct an intermediate accumulator or replace an operation with scalar FP32
addition.

`Program.ideal` separately decodes the original input bits and sums exact
operand products. It does not inspect model outputs, alignments, or residuals.
`Program.recovery` connects this definition to the executable schedule ledger.

`Program.VC program initialBits` requires:

1. A finite initial FP32 encoding.
2. Successful evaluation of every executed model call.
3. A final recovered exact sum with magnitude at most `maxFinite32`.

`Program.vc_sound` proves that these conditions imply `Program.Correct`:
successful execution exists, its ledger recovers the direct original-input
ideal sum, and final correction returns a finite nearest-even FP32 encoding
of that sum. The theorem retains the declared model domain; it does not assert
universal GPU conformance or efficient scalar correction.

## Metaprogramming and trust

The `tc%{ ... }` elaborator constructs ordinary, inspectable `Program` terms
and records each block's file, line, column, and label. The elaborator does not
define a second arithmetic model. Kernel-checked regressions compare the
elaborated operand order, nested-loop order, and output sequence with explicit
expectations; checking a theorem alone would not detect a misinterpreted
intended program.

`tc_verify name : program from initial` assembles an ordinary theorem by
applying `Program.vc_sound` to a kernel-reduction proof of `Program.VC`.
It displays the generated theorem type and its dependencies. Failed proof
elaboration rolls back the generated declarations; the command reports that
no new verification theorem was registered. A timeout or unresolved condition
is not labeled a counterexample.

For symbolic conditions, use:

```lean
tc_verify result : program from initial using proofOfProgramVC
```

The supplied term must prove the same explicit `Program.VC`. The regression
`symbolic_cycle_correct (n : Nat)` uses this path to verify an add/subtract
cycle repeated any finite number of times. `Program.repeat_vc_of_cycle`
establishes its invariant by induction: the body returns the same encoded
state and has a zero residual ledger. This is a reusable, restricted invariant
rule; the frontend does not infer general loop invariants or automatically
unroll a symbolic count.

`tc_inspect` prints the AST, selected profile, and a numerical report. A call
failure includes the original source site and a zero-based invocation index,
which distinguishes repeated executions of one source statement. The report
also distinguishes nonfinite initial state from final-sum range rejection.
`runLocated_erases` proves that adding diagnostics cannot change numerical
execution. `Program.report_accepts_iff` proves report success agrees with the
verification conditions. Executable inspection itself is a computation, not
the proof certificate used by `tc_verify`.

The project audit includes the generated regression theorem roots and enforces
the existing standard Lean axiom allowlist. No compiled numerical inspection
is accepted as a theorem proof.

## Assessment of existing Lean automation

The pinned Lean 4.33.1 sources include `Lean/Elab/Tactic/Do/VCGen.lean` and
`Lean/Elab/Tactic/Do/Internal/VCGen/Frontend.lean`, with Hoare/WP specification
databases, loop invariant support, and experimental-status warnings. These
were inspected before choosing the frontend design.

This increment directly applies the existing schedule contracts and a small
execution-based condition checker. It does not create a competing general
Hoare/VC framework or claim to implement full symbolic VC generation. Reassess
`mvcgen`/`vcgen` integration when scalar state operations and general relational
loop invariants make their facilities useful.

## Boundaries and next language work

The [current plan](CURRENT_PLAN.md) defers implementation of these language
extensions until the general single-invocation arithmetic gate is complete.
The existing DSL and proofs remain available during that work.

- Only V100 FP16/FP32 has an instantiated, empirically checked profile.
- Operands are fixed independently of rounded program state.
- Repetition can be symbolic in definitions/proofs; executable inspection and
  automatic concrete checking materialize finite schedules.
- Scalar add/subtract, casts, exact scaling, intermediate corrections, matrix
  indexing, and adaptive operands require new AST operations and contracts.
- Automatic interval/support propagation, general invariant generation, and
  transparent architecture declaration commands remain future frontend work.
- Residual support/representation, scalar consolidation, fixed-width no-wrap,
  and optimized extraction proofs remain future arithmetic work.

`python3 scripts/check_programs.py` compiles the public example and ten separate
negative examples covering shape, width, format, nonfinite values, final range,
unsupported syntax, unresolved symbolic conditions, and invalid supplied
proofs. It checks that failed verification names are absent from the environment.
