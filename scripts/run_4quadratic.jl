
using AbstractAlgebra
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC
names = ["α1","β1","α2","β2","α3","β3","α4","β4","α","β"]
Rp, v = polynomial_ring(QQ, names); F = fraction_field(Rp); const T = elem_type(F)
hasmethod(isless, Tuple{T,T}) || (Base.isless(a::T, b::T) = isless(string(a), string(b)))
inp = CharacterizationInput([F.(v[2i-1:2i]) for i in 1:4], F.(v[9:10]))
t = @elapsed r = run_characterization(inp; verbose=true)
bysize = Dict{Int,Int}(); for S in keys(r.all_systems); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
println("four quadratic (generic): LHS=", length(r.L), " nonempty=", length(r.all_systems), " by size ", sort(collect(bysize)),
        " closed=", length(r.closed), " characteristics=", length(r.orbits), " max #eq=", maximum(length, keys(r.all_systems)), " [", round(t; digits=1), " s]")
write_report("report_4quadratic_generic.md", r, inp; title="Four mutually commuting {α_i,β_i}-quadratic matrices, {α,β}-quadratic combination — generic parameters")
# dump systems for comparison with the DAS notebook: patterns as symbol names, components as strings
open("ours_4quad.tsv", "w") do io
    for (S, sol) in r.all_systems
        println(io, join(["[" * join(string.(r.L[i]), ",") * "]" for i in S], ";"), "\t",
                join(["[" * join([join(string.(row), ",") for row in a.rows], ";;") * "]" for a in sol], "@"))
    end
end
println("maxrss MiB: ", round(Sys.maxrss()/2^20; digits=1))
