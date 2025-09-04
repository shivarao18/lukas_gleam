import gleam/list

/// Closed-form prefix sum of squares 1² + … + n².
/// Formula: n(n+1)(2n+1)/6
pub fn prefix_sum(n: Int) -> Int {
  n * { n + 1 } * { 2 * n + 1 } / 6
}

/// Sum of squares for consecutive window `[start, start+k-1]`.
pub fn window_sum(start: Int, k: Int) -> Int {
  let b = start + k - 1
  prefix_sum(b) - prefix_sum(start - 1)
}

/// Integer floor of √n (n ≥ 0).
pub fn int_sqrt(n: Int) -> Int {
  case n {
    0 -> 0
    1 -> 1
    _ -> bin_search(n, 0, n)
  }
}

fn bin_search(n: Int, low: Int, high: Int) -> Int {
  case low <= high {
    True -> {
      let mid = low + { high - low } / 2
      let sq = mid * mid
      case sq {
        x if x == n -> mid
        x if x > n -> bin_search(n, low, mid - 1)
        _ -> {
          let next_sq = { mid + 1 } * { mid + 1 }
          case next_sq > n {
            True -> mid
            False -> bin_search(n, mid + 1, high)
          }
        }
      }
    }
    False -> low - 1
  }
}

/// Perfect-square predicate.
pub fn is_square(n: Int) -> Bool {
  case n {
    n if n < 0 -> False
    0 -> True
    n -> {
      let r = int_sqrt(n)
      r * r == n
    }
  }
}

/// Find all starting indices in `[from, to]` (inclusive) where the k-length
/// window sum is a perfect square.
pub fn scan_range(from_: Int, to_: Int, k: Int) -> List(Int) {
  list.range(from_, to_)
  |> list.filter(fn(i) { is_square(window_sum(i, k)) })
}
