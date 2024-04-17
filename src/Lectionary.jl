module Lectionary

using Dates
using AstroLib
using Documenter, DocStringExtensions

import Base: show
import Base: ==

export LiturgicalYear, lectionary_year, daily_office_year
export sundays
export Sunday

export advent, christmas
export advent_season
export  christmasday, epiphanyday
export epiphany
export easter_sunday
export ash_wednesday, lent, palm_sunday, eastertide
export lent_season, easter_season
export pentecost



include("sundayconsts.jl")
include("sunday.jl")
include("fixeddates.jl")
include("year.jl")
include("yearcomputus.jl")


end # module Lectionary
