
"""
TripotentLC.jl — Prototype: complete characterization of the spectrum of linear
combinations  c1 X1 + ... + cm Xm  of mutually commuting diagonalizable matrices
(Kişi–Özdemir method, 2018; Kişi–Sarduvan–Özdemir–Kalaycı algorithm, 2021),
extended to ALL overdetermined systems via intersection of sub-system solutions.

Exact arithmetic: Julia's built-in Rational{Int} (no package needed).
Parallelism     : Base.Threads (start julia with  -t auto  or  -t N).
"""
module TripotentLC


export CharacterizationInput, run_characterization, write_report

const Q = Rational{Int64}

# ---------------------------------------------------------------- input ----
struct CharacterizationInput{T}
    spectra::Vector{Vector{T}}   # σ(X_i), i = 1..m
    target::Vector{T}            # σ(X)
    # repeated eigenvalues describe the same spectrum: deduplicate (order preserved)
    CharacterizationInput{T}(spectra, target) where T = new{T}([unique(s) for s in spectra], unique(target))
end
CharacterizationInput(spectra::Vector{Vector{T}}, target::Vector{T}) where T = CharacterizationInput{T}(spectra, target)
nmat(inp::CharacterizationInput) = length(inp.spectra)

# ------------------------------------------------- multiplicative symmetry -
# Units u with u·σ = σ.  For tripotent spectra U = {1,-1} (the classical ± halving);
# for quadripotent spectra {ω, ω², 1, 0} U = {1, ω, ω²}; in general a finite cyclic group.
stabilizes(u, σ) = Set(u .* σ) == Set(σ)
function unit_candidates(σ::Vector{T}) where T
    nz = filter(!iszero, σ)
    Set{T}(s / t for s in nz, t in nz)
end
"""Global unit group: every u that stabilizes all σ(X_i) and σ(X) (sorted, contains 1)."""
function unit_group(inp::CharacterizationInput{T}) where T
    us = [u for u in unit_candidates(inp.target) if stabilizes(u, inp.target) && all(σ -> stabilizes(u, σ), inp.spectra)]
    isempty(us) && push!(us, one(T))          # e.g. target {0}: only the trivial unit
    sort!(us)
end
"""Per-matrix unit groups: u with u·σ(X_i) = σ(X_i)  (X_i → uX_i keeps the matrix type)."""
coordinate_unit_groups(inp::CharacterizationInput{T}) where T =
    [(us = [u for u in unit_candidates(σ) if stabilizes(u, σ)]; isempty(us) ? [one(T)] : sort!(us)) for σ in inp.spectra]
# representative of the orbit U·λ: lexicographic maximum (for U = {±1} this is "first nonzero > 0")
canon_unit(λ::Vector{T}, U) where T = maximum(u .* λ for u in U)

# ------------------------------------------------- left-hand sides (λ) ----
# all λ ∈ σ(X1)×...×σ(Xm) except the zero vector, one representative per U-orbit.
function lhs_vectors(inp::CharacterizationInput{T}) where T
    m = nmat(inp)
    U = unit_group(inp)
    out = Vector{Vector{T}}()
    for idx in Iterators.product((1:length(s) for s in inp.spectra)...)
        λ = T[inp.spectra[i][idx[i]] for i in 1:m]
        all(iszero, λ) && continue
        canon_unit(λ, U) == λ || continue          # keep the representative only
        push!(out, λ)
    end
    return out, U
end

# ------------------------------------------------- affine subspaces -------
# An affine subspace of C^m is stored as its canonical RREF system  A c = b,
# rows = [a_1 ... a_m | b], full row rank, sorted.  dim = m - #rows.
struct Affine{T}
    rows::Vector{Vector{T}}
end
Base.:(==)(a::Affine, b::Affine) = a.rows == b.rows
Base.hash(a::Affine, h::UInt) = hash(a.rows, h)
dim(a::Affine, m) = m - length(a.rows)

"""RREF of augmented rows (length m+1). Returns `nothing` if inconsistent."""
function rref_aug(rows::Vector{Vector{T}}, m::Int) where T
    R = [copy(r) for r in rows]
    r = 1
    for c in 1:m
        p = findfirst(i -> !iszero(R[i][c]), r:length(R))
        p === nothing && continue
        p += r - 1
        R[r], R[p] = R[p], R[r]
        inv_ = inv(R[r][c]); R[r] .*= inv_
        for i in eachindex(R)
            (i == r || iszero(R[i][c])) && continue
            f = R[i][c]; R[i] .-= f .* R[r]
        end
        r += 1
        r > length(R) && break
    end
    out = Vector{Vector{T}}()
    for row in R
        if all(iszero, @view row[1:m])
            iszero(row[m+1]) || return nothing      # 0 = b≠0 : inconsistent
        else
            push!(out, row)
        end
    end
    sort!(out; rev=true)
    return out
end

# a subspace on which some c_i ≡ 0 is useless (all c_i must be nonzero)
function nonzero_ok(rows::Vector{Vector{T}}, m) where T
    for row in rows
        if iszero(row[m+1]) && count(!iszero, @view row[1:m]) == 1
            return false
        end
    end
    true
end

"""Solution set (union of affine subspaces) of the single equation λ·c ∈ target."""
function solve_single(λ::Vector{T}, target::Vector{T}, m) where T
    out = Set{Affine{T}}()
    for r in target
        rows = rref_aug([vcat(λ, r)], m)
        rows === nothing && continue
        nonzero_ok(rows, m) && push!(out, Affine(rows))
    end
    out
end

"""Intersection of two unions of affine subspaces (distributes pairwise)."""
function intersect_sets(A::Set{Affine{T}}, B::Set{Affine{T}}, m) where T
    out = Set{Affine{T}}()
    for a in A, b in B
        rows = rref_aug(vcat(a.rows, b.rows), m)
        rows === nothing && continue
        nonzero_ok(rows, m) && push!(out, Affine(rows))
    end
    out
end

