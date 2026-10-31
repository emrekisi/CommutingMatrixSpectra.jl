# {α,β,γ}-cubic matrices: symbolic eigenvalues

Problem 1 of Kişi et al. (2021): X_i is {α_i, β_i, γ_i}-cubic (i = 1, 2), X = c₁X₁ + c₂X₂ must be
{α, β, γ}-cubic.  Nine *symbolic* parameters (α₁,β₁,γ₁,α₂,β₂,γ₂,α,β,γ), assumed pairwise distinct
inside each triple.  The equations  λ·c = μ  have coefficients that are *linear forms* in the
parameters; solutions are rational functions (Theorem 4 of 2021, items (a1)–(a45), e.g.
c = ((αβ₂ − α₂β)/(α₁β₂ − α₂β₁), (αβ₁ − α₁β)/(α₂β₁ − α₁β₂))).

The exact-arithmetic engine is generic in the scalar type `T`: it only needs `+ − * inv iszero == hash isless`.
Three ways to supply a `T` for rational functions:

## Option A (recommended for the article): AbstractAlgebra.jl / Nemo.jl
```julia
using AbstractAlgebra                       # pure Julia, MIT; Nemo.jl = FLINT backend, faster
R, (α1,β1,γ1,α2,β2,γ2,α,β,γ) = polynomial_ring(QQ, ["α1","β1","γ1","α2","β2","γ2","α","β","γ"])
F = fraction_field(R)                       # T = elem_type(F); has gcd-reduced canonical forms, hash, ==
inp = CharacterizationInput([F.([α1,β1,γ1]), F.([α2,β2,γ2])], F.([α,β,γ]))
```
Everything else is unchanged (`run_characterization(inp)`).  Zero tests are polynomial identities,
so the result is the **generic** characterization: valid for all parameter values outside an
exceptional algebraic set.

## Option B (no packages): built-in symbolic layer
A ~300-line sparse multivariate polynomial type `Dict{NTuple{9,Int8},Rational{Int64}}` plus
fraction-free (Bareiss) elimination.  Cramer's rule produces exactly the minors that appear in
Theorem 4 (denominators α₁β₂ − α₂β₁ etc.), so no polynomial gcd is needed for the *square*
systems; equality of two rational functions is tested by cross-multiplication (p·s − r·q ≡ 0),
which is exact without gcd.  Canonical hashing is replaced by pairwise equality (the cubic
problems are tiny: 9 LHS, 45 systems for m = 2; 27 LHS for m = 3).

## Option C (no packages, numeric-exact hybrid): specialization + reconstruction
Decide the *structure* (which systems are consistent, ranks, pivot columns) by evaluating the
parameters at random rationals of large height (Schwartz–Zippel: a nonzero polynomial of degree
≤ 4 vanishes at a random point with probability ≤ 4/|S|), then recover the closed-form solution
by Cramer's rule with symbolic minors.  Cheapest, but the correctness argument is probabilistic
unless the structural decisions are re-checked symbolically (which Option B does anyway).

## What the overdetermined analysis adds for cubic matrices
All 2-equation systems have symbolically independent rows, hence unique solutions; a third
equation imposes a *polynomial condition on the parameters*.  Generically it fails, so
**for generic parameters there are no characteristics with more than m blocks** — Theorem 4 is
complete *generically*.  The algorithm should therefore also output the **exceptional set**:
the pivot numerators used in every RREF (assumed ≠ 0) and the polynomial conditions under
which a (m+1)-th equation becomes consistent.  On each exceptional hypersurface the problem can
be re-run with the relation substituted (comprehensive / parametric linear algebra); this is
where the specialised results of the literature (tripotents = {1,−1,0}-cubic, quadratic
matrices, …) reappear as special fibres.

Decision needed: Option A gives canonical forms and gcd for free (recommended for the LAA
paper, the "no packages" constraint belongs to the student project); Option B keeps the
repository dependency-free at the price of ~300 lines and non-reduced output expressions.
