# Build docs from root directory of repository:
#
#   julia --project=docs/ docs/make.jl
#
# Serve docs this repository root to serve:
#
#  julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions, Lectionary

makedocs(
    sitename = "Lectionary.jl: API Documentation",
    pages = [
     
        "API documentation" => "index.md"
    ]
    )

deploydocs(
    repo = "github.com/neelsmith/Lectionary.jl.git",
) 
