import TensorCore.Theory.Format
import TensorCore.Theory.Alignment
import TensorCore.Theory.AccumulatorWidth
import TensorCore.Theory.StageResiduals

namespace TensorCore

private def maxStep (acc : Option Int) (e : Int) : Option Int :=
  some (match acc with | none => e | some v => max v e)

private theorem fold_max_preserves (es : List Int) (e lower : Int) (h : lower ≤ e) :
    ∃ eta, es.foldl maxStep (some e) = some eta ∧ lower ≤ eta := by
  induction es generalizing e with
  | nil => exact ⟨e, rfl, h⟩
  | cons x xs ih =>
    apply ih (max e x)
    omega

private theorem fold_max_member (es : List Int) (acc : Option Int) (e : Int)
    (h : e ∈ es) : ∃ eta, es.foldl maxStep acc = some eta ∧ e ≤ eta := by
  induction es generalizing acc with
  | nil => simp at h
  | cons x xs ih =>
    simp only [List.mem_cons] at h
    rcases h with h | h
    · subst x
      cases acc with
      | none => exact fold_max_preserves xs e e (by omega)
      | some v => exact fold_max_preserves xs (max v e) e (by omega)
    · exact ih (maxStep acc x) h

theorem alignmentScale_term (ts : List RawProduct) (t : RawProduct)
    (hmem : t ∈ ts) (hnz : t.significand ≠ 0) :
    ∃ eta, alignmentScale ts = some eta ∧ t.rawScale ≤ eta := by
  apply fold_max_member
  apply List.mem_filterMap.mpr
  exact ⟨t, hmem, by simp [hnz]⟩

theorem alignmentScale_none (ts : List RawProduct) :
    alignmentScale ts = none ↔ ∀ t ∈ ts, t.significand = 0 := by
  constructor
  · intro h t ht
    by_cases hnz : t.significand = 0
    · exact hnz
    · obtain ⟨eta, he, _⟩ := alignmentScale_term ts t ht hnz
      rw [h] at he
      contradiction
  · intro h
    have hf : (ts.filterMap fun t => if t.significand = 0 then none else some t.rawScale) = [] := by
      apply List.filterMap_eq_nil_iff.mpr
      intro t ht
      simp [h t ht]
    simp [alignmentScale, hf]

theorem eta_term (b : PreparedBlock) (t : RawProduct) (ht : t ∈ b.terms)
    (hnz : t.significand ≠ 0) :
    ∃ eta, b.eta = some eta ∧ t.rawScale ≤ eta := by
  obtain ⟨e, he, hle⟩ := alignmentScale_term b.terms t ht hnz
  cases hf : b.profile.alignFloor with
  | none => exact ⟨e, by simp [PreparedBlock.eta, Profile.applyFloor, he, hf], hle⟩
  | some f => exact ⟨max e f, by simp [PreparedBlock.eta, Profile.applyFloor, he, hf], by omega⟩

/-- A common bound for c (significand below two) and raw products (below four). -/
def RawProduct.Bounded (t : RawProduct) : Prop := absQ t.value < 4 * pow2 t.rawScale

theorem rawMul_bounded (a b : Decoded) (ha : a.Bounded) (hb : b.Bounded) :
    (rawMul a b).Bounded := by
  have hpa := pow2_pos a.rawScale
  have hpb := pow2_pos b.rawScale
  have hna := absQ_nonneg a.value
  have hnb := absQ_nonneg b.value
  have hm : absQ (a.value * b.value) = absQ a.value * absQ b.value := by
    by_cases hz : b.value = 0
    · simp [hz, absQ]
    · by_cases hpos : 0 < b.value
      · rw [absQ_mul_pos _ _ hpos, absQ_of_nonneg (Rat.le_of_lt hpos)]
      · have hneg : b.value < 0 := by grind
        have hm := absQ_mul_pos a.value (-b.value) (by grind)
        rw [Rat.mul_neg, absQ_neg] at hm
        rw [hm, absQ_of_neg hneg]
  change absQ (rawMul a b).value < 4 * pow2 (a.rawScale + b.rawScale)
  rw [rawProduct_value, hm, pow2_add]
  unfold Decoded.Bounded at ha hb
  have h1 := Rat.mul_le_mul_of_nonneg_right (Rat.le_of_lt ha) hnb
  have h2 := Rat.mul_lt_mul_of_pos_left hb (show 0 < 2 * pow2 a.rawScale by grind)
  grind

