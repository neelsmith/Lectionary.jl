module Lectionary

using Dates
using AstroLib
using Documenter, DocStringExtensions

import Base: show
import Base: ==

export LiturgicalYear, lectionary_year

export advent, christmas
export  christmasday, epiphanyday
export easter
export ash_wednesday, lent, palmsunday

include("year.jl")
include("yearcomputus.jl")

end # module Lectionary