# ------------------------------------------------- level-wise enumeration --
# Level k holds every k-subset S of LHS indices whose system has a solution with
# all c_i ≠ 0.  Level k+1 is built Apriori-style: two level-k sets sharing the
# same (k-1)-prefix are joined and their solution sets INTERSECTED (no linear
# system is solved directly beyond the single equations).  Empty ⇒ pruned, and
# all supersets are pruned with it.
function enumerate_systems(inp::CharacterizationInput{T}; verbose=true, max_level=typemax(Int), log=stdout) where T
    m = nmat(inp)
    L, symmetric = lhs_vectors(inp)
    n = length(L)
    single = [solve_single(L[i], inp.target, m) for i in 1:n]
    level = Dict{Vector{Int},Set{Affine{T}}}()
    for i in 1:n
        isempty(single[i]) || (level[[i]] = single[i])
    end
    all_systems = Dict{Vector{Int},Set{Affine{T}}}(level)
    k = 1
    verbose && (println(log, "LHS vectors: $n (unit group: $symmetric)\nlevel 1: $(length(level))"); flush(log))
    while !isempty(level) && k < max_level
        tlev = time()
        keys_sorted = sort!(collect(keys(level)))
        # group by (k-1)-prefix
        groups = Dict{Vector{Int},Vector{Vector{Int}}}()
        for S in keys_sorted
            push!(get!(groups, S[1:end-1], Vector{Vector{Int}}()), S)
        end
        pairs = Vector{Tuple{Vector{Int},Vector{Int}}}()
        for g in values(groups), i in 1:length(g), j in i+1:length(g)
            push!(pairs, (g[i], g[j]))
        end
        # ---- parallel section: each thread intersects its own share of pairs
        # (per-chunk result slots instead of threadid(): Julia ≥1.12 has interactive
        #  threads, so threadid() may exceed nthreads(); this pattern is also race-free)
        nchunks = 4 * Threads.nthreads()
        chunks = collect(Iterators.partition(1:length(pairs), max(1, cld(length(pairs), nchunks))))
        locals = [Dict{Vector{Int},Set{Affine{T}}}() for _ in 1:length(chunks)]
        Threads.@threads :dynamic for ci in eachindex(chunks)
            d = locals[ci]
            for p in chunks[ci]
                a, b = pairs[p]
                sol = intersect_sets(level[a], level[b], m)
                isempty(sol) && continue
                d[vcat(a, b[end])] = sol
            end
        end
        nxt = Dict{Vector{Int},Set{Affine{T}}}()
        for d in locals; merge!(nxt, d); end
        k += 1
        verbose && (println(log, "level $k: $(length(nxt)) nonempty systems (from $(length(pairs)) candidate joins)  [$(round(time()-tlev; digits=2)) s]"); flush(log))
        merge!(all_systems, nxt)
        level = nxt
    end
    exhaustive = isempty(level)                 # false when max_level stopped the enumeration
    return L, single, all_systems, exhaustive
end

"""All s-element sub-vectors of v (lexicographic order of index sets)."""
function combinations_(v, s)
    n = length(v); out = Vector{Vector{eltype(v)}}()
    s > n && return out
    idx = collect(1:s)
    while true
        push!(out, v[idx])
        i = s
        while i ≥ 1 && idx[i] == n - s + i; i -= 1; end
        i == 0 && break
        idx[i] += 1; for j in i+1:s; idx[j] = idx[j-1] + 1; end
    end
    out
end

# ------------------------------------------------- closure & symmetry ------
"""cl(S) = all λ-indices satisfied by EVERY solution of S  (S ⊆ cl(S), same solutions)."""
function closure(sol::Set{Affine{T}}, single, m) where T
    [i for i in eachindex(single) if intersect_sets(sol, single[i], m) == sol]
end

"""Symmetry group of the problem: permutations of matrices with identical spectra ×
per-matrix unit scalings X_i → u X_i with u·σ(X_i) = σ(X_i)  (sign flips for tripotents,
ω-scalings for quadripotents).  Returns index tables on the U-canonical LHS list L."""
function symmetry_group(inp::CharacterizationInput{T}, L) where T
    m = nmat(inp)
    specsets = [Set(s) for s in inp.spectra]
    Ui = coordinate_unit_groups(inp)
    U = unit_group(inp)
    index = Dict{Vector{T},Int}()
    for (i, λ) in enumerate(L); index[λ] = i; end
    tables = Vector{Vector{Int}}()
    perms = collect(Iterators.filter(p -> all(specsets[p[j]] == specsets[j] for j in 1:m),
                     permutations_(m)))
    for p in perms, units in Iterators.product((Ui[i] for i in 1:m)...)
        tab = Vector{Int}(undef, length(L))
        for (i, λ) in enumerate(L)
            μ = T[units[j] * λ[p[j]] for j in 1:m]
            tab[i] = index[canon_unit(μ, U)]
        end
        push!(tables, tab)
    end
    tables
end
function permutations_(m)
    m == 1 && return [[1]]
    out = Vector{Vector{Int}}()
    for p in permutations_(m - 1), k in 1:m
        push!(out, vcat(p[1:k-1], m, p[k:end]))
    end
    out
end
canon_set(S, tables) = minimum(sort!([t[i] for i in S]) for t in tables)

# ------------------------------------------------- verification -----------
"""Build diagonal Λ_i from the λ-pattern S and check (Σ c_i Λ_i) has spectrum ⊆ target
for every point solution.  Independent of the solver (pure matrix arithmetic)."""
function verify_point(c::Vector{T}, S, L, target, m) where T
    # diagonal blocks Λ_i = diag(λ_i for each pattern in S); X = Σ c_i Λ_i (diagonal)
    Λ = [T[L[s][i] for s in S] for i in 1:m]
    X = sum(c[i] .* Λ[i] for i in 1:m)
    all(x -> x in target, X)
end

# ------------------------------------------------- driver -----------------
struct Result{T}
    L::Vector{Vector{T}}
    all_systems::Dict{Vector{Int},Set{Affine{T}}}
    closed::Dict{Vector{Int},Set{Affine{T}}}
    orbits::Dict{Vector{Int},Vector{Vector{Int}}}   # canonical closed S => members
    timings::Dict{String,Float64}
    exhaustive::Bool                                # false if the enumeration was cut by max_level
end

