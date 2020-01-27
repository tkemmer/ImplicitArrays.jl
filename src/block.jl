# TODO
struct BlockMatrix{T} <: AbstractArray{T, 2}
    bdims::NTuple{2, Int}
    blocks::Array{AbstractArray{T, 2}, 2}

    function BlockMatrix{T}(
        blocks::Array{AbstractArray{T, 2}, 2}
    ) where T
        bdims = (1, 1)
        for (i, block) ∈ enumerate(blocks)
            i > 1 && @assert(
                size(block) == bdims,
                "invalid block dimensions (block $i expected $bdims, got $(size(block)))"
            )
            bdims = size(block)
        end
        new(bdims, blocks)
    end
end

@inline BlockMatrix(
    blocks::Array{AbstractArray{T, 2}, 2}
) where T = BlockMatrix{T}(blocks)

function BlockMatrix{T}(
    rows::Int,
    cols::Int,
    blocks::Vararg{AbstractArray{T, 2}}
) where T
    @assert(
        rows * cols == length(blocks),
        "invalid number of blocks given (expected $(rows * cols), got $(length(blocks)))"
    )
    B = Array{AbstractArray{T, 2}, 2}(undef, rows, cols)
    for (i, b) in enumerate(blocks)
        B[Int(ceil(i/cols)), (i - 1) % cols + 1] = b
    end
    BlockMatrix(B)
end

@inline BlockMatrix(
    rows::Int,
    cols::Int,
    block::AbstractArray{T, 2},
    blocks::Vararg{AbstractArray{T, 2}}
) where T = BlockMatrix{T}(rows, cols, block, blocks...)

@inline Base.size(
    M::BlockMatrix{T}
) where T = M.bdims .* size(M.blocks)

@inline Base.getindex(
    M::BlockMatrix{T},
    I::Vararg{Int, 2}
) where T = Base.getindex(
    M.blocks[Int(ceil(I[1]/M.bdims[1])), Int(ceil(I[2]/M.bdims[2]))],
    (I[1] - 1) % M.bdims[1] + 1,
    (I[2] - 1) % M.bdims[2] + 1
)

@inline Base.setindex!(
    M::BlockMatrix{T},
    v::Any,
    I::Vararg{Int, 2}
) where T = Base.setindex!(
    M.blocks[Int(ceil(I[1]/M.bdims[1])), Int(ceil(I[2]/M.bdims[2]))],
    v,
    (I[1] - 1) % M.bdims[1] + 1,
    (I[2] - 1) % M.bdims[2] + 1
)
