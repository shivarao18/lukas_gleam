import argv
import gleam/int
import gleam/io


pub fn main() -> Nil {
  // Assert that the result is Ok and extract the values.
  // If parse_arguments() returns an Error, the program will crash.
  let assert Ok(#(n, k)) = parse_arguments()

  // Now, n and k are available in this scope, outside the case statement.
  io.println("Searching for sequences of length " <> int.to_string(k) 
              <> " with starting points from 1 to " <> int.to_string(n))
  
  run_algorithm(n, k)
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
    _, False -> Error("k must be at least 2 (need at least 2 consecutive numbers)")
  }
}

// Placeholder for the main algorithm - will be implemented in Step 1.2
fn run_algorithm(n: Int, k: Int) -> Nil {
  io.println("Algorithm implementation coming in Step 1.2...")
  io.println("Will search for solutions where sum of " <> int.to_string(k) 
             <> " consecutive squares starting from 1 to " <> int.to_string(n)
             <> " equals a perfect square.")
}
