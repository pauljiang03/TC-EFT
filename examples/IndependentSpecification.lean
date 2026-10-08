import TensorCore.TC.Specification.Composition

open TensorCore

/-- Every encoded input of every named supported path, with rejection preserved. -/
example (path : IndependentSpec.Path) (x : BlockInput (IndependentSpec.implementationProfile path)) :
    (evalBlock x).toOption.map (fun t => t.output.bits) =
      IndependentSpec.bits (IndependentSpec.parameters path) (IndependentSpec.supportedInput path x) :=
  IndependentSpec.supported_eq_spec path x

/-- The specification-side validity condition entails success, rather than assuming it. -/
example (x : BlockInput a100BF16F32)
    (h : IndependentSpec.Valid (IndependentSpec.parametersOf a100BF16F32) (IndependentSpec.inputOf x)) :
    ∃ t, evalBlock x = .ok t ∧
      IndependentSpec.bits (IndependentSpec.parametersOf a100BF16F32) (IndependentSpec.inputOf x) = some t.output.bits :=
  IndependentSpec.valid_success x h

/-- Every intermediate encoding in an explicitly ordered schedule. -/
example (p : Profile) (c : F32) (groups : List (List (p.Word × p.Word))) :
    (runBlocks p c groups).toOption.map (fun ts => ts.map fun t => t.output.bits) =
      IndependentSpec.runGroups (IndependentSpec.parametersOf p) c groups :=
  IndependentSpec.runBlocks_eq_spec p c groups
