import TensorCore.Programs.FP8
import TensorCore.Theory.Binary.Conversion
import TensorCore.Programs.Loops
import TensorCore.Theory.CanonicalFloor

namespace TensorCore

theorem l40sFP8_valid (f : FP8Format) (reading : FP8Reading) :
    (l40sFP8Invocation f reading).Valid := by cases f <;> cases reading <;> decide

theorem fp8Products_append (f : FP8Format) (xs ys : List (f.encoding.Word × f.encoding.Word)) :
    fp8Products f (xs ++ ys) = (do return (← fp8Products f xs) + (← fp8Products f ys)) := by
  have hp : prepareFP8Products f (xs ++ ys) =
      (do return (← prepareFP8Products f xs) ++ (← prepareFP8Products f ys)) := by
    simp [prepareFP8Products]
  unfold fp8Products
  rw [hp]
  cases hx : prepareFP8Products f xs <;> cases hy : prepareFP8Products f ys <;>
    simp [List.map_append, sumQ_append]

/-- The two groups preserve every original pair, its order, and multiplicity. -/
theorem l40sFP8_partition (f : FP8Format) (ps : List (f.encoding.Word × f.encoding.Word)) :
    ps.take 16 ++ ps.drop 16 = ps := List.take_append_drop 16 ps

