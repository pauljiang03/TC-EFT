import TensorCore.Theory.AlignmentScale
import TensorCore.Theory.ErrorBounds
import TensorCore.Theory.AcceptedDomain
import TensorCore.Theory.Padding
import TensorCore.Theory.RoundTrip
import TensorCore.Programs.ErrorBounds
import TensorCore.Programs.EFT

/-! Error budgets derived from operand scales instead of from traces. A scale bound `E` on
the decoded operands of a block bounds the alignment grid by `2^(E−F)`, the accumulator by
`2^(E+2+L)` for `n ≤ 2^L` terms, and therefore the output quantum. The resulting budget
`staticBudget n F E L` is computed from the inputs alone; under it a block is accepted and
its uncorrected error is below the budget. For a schedule, a bound on the ideal partial sums
keeps every accumulator input within scale `E`, so the whole run is accepted and its final
error is at most the number of groups times the budget. -/

namespace TensorCore

/-- Every nonzero term has raw scale at most `E`. -/
def ScaleBounded (ts : List RawProduct) (E : Int) : Prop :=
  ∀ t ∈ ts, t.significand ≠ 0 → t.rawScale ≤ E

theorem magnitudeExponent_le_of_lt (x : Rat) (hx : 0 < x) (e : Int) (h : x < pow2 (e + 1)) :
    magnitudeExponent x ≤ e := by
  obtain ⟨hlo, _⟩ := magnitudeExponent_spec x hx
  apply Classical.byContradiction
  intro hne
  have hle : e + 1 ≤ magnitudeExponent x := by omega
  have := pow2_le_of_le hle
  grind

theorem convExp_le_of_lt (x : Rat) (hx : 0 < x) (e : Int) (h : x < pow2 (e + 1)) :
    convExp x ≤ max e (-126) := by
  unfold convExp emin32
  have := magnitudeExponent_le_of_lt x hx e h
  omega