theorem c_term_bounded (c : Decoded) (hc : c.Bounded) :
    (RawProduct.mk c.significand c.rawScale c.fractionalBits).Bounded := by
  have hp := pow2_pos c.rawScale
  change absQ c.value < 4 * pow2 c.rawScale
  unfold Decoded.Bounded at hc
  grind

/-- Truncation never increases the magnitude of a scaled value. -/
theorem truncCoeff_abs_le (x : Rat) (e : Int) :
    ((truncCoeff x e).natAbs : Rat) ≤ absQ x / pow2 e := by
  have hp := pow2_pos e
  unfold truncCoeff
  split
  · rename_i hx
    have hn : 0 ≤ -x / pow2 e := by
      have := Rat.div_lt_iff (a := -x) (c := 0) hp
      grind
    have hf : 0 ≤ (-x / pow2 e).floor := Rat.le_floor_iff.mpr hn
    rw [Int.natAbs_neg, ← Rat.intCast_natCast, Int.natAbs_of_nonneg hf, absQ_of_neg hx]
    exact Rat.floor_le _
  · rename_i hx
    have hn : 0 ≤ x / pow2 e := by
      have := Rat.div_lt_iff (a := x) (c := 0) hp
      grind
    have hf : 0 ≤ (x / pow2 e).floor := Rat.le_floor_iff.mpr hn
    rw [← Rat.intCast_natCast, Int.natAbs_of_nonneg hf, absQ_of_nonneg (by grind)]
    exact Rat.floor_le _

/-- Two integer magnitude bits plus F fractional bits suffice for each aligned term. -/
theorem aligned_term_coefficient_bound (t : RawProduct) (eta : Int) (F : Nat)
    (ht : t.Bounded) (he : t.rawScale ≤ eta) :
    (truncCoeff t.value (eta - F)).natAbs < 2 ^ (F + 2) := by
  have hq := pow2_pos (eta - F)
  have hp := pow2_le_of_le he
  have hs := truncCoeff_abs_le t.value (eta - F)
  have hb : absQ t.value < 4 * pow2 eta := by unfold RawProduct.Bounded at ht; grind
  have heq : ((2 ^ (F + 2) : Nat) : Rat) * pow2 (eta - F) = 4 * pow2 eta := by
    rw [← pow2_natCast, ← pow2_add]
    have he' : ((F + 2 : Nat) : Int) + (eta - F) = eta + 2 := by omega
    rw [he', pow2_add]
    have htwo : pow2 2 = 4 := by decide
    rw [htwo, Rat.mul_comm]
  have hb' : absQ t.value / pow2 (eta - F) < ((2 ^ (F + 2) : Nat) : Rat) := by
    apply (Rat.div_lt_iff hq).mpr
    rwa [heq]
  apply Rat.natCast_lt_natCast.mp
  grind

theorem prepareProducts_bounds (p : Profile) (ps : List (p.Word × p.Word))
    (qs : List (Decoded × Decoded)) (h : prepareProducts p ps = some qs) :
    qs.length = ps.length ∧ ∀ q ∈ qs, q.1.Bounded ∧ q.2.Bounded := by
  induction ps generalizing qs with
  | nil =>
    simp [prepareProducts] at h
    subst qs
    simp
  | cons pair ps ih =>
    rcases pair with ⟨a, b⟩
    cases ha : p.decode a with
    | none => simp [prepareProducts, List.mapM_cons, ha] at h
    | some da =>
      cases hb : p.decode b with
      | none => simp [prepareProducts, List.mapM_cons, ha, hb] at h
      | some db =>
        cases ht : prepareProducts p ps with
        | none =>
          simp [prepareProducts] at ht
          simp [prepareProducts, List.mapM_cons, ha, hb, ht] at h
        | some ds =>
          have hcons : qs = (da, db) :: ds := by
            have ht' := ht
            simp [prepareProducts] at ht'
            simpa [prepareProducts, List.mapM_cons, ha, hb, ht'] using h.symm
          subst qs
          have hi := ih ds ht
          constructor
          · simpa using hi.1
          · intro q hq
            simp only [List.mem_cons] at hq
            rcases hq with hq | hq
            · subst q
              exact ⟨classifyNat_bounded p.input a.toNat da ha,
                classifyNat_bounded p.input b.toNat db hb⟩
            · exact hi.2 q hq

theorem prepare_terms_bounded {p : Profile} {x : BlockInput p} {b : PreparedBlock}
    (h : prepare x = some b) :
    b.terms.length = x.products.length + 1 ∧ ∀ t ∈ b.terms, t.Bounded := by
  unfold prepare at h
  cases hc : decode32 x.c with
  | none => simp [hc] at h
  | some c =>
    cases hp : prepareProducts p x.products with
    | none => simp [hc, hp] at h
    | some ps =>
      simp [hc, hp] at h
      subst b
      have hps := prepareProducts_bounds p x.products ps hp
      constructor
      · simpa [PreparedBlock.terms] using hps.1
      · intro t ht
        simp only [PreparedBlock.terms, List.mem_cons, List.mem_map] at ht
        rcases ht with ht | ⟨q, hq, ht⟩
        · subst t
          exact c_term_bounded c (classifyNat_bounded fp32 x.c.toNat c hc)
        · subst t
          exact rawMul_bounded q.1 q.2 (hps.2 q hq).1 (hps.2 q hq).2

theorem prepared_coefficient_bound (b : PreparedBlock) (F : Nat)
    (hF : b.profile.alignFraction = F) (ht : ∀ t ∈ b.terms, t.Bounded) :
    ∀ z ∈ b.coefficients, z.natAbs < 2 ^ (F + 2) := by
  intro z hz
  obtain ⟨t, hmem, rfl⟩ := List.mem_map.mp hz
  by_cases hzero : t.significand = 0
  · simp [RawProduct.value, hzero, truncCoeff, Rat.div_def]
    exact Nat.two_pow_pos _
  · obtain ⟨eta, he, hle⟩ := eta_term b t hmem hzero
    have hq : b.quantumExponent = eta - F := by
      simp [PreparedBlock.quantumExponent, he, hF]
    rw [hq]
    exact aligned_term_coefficient_bound t eta F (ht t hmem) hle

/-- Capacity follows from finite decoded inputs and shape, before any output-range check. -/
theorem prepare_coefficient_capacity {p : Profile} {x : BlockInput p} {b : PreparedBlock}
    (hp : prepare x = some b) (hshape : x.products.length = p.products) (F carryBits : Nat)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits) :
    magnitudeSum b.coefficients < 2 ^ ((F + 2 + carryBits + 1) - 1) := by
  have hb := prepare_terms_bounded hp
  have hprof := prepare_profile hp
  apply coefficient_width_sufficient
  · exact prepared_coefficient_bound b F (by rw [hprof, hF]) hb.2
  · simpa [PreparedBlock.coefficients, hb.1, hshape] using hcount

/-- Width derived from decoded inputs, with c included in the member count. -/
theorem evalBlock_coefficient_capacity {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) (F carryBits : Nat)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits) :
    magnitudeSum t.block.coefficients < 2 ^ ((F + 2 + carryBits + 1) - 1) := by
  have hshape : x.products.length = p.products := by
    unfold evalBlock at h
    split at h <;> simp_all
  exact prepare_coefficient_capacity (evalBlock_prepared h) hshape F carryBits hF hcount

