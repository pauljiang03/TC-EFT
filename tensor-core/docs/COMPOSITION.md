# Composition of invocations

The model's unit is one normalization group: K products and c, aligned once, summed
exactly, converted once. A PTX or WMMA instruction can contain several groups, and a long dot
product chains many instructions. This note records what the sources establish about how
groups compose, what the Lean model does today, and how to model composition through
metaprogramming.

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

## What the Lean model does today

`runBlocks` follows the supplied list of groups; each group's output bits are decoded as
the next c. `runBlocks_residual_ledger` proves `c0 + Σ Pj = dm + Σ ej` for any finite list,
with every local residual `ej` kept exactly. `runBlocks_uncorrected_error` bounds the final
uncorrected error by the sum of the traces' local budgets, and `fp16Fp32_schedule_machine_eq`
carries the modular-accumulator equivalence through every encoded boundary. `Program` adds
sequencing and bounded repetition; `runBlocks_append` and `runBlocks_repeat_invariant` are
the composition rules.

`OrderedPartition` and `canonicalPartition` turn a long list of original operand pairs into
contiguous fixed-size groups in increasing k, padding only a partial tail with zero pairs,
with the original ideal preserved by proof. When the schedule is that partition, this is
exactly the GEMM.m rule, and `runCanonicalDot` executes it with proved group count, error
bound, and machine equivalence. Nothing in the model infers a hardware order; the order is an
input, and `Regression.partition_order_changes_output` shows that reversing two groups can
change the bits while the ideal is unchanged.

## Modeling composition with metaprogramming

Three layers, each ordinary Lean data with an evaluator. Elaborators build the data and apply
existing theorems; they never define a second semantics.

1. **Boundary operators as data.** A schedule is a list of invocation descriptions with a
   boundary between consecutive groups: `encoded fmt mode` (decode the actual encoding, the
   only operator today), `unnormalizedSum mode` (align two group sums with a stated rounding,
   the MATLAB odd/even operator), and `scalarAdd fmt mode` (the late-c step). Each operator
   gets its own loss lemma. The ledger theorem is generic over the boundary list;
   `fold_residual_ledger` already has that shape.
2. **Instruction descriptors.** An `InstructionPath` records architecture, opcode or API,
   shape, formats, and a partition of the k indices into ordered groups such as
   `contiguous 4` or `interleavedPairs 2`. A command `tc_instruction` produces the descriptor
   and the derived schedule for a given k, and refuses paths whose grouping has no source.
   A theorem `instruction_schedule_sound` states that running the derived schedule equals
   running the flattened group list. Because ordering is empirical, a descriptor carries an
   evidence record, and every theorem about a real instruction takes `Conforms path` as an
   explicit premise rather than an axiom.
3. **Programs and matrices.** Extend `Program` with `mma path A B C` at tile granularity.
   The elaborator produces one schedule per output cell, the mapping theorem shows every
   `aᵢₗ·bₗⱼ` is used once with the right c, and the per-cell ledger and error contracts then
   apply unchanged. Reordering k or moving a group boundary is a different schedule; the DSL
   should make that a visible choice, and equivalence proofs or checked counterexamples
   (R1 is one) decide when two schedules agree.

What would settle the open ordering questions: vectors that place nonzero products in
different k positions of one instruction, with a c chosen so that group order changes the
truncation (the interleaving test in §4.1.6 is the template), run on the target GPU and
recorded as `Conforms` evidence next to the descriptor.
