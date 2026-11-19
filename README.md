# ImplicitArrays.jl
[![](https://img.shields.io/github/actions/workflow/status/tkemmer/ImplicitArrays.jl/CI.yml?branch=master&style=for-the-badge)](https://github.com/tkemmer/ImplicitArrays.jl/actions/workflows/CI.yml)
[![](https://img.shields.io/github/license/tkemmer/ImplicitArrays.jl?style=for-the-badge)](https://github.com/tkemmer/ImplicitArrays.jl/blob/master/LICENSE)
[![](https://img.shields.io/badge/docs-stable-blue.svg?style=for-the-badge)](https://tkemmer.github.io/ImplicitArrays.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg?style=for-the-badge)](https://tkemmer.github.io/ImplicitArrays.jl/dev)


The `ImplicitArrays.jl` package provides interaction arrays for the [Julia](https://julialang.org) programming language.

## Interaction arrays
An interaction array `A` of size `n₁ × ... × nₙ` consists of axis elements `xᵢ` and an interaction function `f` such that `A[i₁, ..., iₙ] = f(x₁[i₁], ..., xₙ[iₙ])`. The array is stored implicitly: only the axis elements and interaction function are kept, while individual entries are computed on demand. The two-dimensional case is an interaction matrix, for which `InteractionMatrix` is provided as an alias. The main types are `InteractionArray`, `InteractionMatrix`, and `InteractionFunction`:

```julia
julia> using ImplicitArrays

julia> InteractionMatrix{Int}([1, 2, 3], [10, 20, 30], +)
3×3 InteractionMatrix{Int64}:
 11  21  31
 12  22  32
 13  23  33
```

Custom interaction functions are ordinary callable types:

```julia
julia> struct DivFun <: InteractionFunction{Float64, Tuple{Int, Int}} end

julia> (::DivFun)(x::Int, y::Int) = x / y

julia> InteractionMatrix([10, 20, 30], [5, 2, 1], DivFun())
3×3 InteractionMatrix{Float64}:
 2.0   5.0  10.0
 4.0  10.0  20.0
 6.0  15.0  30.0
```

Arbitrarily many dimensions are supported by `InteractionArray`:

```julia
julia> struct Sum3 <: InteractionFunction{Int, Tuple{Int, Int, Int}} end

julia> (::Sum3)(x::Int, y::Int, z::Int) = x + y + z

julia> A = InteractionArray(([1, 2], [10, 20], [100, 200]), Sum3());

julia> A[2, 2, 2]
222
```

See the [interaction array documentation](https://tkemmer.github.io/ImplicitArrays.jl/dev/interaction/) for a detailed guide and more examples.

## Deprecated types
The following legacy implicit array types are obsolete and deprecated. They are retained for backward compatibility only and will be removed in a future release. New code should use the recommended replacements instead:

| Deprecated type | Recommended replacement |
| --- | --- |
| `BlockMatrix` | [`BlockArrays.jl`](https://github.com/JuliaArrays/BlockArrays.jl) (`BlockArray`, `mortar`) |
| `FixedValueArray` | [`FillArrays.jl`](https://github.com/JuliaArrays/FillArrays.jl) (`Fill`) |
| `RowProjectionVector`, `RowProjectionMatrix` | `Base.view` / `@view` with index vectors (e.g. `@view v[rows]`, `@view A[rows, :]`) |

See the [historic types documentation](https://tkemmer.github.io/ImplicitArrays.jl/dev/historic/) for details.

## Installation
In the Julia REPL, switch to the `Pkg` mode by pressing `]` and enter the following command:

```sh
pkg> add ImplicitArrays
```

## Testing
`ImplicitArrays.jl` provides tests for its exported API. You can run the test suite yourself with the following command in `Pkg` mode:
```sh
pkg> test ImplicitArrays
```

## Citing
If you use `ImplicitArrays.jl` in your research, please cite the following publication:
> Kemmer, T (2021). Space-efficient and exact system representations for the nonlocal protein
> electrostatics problem. PhD thesis, Johannes Gutenberg University Mainz. Mainz, Germany.
> <http://doi.org/10.25358/openscience-5689>

Citation items for BibTeX can be found in [CITATION.bib](https://github.com/tkemmer/ImplicitArrays.jl/blob/master/CITATION.bib).
