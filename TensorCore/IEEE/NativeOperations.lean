import TensorCore.IEEE.LeanBridge64

/-! Proved native implementation paths. The exact scalar operations remain
available as independent references and as fallbacks for unmatched domains. -/

namespace TensorCore.IEEE

open LeanBridge

/-- Status for an exact finite result in range, using the supplied rounded bits.
This avoids computing the reference's rounded encoding again to obtain flags. -/
def inRangeResult32 (cfg : Context) (x : ℚ) (bits : F32) : Result .binary32 :=
  if x = 0 then ⟨bits, {}⟩ else
    let inexact := decide (binaryValue fp32 bits ≠ some x)
    let u := precisionMagnitude fp32 cfg.mode (decide (x < 0)) (absQ x)
    ⟨bits, { inexact, underflow := tiny .binary32 cfg (absQ x) u && inexact }⟩

theorem inRangeResult32_eq (cfg : Context) (zeroSign : Bool) (x : ℚ) (bits : F32)
    (hr : absQ x ≤ fp32.maxFinite) (hb : bits = (round .binary32 cfg zeroSign x).bits) :
    inRangeResult32 cfg x bits = round .binary32 cfg zeroSign x := by
  rw [hb]
  by_cases hz : x = 0 <;>
    simp only [inRangeResult32, round, hz, hr, BinaryFormat.layout, ↓reduceIte, ↓reduceDIte]
  rfl

def nativeAddResult32 (cfg : Context) (a b : F32)
    (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b) : Result .binary32 :=
  inRangeResult32 cfg (finiteValue32 a + finiteValue32 b)
    (nativeAdd32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1))

/-- The native path preserves every observable bit and exception flag. -/
theorem nativeAddResult32_eq (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a + finiteValue32 b) ≤ fp32.maxFinite) :
    nativeAddResult32 cfg a b ha hb = add .binary32 cfg a b := by
  have href : add .binary32 cfg a b = round .binary32 cfg
      (sumZeroSign cfg.mode (sign32 a) (sign32 b)) (finiteValue32 a + finiteValue32 b) := by
    change addDatum .binary32 cfg (decode .binary32 a) (decode .binary32 b) = _
    rw [decode32_nonzero a ha, decode32_nonzero b hb]
    rfl
  have hbits := nativeAdd32_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeAddResult32
  rw [inRangeResult32_eq _ _ _ _ hr hbits, ← href]

def inRangeResult64 (cfg : Context) (x : ℚ) (bits : F64) : Result .binary64 :=
  if x = 0 then ⟨bits, {}⟩ else
    let inexact := decide (binaryValue fp64 bits ≠ some x)
    let u := precisionMagnitude fp64 cfg.mode (decide (x < 0)) (absQ x)
    ⟨bits, { inexact, underflow := tiny .binary64 cfg (absQ x) u && inexact }⟩

theorem inRangeResult64_eq (cfg : Context) (zeroSign : Bool) (x : ℚ) (bits : F64)
    (hr : absQ x ≤ fp64.maxFinite) (hb : bits = (round .binary64 cfg zeroSign x).bits) :
    inRangeResult64 cfg x bits = round .binary64 cfg zeroSign x := by
  rw [hb]
  by_cases hz : x = 0 <;>
    simp only [inRangeResult64, round, hz, hr, BinaryFormat.layout, ↓reduceIte, ↓reduceDIte]
  rfl

def nativeAddResult64 (cfg : Context) (a b : F64)
    (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) : Result .binary64 :=
  inRangeResult64 cfg (finiteValue64 a + finiteValue64 b)
    (nativeAdd64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1))

