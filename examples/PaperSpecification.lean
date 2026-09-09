-- Paper Specification for the executable examples.

import TensorCore.TC.Specification.Composition

open TensorCore

/-- Every encoded input of every named supported path, with rejection preserved. -/
example (path : PaperSpec.Path) (x : BlockInput (PaperSpec.implementationProfile path)) :
    (evalBlock x).toOption.map (fun t => t.output.bits) =
      PaperSpec.bits (PaperSpec.parameters path) (PaperSpec.supportedInput path x) :=
  PaperSpec.supported_eq_paper path x

/-- The paper-side validity condition entails success, rather than assuming it. -/
example (x : BlockInput a100BF16F32)
    (h : PaperSpec.Valid (PaperSpec.parametersOf a100BF16F32) (PaperSpec.inputOf x)) :
    ∃ t, evalBlock x = .ok t ∧
      PaperSpec.bits (PaperSpec.parametersOf a100BF16F32) (PaperSpec.inputOf x) = some t.output.bits :=
  PaperSpec.valid_success x h

/-- Every intermediate encoding in an explicitly ordered schedule. -/
example (p : Profile) (c : F32) (groups : List (List (p.Word × p.Word))) :
    (runBlocks p c groups).toOption.map (fun ts => ts.map fun t => t.output.bits) =
      PaperSpec.runGroups (PaperSpec.parametersOf p) c groups :=
  PaperSpec.runBlocks_eq_paper p c groups
