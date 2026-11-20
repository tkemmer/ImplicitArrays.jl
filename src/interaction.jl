"""
    InteractionFunction{T, R <: Tuple}

Abstract base type of all interaction functions `R₁ × ... × Rₙ → T`, where `R` is a tuple of
the axis element types `(R₁, ..., Rₙ)`.

# Examples
```jldoctest; setup = :(using ImplicitArrays)
julia> struct DistanceFun <: InteractionFunction{Float64, Tuple{Float64, Float64}} end

julia> (::DistanceFun)(x::Float64, y::Float64) = abs(x - y)

julia> DistanceFun()(1.0, 2.5)
1.5
```
"""
abstract type InteractionFunction{T, R <: Tuple} end

"""
    ConstInteractionFunction{T, R <: Tuple} <: InteractionFunction{T, R}

Interaction function `R₁ × ... × Rₙ → T` that ignores its arguments and returns a fixed value.

# Constructor
    ConstInteractionFunction{T, R}(val)

Create a constant interaction function that always returns `val`.

# Examples
```jldoctest; setup = :(using ImplicitArrays)
julia> f = ConstInteractionFunction{Int, Tuple{Float64, Float64}}(42);

julia> f(1.0, 1.5)
42
```
"""
struct ConstInteractionFunction{T, R <: Tuple} <: InteractionFunction{T, R}
    val::T
end
@inline (f::ConstInteractionFunction)(args...) = f.val

"""
    GenericInteractionFunction{T, R <: Tuple} <: InteractionFunction{T, R}

Interaction function `R₁ × ... × Rₙ → T` acting as a type-safe wrapper for a given function.

# Constructor
    GenericInteractionFunction{T, R}(fun)

Create an interaction function from the given function `fun`.

# Examples
```jldoctest; setup = :(using ImplicitArrays)
julia> f = GenericInteractionFunction{Int, Tuple{Int, Int}}(+); f(9, 3)
12

julia> g = GenericInteractionFunction{Float64, Tuple{Int, Int}}(/); g(9, 3)
3.0

julia> h = GenericInteractionFunction{String, Tuple{String, Int}}(repeat); h("abc", 3)
"abcabcabc"
```

!!! note
    The interaction function can only be evaluated if there is a method `fun(::R₁, ..., ::Rₙ)`
    that returns a value of type `T`. Otherwise, a `MethodError` or `TypeError` is thrown.
"""
struct GenericInteractionFunction{T, R <: Tuple} <: InteractionFunction{T, R}
    f::Function
end
@inline (f::GenericInteractionFunction{T})(args...) where T = f.f(args...)::T

"""
    InteractionArray{T, N, R, F, AE} <: AbstractArray{T, N}

Interaction array with elements of type `T`, generated from `N` axis element arrays and an
interaction function `F: R₁ × ... × Rₙ → T`.

The type parameters are:
- `T`: element type of the interaction array.
- `N`: number of dimensions.
- `R`: tuple of axis element types `(R₁, ..., Rₙ)`.
- `F`: interaction function type.
- `AE`: tuple of axis element array types.

# Constructors
    InteractionArray(axiselems, interact)
    InteractionArray{T}(axiselems, interact)
    InteractionArray(axiselems, val)
    InteractionArray(A::InteractionArray, I...)

Create an interaction array from a tuple `axiselems` of axis element arrays and an interaction
function `interact`. The interaction function can be an `InteractionFunction` object, a plain
function (with explicit element type `T`), or a constant value `val`.

    InteractionArray(A::InteractionArray, I...)

Create a view on a given interaction array similar to `view(A, I...)`. In contrast to
`Base.view`, this function returns an interaction array object rather than a wrapper of the
original array.

# Examples
```jldoctest; setup = :(using ImplicitArrays)
julia> struct Sum3 <: InteractionFunction{Int, Tuple{Int, Int, Int}} end

julia> (::Sum3)(x::Int, y::Int, z::Int) = x + y + z

julia> A = InteractionArray(([1, 2], [10, 20], [100, 200]), Sum3());

julia> A[2, 2, 2]
222

julia> A[2, :, 1]
2-element Vector{Int64}:
 112
 122
```
"""
@inline _axis_types(axiselems::Tuple) = Tuple{map(eltype, axiselems)...}

