struct SimpleFun <: InteractionFunction{Float64, Tuple{Int, Float64}} end
(::SimpleFun)(r::Int, c::Float64) = r * r + c

struct GenericFun{T <: AbstractFloat} <: InteractionFunction{T, Tuple{Int, T}} end
(::GenericFun{T})(r::Int, c::T) where T = r * r + c

struct StatefulFun{T <: AbstractFloat} <: InteractionFunction{T, Tuple{Int, T}}
    α::T
end
(f::StatefulFun{T})(r::Int, c::T) where T = f.α * (r * r + c)

struct KwargsFun{T <: AbstractFloat} <: InteractionFunction{T, Tuple{Int, T}}
    α::T
end
(f::KwargsFun{T})(r::Int, c::T; α::T = f.α) where T = α * (r * r + c)

@testset "empty matrix" begin
    A = InteractionMatrix(Int[], Int[], 11)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (0, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix{Int}(Int[], Int[], +)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (0, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix{Float64}(Int[], Int[], /)
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[], SimpleFun())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[], GenericFun{Float64}())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[], StatefulFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[], KwargsFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]
    @test_throws BoundsError getindex(A; α = 3.0)
    @test_throws BoundsError getindex(A, 1; α = 3.0)
end

@testset "no rowelems" begin
    A = InteractionMatrix(Int[], Int[42, 40, 47], 11)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (0, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix{Int}(Int[], Int[42, 40, 47], +)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (0, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix{Float64}(Int[], Int[42, 40, 47], /)
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[42, 40, 47], SimpleFun())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[42, 40, 47], GenericFun{Float64}())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[42, 40, 47], StatefulFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[], Float64[42, 40, 47], KwargsFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (0, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]
    @test_throws BoundsError getindex(A; α = 3.0)
    @test_throws BoundsError getindex(A, 1; α = 3.0)
end

@testset "no colelems" begin
    A = InteractionMatrix(Int[42, 40, 47], Int[], 11)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (3, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix{Int}(Int[42, 40, 47], Int[], +)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (3, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix{Float64}(Int[42, 40, 47], Int[], /)
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[42, 40, 47], Float64[], SimpleFun())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[42, 40, 47], Float64[], GenericFun{Float64}())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[42, 40, 47], Float64[], StatefulFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]

    A = InteractionMatrix(Int[42, 40, 47], Float64[], KwargsFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 0)
    @test_throws BoundsError A[]
    @test_throws BoundsError A[1]
    @test_throws BoundsError getindex(A; α = 3.0)
    @test_throws BoundsError getindex(A, 1; α = 3.0)
end

