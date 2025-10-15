@testitem "InteractionMatrix" begin
    struct SimpleFun <: InteractionFunction{Int, Float64, Float64} end
    (::SimpleFun)(r::Int, c::Float64) = r * r + c

    struct GenericFun{T <: AbstractFloat} <: InteractionFunction{Int, T, T} end
    (::GenericFun{T})(r::Int, c::T) where T = r * r + c

    struct StatefulFun{T <: AbstractFloat} <: InteractionFunction{Int, T, T}
        α::T
    end
    (f::StatefulFun{T})(r::Int, c::T) where T = f.α * (r * r + c)

    struct KwargsFun{T <: AbstractFloat} <: InteractionFunction{Int, T, T}
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
end
