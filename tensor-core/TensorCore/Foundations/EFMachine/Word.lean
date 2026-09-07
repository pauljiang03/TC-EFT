import TensorCore.Foundations.EFMachine.BitScan

/-! Fixed-width dyadics for the complete finite-input TC-EFT. A magnitude word has
576 bits (nine 64-bit limbs), on the common grid 2^-272. This grid includes every
finite FP16/BF16/TF32 product and FP32 value. Signs are separate: all shifts truncate
magnitudes. The executable definitions in this module use only bounded words and
Boolean operations; the integer/rational projections are specification functions.
-/

namespace TensorCore.EFMachine

abbrev Magnitude := BitVec 576
abbrev Grid := BitVec 10

structure Word where
  negative : Bool
  magnitude : Magnitude
  deriving Repr, DecidableEq

def Word.zero : Word := ⟨false, 0⟩

/-- Mathematical interpretation; never used to execute the bounded procedure. -/
def Word.coefficient (x : Word) : Int :=
  if x.negative then -(x.magnitude.toNat : Int) else x.magnitude.toNat

def Word.value (x : Word) : Rat := (x.coefficient : Rat) * pow2 (-272)

def Word.neg (x : Word) : Word := ⟨!x.negative, x.magnitude⟩

/-- Exact signed addition, rejecting unsigned magnitude overflow. Opposite signs
use an ordered subtraction, so neither subtraction can borrow. -/
def Word.add (x y : Word) : Option Word :=
  if x.negative == y.negative then
    let m := x.magnitude + y.magnitude
    if m < x.magnitude then none else some ⟨x.negative, m⟩
  else if y.magnitude ≤ x.magnitude then
    some ⟨x.negative, x.magnitude - y.magnitude⟩
  else some ⟨y.negative, y.magnitude - x.magnitude⟩

def Word.sub (x y : Word) : Option Word := x.add y.neg

/-- The order is explicit; each accepted suffix is represented by a fixed word. -/
def sumWords : List Word → Option Word
  | [] => some Word.zero
  | x :: xs => do x.add (← sumWords xs)

structure WordSplit where
  coarse : Word
  low : Word
  deriving Repr, DecidableEq

/-- Quotient/remainder extraction at 2^(grid-272). Check the full ten-bit gap
before shifting: narrowing a gap such as 256 to eight bits would lose the term. -/
def Word.split (x : Word) (grid : Grid) : WordSplit :=
  if grid ≥ 576 then ⟨⟨x.negative, 0⟩, x⟩
  else
    let m := (x.magnitude >>> grid) <<< grid
    ⟨⟨x.negative, m⟩, ⟨x.negative, x.magnitude - m⟩⟩

/-- Largest finite FP32 magnitude in units of the common dyadic grid. -/
def maxMagnitude32 : Magnitude := (16777215 : Magnitude) <<< 376

/-- The output quantum in common-grid units, including subnormal and zero words. -/
def outputGrid (b : F32) : Grid :=
  let e := ((b >>> 23).setWidth 8).zeroExtend 10
  if e == 0 then 123 else e + 122

/-- Positive FP32 conversion grid, using at most ten leading-support probes. -/
def roundingGrid (m : Magnitude) : Magnitude :=
  let length := (576 : Magnitude) - leadingZeros m
  if length ≤ 147 then 123 else length - 24

def roundingCoefficient (m g : Magnitude) : Magnitude :=
  let k := m >>> g
  let r := m - (k <<< g)
  let half := (1 : Magnitude) <<< (g - 1)
  if r > half || (r == half && (k &&& 1) == 1) then k + 1 else k

def encodeAtGrid (negative : Bool) (g k : Magnitude) : F32 :=
  let payload := if k < 8388608 then k else ((g - 122) <<< 23) + (k - 8388608)
  (if negative then (0x80000000 : F32) else 0) + payload.setWidth 32

def encodeRounded (negative : Bool) (g k : Magnitude) : F32 :=
  let (g, k) := if k == 16777216 then (g + 1, k >>> 1) else (g, k)
  encodeAtGrid negative g k

/-- Direct integer nearest-even conversion to FP32. Both the discarded remainder
and its halfway threshold stay in the wide word. There is no intermediate FP64
rounding. Exact zero is +0; a negative nonzero underflow retains its sign. -/
def Word.round32 (x : Word) : Option F32 :=
  if x.magnitude > maxMagnitude32 then none
  else if x.magnitude == 0 then some 0
  else
    let g := roundingGrid x.magnitude
    some (encodeRounded x.negative g (roundingCoefficient x.magnitude g))

end TensorCore.EFMachine