@testset "single value" begin
    A = InteractionMatrix(Int[2], Int[42], 11)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (1, 1)
    @test A[] isa Int
    @test A[] == 11
    @test A[1] isa Int
    @test A[1] == 11
    @test A[1, 1] isa Int
    @test A[1, 1] == 11
    @test_throws BoundsError A[2]
    @test_throws BoundsError A[1, 2]
    @test_throws BoundsError A[2, 1]
    @test_throws BoundsError A[2, 2]
    @test_throws CanonicalIndexError A[] = 13
    @test_throws CanonicalIndexError A[1] = 13
    @test_throws CanonicalIndexError A[1, 1] = 13
    @test_throws CanonicalIndexError A[1:1] = [13]
    @test_throws CanonicalIndexError A[:, 1] = [13]
    @test_throws BoundsError A[2] = 13
    @test_throws BoundsError A[2:2] = [13]
    @test_throws BoundsError A[:, 2] = [13]

    A = InteractionMatrix{Int}(Int[2], Int[42], -)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (1, 1)
    @test A[] isa Int
    @test A[] == -40
    @test A[1] isa Int
    @test A[1] == -40
    @test A[1, 1] isa Int
    @test A[1, 1] == -40
    @test_throws BoundsError A[2]
    @test_throws BoundsError A[1, 2]
    @test_throws BoundsError A[2, 1]
    @test_throws BoundsError A[2, 2]
    @test_throws CanonicalIndexError A[] = 13
    @test_throws CanonicalIndexError A[1] = 13
    @test_throws CanonicalIndexError A[1, 1] = 13

    A = InteractionMatrix{Int}(Int[42], Int[2], -)
    @test A[1] == 40

    A = InteractionMatrix{Int}(Int[42], Int[2], /)
    @test_throws TypeError A[1]

    A = InteractionMatrix{Float64}(Int[42], Int[2], /)
    @test A isa AbstractArray{Float64, 2}
    @test A[1] isa Float64
    @test A[1] == 21.0

    A = InteractionMatrix(Int[2], Float64[42], SimpleFun())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 1)
    @test A[] isa Float64
    @test A[] == 46
    @test A[1] isa Float64
    @test A[1] == 46
    @test A[1, 1] isa Float64
    @test A[1, 1] == 46
    @test_throws BoundsError A[2]
    @test_throws BoundsError A[1, 2]
    @test_throws BoundsError A[2, 1]
    @test_throws BoundsError A[2, 2]
    @test_throws CanonicalIndexError A[] = 13
    @test_throws CanonicalIndexError A[1] = 13
    @test_throws CanonicalIndexError A[1, 1] = 13

    A = InteractionMatrix(Int[2], Float64[42], GenericFun{Float64}())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 1)
    @test A[] isa Float64
    @test A[] == 46
    @test A[1] isa Float64
    @test A[1] == 46
    @test A[1, 1] isa Float64
    @test A[1, 1] == 46
    @test_throws BoundsError A[2]
    @test_throws BoundsError A[1, 2]
    @test_throws BoundsError A[2, 1]
    @test_throws BoundsError A[2, 2]
    @test_throws CanonicalIndexError A[] = 13
    @test_throws CanonicalIndexError A[1] = 13
    @test_throws CanonicalIndexError A[1, 1] = 13

    A = InteractionMatrix(Int[2], Float64[42], StatefulFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 1)
    @test A[] isa Float64
    @test A[] == 92
    @test A[1] isa Float64
    @test A[1] == 92
    @test A[1, 1] isa Float64
    @test A[1, 1] == 92
    @test_throws BoundsError A[2]
    @test_throws BoundsError A[1, 2]
    @test_throws BoundsError A[2, 1]
    @test_throws BoundsError A[2, 2]
    @test_throws CanonicalIndexError A[] = 13
    @test_throws CanonicalIndexError A[1] = 13
    @test_throws CanonicalIndexError A[1, 1] = 13

    A = InteractionMatrix(Int[2], Float64[42], KwargsFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 1)
    @test A == 2 .* [46;;]
    @test getindex(A, :; α = 3.0) == 3 .* [46]
    @test getindex(A, :, :; α = 3.0) == 3 .* [46;;]
    @test A[] isa Float64
    @test A[] == 2 * 46
    @test getindex(A; α = 3.0) == 3 * 46
    @test A[1] isa Float64
    @test A[1] == 92
    @test getindex(A, 1; α = 3.0) == 3 * 46
    @test A[1, 1] isa Float64
    @test A[1, 1] == 92
    @test getindex(A, 1, 1; α = 3.0) == 3 * 46
    @test_throws BoundsError A[2]
    @test_throws BoundsError getindex(A, 2; α = 3.0)
    @test_throws BoundsError A[1, 2]
    @test_throws BoundsError A[2, 1]
    @test_throws BoundsError A[2, 2]
    @test_throws BoundsError getindex(A, 1, 2; α = 3.0)
    @test_throws BoundsError getindex(A, 2, 1; α = 3.0)
    @test_throws BoundsError getindex(A, 2, 2; α = 3.0)
end

