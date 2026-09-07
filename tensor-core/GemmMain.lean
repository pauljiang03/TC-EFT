import TensorCore.Cli.Gemm

open Lean TensorCore.Cli.Gemm

private def consume (input : IO.FS.Stream) : IO UInt32 := do
  let output ← IO.getStdout
  let errors ← IO.getStderr
  let mut lineNumber := 0
  repeat
    let line ← input.getLine
    if line.isEmpty then return 0
    lineNumber := lineNumber + 1
    unless line.trimAscii.toString.isEmpty do
      match Json.parse line >>= evaluate with
      | .ok result => output.putStrLn result.compress
      | .error message =>
        errors.putStrLn (Json.mkObj [
          ("error", toJson "invalid_request"), ("line", toJson lineNumber),
          ("message", toJson message)]).compress
        return 2
  return 0

def main (args : List String) : IO UInt32 := do
  try
    match args with
    | ["--help"] | ["-h"] =>
      IO.println "Usage: tc_gemm FILE|-\nOne GEMM request per JSONL line. See README.md and data/schemas/gemm.schema.json."
      return 0
    | ["-"] => consume (← IO.getStdin)
    | [path] =>
      let handle ← IO.FS.Handle.mk path .read
      consume (IO.FS.Stream.ofHandle handle)
    | _ =>
      (← IO.getStderr).putStrLn "Usage: tc_gemm FILE|-"
      return 2
  catch error =>
    (← IO.getStderr).putStrLn (Json.mkObj [
      ("error", toJson "io_error"), ("message", toJson error.toString)]).compress
    return 2
