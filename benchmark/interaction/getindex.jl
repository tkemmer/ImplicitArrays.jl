struct KwargsFun{T} <: InteractionFunction{T, Tuple{Int, T}}
    α::T
end
(f::KwargsFun{T})(x::Int, y::T; α::T = f.α) where T = α * (x + y)

indexing_suite = SUITE["InteractionMatrix"]["Indexing"]

let n = 100
    rows = collect(1:n)
    cols = rand(n)
    A    = InteractionMatrix{Float64}(rows, cols, +)
    K    = InteractionMatrix(rows, cols, KwargsFun(2.0))
    mask = map(x -> x > 0.5, A)

    i, j  = 42, 17
    k     = 4242
    empty = Int[]

    indexing_suite["scalar"] = @benchmarkable $A[$i, $j]
    indexing_suite["linear"] = @benchmarkable $A[$k]
    indexing_suite["row"]    = @benchmarkable $A[$i, :]
    indexing_suite["column"] = @benchmarkable $A[:, $j]
    indexing_suite["block"]  = @benchmarkable $A[1:10, 1:10]
    indexing_suite["whole"]  = @benchmarkable $A[:]
    indexing_suite["mask"]   = @benchmarkable $A[$mask]
    indexing_suite["kwargs"] = @benchmarkable getindex($K, $i, $j; α = 3.0)
    indexing_suite["empty"]  = @benchmarkable $A[$empty, $empty]
end
