@testset "invalid row bounds" begin
    M = [1 2 3; 4 5 6; 7 8 9]
    @test_throws BoundsError RowProjectionMatrix(M, 0)
    @test_throws BoundsError RowProjectionMatrix(M, 0, 1)
    @test_throws BoundsError RowProjectionMatrix(M, 1, 0)
    @test_throws BoundsError RowProjectionMatrix(M, 4)
    @test_throws BoundsError RowProjectionMatrix(M, 1, 4)
    @test_throws BoundsError RowProjectionMatrix(M, 4, 1)
end

@testset "single row" begin
    M = [1 2 3; 4 5 6; 7 8 9]
    for row ∈ 1:size(M)[1]
        A = RowProjectionMatrix(M, row)
        @test A isa RowProjectionMatrix{Int}
        @test size(A) == (1, size(M)[2])
        @test length(A) == size(M)[1]
        @test_throws BoundsError A[]
        @test_throws BoundsError A[] = 41
        @test_throws BoundsError A[0]
        @test_throws BoundsError A[0] = 41
        for col ∈ 1:size(M)[2]
            @test A[col] == M[row, col]
            @test A[1, col] == M[row, col]

            A[col] = row + col
            @test A[col] == row + col
            @test A[1, col] == row + col
            @test M[row, col] == row + col

            A[1, col] = 10 + row + col
            @test A[col] == 10 + row + col
            @test A[1, col] == 10 + row + col
            @test M[row, col] == 10 + row + col

            M[row, col] = 100 + row + col
            @test A[col] == 100 + row + col
            @test A[1, col] == 100 + row + col
        end
        @test_throws BoundsError A[length(A) + 1]
        @test_throws BoundsError A[length(A) + 1] = 41
    end
end

@testset "row subset" begin
    @test_skip "TODO"
end

@testset "row bag" begin
    @test_skip "TODO"
end

@testset "full projection" begin
    @test_skip "TODO"
end
