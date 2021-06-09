using CommonGameFinder
using Test
using Memento
using Memento.TestUtils: @test_log, @test_nolog

# Todo: make a different logger for tests than main code
const LOGGER = getlogger("BidDatabase")

@testset "All Tests" begin
    include("hello.jl")
end # All Tests
