# TC-EFT

This Lean library formalizes Tensor Core (TC) block arithmetic, its non-monotonicity, and the TC-EFT correction algorithm under explicit preconditions. Executable calculations and correctness proofs use the same definitions. The TC model follows Khattak and Mikaitis, *Accurate Models of NVIDIA Tensor Cores* ([paper](https://arxiv.org/html/2512.07004v4)).

Start with the [guide](docs/README.md). It follows a calculation from encoded input words through alignment and correction, then explains how to run the Lean tests and add cases.

[Website](https://pauljiang03.github.io/TC-EFT/) · [Reviewer guide](ARTIFACT.md) · [Test walkthrough](tests/README.md) · [What is proved](TensorCore/THEOREMS.md) · [FloatLib implementation](floatlib-port/README.md)

## Build and run

Install [elan](https://github.com/leanprover/elan) and Python 3, use the pinned `lean-toolchain`, and run from this directory. A complete source ZIP works as well as a clone; TC-EFT's Git history is unnecessary. The FloatLib project also needs Git to fetch its pinned dependencies.

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

The calculation succeeds with the FP32 value `4.0`. It prints the encoded result; `Except.ok` indicates success. The `example` proves its exact bit pattern by kernel reduction. [GettingStarted.lean](examples/GettingStarted.lean) also shows how TC-EFT recovers contributions lost during alignment and returns the correctly rounded sum.

## Repository layout

| Import / directory | What belongs here |
| --- | --- |
| [`TensorCore.Numerics`](TensorCore/Numerics.lean) | Exact arithmetic, finite representations, encodings, and rounding contracts |
| [`TensorCore.TC`](TensorCore/TC.lean) | TC profiles, alignment, accumulation, conversion, model specification, error and non-monotonicity theory |
| [`TensorCore.EFT`](TensorCore/EFT.lean) | Reference extraction, scalar preconditions, chosen-grid conditions, and Algorithm 1 |
| [`TensorCore.Kernels`](TensorCore/Kernels.lean) | Bounded 576-bit EFT execution and its refinement proofs |
| [`TensorCore.Scalar`](TensorCore/Scalar.lean) | Native FP32 addition proof support used by the bounded EFT path |
| [`Main/`](Main/) | Command-line entry points that call the library and print results for test comparisons |
| [`tests/`](tests/README.md) | Separate `TensorCoreTests` regression modules and executable-test walkthrough |
| [`examples/`](examples/README.md) | Checked worked examples and Lean batch adapters |
| [`floatlib-port/`](floatlib-port/README.md) | Independent FloatLib implementation and equivalence proofs, with its own Lake project |
| [`docs/`](docs/README.md) | Numbered guide, command reference, and trust boundaries |
| [`scripts/`](scripts/) | Validation runners, exact-arithmetic oracles, and proof audits |
| [`data/`](data/) | Executable example inputs, regression fixtures, and recorded check reports |
| [`vendor/`](vendor/SOURCES.json) | Pinned paper inputs and expected outputs, reference models, licenses, and source hashes |

`import TensorCore` loads all production layers. Smaller imports let you use the reference EFT without the bounded kernels. Bounded EFT declarations use the `TensorCore.EFMachine` namespace; scalar IEEE declarations use `TensorCore.IEEE`. The [guide's source map](docs/guide/01-getting-started.md#finding-the-source) links the main definitions and proofs.

## Two implementations

The first-principles implementation defines the model from encoded bits and exact integer and rational arithmetic. The [FloatLib implementation](floatlib-port/README.md) defines the same block model and reference EFT using LeanDojo FloatLib. Kernel-checked theorems prove equivalence between their encoded interfaces. The FloatLib project has its own pinned Lean toolchain:

```sh
cd floatlib-port
python3 scripts/check_all.py
python3 scripts/check_equivalence.py
```

The FloatLib implementation covers the reference algorithm; the bounded backend has a separate refinement proof. Reference preparation verifies the parent sources against the bundled manifest before building the equivalence proofs.

## Validation and scope

```sh
python3 scripts/check_clean_build.py
```

This builds a fresh snapshot, audits theorem dependencies, checks every worked Lean file and documentation example, and compares executable results with independent exact-arithmetic oracles and recorded hardware vectors. See [the test walkthrough](tests/README.md) for individual checks and their failure behavior.

The supported paths use FP16, BF16, or TF32 operands and FP32 outputs. Scalar EFT correctness requires explicit grid, coefficient-budget, representability, and range assumptions. The non-monotonicity theorems cover specified families of encoded inputs. Hardware comparisons replay recorded GPU measurements; the proofs concern the formal model under their stated hypotheses. Software checks require neither MATLAB nor CUDA.

[What is proved](TensorCore/THEOREMS.md) · [Executable reference](docs/reference.md) · [Trust and style](docs/style.md)

## License

TC-EFT's code and documentation are available under the [MIT license](LICENSE). Vendored materials retain their own notices, including the [BSD 2-Clause license](vendor/matlab-tensor-core-v0.5/LICENCE) for the Accurate Models code and recorded vectors. Downloaded dependencies retain their upstream licenses.
