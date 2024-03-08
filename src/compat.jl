#=
    CanonicalIndexError (since Julia 1.8)
    https://github.com/JuliaLang/julia/pull/43852
=#

function _throw_canonical_error(fun::String, T::Type)
    @static if isdefined(Base, :CanonicalIndexError)
        throw(CanonicalIndexError(fun, T))
    else
        error("$fun not defined for $T")
    end
end

@static if !isdefined(Base, :CanonicalIndexError)
    const CanonicalIndexError = ErrorException
end
