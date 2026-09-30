import Lean
import TensorCoreTests

-- Export checked declaration dependencies and source ranges for the proof guide.
open Lean Elab Command

namespace ProofGraph

def moduleOf (env : Environment) (name : Name) : Option Name := do
  let index ← env.getModuleIdxFor? name
  env.header.moduleNames[index.toNat]?

def bodyConstants : ConstantInfo → Array Name
  | .defnInfo info => info.value.getUsedConstants
  | .thmInfo info => info.value.getUsedConstants
  | .opaqueInfo info => info.value.getUsedConstants
  | _ => #[]

def position (p : Position) : Json := toJson #[p.line, p.column]

def range (r : DeclarationRange) : Json :=
  Json.mkObj [("start", position r.pos), ("end", position r.endPos)]

elab "export_proof_graph" : command => do
  let env ← getEnv
  let names := env.constants.fold (init := (#[] : Array Name)) fun acc name _ =>
    if (moduleOf env name).any (fun m => m.getRoot == `TensorCore || m.getRoot == `TensorCoreTests) then
      acc.push name
    else acc
  let mut entries : Array Json := #[]
  for name in names.qsort (fun a b => a.toString < b.toString) do
    let some info := env.find? name | continue
    let mut deps : NameSet := {}
    for dep in info.type.getUsedConstants ++ bodyConstants info do
      deps := deps.insert dep
    let mut fields := [("name", toJson name.toString),
      ("module", toJson ((moduleOf env name).getD .anonymous).toString),
      ("theorem", toJson info.isTheorem),
      ("dependencies", toJson ((deps.toArray.qsort (fun a b => a.toString < b.toString)).map Name.toString))]
    if let some ranges ← liftCoreM (findDeclarationRanges? name) then
      fields := fields ++ [("range", range ranges.range), ("selection", range ranges.selectionRange)]
    if info.isTheorem then
      let axioms ← liftCoreM (collectAxioms name)
      fields := fields ++ [("axioms", toJson ((axioms.qsort (fun a b => a.toString < b.toString)).map Name.toString))]
    entries := entries.push (Json.mkObj fields)
  liftIO <| IO.FS.createDirAll "tmp"
  liftIO <| IO.FS.writeFile "tmp/proof-dependencies.json" (Json.arr entries).compress
  logInfo m!"proof_graph: {entries.size} checked declarations exported"

end ProofGraph

export_proof_graph
