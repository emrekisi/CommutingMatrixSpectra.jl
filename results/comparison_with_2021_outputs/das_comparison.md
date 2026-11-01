# Comparison of the 2021 DAS (Mathematica) outputs with the complete characterization

Source: the five notebooks cited in the data availability statement of Kişi–Sarduvan–Özdemir–Kalaycı (2021)
(figshare 10.6084/m9.figshare.14572713.v1).
The notebooks were parsed as streams (system number, left-hand-side matrix, RREF, and solution matrix).
The comparison was performed **at the solution-set level**, using canonical sets of RREF components and exact arithmetic.
For the symbolic problems, the parameters were specialized at two independent random rational points with values in
1..3000 (Schwartz–Zippel). Both specializations produced the same structure; the DAS expressions were evaluated
at the same points and compared for exact equality.

| Problem | DAS systems | Solvable in DAS | Solvable in our results (k ≤ m) | Exact matches | Extra / missing in DAS | New in our results (k > m) |
|---|---|---|---|---|---|---|
| 3 quadratic (symbolic, 8 parameters) | 92 | 92 | 92 | 92 | — | **6** systems with four equations |
| 4 quadratic (symbolic, 10 parameters) | 2 516 | 2 492 | 2 416 (+24 empty, as in DAS) | 2 416 | **76 systems (200 columns) are invalid**: the "solutions" printed for rank-deficient systems satisfy none of their equations; the systems are generically inconsistent | **912** systems with five equations + **168** with six equations → 504 new closed characteristics (2 612 total; 2 108 with ≤4 blocks) |
| 3 cubic (symbolic, 12 parameters) | 3 303 | 3 303 | 3 276 | 3 276 | **27 systems (486 columns) are invalid**: linearly dependent triples (collinear patterns such as (α₁,α₂,x), x∈{α₃,β₃,γ₃}) are generically unsolvable | **162** systems with four equations (3 438 characteristics in total) |
| 3 quadripotent (Q(ω)) | 41 727 (40 023 printed) | 40 023 | 1 531 (after ω-reduction; 42 have a zero column) | 40 023 → 1 489 distinct canonical systems, all exact matches | 3 276 DAS systems contain a row and its ω-multiple (redundant); 42 systems with a zero column were deleted in DAS step 6 | 13 248 systems (k = 4…9) → 103 characteristics in total (98 with Qᵢ ≠ 0) |
| 4 tripotent (Q) | 102 090 (97 808 printed) | 96 344 (+1 464 empty) | 99 700 (3 356 have a zero column) | 96 344 exact matches; 1 464 empty in both | 3 356 systems with a zero column were deleted in DAS step 6 | 279 092 324 systems (k = 5…25) → 3 058 characteristics in total |

## Notes

- For the rational and Q(ω) problems (4 tripotent and 3 quadripotent), there is **complete agreement** with DAS:
  every solvable system with k ≤ m has the same solution set. The differences arise solely from the systems
  with a zero column deleted by DAS and from ω-reduction.
- For the symbolic problems, the solution matrices printed by DAS for rank-deficient systems
  (linearly dependent left-hand sides) are invalid: 76/2 516 systems for 4 quadratic matrices and
  27/3 303 systems for 3 cubic matrices. These systems have no solutions for generic parameters
  (compatibility requires a polynomial equation in the parameters).
  No such systems occur in the outputs for 2 cubic matrices (Theorem 4) or 3 quadratic matrices;
  those results are correct.
- Overdetermined systems (k > m) are outside the scope of DAS, so all characteristics obtained there are new:
  6 for 3 quadratic matrices, 504 for 4 quadratic matrices, and 162 for 3 cubic matrices.
  See the corresponding reports for 3 quadripotent and 4 tripotent matrices.
  Closed forms (rational functions) for the new characteristics of the symbolic problems will be generated
  with AbstractAlgebra only for these systems, as was done for 2 cubic matrices.
- For 2 cubic matrices, all 45 systems agree with Theorem 4; there are no overdetermined solutions
  for generic parameters. For 2 quadripotent matrices, Theorem 5 is complete.

Files: `das_summary.json`, `das_*.jsonl` (parsed notebooks), `ours_*.tsv` (our system listings),
`generic_eval.jl` (random specialization), and `vals_*_1.txt` (the parameter values used).
