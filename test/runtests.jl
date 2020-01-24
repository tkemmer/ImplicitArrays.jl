using ImplicitArrays
using Test

@testset "ImplicitArrays.jl" begin
    @testset "InteractionMatrix" begin include("interaction.jl") end
    @testset "FixedValueArray" begin include("fixedvalue.jl") end
    @testset "RowProjectionMatrix" begin include("rowprojection.jl") end
end
