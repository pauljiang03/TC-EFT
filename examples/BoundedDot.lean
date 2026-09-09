import TensorCore.TC.Examples.BoundedDot

open TensorCore

-- Symbolic operands and length: this proof never executes the dot product or its prefixes.
example (xs : List (F16 × F16)) (initial : Finite32) (hlen : xs.length ≤ 256)
    (hs : ∀ pair ∈ xs, small16 pair.1 = true ∧ small16 pair.2 = true)
    (hc : absQ initial.value ≤ 1) :
    (boundedDot xs).Accurate initial.bits (1 / 2048) :=
  boundedDot_accurate xs initial hlen hs hc

-- A symbolic changing-state repetition, under a total group-count bound.
example (body : Program v100F16F32) (n : ℕ) (initial : Finite32)
    (hn : n * body.inputs.length ≤ 64)
    (hs : ∀ g ∈ body.inputs, ∀ pair ∈ g, small16 pair.1 = true ∧ small16 pair.2 = true)
    (hc : absQ initial.value ≤ 1) :
    (Program.repeat n body).Accurate initial.bits (1 / 2048) :=
  small_repeat_accurate body n initial hn hs hc

#print axioms boundedDot_accurate
#print axioms small_repeat_accurate