@testset "single rowelem" begin
    A = InteractionMatrix(Int[2], Int[42, 40, 47], 11)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (1, 3)
    @test_throws BoundsError A[]
    @test A[1] isa Int
    @test A[1] == 11
    @test A[2] isa Int
    @test A[2] == 11
    @test A[3] isa Int
    @test A[3] == 11
    @test A[1, 1] isa Int
    @test A[1, 1] == 11
    @test A[1, 2] isa Int
    @test A[1, 2] == 11
    @test A[1, 3] isa Int
    @test A[1, 3] == 11
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[2, 1]

    A = InteractionMatrix{Int}(Int[2], Int[42, 40, 47], -)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (1, 3)
    @test_throws BoundsError A[]
    @test A[1] isa Int
    @test A[1] == -40
    @test A[2] isa Int
    @test A[2] == -38
    @test A[3] isa Int
    @test A[3] == -45
    @test A[1, 1] isa Int
    @test A[1, 1] == -40
    @test A[1, 2] isa Int
    @test A[1, 2] == -38
    @test A[1, 3] isa Int
    @test A[1, 3] == -45
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[2, 1]

    A = InteractionMatrix{Int}(Int[2], Int[42, 40, 47], \)
    @test_throws TypeError A[1]
    @test_throws TypeError A[2]
    @test_throws TypeError A[3]
    @test_throws TypeError A[1, 1]
    @test_throws TypeError A[1, 2]
    @test_throws TypeError A[1, 3]

    A = InteractionMatrix{Float64}(Int[2], Int[42, 40,47], \)
    @test A[1] isa Float64
    @test A[1] == 21.0
    @test A[2] isa Float64
    @test A[2] == 20.0
    @test A[3] isa Float64
    @test A[3] == 23.5
    @test A[1, 1] isa Float64
    @test A[1, 1] == 21.0
    @test A[1, 2] isa Float64
    @test A[1, 2] == 20.0
    @test A[1, 3] isa Float64
    @test A[1, 3] == 23.5

    A = InteractionMatrix(Int[2], Float64[42, 40, 47], SimpleFun())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 3)
    @test_throws BoundsError A[]
    @test A[1] isa Float64
    @test A[1] == 46
    @test A[2] isa Float64
    @test A[2] == 44
    @test A[3] isa Float64
    @test A[3] == 51
    @test A[1, 1] isa Float64
    @test A[1, 1] == 46
    @test A[1, 2] isa Float64
    @test A[1, 2] == 44
    @test A[1, 3] isa Float64
    @test A[1, 3] == 51
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[2, 1]

    A = InteractionMatrix(Int[2], Float64[42, 40, 47], GenericFun{Float64}())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 3)
    @test_throws BoundsError A[]
    @test A[1] isa Float64
    @test A[1] == 46
    @test A[2] isa Float64
    @test A[2] == 44
    @test A[3] isa Float64
    @test A[3] == 51
    @test A[1, 1] isa Float64
    @test A[1, 1] == 46
    @test A[1, 2] isa Float64
    @test A[1, 2] == 44
    @test A[1, 3] isa Float64
    @test A[1, 3] == 51
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[2, 1]

    A = InteractionMatrix(Int[2], Float64[42, 40, 47], StatefulFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 3)
    @test_throws BoundsError A[]
    @test A[1] isa Float64
    @test A[1] == 92
    @test A[2] isa Float64
    @test A[2] == 88
    @test A[3] isa Float64
    @test A[3] == 102
    @test A[1, 1] isa Float64
    @test A[1, 1] == 92
    @test A[1, 2] isa Float64
    @test A[1, 2] == 88
    @test A[1, 3] isa Float64
    @test A[1, 3] == 102
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[2, 1]

    A = InteractionMatrix(Int[2], Float64[42, 40, 47], KwargsFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (1, 3)
    @test_throws BoundsError A[]
    @test_throws BoundsError getindex(A; α = 3.0)
    @test A[1] isa Float64
    @test A[1] == 2 * 46
    @test getindex(A, 1; α = 3.0) == 3 * 46
    @test A[2] isa Float64
    @test A[2] == 2 * 44
    @test getindex(A, 2; α = 3.0) == 3 * 44
    @test A[3] isa Float64
    @test A[3] == 2 * 51
    @test getindex(A, 3; α = 3.0) == 3 * 51
    @test A[1, 1] isa Float64
    @test A[1, 1] == 2 * 46
    @test getindex(A, 1, 1; α = 3.0) == 3 * 46
    @test A[1, 2] isa Float64
    @test A[1, 2] == 2 * 44
    @test getindex(A, 1, 2; α = 3.0) == 3 * 44
    @test A[1, 3] isa Float64
    @test A[1, 3] == 2 * 51
    @test getindex(A, 1, 3; α = 3.0) == 3 * 51
    @test_throws BoundsError A[4]
    @test_throws BoundsError getindex(A, 4; α = 3.0)
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[2, 1]
    @test_throws BoundsError getindex(A, 1, 4; α = 3.0)
    @test_throws BoundsError getindex(A, 2, 1; α = 3.0)
end

@testset "single colelem" begin
    A = InteractionMatrix(Int[42, 40, 47], Int[2], 11)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (3, 1)
    @test_throws BoundsError A[]
    @test A[1] isa Int
    @test A[1] == 11
    @test A[2] isa Int
    @test A[2] == 11
    @test A[3] isa Int
    @test A[3] == 11
    @test A[1, 1] isa Int
    @test A[1, 1] == 11
    @test A[2, 1] isa Int
    @test A[2, 1] == 11
    @test A[3, 1] isa Int
    @test A[3, 1] == 11
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 2]

    A = InteractionMatrix{Int}(Int[42, 40, 47], Int[2], -)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (3, 1)
    @test_throws BoundsError A[]
    @test A[1] isa Int
    @test A[1] == 40
    @test A[2] isa Int
    @test A[2] == 38
    @test A[3] isa Int
    @test A[3] == 45
    @test A[1, 1] isa Int
    @test A[1, 1] == 40
    @test A[2, 1] isa Int
    @test A[2, 1] == 38
    @test A[3, 1] isa Int
    @test A[3, 1] == 45
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 2]

    A = InteractionMatrix{Int}(Int[42, 40, 47], Int[2], /)
    @test_throws TypeError A[1]
    @test_throws TypeError A[2]
    @test_throws TypeError A[3]
    @test_throws TypeError A[1, 1]
    @test_throws TypeError A[2, 1]
    @test_throws TypeError A[3, 1]

    A = InteractionMatrix{Float64}(Int[42, 40,47], Int[2], /)
    @test A[1] isa Float64
    @test A[1] == 21.0
    @test A[2] isa Float64
    @test A[2] == 20.0
    @test A[3] isa Float64
    @test A[3] == 23.5
    @test A[1, 1] isa Float64
    @test A[1, 1] == 21.0
    @test A[2, 1] isa Float64
    @test A[2, 1] == 20.0
    @test A[3, 1] isa Float64
    @test A[3, 1] == 23.5

    A = InteractionMatrix(Int[42, 40, 47], Float64[2], SimpleFun())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 1)
    @test_throws BoundsError A[]
    @test A[1] isa Float64
    @test A[1] == 1766
    @test A[2] isa Float64
    @test A[2] == 1602
    @test A[3] isa Float64
    @test A[3] == 2211
    @test A[1, 1] isa Float64
    @test A[1, 1] == 1766
    @test A[2, 1] isa Float64
    @test A[2, 1] == 1602
    @test A[3, 1] isa Float64
    @test A[3, 1] == 2211
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 2]

    A = InteractionMatrix(Int[42, 40, 47], Float64[2], GenericFun{Float64}())
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 1)
    @test_throws BoundsError A[]
    @test A[1] isa Float64
    @test A[1] == 1766
    @test A[2] isa Float64
    @test A[2] == 1602
    @test A[3] isa Float64
    @test A[3] == 2211
    @test A[1, 1] isa Float64
    @test A[1, 1] == 1766
    @test A[2, 1] isa Float64
    @test A[2, 1] == 1602
    @test A[3, 1] isa Float64
    @test A[3, 1] == 2211
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 2]

    A = InteractionMatrix(Int[42, 40, 47], Float64[2], StatefulFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 1)
    @test_throws BoundsError A[]
    @test A[1] isa Float64
    @test A[1] == 1766 * 2
    @test A[2] isa Float64
    @test A[2] == 1602 * 2
    @test A[3] isa Float64
    @test A[3] == 2211 * 2
    @test A[1, 1] isa Float64
    @test A[1, 1] == 1766 * 2
    @test A[2, 1] isa Float64
    @test A[2, 1] == 1602 * 2
    @test A[3, 1] isa Float64
    @test A[3, 1] == 2211 * 2
    @test_throws BoundsError A[4]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 2]

    A = InteractionMatrix(Int[42, 40, 47], Float64[2], KwargsFun{Float64}(2.0))
    @test A isa AbstractArray{Float64, 2}
    @test size(A) == (3, 1)
    @test_throws BoundsError A[]
    @test_throws BoundsError getindex(A; α = 3.0)
    @test A[1] isa Float64
    @test A[1] == 1766 * 2
    @test getindex(A, 1; α = 3.0) == 1766 * 3
    @test A[2] isa Float64
    @test A[2] == 1602 * 2
    @test getindex(A, 2; α = 3.0) == 1602 * 3
    @test A[3] isa Float64
    @test A[3] == 2211 * 2
    @test getindex(A, 3; α = 3.0) == 2211 * 3
    @test A[1, 1] isa Float64
    @test A[1, 1] == 1766 * 2
    @test getindex(A, 1, 1; α = 3.0) == 1766 * 3
    @test A[2, 1] isa Float64
    @test A[2, 1] == 1602 * 2
    @test getindex(A, 2, 1; α = 3.0) == 1602 * 3
    @test A[3, 1] isa Float64
    @test A[3, 1] == 2211 * 2
    @test getindex(A, 3, 1; α = 3.0) == 2211 * 3
    @test_throws BoundsError A[4]
    @test_throws BoundsError getindex(A, 4; α = 3.0)
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 2]
    @test_throws BoundsError getindex(A, 4, 1; α = 3.0)
    @test_throws BoundsError getindex(A, 1, 2; α = 3.0)