theorem evalBlock_machineAccumulator {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) (F carryBits : Nat)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits) :
    t.block.machineAccumulator (F + 2 + carryBits + 1) = t.block.accumulator :=
  machineAccumulator_eq _ _ (by omega) (evalBlock_coefficient_capacity h F carryBits hF hcount)

/-- Every prefix of a successful encoded invocation is safe at the derived width. -/
theorem evalBlock_machinePrefix {p : Profile} {x : BlockInput p} {t : BlockTrace}
    (h : evalBlock x = .ok t) (F carryBits : Nat)
    (hF : p.alignFraction = F) (hcount : p.products + 1 ≤ 2 ^ carryBits)
    (xs ys : List Int) (hsplit : t.block.coefficients = xs ++ ys) :
    (machineAccumulate (F + 2 + carryBits + 1) 0 xs).toInt = sumZ xs := by
  apply machineAccumulate_prefix_exact _ xs ys (by omega)
  rw [← hsplit]
  exact evalBlock_coefficient_capacity h F carryBits hF hcount

/-- The conservative V100 bound is 29 signed bits: 25 magnitude bits per term,
three carry bits for five terms, and one sign bit. This is not a device register claim. -/
theorem evalV100_machineAccumulator {x : BlockInput v100F16F32} {t : BlockTrace}
    (h : evalV100 x = .ok t) : t.block.machineAccumulator 29 = t.block.accumulator :=
  evalBlock_machineAccumulator h 23 3 rfl (by decide)

end TensorCore
