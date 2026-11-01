
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC
σq = Eis[ω, ω^2, Eis(1), Eis(0)]
inp = CharacterizationInput([σq, σq], σq)
r = run_characterization(inp; verbose=false)
L = r.L; U = TripotentLC.unit_group(inp)
index = Dict(λ => i for (i, λ) in enumerate(L))
# permutation-only tables (no per-matrix ω-scaling), LHS still U-canonical
perm_tabs = [[index[TripotentLC.canon_unit(λ[p], U)] for λ in L] for p in ([1,2], [2,1])]
canon(S, tabs) = minimum(sort([t[i] for i in S]) for t in tabs)
full_tabs = TripotentLC.symmetry_group(inp, L)
for (name, tabs) in (("permutation only", perm_tabs), ("permutation + per-matrix ω-scaling", full_tabs))
    classes = Dict{Vector{Int},Vector{Vector{Int}}}()
    for S in keys(r.closed); push!(get!(classes, canon(S, tabs), Vector{Int}[]), S); end
    nz = [k for k in keys(classes) if all(i -> any(s -> !iszero(L[s][i]), k), 1:2)]
    println(name, ": ", length(classes), " classes (", length(nz), " with Q1,Q2 ≠ 0); by #eq: ",
            sort([(length(k), length(v)) for (k, v) in classes]))
    for k in sort(collect(keys(classes)); by=x->(length(x), x))
        println("   ", [Tuple(string.(L[i])) for i in k], "  members=", length(classes[k]))
    end
end
