// Sequential solver for consecutive squares problem
import gleam/int
import gleam/io
import gleam/list
import math_utils

/// Find all starting points from 1 to n where k consecutive squares sum to a perfect square
/// Returns a list of valid starting points
pub fn find_solutions(n: Int, k: Int) -> List(Int) {
  // Generate list of all possible starting points from 1 to n
  let starting_points = list.range(1, n)

  // Filter to find only valid sequences
  list.filter(starting_points, fn(start) {
    math_utils.is_valid_sequence(start, k)
  })
}

/// Print solutions in the required format (one per line)
pub fn print_solutions(solutions: List(Int)) -> Nil {
  case solutions {
    [] -> Nil
    // No solutions found, print nothing
    _ -> {
      list.each(solutions, fn(start) { io.println(int.to_string(start)) })
    }
  }
}

/// Run the complete sequential algorithm and print results
pub fn solve_and_print(n: Int, k: Int) -> Nil {
  let solutions = find_solutions(n, k)
  print_solutions(solutions)
}
