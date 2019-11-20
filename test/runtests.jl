using FancyArrays
using Test

@testset "FancyArrays.jl" begin
    @testset "FixedValueArray" begin
        include("fixedvalue.jl")
    end
end
