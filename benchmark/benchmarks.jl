using BenchmarkTools
using ImplicitArrays

const SUITE = BenchmarkGroup()

include("interaction/construct.jl")
include("interaction/getindex.jl")
include("interaction/view.jl")
include("interaction/materialize.jl")
