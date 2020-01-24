module ImplicitArrays

include("block.jl")
export BlockMatrix

include("interaction.jl")
export InteractionMatrix

include("fixedvalue.jl")
export FixedValueArray

include("rowprojection.jl")
export RowProjectionMatrix, RowProjectionVector

end # module
