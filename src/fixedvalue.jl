"""
    FixedValueArray{T, N} <: AbstractArray{T, N}

Implicit and arbitrarily-sized array with a common value of type `T` for all elements.

# Constructors
    FixedValueArray(val, dims)
    FixedValueArray(val, dims...)

Create a new matrix of the given dimensions `dims`, where each element is represented
by the given value `val`.

# Examples

```jldoctest; setup = :(using ImplicitArrays)
julia> FixedValueArray(0, (2, 5))
2×5 FixedValueArray{Int64, 2}:
 0  0  0  0  0
 0  0  0  0  0

julia> FixedValueArray("(^_^) Hi!", 1, 2)
1×2 FixedValueArray{String, 2}:
 "(^_^) Hi!"  "(^_^) Hi!"

julia> FixedValueArray(FixedValueArray(5.0, (1, 2)), (1, 3))
1×3 FixedValueArray{FixedValueArray{Float64, 2}, 2}:
 [5.0 5.0]  [5.0 5.0]  [5.0 5.0]

julia> length(FixedValueArray(1, 1_000_000_000, 1_000_000_000))
1000000000000000000
```
"""
struct FixedValueArray{T, N} <: AbstractArray{T, N}
    "Value representing all matrix elements"
    val::T
    "Array dimensions"
    dims::NTuple{N, Int}
end

@inline FixedValueArray(val::Any, dims::Int...) = FixedValueArray(val, dims)

@inline Base.size(A::FixedValueArray) = A.dims

@inline function Base.getindex(A::FixedValueArray, i::Int)
    @boundscheck checkbounds(A, i)
    A.val
end

@inline function Base.getindex(A::FixedValueArray{T, N}, I::Vararg{Int, N}) where {T, N}
    @boundscheck checkbounds(A, I...)
    A.val
end

@inline function Base.setindex!(A::FixedValueArray, ::Any, ::Int)
    _throw_canonical_error("setindex! not defined for ", typeof(A))
end

# This one is required to have setindex! at index [] throw a CanonicalIndexError instead
# of a BoundsError (which is used for all other indices).
@inline function Base.setindex!(A::FixedValueArray, ::Any, ::Vararg{Int})
    _throw_canonical_error("setindex! not defined for ", typeof(A))
end
