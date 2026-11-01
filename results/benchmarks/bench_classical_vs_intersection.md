# Classical multiple-right-hand-side RREF vs. intersection — systems with k ≤ m (underdetermined and square)

Environment: Python 3 / `fractions.Fraction`, single thread (the same language and data structures for both
methods; the measurements will be repeated in Julia when network access is available).
Both methods use the same canonical component representation (RREF rows), and their solution sets
were compared system by system.

| Problem | Systems | Solvable | Identical solutions? | Classical time | Intersection time | Classical memory | Intersection memory | Scalar operations (classical) | Scalar operations (intersection) | RHS columns |
|---|---|---|---|---|---|---|---|---|---|---|
| 3 tripotent, k ≤ 3 | 377 | 371 | True | 0.52 s | 2.45 s | 1.6 MB | 2.4 MB | 43,830 | 237,832 | 8,463 |
| 4 tripotent, k ≤ 3 | 10700 | 10688 | True | 21.7 s | 148.1 s | 92 MB | 157 MB | 1,553,012 | 14,754,530 | 273,900 |

Interpretation:

- At levels k ≤ m, the classical method is faster by factors of 4.7× (m=3) and 6.8× (m=4),
  uses 5.4× and 9.5× fewer scalar operations, and requires less memory.
  Intersection computes a separate RREF for every pair of positive-dimensional components
  (e.g. 6×6 = 36 pairs of lines), most of which are inconsistent. The classical method reduces
  the k rows once and eliminates inconsistent RHS columns within the same reduction at no additional cost.
- The solution sets are exactly equal (H4 verified).
- Recommendation for the hybrid implementation in the paper and package: use classical multiple-RHS RREF
  for k ≤ m, writing components directly in canonical form, and intersection for k > m, where point components
  can be compared by identity without RREF. This retains the shared data structures, pruning, and
  closure/grouping machinery; only the generation of the first m levels changes.

> The Python measurements above are **preliminary**; the main experiment is the Julia study below.

## Julia measurements (main experiment — 31 October 2026)

Environment: Julia 1.13.3, **single thread**, exact `Rational{Int64}` arithmetic, Windows,
with each method run in a **separate process**. Compilation was excluded through a warm-up run;
peak memory is the process's `Sys.maxrss()` value. Code: `bench_classical.jl`.

- **Classical:** the 2021 algorithm. For each k-element subset S (k ≤ m), the coefficient matrix A (k×m)
  and **all 3ᵏ RHS columns are reduced together in one augmented matrix** [A | B] (multiple-RHS RREF).
  Components are extracted from the consistent columns.
- **Intersection:** `TripotentLC.enumerate_systems`. A level-k system is obtained by intersecting,
  component by component, the solution sets of two (k−1)-systems with a common (k−2)-prefix
  (stacked RREF). No k-equation system is solved directly.
- **ops** counts scalar field operations in the elimination kernel (inversion, multiplication, subtraction).
  For the intersection method, the count was obtained by replaying every pairwise component intersection
  performed during the computation.

| Scale | Systems / solvable | Components | Time: classical / intersection | Total allocated memory | Peak RSS | ops: classical / intersection | ops ratio |
|---|---|---|---|---|---|---|---|
| m=3  k≤3 | 377 / 371 | 3388 | 14.4 ms / 8.4 ms | 16 / 10 MiB | 241 / 315 MiB | 90 244 / 420 676 | 4.7× |
| m=4  k≤3 | 10700 / 10688 | 186916 | 765.0 ms / 627.0 ms | 598 / 534 MiB | 438 / 564 MiB | 3 118 366 / 26 150 919 | 8.4× |
| m=4  k≤4 | 102090 / 99700 | 2859416 | 25672.1 ms / 47819.5 ms | 18592 / 39450 MiB | 3880 / 7826 MiB | 144 746 556 / 1 809 173 345 | 12.5× |

Verification: for m=4 and k≤4, the solution sets (canonical sets of RREF components) are **exactly equal**
for all 99700 solvable systems, with 0 mismatches. Equality was also checked separately for m=3
and for m=4 with k≤3.

### Interpretation

1. **Operation count:** the classical method uses 4.7× (m=3) to 12.5× (m=4, k=4) fewer operations.
   The cost of intersection grows with |sol(A)|·|sol(B)| pairwise intersections. For m=4, a three-equation
   system may have up to 27 components, requiring 729 small RREF computations for a single system.
2. **Time:** the timing gap is much smaller than the operation-count gap. For k ≤ 3, intersection is
   **faster** (8.4 ms vs. 14.4 ms; 0.63 s vs. 0.77 s). For k = m = 4, the classical method is 1.9× faster
   (25.7 s vs. 47.8 s). The classical method spends its time constructing 3ᵏ RHS columns and extracting
   solutions from 7.7 million columns (memory allocation), rather than on arithmetic. The intersection
   method spends its time on `Set{Affine}` hashing and equality checks.
3. **Memory:** comparable for k ≤ 3. For k = 4, intersection has twice the peak RSS (7.8 GB vs. 3.9 GB).
   These measurements concern the in-memory reference implementation. The production engine
   (GroupStream: component pool and disk streaming) performs the same computation with a constant
   1.1 GB memory footprint (see `stream4.log`).
4. The 5–7× gap in the preliminary Python measurements falls to 0.6–1.9× in Julia. In Python,
   the object overhead of `fractions.Fraction` disproportionately penalized the many small RREF
   computations required by pairwise intersections.

### Implications for the paper

- For k ≤ m (underdetermined/square systems), classical multiple-RHS RREF has a clear advantage in
  operation count, but a time advantage only when k = m. For k > m (overdetermined systems),
  intersection is the only approach: the classical method requires 2^|L| subsets and 3ᵏ RHS columns
  for each subset.
- Proposed **hybrid engine:** generate levels k ≤ m with classical RREF, storing the components
  in the pool, and levels k > m by intersection (point-identifier equality / subspace evaluation).
  This retains the simplicity of a shared approach and the O(group size) memory profile.