theorem nativeAddResult64_eq (cfg : Context) (a b : F64)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (hr : absQ (finiteValue64 a + finiteValue64 b) ≤ fp64.maxFinite) :
    nativeAddResult64 cfg a b ha hb = add .binary64 cfg a b := by
  have href : add .binary64 cfg a b = round .binary64 cfg
      (sumZeroSign cfg.mode (sign64 a) (sign64 b)) (finiteValue64 a + finiteValue64 b) := by
    change addDatum .binary64 cfg (decode .binary64 a) (decode .binary64 b) = _
    rw [decode64_nonzero a ha, decode64_nonzero b hb]
    rfl
  have hbits := nativeAdd64_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeAddResult64
  rw [inRangeResult64_eq _ _ _ _ hr hbits, ← href]

def nativeSubResult64 (cfg : Context) (a b : F64)
    (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) : Result .binary64 :=
  inRangeResult64 cfg (finiteValue64 a - finiteValue64 b)
    (nativeSub64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1))

theorem nativeSubResult64_eq (cfg : Context) (a b : F64)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (hr : absQ (finiteValue64 a - finiteValue64 b) ≤ fp64.maxFinite) :
    nativeSubResult64 cfg a b ha hb = sub .binary64 cfg a b := by
  have href : sub .binary64 cfg a b = round .binary64 cfg
      (sumZeroSign cfg.mode (sign64 a) (!(sign64 b))) (finiteValue64 a - finiteValue64 b) := by
    change addDatum .binary64 cfg (decode .binary64 a) (decode .binary64 b).negate = _
    rw [decode64_nonzero a ha, decode64_nonzero b hb]
    simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
    rw [← Rat.sub_eq_add_neg]
    rfl
  have hbits := nativeSub64_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeSubResult64
  rw [inRangeResult64_eq _ _ _ _ hr hbits, ← href]

def nativeMulResult64 (cfg : Context) (a b : F64)
    (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b) : Result .binary64 :=
  inRangeResult64 cfg (finiteValue64 a * finiteValue64 b)
    (nativeMul64 a b (native64Valid_finite a ha.1) (native64Valid_finite b hb.1))

theorem nativeMulResult64_eq (cfg : Context) (a b : F64)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite64 a) (hb : NonzeroFinite64 b)
    (hr : absQ (finiteValue64 a * finiteValue64 b) ≤ fp64.maxFinite) :
    nativeMulResult64 cfg a b ha hb = mul .binary64 cfg a b := by
  have href : mul .binary64 cfg a b = round .binary64 cfg
      (xor (sign64 a) (sign64 b)) (finiteValue64 a * finiteValue64 b) := by
    change mulDatum .binary64 cfg (decode .binary64 a) (decode .binary64 b) = _
    rw [decode64_nonzero a ha, decode64_nonzero b hb]
    rfl
  have hbits := nativeMul64_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeMulResult64
  rw [inRangeResult64_eq _ _ _ _ hr hbits, ← href]

/-- Uses native FP32/FP64 addition only on the proved domain. Reference paths retain
zero operands, nonfinite operands, overflowing exact sums, other formats, and
other rounding modes. The reference itself is not removed or redefined. -/
def addWithLean : (f : BinaryFormat) → Context → Word f → Word f → Result f
  | .binary32, cfg, a, b =>
    let a32 : F32 := a
    let b32 : F32 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite32 a32 then
        if hb : NonzeroFinite32 b32 then
          if absQ (finiteValue32 a32 + finiteValue32 b32) ≤ fp32.maxFinite then
            nativeAddResult32 cfg a32 b32 ha hb
          else add .binary32 cfg a b
        else add .binary32 cfg a b
      else add .binary32 cfg a b
    else add .binary32 cfg a b
  | .binary16, cfg, a, b => add .binary16 cfg a b
  | .binary64, cfg, a, b =>
    let a64 : F64 := a
    let b64 : F64 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite64 a64 then
        if hb : NonzeroFinite64 b64 then
          if absQ (finiteValue64 a64 + finiteValue64 b64) ≤ fp64.maxFinite then
            nativeAddResult64 cfg a64 b64 ha hb
          else add .binary64 cfg a b
        else add .binary64 cfg a b
      else add .binary64 cfg a b
    else add .binary64 cfg a b

