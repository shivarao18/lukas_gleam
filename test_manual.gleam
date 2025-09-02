// Quick manual test to verify our math functions
import gleam/io
import gleam/int
import gleam/list
import math_utils

pub fn main() -> Nil {
  // Test sum_consecutive_squares
  let sum_3_4 = math_utils.sum_consecutive_squares(3, 2)  // 3^2 + 4^2 = 9 + 16 = 25
  io.println("3^2 + 4^2 = " <> int.to_string(sum_3_4))
  
  // Test is_perfect_square  
  let is_25_perfect = math_utils.is_perfect_square(25)  // Should be True
  io.println("Is 25 a perfect square? " <> case is_25_perfect { True -> "Yes" False -> "No" })
  
  // Test is_valid_sequence
  let is_valid = math_utils.is_valid_sequence(3, 2)  // Should be True
  io.println("Is sequence starting at 3 with length 2 valid? " <> case is_valid { True -> "Yes" False -> "No" })
  
  // Test Lucas' pyramid: 1^2 + 2^2 + ... + 24^2 = 70^2
  let lucas_sum = math_utils.sum_consecutive_squares(1, 24)
  io.println("Sum of 1^2 + 2^2 + ... + 24^2 = " <> int.to_string(lucas_sum))
  let is_lucas_perfect = math_utils.is_perfect_square(lucas_sum)
  io.println("Is Lucas sum a perfect square? " <> case is_lucas_perfect { True -> "Yes" False -> "No" })
  
  // What's the square root?
  case is_lucas_perfect {
    True -> {
      // Find the square root manually
      let candidates = [70, 69, 71, 68, 72]
      io.println("Testing candidates for square root:")
      list.each(candidates, fn(n) {
        let square = n * n
        io.println(int.to_string(n) <> "^2 = " <> int.to_string(square))
      })
    }
    False -> io.println("Not a perfect square")
  }
}
