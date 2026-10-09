import TensorCore.Kernels.EFT.DecodeDefs

/-! A fixed-width bitvector datapath for one Tensor Core normalization group. -/

namespace TensorCore.Datapath

open EFMachine

/-- Width of exponent arithmetic. -/
abbrev Exp := BitVec 12

/-- Carry bits for summing the K products and c: `K + 1 ≤ 2 ^ carryBits`. -/
def carryBits (path : Path) : ℕ := path.profile.products.log2 + 1

/-- An aligned term: two integer bits (products are below 4) and F = 23 + p bits after the binary point. -/
def termWidth (path : Path) : ℕ := path.alignmentBits.toNat + 2

/-- The two's complement accumulator: an aligned term's width, the carry bits and a sign bit. -/
def accWidth (path : Path) : ℕ := termWidth path + carryBits path + 1

/-- A product or c: sign, significand with `mantissaBits` bits after the binary point, and unnormalized exponent biased by 512. -/
structure Term where
  negative : Bool
  significand : BitVec 24
  mantissaBits : Grid
  biasedExp : Grid
  deriving Repr, DecidableEq

/-- Exact product of two decoded inputs; exponents add without normalizing. -/
def product (a b : Factor) : Term :=
  ⟨a.negative != b.negative, multiplySignificands a.magnitude b.magnitude,
    a.mantissaBits + b.mantissaBits, a.biasedExp + b.biasedExp⟩

def cTerm (c : Accumulator) : Term := ⟨c.negative, c.magnitude, c.mantissaBits, c.biasedExp + 256⟩

def decodeTerm (path : Path) (pair : path.profile.Word × path.profile.Word) : Option Term := do
  let a ← decodeFactor path.kind (pair.1.zeroExtend 32)
  let b ← decodeFactor path.kind (pair.2.zeroExtend 32)
  return product a b

/-- Largest unnormalized exponent of a nonzero term, raised to the profile floor. -/
def alignExp (path : Path) (ts : List Term) : Grid :=
  ts.foldl (fun e t => if t.significand == 0 then e
    else if e ≤ t.biasedExp then t.biasedExp else e) path.floor

/-- The term's magnitude truncated to the grid `2 ^ (e - 512 - F)`. -/
def Term.aligned (path : Path) (e : Grid) (t : Term) : BitVec (termWidth path) :=
  (t.significand.zeroExtend (termWidth path) <<< (path.alignmentBits - t.mantissaBits)) >>>
    (e - t.biasedExp)

def Term.signedAligned (path : Path) (e : Grid) (t : Term) : BitVec (accWidth path) :=
  let a := (t.aligned path e).zeroExtend (accWidth path)
  if t.negative then -a else a

def accumulate (path : Path) (e : Grid) (ts : List Term) : BitVec (accWidth path) :=
  ts.foldl (fun s t => s + t.signedAligned path e) 0

/-- Normalization and final truncation of an accumulator on the grid `2 ^ (e - 512 - F)`;
`none` when the value exceeds the largest finite FP32 value. -/
def normalize (s : BitVec w) (e F : Grid) : Option F32 :=
  let negative := s.msb
  let m := if negative then -s else s
  if m == 0 then some 0 else
    let e : Exp := e.zeroExtend 12
    let F : Exp := F.zeroExtend 12
    -- exponent of the leading one, biased by 512 + F
    let lead : Exp := BitVec.ofNat 12 (w - 1) - m.clz.setWidth 12 + e
    -- FP32 exponent field, 1 for subnormals
    let biased : Exp := if F + 386 ≤ lead then lead - (F + 385) else 1
    let down := biased + F + 362
    let k := if down ≤ e then m <<< (e - down) else m >>> (down - e)
    let exact := down ≤ e || k <<< (down - e) == m
    if 255 ≤ biased || (biased == 254 && k == 0xffffff && !exact) then none
    else
      let k := k.setWidth 32
      let payload := if k < 0x800000 then k else (biased.setWidth 32 <<< 23) + (k - 0x800000)
      some ((if negative then 0x80000000 else 0) + payload)

/-- One normalization group, computed with bitvector operations only. -/
def evalBlock (path : Path) (x : BlockInput path.profile) : Except ModelError F32 := do
  if x.products.length != path.profile.products then throw .wrongProductCount
  let some c := decode32Fields x.c | throw .nonfiniteInput
  let some ps := x.products.mapM (decodeTerm path) | throw .nonfiniteInput
  let ts := cTerm c :: ps
  let e := alignExp path ts
  let some bits := normalize (accumulate path e ts) e path.alignmentBits
    | throw .accumulatorOutOfRange
  return bits

end TensorCore.Datapath
