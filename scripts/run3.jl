
include("TripotentLC.jl"); using .TripotentLC
const Q = Rational{Int64}
inp = TripotentLC.CharacterizationInput([Q[1,-1,0], Q[1,-1,0], Q[1,-1,0]], Q[1,-1,0])
println("threads = ", Threads.nthreads())
res = TripotentLC.run_characterization(inp)                     # includes compilation
println("--- second run (compiled) ---")
res = TripotentLC.run_characterization(inp; verbose=false)
for (k,v) in sort(collect(res.timings)); println("  ", k, " ", round(v, digits=3), " s"); end
TripotentLC.write_report("report_3tripotent.md", res, inp;
    title="Tripotency of c1T1+c2T2+c3T3, T_i mutually commuting tripotent — complete characterization")
println("report written")
