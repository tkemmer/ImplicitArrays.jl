struct Distance{T} <: InteractionFunction{T, T, T} end
(::Distance{T})(x::T, y::T) where T = sqrt(x * x + y * y)

struct ScaleFun{T} <: InteractionFunction{T, T, T}
    α::T
end
(f::ScaleFun{T})(x::T, y::T) where T = f.α * (x + y)

construct_suite = SUITE["InteractionMatrix"]["Construction"]

let
    for T in (Float32, Float64), n in (10, 100, 1000)
        rows = rand(T, n)
        cols = rand(T, n)
        val  = one(T)
        dist = Distance{T}()
        fun  = ScaleFun(one(T))

        construct_suite["constant ($T, $n)"] = @benchmarkable InteractionMatrix($rows, $cols, $val)
        construct_suite["generic ($T, $n)"]  = @benchmarkable InteractionMatrix{$T}($rows, $cols, +)
        construct_suite["custom ($T, $n)"]   = @benchmarkable InteractionMatrix($rows, $cols, $dist)
        construct_suite["stateful ($T, $n)"] = @benchmarkable InteractionMatrix($rows, $cols, $fun)
    end
end
