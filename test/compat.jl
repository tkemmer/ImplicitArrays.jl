# CanonicalIndexError (since Julia 1.8)
# https://github.com/JuliaLang/julia/pull/43852
@static if !isdefined(Base, :CanonicalIndexError)
    const CanonicalIndexError = ErrorException
end
