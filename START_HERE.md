# Start here — tensor-core Lean project

This is the fresh-context entry point, updated 5 September 2026.

The user defines **one invocation as one dot product with unnormalized
products and a block accumulation**, including its alignment/output behavior.
Finish the general parameterized model and proofs for that unit first.
EFT is a separate invocation-local application. Downstream composition,
programs, and hardware mapping are planned work to implement afterward.

Read in this order:

1. [Context handoff](tensor-core/docs/CONTEXT_HANDOFF.md): current code,
   verification, source files, limitations, and resumption instructions.
2. [Current plan](tensor-core/docs/CURRENT_PLAN.md): authoritative priorities,
   feature coverage gate, and concrete later implementation gates.
3. [Status](tensor-core/docs/STATUS.md) and
   [specification](tensor-core/docs/SPECIFICATION.md): completed results and
   pinned numerical decisions.

The original [Astra handoff](lean-tensor-core-astra-handoff.md) and historical
reviews remain useful background, but their work ordering is superseded.
The latest increment deliberately stops at documentation/context preparation;
it did not implement the next feature or proof steps.

Suggested prompt for resuming:

> Read START_HERE.md and the linked context handoff/current plan. Continue with
> the feature coverage matrix and the general single-invocation contract.
> Preserve the existing work; finish the single-dot-product feature model
> before expanding downstream composition. Keep the later gates in the roadmap.