end

@testset "ordinary" begin
    A = InteractionMatrix(Int[2, 5], Int[42, 40], 11)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (2, 2)
    @test_throws BoundsError A[]
    @test A[1] isa Int
    @test A[1] == 11
    @test A[2] isa Int
    @test A[2] == 11
    @test A[3] isa Int
    @test A[3] == 11
    @test A[4] isa Int
    @test A[4] == 11
    @test A[1, 1] isa Int
    @test A[1, 1] == 11
    @test A[2, 1] isa Int
    @test A[2, 1] == 11
    @test A[1, 2] isa Int
    @test A[1, 2] == 11
    @test A[2, 2] isa Int
    @test A[2, 2] == 11

    A = InteractionMatrix{Int}(Int[2, 5], Int[42, 40], -)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (2, 2)
    @test_throws BoundsError A[]
    @test A[1] isa Int
    @test A[1] == -40
    @test A[2] isa Int
    @test A[2] == -37
    @test A[3] isa Int
    @test A[3] == -38
    @test A[4] isa Int
    @test A[4] == -35
    @test A[1, 1] isa Int
    @test A[1, 1] == -40
    @test A[2, 1] isa Int
    @test A[2, 1] == -37
    @test A[1, 2] isa Int
    @test A[1, 2] == -38
    @test A[2, 2] isa Int
    @test A[2, 2] == -35

    A = InteractionMatrix{Int}(Int[42, 40], Int[2, 5], -)
    @test A isa AbstractArray{Int, 2}
    @test size(A) == (2, 2)
    @test_throws BoundsError A[]
    @test A[1] isa Int
    @test A[1] == 40
    @test A[2] isa Int
    @test A[2] == 38
    @test A[3] isa Int
    @test A[3] == 37
    @test A[4] isa Int
    @test A[4] == 35
    @test A[1, 1] isa Int
    @test A[1, 1] == 40
    @test A[2, 1] isa Int
    @test A[2, 1] == 38
    @test A[1, 2] isa Int
    @test A[1, 2] == 37
    @test A[2, 2] isa Int
    @test A[2, 2] == 35

    A = InteractionMatrix{Int}(Int[42, 40], Int[2, 5], /)
    @test_throws TypeError A[1]
    @test_throws TypeError A[2]
    @test_throws TypeError A[3]
    @test_throws TypeError A[4]
    @test_throws TypeError A[1, 1]
    @test_throws TypeError A[2, 1]
    @test_throws TypeError A[1, 2]
    @test_throws TypeError A[2, 2]

    A = InteractionMatrix{Float64}(Int[42, 40], Int[2, 5], /)
    @test A[1] isa Float64
    @test A[1] == 21.0
    @test A[2] isa Float64
    @test A[2] == 20.0
    @test A[3] isa Float64
    @test A[3] == 8.4
    @test A[4] isa Float64
    @test A[4] == 8.0
    @test A[1, 1] isa Float64
    @test A[1, 1] == 21.0
    @test A[2, 1] isa Float64
    @test A[2, 1] == 20.0
    @test A[1, 2] isa Float64
    @test A[1, 2] == 8.4
    @test A[2, 2] isa Float64
    @test A[2, 2] == 8.0

    A = InteractionMatrix{Float64}(view(Int[42, 40], :), view(Int[2, 5], :), /)
    @test A[1] isa Float64
    @test A[1] == 21.0
    @test A[2] isa Float64
    @test A[2] == 20.0
    @test A[3] isa Float64
    @test A[3] == 8.4
    @test A[4] isa Float64
    @test A[4] == 8.0
    @test A[1, 1] isa Float64
    @test A[1, 1] == 21.0
    @test A[2, 1] isa Float64
    @test A[2, 1] == 20.0
    @test A[1, 2] isa Float64
    @test A[1, 2] == 8.4
    @test A[2, 2] isa Float64
    @test A[2, 2] == 8.0

    A = InteractionMatrix(Int[1, 2, 3], Float64[10, 20, 30], SimpleFun())
    @test A isa AbstractMatrix{Float64}
    @test eltype(A) == Float64
    @test size(A) == (3, 3)
    @test A == Float64[11 21 31; 14 24 34; 19 29 39]
    @test_throws BoundsError A[]
    @test A[5] isa Float64
    @test A[5] == 24
    @test A[2, 2] isa Float64
    @test A[2, 2] == 24
    @test_throws BoundsError A[10]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[] = 13
    @test_throws CanonicalIndexError A[5] = 13
    @test_throws CanonicalIndexError A[2, 2] = 13

    A = InteractionMatrix(Int[1, 2, 3], Float64[10, 20, 30], GenericFun{Float64}())
    @test A isa AbstractMatrix{Float64}
    @test eltype(A) == Float64
    @test size(A) == (3, 3)
    @test A == Float64[11 21 31; 14 24 34; 19 29 39]
    @test_throws BoundsError A[]
    @test A[5] isa Float64
    @test A[5] == 24
    @test A[2, 2] isa Float64
    @test A[2, 2] == 24
    @test_throws BoundsError A[10]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[] = 13
    @test_throws CanonicalIndexError A[5] = 13
    @test_throws CanonicalIndexError A[2, 2] = 13

    A = InteractionMatrix(Int[1, 2, 3], Float64[10, 20, 30], StatefulFun{Float64}(2.0))
    @test A isa AbstractMatrix{Float64}
    @test eltype(A) == Float64
    @test size(A) == (3, 3)
    @test A == 2 .* Float64[11 21 31; 14 24 34; 19 29 39]
    @test_throws BoundsError A[]
    @test A[5] isa Float64
    @test A[5] == 48
    @test A[2, 2] isa Float64
    @test A[2, 2] == 48
    @test_throws BoundsError A[10]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[] = 13
    @test_throws CanonicalIndexError A[5] = 13
    @test_throws CanonicalIndexError A[2, 2] = 13

    A = InteractionMatrix(Int[1, 2, 3], Float64[10, 20, 30], KwargsFun{Float64}(2.0))
    @test A isa AbstractMatrix{Float64}
    @test eltype(A) == Float64
    @test size(A) == (3, 3)
    @test A == 2 .* Float64[11 21 31; 14 24 34; 19 29 39]
    @test A[:] == 2 .* Float64[11, 14, 19, 21, 24, 29, 31, 34, 39]
    @test A[:, :] == 2 .* Float64[11 21 31; 14 24 34; 19 29 39]
    @test getindex(A, :; α = 3.0) == 3 .* Float64[11, 14, 19, 21, 24, 29, 31, 34, 39]
    @test getindex(A, :, :; α = 3.0) == 3 .* Float64[11 21 31; 14 24 34; 19 29 39]
    @test A[A .> 50] == 2 .* Float64[29, 31, 34, 39]
    @test getindex(A, A .> 50; α = 3.0) == 3 .* Float64[29, 31, 34, 39] # bitmask refers so non-kwargs getindex!
    @test_throws BoundsError A[]
    @test_throws BoundsError getindex(A; α = 3.0)
    @test A[5] isa Float64
    @test A[5] == 2 * 24
    @test getindex(A, 5; α = 3.0) == 3 * 24
    @test A[2, 2] isa Float64
    @test A[2, 2] == 2 * 24
    @test getindex(A, 2, 2; α = 3.0) == 3 * 24
    @test A[[5]] isa Vector{Float64}
    @test A[[5]] == Float64[2 * 24]
    @test getindex(A, [5]; α = 3.0) == Float64[3 * 24]
    @test A[[2], [2]] isa Matrix{Float64}
    @test A[[2], [2]] == Float64[2 * 24;;]
    @test getindex(A, [2], [2]; α = 3.0) == Float64[3 * 24;;]
    @test_throws BoundsError A[10]
    @test_throws BoundsError getindex(A, 10; α = 3.0)
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError getindex(A, 4, 1; α = 3.0)
    @test_throws BoundsError getindex(A, 1, 4; α = 3.0)
