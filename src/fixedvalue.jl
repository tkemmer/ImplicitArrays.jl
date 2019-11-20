# TODO
struct FixedValueArray{T, N} <: AbstractArray{T, N}
    val::T
    dims::NTuple{N, Int}
end

FixedValueArray(val::T, dims::Int...) where T = FixedValueArray(val, dims)

@inline Base.size(a::FixedValueArray{T, N}) where {T, N} = a.dims

@inline function Base.getindex(a::FixedValueArray{T, N}, i::Int) where {T, N}
    @boundscheck checkbounds(a, i)
    a.val
end

@inline function Base.getindex(a::FixedValueArray{T, N}, I::Vararg{Int, N}) where {T, N}
    @boundscheck checkbounds(a, I...)
    a.val
end
