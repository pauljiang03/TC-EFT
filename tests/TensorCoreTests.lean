import TensorCore
import TensorCoreTests.EFT.BoundedEFT
import TensorCoreTests.EFT.EFT
import TensorCoreTests.EFT.EncodedEFT
import TensorCoreTests.EFT.Flowback
import TensorCoreTests.EFT.MachineSplit
import TensorCoreTests.EFT.NativeEFT
import TensorCoreTests.EFT.ScalarEFT
import TensorCoreTests.Specification.Audit
import TensorCoreTests.Specification.NegativeControls
import TensorCoreTests.TC.BinaryRounding
import TensorCoreTests.TC.CanonicalFormats
import TensorCoreTests.TC.Cases
import TensorCoreTests.TC.Composition
import TensorCoreTests.TC.DirectedBinary
import TensorCoreTests.TC.Features
import TensorCoreTests.TC.Instruction
import TensorCoreTests.TC.Monotonicity
import TensorCoreTests.TC.PublicDomains

/-! # Regression and trust checks

This separate test library imports the production library and all maintained witnesses.
`import TensorCore` does not import tests. Mathematical declaration namespaces remain
unchanged; use `tests/README.md` for the executable test walkthrough.
-/
