import TensorCore.Theory.FP8

/-! Kernel-checked L40S archive rows and distinguishing FP8 boundary cases.
Published rows are pinned in vendor/SOURCES.json; the paper/source discrepancy
remains explicit and is not a device-conformance theorem. -/

namespace TensorCore.Regression

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

def l40sE4M3Row : List (BitVec 8 × BitVec 8) :=
  [(0x37, 0x31), (0x38, 0xb2), (0xaa, 0x2d), (0x3b, 0x29), (0xb3, 0xbf), (0x2a, 0x2f), (0x38, 0xbc), (0x3e, 0xb9), (0x36, 0x1b), (0x35, 0xb3), (0xb8, 0xb5), (0x2b, 0x40), (0x0f, 0x87), (0x29, 0x41), (0x38, 0x21), (0x35, 0xaa), (0xb8, 0xb7), (0x37, 0x3f), (0x03, 0xb2), (0xba, 0x31), (0xae, 0xad), (0xa6, 0x9d), (0x3a, 0xb8), (0x3d, 0x3a), (0x92, 0x3d), (0x26, 0x3b), (0xb0, 0x9b), (0xaf, 0x86), (0xb3, 0xbc), (0x33, 0xac), (0x42, 0x12), (0x2d, 0x83)]

theorem l40s_e4m3_published_row :
    l40sFP8Bits .e4m3 .source13 l40sE4M3Row 0x3e93ca5a = some 0x40827800 ∧
    l40sFP8Bits .e4m3 .paper l40sE4M3Row 0x3e93ca5a = some 0x40827b00 := by
  decide +kernel

theorem l40s_e4m3_group_order :
    l40sFP8Bits .e4m3 .source13 (l40sE4M3Row.drop 16 ++ l40sE4M3Row.take 16)
      0x3e93ca5a = some 0x40827c00 ∧
    (0x40827800 : F32) ≠ 0x40827c00 := by decide +kernel

def l40sE5M2Row : List (BitVec 8 × BitVec 8) :=
  [(0x3b, 0x38), (0x3c, 0xb9), (0xb5, 0x36), (0x3d, 0x34), (0xb9, 0xbf), (0x35, 0x37), (0x3c, 0xbe), (0x3f, 0xbc), (0x3b, 0x2d), (0x3a, 0xb9), (0xbc, 0xba), (0x35, 0x40), (0x27, 0xa3), (0x34, 0x40), (0x3c, 0x30), (0x3a, 0xb5), (0xbc, 0xbb), (0x3b, 0x3f), (0x1e, 0xb9), (0xbd, 0x38), (0xb7, 0xb6), (0xb3, 0xae), (0x3d, 0xbc), (0x3e, 0x3d), (0xa9, 0x3e), (0x33, 0x3d), (0xb8, 0xad), (0xb7, 0xa2), (0xb9, 0xbe), (0x39, 0xb6), (0x41, 0x29), (0x36, 0x9e)]

theorem l40s_e5m2_published_row :
    l40sFP8Bits .e5m2 .source13 l40sE5M2Row 0x3f503bf0 = some 0x4073ec00 ∧
    l40sFP8Bits .e5m2 .paper l40sE5M2Row 0x3f503bf0 = some 0x4073ec00 := by
  decide +kernel

theorem l40s_e5m2_group_order :
    l40sFP8Bits .e5m2 .source13 (l40sE5M2Row.drop 16 ++ l40sE5M2Row.take 16)
      0x3f503bf0 = some 0x4073f000 ∧
    (0x4073ec00 : F32) ≠ 0x4073f000 := by decide +kernel

/-- Three nonzero products suffice: the last group sums to 2 + 2^-13.
Its alignment retains the low bit; normalized 13-fraction-bit truncation loses it. -/
def fp8PrecisionWitness : List (BitVec 8 × BitVec 8) :=
  List.replicate 16 (0, 0) ++ [(0x38, 0x38), (0x38, 0x38), (0x08, 0x04)] ++
    List.replicate 13 (0, 0)

theorem fp8_normalized_precision_discrepancy :
    l40sFP8Ideal .e4m3 fp8PrecisionWitness 0 = some (2 + pow2 (-13)) ∧
    l40sFP8Bits .e4m3 .paper fp8PrecisionWitness 0 = some 0x40000200 ∧
    l40sFP8Bits .e4m3 .source13 fp8PrecisionWitness 0 = some 0x40000000 := by
  decide +kernel

