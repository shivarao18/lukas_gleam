import argv
import boss
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/list
import worker

// Configuration
const num_workers = 60

pub fn main() {
  io.println("--- Lukas Solver ---")
  case parse_arguments() {
    Ok(#(n, k)) -> {
      let reply = process.new_subject()

      let chunk_size = int.max(1, n / { num_workers * 12 })
      //io.println("Chunk size: " <> int.to_string(chunk_size))

      // Start boss actor and get its subject
      let assert Ok(boss_subject) =
        boss.start(n, k, chunk_size, num_workers, reply)

      // Spawn workers
      list.range(1, num_workers)
      |> list.each(fn(_) {
        let _ = worker.start(boss_subject)
      })

      // Wait for boss final reply
      let assert Ok(sol) = process.receive(reply, 10_000)

      //io.println("--- Solutions ---")
      case sol {
        [] -> io.println("No solutions found.")
        _ -> list.each(sol, fn(i) { io.println(int.to_string(i)) })
      }
    }
    _ -> print_usage()
  }
}

// Parse command line arguments and validate them
// Returns Result with tuple (N, k) on success, or error message on failure
fn parse_arguments() -> Result(#(Int, Int), String) {
  case argv.load().arguments {
    // Expect exactly 2 arguments: N and k
    [n_str, k_str] -> {
      // Try to parse both arguments as integers
      case int.parse(n_str), int.parse(k_str) {
        Ok(n), Ok(k) -> validate_parameters(n, k)
        Error(_), _ -> Error("N must be a valid integer")
        _, Error(_) -> Error("k must be a valid integer")
      }
    }
    // Handle incorrect number of arguments
    [] -> Error("Missing arguments")
    [_] -> Error("Missing second argument")
    _ -> Error("Too many arguments provided")
  }
}

// Validate that the parsed parameters make mathematical sense
// N should be positive, k should be at least 2 (need at least 2 consecutive numbers)
fn validate_parameters(n: Int, k: Int) -> Result(#(Int, Int), String) {
  case n > 0, k >= 2 {
    True, True -> Ok(#(n, k))
    False, _ -> Error("N must be positive (N > 0)")
    _, False ->
      Error("k must be at least 2 (need at least 2 consecutive numbers)")
  }
}

// Print usage instructions when arguments are invalid
fn print_usage() -> Nil {
  io.println("")
  io.println("Usage: lukas N k")
  io.println("")
  io.println("  N: Upper limit for starting points (positive integer)")
  io.println("  k: Length of consecutive sequence (integer >= 2)")
  io.println("")
  io.println("Examples:")
  io.println("  lukas 3 2     # Find sequences of length 2 with start <= 3")
  io.println("  lukas 40 24   # Find sequences of length 24 with start <= 40")
  io.println("")
  io.println(
    "The program finds all k consecutive numbers starting at some point",
  )
  io.println(
    "between 1 and N, such that the sum of their squares is a perfect square.",
  )
}
