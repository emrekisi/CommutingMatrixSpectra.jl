
include("TripotentLC.jl"); using .TripotentLC
const GS = TripotentLC.GroupStream
const Q = Rational{Int64}
inp = CharacterizationInput([Q[1,-1,0] for _ in 1:5], Q[1,-1,0])
outdir = "levels5"; mkpath(outdir)
log = open("five_tripotent.log", "w")
t = @elapsed res = GS.enumerate_stream(inp; outdir, max_level=5, log, time_limit=4800)
println(log, "sizes=", res.sizes, " joins=", res.njoins, " times=", round.(res.times; digits=1), " finished=", res.finished, " total=", round(t; digits=1), " s  pool=", length(res.pool.comps), " maxrss GiB=", round(Sys.maxrss()/2^30; digits=2))
for k in 1:res.nlevels
    p = joinpath(outdir, "level_$k.bin"); isfile(p) && println(log, "level_$k.bin ", round(filesize(p)/2^20; digits=1), " MiB")
end
close(log)
