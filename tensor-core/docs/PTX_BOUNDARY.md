# From arithmetic groups to PTX programs

The [current plan](CURRENT_PLAN.md) prioritizes completing the general
parameterized single-invocation arithmetic model. This document records the
hardware boundary and a later instruction-refinement work package; it does
not require finishing PTX mapping before generalizing the arithmetic model.
The user defines one invocation as one dot product with unnormalized products
and a block accumulation. Its local alignment/c/output stages belong to the
arithmetic model. Multiple such groups inside an instruction, their ordering,
and sequencing completed invocations are downstream work.

The current `Program.Correct` theorem verifies an explicitly supplied schedule
of arithmetic normalization groups. It is not a theorem about a PTX instruction,
a CUDA kernel, or compiler lowering. In particular, a DSL `block` is not an
alias for one whole warp-level matrix instruction.

## What is already connected

- A typed DSL block selects a profile, encoded operand pairs, and one incoming
  FP32 accumulator.
- `Program.run` executes the stated block list in order, feeding each actual
  encoded output to the next block.
- `Program.ideal` decodes the original program operands independently and sums
  their exact products. The recovery and final-rounding theorems concern that sum.
- The reference EFT retains exact rational alignment and output residuals.
  This proves recovery but does not establish a scalar PTX implementation of
  extraction or residual consolidation.

Within a group, the reference sums aligned signed integers exactly. A different
reduction tree gives the same result if it really implements that operation
without wrap or intermediate normalization. Across groups, the placement of
normalization/truncation boundaries and the actual order are numerically
significant. Neither may be inferred from the ideal real-valued dot product.

## Source findings

Accurate Models v4 §4.2, p. 15, explicitly distinguishes the instruction's inner
dimension K from its detected normalization-group size N_FMA. For Ampere/Ada
FP16/BF16, it gives K=16 and N_FMA=8. Table 4 distinguishes the tested CUDA/PTX
paths and corresponding SASS instructions. In particular, its FP16/BF16 paths
use the WMMA API, and its TF32 discussion distinguishes WMMA from certain direct
`mma.sync.aligned` shapes. An architecture name plus a format is not sufficient
to identify every instruction path.

The pinned MATLAB `models/tools/GEMM.m` implements successive contiguous groups
of `params.fma` products in increasing k, assigning `c = d` after every group.
That is a concrete *reference-software* composition rule. The current Lean
proofs do not establish that a specified compiler output or target instruction
implements that rule.

The release's `model_validation/CUDA/wmma_fp16_bf16_tf32_input.cu` uses
`wmma::load_matrix_sync`, one `wmma::mma_sync`, and `wmma::store_matrix_sync`
with 16×16×16 FP16/BF16 fragments. The local inspected source is in the full
v0.5 archive under `../tmp/`; it is not currently a vendored build dependency.
Its compile-time format/device switches must be fixed before treating it as
one concrete target artifact. The existing GPU-vector comparison remains
empirical evidence; it is not a proof of fragment layout or instruction lowering.

The [NVIDIA PTX instruction specification](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html#warp-level-matrix-instructions-mma)
leaves accumulation order, rounding, and subnormal handling unspecified for
FP16/BF16/TF32 MMA arithmetic. The current page consulted identifies itself as
PTX ISA 9.3. PTX documentation alone therefore cannot supply the full numerical
contract needed here; a concrete target/compiler path and architecture evidence
must supply the additional assumptions. A versioned ISA source must be pinned
when implementing the instruction interface.

## Later instruction-refinement milestone

1. **Choose and pin one instruction path.** Record target architecture, exact
   opcode/API, shapes, layouts, input/accumulator/output formats, qualifiers,
   CUDA/PTX version, and compiler target. Keep instruction K separate from the
   arithmetic group's product count.
2. **Define the operand and result mapping.** Map lane/register fragments and
   matrix indices to logical entries. Specify loads, stores, packing/conversion,
   and required warp participation. Establish that every intended operand is
   selected with the intended multiplicity.
3. **Make grouping and order explicit.** Connect that instruction path to an
   ordered normalization-group schedule, including c insertion and all
   intermediate output conversions. Require a proved refinement or a plainly
   identified architecture-conformance premise; do not insert a project axiom.
4. **Connect the operations used by the chosen application.** Model its
   concrete scalar operations and conversions, including rounding losses.
   If it uses EFT, connect extraction and correction to their local contracts
   under explicit support, representability, and range conditions. Applications
   using an uncorrected result or an error bound need their own corresponding
   contracts; EFT is not a mandatory part of every downstream proof.
5. **Connect emitted code and evidence.** Inspect emitted PTX/SASS for the
   pinned configuration, validate boundary-sensitive tests on that path, and
   distinguish compiler/layout proofs from empirical numerical conformance.

The generic `Profile` and existing arithmetic proofs remain reusable. A100
FP16/BF16 parameters have been reviewed against v4 §4.1.2 and v0.5 `A100TC.m`,
but no new architecture profile was installed during this instruction-boundary
review. The next extension should carry its instruction-path scope alongside
the numerical parameters.
