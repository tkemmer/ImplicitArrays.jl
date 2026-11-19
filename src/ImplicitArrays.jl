module ImplicitArrays

include("block.jl")
export BlockMatrix

include("interaction.jl")
export ConstInteractionFunction, GenericInteractionFunction, InteractionArray,
    InteractionFunction, InteractionMatrix

include("fixedvalue.jl")
export FixedValueArray

include("rowprojection.jl")
export RowProjectionMatrix, RowProjectionVector

end # module