function run_characterization(inp::CharacterizationInput{T}; verbose=true, max_level=typemax(Int), log=stdout) where T
    m = nmat(inp)
    timings = Dict{String,Float64}()
    t = @elapsed (L, single, all_systems, exhaustive) = enumerate_systems(inp; verbose, max_level, log)
    timings["enumeration"] = t
    t = @elapsed begin
        closed = Dict{Vector{Int},Set{Affine{T}}}()
        ks = collect(keys(all_systems))
        nchunks = 4 * Threads.nthreads()
        chunks = collect(Iterators.partition(eachindex(ks), max(1, cld(length(ks), nchunks))))
        locals = [Dict{Vector{Int},Set{Affine{T}}}() for _ in 1:length(chunks)]
        Threads.@threads :dynamic for ci in eachindex(chunks)
            for idx in chunks[ci]
                S = ks[idx]; sol = all_systems[S]
                locals[ci][closure(sol, single, m)] = sol
            end
        end
        for d in locals; merge!(closed, d); end
    end
    timings["closure"] = t
    t = @elapsed begin
        tables = symmetry_group(inp, L)
        orbits = Dict{Vector{Int},Vector{Vector{Int}}}()
        for S in keys(closed)
            push!(get!(orbits, canon_set(S, tables), Vector{Vector{Int}}()), S)
        end
    end
    timings["orbits"] = t
    # verification of every point solution of every closed system
    t = @elapsed begin
        nver = 0
        for (S, sol) in closed, a in sol
            dim(a, m) == 0 || continue
            c = Vector{T}(undef, m)
            for row in a.rows; j = findfirst(!iszero, @view row[1:m]); c[j] = row[m+1]; end
            verify_point(c, S, L, inp.target, m) || error("verification failed for S=$S c=$c")
            nver += 1
        end
    end
    timings["verification"] = t
    if verbose
        println(log, "\nnonempty systems: $(length(all_systems))   closed systems: $(length(closed))   orbits (characteristics): $(length(orbits))")
        println(log, "verified $nver point solutions by direct matrix arithmetic")
        for (k, v) in sort(collect(timings)); println(log, "  ", rpad(k, 13), " ", round(v; digits=3), " s"); end
        flush(log)
    end
    exhaustive || (verbose && println(log, "WARNING: enumeration stopped at max_level=$max_level — results are partial"))
    Result(L, all_systems, closed, orbits, timings, exhaustive)
end

# ------------------------------------------------- report -----------------
fmtq(x::Rational) = denominator(x) == 1 ? string(numerator(x)) : string(numerator(x), "/", denominator(x))
fmtq(x) = string(x)
fmtλ(λ) = "(" * join(fmtq.(λ), ",") * ")"

function fmt_affine(a::Affine{T}, m) where T
    if dim(a, m) == 0
        c = Vector{T}(undef, m)
        for row in a.rows; j = findfirst(!iszero, @view row[1:m]); c[j] = row[m+1]; end
        return "(" * join(fmtq.(c), ", ") * ")"
    end
    eqs = String[]
    for row in a.rows
        terms = String[]
        for j in 1:m
            iszero(row[j]) && continue
            coef = row[j] == 1 ? "" : (row[j] == -1 ? "-" : fmtq(row[j]) * "·")
            push!(terms, coef * "c$j")
        end
        push!(eqs, replace(join(terms, " + "), "+ -" => "- ") * " = " * fmtq(row[m+1]))
    end
    "{" * join(eqs, ",  ") * "}  (dim $(dim(a, m)), c_i ≠ 0)"
end

function write_report(path, res::Result{T}, inp::CharacterizationInput{T}; title="") where T
    m = nmat(inp)
    open(path, "w") do io
        println(io, "# ", title)
        res.exhaustive || println(io, "\n**WARNING: the enumeration was stopped by max_level — this report is PARTIAL (systems, closed systems and characteristics are lower bounds).**")
        println(io, "\nLHS vectors (λ = eigenvalue pattern of (X1,…,Xm)): ", length(res.L))
        println(io, "Nonempty systems: ", length(res.all_systems), "  |  closed systems: ", length(res.closed),
                    "  |  characteristics (orbits under sign/permutation symmetry): ", length(res.orbits))
        bysize = Dict{Int,Int}()
        for S in keys(res.all_systems); bysize[length(S)] = get(bysize, length(S), 0) + 1; end
        println(io, "\nNonempty systems by number of equations: ",
                join(["$k→$(bysize[k])" for k in sort(collect(keys(bysize)))], ", "))
        println(io, "\n## Characteristics (one representative per orbit; sorted by #equations)\n")
        reps = sort(collect(keys(res.orbits)); by = S -> (length(S), S))
        for (n, S) in enumerate(reps)
            sol = res.closed[S]
            println(io, "### (", n, ")  ", length(S), " equation(s), orbit size ", length(res.orbits[S]))
            println(io, "Eigenvalue patterns allowed:  ", join(fmtλ.(res.L[S]), "  "))
            println(io, "Solutions (c1,…,c$m):")
            for a in sort(collect(sol); by = a -> (dim(a, m), a.rows))
                println(io, "  - ", fmt_affine(a, m))
            end
            println(io)
        end
    end
    path
end


# ======================================================================
#  v2 additions: disk-streamed levels, Channel-based lazy candidate
#  generation, evaluation-based closure.  (appended to module TripotentLC)
# ======================================================================
module Streamed
using ..TripotentLC: Affine, CharacterizationInput, nmat, lhs_vectors, solve_single,
                     intersect_sets, symmetry_group, canon_set, dim, fmt_affine, fmtλ

# ---------------------------------------------------------------- binary I/O
# file = sequence of records:  nidx::Int64, idx..., ncomp::Int64,
#        for each comp: nrows::Int64, then nrows*(m+1) rationals as (num,den) Int64 pairs
function write_level(path, level::Dict{Vector{Int},Set{Affine{T}}}, m) where T
    open(path, "w") do io
        write(io, Int64(length(level))); write(io, Int64(m))
        for (S, sol) in level
            write(io, Int64(length(S))); for i in S; write(io, Int64(i)); end
            write(io, Int64(length(sol)))
            for a in sol
                write(io, Int64(length(a.rows)))
                for row in a.rows, x in row
                    write(io, Int64(numerator(x))); write(io, Int64(denominator(x)))
                end
            end
        end
    end
