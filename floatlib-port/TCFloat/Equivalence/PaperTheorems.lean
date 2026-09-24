import TCFloat.Equivalence.Encoded
import TensorCore.TC.Flowback
import TensorCore.TC.MonotonicityRange

set_option backward.isDefEq.respectTransparency false
set_option maxRecDepth 2048
namespace TCFloat.Equivalence
open FloatLib.Floats.Formats.BinaryInterchange

def PaperFormat (f : FloatFormat) : Prop := f=.binary16 ∨ f=.bfloat16 ∨ f=.tf32
theorem PaperFormat.ieee {f : FloatFormat} (h : PaperFormat f) : f.isIEEE=true := by
  rcases h with rfl|rfl|rfl <;> decide +kernel

/-- The universal theorem restricted explicitly to the paper's FP32-output input formats. -/
theorem paper_equivalence (p : Profile) (hf : PaperFormat p.format)
    (x : TensorCore.BlockInput (profile p)) (D : TensorCore.F32) :
    Paper.tc p (inputPairs x) x.c.toNat =
        (TensorCore.evalBlock x).toOption.map (fun t => t.output.bits.toNat) ∧
    Paper.eft p (inputPairs x) x.c.toNat D.toNat =
        (TensorCore.algorithm1Encoded x D).toOption.map encodedResult :=
  universal_equivalence p hf.ieee x D

theorem trace_related (t : Trace) (hb : ValidBlock t.block) (hw : t.bits < 2^32)
    (hv : TCFloat.value32 t.bits=some t.output) : ∃ s, TraceRel s t := by
  let D : TensorCore.F32 := BitVec.ofNat 32 t.bits
  have hD : D.toNat=t.bits := Nat.mod_eq_of_lt hw
  have hvs : TensorCore.value32 D=some t.output := by rw [← value32_eq,hD]; exact hv
  obtain ⟨d,_,hd,ho⟩ := TensorCore.finite32_of_value32 D t.output hvs
  exact ⟨⟨block t.block,d⟩,⟨rfl,by rw [hd,hD],ho,hb⟩⟩

theorem trace_evaluated {s : TensorCore.BlockTrace} {t : Trace} (h : TraceRel s t)
    (ht : t.block.evaluate=some t.bits) : TensorCore.evalPrepared s.block=.ok s := by
  rw [evaluate_eq t.block h.valid,← h.block_eq] at ht
  obtain ⟨bits,hbits,hval⟩ := Option.map_eq_some_iff.mp ht
  have heq : bits=s.output.bits := BitVec.eq_of_toNat_eq (hval.trans h.bits_eq.symm)
  rw [heq] at hbits
  have hd : TensorCore.finite32 s.output.bits=some s.output := by
    unfold TensorCore.finite32
    split
    · rename_i hd
      rw [s.output.valid] at hd
      contradiction
    · rename_i d hd
      have he : d=s.output.decoded := Option.some.inj (hd.symm.trans s.output.valid)
      subst d
      rfl
  simp only [TensorCore.evalPrepared,hbits,hd]

/-- Paper Theorem III.1, including the actual final-output quantum. -/
theorem paper_error_bound (t : Trace) (hb : ValidBlock t.block) (hw : t.bits<2^32)
    (hv : TCFloat.value32 t.bits=some t.output) (ht : t.block.evaluate=some t.bits) :
    |t.block.ideal-t.output| < (t.block.terms.length:Rat)*TCFloat.pow2 t.block.q +
      TCFloat.pow2 (outputQuantum t.bits) := by
  obtain ⟨s,hs⟩ := trace_related t hb hw hv
  have h := TensorCore.evalPrepared_error_bound (trace_evaluated hs ht)
  simp only [abs_eq,hs.block_eq,ideal_eq _ hb,hs.output_eq,terms_eq,List.length_map,
    q_eq,pow2_eq,TensorCore.outputQuantumExponent,hs.bits_eq] at h
  exact h

/-- Paper Lemma IV.1. -/
theorem paper_lowPart_bound (t : Trace) (e : Rat) (he : e ∈ t.lowParts) :
    |e| < TCFloat.pow2 t.extractionExponent := by
  obtain ⟨x,_,rfl⟩ := List.mem_map.mp he
  exact truncGrid_error x.value t.extractionExponent

