materialize_suite = SUITE["InteractionMatrix"]["Materialization"]

let
    for T in (Float32, Float64), n in (10, 100, 1000)
        rows = rand(T, n)
        cols = rand(T, n)
        A    = InteractionMatrix{T}(rows, cols, +)
        x    = ones(T, n)

        materialize_suite["collect ($T, $n)"]        = @benchmarkable collect($A)
        materialize_suite["sum ($T, $n)"]            = @benchmarkable sum($A)
        materialize_suite["maximum ($T, $n)"]        = @benchmarkable maximum($A)
        materialize_suite["matrix product ($T, $n)"] = @benchmarkable $A * $x
    end
end
