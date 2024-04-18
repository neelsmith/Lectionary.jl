module Lectionary

using Dates
using AstroLib
using Documenter, DocStringExtensions

import Base: show
import Base: ==

export LiturgicalDay
export name, civildate, readings
export Sunday, PrincipalFeast, HolyDay, OtherDay


export LiturgicalYear, lectionary_year, daily_office_year
export sundays



export advent, christmas
export advent_season
export  christmasday, epiphanyday
export epiphany
export easter_sunday
export ash_wednesday, lent, palm_sunday, eastertide
export lent_season, easter_season
export pentecost, trinity, pentecost_season



include("sundayconsts.jl")
#include("feastconstants.jl")
include("days.jl")
include("feasts.jl")
include("sunday.jl")
include("fixeddates.jl")
include("year.jl")
include("seasons.jl")


end # module Lectionary