/-- Paper Lemma IV.2. -/
theorem paper_overlap_window (t : Trace) :
    0 ≤ t.extractionExponent-t.block.q ∧
      t.extractionExponent-t.block.q = max 0 (outputQuantum t.bits-t.block.q) := by
  unfold Trace.extractionExponent
  omega

/-- Paper Lemma IV.3, the exact nested-grid decomposition. -/
theorem paper_accumulator_eq_retained (t : Trace) :
    t.block.accumulator = t.retained + t.retainedLowParts.sum := by
  let τ := (t.extractionExponent-t.block.q).toNat
  have ht : t.extractionExponent=t.block.q+τ := by
    have := (paper_overlap_window t).1
    dsimp [τ]; omega
  have hsplit (x : Rat) : truncGrid x t.block.q = truncGrid x t.extractionExponent +
      truncGrid (x-truncGrid x t.extractionExponent) t.block.q := by
    rw [ht]
    exact TensorCore.truncGrid_split x t.block.q τ
  simp only [Block.accumulator,Block.aligned,Trace.retained,Trace.coarse,
    Trace.retainedLowParts,Trace.lowParts,List.map_map,Function.comp_def]
  have hm : (t.block.terms.map fun x => truncGrid x.value t.block.q) =
      t.block.terms.map (fun x => truncGrid x.value t.extractionExponent+
        truncGrid (x.value-truncGrid x.value t.extractionExponent) t.block.q) := by
    apply List.map_congr_left
    intro x _
    exact hsplit x.value
  rw [hm,List.sum_map_add]

/-- Paper Lemma IV.4. -/
theorem paper_overlap_correction (t : Trace) :
    t.overlap = t.retainedLowParts.sum-t.outputResidual := by
  have h := paper_accumulator_eq_retained t
  unfold Trace.overlap Trace.outputResidual
  linarith

theorem rtz_value_spec (x : Rat) (bits : Nat) (y : Rat)
    (hr : TCFloat.round32 .towardZero x=some bits) (hv : TCFloat.value32 bits=some y) :
    y=TensorCore.signedRounded .towardZero x := by
  rw [round32_rtz_eq] at hr
  obtain ⟨b,hb,hbits⟩ := Option.map_eq_some_iff.mp hr
  rw [← hbits,value32_eq] at hv
  by_cases hz : x=0
  · subst x
    have h0 : TensorCore.round32 .towardZero 0=some 0 := by decide +kernel
    rw [h0] at hb
    cases Option.some.inj hb
    have hz : TensorCore.value32 0=some 0 := by decide +kernel
    rw [hz] at hv
    have hy : y=0 := (Option.some.inj hv).symm
    rw [hy]
    decide +kernel
  · obtain ⟨b',hb',hv',_,_⟩ := TensorCore.round32_nonzero_spec .towardZero x hz (TensorCore.round32_range hb)
    rw [hb] at hb'
    cases Option.some.inj hb'
    rw [hv] at hv'
    exact Option.some.inj hv'

theorem rtz_range (x : Rat) (b : Nat) (h : TCFloat.round32 .towardZero x=some b) :
    TensorCore.absQ x ≤ TensorCore.maxFinite32 := by
  rw [round32_rtz_eq] at h
  obtain ⟨b,hb,_⟩ := Option.map_eq_some_iff.mp h
  exact TensorCore.round32_range hb

