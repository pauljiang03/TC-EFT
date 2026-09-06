import TensorCore.Semantics.Profiles
import TensorCore.Semantics.Canonical

/-! BF16 and TF32 products with FP32 accumulation as profiles of the block semantics, with
the parameters of Accurate Models Table 3. A TF32 register word carries the 19-bit `tf19`
value above 13 zero bits; `tf32Unpack` recovers the value word for the profile. -/

namespace TensorCore

/-- BF16 products, FP32 c and output, `F = 23 + extraBits`. -/
@[implicit_reducible] def bf16Fp32Profile (K extraBits : Nat) (floor : Option Int := none) :
    Profile := ⟨bf16, K, 23 + extraBits, floor⟩

/-- TF32 values in the packed 19-bit `tf19` layout, FP32 c and output. -/
@[implicit_reducible] def tf19Fp32Profile (K extraBits : Nat) (floor : Option Int := none) :
    Profile := ⟨tf19, K, 23 + extraBits, floor⟩

@[implicit_reducible] def a100BF16F32 : Profile := bf16Fp32Profile 8 1 (some (-132))
@[implicit_reducible] def hopperBF16F32 : Profile := bf16Fp32Profile 16 2 (some (-133))
@[implicit_reducible] def a100TF32F32 : Profile := tf19Fp32Profile 4 1 (some (-132))
@[implicit_reducible] def hopperTF32WmmaF32 : Profile := tf19Fp32Profile 4 2 (some (-133))
@[implicit_reducible] def hopperTF32MmaF32 : Profile := tf19Fp32Profile 8 2 (some (-133))

/-- The thirteen low bits of a TF32 register word must be zero. -/
def tf32Padded (w : tf32Register.Word) : Bool := w.toNat % 2 ^ 13 == 0

/-- The 19 value bits of a TF32 register word. -/
def tf32Unpack (w : tf32Register.Word) : BitVec 19 := BitVec.ofNat 19 (w.toNat / 2 ^ 13)

def tf32UnpackPairs (ps : List (tf32Register.Word × tf32Register.Word)) :
    List (BitVec 19 × BitVec 19) :=
  ps.map fun (a, b) => (tf32Unpack a, tf32Unpack b)

/-- The register-word input of a TF32 descriptor as a value-word input of the profile. -/
def tf32Input {K F : Nat} {floor : Option Int}
    (x : InvocationInput (alignedInvocation tf32Register K F floor)) (extra : Nat) :
    BlockInput (tf19Fp32Profile K extra floor) :=
  ⟨tf32UnpackPairs x.products, x.c⟩

end TensorCore
