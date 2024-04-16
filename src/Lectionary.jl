module Lectionary

using Dates
using Documenter, DocStringExtensions

import Base: show
import Base: ==

export LiturgicalYear, lectionary_year

export advent, christmasday, epiphanyday

include("year.jl")
include("yearcomputus.jl")

end # module Lectionary
