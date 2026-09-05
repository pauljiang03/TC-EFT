import TensorCore.Programs.EFT
import TensorCore.Regression.Cases

namespace TensorCore.Regression

/-- Components of Algorithm 1 on one trace: extraction exponent, low parts (c first),
overlap correction, scalar predicate, scalar-branch bits, and Algorithm 1 bits. -/
structure EftSnapshot where
  extractionExponent : Int
  lowParts : List Rat
  overlap : Rat
  scalarPredicate : Bool
  scalarBits : Option Nat
  tceftBits : Option Nat
  deriving Repr, DecidableEq

def eftSnapshot {p : Profile} (x : BlockInput p) : Except ModelError EftSnapshot := do
  let t ← evalBlock x
  return ⟨t.extractionExponent, t.lowParts, t.overlap, t.scalarPredicate,
    t.scalarCorrected.map BitVec.toNat, t.tceft.map BitVec.toNat⟩

set_option maxRecDepth 16384
set_option maxHeartbeats 4000000

/-- R2: nonzero coarse overlap with zero total residual (TC-EFT IV-A). The two small
products leave `2^-23` each below the `2^-22` extraction grid, `ε_o = 2^-22`, and the
scalar branch returns the unchanged output. -/
theorem r2_eft : eftSnapshot r2 = .ok
    ⟨-22, [0, 0, 1 / 8388608, 1 / 8388608, 0], 1 / 4194304, true,
      some 0x40300801, some 0x40300801⟩ := by decide +kernel

/-- R3: the only low part is c's `15·2^-24`; the scalar branch corrects `4107ffff` to
`41080000`. -/
theorem r3_eft : eftSnapshot r3 = .ok
    ⟨-20, [15 / 16777216, 0, 0, 0, 0], 0, true, some 0x41080000, some 0x41080000⟩ := by
  decide +kernel

/-- The TC-EFT §V-D cancellation example: output `449fbe50`, low parts `5/16384` and
`15/8192`, no overlap, and the tie resolved to `449fbe62` by the scalar branch. -/
def cancellationExample : V100Input :=
  ⟨[(0xd83d, 0x5a03), (0x5061, 0x5722), (0x444c, 0x49d5), (0x5810, 0x5976)], 0x4416cfe5⟩

theorem cancellation_eft :
    outputBits cancellationExample = .ok 0x449fbe50 ∧
    eftSnapshot cancellationExample = .ok
      ⟨-9, [5 / 16384, 0, 0, 15 / 8192, 0], 0, true, some 0x449fbe62, some 0x449fbe62⟩ := by
  decide +kernel

/-- Three products near `128` on a `2^-15` grid next to a `2^-48` product exceed the
24-bit coefficient budget on the common grid, so the predicate fails and Algorithm 1
takes the exact-dyadic branch. -/
def supportOverflow : V100Input :=
  ⟨[(0x5bff, 0x37ff), (0x5bff, 0x37ff), (0x5bff, 0x37ff), (1, 1)], 0x4e800000⟩

theorem predicate_fallback :
    outputBits supportOverflow = .ok 0x4e800000 ∧
    ((eftSnapshot supportOverflow).map fun s => (s.scalarPredicate, s.tceftBits)) =
      .ok (false, some 0x4e800003) := by decide +kernel

end TensorCore.Regression
