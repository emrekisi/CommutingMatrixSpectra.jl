# CommutingMatrixSpectra.jl

Julia code and complete outputs for the characterization of the spectrum of linear combinations
X = c₁X₁ + ⋯ + c_mX_m of mutually commuting diagonalizable matrices, including the **overdetermined
systems** (block structures with more than m blocks) that the algorithm of
Kişi, Sarduvan, Özdemir & Kalaycı, *Spec. Matrices* 9 (2021) 305–320, did not treat.

No package dependencies (exact `Rational` arithmetic and a built-in Q(ω) field type); the symbolic
problems (quadratic / cubic matrices with parameters) use AbstractAlgebra.jl for the closed forms.

## Layout

```
src/        engine.jl (modules TripotentLC, Streamed, Pooled, GroupStream), fields.jl (Q(ω)),
            theorems.jl (LaTeX theorem items), groups_writer.jl ("n-th group" listings)
scripts/    drivers used to produce every file in results/
results/    complete outputs, one directory per problem (see below)
test/       regression tests:  julia -t auto test/runtests.jl
benchmarks/ classical multi-RHS RREF vs. intersection (k ≤ m)
```

## Results (one file per problem, "n-th group" format)

Each `groups_*.txt` lists every characteristic (= orbit of closed systems under permutations and unit
scalings X_i → uX_i) as a numbered group: the representative system (set of eigenvalue patterns), its
solution set, and all member systems with their solutions. `thm_*.tex` are the theorem items (block form).

| directory | problem | LHS | solvable systems | closed | groups |
|---|---|---|---|---|---|
| results/two_cubic | 2 cubic (symbolic) | 9 | 45 | 45 | 45 |
| results/two_quadripotent | 2 quadripotent | 5 | 15 | 15 | 5 |
| results/three_tripotent | 3 tripotent | 13 | 1 899 | 582 | 53 |
| results/four_involutive | 4 involutive | 8 | 254 | 254 | 14 |
| results/three_quadratic | 3 quadratic (symbolic) | 8 | 98 | 98 | 98 |
| results/three_cubic | 3 cubic (symbolic) | 27 | 3 438 | 3 438 | 3 438 |
| results/three_quadripotent | 3 quadripotent | 21 | 14 779 | 3 367 | 103 |
| results/four_quadratic | 4 quadratic (symbolic) | 16 | 3 572 | 2 612 | 2 612 |
| results/four_tripotent | 4 tripotent | 40 | 279 192 024 | 415 916 | 3 058 |

The [comparison with the 2021 outputs](results/comparison_with_2021_outputs/das_comparison.md)
compares the paper's Mathematica outputs with these results system by system.
The [benchmark report](results/benchmarks/bench_classical_vs_intersection.md) compares classical
multiple-right-hand-side RREF with intersection; `results/benchmarks/` also holds timings and
the five-tripotent feasibility run.

## Usage

```julia
include("src/CommutingMatrixSpectra.jl"); using .CommutingMatrixSpectra
const CMS = CommutingMatrixSpectra
inp = CMS.problem([CMS.TRIPOTENT, CMS.TRIPOTENT, CMS.TRIPOTENT], CMS.TRIPOTENT)
r = run_characterization(inp)            # start Julia with  -t auto
write_report("three_tripotent.md", r, inp; title = "Three commuting tripotent matrices")
```
See `scripts/` for the group listings (`gen_groups.jl`), the theorem items (`gen_theorems.jl`),
the streamed four-tripotent run (`gen_groups4.jl`), the count of new four-tripotent characteristics
(`count_new_4tripotent.jl`) and the symbolic problems (`symbolic_closed_forms.jl`, `gen_cubic_thm.jl`,
`run_3quadratic.jl`, `run_4quadratic.jl`, `cubic.jl`). Every script loads the sources through
`scripts/common.jl` (paths relative to the repository), so it can be run from any directory:

```
julia -t 12 scripts/run3.jl
julia --project=scripts/symbolic -e 'using Pkg; Pkg.instantiate()'    # once; AbstractAlgebra for the symbolic scripts
julia --project=scripts/symbolic -t 12 scripts/gen_cubic_thm.jl
julia test/runtests.jl
```

`Result.exhaustive` is `false` when a run was cut by `max_level`; reports written from such a result
carry a PARTIAL warning. The pattern matrices in `results/theorems/*.tex` list, with each row λ, also
its unit multiples (−λ for tripotent/involutive problems; ωλ, ω²λ for quadripotent problems).

`literature/<year - paper title>/`: the free-target variant of the algorithm (unknowns (a1,a2,p3,q3), `scripts/free_target.jl`) applied to the problems of Petik–Özdemir–Gökmen (2022) and Demirkol–Ünlütürk (2025), with item-by-item comparison (`comparison.md` in each folder; method notes in `literature/README.md`).

Author: Emre Kişi (Sakarya University). License: MIT.
