```@meta
    CurrentModule = ImplicitArrays
```
# ImplicitArrays.jl

The `ImplicitArrays.jl` package provides interaction arrays for the
[Julia](https://julialang.org) programming language.

## In a nutshell

An interaction array `A` of size `n₁ × ... × nₙ` consists of axis elements `xᵢ` and an
interaction function `f` such that `A[i₁, ..., iₙ] = f(x₁[i₁], ..., xₙ[iₙ])`. The array is
stored implicitly: only the axis elements and interaction function are kept, while individual
entries are computed on demand.

The two-dimensional case is an interaction matrix `M` of size `n × m`, consisting of row
elements `rᵢ`, column elements `cⱼ`, and an interaction function `f` such that
`Mᵢⱼ = f(rᵢ, cⱼ)`. `InteractionMatrix` is an alias for the two-dimensional `InteractionArray`.

```jldoctest home
julia> using ImplicitArrays

julia> M = InteractionMatrix{Int}([1, 2, 3], [10, 20, 30], +)
3×3 InteractionMatrix{Int64}:
 11  21  31
 12  22  32
 13  23  33
```

Custom interaction functions are ordinary callable types:

```jldoctest home
julia> struct DivFun <: InteractionFunction{Float64, Tuple{Int, Int}} end

julia> (::DivFun)(x::Int, y::Int) = x / y

julia> InteractionMatrix([10, 20, 30], [5, 2, 1], DivFun())
3×3 InteractionMatrix{Float64}:
 2.0   5.0  10.0
 4.0  10.0  20.0
 6.0  15.0  30.0
```

Arbitrarily many dimensions are supported by `InteractionArray`:

```jldoctest home
julia> struct Sum3 <: InteractionFunction{Int, Tuple{Int, Int, Int}} end

julia> (::Sum3)(x::Int, y::Int, z::Int) = x + y + z

julia> A = InteractionArray(([1, 2], [10, 20], [100, 200]), Sum3());

julia> A[2, 2, 2]
222
```

## Learn more

See the [Interaction matrices](@ref) page for a detailed guide, more examples, indexing,
views, and the full API reference.

## Deprecated types

The legacy `BlockMatrix`, `FixedValueArray`, `RowProjectionVector`, and
`RowProjectionMatrix` types are deprecated and retained for backward compatibility only.
See [Historic types](@ref) for details and recommended replacements.

## Installation

In the Julia REPL, switch to the `Pkg` mode by pressing `]` and enter the following command:

```sh
pkg> add ImplicitArrays
```

## Citing

If you use `ImplicitArrays.jl` in your research, please cite the following publication:

> Kemmer, T (2021). Space-efficient and exact system representations for the nonlocal protein
> electrostatics problem. PhD thesis, Johannes Gutenberg University Mainz. Mainz, Germany.
> <http://doi.org/10.25358/openscience-5689>

Citation items for BibTeX can be found in
[CITATION.bib](https://github.com/tkemmer/ImplicitArrays.jl/blob/master/CITATION.bib).
