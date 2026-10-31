
include("TripotentLC.jl"); using .TripotentLC
const Q = Rational{Int64}
m = parse(Int, ARGS[1]); maxlev = parse(Int, ARGS[2]); logpath = ARGS[3]
log = open(logpath, "a")
inp = TripotentLC.CharacterizationInput([Q[1,-1,0] for _ in 1:m], Q[1,-1,0])
println(log, "\n=== m = $m tripotents, threads = ", Threads.nthreads(), ", max_level = $maxlev"); flush(log)
TripotentLC.run_characterization(TripotentLC.CharacterizationInput([Q[1,-1,0],Q[1,-1,0]], Q[1,-1,0]); verbose=false)  # compile
t = @elapsed res = TripotentLC.run_characterization(inp; max_level=maxlev, log=log)
println(log, "TOTAL wall: $(round(t; digits=2)) s"); flush(log)
if m == 4 && maxlev >= 4
    TripotentLC.write_report("report_4tripotent_lev$(maxlev).md", res, inp; title="Four mutually commuting tripotent matrices — systems with ≤ $maxlev equations")
end
close(log)