end

"""Lazy reader: `Channel` that yields (S, sol) records one at a time — the file is
never loaded whole into memory."""
function read_level_channel(path, ::Type{T}; buf=256) where T
    Channel{Tuple{Vector{Int},Set{Affine{T}}}}(buf; spawn=true) do ch
        open(path, "r") do io
            n = read(io, Int64); m = Int(read(io, Int64))
            for _ in 1:n
                k = read(io, Int64); S = [Int(read(io, Int64)) for _ in 1:k]
                nc = read(io, Int64); sol = Set{Affine{T}}()
                for _ in 1:nc
                    nr = read(io, Int64)
                    rows = [T[(num = read(io, Int64); den = read(io, Int64); T(num) / T(den)) for _ in 1:m+1] for _ in 1:nr]
                    push!(sol, Affine(rows))
                end
                put!(ch, (S, sol))
            end
        end
    end
end
function read_level(path, ::Type{T}) where T
    d = Dict{Vector{Int},Set{Affine{T}}}()
    for (S, sol) in read_level_channel(path, T); d[S] = sol; end
    d
end

# ---------------------------------------------------------------- lazy candidate producer
"""Lazily yields CHUNKS of (A, B) pairs of level-k keys sharing the same (k-1)-prefix,
from a sorted key list — the full pair list is never materialised; one chunk (default
1024 pairs) is in flight per consumer."""
function candidate_chunks(keys_sorted::Vector{Vector{Int}}; chunk=1024, buf=64)
    Channel{Vector{Tuple{Vector{Int},Vector{Int}}}}(buf; spawn=true) do ch
        cur = Vector{Tuple{Vector{Int},Vector{Int}}}(); sizehint!(cur, chunk)
        i = 1; n = length(keys_sorted)
        while i <= n
            pre = @view keys_sorted[i][1:end-1]; j = i
            while j <= n && (@view keys_sorted[j][1:end-1]) == pre; j += 1; end     # group [i, j)
            for a in i:j-1, b in a+1:j-1
                push!(cur, (keys_sorted[a], keys_sorted[b]))
                if length(cur) == chunk
                    put!(ch, cur); cur = Vector{Tuple{Vector{Int},Vector{Int}}}(); sizehint!(cur, chunk)
                end
            end
            i = j
        end
        isempty(cur) || put!(ch, cur)
    end
end

"""One level step as a separate, type-stable function (no captured re-assigned variables)."""
function next_level(level::Dict{Vector{Int},Set{Affine{T}}}, m::Int) where T
    keys_sorted = sort!(collect(keys(level)))
    ch = candidate_chunks(keys_sorted)
    ntask = Threads.nthreads()
    locals = [Dict{Vector{Int},Set{Affine{T}}}() for _ in 1:ntask]
    counts = zeros(Int, ntask)
    @sync for t in 1:ntask
        Threads.@spawn begin
            d = locals[t]; c = 0
            for chunkv in ch                                 # lazy pull, one chunk at a time
                for (a, b) in chunkv
                    c += 1
                    sol = intersect_sets(level[a], level[b], m)
                    isempty(sol) && continue
                    d[vcat(a, b[end])] = sol
                end
            end
            counts[t] = c
        end
    end
    nxt = Dict{Vector{Int},Set{Affine{T}}}()
    for d in locals; merge!(nxt, d); empty!(d); end
    nxt, sum(counts)
end

# ---------------------------------------------------------------- streamed enumeration
"""Level k+1 is computed from level k ONLY (read from disk), written to disk, and the
previous level is dropped from RAM.  Consumers = Threads.nthreads() tasks pulling from
the lazy candidate Channel; each keeps a private Dict (no locks)."""
function enumerate_streamed(inp::CharacterizationInput{T}; outdir="levels", max_level=typemax(Int),
                            log=stdout, time_limit=Inf) where T
    m = nmat(inp); mkpath(outdir)
    L, symmetric = lhs_vectors(inp); n = length(L)
    single = [solve_single(L[i], inp.target, m) for i in 1:n]
    level = Dict{Vector{Int},Set{Affine{T}}}()
    for i in 1:n; isempty(single[i]) || (level[[i]] = single[i]); end
    write_level(joinpath(outdir, "level_1.bin"), level, m)
    sizes = Int[length(level)]; njoins = Int[0]; times = Float64[0.0]
    println(log, "LHS vectors: $n (unit group: $symmetric)\nlevel 1: $(length(level))"); flush(log)
    k = 1; t_start = time()
    while !isempty(level) && k < max_level && (time() - t_start) < time_limit
        t0 = time()
        nxt, nj = next_level(level, m)
        k += 1
        write_level(joinpath(outdir, "level_$k.bin"), nxt, m)
        push!(sizes, length(nxt)); push!(njoins, nj); push!(times, time() - t0)
        println(log, "level $k: $(length(nxt)) nonempty systems (from $nj candidate joins)  [$(round(time()-t0; digits=2)) s]  disk(level file)=$(round(filesize(joinpath(outdir, "level_$k.bin"))/2^20; digits=1)) MiB  maxrss=$(round(Sys.maxrss()/2^30; digits=2)) GiB"); flush(log)
        level = nxt                                     # previous level dropped
        GC.gc()
    end
    finished = isempty(level)
    return (; L, single, sizes, njoins, times, nlevels=k, finished, outdir)
end

# ---------------------------------------------------------------- evaluation-based closure
"""λ ∈ cl(S)  ⇔  on every component a of sol(S), λ·c is constant and lies in `target`.
For an RREF component, λ is constant on a iff λ ∈ rowspace(A); then the value is
Σ λ[pivot_r]·b_r after reducing λ by the pivot rows.  O(#rows·m), no RREF, no allocation
of new Affine objects."""
function closure_eval(sol::Set{Affine{T}}, L, target, m) where T
    out = Int[]
    for (i, λ) in enumerate(L)
        ok = true
        for a in sol
            μ = copy(λ); val = zero(T)
            for row in a.rows
                piv = findfirst(!iszero, @view row[1:m])
                f = μ[piv]; iszero(f) && continue
                val += f * row[m+1]
                @inbounds for j in 1:m; μ[j] -= f * row[j]; end
            end
            if !all(iszero, μ) || !(val in target); ok = false; break; end
        end
        ok && push!(out, i)
    end
    out
