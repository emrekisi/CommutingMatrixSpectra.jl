# CommutingMatrixSpectra.jl

Exact, complete characterization of when a linear combination

    X = c₁X₁ + c₂X₂ + ⋯ + c_mX_m ,  c_i ≠ 0,

of mutually commuting diagonalizable matrices has its spectrum inside a prescribed set σ(X)
(tripotency of tripotents, quadripotency of quadripotents, cubicity of cubic matrices, …).
It extends the algorithm of Kişi, Sarduvan, Özdemir & Kalaycı,
*Spec. Matrices* 9 (2021) 305–320, [doi:10.1515/spma-2020-0138](https://doi.org/10.1515/spma-2020-0138),
to **overdetermined systems**, i.e. to diagonal block structures with more than *m* blocks,
which the 2021 algorithm (and the Mathematica code accompanying it) did not consider.

Pure Julia, **no package dependencies**: exact arithmetic with `Rational{Int64}` and a
10-line field type for Q(ω) (`src/fields.jl`); multithreaded; disk-streamed for large cases.

## The algorithm (hybrid)

Each eigenvalue pattern λ ∈ σ(X₁)×⋯×σ(X_m) gives one linear equation λ·c ∈ σ(X).
A *system* is a set S of such patterns; its solution set sol(S) ⊆ Cᵐ is a finite union of
affine subspaces (stored in canonical RREF form, components with some c_i ≡ 0 discarded).

| systems | method |
|---|---|
| **k ≤ m equations** (underdetermined / square) | classical multi-right-hand-side RREF: one augmented matrix `[A | B]`, all \|σ(X)\|ᵏ right-hand sides at once (the 2021 method) |
| **k > m equations** (overdetermined) | **intersection**: sol(S) = sol(S′) ∩ sol(S″) for two (k−1)-subsystems sharing a (k−2)-prefix; components intersect pairwise (point ∩ point = identity, point ∈ subspace = evaluation). Apriori pruning: an empty system kills all its supersets |

Post-processing: **closed systems** (S = cl(S), the set of all patterns satisfied by every
solution of S) are the actual characteristics; they are grouped into orbits under the symmetry
group *G = (U₁×⋯×U_m) ⋊ Sym* (per-matrix unit scalings X_i → uX_i with uσ(X_i) = σ(X_i),
e.g. ±1 for tripotents, {1, ω, ω²} for quadripotents, and permutations of matrices with equal
spectra). Left-hand sides are also reduced modulo the global unit group U (the classical
“± halving” and its ω-analogue). Every point solution is re-verified by direct matrix arithmetic.

Engines in `src/engine.jl`: `TripotentLC` (reference, in-RAM), `Pooled` (component pool,
id-list solutions), `GroupStream` (sorted level files on disk, prefix-group channel,
`Threads.@spawn` workers, single ordered writer — O(group) RAM).

## Results so far

| problem | LHS (reduced) | nonempty systems | max #eq | closed | characteristics | time |
|---|---|---|---|---|---|---|
| 3 tripotents (2021 Problem 3) | 13 | 1 899 | 9 | 582 | 53 (47 with all T_i ≠ 0) | < 0.2 s |
| 4 tripotents (2021 Table 3, #5) | 40 | 279 192 024 | 25 | 415 916 | 3 058 | 9.4 min, 1.1 GB RAM, 12 threads |
| 2 quadripotents (2021 Problem 2) | 5 (15 in 2021) | 15 | 2 | 15 | 5 | < 2 s |
| 3 quadripotents (2021 Table 3, #3) | 21 (63 in 2021) | 14 779 | 9 | 3 367 | 103 (98 with all Q_i ≠ 0) | 12 s |

See `results/*/report.md`.  For three tripotents, 18 of the 47 characteristics need ≥ 4 blocks
and are therefore absent from the 31 items of Theorem 6 in the 2021 paper.
For two quadripotents no overdetermined system is solvable, so Theorem 5 (2021) is complete.

## Usage

```julia
include("src/CommutingMatrixSpectra.jl"); using .CommutingMatrixSpectra
const CMS = CommutingMatrixSpectra
inp = CMS.problem([CMS.TRIPOTENT, CMS.TRIPOTENT, CMS.TRIPOTENT], CMS.TRIPOTENT)
r = run_characterization(inp)                       # start Julia with  -t auto  for threads
write_report("three_tripotent.md", r, inp; title = "Three commuting tripotent matrices")

inpq = CMS.problem([CMS.QUADRIPOTENT, CMS.QUADRIPOTENT], CMS.QUADRIPOTENT)   # exact Q(ω)
rq = run_characterization(inpq)
```

Large cases: `scripts/run_stream4.jl` (four tripotents, disk-streamed engine).
Tests: `julia -t auto test/runtests.jl`.

## Layout

```
src/         CommutingMatrixSpectra.jl (package), engine.jl (all engines), fields.jl (Q(ω))
test/        regression tests (counts for 3 tripotents, 2 quadripotents, Q(ω) identities)
benchmarks/  classical multi-RHS RREF vs intersection (k ≤ m), timing/allocation/op counts
scripts/     drivers used for the reported runs
results/     machine-generated characterizations and logs
docs/        notes (comparison with the 2018 thesis groups, …)
paper/       outline of the LAA manuscript
```

## Status / roadmap

- [x] intersection engine, closure, symmetry orbits, verification (all levels)
- [x] Q(ω) field, unit-group reduction (ω-halving), 2 and 3 quadripotents
- [ ] hybrid engine: classical multi-RHS RREF for levels k ≤ m inside `GroupStream`
- [ ] {α,β,γ}-cubic matrices (symbolic parameters) — see `docs/cubic.md`
- [ ] 4 quadripotents (85 reduced LHS vs 255), 5 tripotents (121 LHS): feasibility limits

## Author

Emre Kişi (Department of Mathematics, Sakarya University). License: MIT.
