# Checked Lean examples

From the repository root, build first and check a file with `lake env lean examples/NAME.lean`.

| File | Purpose | Execution |
| --- | --- | --- |
| [GettingStarted.lean](GettingStarted.lean) | Encoded TC calculation, scalar EFT correction, symbolic recovery theorem | Prints calculations and checks equalities |
| [NonMonotonicity.lean](NonMonotonicity.lean) | Smaller C, larger TC output, corrected results, general family theorem types | Prints calculations and checks equalities |
| [CanonicalInvocation.lean](CanonicalInvocation.lean) | Hopper invocation and arbitrary-width model refinement | Checks a concrete equality and symbolic API use |
| [BinaryFoundation.lean](BinaryFoundation.lean) | Signed encodings and binary rounding contracts | Checks symbolic API use |
| [EncodedEFT.lean](EncodedEFT.lean) | Supplied-D correction and encoded correctness | Checks concrete and symbolic results |
| [ScalarEFT.lean](ScalarEFT.lean) | Generic correction precision and any-order exact summation | Checks symbolic results |
| [BoundedEFT.lean](BoundedEFT.lean) | BF16 cancellation, operation budget, bounded success contract | Prints calculations and checks symbolic results |
| [PaperSpecification.lean](PaperSpecification.lean) | Encoded model equality to the independent specification | Checks symbolic results |
| [EFTCoverage.lean](EFTCoverage.lean) | Batch observation adapter for the scalar-coverage harness | Has `main`; requires an input file when run |
| [InstructionGroups.lean](InstructionGroups.lean) | Ordered 16-position instruction-group model observations | Has `main`; requires an input file when run |

Checking a file with `lake env lean FILE` elaborates declarations and runs its `#eval` commands. It does not invoke `main`. Use `lake env lean --run FILE INPUT` to run an IO adapter. The Python coverage and instruction-group checks generate the correct batch input and call those two adapters.

The clean suite enumerates every `.lean` file in this directory. [The test walkthrough](../tests/README.md) explains the assertions and observation pipeline.
