import TensorCore.Kernels.Datapath.Align
import TensorCore.Kernels.Datapath.Normalize
import TensorCore.Kernels.EFT.Preparation
import TensorCore.TC.AcceptedDomain

/-! The bitvector datapath computes the Tensor Core model's output word on every input. -/

namespace TensorCore.Datapath

open EFMachine

set_option exponentiation.threshold 1024

/-- A finite decoded significand is below `2 ^ (mantissaBits + 1)`. -/
theorem classifyNat_finite_bound (f : Format) (n : ℕ) (d : Decoded)
    (h : (classifyNat f n).finite = some d) :
    d.significand.natAbs < 2 ^ (d.mantissaBits.toNat + 1) := by
  have hm := Nat.mod_lt n (Nat.two_pow_pos f.mantissaBits)
  have hp : 2 ^ (f.mantissaBits + 1) = 2 * 2 ^ f.mantissaBits := by rw [Nat.pow_succ]; omega
  unfold classifyNat at h
  dsimp only at h
  by_cases ht : n / 2 ^ f.mantissaBits % 2 ^ f.exponentBits = 2 ^ f.exponentBits - 1
  · rw [if_pos ht] at h
    split at h <;> simp [Classification.finite] at h
  · rw [if_neg ht] at h
    by_cases hz : n / 2 ^ f.mantissaBits % 2 ^ f.exponentBits = 0
    · rw [if_pos hz] at h
      by_cases hm0 : n % 2 ^ f.mantissaBits = 0
      · rw [if_pos hm0] at h
        simp only [Classification.finite, Option.some.injEq] at h
        rw [← h]
        decide
      · rw [if_neg hm0] at h
        simp only [Classification.finite, Option.some.injEq] at h
        rw [← h]
        simp only [Int.toNat_natCast]
        split <;> simp only [Int.natAbs_neg, Int.natAbs_natCast] <;> omega
    · rw [if_neg hz] at h
      simp only [Classification.finite, Option.some.injEq] at h
      rw [← h]
      simp only [Int.toNat_natCast]
      split <;> simp only [Int.natAbs_neg, Int.natAbs_natCast] <;> omega

theorem decodeFactor_valid {kind : InputKind} {bits : F32} {a : Factor}
    (h : decodeFactor kind bits = some a) :
    a.magnitude.toNat < 2 ^ (a.mantissaBits.toNat + 1) ∧ a.mantissaBits.toNat ≤ 10 ∧
      130 ≤ a.biasedExp.toNat ∧ a.biasedExp.toNat ≤ 383 := by
  have hd : (classifyNat kind.format bits.toNat).finite = some a.decoded := by
    rw [← decodeFactor_asDecoded, h]; rfl
  have hb := classifyNat_finite_bound _ _ _ hd
  have hs : a.decoded.significand.natAbs = a.magnitude.toNat := by
    unfold Factor.decoded; cases a.negative <;> simp
  have hmb : a.decoded.mantissaBits.toNat = a.mantissaBits.toNat := by simp [Factor.decoded]
  obtain ⟨h1, h2, h3⟩ := decodeFactor_bounds h
  rw [hs, hmb] at hb
  exact ⟨hb, h3, h1, h2⟩

theorem decode32Fields_valid {bits : F32} {c : Accumulator} (h : decode32Fields bits = some c) :
    c.magnitude.toNat < 2 ^ (c.mantissaBits.toNat + 1) ∧ c.mantissaBits.toNat ≤ 23 ∧
      130 ≤ c.biasedExp.toNat ∧ c.biasedExp.toNat ≤ 383 := by
  have hd : (classifyNat fp32 bits.toNat).finite = some c.decoded := by
    rw [← decode32_eq, ← decode32Fields_asDecoded, h]; rfl
  have hb := classifyNat_finite_bound _ _ _ hd
  have hs : c.decoded.significand.natAbs = c.magnitude.toNat := by
    unfold Accumulator.decoded; cases c.negative <;> simp
  have hmb : c.decoded.mantissaBits.toNat = c.mantissaBits.toNat := by simp [Accumulator.decoded]
  obtain ⟨h1, h2, h3⟩ := decode32Fields_bounds h
  rw [hs, hmb] at hb
  exact ⟨hb, h3, h1, h2⟩

