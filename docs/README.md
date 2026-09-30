# Guide to tensor-core arithmetic

The guide follows executable calculations into the definitions and proofs that justify them. Each Lean code block is checked by `python3 scripts/check_docs.py`; complete worked files live in `examples/`.

1. [Getting started](guide/01-getting-started.md): choose imports, run a calculation, and find the source.
2. [The tensor-core model](guide/02-tensor-core-model.md): follow raw products, alignment, accumulation, and conversion.
3. [Non-monotonicity](guide/03-non-monotonicity.md): execute a witness and connect it to the general threshold and range theorems.
4. [TC-EFT](guide/04-eft.md): follow the overlap identity, scalar preconditions, and the two execution backends.
5. [Executable Lean tests](guide/05-executable-tests.md): run kernel witnesses, IO programs, native adapters, and independent comparisons.

Use the [theorem index](../TensorCore/THEOREMS.md) to locate results and their Lean source. The [reference](reference.md) lists command formats and precise contracts.

The independent FloatLib implementation has a [folder guide](../floatlib-port/FOLDER_GUIDE.md) and a [theorem correspondence](../floatlib-port/COMPARISON.md). Its toolchain and runtime implementation are separate from the first-principles project.
