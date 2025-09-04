import argv
import boss_actor
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/actor

// import solver
import worker_actor

// Main entry point for the program
// Expects two command line arguments: N (upper limit) and k (sequence length)
pub fn main() -> Nil {
  // case parse_arguments() {
  //   Ok(#(n, k)) -> {
  //     // Run the sequential algorithm and print results
  //     solver.solve_and_print(n, k)
  //   }
  //   Error(message) -> {
  //     io.println("Error: " <> message)
  //     print_usage()
  //   }
  // }
  case parse_arguments() {
    Ok(#(n, k)) -> {
      // Start boss with state (workers count will be set later)
      let chunk_size = 100
      let num_workers = { n + chunk_size - 1 } / chunk_size
      io.println("Number of workers: " <> int.to_string(num_workers))
      let client_subject = process.new_subject()

      let state =
        boss_actor.State(
          remaining: num_workers,
          results: [],
          client: client_subject,
        )

      let assert Ok(boss) =
        actor.new(state)
        |> actor.on_message(boss_actor.handle_message)
        |> actor.start

      let boss_subject = boss.data

      // Spawn workers
      list.range(0, num_workers - 1)
      |> list.each(fn(i) {
        let start = i * chunk_size + 1
        let stop = int.min({ i + 1 } * chunk_size, n)
        let assert Ok(w) =
          actor.new(Nil)
          |> actor.on_message(worker_actor.handle_message)
          |> actor.start
        process.send(w.data, worker_actor.Work(start, stop, k, boss_subject))
      })

      // Wait for results
      let assert Ok(results) = process.receive(client_subject, 5000)
      results |> list.each(fn(r) { io.println(int.to_string(r)) })
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
