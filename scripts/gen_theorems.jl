
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC, .Theorems
const Q = Rational{Int64}
# 3 tripotent
inp3 = CharacterizationInput([Q[1,-1,0] for _ in 1:3], Q[1,-1,0]); r3 = run_characterization(inp3; verbose=false)
Theorems.write_theorem("thm_3tripotent.tex", r3, inp3; label="d", pm=true, symbol="T", pattern_units=Q[1, -1])
# 4 involutive
inp4 = CharacterizationInput([Q[1,-1] for _ in 1:4], Q[1,-1,0]); r4 = run_characterization(inp4; verbose=false)
Theorems.write_theorem("thm_4involutive.tex", r4, inp4; label="e", pm=true, symbol="T", pattern_units=Q[1, -1])
# 2 quadripotent
σq = Eis[ω, ω^2, Eis(1), Eis(0)]
inpq = CharacterizationInput([σq, σq], σq); rq = run_characterization(inpq; verbose=false)
Theorems.write_theorem("thm_2quadripotent.tex", rq, inpq; label="b", units=TripotentLC.unit_group(inpq), symbol="Q", pattern_units=TripotentLC.unit_group(inpq))
# 3 quadripotent (for the GitHub listing / counts)
inpq3 = CharacterizationInput([σq, σq, σq], σq); rq3 = run_characterization(inpq3; verbose=false)
Theorems.write_theorem("thm_3quadripotent.tex", rq3, inpq3; label="f", units=TripotentLC.unit_group(inpq3), symbol="Q", pattern_units=TripotentLC.unit_group(inpq3))
