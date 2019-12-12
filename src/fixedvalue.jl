# TODO
struct FixedValueArray{T, N} <: AbstractArray{T, N}
    val::T
    dims::NTuple{N, Int}
end

FixedValueArray(val::T, dims::Int...) where T = FixedValueArray(val, dims)

@inline Base.size(A::FixedValueArray{T, N}) where {T, N} = A.dims

@inline function Base.getindex(A::FixedValueArray{T, N}, i::Int) where {T, N}
    @boundscheck checkbounds(A, i)
    A.val
end

@inline function Base.getindex(A::FixedValueArray{T, N}, I::Vararg{Int, N}) where {T, N}
    @boundscheck checkbounds(A, I...)
    A.val
end

@inline function Base.setindex!(A::FixedValueArray{T, N}, ::Any, ::Int) where {T, N}
    error("setindex! not defined for ", typeof(A))
end

# This one is required to have setindex! at index [] throw an ErrorException instead
# of a BoundsError (which is used for all other indices).
@inline function Base.setindex!(A::FixedValueArray, ::Any, ::Vararg{Int, N}) where N
    error("setindex! not defined for ", typeof(A))
end