end

"""Stream every level file, compute closures, keep only distinct closed systems."""
function closures_streamed(res, inp::CharacterizationInput{T}; log=stdout) where T
    m = nmat(inp); L = res.L
    closed = Dict{Vector{Int},Set{Affine{T}}}(); lk = ReentrantLock()
    for k in 1:res.nlevels
        path = joinpath(res.outdir, "level_$k.bin"); isfile(path) || continue
        t0 = time()
        ch = read_level_channel(path, T; buf=4096)
        @sync for t in 1:Threads.nthreads()
            Threads.@spawn begin
                for (S, sol) in ch
                    key = closure_eval(sol, L, inp.target, m)
                    lock(lk) do; haskey(closed, key) || (closed[key] = sol); end
                end
            end
        end
        println(log, "closure level $k: closed so far $(length(closed))  [$(round(time()-t0; digits=2)) s]"); flush(log)
    end
    closed
end

function verify_points(closed, L, target, m)
    nver = 0
    for (S, sol) in closed, a in sol
        dim(a, m) == 0 || continue
        c = Vector{eltype(target)}(undef, m)
        for row in a.rows; j = findfirst(!iszero, @view row[1:m]); c[j] = row[m+1]; end
        for s in S
            (sum(L[s][i] * c[i] for i in 1:m) in target) || error("verification failed S=$S c=$c")
        end
        nver += 1
    end
    nver
end

function run_streamed(inp::CharacterizationInput{T}; outdir="levels", max_level=typemax(Int), log=stdout, time_limit=Inf) where T
    m = nmat(inp)
    t_en = @elapsed res = enumerate_streamed(inp; outdir, max_level, log, time_limit)
    t_cl = @elapsed closed = closures_streamed(res, inp; log)
    t_or = @elapsed begin
        tables = symmetry_group(inp, res.L)
        orbits = Dict{Vector{Int},Vector{Vector{Int}}}()
        for S in keys(closed); push!(get!(orbits, canon_set(S, tables), Vector{Vector{Int}}()), S); end
    end
    t_ve = @elapsed nver = verify_points(closed, res.L, inp.target, m)
    println(log, "\nnonempty systems: $(sum(res.sizes))   closed systems: $(length(closed))   orbits: $(length(orbits))   finished=$(res.finished)")
    println(log, "verified $nver point solutions;  times: enumeration $(round(t_en;digits=2)) s, closure $(round(t_cl;digits=2)) s, orbits $(round(t_or;digits=2)) s, verification $(round(t_ve;digits=2)) s"); flush(log)
    (; res, closed, orbits, nver, timings=(enumeration=t_en, closure=t_cl, orbits=t_or, verification=t_ve))
end

end # module Streamed


# ======================================================================
#  Pooled: component interning + id-list solution sets + bitset closure
# ======================================================================
module Pooled
using ..TripotentLC: Affine, CharacterizationInput, nmat, lhs_vectors, solve_single,
                     rref_aug, nonzero_ok, symmetry_group, canon_set, dim

# ---------------------------------------------------------------- component pool
mutable struct Pool{T}
    comps::Vector{Affine{T}}          # id -> component (RREF rows)
    index::Dict{Affine{T},Int32}      # component -> id
    ispoint::Vector{Bool}
    lams::Vector{BitVector}           # id -> which λ (index into L) the component satisfies entirely
    lock::ReentrantLock
end
Pool{T}() where T = Pool{T}(Affine{T}[], Dict{Affine{T},Int32}(), Bool[], BitVector[], ReentrantLock())

"""λ·c is constant on component `a` with value in `target`?  (λ ∈ rowspace(A) and value ∈ target)"""
function satisfies(a::Affine{T}, λ::Vector{T}, target, m) where T
    μ = copy(λ); val = zero(T)
    for row in a.rows
        piv = findfirst(!iszero, @view row[1:m])
        f = μ[piv]; iszero(f) && continue
        val += f * row[m+1]
        @inbounds for j in 1:m; μ[j] -= f * row[j]; end
    end
    all(iszero, μ) && (val in target)
end

function intern!(pool::Pool{T}, a::Affine{T}, L, target, m) where T
    lock(pool.lock) do
        id = get(pool.index, a, Int32(0))
        id != 0 && return id
        push!(pool.comps, a); id = Int32(length(pool.comps)); pool.index[a] = id
        push!(pool.ispoint, dim(a, m) == 0)
        push!(pool.lams, BitVector([satisfies(a, L[i], target, m) for i in eachindex(L)]))
        return id
    end
end

point_in(a::Affine{T}, p::Vector{T}, m) where T =
    all(sum(row[j] * p[j] for j in 1:m) == row[m+1] for row in a.rows)
function point_coords(a::Affine{T}, m) where T
    c = Vector{T}(undef, m)
    for row in a.rows; j = findfirst(!iszero, @view row[1:m]); c[j] = row[m+1]; end
    c
end

# ---------------------------------------------------------------- intersection on id lists
"""Intersection of two solution sets given as sorted id vectors."""
function intersect_ids(A::Vector{Int32}, B::Vector{Int32}, pool::Pool{T}, L, target, m) where T
    out = Int32[]
    # 1) point ∩ point : identical ids (sorted merge)
    i = j = 1
    while i <= length(A) && j <= length(B)
        if A[i] == B[j]; push!(out, A[i]); i += 1; j += 1
        elseif A[i] < B[j]; i += 1 else j += 1 end
    end
    # snapshot of the pool entries we need, taken under the pool lock (intern! may grow the
    # vectors concurrently; reading a growing Vector without the lock is a data race)
    compA, ptA, compB, ptB = lock(pool.lock) do
        ([pool.comps[a] for a in A], [pool.ispoint[a] for a in A], [pool.comps[b] for b in B], [pool.ispoint[b] for b in B])
    end
    Anp = [compA[k] for k in eachindex(A) if !ptA[k]]; Bnp = [compB[k] for k in eachindex(B) if !ptB[k]]
    isempty(Anp) && isempty(Bnp) && return out
    # 2) point of A inside a non-point of B (and vice versa)
    for k in eachindex(A)
        ptA[k] || continue
        p = point_coords(compA[k], m)
        any(b -> point_in(b, p, m), Bnp) && push!(out, A[k])
    end
    for k in eachindex(B)
        ptB[k] || continue
        p = point_coords(compB[k], m)
        any(a -> point_in(a, p, m), Anp) && push!(out, B[k])
    end
    # 3) non-point ∩ non-point : RREF, intern result
    for a in Anp, b in Bnp
        rows = rref_aug(vcat(a.rows, b.rows), m)
        rows === nothing && continue
        nonzero_ok(rows, m) || continue
        push!(out, intern!(pool, Affine(rows), L, target, m))
    end
    sort!(out); unique!(out)
    out
