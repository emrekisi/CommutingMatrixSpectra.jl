
include("TripotentLC.jl"); include("fields.jl")
using .TripotentLC
const Q = Rational{Int64}
# 1) Complex{Rational} cannot hold ω
w = -1//2 + (3//4)im
println("Complex{Rational} test: w = ", w, "   w^2 + w + 1 = ", w^2 + w + 1, "  (≠ 0: not a cube root of unity)")
println("Eis test: ω = ", ω, "   ω^3 = ", ω^3, "   ω^2 + ω + 1 = ", ω^2 + ω + 1, "   ω^2 = ", ω^2)
# 2) regression: three tripotents unchanged
inp3 = TripotentLC.CharacterizationInput([Q[1, -1, 0] for _ in 1:3], Q[1, -1, 0])
r3 = nothing

# 3) two quadripotent matrices  σ ⊆ {ω, ω², 1, 0}
σq = Eis[ω, ω^2, Eis(1), Eis(0)]
inp2 = TripotentLC.CharacterizationInput([σq, σq], σq)
println("unit group U = ", TripotentLC.unit_group(inp2), "   per-matrix U_i = ", TripotentLC.coordinate_unit_groups(inp2))
r2 = TripotentLC.run_characterization(inp2; verbose=true)
println("2 quadripotent: LHS=", length(r2.L), " ", r2.L)
bysize = Dict{Int,Int}(); for S in keys(r2.all_systems); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
println("nonempty systems by size: ", sort(collect(bysize)))
println("closed systems: ", length(r2.closed), "  characteristics (orbits): ", length(r2.orbits))
TripotentLC.write_report("report_2quadripotent.md", r2, inp2; title="Two commuting quadripotent matrices (exact Q(ω) arithmetic)")
# 4) three quadripotent matrices, paper scope k ≤ 3 (41 727 systems) and growth beyond
inp3q = TripotentLC.CharacterizationInput([σq, σq, σq], σq)
L3, U3 = TripotentLC.lhs_vectors(inp3q)
println("3 quadripotent: LHS after unit halving = ", length(L3), " (paper: 63 without ω-reduction), U = ", U3)
t = @elapsed (L, single, allsys) = TripotentLC.enumerate_systems(inp3q; verbose=true, max_level=5)
println("3 quadripotent up to level 5: nonempty=", length(allsys), " in ", round(t; digits=2), " s")