theorem addWithLean_native (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a + finiteValue32 b) ≤ fp32.maxFinite) :
    addWithLean .binary32 cfg a b = nativeAddResult32 cfg a b ha hb := by
  simp only [addWithLean, hm, ha, hb, hr, ↓reduceIte, ↓reduceDIte]

/-- Total public-contract preservation, including every fallback case. -/
theorem addWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    addWithLean f cfg a b = add f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [addWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeAddResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [addWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeAddResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›

theorem addWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b) (addWithLean f cfg a b) := by
  rw [addWithLean_eq]
  exact add_correct f cfg a b

def nativeSubResult32 (cfg : Context) (a b : F32)
    (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b) : Result .binary32 :=
  inRangeResult32 cfg (finiteValue32 a - finiteValue32 b)
    (nativeSub32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1))

/-- The native path preserves every observable bit and exception flag. -/
theorem nativeSubResult32_eq (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a - finiteValue32 b) ≤ fp32.maxFinite) :
    nativeSubResult32 cfg a b ha hb = sub .binary32 cfg a b := by
  have href : sub .binary32 cfg a b = round .binary32 cfg
      (sumZeroSign cfg.mode (sign32 a) (!(sign32 b))) (finiteValue32 a - finiteValue32 b) := by
    change addDatum .binary32 cfg (decode .binary32 a) (decode .binary32 b).negate = _
    rw [decode32_nonzero a ha, decode32_nonzero b hb]
    simp only [Datum.negate, addDatum, Datum.isNaN, Bool.false_or, Bool.false_eq_true, ↓reduceIte]
    rw [← Rat.sub_eq_add_neg]
    rfl
  have hbits := nativeSub32_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeSubResult32
  rw [inRangeResult32_eq _ _ _ _ hr hbits, ← href]

/-- Uses native FP32/FP64 subtraction only on the proved domain. Reference paths retain
zero operands, nonfinite operands, out-of-range exact differences, other formats, and
other rounding modes. The reference itself is not removed or redefined. -/
def subWithLean : (f : BinaryFormat) → Context → Word f → Word f → Result f
  | .binary32, cfg, a, b =>
    let a32 : F32 := a
    let b32 : F32 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite32 a32 then
        if hb : NonzeroFinite32 b32 then
          if absQ (finiteValue32 a32 - finiteValue32 b32) ≤ fp32.maxFinite then
            nativeSubResult32 cfg a32 b32 ha hb
          else sub .binary32 cfg a b
        else sub .binary32 cfg a b
      else sub .binary32 cfg a b
    else sub .binary32 cfg a b
  | .binary16, cfg, a, b => sub .binary16 cfg a b
  | .binary64, cfg, a, b =>
    let a64 : F64 := a
    let b64 : F64 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite64 a64 then
        if hb : NonzeroFinite64 b64 then
          if absQ (finiteValue64 a64 - finiteValue64 b64) ≤ fp64.maxFinite then
            nativeSubResult64 cfg a64 b64 ha hb
          else sub .binary64 cfg a b
        else sub .binary64 cfg a b
      else sub .binary64 cfg a b
    else sub .binary64 cfg a b

theorem subWithLean_native (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a - finiteValue32 b) ≤ fp32.maxFinite) :
    subWithLean .binary32 cfg a b = nativeSubResult32 cfg a b ha hb := by
  simp only [subWithLean, hm, ha, hb, hr, ↓reduceIte, ↓reduceDIte]