end

# ---------------------------------------------------------------- lazy candidate chunks
function candidate_chunks(keys_sorted::Vector{Vector{Int8}}; chunk=2048, buf=64)
    Channel{Vector{Tuple{Vector{Int8},Vector{Int8}}}}(buf; spawn=true) do ch
        cur = Vector{Tuple{Vector{Int8},Vector{Int8}}}(); sizehint!(cur, chunk)
        i = 1; n = length(keys_sorted)
        while i <= n
            pre = @view keys_sorted[i][1:end-1]; j = i
            while j <= n && (@view keys_sorted[j][1:end-1]) == pre; j += 1; end
            for a in i:j-1, b in a+1:j-1
                push!(cur, (keys_sorted[a], keys_sorted[b]))
                if length(cur) == chunk
                    put!(ch, cur); cur = Vector{Tuple{Vector{Int8},Vector{Int8}}}(); sizehint!(cur, chunk)
                end
            end
            i = j
        end
        isempty(cur) || put!(ch, cur)
    end
end

const Level = Dict{Vector{Int8},Vector{Int32}}

function next_level(level::Level, pool::Pool{T}, L, target, m) where T
    keys_sorted = sort!(collect(keys(level)))
    ch = candidate_chunks(keys_sorted)
    ntask = Threads.nthreads()
    locals = [Level() for _ in 1:ntask]; counts = zeros(Int, ntask)
    @sync for t in 1:ntask
        Threads.@spawn begin
            d = locals[t]; c = 0
            for chunkv in ch, (a, b) in chunkv
                c += 1
                sol = intersect_ids(level[a], level[b], pool, L, target, m)
                isempty(sol) && continue
                d[vcat(a, b[end])] = sol
            end
            counts[t] = c
        end
    end
    nxt = Level()
    for d in locals; merge!(nxt, d); empty!(d); end
    nxt, sum(counts)
end

# ---------------------------------------------------------------- binary I/O (ids only)
function write_level(path, level::Level)
    open(path, "w") do io
        write(io, Int64(length(level)))
        for (S, ids) in level
            write(io, Int64(length(S))); write(io, S)
            write(io, Int64(length(ids))); write(io, ids)
        end
    end
end
function read_level_channel(path; buf=4096)
    Channel{Tuple{Vector{Int8},Vector{Int32}}}(buf; spawn=true) do ch
        open(path, "r") do io
            n = read(io, Int64)
            for _ in 1:n
                k = read(io, Int64); S = read!(io, Vector{Int8}(undef, k))
                q = read(io, Int64); ids = read!(io, Vector{Int32}(undef, q))
                put!(ch, (S, ids))
            end
        end
    end
end

# ---------------------------------------------------------------- driver
function enumerate_pooled(inp::CharacterizationInput{T}; outdir="levels", max_level=typemax(Int),
                          log=stdout, time_limit=Inf) where T
    m = nmat(inp); mkpath(outdir)
    L, symmetric = lhs_vectors(inp); n = length(L); target = inp.target
    pool = Pool{T}()
    level = Level()
    for i in 1:n
        ids = Int32[intern!(pool, a, L, target, m) for a in solve_single(L[i], target, m)]
        isempty(ids) || (level[Int8[i]] = sort!(ids))
    end
    write_level(joinpath(outdir, "level_1.bin"), level)
    sizes = Int[length(level)]; njoins = Int[0]; times = Float64[0.0]
    println(log, "LHS vectors: $n (unit group: $symmetric)\nlevel 1: $(length(level))  pool=$(length(pool.comps))"); flush(log)
    k = 1; t_start = time()
    while !isempty(level) && k < max_level && (time() - t_start) < time_limit
        t0 = time()
        nxt, nj = next_level(level, pool, L, target, m)
        k += 1
        write_level(joinpath(outdir, "level_$k.bin"), nxt)
        push!(sizes, length(nxt)); push!(njoins, nj); push!(times, time() - t0)
        println(log, "level $k: $(length(nxt)) nonempty systems (from $nj candidate joins)  [$(round(time()-t0; digits=2)) s]  pool=$(length(pool.comps))  disk=$(round(filesize(joinpath(outdir, "level_$k.bin"))/2^20; digits=1)) MiB  maxrss=$(round(Sys.maxrss()/2^30; digits=2)) GiB"); flush(log)
        level = nxt; GC.gc()
    end
    finished = isempty(level)
    (; L, pool, sizes, njoins, times, nlevels=k, finished, outdir)
end

"""Closure of a system = AND of the λ-bitsets of its components (precomputed once per component)."""
function closure_bits(ids::Vector{Int32}, pool::Pool)
    bits = copy(pool.lams[ids[1]])
    for i in 2:length(ids); bits .&= pool.lams[ids[i]]; end
    bits
end

