# Loads the package sources relative to this file, so that every script runs from a clean clone
# regardless of the working directory:  julia -t 12 scripts/<script>.jl
# (the symbolic scripts additionally need AbstractAlgebra:  julia --project=scripts/symbolic scripts/<script>.jl)
const _SRC = joinpath(@__DIR__, "..", "src")
include(joinpath(_SRC, "engine.jl"))
include(joinpath(_SRC, "fields.jl"))
include(joinpath(_SRC, "theorems.jl"))
include(joinpath(_SRC, "groups_writer.jl"))
using .TripotentLC, .Theorems, .Groups
