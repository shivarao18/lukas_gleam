// Mathematical utility functions for consecutive squares problem

/// Calculate the sum of squares of k consecutive integers starting from start
/// Formula: start^2 + (start+1)^2 + ... + (start+k-1)^2
pub fn sum_consecutive_squares(start: Int, k: Int) -> Int {
  // Use tail recursion for efficiency
  sum_consecutive_squares_helper(start, k, 0)
}

// Helper function for tail-recursive calculation
fn sum_consecutive_squares_helper(
  current: Int,
  remaining: Int,
  accumulator: Int,
) -> Int {
  case remaining {
    0 -> accumulator
    _ -> {
      let square = current * current
      sum_consecutive_squares_helper(
        current + 1,
        remaining - 1,
        accumulator + square,
      )
    }
  }
}

/// Check if a number is a perfect square
/// Returns True if n is a perfect square, False otherwise
pub fn is_perfect_square(n: Int) -> Bool {
  case n {
    n if n < 0 -> False
    0 -> True
    n if n > 0 -> {
      let sqrt_n = int_sqrt(n)
      sqrt_n * sqrt_n == n
    }
    _ -> False
  }
}

/// Calculate integer square root using binary search
/// Returns the largest integer whose square is <= n
fn int_sqrt(n: Int) -> Int {
  case n {
    0 -> 0
    1 -> 1
    _ -> int_sqrt_binary_search(n, 0, n)
  }
}

// Binary search to find integer square root
fn int_sqrt_binary_search(n: Int, low: Int, high: Int) -> Int {
  case low <= high {
    True -> {
      let mid = low + { high - low } / 2
      let mid_squared = mid * mid

      case mid_squared {
        // Found exact square root
        x if x == n -> mid
        // mid^2 is too large, search lower half
        x if x > n -> int_sqrt_binary_search(n, low, mid - 1)
        // mid^2 is too small, but check if mid+1 would be too large
        _ -> {
          let next_squared = { mid + 1 } * { mid + 1 }
          case next_squared > n {
            // mid is the largest integer whose square <= n
            True -> mid
            // Continue searching upper half
            False -> int_sqrt_binary_search(n, mid + 1, high)
          }
        }
      }
    }
    False -> low - 1
  }
}

/// Check if sum of k consecutive squares starting at 'start' is a perfect square
/// This is the core mathematical test for our problem
pub fn is_valid_sequence(start: Int, k: Int) -> Bool {
  let sum = sum_consecutive_squares(start, k)
  is_perfect_square(sum)
}
