view_suite = SUITE["InteractionMatrix"]["Views"]

let
    for T in (Float32, Float64), n in (10, 100, 1000)
        rows = rand(T, n)
        cols = rand(T, n)
        A    = InteractionMatrix{T}(rows, cols, +)
        ridx = collect(1:2:n)
        cidx = collect(n:-2:1)
        rrange = 2:(n-1)
        crange = 2:(n-1)

        view_suite["range ($T, $n)"]         = @benchmarkable InteractionMatrix($A, $rrange, $crange)
        view_suite["index vectors ($T, $n)"] = @benchmarkable InteractionMatrix($A, $ridx, $cidx)
        view_suite["collect ($T, $n)"]       = @benchmarkable collect(InteractionMatrix($A, $rrange, $crange))
        view_suite["collect view ($T, $n)"]  = @benchmarkable collect(view($A, $rrange, $crange))
    end
end
