# Project 1: Sums of Consecutive Squares - Development Plan

## **LEVEL 1: Basic Functionality**
*Goal: Implement core algorithm with proper I/O*

### Step 1.1: Project Setup & CLI
- [ ] Set up command-line argument parsing for N and k parameters
- [ ] Add input validation and error handling
- [ ] Implement proper program structure with modules

### Step 1.2: Core Algorithm
- [ ] Implement sum of consecutive squares calculation
- [ ] Implement perfect square checking function
- [ ] Create sequential solution that finds all valid starting points
- [ ] Test with examples: `lukas 3 2` and `lukas 40 24`

### Step 1.3: Output & Validation
- [ ] Format output to print first number in each sequence
- [ ] Validate against known solutions (3^2 + 4^2 = 5^2, Lucas' pyramid)
- [ ] Add basic timing measurements

---

## **LEVEL 2: Actor Model & Performance Optimization**
*Goal: Multi-threaded solution with optimal performance*

### Step 2.1: Worker-Boss Architecture
- [ ] Design worker actor to process ranges of starting points
- [ ] Design boss actor to distribute work and collect results
- [ ] Implement message types for work distribution and result collection

### Step 2.2: Work Distribution Strategy
- [ ] Implement dynamic work unit assignment
- [ ] Test different work unit sizes (10, 100, 1000, 10000)
- [ ] Measure performance with different worker counts

### Step 2.3: Performance Optimization
- [ ] Find optimal work unit size for best performance
- [ ] Optimize worker count for available CPU cores
- [ ] Benchmark `lukas 1000000 4` with timing measurements
- [ ] Achieve CPU/Real time ratio > 2.0

### Step 2.4: System Tuning
- [ ] Implement proper actor supervision
- [ ] Add graceful shutdown and resource cleanup
- [ ] Test and document largest problem size solved

---

## **LEVEL 3: Production & Bonus**
*Goal: Final polish and remote actor implementation*

### Step 3.1: Code Polish
- [ ] Clean up code structure and error handling
- [ ] Add proper logging for debugging
- [ ] Optimize memory usage and performance

### Step 3.2: Documentation
- [ ] Document optimal work unit size with explanation
- [ ] Record results for `lukas 1000000 4`
- [ ] Document CPU/Real time ratios and largest problem solved
- [ ] Complete README as per requirements

### Step 3.3: Remote Actors (Bonus)
- [ ] Implement remote worker registration and communication
- [ ] Handle network failures and worker discovery
- [ ] Test distributed setup on 2+ machines
- [ ] Solve `lukas 100000000 20` on distributed system

### Step 3.4: Bonus Delivery
- [ ] Record video demonstration
- [ ] Document distributed performance results
- [ ] Create deployment instructions

---

## **Key Deliverables**
- **Level 1:** Working sequential solution
- **Level 2:** Optimized multi-actor solution with performance metrics
- **Level 3:** Complete project with documentation + (Bonus) distributed implementation
