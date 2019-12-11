using ImplicitArrays
using Test

@testset "ImplicitArrays.jl" begin
    @testset "FixedValueArray" begin
        include("fixedvalue.jl")
        include("rowprojection.jl")
    end
end
