import Lean
open Lean

def main : IO Unit := do
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := `TensorCore.All }] {}
  let mut roots : Array Name := #[]
  let mut publicCount := 0
  let mut ownModules : Array Name := #[]
  for m in env.header.moduleNames do
    if m == `TensorCore || (`TensorCore).isPrefixOf m then
      ownModules := ownModules.push m
  for (n, ci) in env.constants.toList do
    if ci.isTheorem then
      if let some i := env.getModuleIdxFor? n then
        let m := env.header.moduleNames[i.toNat]!
        if m == `TensorCore || (`TensorCore).isPrefixOf m then
          roots := roots.push n
          if n.getRoot == `TensorCore && !n.isInternal then
            publicCount := publicCount + 1
  for n in roots.qsort (fun a b => a.toString < b.toString) do
    IO.println n
  IO.eprintln s!"{roots.size} theorem roots, including {publicCount} public TensorCore roots, across {ownModules.size} project modules"
