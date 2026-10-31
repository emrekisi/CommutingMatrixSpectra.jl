
using AbstractAlgebra
include("TripotentLC.jl"); include("fields.jl"); include("theorems.jl"); using .TripotentLC, .Theorems
Rp, (α1, β1, γ1, α2, β2, γ2, α, β, γ) = polynomial_ring(QQ, ["α1","β1","γ1","α2","β2","γ2","α","β","γ"]); F = fraction_field(Rp); const T = elem_type(F)
hasmethod(isless, Tuple{T,T}) || (Base.isless(a::T, b::T) = isless(string(a), string(b)))
inp = CharacterizationInput([F.([α1,β1,γ1]), F.([α2,β2,γ2])], F.([α,β,γ])); r = run_characterization(inp; verbose=false)
Theorems.write_theorem("thm_2cubic.tex", r, inp; label="a", symbol="X")
