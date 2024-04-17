module Lectionary

using Dates
using AstroLib
using Documenter, DocStringExtensions

import Base: show
import Base: ==

export LiturgicalYear, lectionary_year, sundays

export advent, christmas
export  christmasday, epiphanyday
export epiphany
export easter
export ash_wednesday, lent, palmsunday, eastertide
export lentseason



include("sundayconsts.jl")
include("fixeddates.jl")
include("year.jl")
include("yearcomputus.jl")


end # module Lectionary