/-- Actual FloatLib RTZ outputs are monotone in the exact value being converted. -/
theorem rtz_output_monotone (x y : Rat) (bx by' : Nat) (dx dy : Rat)
    (hx : TCFloat.round32 .towardZero x=some bx) (hy : TCFloat.round32 .towardZero y=some by')
    (hdx : TCFloat.value32 bx=some dx) (hdy : TCFloat.value32 by'=some dy) (hxy : x≤y) : dx≤dy := by
  rw [rtz_value_spec x bx dx hx hdx,rtz_value_spec y by' dy hy hdy]
  exact TensorCore.signedRounded_rtz_monotone x y hxy (rtz_range x bx hx) (rtz_range y by' hy)

/-- Paper Eq. 6 for the port's actual outputs under a C perturbation. -/
theorem paper_output_condition (p : Profile) (ps : List (Term×Term)) (c c' : Term)
    (bits bits' : Nat) (d d' : Rat)
    (h : (Block.mk p c ps).evaluate=some bits) (h' : (Block.mk p c' ps).evaluate=some bits')
    (hd : TCFloat.value32 bits=some d) (hd' : TCFloat.value32 bits'=some d') :
    (d<d' ↔ TensorCore.signedRounded .towardZero (Block.mk p c ps).accumulator <
      TensorCore.signedRounded .towardZero ((Block.mk p c ps).accumulator+
        TCFloat.flowback p ps c c'-TCFloat.accumulatorShift p ps c c')) := by
  rw [rtz_value_spec _ _ _ h hd,rtz_value_spec _ _ _ h' hd',TCFloat.perturbed_accumulator p ps c c']

theorem paper_flowback_necessary (p : Profile) (ps : List (Term×Term)) (c c' : Term)
    (bits bits' : Nat) (d d' : Rat)
    (h : (Block.mk p c ps).evaluate=some bits) (h' : (Block.mk p c' ps).evaluate=some bits')
    (hd : TCFloat.value32 bits=some d) (hd' : TCFloat.value32 bits'=some d') (hi : d<d') :
    TCFloat.accumulatorShift p ps c c' < TCFloat.flowback p ps c c' := by
  by_contra hn
  have ha : (Block.mk p c' ps).accumulator ≤ (Block.mk p c ps).accumulator := by
    rw [TCFloat.perturbed_accumulator p ps c c']; linarith
  have hm := rtz_output_monotone _ _ _ _ _ _ h' h hd' hd ha
  linarith

theorem paper_flowback_sufficient (p : Profile) (ps : List (Term×Term)) (c c' : Term)
    (bits bits' : Nat) (d d' : Rat)
    (h : (Block.mk p c ps).evaluate=some bits) (h' : (Block.mk p c' ps).evaluate=some bits')
    (hd : TCFloat.value32 bits=some d) (hd' : TCFloat.value32 bits'=some d')
    (ha : TensorCore.FiniteValue32 (Block.mk p c ps).accumulator)
    (ha' : TensorCore.FiniteValue32 (Block.mk p c' ps).accumulator)
    (hi : TCFloat.accumulatorShift p ps c c' < TCFloat.flowback p ps c c') : d<d' := by
  rw [rtz_value_spec _ _ _ h hd,rtz_value_spec _ _ _ h' hd',
    TensorCore.signedRounded_rtz_of_finite _ ha,TensorCore.signedRounded_rtz_of_finite _ ha',
    TCFloat.perturbed_accumulator p ps c c']
  linarith

def belowTerm (j : Nat) : Term :=
  ⟨FloatLib.Numerics.Dyadic.ofScaledInt ((16777216-j : Nat):Int) (-24),-1,23⟩

theorem belowTerm_project (j : Nat) : project (belowTerm j)=TensorCore.belowDecoded j :=
  project_term (TensorCore.belowDecoded j)

/-- Paper Theorem III.5 in the port: arbitrary p, K and perturbation j, including
the exact increase, threshold and maximum. Transport uses the proved converter/block bridge. -/
theorem paper_nonmonotone_range (prof : Profile) (p K j : Nat) (a b : Term)
    (hp : prof.extra=p) (ha : ValidTerm a) (hb : ValidTerm b)
    (hf : ∀ f ∈ prof.floor, f≤ -1)
    (hv : (a.mul b).value=TCFloat.pow2 (-(24+(p:Int))))
    (hs : (a.mul b).rawScale≤ -1) (hK : K<2^(24+p)) (hj : 1≤j) (hj' : j≤2^23) :
    ∃ bits y,
      (Block.mk prof (belowTerm j) (List.replicate K (a,b))).evaluate=some bits ∧
      TCFloat.value32 bits=some y ∧
      (1<y ↔ (j+2)*2^p≤K) ∧
      (j*2^p≤K → y=1+((K-j*2^p)/2^(p+1):Nat)*TCFloat.pow2 (-23)) ∧
      y≤1+((K-2^p)/2^(p+1):Nat)*TCFloat.pow2 (-23) := by
  have hva : a.value=(project a).value := ha
  have hvb : b.value=(project b).value := hb
  have hvs : (TensorCore.rawMul (project a) (project b)).value = TensorCore.pow2 (-(24+(p:Int))) := by
    rw [TensorCore.rawProduct_value,← hva,← hvb,← TCFloat.mul_value,pow2_eq]
    exact hv
  obtain ⟨s,he,hi,hy,hu⟩ := TensorCore.nonmonotone_range (profile prof) p K j
    (project a) (project b) (by simp [profile,hp]) hf hvs hs hK hj hj'
  let t : Block := ⟨prof,belowTerm j,List.replicate K (a,b)⟩
  have ht : ValidBlock t := by
    constructor
    · change (term (TensorCore.belowDecoded j)).value = _
      rw [term_value,belowTerm_project]
    · intro ab hab
      have hab' : ab=(a,b) := List.eq_of_mem_replicate hab
      subst ab
      exact ⟨ha,hb⟩
  have hblock : block t=⟨profile prof,List.replicate K (project a,project b),TensorCore.belowDecoded j⟩ := by
    simp [t,block,List.map_replicate,belowTerm_project]
  have hout := TensorCore.evalPrepared_output he
  refine ⟨s.output.bits.toNat,s.output.value,?_,?_,?_,?_,?_⟩
  · change t.evaluate=_
    rw [evaluate_eq t ht,hblock,hout]
    rfl
  · rw [value32_eq]
    simp [TensorCore.value32,s.output.valid,TensorCore.Finite32.value]
  · exact hi
  · simpa only [pow2_eq] using hy
  · simpa only [pow2_eq] using hu

/-- Every representable value in the source's finite FP32 set passes the port's test,
and every value passing that test belongs to exactly that set. -/
theorem finiteValue32_iff_representable (x : Rat) :
    TensorCore.FiniteValue32 x ↔ TCFloat.representable x=true := by
  rw [representable_eq]
  constructor
  · intro hx
    obtain ⟨b,hb,hv⟩ := TensorCore.round32_exact_of_finite hx
    simp [TensorCore.representable32,hb,hv]
  · exact TensorCore.representable32_finite

private theorem sum_map_difference (xs : List Rat) (f g : Rat → Rat) :
    (xs.map fun x => f x-g x).sum=(xs.map f).sum-(xs.map g).sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp only [List.map_cons,List.sum_cons,ih]; ring

/-- Paper Def. III.3 for an arbitrary chosen summand. The grids may be the actual
before/after TC grids; no unchanged-grid or primary-is-C assumption is made. -/
theorem general_flowback_necessary (primary primary' : Rat) (others : List Rat) (q q' : Int)
    (bits bits' : Nat) (d d' : Rat)
    (h : TCFloat.round32 .towardZero
      (truncGrid primary q+(others.map fun x => truncGrid x q).sum)=some bits)
    (h' : TCFloat.round32 .towardZero
      (truncGrid primary' q'+(others.map fun x => truncGrid x q').sum)=some bits')
    (hd : TCFloat.value32 bits=some d) (hd' : TCFloat.value32 bits'=some d') (hi : d<d') :
    truncGrid primary q-truncGrid primary' q' <
      (others.map fun x => truncGrid x q'-truncGrid x q).sum := by
  rw [sum_map_difference]
  by_contra hn
  have hle : truncGrid primary' q'+(others.map fun x => truncGrid x q').sum ≤
      truncGrid primary q+(others.map fun x => truncGrid x q).sum := by linarith
  have hm := rtz_output_monotone _ _ _ _ _ _ h' h hd' hd hle
  linarith

theorem general_flowback_sufficient (primary primary' : Rat) (others : List Rat) (q q' : Int)
    (bits bits' : Nat) (d d' : Rat)
    (h : TCFloat.round32 .towardZero
      (truncGrid primary q+(others.map fun x => truncGrid x q).sum)=some bits)
    (h' : TCFloat.round32 .towardZero
      (truncGrid primary' q'+(others.map fun x => truncGrid x q').sum)=some bits')
    (hd : TCFloat.value32 bits=some d) (hd' : TCFloat.value32 bits'=some d')
    (ha : TCFloat.representable (truncGrid primary q+(others.map fun x => truncGrid x q).sum)=true)
    (ha' : TCFloat.representable (truncGrid primary' q'+(others.map fun x => truncGrid x q').sum)=true)
    (hi : truncGrid primary q-truncGrid primary' q' <
      (others.map fun x => truncGrid x q'-truncGrid x q).sum) : d<d' := by
  rw [rtz_value_spec _ _ _ h hd,rtz_value_spec _ _ _ h' hd',
    TensorCore.signedRounded_rtz_of_finite _ ((finiteValue32_iff_representable _).mpr ha),
    TensorCore.signedRounded_rtz_of_finite _ ((finiteValue32_iff_representable _).mpr ha')]
  rw [sum_map_difference] at hi
  linarith

end TCFloat.Equivalence
