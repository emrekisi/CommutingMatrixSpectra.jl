
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC, .Theorems, .Groups
using .TripotentLC: Affine
const GS = TripotentLC.GroupStream
const Q = Rational{Int64}
inp = CharacterizationInput([Q[1,-1,0] for _ in 1:4], Q[1,-1,0])
outdir = "levels4"; mkpath(outdir)
log = open("groups4_run.log", "w")
out = GS.run_stream(inp; outdir, log)
close(log)
res = out.res; L = res.L; m = 4; pool = res.pool
sol_of(S) = Set{Affine{Q}}(pool.comps[i] for i in out.closed[mask_of(S)])
mask_of(S) = (msk = UInt64(0); for s in S; msk |= UInt64(1) << (s-1); end; msk)
# groups: canonical mask -> member masks
gs = []
for (cm, members) in out.orbits
    rep = GS.mask_to_set(cm); mem = [GS.mask_to_set(x) for x in members]
    push!(gs, (rep, mem, sol_of, 0))      # minimal generating set not computed for the 4-tripotent listing
end
pos(λ) = [findfirst(==(λ[i]), inp.spectra[i]) for i in 1:m]
sort!(gs; by=x -> (any(i -> all(s -> iszero(L[s][i]), x[1]), 1:m), length(x[1]), sort([pos(L[s]) for s in x[1]])))
# write in parts by number of blocks (file size)
parts = Dict{Int,Vector{Any}}(); for g in gs; push!(get!(parts, length(g[1]), Any[]), g); end
total = 0
for k in sort(collect(keys(parts)))
    path = "groups_4tripotent_blocks$(lpad(k,2,'0')).txt"
    Groups.write_groups(path, "Tripotency of linear combinations of four mutually commuting tripotent matrices — complete characterization, characteristics with $k blocks", L, m, parts[k])
    global total += filesize(path)
    println(path, ": ", length(parts[k]), " groups, ", sum(length(g[2]) for g in parts[k]), " closed systems, ", round(filesize(path)/2^20; digits=1), " MiB")
end
println("total ", round(total/2^20; digits=1), " MiB; groups=", length(gs), " closed=", length(out.closed))
