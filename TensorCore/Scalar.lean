import TensorCore.Scalar.LeanFiniteAddition

/-! # Native scalar proof support

Finite FP32 addition and its bit-level agreement with the reference rounder. These
proof dependencies support `TensorCore.Kernels.EFT.Native`; declaration namespaces
remain `TensorCore.IEEE` to preserve the existing mathematical API.
-/
