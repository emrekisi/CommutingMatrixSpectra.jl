
using AbstractAlgebra
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC, .Theorems, .Groups
function go(inp, path, title)
    r = run_characterization(inp; verbose=false); gs = Groups.groups_from_result(r, inp)
    Groups.write_groups(path, title, r.L, length(inp.spectra), gs)
    println(path, ": ", length(gs), " groups, ", sum(length(g[2]) for g in gs), " closed systems, ", round(filesize(path)/2^20; digits=2), " MiB")
end
Rp, (α1, β1, γ1, α2, β2, γ2, α, β, γ) = polynomial_ring(QQ, ["α1","β1","γ1","α2","β2","γ2","α","β","γ"]); F = fraction_field(Rp); const T = elem_type(F)
hasmethod(isless, Tuple{T,T}) || (Base.isless(a::T, b::T) = isless(string(a), string(b)))
go(CharacterizationInput([F.([α1,β1,γ1]), F.([α2,β2,γ2])], F.([α,β,γ])), "groups_2cubic.txt", "Cubicity of linear combinations of two commuting {α_i,β_i,γ_i}-cubic matrices — generic parameters")
R2, (a1, b1, a2, b2, a3, b3, a, b) = polynomial_ring(QQ, ["α1","β1","α2","β2","α3","β3","α","β"]); F2 = fraction_field(R2); const T2 = elem_type(F2)
hasmethod(isless, Tuple{T2,T2}) || (Base.isless(x::T2, y::T2) = isless(string(x), string(y)))
go(CharacterizationInput([F2.([a1,b1]), F2.([a2,b2]), F2.([a3,b3])], F2.([a,b])), "groups_3quadratic.txt", "Quadraticity of linear combinations of three mutually commuting {α_i,β_i}-quadratic matrices — generic parameters")
