
# bench_classical.jl — classical multi-RHS RREF (2021 algorithm, every k-subset, k ≤ m)
# versus the intersection method (TripotentLC.enumerate_systems) — Julia, exact Rational{Int64}.
include(joinpath(@__DIR__, "..", "scripts", "common.jl"))
using .TripotentLC: CharacterizationInput, lhs_vectors, Affine, nonzero_ok, enumerate_systems
const Q = Rational{Int64}
const OPS = Ref{Int}(0)          # scalar field operations (inv, mul, sub) in the elimination kernels

# ---- instrumented RREF kernel, M is a k × ncols dense matrix, pivots searched in columns 1:m
function rref!(M::Matrix{T}, m::Int) where T
    k, ncols = size(M)
    r = 1
    @inbounds for c in 1:m
        p = 0
        for i in r:k
            if !iszero(M[i, c]); p = i; break; end
        end
        p == 0 && continue
        if p != r
            for j in 1:ncols; M[r, j], M[p, j] = M[p, j], M[r, j]; end
        end
        iv = inv(M[r, c]); OPS[] += 1
        for j in c:ncols; M[r, j] *= iv; end
        OPS[] += ncols - c + 1
        for i in 1:k
            (i == r || iszero(M[i, c])) && continue
            f = M[i, c]
            for j in c:ncols; M[i, j] -= f * M[r, j]; end
            OPS[] += 2 * (ncols - c + 1)
        end
        r += 1
        r > k && break
    end
    return r - 1                 # rank of the coefficient part
end

# ---- classical: one k-subset S, ALL 3^k right-hand sides at once (multi-RHS augmented matrix)
function classical_system(L::Vector{Vector{T}}, S::Vector{Int}, target::Vector{T}, m::Int) where T
    k = length(S)
    t = length(target); nr = t^k                                    # all b ∈ target^k
    M = Matrix{T}(undef, k, m + nr)
    for (i, s) in enumerate(S); M[i, 1:m] .= L[s]; end
    @inbounds for j in 0:nr-1
        q = j
        for i in 1:k; M[i, m + 1 + j] = target[q % t + 1]; q ÷= t; end
    end
    rk = rref!(M, m)
    out = Set{Affine{T}}()
    @inbounds for j in 1:nr
        col = m + j
        ok = true
        for i in rk+1:k            # zero rows of A: need 0 = b
            iszero(M[i, col]) || (ok = false; break)
        end
        ok || continue
        rows = [vcat(M[i, 1:m], M[i, col]) for i in 1:rk]
        sort!(rows; rev=true)
        nonzero_ok(rows, m) && push!(out, Affine(rows))
    end
    return out, nr
end

function classical_all(inp, maxk)
    m = length(inp.spectra)
    L, _ = lhs_vectors(inp); n = length(L)
    res = Dict{Vector{Int},Set{Affine{Q}}}()
    nsys = 0; ncols = 0
    for k in 1:maxk
        idx = collect(1:k)
        while true
            S = copy(idx)
            sol, nr = classical_system(L, S, inp.target, m)
            nsys += 1; ncols += nr
            isempty(sol) || (res[S] = sol)
            # next combination
            i = k
            while i ≥ 1 && idx[i] == n - k + i; i -= 1; end
            i == 0 && break
            idx[i] += 1
            for j in i+1:k; idx[j] = idx[j-1] + 1; end
        end
    end
    return res, nsys, ncols
end

# ---- intersection method: level-wise joins (uses the library; its rref_aug is not instrumented,
#      so ops are counted by an identical instrumented re-run of each pairwise stacked RREF)
function intersection_ops(all_systems, L, inp, m)
    # recount: for each system of size k≥2 the pairs actually intersected are
    # (S[1:end-1], S[1:end-2] ∪ S[end]) component-wise; we replay those joins to count ops.
    ops = 0
    for (S, _) in all_systems
        k = length(S); k == 1 && continue
        A = all_systems[S[1:end-1]]; B = all_systems[vcat(S[1:end-2], S[end])]
        for a in A, b in B
            M = Matrix{Q}(undef, length(a.rows) + length(b.rows), m + 1)
            for (i, r) in enumerate(vcat(a.rows, b.rows)); M[i, :] .= r; end
            OPS[] = 0; rref!(M, m); ops += OPS[]
        end
    end
    # level 1: single equations, one row each: normalisation only
    ops += sum(length(inp.target) * (m + 1) for _ in L)
    ops
end


inputfor(m) = CharacterizationInput([Q[1, -1, 0] for _ in 1:m], Q[1, -1, 0])

function run_classical(m, maxk)
    GC.gc(); OPS[] = 0
    t = @timed classical_all(inputfor(m), maxk)
    res, nsys, ncols = t.value
    (; method="classical", m, maxk, nsys, ncols, nonempty=length(res), comps=sum(length, values(res); init=0),
       time=t.time, alloc=t.bytes, ops=OPS[])
end
function run_intersection(m, maxk)
    inp = inputfor(m); GC.gc()
    t = @timed enumerate_systems(inp; verbose=false, max_level=maxk)
    L, single, all_systems = t.value
    (; method="intersection", m, maxk, nsys=length(all_systems), ncols=0, nonempty=length(all_systems),
       comps=sum(length, values(all_systems); init=0), time=t.time, alloc=t.bytes, ops=intersection_ops(all_systems, L, inp, m))
end
function check(m, maxk)
    inp = inputfor(m)
    cres, _, _ = classical_all(inp, maxk)
    _, _, all_systems, _ = enumerate_systems(inp; verbose=false, max_level=maxk)
    mism = count(S -> get(all_systems, S, Set{Affine{Q}}()) != cres[S], keys(cres)) + count(S -> !haskey(cres, S), keys(all_systems))
    (; method="check", m, maxk, compared=length(cres), mismatches=mism)
end

mode = ARGS[1]; m = parse(Int, ARGS[2]); maxk = parse(Int, ARGS[3])
f = mode == "classical" ? run_classical : mode == "intersection" ? run_intersection : check
f(3, 3)                                   # warm-up: compiles every code path (k = 1..3; k = 4 shares the same methods)
r = f(m, maxk)
println(r)
println("maxrss_MiB=", round(Sys.maxrss() / 2^20; digits=1), " threads=", Threads.nthreads())
