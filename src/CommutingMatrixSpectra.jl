module CommutingMatrixSpectra

# Exact characterization of when a linear combination  X = Σ c_i X_i  of mutually commuting
# diagonalizable matrices has spectrum inside a prescribed set.  Only Base Julia is used:
# exact arithmetic over Q (Rational{Int64}) and Q(ω) (fields.jl); no external packages.

include("engine.jl")          # modules TripotentLC (reference, RAM), Streamed, Pooled, GroupStream (disk-streamed, parallel)
include("fields.jl")          # Eis = Q(√-3) = Q(ω) for quadripotent problems

using .TripotentLC: CharacterizationInput, run_characterization, write_report, lhs_vectors, unit_group
export CharacterizationInput, run_characterization, write_report, lhs_vectors, unit_group, Eis, ω

const TRIPOTENT   = Rational{Int64}[1, -1, 0]
const INVOLUTIVE  = Rational{Int64}[1, -1]
const IDEMPOTENT  = Rational{Int64}[1, 0]
const QUADRIPOTENT = Eis[ω, ω^2, Eis(1), Eis(0)]

"""problem(spectra, target) — convenience constructor, e.g. problem([TRIPOTENT, TRIPOTENT, TRIPOTENT], TRIPOTENT)."""
problem(spectra, target) = CharacterizationInput(collect(spectra), target)

end # module
