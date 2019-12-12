module ImplicitArrays

include("fixedvalue.jl")
export FixedValueArray, FixedValueDiagonal

include("rowprojection.jl")
export RowProjectionMatrix, RowProjectionVector

end # module
