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


@testset "exhaustive flag and partial reports (review item 4)" begin
    inp = CMS.problem([CMS.TRIPOTENT for _ in 1:3], CMS.TRIPOTENT)
    r1 = run_characterization(inp; verbose=false, max_level=1)
    @test r1.exhaustive == false && length(r1.orbits) == 3
    @test run_characterization(inp; verbose=false).exhaustive == true
    p = tempname(); write_report(p, r1, inp); @test occursin("PARTIAL", read(p, String))
end

@testset "zero-only spectra and duplicated spectrum elements (review items 7, 8)" begin
    r = run_characterization(CMS.problem([Q[1], Q[1]], Q[0]); verbose=false)      # c1 + c2 = 0
    @test length(r.all_systems) == 1 && length(r.orbits) == 1
    r = run_characterization(CMS.problem([Q[0], Q[1]], Q[1]); verbose=false)      # c2 = 1
    @test length(r.all_systems) == 1 && length(r.orbits) == 1
    inp = CMS.problem([Q[1, 1]], Q[1]); r = run_characterization(inp; verbose=false)
    @test length(r.all_systems) == 1; write_report(tempname(), r, inp)
end

@testset "Eis hash is consistent with isequal (review item 9)" begin
    @test isequal(Eis(1), 1) && hash(Eis(1)) == hash(1) && hash(Eis(0)) == hash(0)
    @test 1 in Set(CMS.QUADRIPOTENT) && 0 in Set(CMS.QUADRIPOTENT)
    @test Dict{Any,Int}(Eis(1) => 42)[1] == 42
end

@testset "LaTeX: composite coefficients are parenthesised (review item 1)" begin
    a = CMS.TripotentLC.Affine([[Eis(1), Eis(0), Eis(1) + 2ω, Eis(0)]])      # row  c1 + (1+2ω) c3  (augmented, m = 3)
    s = CMS.Theorems.tex_affine(a, 3)[1]
    @test occursin("(1+2\\omega) c_3", s) && !occursin("+1+2", s)
end

@testset "groups writer runs under the package namespace (review item 6)" begin
    inp = CMS.problem([CMS.INVOLUTIVE for _ in 1:4], CMS.TRIPOTENT)
    r = run_characterization(inp; verbose=false)
    g = CMS.Groups.groups_from_result(r, inp)
    @test length(g) == 14
end

@testset "GroupStream: a worker error propagates instead of hanging (review item 5)" begin
    inp = CMS.problem([Q[10_000_000 + i, 1] for i in 1:3], Q[1, 2])
    threw = Ref(false)
    try CMS.TripotentLC.GroupStream.run_stream(inp; outdir=mktempdir(), log=devnull, time_limit=5.0) catch; threw[] = true end
    @test threw[]
end

println(FAILS[] == 0 ? "all tests passed" : "$(FAILS[]) test(s) failed"); exit(FAILS[] == 0 ? 0 : 1)
