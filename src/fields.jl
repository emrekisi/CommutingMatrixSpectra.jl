
# fields.jl — exact number fields beyond Q for CommutingMatrixSpectra
# Eisenstein rationals Q(√-3) = Q(ω), ω = -1/2 + (√3/2)i.  Element a + b·√3·i, a,b ∈ Q.
# Complex{Rational} (Gaussian rationals Q(i)) CANNOT represent ω: z²+z+1 = 0 has no root in Q(i).
struct Eis <: Number
    a::Rational{Int64}   # rational part
    b::Rational{Int64}   # coefficient of √3·i
end
Eis(a::Union{Integer,Rational}) = Eis(Rational{Int64}(a), 0//1)
const ω = Eis(-1//2, 1//2)
Base.promote_rule(::Type{Eis}, ::Type{<:Union{Integer,Rational{<:Integer}}}) = Eis
Base.convert(::Type{Eis}, x::Union{Integer,Rational}) = Eis(x)
Base.:+(x::Eis, y::Eis) = Eis(x.a + y.a, x.b + y.b)
Base.:-(x::Eis, y::Eis) = Eis(x.a - y.a, x.b - y.b)
Base.:-(x::Eis) = Eis(-x.a, -x.b)
Base.:*(x::Eis, y::Eis) = Eis(x.a * y.a - 3 * x.b * y.b, x.a * y.b + x.b * y.a)   # (√3i)² = -3
function Base.inv(x::Eis)
    n = x.a^2 + 3 * x.b^2            # norm, > 0 for x ≠ 0
    Eis(x.a / n, -x.b / n)
end
Base.:/(x::Eis, y::Eis) = x * inv(y)
Base.:(==)(x::Eis, y::Eis) = x.a == y.a && x.b == y.b
Base.hash(x::Eis, h::UInt) = iszero(x.b) ? hash(x.a, h) : hash(x.b, hash(x.a, h))   # consistent with hash of equal Rational/Integer values
Base.iszero(x::Eis) = iszero(x.a) && iszero(x.b)
Base.isone(x::Eis) = isone(x.a) && iszero(x.b)
Base.zero(::Type{Eis}) = Eis(0//1, 0//1);  Base.one(::Type{Eis}) = Eis(1//1, 0//1)
Base.isless(x::Eis, y::Eis) = isless((x.a, x.b), (y.a, y.b))      # total order (lexicographic), for canonical forms
Base.real(x::Eis) = x.a
fq(r::Rational) = denominator(r) == 1 ? string(numerator(r)) : string(numerator(r), "/", denominator(r))
function Base.show(io::IO, x::Eis)
    if iszero(x.b); print(io, fq(x.a))
    elseif iszero(x.a); print(io, x.b == 1 ? "" : x.b == -1 ? "-" : fq(x.b) * "·", "√3i")
    else; print(io, fq(x.a), x.b < 0 ? " - " : " + ", abs(x.b) == 1 ? "" : fq(abs(x.b)) * "·", "√3i"); end
end

# coefficient formatting inside linear equations: wrap two-term elements in parentheses
if @isdefined(TripotentLC)
    TripotentLC.fmtq(x::Eis) = (iszero(x.a) || iszero(x.b)) ? string(x) : "(" * string(x) * ")"
end
