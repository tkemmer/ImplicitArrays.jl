# TODO
struct RowProjectionMatrix{T} <: AbstractArray{T, 2}
    base::AbstractArray{T, 2}
    rows::Vector{Int}

    function RowProjectionMatrix{T}(
        base::AbstractArray{T, 2},
        rows::Vector{Int}
    ) where T
        @boundscheck _checkrowbounds(base, rows)
        new(base, rows)
    end
end

RowProjectionMatrix(
    base::AbstractArray{T, 2},
    rows::Vector{Int}
) where T = RowProjectionMatrix{T}(base, rows)

RowProjectionMatrix(
    base::AbstractArray{T, 2},
    rows::Vararg{Int, N}
) where {T, N} = RowProjectionMatrix(base, collect(rows))

@inline Base.size(
    M::RowProjectionMatrix{T}
) where T = (length(M.rows), size(M.base)[2])

@inline function Base.getindex(
    M::RowProjectionMatrix{T},
    I::Vararg{Int, 2}
) where T
    @boundscheck checkbounds(M, I...)
    M.base[M.rows[I[1]], I[2]]
end

@inline function Base.setindex!(
    M::RowProjectionMatrix{T},
    v::Any,
    I::Vararg{Int, 2}
) where T
    @boundscheck checkbounds(M, I...)
    M.base[M.rows[I[1]], I[2]] = v
end

function _checkrowbounds(
    base::AbstractArray{T, 2},
    rows::Vector{Int}
) where T
    for row ∈ rows
        checkbounds(base, row, :)
    end
end
