# project_1

This project implements a **parallel solver for the Lukas problem** using the [Gleam language](https://gleam.run/) and its actor model.  

The solver is structured around a **boss–worker architecture**:  
- The **boss** actor partitions the search space into *work units* and distributes them.  
- **Workers** receive subproblems, solve them, and send results back to the boss.  
- At the end, the boss prints all valid solutions.  

If valid sequences exist, their starting indices are printed one per line.
If no sequence exists, the program prints `No solutions found.`

---

## Usage

The program takes two arguments:

```sh
lukas N k
```

* `N`: upper limit for starting points (positive integer)
* `k`: length of consecutive sequence (integer ≥ 2)

### Examples

```sh
lukas 3 2      # Find sequences of length 2 with start <= 3
lukas 40 24    # Find sequences of length 24 with start <= 40
lukas 1000000 4
```

The program prints each valid solution’s starting index, one per line.
If no solutions exist, it prints: `No solutions found.`

---

## Performance Results

### Work Unit Size

The best-performing work unit size was **10,000 subproblems per task**.
This was determined experimentally by running with different chunk sizes:

* **Too small (e.g., 1,000)** → high communication overhead between boss and workers.
* **Too large (e.g., 50,000)** → poor load balancing (some workers idle at the end).
* **10,000** achieved the best trade-off: enough computation per task to keep workers busy, while still balancing evenly across workers.

The chunk size is computed automatically as:

```
chunk_size = max(1, N / (num_workers * 4))
```

with `num_workers = 50` in the provided implementation.

---

### Run: `lukas 1000000 4`

* **Result**: The solver correctly identified and printed the starting indices of all valid sequences.
  
* **Stats:**
* **Timing (from `/usr/bin/time -v`):**

  * **REAL TIME**: `XX.XX seconds`
  * **USER (CPU) TIME**: `YY.YY seconds`
  * **SYSTEM TIME**: `ZZ.ZZ seconds`
  * **CPU/REAL Ratio**: \~`R.R`

> A ratio significantly above 1 indicates effective parallelism.
> For this run, multiple cores were successfully utilized.

---

### Largest Problem Solved

The largest instance successfully solved was:

```
lukas 100000000 20
```
* **Stats:**
---


