---
title: Trust boundary
description: What is proved, what is tested, and what is trusted.
---

## Proved in Lean

All model properties, EFT correctness, and refinement results, under the
hypotheses stated in each theorem (see the [theorem
index](/TC-EFT/proofs/theorems/)). The development uses no `sorry` and no
custom axioms. `scripts/check_axioms.py` audits every public theorem under
the `TensorCore` namespace and allows only `propext`, `Classical.choice`, and
`Quot.sound`. The recorded run audited 1,375 theorem roots.

## Tested, not proved

- **Agreement with GPUs**: on the 35,000 recorded measurements only, with the
  [coverage gaps](/TC-EFT/model/validation/#what-the-rows-dont-cover) noted
  there.
- **Agreement with Python oracles**: exact-rational reimplementations of
  the same *Accurate Models* semantics.
- **Native Float32**: `tcEftWithLean_eq` is proved against Lean's float
  *model*. That the compiled `Float32` addition matches the model is checked
  by `check_lean_eft.py`, not proved.

## Trusted

- The Lean kernel, and for `#eval` and the `tc_*` executables, Lean's
  compiler and runtime.
- The Python harnesses that compare outputs. Their pass/fail rests largely on
  `assert`, so they must run **without** `python -O` or `PYTHONOPTIMIZE`.
- The authenticity of the vendored measurement files. They are pinned by
  SHA-256 in [`vendor/SOURCES.json`](https://github.com/pauljiang03/TC-EFT/blob/main/vendor/SOURCES.json)
  but cannot be independently re-measured without GPUs.

## Assumed

That the *Accurate Models* model, and therefore this one, matches hardware in the
regions the recorded data does not exercise: active alignment floors,
subnormal and zero operands, wide-exponent BF16/TF32 inputs, and the H100 TF32
K = 8 MMA path.
