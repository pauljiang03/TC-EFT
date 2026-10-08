---
title: Project status
description: Build, audit, and validation status, and known open items.
---

## Current state

| Check | Status |
| --- | --- |
| `lake build` (226 targets) | passes, no Lean warnings |
| Axiom audit | only `propext`, `Classical.choice`, `Quot.sound`; no `sorry` |
| Model = independent specification | proved for all inputs on 8 paths |
| Recorded GPU vectors | 35,000 rows, 0 mismatches |
| Software oracle cases | 715 blocks, 2,918 rounding cases, 2,033 feature cases, 0 mismatches |
| FloatLib equivalence | proved; 115,029 + 668,944 comparison cases, 0 mismatches |

## Known open items

- **Hardware coverage.** Floors, subnormal and zero operands, wide-exponent
  BF16/TF32 inputs, and the H100 TF32 K = 8 path have no recorded GPU rows.
  The TF32 input files duplicate the V100 FP16 inputs.
- **`inputBudget_scalarPredicate`** takes most of its conclusion as hypotheses, and
  no repository instance satisfies all of them.
- **Scalar fast path.** No theorem shows that the predicate forces the
  bounded kernel to take the fast path.
- **The reference fast-path check is stricter than it needs to be.** To
  decide whether the cheap FP32 path is safe, it asks how many bits the low
  parts *could* occupy, based on each term's format. It even counts zero
  terms: a zero `C` is treated as if it had bits down to `2^0`. The 576-bit
  implementation instead looks at the bits the low parts *actually* occupy.
  Both always return the correct answer, but the reference version takes the
  slower exact path in some cases where the fast path would have been fine.
  The TC-EFT paper's own generator and the 576-bit version both use the
  tighter rule; the reference disagrees with the paper's generator in 27
  recorded cases. Kept as is by choice.
- **Validation scripts** rely on `assert` and must not run under `python -O`.
- **Signed zero.** The binary rounding helpers return `+0` for exact zero in
  every mode, so the FP64 FMA in round-down mode differs from IEEE here.
