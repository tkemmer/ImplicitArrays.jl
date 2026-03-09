using ParallelTestRunner
import ImplicitArrays

const init_code = quote
    using ImplicitArrays
end

runtests(ImplicitArrays, ["--verbose", ARGS...]; init_code)
