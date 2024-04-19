module Lectionary

using Dates
using AstroLib
using Documenter, DocStringExtensions

import Base: show
import Base: ==

export LiturgicalDay
export name, civildate, weekday, readings, priority
export Sunday, Feast, HolyDay, OtherDay


export LiturgicalYear, lectionary_year, daily_office_year
export sundays, principal_feasts, holy_days
export liturgical_year, liturgical_day

export advent, christmas, christmas_day
export advent_season
export epiphany_season
export easter_sunday
export ash_wednesday, lent, palm_sunday, eastertide
export lent_season, easter_season
export ascension
export pentecost, trinity, pentecost_season
export thanksgiving

export Reading, readings, ot, nt, psalm, gospel


include("sundayconsts.jl")
include("feastconstants.jl")
include("fixeddates.jl")
include("days.jl")
include("feasts.jl")
include("sunday.jl")
include("holydays.jl")
include("otherdays.jl")

include("year.jl")
include("seasons.jl")

include("reading.jl")
include("readingconstants.jl")


end # module Lectionary