/-- E4M3 maximum finite value 448, including its finite top exponent. -/
theorem fp8_e4m3_top_exponent :
    l40sFP8Bits .e4m3 .source13 ([(0x7e, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x43e00000 ∧
    l40sFP8Bits .e4m3 .paper ([(0x7e, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x43e00000 := by decide +kernel

theorem fp8_subnormal_preserved :
    l40sFP8Bits .e4m3 .source13 ([(1, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x3b000000 ∧
    l40sFP8Bits .e5m2 .source13 ([(1, 0x3c)] ++ List.replicate 31 (0, 0)) 0 =
      some 0x37800000 := by decide +kernel

theorem fp8_zero_and_rejections :
    l40sFP8Bits .e4m3 .source13 (List.replicate 32 (0, 0)) 0x80000000 = some 0 ∧
    runL40SFP8 .e4m3 .source13 (List.replicate 31 (0, 0)) 0 = .error .wrongProductCount ∧
    runL40SFP8 .e4m3 .source13 ([(0x7f, 0x38)] ++ List.replicate 31 (0, 0)) 0 =
      .error .nonfiniteOrInvalidEncoding ∧
    runL40SFP8 .e5m2 .source13 (List.replicate 16 (0, 0) ++ [(0x7c, 0x3c)] ++
      List.replicate 15 (0, 0)) 0 = .error .nonfiniteOrInvalidEncoding ∧
    runL40SFP8 .e5m2 .paper (List.replicate 32 (0, 0)) 0x7f800000 =
      .error .nonfiniteOrInvalidEncoding := by decide +kernel

def fp8Words (f : FP8Format) (ps : List (BitVec 8 × BitVec 8)) :
    List (f.encoding.Word × f.encoding.Word) := by cases f <;> exact ps

/-- (eta, alignment loss, accumulated value, conversion loss, FP32 output).
Project the actual trace so the precision witness locates the lost bit. -/
def fp8BlockObservation (f : FP8Format) (reading : FP8Reading)
    (ps : List (BitVec 8 × BitVec 8)) (c : F32) :
    Option (Option Int × Rat × Rat × Rat × F32) :=
  (evalInvocation (p := l40sFP8Invocation f reading) ⟨fp8Words f ps, c⟩).toOption.map fun t =>
    ((t.prepared.alignedBlock 13 none true).eta, t.accumulation.alignmentLoss,
      t.accumulation.value, t.intermediate.loss, t.output.bits)

/-- Encoded factors for 1 and 2^-13, in both native FP8 formats. -/
def fp8ProbeFactors : FP8Format → BitVec 8 × (BitVec 8 × BitVec 8)
  | .e4m3 => (0x38, (0x08, 0x04))
  | .e5m2 => (0x3c, (0x20, 0x24))

def fp8CarryGroup (f : FP8Format) : List (BitVec 8 × BitVec 8) :=
  let (one, small) := fp8ProbeFactors f
  [(one, one), (one, one), small] ++ List.replicate 13 (0, 0)

/-- A carry changes the normalized grid from 2^-13 to 2^-12. Alignment loses
nothing; only the source13 conversion drops the low bit. This holds for E5M2 too. -/
theorem fp8_carry_loss_location (f : FP8Format) :
    fp8BlockObservation f .paper (fp8CarryGroup f) 0 =
      some (some 0, 0, 2 + pow2 (-13), 0, 0x40000200) ∧
    fp8BlockObservation f .source13 (fp8CarryGroup f) 0 =
      some (some 0, 0, 2 + pow2 (-13), pow2 (-13), 0x40000000) := by
  cases f <;> decide +kernel

/-- Negative carry witnesses distinguish signed truncation from rounding down. -/
theorem fp8_negative_carry_loss (f : FP8Format) :
    let ps := (fp8CarryGroup f).map fun (a, b) => (a ^^^ 0x80, b)
    fp8BlockObservation f .paper ps 0 =
      some (some 0, 0, -(2 + pow2 (-13)), 0, 0xc0000200) ∧
    fp8BlockObservation f .source13 ps 0 =
      some (some 0, 0, -(2 + pow2 (-13)), -pow2 (-13), 0xc0000000) := by
  cases f <;> decide +kernel

/-- Section 4.1.4's reported endpoint: p1=1, p2=p3=2^-13, c=0.
The displayed stopping expression in the prose has inconsistent indices; this
checks its stated numerical endpoint, not an inferred correction of that expression.
With no carry beyond eta, this probe cannot choose the final precision. -/
theorem fp8_paper_alignment_probe (f : FP8Format) (reading : FP8Reading) :
    let (one, small) := fp8ProbeFactors f
    fp8BlockObservation f reading
      ([(one, one), small, small] ++ List.replicate 13 (0, 0)) 0 =
      some (some 0, 0, 1 + pow2 (-12), 0, 0x3f800800) := by
  cases f <;> cases reading <;> decide +kernel

/-- Section 4.1.4's early-c probe also agrees: c=1, p1=p2=2^-14.
The loss already occurs in alignment and says nothing about normalized precision. -/
theorem fp8_paper_early_c_probe (reading : FP8Reading) :
    fp8BlockObservation .e4m3 reading
      ([(0x08, 0x02), (0x08, 0x02)] ++ List.replicate 14 (0, 0)) 0x3f800000 =
      some (some 0, pow2 (-13), 1, 0, 0x3f800000) := by
  cases reading <;> decide +kernel

/-- Moving the carry witness to the first group exposes distinct intermediate
words but the next group's alignment erases the distinction. Final archive bits
alone therefore do not identify every intermediate conversion boundary. -/
theorem fp8_first_group_precision_absorbed (f : FP8Format) :
    let ps := fp8CarryGroup f ++ List.replicate 16 (0, 0)
    ((runL40SFP8 f .paper (fp8Words f ps) 0).toOption.map fun t =>
      (t.first.output.bits, t.second.output.bits)) = some (0x40000200, 0x40000000) ∧
    ((runL40SFP8 f .source13 (fp8Words f ps) 0).toOption.map fun t =>
      (t.first.output.bits, t.second.output.bits)) = some (0x40000000, 0x40000000) := by
  cases f <;> decide +kernel

end TensorCore.Regression
