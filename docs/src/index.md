```@meta
    CurrentModule = ImplicitArrays
```
# ImplicitArrays.jl

The `ImplicitArrays.jl` package provides interaction matrices for the [Julia](https://julialang.org) programming language.

!!! note "Historic types"
    The legacy `BlockMatrix`, `FixedValueArray`, `RowProjectionVector`, and
    `RowProjectionMatrix` types are deprecated and documented on the
    [Historic types](@ref) page. They are retained for backward compatibility only.


## Interaction matrices

An interaction matrix `M` of size `n × m` consist of a list of `n` elements `rᵢ ∈ R` (*row elements*), a list of `m` elements `cⱼ ∈ C` (*column elements*), and a *interaction function* `f: R × C → T`, such that each element `Mᵢⱼ` of the matrix can be computed as `f(rᵢ, cⱼ)`.

### Interaction functions
```@docs
    InteractionFunction
    ConstInteractionFunction
    GenericInteractionFunction
```

### Interaction matrices
```@docs
    InteractionMatrix
```