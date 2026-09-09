import TensorCore.EFT.Algorithm1

/-! TC-EFT Algorithm 1 with its paper interface: encoded operands, an explicit profile,
and a supplied finite FP32 output D. Preparation decodes the original operands; terms,
raw scales, grids, and components are reconstructed from them. No tensor-core evaluation
is performed, and exact recovery does not require the supplied D to conform to the model. -/

namespace TensorCore

/-- Lines 3–6: decode operands and supplied D, preserving raw-product metadata. -/
def prepareEncodedEFT {p : Profile} (x : BlockInput p) (D : F32) : Except ModelError BlockTrace :=
  if x.products.length != p.products then .error .wrongProductCount
  else match prepare x with
    | none => .error .nonfiniteInput
    | some b => match finite32 D with
      | none => .error .nonfiniteOutput
      | some d => .ok ⟨b, d⟩

/-- The paper's zero shortcut is distinct from the two consolidation branches. -/
inductive EncodedEFTResult where
  | allZero
  | consolidated (result : Algorithm1Result)
  deriving Repr, DecidableEq

def EncodedEFTResult.bits : EncodedEFTResult → Option F32
  | .allZero => some 0
  | .consolidated r => r.bits

def PreparedBlock.allZeroTerms (b : PreparedBlock) : Bool :=
  b.terms.all fun t => t.significand == 0

/-- Algorithm 1: check the finite encoded interface, return +0 for all-zero terms,
otherwise reconstruct the grids and overlap components and execute the two-branch reference.
The range failure is retained as `.consolidated .outOfRange`. -/
def algorithm1Encoded {p : Profile} (x : BlockInput p) (D : F32) :
    Except ModelError EncodedEFTResult :=
  match prepareEncodedEFT x D with
  | .error e => .error e
  | .ok t => .ok (if t.block.allZeroTerms then .allZero else .consolidated t.algorithm1)

theorem prepareEncodedEFT_spec {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) :
    x.products.length = p.products ∧ prepare x = some t.block ∧ finite32 D = some t.output := by
  unfold prepareEncodedEFT at h
  split at h
  · contradiction
  · rename_i hs
    cases hp : prepare x with
    | none => simp [hp] at h
    | some b =>
      cases hd : finite32 D with
      | none => simp [hp, hd] at h
      | some d =>
        simp only [hp, hd, Except.ok.injEq] at h
        subst t
        exact ⟨by simpa using hs, rfl, rfl⟩

theorem prepareEncodedEFT_success_iff (p : Profile) (x : BlockInput p) (D : F32) :
    (∃ t, prepareEncodedEFT x D = .ok t) ↔
      x.products.length = p.products ∧ (∃ b, prepare x = some b) ∧ (∃ d, finite32 D = some d) := by
  constructor
  · rintro ⟨t, ht⟩
    obtain ⟨hs, hp, hd⟩ := prepareEncodedEFT_spec ht
    exact ⟨hs, ⟨t.block, hp⟩, ⟨t.output, hd⟩⟩
  · rintro ⟨hs, ⟨b, hp⟩, ⟨d, hd⟩⟩
    exact ⟨⟨b, d⟩, by simp [prepareEncodedEFT, hs, hp, hd]⟩