end

@testset "views" begin
    A = InteractionMatrix{Float64}(Int[1, 2, 3], Int[10, 20, 30], /)

    @test view(A, :, :) isa AbstractMatrix{Float64}
    @test view(A, :, :) == A
    @test InteractionMatrix(A, :, :) isa AbstractMatrix{Float64}
    @test InteractionMatrix(A, :, :) == view(A, :, :)
    @test InteractionMatrix(A, :, 1:2) == view(A, :, 1:2)
    @test InteractionMatrix(A, 2:3, :) == view(A, 2:3, :)
    @test InteractionMatrix(A, [2], [2]) == view(A, [2], [2])
end

@testset "getindex parity" begin
    A = InteractionMatrix{Int}([1, 2, 3], [10, 20, 30], +)
    B = collect(A)
    mask = BitVector([true, false, true, false, true, false, true, false, true])
    mask3 = BitVector([true, false, true])
    bitmask = BitMatrix([true false true; false true false; true false true])

    indexing_forms = (
        X -> X[1, :],
        X -> X[:, 2],
        X -> X[1, 1:2],
        X -> X[1:2, 2],
        X -> X[1, [1, 2]],
        X -> X[[1, 2], 2],
        X -> X[begin, :],
        X -> X[:, end],
        X -> X[1:0, 1],
        X -> X[1, 1:0],
        X -> X[1:2, 1:2],
        X -> X[1:2, :],
        X -> X[:, 1:2],
        X -> X[:, :],
        X -> X[[1, 2], [1, 2]],
        X -> X[1:2, [1, 2]],
        X -> X[[1, 2], 1:2],
        X -> X[[1 2; 1 2], [1 2; 1 2]],
        X -> X[1:2, [1 2; 1 2]],
        X -> X[[1 2; 1 2], 1:2],
        X -> X[[1 2; 1 2], 1],
        X -> X[1, [1 2; 1 2]],
        X -> X[1, 2, 1],
        X -> X[1:2, 1:2, 1],
        X -> X[1:2, 1:2, :],
        X -> X[1:2, 1:2, 1:1],
        X -> X[1, 2, 1, 1],
        X -> X[1:2, 1:2, 1, 1],
        X -> X[1:2, 1:2, 1:1, 1:1],
        X -> X[CartesianIndex(1, 2)],
        X -> X[CartesianIndex.(1:2, 1:2)],
        X -> X[[CartesianIndex(1, 1), CartesianIndex(2, 2)]],
        X -> X[CartesianIndices(X)],
        X -> X[1:2, CartesianIndex(1, 1)],
        X -> X[:],
        X -> X[LinearIndices(X)],
        X -> X[axes(X)...],
        X -> X[begin:end],
        X -> X[mask],
        X -> X[bitmask],
        X -> X[mask3, 1:2],
        X -> X[1:2, mask3],
        X -> X[mask3, mask3],
        X -> X[X .> 20],
    )

    for f in indexing_forms
        a = f(A)
        b = f(B)
        @test a == b
        @test typeof(a) == typeof(b)
        @test size(a) == size(b)
    end

    idx = eachindex(A)
    @test A[idx] == B[idx]
    @test typeof(A[idx]) == typeof(B[idx])
    @test size(A[idx]) == size(B[idx])

    @test_throws BoundsError A[1, 4]
    @test_throws BoundsError A[4, 1]
    @test_throws BoundsError A[1, 1:4]
    @test_throws BoundsError A[1:4, 1]
    @test_throws BoundsError A[1, [1, 4]]
    @test_throws BoundsError A[[1, 4], 1]
    @test_throws BoundsError A[1, 2, 2]
    @test_throws BoundsError A[1:2, 1:2, 2]
    @test_throws BoundsError A[1:2, 1:2, 1:2]
    @test_throws BoundsError A[CartesianIndex(1, 1), 1:2]
