# TODO
struct RowProjectionVector{T} <: AbstractArray{T, 1}
    base::AbstractArray{T, 1}
    rows::Vector{Int}

    function RowProjectionVector{T}(
        base::AbstractArray{T, 1},
        rows::Vector{Int}
    ) where T
        @boundscheck _checkrowbounds(base, rows)
        new(base, rows)
    end
end

RowProjectionVector(
    base::AbstractArray{T, 1},
    rows::Vector{Int}
) where T = RowProjectionVector{T}(base, rows)

RowProjectionVector(
    base::AbstractArray{T, 1},
    rows::Vararg{Int, N}
) where {T, N} = RowProjectionVector(base, collect(rows))

@inline Base.size(
    M::RowProjectionVector{T}
) where T = (length(M.rows),)

@inline Base.getindex(
    M::RowProjectionVector{T},
    i::Int
) where T = Base.getindex(M.base, M.rows[i])

@inline Base.setindex!(
    M::RowProjectionVector{T},
    v::Any,
    i::Int
) where T = Base.setindex!(M.base, v, M.rows[i])


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

@inline Base.getindex(
    M::RowProjectionMatrix{T},
    I::Vararg{Int, 2}
) where T = Base.getindex(M.base, M.rows[I[1]], I[2])

@inline Base.setindex!(
    M::RowProjectionMatrix{T},
    v::Any,
    I::Vararg{Int, 2}
) where T = Base.setindex!(M.base, v, M.rows[I[1]], I[2])

function _checkrowbounds(
    base::Union{AbstractArray{T, 1}, AbstractArray{T, 2}},
    rows::Vector{Int}
) where T
    for row ∈ rows
        checkbounds(base, row, :)
    end
end
