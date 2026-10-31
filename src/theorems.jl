
# theorems.jl — turn a TripotentLC.Result into LaTeX theorem items (block-form matrix conditions).
# Each characteristic = G-orbit of a closed system without zero columns; representative = canonical member.
module Theorems
using ..TripotentLC
using ..TripotentLC: Affine, dim, closure, canon_set, symmetry_group

# ---------- number formatting ----------
texnum(x::Rational) = denominator(x) == 1 ? string(numerator(x)) :
    (numerator(x) < 0 ? "-" : "") * "\\tfrac{$(abs(numerator(x)))}{$(denominator(x))}"
texnum(x::Integer) = string(x)
# Eis a + b√3 i  = (a+b) + 2b·ω   (ω = -1/2 + √3 i/2)
function texnum(x)   # fallback: Eis or symbolic; Eis handled via fields a,b if present
    if hasproperty(x, :a) && hasproperty(x, :b)
        p = x.a + x.b; q = 2 * x.b
        iszero(q) && return texnum(p)
        if p == q                      # p(1+ω) = -p ω²
            s = texnum(-p); return (s == "1" ? "" : s == "-1" ? "-" : s) * "\\omega^2"
        end
        qs = q == 1 ? "" : q == -1 ? "-" : texnum(q)
        iszero(p) && return qs * "\\omega"
        return texnum(p) * (q > 0 ? "+" : "") * qs * "\\omega"
    end
    return texsym(string(x))
end
# symbolic rational functions printed by AbstractAlgebra:  "(-α2*α + β2*α)//(α1*β2 - β1*α2)"
function texsym(s::String)
    s = replace(s, r"α(\d)" => s"\\alpha_\1"); s = replace(s, r"β(\d)" => s"\\beta_\1"); s = replace(s, r"γ(\d)" => s"\\gamma_\1")
    s = replace(s, "α" => "\\alpha "); s = replace(s, "β" => "\\beta "); s = replace(s, "γ" => "\\gamma "); s = replace(s, "*" => " ")
    if occursin("//", s)
        num, den = split(s, "//"; limit=2)
        strip_par(t) = (t = strip(t); startswith(t, "(") && endswith(t, ")") ? t[2:end-1] : t)
        return "\\frac{" * strip_par(num) * "}{" * strip_par(den) * "}"
    end
    return s
end

# ---------- solution-set formatting ----------
function sol_point(a::Affine, m)
    c = Vector{Any}(undef, m)
    for row in a.rows; j = findfirst(!iszero, @view row[1:m]); c[j] = row[m+1]; end
    c
end
first_nonzero_sign(c) = (k = findfirst(!iszero, c); k === nothing ? 1 : (real(c[k]) < 0 ? -1 : 1))
function tex_affine(a::Affine, m)
    eqs = String[]
    for row in a.rows
        terms = String[]
        for j in 1:m
            iszero(row[j]) && continue
            coef = row[j] == 1 ? "" : (row[j] == -1 ? "-" : texnum(row[j]))
            push!(terms, (isempty(terms) || startswith(coef, "-") ? "" : "+") * (coef == "" ? "" : coef * " ") * "c_$j")
        end
        push!(eqs, join(terms))
    end
    eqs
end
"""Group affine components with the same coefficient rows: (expr_1,…,expr_r) ∈ {rhs tuples}."""
function tex_subspaces(subs, m; pm=false, units=nothing)
    groups = Dict{Any,Vector{Any}}()
    for a in subs
        key = [row[1:m] for row in a.rows]
        push!(get!(groups, key, Any[]), [row[m+1] for row in a.rows])
    end
    out = String[]
    for key in sort(collect(keys(groups)); by=string)
        exprs = tex_affine(Affine([vcat(k, zero(k[1])) for k in key]), m)
        rhs = groups[key]
        if pm; rhs = [b for b in rhs if first_nonzero_sign(b) >= 0 && (any(!iszero, b) || true)]
            rhs = unique([first_nonzero_sign(b) > 0 ? b : b for b in rhs]); rhs = [b for b in rhs if first_nonzero_sign(b) > 0 || all(iszero, b)]
        elseif units !== nothing && length(units) > 1
            rhs = unique([maximum(u .* b for u in units) for b in rhs])
        end
        sort!(rhs; by=string)
        pref = pm ? "\\pm" : (units !== nothing && length(units) > 1 ? "U\\cdot" : "")
        lhs = length(exprs) == 1 ? exprs[1] : "(" * join(exprs, ",\\ ") * ")"
        rhss = length(exprs) == 1 ? join(texnum.(first.(rhs)), ",") : join(["(" * join(texnum.(b), ",") * ")" for b in rhs], ",\\ ")
        push!(out, lhs * "\\in " * pref * "\\{" * rhss * "\\}")
    end
    out
