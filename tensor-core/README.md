# Tensor-core reference semantics in Lean

For a new context, read [START_HERE.md](../START_HERE.md) and the
[current plan](docs/CURRENT_PLAN.md). The priority is general parameterized
semantics/proofs for **one dot product with unnormalized products and a block
accumulation**. Later composition is planned; EFT is a separate local application.

A working V100 FP16/FP32 reference evaluator with exact stage residuals,
an arbitrary-length residual ledger, general finite-range nearest-even rounding
proofs, and a two-stage block error bound. The numerical
specification is the supplied Accurate Models v4 paper, reconciled with its
MATLAB Tensor Core v0.5 release. This is a model-relative formalization.

The first DSL/metaprogramming frontend supports typed block calls, sequencing,
bounded repetition, inspectable source locations, and generated correctness
theorems. See [the DSL guide](docs/DSL.md) and the runnable
[verification example](examples/Verify.lean).

```sh
cd tensor-core
lake build
lake exe tc_trace
python3 scripts/check_axioms.py
python3 scripts/validate.py
python3 scripts/check_device.py
python3 scripts/check_programs.py
lake env lean examples/Verify.lean
```

Lean is pinned to 4.33.1; there are no external Lean packages or solvers. With
that toolchain installed, `lake build` works offline. Python validation uses
only its standard library. The executable prints JSON traces with exact rational
values. Supply eight FP16 hexadecimal words followed by one FP32 accumulator:

```sh
lake exe tc_trace 3e00 3d00 3e00 3d00 3e00 3d00 3e00 3d00 3f7fffff
```

Argument order is `a0 b0 a1 b1 a2 b2 a3 b3 c`; omit `0x`. `--file PATH` accepts
one such block per line. `--round-file PATH` accepts exact integer numerator /
positive denominator pairs separated by spaces, and emits RTZ/RNE output bits.
Malformed or oversized words fail rather than wrapping to the input width.

See [status](docs/STATUS.md), [continuation details](docs/CONTEXT_HANDOFF.md),
[historical Fable review](docs/FABLE_REVIEW.md), and
[specification decisions](docs/SPECIFICATION.md). [The theorem map](docs/THEOREM_MAP.md)
and [assumption report](docs/ASSUMPTIONS.md) identify exactly what is proved.

The first executable acceptance gate is implemented, and the evaluator matches
the 5,000 V100 GPU vectors published with the MATLAB release. The fixed-width
refinement, the paper's scalar FP EFT algorithm, optimized extraction, and further
feature families remain open. Exact residuals
are arbitrary-precision rational values over dyadic inputs, not promised single
FP32 values or classical floating-point expansions.
