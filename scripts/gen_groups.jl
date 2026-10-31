
include("TripotentLC.jl"); include("fields.jl"); include("theorems.jl"); include("groups_writer.jl")
using .TripotentLC, .Theorems, .Groups
const Q = Rational{Int64}
function go(inp, path, title)
    r = run_characterization(inp; verbose=false)
    gs = Groups.groups_from_result(r, inp)
    Groups.write_groups(path, title, r.L, length(inp.spectra), gs)
    println(path, ": ", length(gs), " groups, ", sum(length(g[2]) for g in gs), " closed systems, ", round(filesize(path)/2^20; digits=2), " MiB")
end
go(CharacterizationInput([Q[1,-1,0] for _ in 1:3], Q[1,-1,0]), "groups_3tripotent.txt", "Tripotency of linear combinations of three mutually commuting tripotent matrices — complete characterization")
go(CharacterizationInput([Q[1,-1] for _ in 1:4], Q[1,-1,0]), "groups_4involutive.txt", "Tripotency of linear combinations of four mutually commuting involutive matrices — complete characterization")
σq = Eis[ω, ω^2, Eis(1), Eis(0)]
go(CharacterizationInput([σq, σq], σq), "groups_2quadripotent.txt", "Quadripotency of linear combinations of two commuting quadripotent matrices — complete characterization (ω = -1/2 + √3 i/2)")
go(CharacterizationInput([σq, σq, σq], σq), "groups_3quadripotent.txt", "Quadripotency of linear combinations of three mutually commuting quadripotent matrices — complete characterization (ω = -1/2 + √3 i/2)")
