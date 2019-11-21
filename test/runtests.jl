using FancyArrays
using Test

@testset "FancyArrays.jl" begin
    @testset "FixedValueArray" begin
        include("fixedvalue.jl")
        include("rowprojection.jl")
    end
end
