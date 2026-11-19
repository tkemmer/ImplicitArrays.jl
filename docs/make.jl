using ImplicitArrays
using Documenter, DocumenterCodeBlocks

const pages = [
    "Home" => "index.md",
    "Interaction matrices" => "interaction.md",
    "Historic types" => "historic.md"
]

makedocs(
    modules   = [ImplicitArrays],
    clean     = true,
    doctest   = true,
    linkcheck = get(ENV, "CI", nothing) == "true",
    checkdocs = :all,
    pages     = pages,
    format    = Documenter.HTML(),
    sitename  = "ImplicitArrays.jl",
    repo      = Remotes.GitHub("tkemmer", "ImplicitArrays.jl"),
    plugins   = [CodeBlocks()],
)

deploydocs(;
    repo = "github.com/tkemmer/ImplicitArrays.jl.git",
    devbranch = "master"
)
