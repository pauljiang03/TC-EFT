import TensorCore.Theory.EFMachine.Extraction

namespace TensorCore.EFMachine

set_option exponentiation.threshold 1024

theorem Word.sameValue_value {x y : Word} (h : x.sameValue y = true) : x.value = y.value := by
  simp only [Word.sameValue, Bool.and_eq_true, beq_iff_eq, Bool.or_eq_true] at h
  obtain ⟨hm, hs⟩ := h
  rcases hs with hz | hs
  · have hy : y.magnitude = 0 := hm.symm.trans hz
    simp [Word.value, Word.coefficient, hz, hy, Rat.zero_mul]
  · simp [Word.value, Word.coefficient, hm, hs]

theorem Word.exact32_value {x : Word} {b : F32} (h : x.exact32 = some b) :
    TensorCore.value32 b = some x.value := by
  unfold Word.exact32 at h
  cases hb : x.round32 with
  | none => simp [hb] at h
  | some r =>
    cases hd : decode32Word r with
    | none => simp [hb, hd] at h
    | some y =>
      simp [hb, hd] at h
      obtain ⟨he, rfl⟩ := h
      rw [← decode32Word_value, hd, Option.map_some, Word.sameValue_value he]

/-- The executable scalar primitive is exactly one finite-range nearest-even FP32
addition. Its wide workspace always accommodates two finite FP32 inputs. -/
theorem add32_eq (a b : F32) :
    add32 a b = (do
      let x ← TensorCore.value32 a
      let y ← TensorCore.value32 b
      TensorCore.round32 .nearestEven (x + y)) := by
  rw [← decode32Word_value, ← decode32Word_value]
  cases ha : decode32Word a with
  | none => simp [add32, ha]
  | some x =>
    cases hb : decode32Word b with
    | none => simp [add32, ha, hb]
    | some y =>
      have hx := decode32Word_magnitude ha
      have hy := decode32Word_magnitude hb
      obtain ⟨z, hz⟩ := x.add_exists y (by omega)
      simp [add32, ha, hb, hz, Word.round32_eq, Word.add_value hz]

/-- Exact-intermediate checks make scalar acceptance sound even when a sufficient
support predicate is conservative. No assumption about scalarSum accuracy is hidden. -/
theorem Components.scalar_correct {c : Components} {b : F32} (hc : c.scalar = some b) :
    TensorCore.round32 .nearestEven (c.retained.value + c.residualSum.value) = some b := by
  unfold Components.scalar at hc
  split at hc
  · contradiction
  · cases he : scalarSum c.low with
    | none => simp [he] at hc
    | some eb =>
      cases hed : decode32Word eb with
      | none => simp [he, hed] at hc
      | some e =>
        simp [he, hed] at hc
        obtain ⟨hev, hc⟩ := hc
        have hev' : e.value = c.residualSum.value := Word.sameValue_value (by simpa using hev)
        cases hd : c.prepared.output.exact32 with
        | none => simp [hd] at hc
        | some db =>
          cases ho : c.overlap.neg.exact32 with
          | none => simp [hd, ho] at hc
          | some ob =>
            cases hh : add32 db ob with
            | none => simp [hd, ho, hh] at hc
            | some hb =>
              cases hhd : decode32Word hb with
              | none => simp [hd, ho, hh, hhd] at hc
              | some h =>
                simp [hd, ho, hh, hhd] at hc
                obtain ⟨hhv, hc⟩ := hc
                have hhv' : h.value = c.retained.value := Word.sameValue_value (by simpa using hhv)
                rw [add32_eq, ← decode32Word_value, ← decode32Word_value, hhd, hed] at hc
                simpa [hhv', hev'] using hc
end TensorCore.EFMachine
