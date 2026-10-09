import MatrixCore

/-! # Chained blocks and contracts

How a downstream proof uses the contracts: one hypothesis about an inner product gives every
block's guarantees and the loss accounting of the whole inner product. -/

open MatrixCore

namespace MatrixCoreTests.Chain

/-- On CDNA 1 every block of an accepted inner product rounds its exact sum to nearest, ties to
even, and the blocks are linked through the words they pass on. -/
example {a b : List (BitVec 16)} {c d : F32} (hlen : a.length = b.length)
    (h : dotBits cdna1F16 a b c = .ok d) :
    ∃ ts : List (BlockTrace cdna1F16), lastOutput c ts = d ∧ Chain c ts ∧
      ∀ t ∈ ts, NearestEven32 t.prepared.exact t.d := by
  obtain ⟨ts, _, hd, hc, hall, _⟩ :=
    dotBits_blocks cdna1F16 (fun _ _ h => cdna1F16_contract h) hlen h
  refine ⟨ts, hd, hc, fun t ht => ?_⟩
  obtain ⟨_, hx⟩ := hall t ht
  exact hx.nearest

/-- On CDNA 3 fp16 every block of an inner product has the same trace with 30-bit registers. -/
example {a b : List (BitVec 16)} {c d : F32} (hlen : a.length = b.length)
    (h : dotBits cdna3F16 a b c = .ok d) :
    ∀ t ∈ ((runBlocks cdna3F16 c (blocks cdna3F16 a b)).toOption.getD []),
      ∃ x, evalBlockMachine 30 x = .ok t := by
  obtain ⟨ts, hr, _, _, hall, _⟩ :=
    dotBits_blocks cdna3F16 (fun _ _ h => cdna3F16_contract h) hlen h
  rw [hr]
  intro t ht
  obtain ⟨x, hx⟩ := hall t ht
  exact ⟨x, hx.register⟩

/-- Nine fp16 products `1 · 1` on CDNA 3 (two blocks of eight, the second padded) with `c = 0`. -/
def nine : List (BitVec 16) := List.replicate 9 0x3C00

example : dotBits cdna3F16 nine nine 0 = .ok 0x41100000 := by decide +kernel

/-- The run has two blocks, the first passing `8` to the second. -/
example : (runBlocks cdna3F16 0 (blocks cdna3F16 nine nine)).map (·.map BlockTrace.d) =
    .ok [0x41000000, 0x41100000] := by decide +kernel

end MatrixCoreTests.Chain
