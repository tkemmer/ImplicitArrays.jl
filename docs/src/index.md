```@meta
    CurrentModule = ImplicitArrays
```
# ImplicitArrays.jl

The `ImplicitArrays.jl` package provides interaction matrices for the
[Julia](https://julialang.org) programming language.

## In a nutshell

An interaction matrix `M` of size `n × m` consists of row elements `rᵢ`, column elements `cⱼ`,
and an interaction function `f` such that `Mᵢⱼ = f(rᵢ, cⱼ)`. The matrix is stored implicitly:
only the row elements, column elements, and interaction function are kept, while individual
entries are computed on demand.

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
julia> struct DivFun <: InteractionFunction{Int, Int, Float64} end

julia> (::DivFun)(x::Int, y::Int) = x / y

julia> InteractionMatrix([10, 20, 30], [5, 2, 1], DivFun())
3×3 InteractionMatrix{Float64}:
 2.0   5.0  10.0
 4.0  10.0  20.0
 6.0  15.0  30.0
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
