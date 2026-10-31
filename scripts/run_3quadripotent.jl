
include("TripotentLC.jl"); include("fields.jl")
using .TripotentLC
σq = Eis[ω, ω^2, Eis(1), Eis(0)]
inp = TripotentLC.CharacterizationInput([σq, σq, σq], σq)
r = TripotentLC.run_characterization(inp; verbose=true)
bysize = Dict{Int,Int}(); for S in keys(r.all_systems); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
println("nonempty by size: ", sort(collect(bysize)))
cs = Dict{Int,Int}(); for S in keys(r.closed); cs[length(S)] = get(cs, length(S), 0) + 1; end
println("closed by size: ", sort(collect(cs)))
os = Dict{Int,Int}(); for S in keys(r.orbits); os[length(S)] = get(os, length(S), 0) + 1; end
println("orbits by size: ", sort(collect(os)))
nz = count(S -> all(i -> any(s -> !iszero(r.L[s][i]), S), 1:3), keys(r.orbits))
println("characteristics with all Q_i ≠ 0: ", nz, "  paper scope (k ≤ 3) systems: ", sum(v for (k, v) in bysize if k <= 3))
TripotentLC.write_report("report_3quadripotent.md", r, inp; title="Three mutually commuting quadripotent matrices (exact Q(ω) arithmetic, full overdetermined analysis)")
println("maxrss MiB: ", round(Sys.maxrss()/2^20; digits=1))
