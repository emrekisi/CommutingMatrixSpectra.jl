
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC
const Q = Rational{Int64}
inp = CharacterizationInput([Q[1, -1] for _ in 1:4], Q[1, -1, 0])
t = @elapsed r = run_characterization(inp; verbose=true)
bysize(d) = (c = Dict{Int,Int}(); for S in keys(d); c[length(S)] = get(c, length(S), 0) + 1; end; sort(collect(c)))
println("4 involutive: LHS=", length(r.L), " nonempty=", length(r.all_systems), " ", bysize(r.all_systems))
println("closed=", length(r.closed), " ", bysize(r.closed), "  orbits=", length(r.orbits), " ", bysize(r.orbits))
println("time ", round(t; digits=2), " s, maxrss ", round(Sys.maxrss()/2^20; digits=1), " MiB")
write_report("report_4involutive.md", r, inp; title="Four mutually commuting involutive matrices, tripotent combination — full characterization")
