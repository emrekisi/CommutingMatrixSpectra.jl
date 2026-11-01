
# cubic.jl — Problem 1 of Kişi et al. (2021): cubicity of c₁X₁ + c₂X₂ for commuting
# {α_i,β_i,γ_i}-cubic X_i, target {α,β,γ}-cubic.  Scalars = rational functions over Q in the
# nine symbolic parameters (AbstractAlgebra.jl fraction field); zero tests are polynomial
# identities, so the output is the GENERIC characterization + the exceptional parameter set.
using AbstractAlgebra
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC
const AA = AbstractAlgebra

Rp, (α1, β1, γ1, α2, β2, γ2, α, β, γ) = polynomial_ring(QQ, ["α1", "β1", "γ1", "α2", "β2", "γ2", "α", "β", "γ"])
F = fraction_field(Rp)
const T = elem_type(F)
const P = elem_type(Rp)
# the engine sorts canonical RREF rows and unit candidates: any total order consistent with == works
if !hasmethod(isless, Tuple{T, T})
    Base.isless(a::T, b::T) = isless(string(a), string(b))
end
println("hash defined: ", hasmethod(hash, Tuple{T, UInt}), "   isless defined: ", hasmethod(isless, Tuple{T, T}))

σ1 = F.([α1, β1, γ1]); σ2 = F.([α2, β2, γ2]); σ = F.([α, β, γ])
inp = CharacterizationInput([σ1, σ2], σ)
println("unit group (generic parameters): ", TripotentLC.unit_group(inp))
t = @elapsed r = run_characterization(inp; verbose=true)
println("two cubic matrices: LHS=", length(r.L), " nonempty=", length(r.all_systems), " closed=", length(r.closed),
        " characteristics=", length(r.orbits), "  max #eq=", maximum(length, keys(r.all_systems)), "  [", round(t; digits=1), " s]")

# --- compare with Theorem 4 (a13): S = {(α1,α2),(β1,β2)}
L = r.L
i1 = findfirst(==(F.([α1, α2])), L); i2 = findfirst(==(F.([β1, β2])), L)
S = sort([i1, i2]); sol = r.all_systems[S]
println("\n(a13) system ", S, " = {(α1,α2),(β1,β2)}: ", length(sol), " point solutions, e.g.")
for a in Iterators.take(sort(collect(sol); by = x -> string(x.rows)), 3)
    c = [a.rows[j][3] for j in 1:2]
    println("   c = (", c[1], ",  ", c[2], ")")
end
# Theorem 4 (a13), first listed point for μ = (α, α):  c = ((−α2α+αβ2)/(α1β2−α2β1), (α1α−αβ1)/(α1β2−α2β1))
c_paper = [(-α2*α + α*β2) // (α1*β2 - α2*β1), (α1*α - α*β1) // (α1*β2 - α2*β1)]
found = any(a -> [a.rows[j][3] for j in 1:2] == c_paper, sol)
println("paper's (a13) first point reproduced exactly: ", found)

# --- exceptional parameter set --------------------------------------------------------
# (i) pivot conditions: 2×2 determinants of every pair of LHS rows (assumed ≠ 0 generically)
normalize(p::P) = (lc = leading_coefficient(p); iszero(lc) ? p : divexact(p, lc))
pivots = Set{P}()
for i in 1:length(L), j in i+1:length(L)
    d = numerator(L[i][1] * L[j][2] - L[i][2] * L[j][1])
    iszero(d) || push!(pivots, normalize(d))
end
# (ii) consistency conditions: a third equation λ·c = μ at a point c of a 2-system holds only on V(num(λ·c − μ))
cons = Set{P}()
for (S, sol) in r.all_systems
    length(S) == 2 || continue
    for a in sol
        c = [a.rows[j][3] for j in 1:2]
        for k in 1:length(L)
            k in S && continue
            for μ in σ
                e = L[k][1] * c[1] + L[k][2] * c[2] - μ
                iszero(e) && error("unexpected generic 3-equation solution")
                push!(cons, normalize(numerator(e)))
            end
        end
    end
end
degs(Sx) = (d = Dict{Int,Int}(); for p in Sx; d[total_degree(p)] = get(d, total_degree(p), 0) + 1; end; sort(collect(d)))
println("\nexceptional set: ", length(pivots), " pivot polynomials (degrees ", degs(pivots), "), ",
        length(cons), " consistency polynomials (degrees ", degs(cons), ")")
println("examples of pivot polynomials: ", join(string.(Iterators.take(sort(collect(pivots); by=string), 4)), " ; "))
println("examples of consistency polynomials: ", join(string.(Iterators.take(sort(collect(cons); by=string), 3)), " ; "))
write_report("report_2cubic_generic.md", r, inp; title="Two commuting {α_i,β_i,γ_i}-cubic matrices, {α,β,γ}-cubic combination — generic parameters (exact rational-function arithmetic)")
open("exceptional_2cubic.txt", "w") do io
    println(io, "# pivot polynomials (assumed nonzero)"); foreach(p -> println(io, p), sort(collect(pivots); by=string))
    println(io, "\n# consistency polynomials (a third block is possible only on their zero sets)"); foreach(p -> println(io, p), sort(collect(cons); by=string))
end
println("maxrss MiB: ", round(Sys.maxrss()/2^20; digits=1))
