
# generic_eval.jl  <kind: quad4|cubic3> <seed>  — specialise symbolic parameters at random rationals (Schwartz–Zippel),
# run the FULL overdetermined enumeration with exact Rational{Int128} arithmetic and dump systems for comparison.
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC
using Random
const Q = Rational{Int128}
kind, seed = ARGS[1], parse(Int, ARGS[2])
rng = MersenneTwister(seed)
if kind == "quad4"
    names = ["α1","β1","α2","β2","α3","β3","α4","β4","α","β"]; m = 4; per = 2
else
    names = ["α1","β1","γ1","α2","β2","γ2","α3","β3","γ3","α","β","γ"]; m = 3; per = 3
end
vals = Dict(n => Q(rand(rng, 1:3000)) for n in names)
while length(unique(values(vals))) < length(names); for n in names; vals[n] = Q(rand(rng, 1:3000)); end; end
spectra = [Q[vals[names[per*(i-1)+j]] for j in 1:per] for i in 1:m]
target = Q[vals[n] for n in names[end-per+1:end]]
name_of = Dict(v => n for (n, v) in vals)
inp = CharacterizationInput(spectra, target)
t = @elapsed (L, single, allsys, _) = TripotentLC.enumerate_systems(inp; verbose=true)
bysize = Dict{Int,Int}(); for S in keys(allsys); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
println(kind, " seed=", seed, ": LHS=", length(L), " nonempty=", length(allsys), " by size ", sort(collect(bysize)), " [", round(t; digits=1), " s]")
open("vals_$(kind)_$(seed).txt", "w") do io; for n in names; println(io, n, "\t", numerator(vals[n]), "/", denominator(vals[n])); end; end
fmt(x) = string(numerator(x), "/", denominator(x))
open("ours_$(kind)_$(seed).tsv", "w") do io
    for (S, sol) in allsys
        println(io, join(["[" * join([name_of[x] for x in L[i]], ",") * "]" for i in S], ";"), "\t",
                join(["[" * join([join(fmt.(r), ",") for r in a.rows], ";;") * "]" for a in sol], "@"))
    end
end
# closure + orbits for the characteristic count (orbits trivial: distinct parameters)
r = run_characterization(inp; verbose=false)
cs = Dict{Int,Int}(); for S in keys(r.closed); cs[length(S)] = get(cs, length(S), 0) + 1; end
println("closed=", length(r.closed), " by size ", sort(collect(cs)), " characteristics=", length(r.orbits), " maxrss MiB=", round(Sys.maxrss()/2^20; digits=1))
