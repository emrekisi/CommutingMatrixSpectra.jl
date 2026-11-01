
# bench_all.jl <key> — one problem per process: counts, wall time, peak RSS (Sys.maxrss), threads
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC
using Random
const Q = Rational{Int64}
key = ARGS[1]
σq = Eis[ω, ω^2, Eis(1), Eis(0)]
function specialised(names, m, per; seed=1)
    rng = MersenneTwister(seed); QQ128 = Rational{Int128}
    vals = Dict(n => QQ128(rand(rng, 1:3000)) for n in names)
    while length(unique(values(vals))) < length(names); for n in names; vals[n] = QQ128(rand(rng, 1:3000)); end; end
    CharacterizationInput([QQ128[vals[names[per*(i-1)+j]] for j in 1:per] for i in 1:m], QQ128[vals[n] for n in names[end-per+1:end]])
end
inp = key == "3tripotent" ? CharacterizationInput([Q[1,-1,0] for _ in 1:3], Q[1,-1,0]) :
      key == "4involutive" ? CharacterizationInput([Q[1,-1] for _ in 1:4], Q[1,-1,0]) :
      key == "2quadripotent" ? CharacterizationInput([σq, σq], σq) :
      key == "3quadripotent" ? CharacterizationInput([σq, σq, σq], σq) :
      key == "2cubic" ? specialised(["α1","β1","γ1","α2","β2","γ2","α","β","γ"], 2, 3) :
      key == "3quadratic" ? specialised(["α1","β1","α2","β2","α3","β3","α","β"], 3, 2) :
      key == "4quadratic" ? specialised(["α1","β1","α2","β2","α3","β3","α4","β4","α","β"], 4, 2) :
      key == "3cubic" ? specialised(["α1","β1","γ1","α2","β2","γ2","α3","β3","γ3","α","β","γ"], 3, 3) : error(key)
# warm-up on a tiny instance (compilation)
run_characterization(CharacterizationInput([Q[1,-1] for _ in 1:2], Q[1,-1,0]); verbose=false)
GC.gc(); rss0 = Sys.maxrss()
t = @elapsed r = run_characterization(inp; verbose=false)
m = length(inp.spectra); L = r.L
nz = count(S -> all(i -> any(s -> !iszero(L[s][i]), S), 1:m), keys(r.orbits))
bysize = Dict{Int,Int}(); for S in keys(r.all_systems); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
println("{\"key\":\"$key\",\"lhs\":$(length(L)),\"nonempty\":$(length(r.all_systems)),\"closed\":$(length(r.closed)),\"orbits\":$(length(r.orbits)),\"orbits_nz\":$nz,\"maxk\":$(maximum(length, keys(r.all_systems))),\"paper_scope\":$(sum(v for (k, v) in bysize if k <= m)),\"time_s\":$(round(t; digits=2)),\"maxrss_mib\":$(round(Sys.maxrss()/2^20; digits=1)),\"threads\":$(Threads.nthreads()),\"bysize\":\"$(sort(collect(bysize)))\"}")
