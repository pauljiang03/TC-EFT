import Lean
import TensorCore.Programs.Report

open Lean Elab Term Command

namespace TensorCore.Meta

declare_syntax_cat tcPair
syntax "(" num "," num ")" : tcPair
declare_syntax_cat tcStmt
syntax "block" str "[" tcPair,* "]" ";" : tcStmt
syntax "call" str term ";" : tcStmt
syntax "repeat" "(" term ")" "{" tcStmt* "}" : tcStmt
syntax (name := tcProgram) "tc%{" tcStmt* "}" : term

private def sourceTerm (stx : Syntax) (label : TSyntax `str) : TermElabM (TSyntax `term) := do
  let pos := (← getFileMap).toPosition (stx.getPos?.getD 0)
  let file := (← readThe Core.Context).fileName
  `(TensorCore.SourceSite.mk $(quote file) $(quote pos.line) $(quote (pos.column + 1)) $label)

private partial def expandStmts (stmts : Array (TSyntax `tcStmt)) : TermElabM (TSyntax `term) := do
  let mut body ← `(TensorCore.Program.skip)
  for stmt in stmts.reverse do
    let head ← match stmt with
      | `(tcStmt| block $label:str [$pairs:tcPair,*];) => do
        let site ← sourceTerm stmt label
        let ps ← pairs.getElems.mapM fun pair => do
          match pair with
          | `(tcPair| ($a:num, $b:num)) => `(($a, $b))
          | _ => throwErrorAt pair "Expected a pair of encoded operand literals"
        `(TensorCore.Program.block ⟨$site,
          TensorCore.BlockOperands.ofNats [$ps,*] (by decide +kernel) (by decide +kernel)⟩)
      | `(tcStmt| call $label:str $operands:term;) => do
        let site ← sourceTerm stmt label
        `(TensorCore.Program.block ⟨$site, $operands⟩)
      | `(tcStmt| repeat ($n:term) { $inner:tcStmt* }) => do
        let child ← expandStmts inner
        `(TensorCore.Program.repeat $n $child)
      | _ => throwErrorAt stmt "Unsupported tensor-core program operation"
    body ← `(TensorCore.Program.seq $head $body)
  return body

@[term_elab tcProgram] def elabProgram : TermElab := fun stx expectedType? => do
  match stx with
  | `(tc%{ $stmts:tcStmt* }) =>
    let expanded ← expandStmts stmts
    withMacroExpansion (← getRef) expanded <| elabTerm expanded expectedType?
  | _ => throwUnsupportedSyntax

/-- Apply the checked program theorem; automatic checking uses kernel reduction. -/
syntax "tc_verify" ident ":" term "from" term : command
syntax "tc_verify" ident ":" term "from" term "using" term : command

private partial def checkedInitial (initial : TSyntax `term) : CommandElabM (TSyntax `term) := do
  match initial with
  | `(($inner:term)) => checkedInitial inner
  | `($n:num) => `(TensorCore.checkedF32 $n (by decide +kernel))
  | _ => return initial

private def verifyCommand (name : TSyntax `ident) (program initial proof : TSyntax `term) :
    CommandElabM Unit := do
  let savedEnv ← getEnv
  let before := (← get).messages.toList.length
  elabCommand (← `(set_option Elab.async false in
    theorem $name : TensorCore.Program.Correct $program $initial :=
      TensorCore.Program.vc_sound $program $initial $proof))
  let fresh := (← get).messages.toList.drop before
  if fresh.any (·.severity == MessageSeverity.error) then
    setEnv savedEnv
    logErrorAt name "Verification incomplete; no new verification theorem was registered. Use tc_inspect for numerical diagnostics, or supply a proof of Program.VC with 'using'."
  else
    elabCommand (← `(#check $name))
    elabCommand (← `(#print axioms $name))

elab_rules : command
  | `(tc_verify $name:ident : $program:term from $initial:term) => do
    let initial ← checkedInitial initial
    verifyCommand name program initial (← `(by decide +kernel))
  | `(tc_verify $name:ident : $program:term from $initial:term using $proof:term) => do
    let initial ← checkedInitial initial
    verifyCommand name program initial proof

/-- Show the selected profile, complete AST, and numerical success/failure report. -/
syntax "tc_inspect" term "from" term : command
elab_rules : command
  | `(tc_inspect $program:term from $initial:term) => do
    let initial ← checkedInitial initial
    elabCommand (← `(#eval $program))
    elabCommand (← `(#eval TensorCore.Program.report $program $initial))

end TensorCore.Meta
