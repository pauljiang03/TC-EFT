# TC-EFT

This Lean library brings executable tensor-core arithmetic together with proofs about the same operations. It formalizes the TC block model, its non-monotonicity, and the TC-EFT transformation under explicit preconditions. The hardware model follows Khattak and Mikaitis, *Accurate Models of NVIDIA Tensor Cores* ([v4](https://arxiv.org/html/2512.07004v4)).

Start with the [guide](docs/README.md). It follows a calculation from encoded words through alignment and correction, then explains how to run and extend the executable Lean tests.

## Build and run

Install elan and Python 3, use the pinned `lean-toolchain`, and run from this directory:

```sh
lake build
lake env lean examples/GettingStarted.lean
lake env lean examples/NonMonotonicity.lean
```

`lake build` builds the production library, the separate regression library, and the native test adapters. To build only the production library, use `lake build TensorCore`.

## A calculation and a proof

Four FP16 products of one produce the FP32 encoding of four:

```lean
import TensorCore.TC

open TensorCore

def ones : BlockInput v100F16F32 :=
  ⟨List.replicate 4 (0x3c00, 0x3c00), 0⟩

#eval (evalBlock ones).map fun t => t.output.bits.toNat

example : ((evalBlock ones).toOption.map fun t => t.output.bits) =
    some 0x40800000 := by decide +kernel
```

The calculation prints `Except.ok 1082130432`. The `example` proves the complete result word by kernel reduction. [GettingStarted.lean](examples/GettingStarted.lean) also shows a block whose model result loses tiny products and whose EFT recovers the correctly rounded sum.

## Source layers

| Import / directory | What belongs here |
| --- | --- |
| [`TensorCore.Numerics`](TensorCore/Numerics.lean) | Exact arithmetic, finite representations, encodings, and rounding contracts |
| [`TensorCore.TC`](TensorCore/TC.lean) | TC profiles, alignment, accumulation, conversion, model specification, error and non-monotonicity theory |
| [`TensorCore.EFT`](TensorCore/EFT.lean) | Reference extraction, scalar preconditions, chosen-grid conditions, and Algorithm 1 |
| [`TensorCore.Kernels`](TensorCore/Kernels.lean) | Bounded 576-bit EFT execution and its refinement proofs |
| [`TensorCore/Scalar`](TensorCore/Scalar.lean) | Native FP32 addition proof support used by the bounded EFT path |
| [`tests/`](tests/README.md) | Separate `TensorCoreTests` regression modules and executable-test walkthrough |
| [`examples/`](examples/README.md) | Checked worked examples and Lean batch adapters |

`import TensorCore` loads all production layers. Smaller imports let you use the reference EFT without the bounded kernels. Existing mathematical declaration names, including `TensorCore.EFMachine` and `TensorCore.IEEE`, are preserved. The [guide's module map](docs/guide/01-getting-started.md#finding-the-source) explains the file moves.

## Two implementations

The main library defines the model from encoded bits and exact arithmetic. [floatlib-port](floatlib-port/README.md) independently implements the same block model and reference EFT using LeanDojo FloatLib, with kernel-checked equivalence proofs. It has its own pinned Lean toolchain:

```sh
cd floatlib-port
python3 scripts/check_all.py
python3 scripts/check_equivalence.py
```

The FloatLib implementation covers the reference algorithm; the bounded backend has a separate refinement proof. Reference preparation checks the actual relocated parent sources against the pinned arithmetic/proof bodies.

## Validation and scope

```sh
python3 scripts/check_clean_build.py
```

This builds a fresh snapshot, audits theorem dependencies, checks every worked Lean file and documentation example, and compares executable results with independent exact-arithmetic oracles and recorded hardware vectors. See [the test walkthrough](tests/README.md) for individual checks and their failure behavior.

The selected paths have FP16/BF16/TF32 operands and FP32 outputs. Scalar EFT correctness keeps its grid, coefficient-budget, representability, and range hypotheses. Non-monotonicity results describe the stated realizable perturbation family. Hardware correspondence remains an external obligation; recorded-vector replay takes no new GPU measurements. Software checks require neither MATLAB nor CUDA.

[Theorem index](TensorCore/THEOREMS.md) · [Executable reference](docs/reference.md) · [Trust and style](docs/style.md)