struct InteractionArray{
    T,
    N,
    R <: NTuple{N, Any},
    F <: InteractionFunction{T, R},
    AE <: NTuple{N, AbstractVector}
} <: AbstractArray{T, N}
    axiselems::AE
    interact::F

    @inline function InteractionArray{T, N, R, F, AE}(
        axiselems::AE,
        interact::F
    ) where {
        T,
        N,
        R <: NTuple{N, Any},
        F <: InteractionFunction{T, R},
        AE <: NTuple{N, AbstractVector}
    }
        # The type-level check folds to a constant for well-typed arrays, so validation
        # is free in the common case. The loop below only runs (and only produces the
        # detailed per-axis message) when the check fails.
        if !(_axis_types(axiselems) <: R)
            for i in 1:N
                eltype(axiselems[i]) <: R.parameters[i] || throw(ArgumentError(
                    "axis element array $i has element type $(eltype(axiselems[i])), " *
                    "which is not a subtype of $(R.parameters[i])"
                ))
            end
        end
        new{T, N, R, F, AE}(axiselems, interact)
    end
end

@inline InteractionArray(
    axiselems::AE,
    interact::F
) where {
    T,
    N,
    R,
    F <: InteractionFunction{T, R},
    AE <: NTuple{N, AbstractVector}
} = InteractionArray{T, N, R, F, AE}(axiselems, interact)

@inline InteractionArray{T}(
    axiselems::AE,
    interact::Function
) where {T, N, AE <: NTuple{N, AbstractVector}} = InteractionArray(
    axiselems,
    GenericInteractionFunction{T, _axis_types(axiselems)}(interact)
)

@inline InteractionArray(
    axiselems::AE,
    val::T
) where {T, N, AE <: NTuple{N, AbstractVector}} = InteractionArray(
    axiselems,
    ConstInteractionFunction{T, _axis_types(axiselems)}(val)
)

@inline InteractionArray(
    A::InteractionArray{T, N},
    I::Vararg{Any, N}
) where {T, N} = InteractionArray(
    ntuple(i -> vec(view(A.axiselems[i], I[i])), Val(N)),
    A.interact
)

@inline Base.size(A::InteractionArray) = map(length, A.axiselems)

function Base.summary(io::IO, A::InteractionArray{T, N}) where {T, N}
    if N == 2
        print(io, size(A, 1), '×', size(A, 2), " InteractionMatrix{", T, "}")
    elseif N == 1
        print(io, length(A), "-element InteractionArray{", T, "}")
    elseif N == 0
        print(io, "0-dimensional InteractionArray{", T, "}")
    else
        print(io, join(size(A), '×'), " InteractionArray{", T, "}")
    end
end

# Compatibility accessors for the old 2-D field names.
@inline function Base.getproperty(A::InteractionArray{T, 2}, s::Symbol) where {T}
    if s === :rowelems
        return getfield(A, :axiselems)[1]
    elseif s === :colelems
        return getfield(A, :axiselems)[2]
    else
        return getfield(A, s)
    end
end

@inline Base.propertynames(A::InteractionArray{T, 2}) where {T} =
    (:rowelems, :colelems, :axiselems, :interact)
@inline Base.propertynames(A::InteractionArray) = (:axiselems, :interact)

# Wrapper that delegates non-scalar indexing to Base's generic AbstractArray implementation.
# This guarantees that mixed scalar/range indexing, multidimensional index arrays, trailing
# singleton dimensions, and other standard `getindex` forms behave like a regular array.
struct _InteractionArrayIndexer{T, N, K, A <: InteractionArray{T, N}} <: AbstractArray{T, N}
    A::A
    kwargs::K
end

@inline Base.size(w::_InteractionArrayIndexer) = size(w.A)
@inline Base.axes(w::_InteractionArrayIndexer) = axes(w.A)
@inline Base.IndexStyle(::Type{<:_InteractionArrayIndexer}) = IndexCartesian()

@inline Base.getindex(w::_InteractionArrayIndexer{T, N}, I::Vararg{Int, N}) where {T, N} =
    _getindex(w.A, I...; w.kwargs...)

