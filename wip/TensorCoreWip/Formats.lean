import TensorCore.Core.Format

namespace TensorCore

/-- FP8 layouts retained with the unresolved tensor-core candidates. -/
def e5m2 : Format := ⟨2, 5, 15⟩
def e4m3 : ValueFormat := ⟨⟨3, 4, 7⟩, .finiteTopNaN⟩
def packedE4M3 : OperandEncoding := ⟨e4m3, 0⟩

end TensorCore