end
"""LaTeX for the solution set of a closed system; `pm` = list one of each ±pair with a ± sign."""
function tex_solutions(sol, m; pm::Bool=false, units=nothing)
    pts = [a for a in sol if dim(a, m) == 0]; subs = [a for a in sol if dim(a, m) > 0]
    out = String[]
    if !isempty(pts)
        cs = [sol_point(a, m) for a in pts]
        if pm
            cs = [c for c in cs if first_nonzero_sign(c) > 0]
        elseif units !== nothing && length(units) > 1
            # keep one representative per U-orbit (lexicographic max under the field's isless)
            cs = unique(c -> maximum(u .* c for u in units), cs); cs = [maximum(u .* c for u in units) for c in cs]
        end
        sort!(cs; by=string)
        pref = pm ? "\\pm" : (units !== nothing && length(units) > 1 ? "U\\cdot" : "")
        push!(out, "(c_1,\\dots,c_$m)\\in " * pref * "\\{" * join(["(" * join(texnum.(c), ",") * ")" for c in cs], ",\\ ") * "\\}")
    end
    append!(out, tex_subspaces(subs, m; pm, units))
    join(out, " \\text{ or } ")
end

# ---------- pattern matrix ----------
tex_pattern(L, S, m) = "\\begin{bmatrix}" * join([join(texnum.(L[s]), "&") for s in S], "\\\\") * "\\end{bmatrix}"

# ---------- minimal generating set size of a closed system ----------
function min_generating_size(C, closed_sol, single, m)
    k = length(C)
    for s in 1:k
        for sub in combinations_(C, s)
            sol = reduce((A, B) -> TripotentLC.intersect_sets(A, B, m), (single[i] for i in sub))
            sol == closed_sol && return s
        end
    end
    k
end
function combinations_(v, s)
    n = length(v); out = Vector{Vector{eltype(v)}}()
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

"""characteristics(r, inp; m) -> vector of named tuples sorted by (#blocks, pattern); zero-column orbits dropped."""
function characteristics(r, inp)
    m = length(inp.spectra); L = r.L
    single = [TripotentLC.solve_single(L[i], inp.target, m) for i in 1:length(L)]
    out = []
    for (S, members) in r.orbits
        all(i -> any(s -> !iszero(L[s][i]), S), 1:m) || continue       # zero column -> T_i = 0
        sol = r.closed[S]
        g = min_generating_size(S, sol, single, m)
        push!(out, (S=S, members=members, sol=sol, gen=g, nblocks=length(S)))
    end
    # order: number of blocks, then the patterns in the product order of the spectra (last coordinate fastest),
    # which reproduces the item order of Kişi et al. (2021) for the cubic problem
    pos(λ) = [findfirst(==(λ[i]), inp.spectra[i]) for i in 1:m]
    sort!(out; by=x -> (x.nblocks, sort([pos(L[s]) for s in x.S])))
    out
end

"""Write theorem items. label = letter prefix (e.g. "d"); mprev = 2021 scope (k ≤ m) marker."""
function write_theorem(path, r, inp; label="d", pm=false, units=nothing, symbol="T", mprev=length(inp.spectra), preamble="")
    m = length(inp.spectra); chars = characteristics(r, inp)
    open(path, "w") do io
        println(io, preamble)
        println(io, "\\begin{enumerate}")
        for (k, ch) in enumerate(chars)
            tag = ch.gen <= mprev ? "" : "\\,\\newitem"
            println(io, "\\item[($label$k)$tag] \$", tex_solutions(ch.sol, m; pm, units), "\$ and \$P=", tex_pattern(r.L, ch.S, m), "\$;")
        end
        println(io, "\\end{enumerate}")
    end
    open(replace(path, ".tex" => ".map"), "w") do io
        for (k, ch) in enumerate(chars)
            println(io, label, k, "\t", join(["[" * join(string.(r.L[s]), ",") * "]" for s in ch.S], ";"), "\t", ch.gen, "\t", length(ch.members))
        end
    end
    nnew = count(ch -> ch.gen > mprev, chars)
    println(path, ": ", length(chars), " items, ", nnew, " new (min generating set > $mprev), by #blocks ",
            sort(collect(Dict(k => count(c -> c.nblocks == k, chars) for k in unique(c.nblocks for c in chars)))))
    chars
end
end # module
