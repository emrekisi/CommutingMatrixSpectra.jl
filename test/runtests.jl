# Dependency-free checks (the Test stdlib needs many minutes of precompilation on a cold depot;
# the package has no dependencies, so the tests have none either).
const FAILS = Ref(0)
macro test(ex); :( ($(esc(ex))) ? nothing : (FAILS[] += 1; println("FAILED: ", $(string(ex)))) ); end
macro testset(name, blk); :( (println("-- ", $(esc(name))); $(esc(blk))) ); end
include(joinpath(@__DIR__, "..", "src", "CommutingMatrixSpectra.jl"))
using .CommutingMatrixSpectra
const CMS = CommutingMatrixSpectra
const Q = Rational{Int64}

@testset "Q(ω) arithmetic" begin
    @test ω^3 == Eis(1)
    @test iszero(ω^2 + ω + 1)
    @test inv(ω) == ω^2
end

@testset "three tripotents (Kişi et al. 2021, Problem 3) — full overdetermined analysis" begin
    inp = CMS.problem([CMS.TRIPOTENT for _ in 1:3], CMS.TRIPOTENT)
    L, U = lhs_vectors(inp)
    @test length(L) == 13 && U == Q[-1, 1]
    r = run_characterization(inp; verbose=false)
    @test length(r.all_systems) == 1899
    @test length(r.closed) == 582
    @test length(r.orbits) == 53
    nz = count(S -> all(i -> any(s -> !iszero(r.L[s][i]), S), 1:3), keys(r.orbits))
    @test nz == 47
    @test maximum(length, keys(r.all_systems)) == 9
end

@testset "two quadripotents (2021, Problem 2)" begin
    inp = CMS.problem([CMS.QUADRIPOTENT, CMS.QUADRIPOTENT], CMS.QUADRIPOTENT)
    L, U = lhs_vectors(inp)
    @test length(L) == 5 && length(U) == 3
    r = run_characterization(inp; verbose=false)
    @test length(r.all_systems) == 15 && length(r.orbits) == 5
    @test maximum(length, keys(r.all_systems)) == 2      # no overdetermined solutions
end

println(FAILS[] == 0 ? "all tests passed" : "$(FAILS[]) test(s) failed"); exit(FAILS[] == 0 ? 0 : 1)