theorem fp8_prepared_decoding {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {b : PreparedInvocation (l40sFP8Invocation f reading)}
    (h : prepareInvocation x = some b) :
    decode32 x.c = some b.c ∧ prepareFP8Products f x.products = some b.products := by
  change (do
    let c ← decode32 x.c
    let ps ← prepareFP8Products f x.products
    return (⟨ps, c⟩ : PreparedInvocation (l40sFP8Invocation f reading))) = some b at h
  cases hc : decode32 x.c with
  | none => simp only [hc] at h; contradiction
  | some c =>
    simp only [hc] at h
    cases hp : prepareFP8Products f x.products with
    | none => simp [hp] at h
    | some ps =>
      simp [hp] at h
      subst b
      exact ⟨rfl, rfl⟩

theorem fp8_prepared {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {b : PreparedInvocation (l40sFP8Invocation f reading)}
    (h : prepareInvocation x = some b) :
    decode32 x.c = some b.c ∧ fp8Products f x.products = some b.exactProducts := by
  obtain ⟨hc, hp⟩ := fp8_prepared_decoding h
  exact ⟨hc, by simp [fp8Products, hp, PreparedInvocation.exactProducts]⟩

/-- Exhaustive kernel proof over the two finite 8-bit encoding domains. -/
theorem fp8_decode_scale_lower (f : FP8Format) (w : f.encoding.Word) (d : Decoded)
    (h : f.encoding.decode w = some d) : -14 ≤ d.rawScale := by
  have hall : ∀ w : f.encoding.Word,
      (f.encoding.decode w).all (fun d => decide (-14 ≤ d.rawScale)) = true := by
    cases f <;> decide +kernel
  have hw := hall w
  rw [h] at hw
  simpa using hw

theorem prepareFP8Products_scale_lower (f : FP8Format)
    (xs : List (f.encoding.Word × f.encoding.Word)) (ds : List (Decoded × Decoded))
    (h : prepareFP8Products f xs = some ds) :
    ∀ pair ∈ ds, -14 ≤ pair.1.rawScale ∧ -14 ≤ pair.2.rawScale := by
  induction xs generalizing ds with
  | nil => simp [prepareFP8Products] at h; subst ds; simp
  | cons w xs ih =>
    cases ha : f.encoding.decode w.1 with
    | none => simp [prepareFP8Products, List.mapM_cons, ha] at h
    | some a =>
      cases hb : f.encoding.decode w.2 with
      | none => simp [prepareFP8Products, List.mapM_cons, ha, hb] at h
      | some b =>
        cases ht : prepareFP8Products f xs with
        | none => simp [prepareFP8Products, List.mapM_cons, ha, hb] at h ht; rw [ht] at h; contradiction
        | some rest =>
          have he : prepareFP8Products f (w :: xs) = some ((a, b) :: rest) := by
            have ht' := ht
            simp [prepareFP8Products] at ht'
            simp [prepareFP8Products, List.mapM_cons, ha, hb, ht']
          rw [he] at h
          cases Option.some.inj h
          intro pair hm
          rcases List.mem_cons.mp hm with rfl | hm
          · exact ⟨fp8_decode_scale_lower f w.1 a ha, fp8_decode_scale_lower f w.2 b hb⟩
          · exact ih rest ht pair hm

/-- The v0.5 floor -132 is inactive for finite FP8 factors and FP32 c. This justifies
the Table 3 descriptor's absent floor even for zero and subnormal inputs. -/
theorem l40sFP8_floor_inactive {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {b : PreparedInvocation (l40sFP8Invocation f reading)}
    (h : prepareInvocation x = some b) :
    (b.alignedBlock 13 (some (-132)) true).eta = (b.alignedBlock 13 none true).eta := by
  obtain ⟨hc, hp⟩ := fp8_prepared_decoding h
  have hl : ∀ t ∈ (b.alignedBlock 13 none true).terms,
      t.significand ≠ 0 → -126 ≤ t.rawScale := by
    intro t ht hnz
    change t ∈ (⟨b.c.significand, b.c.rawScale, b.c.fractionalBits⟩ ::
      b.products.map fun (a, b) => rawMul a b) at ht
    rcases List.mem_cons.mp ht with rfl | ht
    · exact classifyNat_scale_lower fp32 x.c.toNat b.c hc hnz
    · obtain ⟨pair, hm, rfl⟩ := List.mem_map.mp ht
      obtain ⟨ha, hb⟩ := prepareFP8Products_scale_lower f x.products b.products hp pair hm
      change -126 ≤ pair.1.rawScale + pair.2.rawScale
      omega
  have ht : (b.alignedBlock 13 (some (-132)) true).terms =
      (b.alignedBlock 13 none true).terms := rfl
  unfold PreparedBlock.eta
  rw [ht]
  cases he : alignmentScale (b.alignedBlock 13 none true).terms with
  | none => rfl
  | some e =>
    have hmin := alignmentScale_lower _ (-126) e hl he
    change some (max e (-132)) = some e
    congr 1
    omega

theorem runL40SFP8_spec {f : FP8Format} {reading : FP8Reading}
    {ps : List (f.encoding.Word × f.encoding.Word)} {c : F32} {t : L40SFP8Trace f reading}
    (h : runL40SFP8 f reading ps c = .ok t) :
    ps.length = 32 ∧
    evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.take 16, c⟩ = .ok t.first ∧
    evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.drop 16, t.first.output.bits⟩ =
      .ok t.second := by
  unfold runL40SFP8 at h
  split at h
  · simp at h
  · rename_i hs
    cases h1 : evalInvocation (p := l40sFP8Invocation f reading) ⟨ps.take 16, c⟩ with
    | error e => simp [h1] at h
    | ok first =>
      cases h2 : evalInvocation (p := l40sFP8Invocation f reading)
          ⟨ps.drop 16, first.output.bits⟩ with
      | error e => simp [h1, h2] at h
      | ok second =>
        simp [h1, h2] at h
        subst t
        exact ⟨by simpa using hs, rfl, h2⟩

/-- Exact loss accounting for either reading, across the *encoded* group boundary,
against the independent ideal of all 32 original operand pairs. -/
theorem runL40SFP8_recovery {f : FP8Format} {reading : FP8Reading}
    {ps : List (f.encoding.Word × f.encoding.Word)} {c : F32} {t : L40SFP8Trace f reading}
    (h : runL40SFP8 f reading ps c = .ok t) :
    l40sFP8Ideal f ps c = some (t.second.output.value + t.first.residual + t.second.residual) := by
  obtain ⟨_, h1, h2⟩ := runL40SFP8_spec h
  have hs1 := evalInvocation_spec h1
  have hs2 := evalInvocation_spec h2
  obtain ⟨hc, hp1⟩ := fp8_prepared hs1.2.2.1
  obtain ⟨hb, hp2⟩ := fp8_prepared hs2.2.2.1
  have hb' : t.second.prepared.c = t.first.output.decoded := by
    have hv : decode32 t.first.output.bits = some t.first.output.decoded := t.first.output.valid
    rw [hv] at hb
    exact (Option.some.inj hb).symm
  have hr1 := evalInvocation_recovery h1
  have hr2 := evalInvocation_recovery h2
  simp only [invocationIdeal, hs1.2.2.1, Option.map_some, Option.some.injEq] at hr1
  simp only [invocationIdeal, hs2.2.2.1, Option.map_some, Option.some.injEq] at hr2
  have hp : fp8Products f ps = some (t.first.prepared.exactProducts + t.second.prepared.exactProducts) := by
    rw [← l40sFP8_partition f ps, fp8Products_append, hp1, hp2]
    rfl
  simp only [l40sFP8Ideal, hc, hp]
  change some (t.first.prepared.c.value +
    (t.first.prepared.exactProducts + t.second.prepared.exactProducts)) = _
  unfold PreparedInvocation.exactDot at hr1 hr2
  rw [hb'] at hr2
  change t.first.output.value + _ = _ at hr2
  congr 1
  grind

/-- Final FP32 conversion is toward zero for both readings. In `source13`, the
intermediate precision reduction is a separate event with its own rounding theorem. -/
theorem l40sFP8_output_towardZero {f : FP8Format} {reading : FP8Reading}
    {x : InvocationInput (l40sFP8Invocation f reading)}
    {t : InvocationTrace (l40sFP8Invocation f reading)} (h : evalInvocation x = .ok t) :
    TowardZero fp32 t.intermediate.value t.output.bits :=
  evalInvocation_output_towardZero h rfl

theorem l40sFP8_source13_towardZero {f : FP8Format}
    {x : InvocationInput (l40sFP8Invocation f .source13)}
    {t : InvocationTrace (l40sFP8Invocation f .source13)} (h : evalInvocation x = .ok t) :
    ∀ e ∈ t.intermediate.events, TowardZero e.stage.format e.input e.output.bits := by
  have hr := (evalInvocation_spec h).2.2.2.2.1
  obtain ⟨hs, he⟩ := runConversions_events _ _ _ hr
  intro e hm
  have hm' : e.stage ∈ t.intermediate.events.map ConversionEvent.stage := List.mem_map_of_mem hm
  rw [hs] at hm'
  have heq : e.stage = ⟨fp32With13FractionBits, .towardZero⟩ := by simpa [l40sFP8Invocation] using hm'
  apply conversionStage_towardZero_correct e.stage
  · rw [heq]; decide
  · rw [heq]
  · exact he e hm

/-- On the same decoded inputs, the readings have identical accumulation,
including alignment loss. Only their subsequent conversions differ. -/
theorem l40sFP8_readings_same_accumulation (f : FP8Format)
    (ps : List (Decoded × Decoded)) (c : Decoded) :
    accumulateInvocation (p := l40sFP8Invocation f .paper) ⟨ps, c⟩ =
      accumulateInvocation (p := l40sFP8Invocation f .source13) ⟨ps, c⟩ := rfl

/-- The direct-FP32 candidate rounds the accumulated value itself. -/
theorem l40sFP8_paper_towardZero_accumulation {f : FP8Format}
    {x : InvocationInput (l40sFP8Invocation f .paper)}
    {t : InvocationTrace (l40sFP8Invocation f .paper)} (h : evalInvocation x = .ok t) :
    TowardZero fp32 t.accumulation.value t.output.bits := by
  have hr := (evalInvocation_spec h).2.2.2.2.1
  have hi : t.intermediate = ⟨[], t.accumulation.value⟩ := by
    simpa [l40sFP8Invocation, runConversions] using hr.symm
  have ho := l40sFP8_output_towardZero h
  simpa [hi] using ho

/-- Source13 has exactly one reduced-precision event on the accumulated value.
This proves the explicit source model's boundary, not paper/device conformance. -/
theorem l40sFP8_source13_boundary {f : FP8Format}
    {x : InvocationInput (l40sFP8Invocation f .source13)}
    {t : InvocationTrace (l40sFP8Invocation f .source13)} (h : evalInvocation x = .ok t) :
    ∃ d : FiniteBinary fp32With13FractionBits,
      t.intermediate = ⟨[⟨⟨fp32With13FractionBits, .towardZero⟩,
        t.accumulation.value, d⟩], d.value⟩ ∧
      TowardZero fp32With13FractionBits t.accumulation.value d.bits := by
  have hr := (evalInvocation_spec h).2.2.2.2.1
  let s : ConversionStage := ⟨fp32With13FractionBits, .towardZero⟩
  change runConversions [s] t.accumulation.value = some t.intermediate at hr
  cases hd : s.convert t.accumulation.value with
  | none => simp [runConversions, hd] at hr
  | some d =>
    refine ⟨d, ?_, conversionStage_towardZero_correct s (by decide) rfl _ _ hd⟩
    simpa [runConversions, hd] using hr.symm

end TensorCore