/-- Valid terms whose nonzero exponents are positive. -/
def Term.Accepted (t : Term) : Prop := t.Valid ∧ (t.significand ≠ 0 → 1 ≤ t.biasedExp.toNat)

theorem product_spec {kind : InputKind} {x y : F32} {a b : Factor}
    (ha : decodeFactor kind x = some a) (hb : decodeFactor kind y = some b) :
    (product a b).unnormalized = unnormalizedMul a.decoded b.decoded ∧ (product a b).Accepted := by
  obtain ⟨ha1, ha2, ha3, ha4⟩ := decodeFactor_valid ha
  obtain ⟨hb1, hb2, hb3, hb4⟩ := decodeFactor_valid hb
  have hmul : (multiplySignificands a.magnitude b.magnitude).toNat = a.magnitude.toNat * b.magnitude.toNat := by
    have hlt : a.magnitude.toNat * b.magnitude.toNat < 2 ^ 24 := by
      have := Nat.mul_lt_mul'' a.magnitude.isLt b.magnitude.isLt
      omega
    unfold multiplySignificands
    rw [BitVec.toNat_mul, BitVec.toNat_setWidth, BitVec.toNat_setWidth,
      Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le a.magnitude.isLt (by decide)),
      Nat.mod_eq_of_lt (Nat.lt_of_lt_of_le b.magnitude.isLt (by decide)), Nat.mod_eq_of_lt hlt]
  have hexp : (a.biasedExp + b.biasedExp).toNat = a.biasedExp.toNat + b.biasedExp.toNat := by
    rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
  have hmb : (a.mantissaBits + b.mantissaBits).toNat = a.mantissaBits.toNat + b.mantissaBits.toNat := by
    rw [BitVec.toNat_add, Nat.mod_eq_of_lt (by omega)]
  refine ⟨?_, ⟨?_, ?_⟩, ?_⟩
  · simp only [Term.unnormalized, product, unnormalizedMul, Factor.decoded, hmul, hexp, hmb,
      UnnormalizedProduct.mk.injEq]
    refine ⟨?_, by omega, by omega⟩
    cases a.negative <;> cases b.negative <;> simp [Int.neg_mul, Int.mul_neg]
  · simp only [product, hmul, hmb]
    have := Nat.mul_lt_mul'' ha1 hb1
    rw [← Nat.pow_add] at this
    rw [show a.mantissaBits.toNat + b.mantissaBits.toNat + 2 =
      a.mantissaBits.toNat + 1 + (b.mantissaBits.toNat + 1) by omega]
    exact this
  · simp only [product, hmb]; omega
  · intro _; simp only [product, hexp]; omega

theorem cTerm_spec {bits : F32} {c : Accumulator} (h : decode32Fields bits = some c) :
    (cTerm c).unnormalized =
      ⟨c.decoded.significand, c.decoded.unnormalizedExp, c.decoded.mantissaBits⟩ ∧
      (cTerm c).Accepted := by
  obtain ⟨h1, h2, h3, h4⟩ := decode32Fields_valid h
  have hexp : (c.biasedExp + 256).toNat = c.biasedExp.toNat + 256 := by
    rw [BitVec.toNat_add]
    change (c.biasedExp.toNat + 256) % 1024 = _
    omega
  refine ⟨?_, ⟨⟨?_, ?_⟩, ?_⟩⟩
  · simp only [Term.unnormalized, cTerm, Accumulator.decoded, hexp, UnnormalizedProduct.mk.injEq]
    exact ⟨rfl, by omega, trivial⟩
  · simp only [cTerm]
    exact Nat.lt_of_lt_of_le h1 (Nat.pow_le_pow_right (by decide) (by omega))
  · exact h2
  · intro _; simp only [cTerm, hexp]; omega