end

@testset "getindex parity with kwargs" begin
    A = InteractionMatrix(Int[1, 2, 3], Float64[10, 20, 30], KwargsFun{Float64}(2.0))
    M = 3 .* Float64[11 21 31; 14 24 34; 19 29 39]

    @test getindex(A, 1, :; α = 3.0) == 3 .* Float64[11, 21, 31]
    @test getindex(A, :, 2; α = 3.0) == 3 .* Float64[21, 24, 29]
    @test getindex(A, 1, 1:2; α = 3.0) == 3 .* Float64[11, 21]
    @test getindex(A, 1:2, 2; α = 3.0) == 3 .* Float64[21, 24]
    @test getindex(A, 1, [1 2; 1 2]; α = 3.0) == 3 .* Float64[11 21; 11 21]
    @test getindex(A, [1 2; 1 2], 1; α = 3.0) == 3 .* Float64[11 14; 11 14]
    @test getindex(A, 1:2, 1:2, 1; α = 3.0) == 3 .* Float64[11 21; 14 24]
    @test getindex(A, 1:2, 1:2, :; α = 3.0) == 3 .* reshape(Float64[11 21; 14 24], 2, 2, 1)
    @test getindex(A, 1, 2, 1; α = 3.0) == 3 * 21
    @test getindex(A, 1, 2, 1, 1; α = 3.0) == 3 * 21
    @test getindex(A, CartesianIndex(1, 2); α = 3.0) == 3 * 21
    @test getindex(A, CartesianIndex.(1:2, 1:2); α = 3.0) == 3 .* Float64[11, 24]
    @test getindex(A, [CartesianIndex(1, 1), CartesianIndex(2, 2)]; α = 3.0) == 3 .* Float64[11, 24]
    @test getindex(A, 1:2, CartesianIndex(1, 1); α = 3.0) == 3 .* Float64[11, 14]
    @test getindex(A, :; α = 3.0) == 3 .* Float64[11, 14, 19, 21, 24, 29, 31, 34, 39]
    @test getindex(A, :, :; α = 3.0) == M
    @test getindex(A, CartesianIndices(A); α = 3.0) == M
    @test getindex(A, [1 2; 1 2], [1 2; 1 2]; α = 3.0) == M[[1 2; 1 2], [1 2; 1 2]]
    @test getindex(A, A .> 50; α = 3.0) == 3 .* Float64[29, 31, 34, 39]
