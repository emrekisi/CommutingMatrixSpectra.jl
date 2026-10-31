
# symbolic_closed_forms.jl <quad4|cubic3> — structure from a random rational specialisation (exact, Rational{Int128}),
# closed forms from AbstractAlgebra's fraction field, one small symbolic RREF per solution component.
using AbstractAlgebra, Random
include("TripotentLC.jl"); include("fields.jl"); include("theorems.jl"); include("groups_writer.jl")
using .TripotentLC, .Theorems, .Groups
using .TripotentLC: Affine, rref_aug, nonzero_ok, dim
kind = ARGS[1]
const Q = Rational{Int128}
if kind == "quad4"
    names = ["α1","β1","α2","β2","α3","β3","α4","β4","α","β"]; m = 4; per = 2
    title = "Quadraticity of linear combinations of four mutually commuting {α_i,β_i}-quadratic matrices — complete characterization, generic parameters"
else
    names = ["α1","β1","γ1","α2","β2","γ2","α3","β3","γ3","α","β","γ"]; m = 3; per = 3
    title = "Cubicity of linear combinations of three mutually commuting {α_i,β_i,γ_i}-cubic matrices — complete characterization, generic parameters"
end
rng = MersenneTwister(1)
vals = Dict(n => Q(rand(rng, 1:3000)) for n in names)
while length(unique(values(vals))) < length(names); for n in names; vals[n] = Q(rand(rng, 1:3000)); end; end
spectra = [Q[vals[names[per*(i-1)+j]] for j in 1:per] for i in 1:m]; target = Q[vals[n] for n in names[end-per+1:end]]
name_of = Dict(v => n for (n, v) in vals)
inp = CharacterizationInput(spectra, target)
t_num = @elapsed r = run_characterization(inp; verbose=false)
println("numeric structure: nonempty=", length(r.all_systems), " closed=", length(r.closed), " orbits=", length(r.orbits), " [", round(t_num; digits=1), " s]")
# symbolic field
Rp, v = polynomial_ring(QQ, names); F = fraction_field(Rp); const T = elem_type(F)
hasmethod(isless, Tuple{T,T}) || (Base.isless(a::T, b::T) = isless(string(a), string(b)))
sym = Dict(names[i] => v[i] for i in eachindex(names))
symλ(λ) = T[F(sym[name_of[x]]) for x in λ]
function particular(a::Affine, m)        # a point on the component (free variables = 0)
    c = zeros(Q, m)
    for row in a.rows; j = findfirst(!iszero, @view row[1:m]); c[j] = row[m+1]; end
    c
end
symsol = Dict{Vector{Int},Set{Affine{T}}}()
const NSOLVE = Ref(0)
t_sym = @elapsed begin
    for (S, sol) in r.closed
        out = Set{Affine{T}}()
        for a in sol
            c = particular(a, m)
            rows = Vector{T}[]
            for s in S
                μ = sum(r.L[s][i] * c[i] for i in 1:m)
                μ in target || error("pattern value not in target")
                push!(rows, vcat(symλ(r.L[s]), F(sym[name_of[μ]])))
            end
            rr_ = rref_aug(rows, m); NSOLVE[] += 1
            rr_ === nothing && error("symbolically inconsistent component for S=$S")
            nonzero_ok(rr_, m) || error("symbolic component forces c_i = 0")
            push!(out, Affine(rr_))
        end
        symsol[S] = out
    end
end
println("symbolic components: ", NSOLVE[], " RREFs in ", round(t_sym; digits=1), " s")
# groups listing (trivial G: distinct parameters) with symbolic solutions
Lsym = [symλ(λ) for λ in r.L]
gs = []
for (S, members) in r.orbits
    push!(gs, (S, members, S2 -> symsol[S2], 0))
end
pos(λ) = [findfirst(==(λ[i]), inp.spectra[i]) for i in 1:m]
sort!(gs; by=x -> (length(x[1]), sort([pos(r.L[s]) for s in x[1]])))
Groups.write_groups("groups_$(kind).txt", title, Lsym, m, gs)
println("groups_$(kind).txt: ", length(gs), " groups; by blocks ", sort(collect(Dict(k => count(g -> length(g[1]) == k, gs) for k in unique(length(g[1]) for g in gs)))), "; ", round(filesize("groups_$(kind).txt")/2^20; digits=1), " MiB")