theorem allZeroTerms_exactDot {b : PreparedBlock} (h : b.allZeroTerms = true) : b.exactDot = 0 := by
  rw [← terms_value]
  have hz : ∀ t ∈ b.terms, t.value = 0 := by
    intro t ht
    have hs := (List.all_eq_true.mp h) t ht
    have hs' : t.significand = 0 := by simpa using hs
    simp [RawProduct.value, hs']
  generalize b.terms = ts at *
  induction ts with
  | nil => rfl
  | cons t ts ih =>
    simp only [List.map_cons, sumQ, hz t (by simp), Rat.zero_add]
    exact ih (by intro u hu; exact hz u (by simp [hu]))

/-- Bit equality for the trace algorithm, including rejection outside the finite ideal range. -/
theorem algorithm1_bits_eq_round (t : BlockTrace) :
    t.algorithm1.bits = round32 .nearestEven t.block.exactDot := by
  unfold BlockTrace.algorithm1
  cases hs : t.scalarCorrected with
  | some b =>
    have hp : t.scalarPredicate = true := (tceft_isSome_iff t).mp (by
      change t.scalarCorrected.isSome = true
      rw [hs]; rfl)
    exact (hs.symm.trans (scalarCorrected_eq t hp))
  | none =>
    rw [exactConsolidation_eq_corrected, corrected_eq_round_exactDot]
    cases round32 .nearestEven t.block.exactDot <;> rfl

/-- The all-zero shortcut agrees in bits with Algorithm 1 on the reconstructed trace. -/
theorem algorithm1Encoded_agrees {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) :
    (algorithm1Encoded x D).map EncodedEFTResult.bits = .ok t.algorithm1.bits := by
  simp only [algorithm1Encoded, h, Except.map]
  split
  · rename_i hz
    rw [algorithm1_bits_eq_round, allZeroTerms_exactDot hz]
    rw [show round32 .nearestEven 0 = some 0 by decide +kernel]
    rfl
  · rfl

/-- Nonzero inputs preserve the trace algorithm's branch as well as its bits. -/
theorem algorithm1Encoded_nonzero {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) (hz : t.block.allZeroTerms = false) :
    algorithm1Encoded x D = .ok (.consolidated t.algorithm1) := by
  simp [algorithm1Encoded, h, hz]

theorem algorithm1Encoded_allZero {p : Profile} {x : BlockInput p} {D : F32} {t : BlockTrace}
    (h : prepareEncodedEFT x D = .ok t) (hz : t.block.allZeroTerms = true) :
    algorithm1Encoded x D = .ok .allZero := by simp [algorithm1Encoded, h, hz]

/-- Returned bits round the independent decoded original-input ideal, for any finite D. -/
theorem algorithm1Encoded_correct {p : Profile} {x : BlockInput p} {D b : F32}
    {r : EncodedEFTResult} (h : algorithm1Encoded x D = .ok r) (hb : r.bits = some b) :
    ∃ z, exactDot x = some z ∧ NearestEven32 z b := by
  cases ht : prepareEncodedEFT x D with
  | error e => simp [algorithm1Encoded, ht] at h
  | ok t =>
    have he := algorithm1Encoded_agrees ht
    rw [h] at he
    simp only [Except.map, Except.ok.injEq] at he
    have ha : t.algorithm1.bits = some b := he.symm.trans hb
    exact ⟨t.block.exactDot, by simp [exactDot, (prepareEncodedEFT_spec ht).2.1],
      algorithm1_correct t b ha⟩

/-- After finite input decoding, an encoding exists exactly when the independent ideal fits. -/
theorem algorithm1Encoded_bits_isSome_iff {p : Profile} {x : BlockInput p} {D : F32}
    {t : BlockTrace} (h : prepareEncodedEFT x D = .ok t) :
    (algorithm1Encoded x D).map (fun r => r.bits.isSome) = .ok true ↔
      ∃ z, exactDot x = some z ∧ absQ z ≤ maxFinite32 := by
  have he := algorithm1Encoded_agrees h
  have hm : (algorithm1Encoded x D).map (fun r => r.bits.isSome) = .ok t.algorithm1.bits.isSome := by
    cases hr : algorithm1Encoded x D with
    | error e => simp [hr, Except.map] at he
    | ok r =>
      simp only [hr, Except.map, Except.ok.injEq] at he
      simp only [Except.map, he]
  rw [hm]
  simpa [exactDot, (prepareEncodedEFT_spec h).2.1] using algorithm1_bits_isSome_iff t

/-- A model evaluation supplies exactly the same decoded trace at this public interface. -/
theorem prepareEncodedEFT_of_evalBlock {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) : prepareEncodedEFT x t.output.bits = .ok t := by
  have hs : x.products.length = p.products := by
    unfold evalBlock at h
    split at h <;> simp_all
  have hd : finite32 t.output.bits = some t.output := by
    unfold finite32
    split
    · rename_i hd
      rw [t.output.valid] at hd
      contradiction
    · rename_i d hd
      rw [t.output.valid] at hd
      cases Option.some.inj hd
      rfl
  simp only [prepareEncodedEFT, hs, bne_self_eq_false, Bool.false_eq_true, ↓reduceIte,
    evalBlock_prepared h, hd]

theorem algorithm1Encoded_of_evalBlock {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) :
    (algorithm1Encoded x t.output.bits).map EncodedEFTResult.bits = .ok t.algorithm1.bits :=
  algorithm1Encoded_agrees (prepareEncodedEFT_of_evalBlock h)

end TensorCore