end

@testset "summary" begin
    A = InteractionMatrix{Int}([1, 2, 3], [10, 20, 30], +)
    @test summary(A) == "3×3 InteractionMatrix{$(Int)}"
    @test startswith(sprint(show, MIME"text/plain"(), A), "3×3 InteractionMatrix{$(Int)}:")

    B = InteractionMatrix(Int[1, 2, 3], Float64[10, 20, 30], SimpleFun())
    @test summary(B) == "3×3 InteractionMatrix{Float64}"
    @test startswith(sprint(show, MIME"text/plain"(), B), "3×3 InteractionMatrix{Float64}:")

    C = InteractionMatrix([1, 2, 3], [10, 20, 30], 42)
    @test summary(C) == "3×3 InteractionMatrix{$(Int)}"

    E = InteractionMatrix(Int[], Int[], 11)
    @test summary(E) == "0×0 InteractionMatrix{$(Int)}"

    V = InteractionMatrix(A, 2:3, [1, 3])
    @test summary(V) == "2×2 InteractionMatrix{$(Int)}"
end

struct Sum3 <: InteractionFunction{Int, Tuple{Int, Int, Int}} end
(::Sum3)(x::Int, y::Int, z::Int) = x + y + z

@testset "InteractionArray 3-D" begin
    xs = [1, 2]
    ys = [10, 20]
    zs = [100, 200]
    A = InteractionArray((xs, ys, zs), Sum3())
    B = [x + y + z for x in xs, y in ys, z in zs]

    @test A isa AbstractArray{Int, 3}
    @test A isa InteractionArray{Int, 3}
    @test size(A) == (2, 2, 2)
    @test eltype(A) == Int
    @test ndims(A) == 3

    @test A[2, 2, 2] == 222
    @test A[5] == B[5]
    @test A[2, :, 1] == B[2, :, 1]
    @test A[:, :, 2] == B[:, :, 2]
    @test A[:] == B[:]
    @test A[CartesianIndex(2, 2, 2)] == 222
    @test A[CartesianIndices(A)] == B
    @test A[A .> 150] == B[B .> 150]

    @test summary(A) == "2×2×2 InteractionArray{$(Int)}"
    @test startswith(sprint(show, MIME"text/plain"(), A), "2×2×2 InteractionArray{$(Int)}:")

    @test_throws CanonicalIndexError A[1, 1, 1] = 0
    @test_throws BoundsError A[3, 1, 1]
    @test_throws BoundsError A[1, 3, 1]
    @test_throws BoundsError A[1, 1, 3]
end

