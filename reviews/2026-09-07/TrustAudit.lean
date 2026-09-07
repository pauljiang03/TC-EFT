import Lean
import TensorCore

open Lean Elab Command

-- Review all declarations originating in project modules, including private and
-- generated declarations, not only public theorems in one namespace.
run_cmd do
  let env ← getEnv
  let allowed : Array Name := #[``propext, ``Classical.choice, ``Quot.sound]
  let mut declarations : Nat := 0
  let mut theorems : Nat := 0
  let mut axiomatic : Nat := 0
  let mut forbidden : Array Name := #[]
  for (name, info) in env.constants.toList do
    let some idx := env.getModuleIdxFor? name | continue
    let some mod := env.header.moduleNames[idx.toNat]? | continue
    unless mod.getRoot == `TensorCore do continue
    declarations := declarations + 1
    if info.isTheorem then theorems := theorems + 1
    if let .axiomInfo _ := info then axiomatic := axiomatic + 1
    let dependencies ← liftCoreM (collectAxioms name)
    if dependencies.any (fun a => !allowed.contains a) then
      forbidden := forbidden.push name
  logInfo m!"Independent trust audit: {declarations} project declarations; {theorems} theorems including private/generated; {axiomatic} project axiom declarations"
  if declarations == 0 || theorems == 0 then
    throwError "No project declarations or theorems were audited"
  unless axiomatic == 0 do
    throwError "Project axiom declarations found: {axiomatic}"
  unless forbidden.isEmpty do
    throwError "Nonstandard axiom dependencies: {forbidden}"
  logInfo "All audited dependencies belong to propext, Classical.choice, Quot.sound."

#print axioms TensorCore.roundBinary_correct
#print axioms TensorCore.signedFiniteBinaryBijection
#print axioms TensorCore.profile_contract
#print axioms TensorCore.evalBlockMachine_eq
#print axioms TensorCore.gemmAnalysisCheck_sound
#print axioms TensorCore.entryFamilyCheck_sound
#print axioms TensorCore.nonmonotone_range_encoded