/-- Truncation toward zero loses less than the conversion grid of the input magnitude. -/
theorem rtz_residual_lt (x : Rat) (b : F32) (d : Rat) (hr : absQ x ≤ maxFinite32)
    (hb : round32 .towardZero x = some b) (hd : value32 b = some d) :
    absQ (x - d) < pow2 (convExp (absQ x) - 23) := by
  by_cases hx : x = 0
  · subst x
    have hz : round32 .towardZero 0 = some 0 := by decide +kernel
    rw [hz] at hb
    cases Option.some.inj hb
    have hv : value32 0 = some 0 := by decide +kernel
    rw [hv] at hd
    cases Option.some.inj hd
    have ha : absQ (0 - 0) = 0 := by decide +kernel
    rw [ha]; exact pow2_pos _
  · obtain ⟨b', hb', hd', _, _⟩ := round32_nonzero_spec .towardZero x hx hr
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hd] at hd'
    rw [Option.some.inj hd']
    exact rtz_signed_residual x

/-- A bounded term of scale at most `E` has magnitude below `4·2^E`. -/
theorem term_abs_lt (t : RawProduct) (E : Int) (hb : t.Bounded)
    (hs : t.significand ≠ 0 → t.rawScale ≤ E) : absQ t.value < 4 * pow2 E := by
  have hE := pow2_pos E
  by_cases hz : t.significand = 0
  · have hv : t.value = 0 := by simp [RawProduct.value, hz]
    rw [hv]
    have : absQ 0 = 0 := by decide +kernel
    rw [this]
    grind
  · have hle := pow2_le_of_le (hs hz)
    unfold RawProduct.Bounded at hb
    grind

theorem truncGrid_abs_le (x : Rat) (e : Int) : absQ (truncGrid x e) ≤ absQ x := by
  have hq := pow2_pos e
  have h := truncCoeff_abs_le x e
  unfold truncGrid
  rw [absQ_mul_pos _ _ hq, absQ_intCast]
  have := Rat.mul_le_mul_of_nonneg_right h (Rat.le_of_lt hq)
  rwa [Rat.div_mul_cancel (Rat.ne_of_gt hq)] at this

theorem absQ_sumQ_le (xs : List Rat) : absQ (sumQ xs) ≤ sumQ (xs.map absQ) := by
  induction xs with
  | nil =>
    simp only [sumQ, List.map_nil]
    have : absQ 0 = 0 := by decide +kernel
    rw [this]
    exact Rat.le_refl
  | cons x xs ih =>
    simp only [sumQ, List.map_cons]
    have := absQ_add_le x (sumQ xs)
    grind

theorem sumQ_map_le (xs : List α) (f : α → Rat) (B : Rat) (h : ∀ x ∈ xs, f x ≤ B) :
    sumQ (xs.map f) ≤ (xs.length : Rat) * B := by
  induction xs with
  | nil =>
    simp only [List.map_nil, sumQ, List.length_nil]
    grind
  | cons x xs ih =>
    have hx := h x (by simp)
    have hrest := ih (fun y hy => h y (by simp [hy]))
    have hs : ((xs.length + 1 : Nat) : Rat) = (xs.length : Rat) + 1 := by
      rw [Rat.natCast_add]; rfl
    simp only [List.map_cons, sumQ, List.length_cons, hs]
    grind

theorem sumQ_map_lt (xs : List α) (hne : xs ≠ []) (f : α → Rat) (B : Rat)
    (h : ∀ y ∈ xs, f y < B) : sumQ (xs.map f) < (xs.length : Rat) * B := by
  cases xs with
  | nil => exact absurd rfl hne
  | cons x xs =>
    have hx := h x (by simp)
    have hrest := sumQ_map_le xs f B (fun y hy => Rat.le_of_lt (h y (by simp [hy])))
    have hs : ((xs.length + 1 : Nat) : Rat) = (xs.length : Rat) + 1 := by
      rw [Rat.natCast_add]; rfl
    simp only [List.map_cons, sumQ, List.length_cons, hs]
    grind

theorem sumQ_map_abs_truncGrid_le (ts : List RawProduct) (q : Int) :
    sumQ (ts.map fun t => absQ (truncGrid t.value q)) ≤ sumQ (ts.map fun t => absQ t.value) := by
  induction ts with
  | nil => simp only [List.map_nil, sumQ]; exact Rat.le_refl
  | cons t ts ih =>
    simp only [List.map_cons, sumQ]
    have := truncGrid_abs_le t.value q
    grind

theorem sumQ_map_zero (xs : List α) : sumQ (xs.map fun _ => (0 : Rat)) = 0 := by
  induction xs with
  | nil => rfl
  | cons _ _ ih => simp only [List.map_cons, sumQ, ih]; grind

theorem terms_ne_nil (b : PreparedBlock) : b.terms ≠ [] := by
  simp [PreparedBlock.terms]

/-- The accumulator of a scale-bounded block is below `n·4·2^E`. -/
theorem accumulator_abs_lt (b : PreparedBlock) (E : Int) (hb : ∀ t ∈ b.terms, t.Bounded)
    (hs : ScaleBounded b.terms E) :
    absQ b.accumulator < (b.terms.length : Rat) * (4 * pow2 E) := by
  rw [accumulator_value]
  have h1 := absQ_sumQ_le (b.terms.map fun t => truncGrid t.value b.quantumExponent)
  have h2 : sumQ ((b.terms.map fun t => truncGrid t.value b.quantumExponent).map absQ) ≤
      sumQ (b.terms.map fun t => absQ t.value) := by
    rw [List.map_map]
    exact sumQ_map_abs_truncGrid_le b.terms b.quantumExponent
  have h3 : sumQ (b.terms.map fun t => absQ t.value) < (b.terms.length : Rat) * (4 * pow2 E) := by
    apply sumQ_map_lt b.terms (terms_ne_nil b)
    intro t ht
    exact term_abs_lt t E (hb t ht) (hs t ht)
  grind

/-- The alignment grid of a scale-bounded block with floor at most `E` is at most `2^(E−F)`
whenever some term is nonzero. -/
theorem quantumExponent_le (b : PreparedBlock) (E : Int) (hs : ScaleBounded b.terms E)
    (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E) (t : RawProduct) (ht : t ∈ b.terms)
    (hnz : t.significand ≠ 0) : b.quantumExponent ≤ E - b.profile.alignFraction := by
  obtain ⟨e, he, _⟩ := alignmentScale_term b.terms t ht hnz
  have hup := alignmentScale_upper b.terms E hs e (by rw [he]; simp)
  unfold PreparedBlock.quantumExponent PreparedBlock.eta Profile.applyFloor
  rw [he]
  cases hf : b.profile.alignFloor with
  | none => simp; omega
  | some f =>
    have := hfl f (by rw [hf]; simp)
    simp
    omega

/-- Aggregate alignment loss from the scale bound alone. -/
theorem alignment_static_bound (b : PreparedBlock) (E : Int) (hs : ScaleBounded b.terms E)
    (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E) :
    absQ (sumQ b.alignmentResiduals) <
      (b.terms.length : Rat) * pow2 (E - b.profile.alignFraction) := by
  have hq := pow2_pos (E - b.profile.alignFraction)
  by_cases hall : ∀ t ∈ b.terms, t.significand = 0
  · have hz : b.alignmentResiduals = b.terms.map fun _ => 0 := by
      unfold PreparedBlock.alignmentResiduals
      apply List.map_congr_left
      intro t ht
      have hv : t.value = 0 := by simp [RawProduct.value, hall t ht]
      rw [hv, truncGrid_zero]
      grind
    rw [hz, sumQ_map_zero]
    have h0 : absQ 0 = 0 := by decide +kernel
    rw [h0]
    have hn : (1 : Rat) ≤ (b.terms.length : Rat) := by
      have : 1 ≤ b.terms.length := by
        show 1 ≤ (_ :: _).length
        simp
      have := Rat.natCast_le_natCast.mpr this
      simpa using this
    have := Rat.mul_le_mul_of_nonneg_right hn (Rat.le_of_lt hq)
    grind
  · have ⟨t, ht, hnz⟩ : ∃ t ∈ b.terms, t.significand ≠ 0 := by
      apply Classical.byContradiction
      intro h
      apply hall
      intro t ht
      apply Classical.byContradiction
      intro hne
      exact h ⟨t, ht, hne⟩
    have hqe := quantumExponent_le b E hs hfl t ht hnz
    have hle := pow2_le_of_le hqe
    have hbound := block_alignment_bound b
    have hn : (0 : Rat) ≤ (b.terms.length : Rat) := Rat.natCast_nonneg
    have := Rat.mul_le_mul_of_nonneg_left hle hn
    grind

/-- Input-derived error budget for `n` terms on an `F`-bit alignment grid with scale bound
`E` and `n ≤ 2^L`: the alignment loss `n·2^(E−F)` plus the output quantum of a magnitude
below `2^(E+2+L)`. -/
def staticBudget (n : Nat) (F E : Int) (L : Nat) : Rat :=
  (n : Rat) * pow2 (E - F) + pow2 (max (E + 1 + L) (-126) - 23)

theorem accumulator_lt_pow2 (b : PreparedBlock) (E : Int) (L : Nat)
    (hb : ∀ t ∈ b.terms, t.Bounded) (hs : ScaleBounded b.terms E)
    (hL : b.terms.length ≤ 2 ^ L) : absQ b.accumulator < pow2 (E + 1 + L + 1) := by
  have h := accumulator_abs_lt b E hb hs
  have hE := pow2_pos E
  have hn : (b.terms.length : Rat) ≤ ((2 ^ L : Nat) : Rat) := Rat.natCast_le_natCast.mpr hL
  have h4 : (0 : Rat) ≤ 4 * pow2 E := by grind
  have := Rat.mul_le_mul_of_nonneg_right hn h4
  have heq : ((2 ^ L : Nat) : Rat) * (4 * pow2 E) = pow2 (E + 1 + L + 1) := by
    rw [← pow2_natCast]
    have h4' : (4 : Rat) = pow2 2 := by decide +kernel
    rw [h4', ← pow2_add, ← pow2_add]
    congr 1
    omega
  rw [heq] at this
  grind

/-- Static two-stage error bound for one block. -/
theorem block_static_error_bound (b : PreparedBlock) (d : Finite32) (E : Int) (L : Nat)
    (hb : ∀ t ∈ b.terms, t.Bounded) (hs : ScaleBounded b.terms E)
    (hfl : ∀ f ∈ b.profile.alignFloor, f ≤ E) (hL : b.terms.length ≤ 2 ^ L)
    (hr : absQ b.accumulator ≤ maxFinite32)
    (hout : round32 .towardZero b.accumulator = some d.bits) :
    absQ (b.exactDot - d.value) < staticBudget b.terms.length b.profile.alignFraction E L := by
  have hd : value32 d.bits = some d.value := by simp [value32, d.valid, Finite32.value]
  have halign := alignment_static_bound b E hs hfl
  have hout' := rtz_residual_lt b.accumulator d.bits d.value hr hout hd
  have hacc := accumulator_lt_pow2 b E L hb hs hL
  have hout2 : absQ (b.accumulator - d.value) < pow2 (max (E + 1 + L) (-126) - 23) := by
    by_cases hz : b.accumulator = 0
    · have hdv : d.value = 0 := by
        have hz0 : round32 .towardZero 0 = some 0 := by decide +kernel
        rw [hz, hz0] at hout
        have hb0 : d.bits = 0 := (Option.some.inj hout).symm
        have hv : value32 0 = some 0 := by decide +kernel
        rw [hb0, hv] at hd
        exact (Option.some.inj hd).symm
      rw [hz, hdv]
      have h0 : absQ (0 - 0) = 0 := by decide +kernel
      rw [h0]
      exact pow2_pos _
    · have hpos := absQ_pos_of_ne_zero _ hz
      have hce := convExp_le_of_lt (absQ b.accumulator) hpos (E + 1 + L) hacc
      have := pow2_le_of_le (show convExp (absQ b.accumulator) - 23 ≤
        max (E + 1 + L) (-126) - 23 by omega)
      grind
  have hid := block_residual_identity b d.value
  unfold PreparedBlock.extractReference at hid
  have ht := absQ_add_le (b.accumulator - d.value) (sumQ b.alignmentResiduals)
  have he : b.exactDot - d.value = (b.accumulator - d.value) + sumQ b.alignmentResiduals := by
    grind
  rw [he]
  unfold staticBudget
  grind

theorem maxFinite32_ge_pow2_127 : pow2 127 ≤ maxFinite32 := by decide +kernel

/-- A scale-bounded block with `E + 2 + L ≤ 127` is accepted. -/
theorem prepared_static_success (b : PreparedBlock) (E : Int) (L : Nat)
    (hb : ∀ t ∈ b.terms, t.Bounded) (hs : ScaleBounded b.terms E)
    (hL : b.terms.length ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127) :
    absQ b.accumulator ≤ maxFinite32 := by
  have hacc := accumulator_lt_pow2 b E L hb hs hL
  have hle : pow2 (E + 1 + L + 1) ≤ pow2 127 := pow2_le_of_le (by omega)
  have := maxFinite32_ge_pow2_127
  grind

/-- Operand-level scale bound for one group of encoded pairs: every pair decodes, and each
nonzero raw product has raw scale at most `E`. -/
def GroupScaleBounded (p : Profile) (g : List (p.Word × p.Word)) (E : Int) : Prop :=
  ∀ pair ∈ g, ∃ da db, p.decode pair.1 = some da ∧ p.decode pair.2 = some db ∧
    ((rawMul da db).significand ≠ 0 → (rawMul da db).rawScale ≤ E)

theorem prepareProducts_of_decodes (p : Profile) (g : List (p.Word × p.Word))
    (h : ∀ pair ∈ g, ∃ da db, p.decode pair.1 = some da ∧ p.decode pair.2 = some db) :
    ∃ qs, prepareProducts p g = some qs ∧
      ∀ q ∈ qs, ∃ pair ∈ g, p.decode pair.1 = some q.1 ∧ p.decode pair.2 = some q.2 := by
  induction g with
  | nil => exact ⟨[], rfl, by simp⟩
  | cons pair g ih =>
    rcases pair with ⟨a, b⟩
    obtain ⟨da, db, ha, hb⟩ := h (a, b) (by simp)
    obtain ⟨qs, hqs, hmem⟩ := ih (fun q hq => h q (by simp [hq]))
    have hqs' := hqs
    simp [prepareProducts] at hqs'
    refine ⟨(da, db) :: qs, by simp [prepareProducts, List.mapM_cons, ha, hb, hqs'], ?_⟩
    intro q hq
    simp only [List.mem_cons] at hq
    rcases hq with rfl | hq
    · exact ⟨(a, b), by simp, ha, hb⟩
    · obtain ⟨pair', hpair', h1, h2⟩ := hmem q hq
      exact ⟨pair', by simp [hpair'], h1, h2⟩

theorem prepare_of_decodes {p : Profile} (g : List (p.Word × p.Word)) (c : Finite32)
    (qs : List (Decoded × Decoded)) (hqs : prepareProducts p g = some qs) :
    prepare (⟨g, c.bits⟩ : BlockInput p) = some ⟨p, qs, c.decoded⟩ := by
  have hcd : decode32 c.bits = some c.decoded := c.valid
  unfold prepare
  simp only [hcd, hqs]

theorem idealProducts_of_prepareProducts (p : Profile) (g : List (p.Word × p.Word))
    (qs : List (Decoded × Decoded)) (hqs : prepareProducts p g = some qs) :
    idealProducts p g = some (PreparedBlock.exactProducts ⟨p, qs, ⟨0, 0, 0⟩⟩) := by
  simp [idealProducts, hqs, PreparedBlock.exactProducts]

/-- A block built from a scale-bounded accumulator input and a scale-bounded group has
scale-bounded terms. -/
theorem prepared_scaleBounded {p : Profile} (g : List (p.Word × p.Word)) (c : Finite32)
    (qs : List (Decoded × Decoded)) (E : Int)
    (hmem : ∀ q ∈ qs, ∃ pair ∈ g, p.decode pair.1 = some q.1 ∧ p.decode pair.2 = some q.2)
    (hc : c.decoded.significand ≠ 0 → c.decoded.rawScale ≤ E) (hg : GroupScaleBounded p g E) :
    ScaleBounded (PreparedBlock.mk p qs c.decoded).terms E := by
  intro t ht
  simp only [PreparedBlock.terms, List.mem_cons, List.mem_map] at ht
  rcases ht with rfl | ⟨⟨da, db⟩, hq, rfl⟩
  · exact hc
  · obtain ⟨pair, hpair, h1, h2⟩ := hmem (da, db) hq
    obtain ⟨da', db', h1', h2', hbound⟩ := hg pair hpair
    rw [h1] at h1'
    rw [h2] at h2'
    cases Option.some.inj h1'
    cases Option.some.inj h2'
    exact hbound

/-- Static acceptance and error bound for one encoded block: the block is accepted, its
ideal is the accumulator input plus the group's exact products, and its uncorrected error is
below the input-derived budget. -/
theorem evalBlock_static {p : Profile} (g : List (p.Word × p.Word)) (c : Finite32) (E : Int)
    (L : Nat) (hshape : g.length = p.products) (hfl : ∀ f ∈ p.alignFloor, f ≤ E)
    (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (hc : c.decoded.significand ≠ 0 → c.decoded.rawScale ≤ E) (hg : GroupScaleBounded p g E) :
    ∃ t, evalBlock (⟨g, c.bits⟩ : BlockInput p) = .ok t ∧
      idealProducts p g = some t.block.exactProducts ∧
      t.block.exactDot = c.value + t.block.exactProducts ∧
      absQ (t.block.exactDot - t.output.value) <
        staticBudget (p.products + 1) p.alignFraction E L := by
  obtain ⟨qs, hqs, hmem⟩ := prepareProducts_of_decodes p g
    (fun pair hpair => let ⟨da, db, h1, h2, _⟩ := hg pair hpair; ⟨da, db, h1, h2⟩)
  have hp := prepare_of_decodes g c qs hqs
  have hbounded := prepare_terms_bounded hp
  have hlen : (PreparedBlock.mk p qs c.decoded).terms.length = p.products + 1 := by
    rw [hbounded.1]
    show g.length + 1 = _
    rw [hshape]
  have hs := prepared_scaleBounded g c qs E hmem hc hg
  have hr := prepared_static_success _ E L hbounded.2 hs (by rw [hlen]; exact hL) hrange
  obtain ⟨t, ht⟩ := (evalBlock_success_iff p ⟨g, c.bits⟩).mpr ⟨hshape, _, hp, hr⟩
  have hblock : t.block = ⟨p, qs, c.decoded⟩ := by
    have := evalBlock_prepared ht
    rw [hp] at this
    exact (Option.some.inj this).symm
  have hout := evalPrepared_output (evalBlock_evalPrepared ht)
  rw [hblock] at hout
  refine ⟨t, ht, ?_, ?_, ?_⟩
  · rw [hblock]
    exact idealProducts_of_prepareProducts p g qs hqs
  · rw [hblock]
    rfl
  · rw [hblock]
    have := block_static_error_bound ⟨p, qs, c.decoded⟩ t.output E L hbounded.2 hs hfl
      (by rw [hlen]; exact hL) hr hout
    rw [hlen] at this
    exact this

/-- A finite FP32 value below `2^(E+1)` in magnitude has raw scale at most `E`, for
`E ≥ −126`. -/
theorem finite32_scale_le (c : Finite32) (E : Int) (hE : -126 ≤ E)
    (h : absQ c.value < pow2 (E + 1)) : c.decoded.significand ≠ 0 → c.decoded.rawScale ≤ E := by
  intro hnz
  rcases decode32_fields c.bits c.decoded c.valid with ⟨_, _, hd⟩ | ⟨_, _, hd⟩ | ⟨_, _, hd⟩
  · rw [hd] at hnz
    exact absurd rfl hnz
  · rw [hd]
    exact hE
  · have hv : c.value = c.decoded.value := rfl
    rw [hv, hd] at h
    rw [hd]
    show ((c.bits.toNat / 8388608 % 256 : Nat) : Int) - 127 ≤ E
    generalize hr : ((c.bits.toNat / 8388608 % 256 : Nat) : Int) - 127 = r at h
    generalize hm : c.bits.toNat % 8388608 = m at h
    unfold Decoded.value at h
    simp only at h
    have hq := pow2_pos (r - 23)
    rw [absQ_mul_pos _ _ hq] at h
    have hmag : ((8388608 + m : Nat) : Rat) ≤
        absQ (((if (c.bits.toNat / 2147483648 != 0) then -((8388608 + m : Nat) : Int)
          else ((8388608 + m : Nat) : Int) : Int) : Rat)) := by
      split
      · rw [Rat.intCast_neg, absQ_neg, Rat.intCast_natCast, absQ_of_nonneg Rat.natCast_nonneg]
        exact Rat.le_refl
      · rw [Rat.intCast_natCast, absQ_of_nonneg Rat.natCast_nonneg]
        exact Rat.le_refl
    have hbase : pow2 r ≤ ((8388608 + m : Nat) : Rat) * pow2 (r - 23) := by
      have h1 : ((8388608 : Nat) : Rat) ≤ ((8388608 + m : Nat) : Rat) :=
        Rat.natCast_le_natCast.mpr (by omega)
      have h2 := Rat.mul_le_mul_of_nonneg_right h1 (Rat.le_of_lt hq)
      have h3 : ((8388608 : Nat) : Rat) * pow2 (r - 23) = pow2 r := by
        have : ((8388608 : Nat) : Rat) = pow2 23 := by decide +kernel
        rw [this, ← pow2_add]
        congr 1
        omega
      rw [h3] at h2
      exact h2
    have hlt : pow2 r < pow2 (E + 1) := by
      have h4 := Rat.mul_le_mul_of_nonneg_right hmag (Rat.le_of_lt hq)
      grind
    apply Classical.byContradiction
    intro hne
    have := pow2_le_of_le (show E + 1 ≤ r by omega)
    grind

theorem idealContributions_cons (p : Profile) (q : List (p.Word × p.Word))
    (rest : List (List (p.Word × p.Word))) (a b : Rat) (ha : idealProducts p q = some a)
    (hb : idealContributions p rest = some b) :
    idealContributions p (q :: rest) = some (a + b) := by
  simp [idealContributions, ha, hb]

/-- Static acceptance and error bound for a schedule. Every group is scale-bounded by `E`,
and every ideal partial sum stays below `2^(E+1)` with room for the accumulated error, so
every accumulator input keeps scale `E`. The run is then accepted and its final uncorrected
error is at most the number of groups times the per-group budget. No trace is consulted. -/
theorem runBlocks_static (p : Profile) (E : Int) (L : Nat) (hE : -126 ≤ E)
    (hfl : ∀ f ∈ p.alignFloor, f ≤ E) (hL : p.products + 1 ≤ 2 ^ L) (hrange : E + 2 + L ≤ 127)
    (ps : List (List (p.Word × p.Word))) (hshape : ∀ g ∈ ps, g.length = p.products)
    (hscale : ∀ g ∈ ps, GroupScaleBounded p g E) (c : Finite32)
    (hpartial : ∀ n ≤ ps.length, ∀ v, idealContributions p (ps.take n) = some v →
      absQ (c.value + v) + (n : Rat) * staticBudget (p.products + 1) p.alignFraction E L <
        pow2 (E + 1)) :
    ∃ ts products, runBlocks p c.bits ps = .ok ts ∧ idealContributions p ps = some products ∧
      absQ (c.value + products - (lastOutput c ts).value) ≤
        (ps.length : Rat) * staticBudget (p.products + 1) p.alignFraction E L := by
  generalize hB : staticBudget (p.products + 1) p.alignFraction E L = B at hpartial
  induction ps generalizing c with
  | nil =>
    refine ⟨[], 0, rfl, rfl, ?_⟩
    simp only [lastOutput, List.length_nil]
    have h0 : absQ (c.value + 0 - c.value) = 0 := by
      rw [Rat.add_zero, Rat.sub_self]
      decide +kernel
    rw [h0]
    grind
  | cons q rest ih =>
    have hc0 : absQ c.value < pow2 (E + 1) := by
      have := hpartial 0 (by simp) 0 rfl
      have h00 : ((0 : Nat) : Rat) * B = 0 := by simp
      rw [Rat.add_zero, h00, Rat.add_zero] at this
      exact this
    have hcs := finite32_scale_le c E hE hc0
    obtain ⟨t, ht, hq, hdot, herr⟩ :=
      evalBlock_static q c E L (hshape q (by simp)) hfl hL hrange hcs (hscale q (by simp))
    rw [hB] at herr
    have hpartial' : ∀ n ≤ rest.length, ∀ v, idealContributions p (rest.take n) = some v →
        absQ (t.output.value + v) + (n : Rat) * B < pow2 (E + 1) := by
      intro n hn v hv
      have h1 := hpartial (n + 1) (by simp; omega) (t.block.exactProducts + v)
        (by rw [List.take_succ_cons]; exact idealContributions_cons p q _ _ _ hq hv)
      have h2 := absQ_add_le (c.value + (t.block.exactProducts + v))
        (t.output.value - t.block.exactDot)
      rw [absQ_sub_comm] at h2
      have hcast : ((n + 1 : Nat) : Rat) = (n : Rat) + 1 := by rw [Rat.natCast_add]; rfl
      rw [hcast] at h1
      rw [hdot] at h2 herr
      have h3 : c.value + (t.block.exactProducts + v) + (t.output.value - (c.value + t.block.exactProducts)) = t.output.value + v := by grind
      rw [h3] at h2
      grind
    obtain ⟨ts, products', hrun, hi', hbound⟩ := ih (fun g hg => hshape g (by simp [hg]))
      (fun g hg => hscale g (by simp [hg])) t.output hpartial'
    refine ⟨t :: ts, t.block.exactProducts + products', ?_, ?_, ?_⟩
    · simp only [runBlocks, ht, hrun]
    · exact idealContributions_cons p q rest _ _ hq hi'
    · simp only [lastOutput, List.length_cons]
      have hcast : ((rest.length + 1 : Nat) : Rat) = (rest.length : Rat) + 1 := by
        rw [Rat.natCast_add]; rfl
      rw [hcast]
      have h2 := absQ_add_le (c.value + t.block.exactProducts - t.output.value)
        (t.output.value + products' - (lastOutput t.output ts).value)
      rw [hdot] at herr
      have h3 : c.value + t.block.exactProducts - t.output.value +
          (t.output.value + products' - (lastOutput t.output ts).value) =
          c.value + (t.block.exactProducts + products') - (lastOutput t.output ts).value := by
        grind
      rw [h3] at h2
      grind

end TensorCore
