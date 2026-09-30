import TensorCore.Numerics.Binary.Bijection
import TensorCore.Numerics.Binary.ConversionBounds
import TensorCore.Numerics.Binary.CorrectRounding
import TensorCore.Numerics.Binary.Defs
import TensorCore.Numerics.Binary.DirectedRounding
import TensorCore.Numerics.Binary.Encoding
import TensorCore.Numerics.Binary.MagnitudeScale
import TensorCore.Numerics.Binary.ResidualBudget
import TensorCore.Numerics.Binary.RoundOp
import TensorCore.Numerics.Binary.RoundTrip
import TensorCore.Numerics.Binary.RoundingContract
import TensorCore.Numerics.Binary.ScalarSum
import TensorCore.Numerics.Binary.SignedBijection

/-! # Generic finite binary arithmetic

Canonical and signed finite representations, encoding bijections, correctly rounded
conversions, directed rounding, and exact scalar summation for well-formed formats.
-/
