
using AbstractAlgebra
include("TripotentLC.jl"); using .TripotentLC
Rp, (α1,β1,α2,β2,α3,β3,α,β) = polynomial_ring(QQ, ["α1","β1","α2","β2","α3","β3","α","β"]); F = fraction_field(Rp); const T = elem_type(F)
hasmethod(isless, Tuple{T,T}) || (Base.isless(a::T, b::T) = isless(string(a), string(b)))
inp = CharacterizationInput([F.([α1,β1]), F.([α2,β2]), F.([α3,β3])], F.([α,β]))
t = @elapsed r = run_characterization(inp; verbose=true)
bysize = Dict{Int,Int}(); for S in keys(r.all_systems); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
println("three quadratic (generic): LHS=", length(r.L), " nonempty=", length(r.all_systems), " by size ", sort(collect(bysize)),
        " closed=", length(r.closed), " characteristics=", length(r.orbits), " max #eq=", maximum(length, keys(r.all_systems)), " [", round(t; digits=1), " s]")
# notebook system 9: {(α1,α2,α3),(α1,α2,β3)} → c3 = (α-β)/(α3-β3) or (β-α)/(α3-β3), c1 + (α2/α1) c2 = ...
L = r.L; i1 = findfirst(==(F.([α1,α2,α3])), L); i2 = findfirst(==(F.([α1,α2,β3])), L)
sol = r.all_systems[sort([i1,i2])]
println("system {(α1,α2,α3),(α1,α2,β3)}: ", length(sol), " components")
for a in sol; println("   ", TripotentLC.fmt_affine(a, 3)); end
write_report("report_3quadratic_generic.md", r, inp; title="Three mutually commuting {α_i,β_i}-quadratic matrices, {α,β}-quadratic combination — generic parameters")
