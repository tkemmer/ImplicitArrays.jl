```@meta
    CurrentModule = ImplicitArrays
```
# Interaction matrices

An interaction matrix `M` of size `n × m` consists of a list of `n` row elements
`rᵢ ∈ R`, a list of `m` column elements `cⱼ ∈ C`, and an interaction function
`f: R × C → T`, such that each element of the matrix is computed as
`M[i, j] = f(rowelems[i], colelems[j])`.

The matrix is stored implicitly: only the row elements, column elements, and the
interaction function are kept. Individual entries are computed on demand, so an
`n × m` interaction matrix does not require `n × m` storage.

Interaction matrices are read-only. Attempting to assign to an entry throws a
`CanonicalIndexError`; invalid index expressions may still throw `BoundsError`.

## Getting started

### A first interaction matrix

```jldoctest interaction
julia> using ImplicitArrays

julia> M = InteractionMatrix{Int}([1, 2, 3], [10, 20, 30], +)
3×3 InteractionMatrix{Int64}:
 11  21  31
 12  22  32
 13  23  33

julia> size(M)
(3, 3)

julia> M[2, 3]
32
```

!!! note
    When passing a plain function such as `+`, specify the element type explicitly:
    `InteractionMatrix{Int}(rows, cols, +)`. Without `{Int}`, the function is treated as a
    constant value that fills the whole matrix.

### Constructor overview

| Goal | Constructor |
| --- | --- |
| Wrap a plain function | `InteractionMatrix{T}(rows, cols, fun)` |
| Use a custom `InteractionFunction` | `InteractionMatrix(rows, cols, fun)` |
| Use a constant value | `InteractionMatrix(rows, cols, val)` |
| Create a view | `InteractionMatrix(A, rows, cols)` |

### Constant matrices

Passing a value instead of a function creates a constant interaction matrix:

```jldoctest interaction
julia> InteractionMatrix([1, 2, 3], [10, 20, 30], 42)
3×3 InteractionMatrix{Int64}:
 42  42  42
 42  42  42
 42  42  42
```

### Custom interaction functions

An interaction function is any subtype of `InteractionFunction{R, C, T}` that implements
`(f::MyFun)(r::R, c::C)::T`. A typical example is a pairwise distance matrix:

```jldoctest interaction
julia> struct Distance <: InteractionFunction{Float64, Float64, Float64} end

julia> (::Distance)(x::Float64, y::Float64) = abs(x - y)

julia> coords = [0.0, 1.0, 2.5, 4.0];

julia> InteractionMatrix(coords, coords, Distance())
4×4 InteractionMatrix{Float64}:
 0.0  1.0  2.5  4.0
 1.0  0.0  1.5  3.0
 2.5  1.5  0.0  1.5
 4.0  3.0  1.5  0.0
```

!!! note
    The interaction function must return a value of type `T`. Otherwise, indexing throws a
    `TypeError`.

### Stateful interaction functions

Interaction functions can carry parameters. For example, a scaled interaction can store a
factor `α`:

```jldoctest interaction
julia> struct ScaleFun{T} <: InteractionFunction{Int, T, T}
           α::T
       end

julia> (f::ScaleFun{T})(x::Int, y::T) where T = f.α * (x + y)

julia> InteractionMatrix([1, 2], [10.0, 20.0], ScaleFun(2.0))
2×2 InteractionMatrix{Float64}:
 22.0  42.0
 24.0  44.0
```

### Passing keyword arguments

If an interaction function accepts keyword arguments, they can be forwarded through
`getindex`:

```jldoctest interaction
julia> struct KwargsFun{T} <: InteractionFunction{Int, T, T}
           α::T
       end

julia> (f::KwargsFun{T})(x::Int, y::T; α::T = f.α) where T = α * (x + y)

julia> K = InteractionMatrix([1, 2], [10.0, 20.0], KwargsFun(2.0));

julia> K[1, 2]
42.0

julia> getindex(K, 1, 2; α = 3.0)
63.0
```

## Working with an interaction matrix

### Indexing

Interaction matrices support the standard `AbstractArray` indexing forms, including mixed
scalar/range indices, multidimensional index arrays, and trailing singleton dimensions:

```jldoctest interaction
julia> M[5]
22

julia> M[2, :]
3-element Vector{Int64}:
 12
 22
 32

julia> M[:, 2]
3-element Vector{Int64}:
 21
 22
 23

julia> M[2, 1:2]
2-element Vector{Int64}:
 12
 22

julia> M[1:2, 2]
2-element Vector{Int64}:
 21
 22

julia> M[[1 2; 1 2], 1]
2×2 Matrix{Int64}:
 11  12
 11  12

julia> M[[1, 3], [2]]
2×1 Matrix{Int64}:
 21
 23

julia> M[[2], :]
1×3 Matrix{Int64}:
 12  22  32

julia> M[:]
9-element Vector{Int64}:
 11
 12
 13
 21
 22
 23
 31
 32
 33

julia> M[M .> 20]
6-element Vector{Int64}:
 21
 22
 23
 31
 32
 33
```

### Interaction-matrix views

`InteractionMatrix(A, rows, cols)` creates a new interaction matrix from a subset of the
row and column elements. Unlike `view`, the result is still an `InteractionMatrix`:

```jldoctest interaction
julia> V = InteractionMatrix(M, 2:3, [1, 3])
2×2 InteractionMatrix{Int64}:
 12  32
 13  33

julia> V == view(M, 2:3, [1, 3])
true
```

### Memory and performance

Since entries are computed on demand, interaction matrices can represent very large
matrices without allocating `n × m` storage:

```jldoctest interaction
julia> L = InteractionMatrix{Int}(1:10^9, 1:10^9, +);

julia> size(L)
(1000000000, 1000000000)

julia> L[10^9, 10^9]
2000000000
```

Repeated indexing recomputes the interaction function. Use `collect` when an explicit
matrix is needed.

## API reference

### Interaction functions

```@docs
    InteractionFunction
    ConstInteractionFunction
    GenericInteractionFunction
```

### Interaction matrix type

```@docs
    InteractionMatrix
```
