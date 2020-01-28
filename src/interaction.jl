# TODO
struct InteractionMatrix{T, R, C} <: AbstractArray{T, 2}
    rowelems::Array{R, 1}
    colelems::Array{C, 1}
    interact::Function

    InteractionMatrix(
        ::Type{T},
        rowelems::AbstractArray{R, 1},
        colelems::AbstractArray{C, 1},
        interact::Function
    ) where {T, R, C} = new{T, R, C}(collect(rowelems), collect(colelems), interact)
end

@inline Base.size(
    A::InteractionMatrix{T}
) where T = (length(A.rowelems), length(A.colelems))

@inline Base.getindex(
    A::InteractionMatrix{T},
    I::Vararg{Int, 2}
) where T = A.interact(A.rowelems[I[1]], A.colelems[I[2]])::T

@inline Base.setindex!(
    A::InteractionMatrix{T},
    ::Any,
    ::Int
) where T = error("setindex! not defined for ", typeof(A))
