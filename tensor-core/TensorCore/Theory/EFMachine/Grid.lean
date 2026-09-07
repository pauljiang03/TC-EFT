import TensorCore.Theory.EFMachine.Preparation

namespace TensorCore.EFMachine

set_option exponentiation.threshold 1024

/-- Specification of the raw maximum: zero terms are ignored, before any shift or
normalization. The profile floor is expressed using the same bias as term metadata. -/
def rawMaximum (ts : List Term) (initial : Nat) : Nat :=
  ts.foldl (fun e t => if t.word.magnitude = 0 then e else max e t.raw.toNat) initial

theorem rawMaximum_eq (ts : List Term) (e : Grid) :
    (ts.foldl (fun e t => if t.word.magnitude == 0 then e
      else if e ≤ t.raw then t.raw else e) e).toNat = rawMaximum ts e.toNat := by
  induction ts generalizing e with
  | nil => rfl
  | cons t ts ih =>
    simp only [List.foldl_cons, rawMaximum]
    rw [ih]
    by_cases hz : t.word.magnitude = 0
    · simp [hz, rawMaximum]
    · simp only [beq_iff_eq, hz, if_false]
      split
      · rename_i h; rw [Nat.max_eq_right h]; rfl
      · rename_i h
        have h' : t.raw.toNat ≤ e.toNat := by change ¬ e.toNat ≤ t.raw.toNat at h; omega
        rw [Nat.max_eq_left h']; rfl

theorem outputGrid_spec (D : F32) :
    (outputGrid D).toNat = (D.toNat / 8388608 % 256) +
      (if D.toNat / 8388608 % 256 = 0 then 123 else 122) ∧
    ((outputGrid D).toNat : Int) - 272 = outputQuantumExponent D ∧
    123 ≤ (outputGrid D).toNat := by
  have he := fp32_exponent_toNat D
  have hb : D.toNat / 8388608 % 256 < 256 := Nat.mod_lt _ (by decide)
  unfold outputGrid
  by_cases hz : D.toNat / 8388608 % 256 = 0
  · have hz' : (((D >>> 23).setWidth 8).zeroExtend 10 : Grid) = 0 := by
      apply BitVec.eq_of_toNat_eq; simpa [hz] using he
    simp [hz', outputQuantumExponent, hz, emin32, Int.max_def]
  · have hz' : (((D >>> 23).setWidth 8).zeroExtend 10 : Grid) ≠ 0 := by
      intro h; have hh := congrArg BitVec.toNat h; rw [he] at hh; exact hz hh
    simp only [beq_iff_eq, hz', if_false, BitVec.toNat_add, he]
    have hm : (D.toNat / 8388608 % 256 + 122) % 1024 = D.toNat / 8388608 % 256 + 122 :=
      Nat.mod_eq_of_lt (by omega)
    simp only [show (122 : Grid).toNat = 122 from rfl, Nat.reducePow, hm, hz, if_false]
    unfold outputQuantumExponent
    simp only [Nat.reducePow, emin32]
    rw [Int.max_eq_left (by omega)]
    exact ⟨trivial, by omega, by omega⟩

/-- Exact qE=max(qA,qD), with qA obtained from raw exponents, not product magnitude.
The biased maximum starts at -512 for V100 (below every nonzero input raw scale),
and at the characterized architectural floor for Ampere/Hopper. -/
theorem selectedGrid_spec (path : Path) (ts : List Term) (D : F32) :
    ((selectedGrid path ts D).toNat : Int) - 272 =
      max ((rawMaximum ts path.floor.toNat : Int) - 512 - path.profile.alignFraction)
        (outputQuantumExponent D) := by
  have ho : (path.alignmentBits + 240).toNat = path.profile.alignFraction.toNat + 240 := by
    cases path <;> decide
  have hal : (path.profile.alignFraction.toNat : Int) = path.profile.alignFraction := by
    cases path <;> decide
  have hd := outputGrid_spec D
  unfold selectedGrid
  generalize he : ts.foldl _ path.floor = e
  have hem := rawMaximum_eq ts path.floor
  rw [he] at hem
  dsimp only
  by_cases hsmall : e < path.alignmentBits + 240
  · rw [if_pos hsmall, if_pos (show (0 : Grid) ≤ outputGrid D from by exact Nat.zero_le _)]
    rw [hd.2.1, Int.max_eq_right]
    change e.toNat < (path.alignmentBits + 240).toNat at hsmall
    rw [ho, hem] at hsmall
    omega
  · have hle : path.alignmentBits + 240 ≤ e := by
      change ¬ e.toNat < _ at hsmall; change _ ≤ e.toNat; omega
    have hsub : (e - (path.alignmentBits + 240)).toNat =
        rawMaximum ts path.floor.toNat - (path.profile.alignFraction.toNat + 240) := by
      rw [BitVec.toNat_sub_of_le hle, hem, ho]
    rw [if_neg hsmall]
    split
    · rename_i h
      change (e - (path.alignmentBits + 240)).toNat ≤ (outputGrid D).toNat at h
      rw [hsub] at h
      rw [hd.2.1, Int.max_eq_right]
      change (path.alignmentBits + 240).toNat ≤ e.toNat at hle
      rw [ho, hem] at hle
      omega
    · rename_i h
      change ¬ (e - (path.alignmentBits + 240)).toNat ≤ (outputGrid D).toNat at h
      rw [hsub] at h
      rw [hsub, Int.max_eq_left]
      · omega
      · omega

end TensorCore.EFMachine
