abstract type InteractionFunction{R, C, T} end

#struct LDiv <: InteractionFunction{Int, Int, Float64} end
#(::LDiv)(x::Int, y::Int) = x \ y

struct ConstInteractionFunction{R, C, T} <: InteractionFunction{R, C, T}
    val::T
end
(f::ConstInteractionFunction{R, C, T})(x::R, y::C) where {R, C, T} = f.val

struct GenericInteractionFunction{R, C, T} <: InteractionFunction{R, C, T}
    f::Function
end
(f::GenericInteractionFunction{R, C, T})(x::R, y::C) where {R, C, T} = f.f(x, y)::T

# TODO
struct InteractionMatrix{T, R, C, F <: InteractionFunction{R, C, T}} <: AbstractArray{T, 2}
    rowelems::Array{R, 1}
    colelems::Array{C, 1}
    interact::F

    @inline function InteractionMatrix(
        rowelems::AbstractArray{R, 1},
        colelems::AbstractArray{C, 1},
        interact::F
    ) where {T, R, C, F <: InteractionFunction{R, C, T}}
        new{T, R, C, F}(collect(rowelems), collect(colelems), interact)
    end
end

@inline InteractionMatrix{T}(
    rowelems::AbstractArray{R, 1},
    colelems::AbstractArray{C, 1},
    interact::Function
) where {T, R, C} = InteractionMatrix(
    rowelems,
    colelems,
    GenericInteractionFunction{R, C, T}(interact)
)

@inline InteractionMatrix(
    rowelems::AbstractArray{R, 1},
    colelems::AbstractArray{C, 1},
    val::T
) where {T, R, C} = InteractionMatrix(
    rowelems,
    colelems,
    ConstInteractionFunction{R, C, T}(val)
)

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
