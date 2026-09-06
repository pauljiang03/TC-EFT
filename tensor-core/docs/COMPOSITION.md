# Composition of invocations

The model's unit is one normalization group: K products and c, aligned once, summed
exactly, converted once. A PTX or WMMA instruction can contain several groups, and a long dot
product chains many instructions. This note records what the sources establish about how
groups compose, what the Lean model does, and what remains.

## What the sources establish

1. **Instruction k versus N_FMA.** Accurate Models §2 defines N_FMA as the number of
   products added with a single normalization and rounding. §4.2 states that the
   instruction's inner dimension k need not equal N_FMA: for Ampere and Ada FP16/BF16,
   k = 16 while N_FMA = 8. Table 3 gives N_FMA = 4 (V100 HMMA.844), 8 (A100/Ada HMMA.1688),
   and 16 (Hopper/Blackwell HMMA.16816). For TF32 on Hopper, WMMA m16n16k8 lowers to
   HMMA.1684 with N_FMA = 4 while mma.sync m16n8k8 lowers to HMMA.1688 with N_FMA = 8 (§4.1.6).
2. **Reference composition rule.** `models/tools/GEMM.m` in MATLAB Tensor Core v0.5 pads each
   row·column dot product to a multiple of `params.fma`, splits it into consecutive groups in
   increasing k, calls `Generic_BFMA_TC` on each group with the previous group's output as c,
   and returns the last output. Every group boundary is a fully encoded output-format value
   for the FP16/BF16/TF32 paths; no unnormalized state crosses it.
3. **Evidence for that rule.** The paper's randomized validation (§4.2) runs whole
   instructions (k = 16 for FP16/BF16, 8 for TF32, 32 for FP8) against the model with 10^7
   vectors per setting and reports zero mismatches after refinement. For A100/Ada FP16 that
   exercises two groups per instruction, so the increasing-k, encoded-boundary rule is
   validated there at scale. On Volta, a WMMA m16n16k16 compiles to sixteen HMMA.884 SASS
   instructions in four sets of four steps (Jia et al., arXiv:1804.06826); each instruction
   reads and writes the FP32 accumulator registers, so the group boundary is visible at the
   SASS level.
4. **What the vendored vectors show.** The harness
   `model_validation/CUDA/wmma_fp16_bf16_tf32_input.cu` writes `K = N_FMA` products into k
   positions `0..K−1` of a 16×16×16 WMMA and zeros the rest (4 on V100, 8 on A100, 16 on
   H100). The 5,000 matches per family therefore validate one group, plus pass-through of an
   FP32 accumulator through the remaining all-zero groups on V100 and A100. They do not
   distinguish orderings of nonzero groups.
5. **Exceptions.** Hopper and Blackwell FP8 through mma.sync are converted to FP16 and run
   on HMMA.16816: the 32 products split into two interleaved groups by alternating pairs, and
   c is added to the normalized product sum with RNE (§4.1.6, Fig. 5c). The paper's text
   describes two invocations; the MATLAB odd/even model instead aligns and adds the two
   unnormalized group sums before normalization. A distinguishing vector is needed before
   either is assigned to the hardware. FP64 DMMA has N_FMA = 1 and behaves as an IEEE FMA
   chain `((c + p1) + p2) + …`, established by permuting operands (§4.1.2).
6. **PTX specifies nothing here.** The PTX ISA states for these instructions that "the
   accumulation order, rounding, and handling of subnormal inputs is unspecified" (quoted in
   Valpey et al., arXiv:2502.15999, §4). Grouping and order must come from measurement.
7. **Earlier formal models.** Valpey et al. model an instruction as one accumulation of all k
   products in any order. The refinements in Accurate Models (N_FMA < k on Ampere/Ada,
   unnormalized products, exponent floors) show that abstraction is too coarse for those paths.

## What the Lean model does

`runBlocks` follows a supplied list of groups; each group's output bits are decoded as the
next c. `runBlocks_residual_ledger` proves `c0 + Σ Pj = dm + Σ ej` for any finite list, with
every local residual `ej` kept exactly; `runBlocks_uncorrected_error` bounds the final
uncorrected error by the sum of the traces' local budgets; `fp16Fp32_schedule_machine_eq`
carries the modular-accumulator equivalence through every encoded boundary. `Program` adds
sequencing and bounded repetition. `OrderedPartition` and `canonicalPartition` turn a long
operand list into contiguous fixed-size groups in increasing k, padding only a partial tail
with zero pairs, with the original ideal preserved by proof; `runCanonicalDot` executes it.

`InstructionPath` (`Programs/Instruction.lean`) pins one instruction: name, `k`, `N_FMA`,
extra alignment bits, floor, and the source of those parameters, with `N_FMA ∣ k`. Its
schedule is `k / N_FMA` contiguous groups in increasing k (`chunks`), `run` rejects any
operand list whose length is not `k`, and `output` is the last group's FP32 bits. Three paths are pinned: `v100Wmma16` (four groups of four),
`ampereWmma16` (two of eight), and `hopperWmma16` (one of sixteen). The command
`tc_instruction "ampere-wmma-k16"` prints a pinned path and refuses any other name.

Hardware enters only as a premise. `Conforms path device` says that whenever `path.output`
produces bits for an input, the device produces the same bits; inputs the model rejects leave
the device unconstrained. `conforms_uncorrected_error` then gives, for that device, the
model's last-group output and the composed error bound against the original-input ideal. No
theorem asserts `Conforms` for any real GPU.

Two facts make the published vectors meaningful for whole instructions.
`zero_products_passthrough` proves a group of zero products returns its accumulator input
unchanged (for any finite input other than `−0`, using the decoder/encoder round trip and
floor inactivity), and `single_group_output` proves that an input with nonzero products only
in the first group yields that group's output from the whole instruction. So each published
row is one test of the instruction path under the increasing-k rule. What the rows do not
test is the order of two nonzero groups; `Regression.ampere_instruction_order_matters` is a
k = 16 Ampere input whose two group orders give different bits (`33800000` versus `0`) for the
same exact dot product, and is the template for a distinguishing GPU measurement.

## What remains

1. **Boundary operators beyond the encoded boundary.** The Fig. 5c path combines two
   interleaved groups and adds c late with RNE. Model boundaries as data (encoded conversion,
   unnormalized combination, scalar addition) with a loss lemma each, a ledger generic over
   the boundary list, and an `interleavedPairs` grouping. Assign it to hardware only after the
   FP8 output-precision question in FEATURE_COVERAGE.md is settled.
2. **Programs and matrices.** Extend `Program` with `mma path A B C` at tile granularity,
   elaborated to one instruction schedule per output cell, with a mapping theorem showing
   every `aᵢₗ·bₗⱼ` is used once with the right c. Reordering k or moving a group boundary is a
   different schedule; the DSL should make that a visible choice.
3. **Measurement.** Run inputs like `ampere_instruction_order_matters` on the target GPUs and
   record the results as `Conforms` evidence next to the descriptors.
