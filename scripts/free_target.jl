
# Free-target version of the characterization: X = a1 X1 + a2 X2 must be {p3,q3}-quadratic for SOME p3,q3.
# Unknown vector u = (a1, a2, p3, q3); pattern λ = (ξ1, ξ2) imposes  ξ1 a1 + ξ2 a2 ∈ {p3, q3}, i.e. the union of
# the two hyperplanes (ξ1, ξ2, -1, 0)·u = 0 and (ξ1, ξ2, 0, -1)·u = 0.  Same intersection/closure machinery as
# TripotentLC, with the nonzero condition imposed on a1, a2 only.  Structure is computed at an exact random
# rational specialization of the parameters (two seeds).
include(joinpath(@__DIR__, "common.jl"))
using .TripotentLC: Affine, rref_aug
using Random
const Q = Rational{Int128}
const M = 4

ok(rows) = all(r -> !(iszero(r[M+1]) && count(!iszero, @view r[1:M]) == 1 && (findfirst(!iszero, @view r[1:M]) <= 2)), rows)

function single_sets(L)
    out = Vector{Set{Affine{Q}}}()
    for λ in L
        s = Set{Affine{Q}}()
        for row in ([λ[1], λ[2], -1, 0, 0], [λ[1], λ[2], 0, -1, 0])
            rows = rref_aug([Q.(row)], M); rows === nothing && continue
            ok(rows) && push!(s, Affine(rows))
        end
        push!(out, prune!(s))
    end
    out
end
function isect(A, B)
    out = Set{Affine{Q}}()
    for a in A, b in B
        rows = rref_aug(vcat(a.rows, b.rows), M); rows === nothing && continue
        ok(rows) && push!(out, Affine(rows))
    end
    prune!(out)
end
function enumerate_free(single)
    n = length(single)
    level = Dict{Vector{Int},Set{Affine{Q}}}([i] => single[i] for i in 1:n if !isempty(single[i]))
    all = copy(level)
    while !isempty(level)
        nxt = Dict{Vector{Int},Set{Affine{Q}}}()
        ks = sort!(collect(keys(level)))
        for i in 1:length(ks), j in i+1:length(ks)
            ks[i][1:end-1] == ks[j][1:end-1] || continue
            s = isect(level[ks[i]], level[ks[j]]); isempty(s) && continue
            nxt[vcat(ks[i], ks[j][end])] = s
        end
        merge!(all, nxt); level = nxt
    end
    all
end

# remove components contained in another component (arises here because p3 and q3 are unknowns)
function prune!(s::Set{Affine{Q}})
    v = collect(s)
    for a in v, b in v
        a === b && continue
        length(a.rows) <= length(b.rows) && continue       # a can only be inside a bigger (fewer equations) b
        r = rref_aug(vcat(a.rows, b.rows), M)
        r !== nothing && length(r) == length(a.rows) && (delete!(s, a); break)
    end
    s
end
dimA(a) = M - length(a.rows)
closure(sol, single) = [i for i in eachindex(single) if isect(sol, single[i]) == sol]

function run(name, names1, names2, seed)
    rng = MersenneTwister(seed)
    v1 = Q.(randperm(rng, 3000)[1:length(names1)]); v2 = Q.(randperm(rng, 3000)[1:length(names2)])
    L = [Q[x, y] for x in v1 for y in v2]; lab = [(a, b) for a in names1 for b in names2]
    single = single_sets(L)
    all = enumerate_free(single)
    closed = Dict{Vector{Int},Set{Affine{Q}}}()
    for (S, sol) in all
        c = closure(sol, single); closed[c] = sol
    end
    kmax = maximum(length, keys(all))
    println("[$name seed=$seed] patterns=$(length(L)) solvable systems=$(length(all)) closed=$(length(closed)) k_max=$kmax")
    bysize = Dict{Int,Int}(); for S in keys(all); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
    println("  by size: ", join(["$k→$(bysize[k])" for k in sort(collect(keys(bysize)))], ", "))
    # report: closed systems with component dims and the "value classes" (which patterns share p3 / q3)
    io = open("free_$(name)_seed$(seed).txt", "w")
    println(io, "# $name — free target, closed systems (seed $seed). u=(a1,a2,p3,q3); dim = dimension of the component in C^4 (homogeneous).")
    for S in sort(collect(keys(closed)); by = s -> (length(s), s))
        comps = sort(collect(closed[S]); by = a -> (dimA(a), a.rows))
        desc = String[]
        for a in comps
            # value class: evaluate which hyperplane each pattern of S lies on: test λ·a - p3 ≡ 0 on component
            cls = String[]
            for i in S
                rp = rref_aug(vcat(a.rows, [Q[L[i][1], L[i][2], -1, 0, 0]]), M); rq = rref_aug(vcat(a.rows, [Q[L[i][1], L[i][2], 0, -1, 0]]), M)
                onp = rp !== nothing && length(rp) == length(a.rows); onq = rq !== nothing && length(rq) == length(a.rows)
                push!(cls, onp && onq ? "pq" : onp ? "p" : onq ? "q" : "?")
            end
            push!(desc, "dim$(dimA(a))[" * join(cls, ",") * "]")
        end
        println(io, join(["($(lab[i][1]),$(lab[i][2]))" for i in S], " "), "  ->  ", length(comps), " comps: ", join(desc, " "))
    end
    close(io)
    (all, closed, lab)
end

function run_vals(name, names1, v1, names2, v2)
    L = [Q[x, y] for x in v1 for y in v2]; lab = [(a, b) for a in names1 for b in names2]
    single = single_sets(L); all = enumerate_free(single)
    closed = Dict{Vector{Int},Set{Affine{Q}}}()
    for (S, sol) in all; closed[closure(sol, single)] = sol; end
    println("[$name] solvable=$(length(all)) closed=$(length(closed)) k_max=$(maximum(length, keys(all)))")
    io = open("free_$(name).txt", "w")
    for S in sort(collect(keys(closed)); by = s -> (length(s), s))
        comps = sort(collect(closed[S]); by = a -> (dimA(a), a.rows))
        desc = String[]
        for a in comps
            # parametrize: print RREF rows over (a1,a2,p3,q3)
            push!(desc, "dim$(dimA(a)){" * join([join(string.(r[1:M]), ",") for r in a.rows], "; ") * "}")
        end
        println(io, join(["($(lab[i][1]),$(lab[i][2]))" for i in S], " "), "  ->  ", join(desc, " "))
    end
    close(io)
end
for seed in (1, 2)
    run("cubic_quadratic", ["α1","β1","γ1"], ["α2","β2"], seed)
    run("cubic_cubic", ["p1","q1","r1"], ["p2","q2","r2"], seed)
end
run_vals("tripotent_tripotent", ["1","-1","0"], Q[1,-1,0], ["1","-1","0"], Q[1,-1,0])
run_vals("tripotent_idempotent", ["1","-1","0"], Q[1,-1,0], ["1","0"], Q[1,0])
run_vals("tripotent_involutive", ["1","-1","0"], Q[1,-1,0], ["1","-1"], Q[1,-1])

