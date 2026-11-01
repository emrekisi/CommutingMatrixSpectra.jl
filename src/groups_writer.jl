
# groups_writer.jl — "n-th group" style listings (as in the 2021 Mathematica output notebooks):
# every characteristic (G-orbit of closed systems) with all its member systems and their solutions.
module Groups
using ..TripotentLC
using ..TripotentLC: Affine, dim, fmt_affine, fmtq, canon_set, symmetry_group, combinations_

ordinal(n) = string(n, (n % 100 in 11:13) ? "th" : n % 10 == 1 ? "st" : n % 10 == 2 ? "nd" : n % 10 == 3 ? "rd" : "th")
fmtpat(λ) = "(" * join(fmtq.(λ), ",") * ")"
fmtsys(L, S) = "{" * join([fmtpat(L[s]) for s in S], ", ") * "}"
function fmtsol(sol, m)
    pts = sort([fmt_affine(a, m) for a in sol if dim(a, m) == 0]); subs = sort([fmt_affine(a, m) for a in sol if dim(a, m) > 0])
    parts = String[]
    isempty(pts) || push!(parts, "(c1,…,c$m) ∈ {" * join(pts, ", ") * "}")
    isempty(subs) || push!(parts, join(subs, " or "))
    join(parts, " ; ")
end
"""groups: vector of (rep::Vector{Int}, members::Vector{Vector{Int}}, solution_of::Function(S)->Set{Affine}, gen::Int)"""
function write_groups(path, title, L, m, groups; zero_col_note=true)
    open(path, "w") do io
        println(io, "# ", title)
        println(io, "# Left-hand sides (eigenvalue patterns λ; one representative per unit-group orbit):")
        for (i, λ) in enumerate(L); println(io, "#   λ", i, " = ", fmtpat(λ)); end
        println(io, "# A system is a set of patterns {λ…}; its solutions are the (c1,…,c$m) with λ·c ∈ σ(X) for every λ in the set,")
        println(io, "# all c_i ≠ 0.  Listed systems are closed (they contain every pattern satisfied by all their solutions).")
        println(io, "# Groups = orbits under permutations of matrices with equal spectra and unit scalings X_i → uX_i (u·σ(X_i) = σ(X_i)).")
        println(io, "# Groups whose representative has a zero column (some X_i = 0) are marked [zero column].")
        println(io, "# ", length(groups), " groups\n")
        for (g, (rep, members, solution_of, gen)) in enumerate(groups)
            zc = any(i -> all(s -> iszero(L[s][i]), rep), 1:m)
            println(io, "======== ", ordinal(g), " group ========", zc ? "   [zero column]" : "")
            println(io, "blocks: ", length(rep), " | systems in this group: ", length(members), " | minimal generating set: ", gen == 0 ? "n/a" : string(gen, " equation(s)"))
            println(io, "representative system: ", fmtsys(L, rep))
            println(io, "solutions: ", fmtsol(solution_of(rep), m))
            println(io, "systems in this group and their solutions:")
            for (j, S) in enumerate(sort(members))
                println(io, "  ", j, ". ", fmtsys(L, S), "  ->  ", fmtsol(solution_of(S), m))
            end
            println(io)
        end
    end
end
# adapter for TripotentLC.Result
function groups_from_result(r, inp)
    m = length(inp.spectra); L = r.L
    single = [TripotentLC.solve_single(L[i], inp.target, m) for i in 1:length(L)]
    gs = []
    for (S, members) in r.orbits
        sol = r.closed[S]
        gen = length(S)
        for s in 1:length(S)
            found = false
            for sub in combinations_(S, s)
                reduce((A, B) -> TripotentLC.intersect_sets(A, B, m), (single[i] for i in sub)) == sol && (found = true; break)
            end
            found && (gen = s; break)
        end
        push!(gs, (S, members, S2 -> r.closed[S2], gen))
    end
    pos(λ) = [findfirst(==(λ[i]), inp.spectra[i]) for i in 1:m]
    sort!(gs; by=x -> (any(i -> all(s -> iszero(L[s][i]), x[1]), 1:m), length(x[1]), sort([pos(L[s]) for s in x[1]])))
    gs
end
end # module
