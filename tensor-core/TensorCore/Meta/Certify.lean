import TensorCore.Meta.Syntax
import TensorCore.Programs.CertifiedProgram

open Lean Elab Command

namespace TensorCore.Meta

syntax "tc_certify" ident ":" term "from" term "scale" term "carry" term "within" term : command
syntax "tc_certify" ident ":" term "from" term "scale" term "carry" term "within" term "using" term : command
syntax "tc_certificate" term "from" term "scale" term "carry" term "within" term : command

private def certifyCommand (name : TSyntax `ident) (program initial E L tolerance proof : TSyntax `term) :
    CommandElabM Unit := do
  let initial ← checkedInitial initial
  let savedEnv ← getEnv
  let before := (← get).messages.toList.length
  elabCommand (← `(set_option Elab.async false in
    theorem $name : TensorCore.Program.Accurate $program $initial $tolerance :=
      TensorCore.Program.staticCertificate_sound $program $E $L $initial $tolerance $proof))
  let fresh := (← get).messages.toList.drop before
  if fresh.any (·.severity == MessageSeverity.error) then
    setEnv savedEnv
    logErrorAt name "Not certified; no new accuracy theorem was registered. The concrete certificate checks ideal prefixes and an uncorrected error budget. Use tc_certificate to inspect inputConditionsPass and tolerancePass."
  else
    elabCommand (← `(#check $name))
    elabCommand (← `(#print axioms $name))

elab_rules : command
  | `(tc_certify $name:ident : $program:term from $initial:term scale $E:term carry $L:term within $tolerance:term) => do
    certifyCommand name program initial E L tolerance (← `(by decide +kernel))
  | `(tc_certify $name:ident : $program:term from $initial:term scale $E:term carry $L:term within $tolerance:term using $proof:term) =>
    certifyCommand name program initial E L tolerance proof
  | `(tc_certificate $program:term from $initial:term scale $E:term carry $L:term within $tolerance:term) => do
    let initial ← checkedInitial initial
    elabCommand (← `(#eval TensorCore.Program.certificateReport $program $E $L $initial $tolerance))

end TensorCore.Meta