function closures_pooled(res; log=stdout)
    pool = res.pool
    closed = Dict{Vector{Int},Vector{Int32}}(); lk = ReentrantLock()
    nver = Threads.Atomic{Int}(0)
    for k in 1:res.nlevels
        path = joinpath(res.outdir, "level_$k.bin"); isfile(path) || continue
        t0 = time(); ch = read_level_channel(path)
        @sync for t in 1:Threads.nthreads()
            Threads.@spawn begin
                for (S, ids) in ch
                    bits = closure_bits(ids, pool)
                    all(bits[Int(s)] for s in S) || error("verification failed: S=$S")   # every component satisfies every λ ∈ S
                    Threads.atomic_add!(nver, count(pool.ispoint[i] for i in ids))
                    key = findall(bits)
                    lock(lk) do; haskey(closed, key) || (closed[key] = ids); end
                end
            end
        end
        println(log, "closure level $k: closed so far $(length(closed))  [$(round(time()-t0; digits=2)) s]"); flush(log)
    end
    closed, nver[]
end

function run_pooled(inp::CharacterizationInput{T}; outdir="levels", max_level=typemax(Int), log=stdout, time_limit=Inf) where T
    m = nmat(inp)
    t_en = @elapsed res = enumerate_pooled(inp; outdir, max_level, log, time_limit)
    t_cl = @elapsed (closed, nver) = closures_pooled(res; log)
    t_or = @elapsed begin
        tables = symmetry_group(inp, res.L)
        orbits = Dict{Vector{Int},Vector{Vector{Int}}}()
        for S in keys(closed); push!(get!(orbits, canon_set(S, tables), Vector{Vector{Int}}()), S); end
    end
    npts = count(res.pool.ispoint); ncomp = length(res.pool.comps)
    println(log, "\nnonempty systems: $(sum(res.sizes))   closed systems: $(length(closed))   orbits: $(length(orbits))   finished=$(res.finished)")
    println(log, "pool: $ncomp components ($npts points);  verified $nver point-memberships;  times: enumeration $(round(t_en;digits=2)) s, closure $(round(t_cl;digits=2)) s, orbits $(round(t_or;digits=2)) s"); flush(log)
    (; res, closed, orbits, nver, timings=(enumeration=t_en, closure=t_cl, orbits=t_or))
end

end # module Pooled


# ======================================================================
#  GroupStream: fully disk-streamed level construction.  RAM = O(one prefix
#  group + I/O buffers); level files are sorted and read sequentially; the
#  next level is written as it is produced.  Closure keys are UInt64 masks.
# ======================================================================
module GroupStream
using ..TripotentLC: CharacterizationInput, nmat, lhs_vectors, solve_single, symmetry_group
using ..Pooled: Pool, intern!, intersect_ids, Level

const Rec = Tuple{Vector{Int8},Vector{Int32}}

function write_header!(io, n::Int); seekstart(io); write(io, Int64(n)); end
function write_rec(io, S::Vector{Int8}, ids::Vector{Int32})
    write(io, Int64(length(S))); write(io, S); write(io, Int64(length(ids))); write(io, ids)
end
function write_sorted_level(path, level::Level)
    ks = sort!(collect(keys(level)))
    open(path, "w") do io
        write(io, Int64(length(ks)))
        for S in ks; write_rec(io, S, level[S]); end
    end
end
"""Sequential reader → Channel of prefix GROUPS (records sharing the first k-1 indices)."""
function group_channel(path; buf=512)
    Channel{Vector{Rec}}(buf; spawn=true) do ch
        open(path, "r") do io
            n = read(io, Int64); grp = Rec[]
            for _ in 1:n
                k = read(io, Int64); S = read!(io, Vector{Int8}(undef, k))
                q = read(io, Int64); ids = read!(io, Vector{Int32}(undef, q))
                if !isempty(grp) && (@view grp[1][1][1:end-1]) != (@view S[1:end-1])
                    put!(ch, grp); grp = Rec[]
                end
                push!(grp, (S, ids))
            end
            isempty(grp) || put!(ch, grp)
        end
    end
end

"""Build level k+1 file from level k file.  Workers process groups; a single writer
emits results in group order so the output stays sorted."""
function next_level_file(path_in, path_out, pool::Pool{T}, L, target, m) where T
    groups = group_channel(path_in)
    results = Channel{Tuple{Int,Vector{Rec},Int}}(1024)          # (seq, records, njoins)
    seqch = Channel{Tuple{Int,Vector{Rec}}}(1024; spawn=true) do c   # number the groups
        s = 0
        for g in groups; s += 1; put!(c, (s, g)); end
    end
    ntask = Threads.nthreads()
    workers = @async begin
        try
            @sync for t in 1:ntask
                Threads.@spawn for (seq, g) in seqch
                    out = Rec[]; nj = 0
                    for i in 1:length(g), j in i+1:length(g)
                        nj += 1
                        sol = intersect_ids(g[i][2], g[j][2], pool, L, target, m)
                        isempty(sol) && continue
                        push!(out, (vcat(g[i][1], g[j][1][end]), sol))
                    end
                    put!(results, (seq, out, nj))
                end
            end
            close(results)
        catch err
            close(results, err)          # a worker failure terminates the consumer loop with the error instead of a hang
            rethrow()
        end
    end
    nrec = 0; njoins = 0
    open(path_out, "w") do io
        write(io, Int64(0))                                   # placeholder count
        pending = Dict{Int,Tuple{Vector{Rec},Int}}(); nextseq = 1
        for (seq, out, nj) in results
            pending[seq] = (out, nj)
            while haskey(pending, nextseq)
                o, j = pop!(pending, nextseq)
                for (S, ids) in o; write_rec(io, S, ids); end
                nrec += length(o); njoins += j; nextseq += 1
            end
        end
        write_header!(io, nrec)
    end
    wait(workers)
    nrec, njoins
end

