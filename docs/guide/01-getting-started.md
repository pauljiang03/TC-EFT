# Getting started

Run commands in this chapter from the repository root. The project needs the Lean version in `lean-toolchain`, elan, and Python 3. The first-principles library uses Lean's standard arithmetic; the independent FloatLib project has a separate toolchain and dependency graph.

```sh
lake build
lake env lean examples/GettingStarted.lean
```

The worked file prints:

```text
Except.ok 1082130432
Except.ok 1065353216
Except.ok (some 1065353218)
```

Those integers encode `4`, `1`, and `1 + 2^-22` in FP32. The first block contains four products of one. The second contains four products of `2^-12` and an accumulator of one. Its TC model output is one, while scalar EFT returns the correctly rounded exact sum `1 + 4·2^-24`.

## Choosing an import

`import TensorCore` supplies the production numerical, TC, reference EFT, and bounded-kernel layers. For a smaller dependency set, choose an entry point:

| Import | Available development |
| --- | --- |
| `TensorCore.Numerics` | Finite representations, exact arithmetic, encoding and rounding |
| `TensorCore.TC` | TC stages, profiles, specification, widths, error and non-monotonicity |
| `TensorCore.EFT` | Reference EFT and its scalar/chosen-grid conditions |
| `TensorCore.Kernels.EFT` | Bounded workspace operations, correction, and refinement |
| `TensorCoreTests` | Production library plus the complete regression and trust-check environment |

The production imports do not load `TensorCoreTests`. Tests have their own source root at `tests/`, while sharing the parent's Lake project and toolchain.

## Encoded input, executable result, and proof

A `BlockInput p` contains a list of encoded operand pairs and an encoded FP32 accumulator. `p` determines the input word type and expected group size. Hexadecimal literals below denote bit patterns:

```lean
import TensorCore.TC

open TensorCore

def ones : BlockInput v100F16F32 :=
  ⟨List.replicate 4 (0x3c00, 0x3c00), 0⟩

#eval (evalBlock ones).map fun t => t.output.bits.toNat

example : ((evalBlock ones).toOption.map fun t => t.output.bits) =
    some 0x40800000 := by decide +kernel
```

FP16 `0x3c00` represents one; FP32 `0x40800000` represents four. `evalBlock` returns an `Except ModelError BlockTrace`. On success, the trace retains the prepared terms and output word. On failure, it returns a named domain error.

`#eval` runs the calculation and prints an observation. `example` asks Lean to check a proposition. `decide +kernel` discharges this concrete equality by kernel reduction. The assertion compares the full word, including its zero sign.

A symbolic theorem connects the same evaluator to an exact-arithmetic statement:

```lean
import TensorCore.TC.StageResiduals

open TensorCore

example {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) :
    exactDot x = some (t.output.value + t.residual) :=
  evalBlock_residual_identity h
```

Here the input remains arbitrary. Successful model evaluation is a premise; the theorem identifies the independently defined ideal with the output plus its extracted residual.

## Finding the source

The layout follows FloatLib's separation of numerical foundations, execution kernels, worked documentation, and tests. The TC/EFT subject names remain explicit:

| Former module area | Current location |
| --- | --- |
| `TensorCore/Core` | `TensorCore/Numerics` |
| `TensorCore/EFT/Machine`, `EFT/Bounded`, `EFT/Native` | `TensorCore/Kernels/EFT` |
| `TensorCore/IEEE` | `TensorCore/Scalar` |
| `TensorCore/TC/Regression`, `EFT/Regression`, `Regression/Specification` | `tests/TensorCoreTests/{TC,EFT,Specification}` |
| `TensorCore.All`, `TensorCore.Tests` | Separate `TensorCoreTests` root |

Only module locations and imports change. Mathematical names such as `evalBlock`, `algorithm1Encoded`, `EFMachine.algorithm1`, and `IEEE.LeanBridge.nativeFiniteAdd32` retain their namespaces. The source-path changes also update the FloatLib equivalence layer and reference-copy provenance.

Next: [follow the TC stages](02-tensor-core-model.md).