theorem decodeTerm_spec (path : Path) (pair : path.profile.Word × path.profile.Word) :
    (decodeTerm path pair).map Term.unnormalized =
      ((do return (← path.profile.decode pair.1, ← path.profile.decode pair.2) :
        Option (Decoded × Decoded))).map (fun (a, b) => unnormalizedMul a b) := by
  rw [← decodeFactor_profile, ← decodeFactor_profile]
  cases ha : decodeFactor path.kind (pair.1.zeroExtend 32) with
  | none => simp [decodeTerm, ha]
  | some a =>
    cases hb : decodeFactor path.kind (pair.2.zeroExtend 32) with
    | none => simp [decodeTerm, ha, hb]
    | some b =>
      simp only [decodeTerm, ha, hb, Option.map_some, pure, bind, Option.bind]
      exact congrArg some (product_spec ha hb).1

theorem decodeTerm_accepted {path : Path} {pair : path.profile.Word × path.profile.Word} {t : Term}
    (h : decodeTerm path pair = some t) : t.Accepted := by
  cases ha : decodeFactor path.kind (pair.1.zeroExtend 32) with
  | none => simp [decodeTerm, ha] at h
  | some a =>
    cases hb : decodeFactor path.kind (pair.2.zeroExtend 32) with
    | none => simp [decodeTerm, ha, hb] at h
    | some b =>
      simp [decodeTerm, ha, hb] at h
      rw [← h]
      exact (product_spec ha hb).2

theorem sumZ_map_zero (ts : List α) (f : α → ℤ) (h : ∀ t ∈ ts, f t = 0) : sumZ (ts.map f) = 0 := by
  induction ts with
  | nil => rfl
  | cons t ts ih =>
    simp only [List.map_cons, sumZ, h t (by simp), ih (fun u hu => h u (by simp [hu]))]
    rfl

theorem path_floor (path : Path) :
    (path.profile.alignFloor = none ∧ path.floor.toNat = 0) ∨
      ∃ f, path.profile.alignFloor = some f ∧ (path.floor.toNat : ℤ) = f + 512 := by
  cases path <;> decide

theorem path_alignment (path : Path) :
    path.profile.alignMantissaBits = path.alignmentBits.toNat ∧ 23 ≤ path.alignmentBits.toNat ∧
      path.alignmentBits.toNat ≤ 25 := by
  cases path <;> decide