@inline Base.getindex(A::InteractionArray, I...; kwargs...) =
    getindex(_InteractionArrayIndexer(A, kwargs), I...)

@inline _getindex(A::InteractionArray{T, N}, I::Vararg{Integer, N}; kwargs...) where {T, N} =
    A.interact(map((ax, i) -> ax[i], A.axiselems, I)...; kwargs...)::T

"""
    InteractionMatrix{T, R, C, F, RE, CE}

Two-dimensional interaction array, alias for
`InteractionArray{T, 2, Tuple{R, C}, F, Tuple{RE, CE}}`.

An interaction matrix with elements of type `T`, generated from row elements of type `R`,
column elements of type `C`, and an interaction function `F: R × C → T`.

# Constructors
    InteractionMatrix(rowelems, colelems, interact)
    InteractionMatrix{T}(rowelems, colelems, interact)

Create an interaction matrix for the given row and column element arrays as well as an
interaction function.

    InteractionMatrix(rowelems, colelems, val)

Create an interaction matrix for the given (yet unused) row and column element arrays and a
constant interaction function always returning `val`. In this form, the interaction matrix acts
as a replacement for a two-dimensional fixed-value array such as `FillArrays.Fill` from
FillArrays.jl.

    InteractionMatrix(A::InteractionMatrix, rows, cols)

Create a view on a given interaction matrix similar to `view(A, rows, cols)`. In contrast to
`Base.view`, this function returns an interaction matrix object rather than a wrapper of the
original matrix.

# Examples
```jldoctest; setup = :(using ImplicitArrays)
julia> InteractionMatrix{Int64}([1, 2, 3], [10, 20, 30], +)
3×3 InteractionMatrix{Int64}:
 11  21  31
 12  22  32
 13  23  33

julia> InteractionMatrix([1, 2, 3], [10, 20, 30], 42)
3×3 InteractionMatrix{Int64}:
 42  42  42
 42  42  42
 42  42  42

julia> struct DivFun <: InteractionFunction{Float64, Tuple{Int, Int}} end

julia> (::DivFun)(x::Int, y::Int) = x / y

julia> InteractionMatrix([10, 20, 30], [5, 2, 1], DivFun())
3×3 InteractionMatrix{Float64}:
 2.0   5.0  10.0
 4.0  10.0  20.0
 6.0  15.0  30.0
```
"""
const InteractionMatrix{
    T,
    R,
    C,
    F <: InteractionFunction{T, Tuple{R, C}},
    RE <: AbstractVector{R},
    CE <: AbstractVector{C}
} = InteractionArray{T, 2, Tuple{R, C}, F, Tuple{RE, CE}}

@inline InteractionMatrix(
    rowelems::AbstractVector,
    colelems::AbstractVector,
    interact::InteractionFunction
) = InteractionArray((rowelems, colelems), interact)

@inline InteractionMatrix{T}(
    rowelems::AbstractVector{R},
    colelems::AbstractVector{C},
    interact::F
) where {T, R, C, F <: InteractionFunction{T, Tuple{R, C}}} =
    InteractionArray((rowelems, colelems), interact)

@inline InteractionMatrix{T, R, C, F, RE, CE}(
    rowelems::RE,
    colelems::CE,
    interact::F
) where {
    T,
    R,
    C,
    F <: InteractionFunction{T, Tuple{R, C}},
    RE <: AbstractVector{R},
    CE <: AbstractVector{C}
} = InteractionArray{T, 2, Tuple{R, C}, F, Tuple{RE, CE}}(
    (rowelems, colelems),
    interact
)

@inline InteractionMatrix{T}(
    rowelems::AbstractVector{R},
    colelems::AbstractVector{C},
    interact::Function
) where {T, R, C} = InteractionArray(
    (rowelems, colelems),
    GenericInteractionFunction{T, Tuple{R, C}}(interact)
)

@inline InteractionMatrix(
    rowelems::AbstractVector{R},
    colelems::AbstractVector{C},
    val::T
) where {T, R, C} = InteractionArray(
    (rowelems, colelems),
    ConstInteractionFunction{T, Tuple{R, C}}(val)
)

@inline InteractionMatrix(
    A::InteractionArray{T, 2},
    I::Vararg{Any, 2}
) where {T} = InteractionArray(A, I...)
