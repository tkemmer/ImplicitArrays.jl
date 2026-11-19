```@meta
    CurrentModule = ImplicitArrays
```
# Historic types

!!! warning "Deprecated"
    The types on this page are obsolete and deprecated. They are retained for backward
    compatibility only and will be removed in a future release. New code should use the
    recommended replacements below.

| Deprecated type | Recommended replacement |
| --- | --- |
| `BlockMatrix` | [`BlockArrays.jl`](https://github.com/JuliaArrays/BlockArrays.jl) (`BlockArray`, `mortar`) |
| `FixedValueArray` | [`FillArrays.jl`](https://github.com/JuliaArrays/FillArrays.jl) (`Fill`) |
| `RowProjectionVector`, `RowProjectionMatrix` | `Base.view` / `@view` with index vectors |

## Migration examples

Row projections can be replaced by standard views:

```julia
# Instead of RowProjectionVector(v, rows)
@view v[rows]

# Instead of RowProjectionMatrix(A, rows)
@view A[rows, :]
```

For block matrices, use `BlockArrays.jl`:

```julia
using BlockArrays

# Combine an array of arrays into a block array
mortar(blocks)

# Repack an existing array into a block array
BlockArray(arr, block_sizes)
```

For fixed-value arrays, use `FillArrays.jl`:

```julia
using FillArrays

Fill(0, 2, 5)
```

## Block matrices

This section presents a [block matrix](https://en.wikipedia.org/wiki/Block_matrix) type for equally-sized blocks (sharing a common element type). The `BlockMatrix` type can be used to encapsulate and mix different matrix blocks, e.g., regular matrices and implicit matrices at the same time.

```@docs
    BlockMatrix
```

## Fixed-value arrays

Fixed-value arrays "replicate" a single value across arbitrary array dimensions. The resulting arrays have a constant memory footprint (i.e., the represented value and the array dimensions) and can only be read from.

```@docs
    FixedValueArray
```

## Row-projection arrays

Row-projection arrays represent views on existing vectors or matrices, where the projections are created from a sequence of valid row indices corresponding to the vector or matrix. Row indices can occur multiple times and at arbitrary positions in the sequence.

```@docs
    RowProjectionVector
    RowProjectionMatrix
```