@testset "InteractionArray constructors" begin
    xs = [1, 2, 3]
    ys = [10.0, 20.0]

    A = InteractionArray{Float64}((xs, ys), (x, y) -> x + y)
    @test A isa InteractionArray{Float64, 2}
    @test A[2, 1] == 12.0
    @test A[2, 1] isa Float64

    C = InteractionArray((xs, ys), 42.0)
    @test C isa InteractionArray{Float64, 2}
    @test C[3, 2] == 42.0
    @test all(==(42.0), C)

    D = InteractionArray(
        (xs, ys),
        GenericInteractionFunction{Float64, Tuple{Int, Float64}}((x, y) -> x / y)
    )
    @test D isa InteractionArray{Float64, 2}
    @test D[3, 2] == 0.15

    E = InteractionArray(
        (xs, ys),
        ConstInteractionFunction{Float64, Tuple{Int, Float64}}(7.0)
    )
    @test E isa InteractionArray{Float64, 2}
    @test E[1, 1] == 7.0

    @test_throws ArgumentError InteractionArray((Int[], Float64[], Int[]), Sum3())
end

@testset "InteractionArray views" begin
    xs = [1, 2, 3]
    ys = [10, 20, 30]
    zs = [100, 200, 300]
    A = InteractionArray((xs, ys, zs), Sum3())

    V = InteractionArray(A, 2:3, :, [2])
    @test V isa InteractionArray{Int, 3}
    @test size(V) == (2, 3, 1)
    @test V[1, 1, 1] == A[2, 1, 2]
    @test V[:, :, 1] == A[2:3, :, 2]
    @test V.axiselems[1] == [2, 3]
    @test V.axiselems[2] == [10, 20, 30]
    @test V.axiselems[3] == [200]

    W = InteractionArray(A, 2, 2, 2)
    @test size(W) == (1, 1, 1)
    @test W[] == 222
end

@testset "InteractionArray 1-D and 0-D" begin
    A = InteractionArray(([1, 2, 3],), ConstInteractionFunction{Int, Tuple{Int}}(7))
    @test A isa InteractionArray{Int, 1}
    @test size(A) == (3,)
    @test A[2] == 7
    @test A[:] == [7, 7, 7]
    @test summary(A) == "3-element InteractionArray{$(Int)}"

    E = InteractionArray((Int[],), ConstInteractionFunction{Int, Tuple{Int}}(7))
    @test E isa InteractionArray{Int, 1}
    @test size(E) == (0,)
    @test_throws BoundsError E[1]
    @test summary(E) == "0-element InteractionArray{$(Int)}"

    B = InteractionArray((), ConstInteractionFunction{Int, Tuple{}}(11))
    @test B isa InteractionArray{Int, 0}
    @test size(B) == ()
    @test B[] == 11
    @test summary(B) == "0-dimensional InteractionArray{$(Int)}"
    @test_throws CanonicalIndexError B[] = 12
end

@testset "InteractionMatrix alias" begin
    A = InteractionMatrix{Int}([1, 2, 3], [10, 20, 30], +)
    @test A isa InteractionMatrix
    @test A isa InteractionArray{Int, 2}
    @test A isa InteractionArray
    @test typeof(A) <: InteractionArray
    @test A.rowelems == [1, 2, 3]
    @test A.colelems == [10, 20, 30]
    @test A.axiselems == ([1, 2, 3], [10, 20, 30])
    @test propertynames(A) == (:rowelems, :colelems, :axiselems, :interact)

    B = InteractionMatrix([1, 2, 3], [10, 20, 30], 42)
    @test B isa InteractionMatrix
    @test B[2, 3] == 42

    C = InteractionMatrix(
        [10, 20],
        [5, 2],
        GenericInteractionFunction{Float64, Tuple{Int, Int}}(/)
    )
    @test C isa InteractionMatrix
    @test C[1, 1] == 2.0

    D = InteractionMatrix(
        [10, 20],
        [5, 2],
        ConstInteractionFunction{Float64, Tuple{Int, Int}}(7.0)
    )
    @test D isa InteractionMatrix
    @test D[1, 1] == 7.0

    E = InteractionMatrix(A, 2:3, [1, 3])
    @test E isa InteractionMatrix
    @test size(E) == (2, 2)
    @test E[1, 1] == A[2, 1]

    F = GenericInteractionFunction{Int, Tuple{Int, Int}}
    G = InteractionMatrix{Int, Int, Int, F, Vector{Int}, Vector{Int}}(
        [1, 2],
        [10, 20],
        F(+)
    )
    @test G isa InteractionMatrix
    @test G[2, 2] == 22

    H = InteractionMatrix{Int}([1, 2], [10, 20], F(+))
    @test H isa InteractionMatrix
    @test H[2, 2] == 22
end

@testset "InteractionFunction type parameter order" begin
    @test SimpleFun() isa InteractionFunction{Float64, Tuple{Int, Float64}}
    @test GenericFun{Float64}() isa InteractionFunction{Float64, Tuple{Int, Float64}}
    @test ConstInteractionFunction{Int, Tuple{Int, Int}}(42) isa
        InteractionFunction{Int, Tuple{Int, Int}}
    @test GenericInteractionFunction{Int, Tuple{Int, Int}}(+) isa
        InteractionFunction{Int, Tuple{Int, Int}}
end