/-- The bitvector accumulator, read on its grid, is the model's aligned accumulator. -/
theorem accumulator_eq (path : Path) (ts : List Term) (b : PreparedBlock)
    (hprof : b.profile = path.profile) (hterms : b.terms = ts.map Term.unnormalized)
    (hacc : ∀ t ∈ ts, t.Accepted) (hlen : ts.length = path.profile.products + 1) :
    ((accumulate path (alignExp path ts) ts).toInt : ℚ) *
      pow2 (((alignExp path ts).toNat : ℤ) - 512 - path.alignmentBits.toNat) = b.accumulator := by
  obtain ⟨hal, hF, _⟩ := path_alignment path
  obtain ⟨hA1, hA2, hA3⟩ := alignFold_spec ts path.floor
  change path.floor.toNat ≤ (alignExp path ts).toNat at hA1
  change ∀ t ∈ ts, t.significand ≠ 0 → t.biasedExp.toNat ≤ (alignExp path ts).toNat at hA2
  change alignExp path ts = path.floor ∨ ∃ t ∈ ts, t.significand ≠ 0 ∧ alignExp path ts = t.biasedExp at hA3
  generalize hA : alignExp path ts = A at hA1 hA2 hA3
  have htr : ∀ t ∈ ts, truncBits t.unnormalized.value ((A.toNat : ℤ) - 512 - path.alignmentBits.toNat) =
      if t.negative then -((t.aligned path A).toNat : ℤ) else ((t.aligned path A).toNat : ℤ) :=
    fun t ht => t.truncBits_eq path A (hacc t ht).1 hF (hA2 t ht)
  rw [accumulate_toInt path A ts hlen, ← List.map_congr_left htr]
  have hsig : ∀ t : Term, t.unnormalized.significand = 0 ↔ t.significand = 0 := by
    intro t
    have : t.significand = 0 ↔ t.significand.toNat = 0 :=
      ⟨fun h => by rw [h]; rfl, fun h => BitVec.eq_of_toNat_eq (by rw [h]; rfl)⟩
    rw [this]
    unfold Term.unnormalized
    cases t.negative <;> simp
  unfold PreparedBlock.accumulator PreparedBlock.alignedBits
  rw [hterms, List.map_map]
  by_cases hall : ∀ t ∈ ts, t.significand = 0
  · have hv : ∀ t ∈ ts, t.unnormalized.value = 0 := by
      intro t ht
      simp [UnnormalizedProduct.value, (hsig t).mpr (hall t ht)]
    rw [sumZ_map_zero _ _ (fun t ht => by rw [hv t ht, truncBits_zero]),
      sumZ_map_zero _ _ (fun t ht => by simp only [Function.comp, hv t ht, truncBits_zero])]
    simp
  · have hex : ∃ t ∈ ts, t.significand ≠ 0 := by
      apply Classical.byContradiction
      intro h
      exact hall (fun t ht => Classical.byContradiction fun hz => h ⟨t, ht, hz⟩)
    obtain ⟨t0, ht0, hz0⟩ := hex
    have hmem : t0.unnormalized ∈ b.terms := by rw [hterms]; exact List.mem_map_of_mem ht0
    obtain ⟨m, hm, hm0⟩ := maxTermExp_term b.terms t0.unnormalized hmem (mt (hsig t0).mp hz0)
    have hup : m ≤ (A.toNat : ℤ) - 512 := by
      apply maxTermExp_upper b.terms _ _ m (by rw [hm]; rfl)
      intro u hu hnz
      rw [hterms] at hu
      obtain ⟨t, ht, rfl⟩ := List.mem_map.mp hu
      have := hA2 t ht (mt (hsig t).mpr hnz)
      simp only [Term.unnormalized]
      omega
    have ht0E : (t0.biasedExp.toNat : ℤ) - 512 ≤ m := hm0
    have hlow : ∀ t ∈ ts, t.significand ≠ 0 → (t.biasedExp.toNat : ℤ) - 512 ≤ m := by
      intro t ht hnz
      obtain ⟨m', hm', hle⟩ := maxTermExp_term b.terms t.unnormalized
        (by rw [hterms]; exact List.mem_map_of_mem ht) (mt (hsig t).mp hnz)
      rw [hm] at hm'
      cases Option.some.inj hm'
      exact hle
    have hexp : b.alignExp = some ((A.toNat : ℤ) - 512) := by
      unfold PreparedBlock.alignExp Profile.applyFloor
      rw [hm, hprof]
      rcases path_floor path with ⟨hf, hf0⟩ | ⟨f, hf, hf0⟩
      · rw [hf]
        dsimp only
        congr 1
        rcases hA3 with h | ⟨t, ht, hnz, h⟩
        · exfalso
          have h1 := hA2 t0 ht0 hz0
          have h2 := (hacc t0 ht0).2 hz0
          rw [h, hf0] at h1
          omega
        · have := hlow t ht hnz
          have : A.toNat = t.biasedExp.toNat := by rw [h]
          omega
      · rw [hf]
        dsimp only
        congr 1
        rcases hA3 with h | ⟨t, ht, hnz, h⟩
        · have : A.toNat = path.floor.toNat := by rw [h]
          omega
        · have := hlow t ht hnz
          have : A.toNat = t.biasedExp.toNat := by rw [h]
          omega
    have hgrid : b.alignGridExponent = (A.toNat : ℤ) - 512 - path.alignmentBits.toNat := by
      unfold PreparedBlock.alignGridExponent
      rw [hexp, hprof, hal]
      rfl
    rw [hgrid]
    rfl

