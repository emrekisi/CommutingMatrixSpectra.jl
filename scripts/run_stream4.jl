
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC
const Q = Rational{Int64}
nt = Threads.nthreads()
inp = TripotentLC.CharacterizationInput([Q[1,-1,0] for _ in 1:4], Q[1,-1,0])
log = open("stream4.log", "a")
println(log, "\n=== m=4 group-streamed, threads=$nt"); flush(log)
TripotentLC.GroupStream.run_stream(TripotentLC.CharacterizationInput([Q[1,-1,0],Q[1,-1,0]], Q[1,-1,0]); outdir="levels_warm", log=devnull)
out = TripotentLC.GroupStream.run_stream(inp; outdir="levels_m4s", log=log, time_limit=10800)
println(log, "sizes: ", out.res.sizes, "\njoins: ", out.res.njoins, "\ntimes: ", round.(out.res.times; digits=2)); flush(log)
if out.res.finished
    pool = out.res.pool; GS = TripotentLC.GroupStream
    # orbit representatives: smallest mask per orbit; sizes by #equations
    reps = sort!([ (count_ones(c), c) for c in keys(out.orbits) ])
    open("report_4tripotent_full.md", "w") do io
        println(io, "# Four mutually commuting tripotent matrices — complete characterization (all overdetermined systems, streamed)\n")
        println(io, "LHS vectors: ", length(out.res.L), "  |  nonempty systems: ", sum(out.res.sizes), "  |  closed systems: ", length(out.closed), "  |  characteristics (B4 orbits): ", length(out.orbits))
        println(io, "Nonempty systems by #equations: ", join(["$k→$(out.res.sizes[k])" for k in 1:length(out.res.sizes) if out.res.sizes[k] > 0], ", "))
        bysz = Dict{Int,Int}(); for (n, c) in reps; bysz[n] = get(bysz, n, 0) + 1; end
        println(io, "Characteristics by #equations: ", join(["$k→$(bysz[k])" for k in sort(collect(keys(bysz)))], ", "), "\n")
        println(io, "## Characteristics (one representative per orbit)\n")
        for (idx, (n, c)) in enumerate(reps)
            S = GS.mask_to_set(c); ids = out.closed[c]
            println(io, "### ($idx)  $n equation(s), orbit size $(length(out.orbits[c]))")
            println(io, "Patterns: ", join([TripotentLC.fmtλ(out.res.L[s]) for s in S], "  "))
            println(io, "Solutions:")
            for i in ids; println(io, "  - ", TripotentLC.fmt_affine(pool.comps[i], 4)); end
            println(io)
        end
    end
    println(log, "report written"); flush(log)
end
close(log)
