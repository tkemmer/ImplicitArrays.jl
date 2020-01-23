module ImplicitArrays

include("interaction.jl")
export InteractionMatrix

include("fixedvalue.jl")
export FixedValueArray

include("rowprojection.jl")
export RowProjectionMatrix, RowProjectionVector

end # module