/-- The bitvector datapath returns the integer model's output word, or the same error, on every input. -/
theorem evalBlock_eq (path : Path) (x : BlockInput path.profile) :
    Datapath.evalBlock path x = (TensorCore.evalBlock x).map (·.output.bits) := by
  unfold Datapath.evalBlock TensorCore.evalBlock
  by_cases hlen : x.products.length = path.profile.products
  · simp only [hlen, bne_self_eq_false, Bool.false_eq_true, if_false]
    have hmap := mapM_project_eq (f := decodeTerm path) (v := Term.unnormalized)
      (g := fun (a, b) => do return (← path.profile.decode a, ← path.profile.decode b))
      (w := fun (a, b) => unnormalizedMul a b)
      (fun pair => by rcases pair with ⟨a, b⟩; exact decodeTerm_spec path (a, b)) x.products
    cases hc : decode32Fields x.c with
    | none =>
      have hdc : decode32 x.c = none := by rw [← decode32Fields_asDecoded, hc]; rfl
      simp only [prepare, hdc]
      rfl
    | some c =>
      have hdc : decode32 x.c = some c.decoded := by rw [← decode32Fields_asDecoded, hc]; rfl
      cases hps : x.products.mapM (decodeTerm path) with
      | none =>
        have hpp : prepareProducts path.profile x.products = none := by
          unfold prepareProducts
          rw [hps] at hmap
          cases hq : x.products.mapM (fun (a, b) => do return (← path.profile.decode a, ← path.profile.decode b) :
              path.profile.Word × path.profile.Word → Option (Decoded × Decoded)) with
          | none => rfl
          | some _ => rw [hq] at hmap; simp at hmap
        simp only [prepare, hdc, hpp]
        rfl
      | some ps =>
        rw [hps] at hmap
        cases hpp : prepareProducts path.profile x.products with
        | none =>
          unfold prepareProducts at hpp
          rw [hpp] at hmap
          simp at hmap
        | some ds =>
          unfold prepareProducts at hpp
          rw [hpp] at hmap
          simp only [Option.map_some, Option.some.injEq] at hmap
          have hprep : prepare x = some ⟨path.profile, ds, c.decoded⟩ := by
            simp only [prepare, hdc, prepareProducts, hpp]
          rw [hprep]
          dsimp only
          have hcs := cTerm_spec hc
          have hterms : (PreparedBlock.mk path.profile ds c.decoded).terms =
              (cTerm c :: ps).map Term.unnormalized := by
            simp only [PreparedBlock.terms, List.map_cons, hcs.1]
            rw [hmap]
          obtain ⟨hpl, hpa⟩ := mapM_bounds (fun _ _ h => decodeTerm_accepted h) hps
          have hacc : ∀ t ∈ cTerm c :: ps, t.Accepted := by
            intro t ht
            rcases List.mem_cons.mp ht with rfl | ht
            · exact hcs.2
            · exact hpa t ht
          have hlen' : (cTerm c :: ps).length = path.profile.products + 1 := by
            simp [hpl, hlen]
          have hw : 24 ≤ accWidth path ∧ accWidth path ≤ 64 ∧ path.alignmentBits.toNat ≤ 64 := by
            cases path <;> decide
          rw [normalize_eq _ _ _ hw.1 hw.2.1 hw.2.2,
            accumulator_eq path _ _ rfl hterms hacc hlen']
          unfold evalPrepared
          cases hr : round32 .truncate (PreparedBlock.mk path.profile ds c.decoded).accumulator with
          | none => rfl
          | some bits =>
            obtain ⟨bits', d, hb', hd⟩ := round32_finite_exists .truncate _ (round32_range hr)
            rw [hr] at hb'
            cases Option.some.inj hb'
            have hf : finite32 bits = some ⟨bits, d, hd⟩ := by
              unfold finite32
              split
              · rename_i he; rw [hd] at he; contradiction
              · rename_i d' he; rw [hd] at he; cases Option.some.inj he; rfl
            simp only [hf]
            rfl
  · have hb : (x.products.length != path.profile.products) = true := by simpa using hlen
    rw [if_pos hb, if_pos hb]
    rfl

end TensorCore.Datapath