/-- Total public-contract preservation, including every fallback case. -/
theorem subWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    subWithLean f cfg a b = sub f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [subWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeSubResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [subWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeSubResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›

theorem subWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    AddSpec f cfg (decode f a) (decode f b).negate (subWithLean f cfg a b) := by
  rw [subWithLean_eq]
  exact sub_correct f cfg a b

def nativeMulResult32 (cfg : Context) (a b : F32)
    (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b) : Result .binary32 :=
  inRangeResult32 cfg (finiteValue32 a * finiteValue32 b)
    (nativeMul32 a b (native32Valid_finite a ha.1) (native32Valid_finite b hb.1))

/-- The native path preserves every observable bit and exception flag. -/
theorem nativeMulResult32_eq (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a * finiteValue32 b) ≤ fp32.maxFinite) :
    nativeMulResult32 cfg a b ha hb = mul .binary32 cfg a b := by
  have href : mul .binary32 cfg a b = round .binary32 cfg
      (xor (sign32 a) (sign32 b)) (finiteValue32 a * finiteValue32 b) := by
    change mulDatum .binary32 cfg (decode .binary32 a) (decode .binary32 b) = _
    rw [decode32_nonzero a ha, decode32_nonzero b hb]
    rfl
  have hbits := nativeMul32_reference a b ha hb cfg.tininess hr
  have hcfg : (⟨.nearestEven, cfg.tininess⟩ : Context) = cfg := by
    cases cfg
    simp_all
  rw [hcfg, href] at hbits
  unfold nativeMulResult32
  rw [inRangeResult32_eq _ _ _ _ hr hbits, ← href]

/-- Uses native FP32/FP64 multiplication only on the proved domain. Reference paths retain
zero operands, nonfinite operands, out-of-range exact products, other formats, and
other rounding modes. The reference itself is not removed or redefined. -/
def mulWithLean : (f : BinaryFormat) → Context → Word f → Word f → Result f
  | .binary32, cfg, a, b =>
    let a32 : F32 := a
    let b32 : F32 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite32 a32 then
        if hb : NonzeroFinite32 b32 then
          if absQ (finiteValue32 a32 * finiteValue32 b32) ≤ fp32.maxFinite then
            nativeMulResult32 cfg a32 b32 ha hb
          else mul .binary32 cfg a b
        else mul .binary32 cfg a b
      else mul .binary32 cfg a b
    else mul .binary32 cfg a b
  | .binary16, cfg, a, b => mul .binary16 cfg a b
  | .binary64, cfg, a, b =>
    let a64 : F64 := a
    let b64 : F64 := b
    if cfg.mode = .nearestEven then
      if ha : NonzeroFinite64 a64 then
        if hb : NonzeroFinite64 b64 then
          if absQ (finiteValue64 a64 * finiteValue64 b64) ≤ fp64.maxFinite then
            nativeMulResult64 cfg a64 b64 ha hb
          else mul .binary64 cfg a b
        else mul .binary64 cfg a b
      else mul .binary64 cfg a b
    else mul .binary64 cfg a b

theorem mulWithLean_native (cfg : Context) (a b : F32)
    (hm : cfg.mode = .nearestEven) (ha : NonzeroFinite32 a) (hb : NonzeroFinite32 b)
    (hr : absQ (finiteValue32 a * finiteValue32 b) ≤ fp32.maxFinite) :
    mulWithLean .binary32 cfg a b = nativeMulResult32 cfg a b ha hb := by
  simp only [mulWithLean, hm, ha, hb, hr, ↓reduceIte, ↓reduceDIte]

/-- Total public-contract preservation, including every fallback case. -/
theorem mulWithLean_eq (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    mulWithLean f cfg a b = mul f cfg a b := by
  cases f with
  | binary16 => rfl
  | binary32 =>
    simp only [mulWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeMulResult32_eq _ _ _ ‹_› ‹_› ‹_› ‹_›
  | binary64 =>
    simp only [mulWithLean]
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    split <;> (try rfl)
    exact nativeMulResult64_eq _ _ _ ‹_› ‹_› ‹_› ‹_›

theorem mulWithLean_correct (f : BinaryFormat) (cfg : Context) (a b : Word f) :
    MulSpec f cfg (decode f a) (decode f b) (mulWithLean f cfg a b) := by
  rw [mulWithLean_eq]
  exact mul_correct f cfg a b

end TensorCore.IEEE