function enumerate_stream(inp::CharacterizationInput{T}; outdir="levels", max_level=typemax(Int),
                          log=stdout, time_limit=Inf) where T
    m = nmat(inp); mkpath(outdir)
    L, symmetric = lhs_vectors(inp); n = length(L); target = inp.target
    pool = Pool{T}()
    level = Level()
    for i in 1:n
        ids = Int32[intern!(pool, a, L, target, m) for a in solve_single(L[i], target, m)]
        isempty(ids) || (level[Int8[i]] = sort!(ids))
    end
    write_sorted_level(joinpath(outdir, "level_1.bin"), level)
    sizes = Int[length(level)]; njoins = Int[0]; times = Float64[0.0]
    println(log, "LHS vectors: $n (unit group: $symmetric)\nlevel 1: $(length(level))"); flush(log)
    k = 1; t_start = time()
    while sizes[end] > 0 && k < max_level && (time() - t_start) < time_limit
        t0 = time()
        nrec, nj = next_level_file(joinpath(outdir, "level_$k.bin"), joinpath(outdir, "level_$(k+1).bin"), pool, L, target, m)
        k += 1
        push!(sizes, nrec); push!(njoins, nj); push!(times, time() - t0)
        println(log, "level $k: $nrec nonempty systems (from $nj candidate joins)  [$(round(time()-t0; digits=2)) s]  pool=$(length(pool.comps))  disk=$(round(filesize(joinpath(outdir, "level_$k.bin"))/2^20; digits=1)) MiB  maxrss=$(round(Sys.maxrss()/2^30; digits=2)) GiB"); flush(log)
        GC.gc()
    end
    finished = sizes[end] == 0            # exhaustive only if the last level is empty (not when max_level/time_limit stopped it)
    (; L, pool, sizes, njoins, times, nlevels=k, finished, outdir)
end

# ---------------------------------------------------------------- closure as UInt64 masks
function lam_masks(pool::Pool)
    [begin msk = UInt64(0); for (i, b) in enumerate(bits); b && (msk |= UInt64(1) << (i-1)); end; msk end for bits in pool.lams]
end
"""Stream all level files; closure(S) = AND of component masks; keep distinct masks (+ one id list each)."""
function closures_stream(res; log=stdout)
    length(res.L) <= 64 || error("UInt64 closure masks support at most 64 LHS vectors (got $(length(res.L)))")
    masks = lam_masks(res.pool); ispoint = res.pool.ispoint
    closed = Dict{UInt64,Vector{Int32}}(); lk = ReentrantLock(); nver = Threads.Atomic{Int}(0)
    for k in 1:res.nlevels
        path = joinpath(res.outdir, "level_$k.bin"); isfile(path) || continue
        t0 = time()
        recs = Channel{Vector{Rec}}(256; spawn=true) do c      # chunks of records
            open(path, "r") do io
                n = read(io, Int64); buf = Rec[]
                for _ in 1:n
                    kk = read(io, Int64); S = read!(io, Vector{Int8}(undef, kk))
                    q = read(io, Int64); ids = read!(io, Vector{Int32}(undef, q))
                    push!(buf, (S, ids))
                    if length(buf) == 4096; put!(c, buf); buf = Rec[]; end
                end
                isempty(buf) || put!(c, buf)
            end
        end
        @sync for t in 1:Threads.nthreads()
            Threads.@spawn begin
                local_new = Dict{UInt64,Vector{Int32}}(); np = 0
                for chunk in recs, (S, ids) in chunk
                    msk = typemax(UInt64)
                    for i in ids; msk &= masks[i]; end
                    for s in S; (msk >> (Int(s)-1)) & 1 == 1 || error("verification failed S=$S"); end
                    np += count(ispoint[i] for i in ids)
                    haskey(local_new, msk) || (local_new[msk] = ids)
                end
                Threads.atomic_add!(nver, np)
                lock(lk) do; for (kk, v) in local_new; haskey(closed, kk) || (closed[kk] = v); end; end
            end
        end
        println(log, "closure level $k: closed so far $(length(closed))  [$(round(time()-t0; digits=2)) s]"); flush(log)
    end
    closed, nver[]
end

# ---------------------------------------------------------------- orbits on masks (byte LUT)
function mask_tables(inp, L)
    tabs = symmetry_group(inp, L); n = length(L)
    # per table, per byte position b (0..7), per byte value v: permuted mask contribution
    luts = Vector{Matrix{UInt64}}(undef, length(tabs))
    for (ti, tab) in enumerate(tabs)
        lut = zeros(UInt64, 8, 256)
        for b in 0:7, v in 0:255
            acc = UInt64(0)
            for bit in 0:7
                (v >> bit) & 1 == 1 || continue
                i = 8b + bit + 1; i <= n || continue
                acc |= UInt64(1) << (tab[i] - 1)
            end
            lut[b+1, v+1] = acc
        end
        luts[ti] = lut
    end
    luts
end
@inline function apply_lut(lut::Matrix{UInt64}, msk::UInt64)
    acc = UInt64(0)
    @inbounds for b in 0:7
        v = (msk >> (8b)) & 0xff
        acc |= lut[b+1, Int(v)+1]
    end
    acc
end
function orbits_stream(closed, inp, L)
    luts = mask_tables(inp, L)
    ks = collect(keys(closed))
    canon = Vector{UInt64}(undef, length(ks))
    Threads.@threads :dynamic for idx in eachindex(ks)
        msk = ks[idx]; best = msk
        for lut in luts; c = apply_lut(lut, msk); c < best && (best = c); end
        canon[idx] = best
    end
    orbits = Dict{UInt64,Vector{UInt64}}()
    for (idx, k) in enumerate(ks); push!(get!(orbits, canon[idx], UInt64[]), k); end
    orbits
end
mask_to_set(msk::UInt64) = [i for i in 1:64 if (msk >> (i-1)) & 1 == 1]

function run_stream(inp::CharacterizationInput{T}; outdir="levels", max_level=typemax(Int), log=stdout, time_limit=Inf) where T
    t_en = @elapsed res = enumerate_stream(inp; outdir, max_level, log, time_limit)
    t_cl = @elapsed (closed, nver) = closures_stream(res; log)
    t_or = @elapsed orbits = orbits_stream(closed, inp, res.L)
    npts = count(res.pool.ispoint)
    println(log, "\nnonempty systems: $(sum(res.sizes))   closed systems: $(length(closed))   orbits: $(length(orbits))   finished=$(res.finished)")
    println(log, "pool: $(length(res.pool.comps)) components ($npts points);  verified $nver point-memberships;  times: enumeration $(round(t_en;digits=2)) s, closure $(round(t_cl;digits=2)) s, orbits $(round(t_or;digits=2)) s"); flush(log)
    (; res, closed, orbits, nver, timings=(enumeration=t_en, closure=t_cl, orbits=t_or))
end
end # module GroupStream

end # module
