module Lectionary

using Dates
using AstroLib
using Documenter, DocStringExtensions

import Base: show
import Base: ==



export LiturgicalYear, lectionary_year, daily_office_year
export sundays, principal_feasts, holy_days
export liturgical_year, liturgical_day, date_range

export LiturgicalSeason

export LiturgicalDay
export name, civildate, weekday, readings, precedence
export kalendar
export Sunday, Commemoration,  OtherDay



export advent, advent_sundays
export christmas, christmas_day, christmas_sundays
export epiphany_day, epiphany_sundays
export easter_sunday
export ash_wednesday, lent, palm_sunday, holyweek, good_friday
export ash_wednesday_date
export lent_season, easter_sundays
export eastertide
export ascension
export pentecost, pentecost_day, trinity, pentecost_season
export thanksgiving

export calendar_week, calendar_month, calendar_year

export Reading, readings, ot, nt, psalm, gospel


include("selections.jl")





include("year.jl")

include("seasonconstants.jl")
include("sundayconsts.jl")
include("feastconstants.jl")
include("readingconstants.jl")
include("propersconstants.jl")
include("fixeddates.jl")
include("days.jl")
include("commemorations.jl")
include("sunday.jl")
include("holydays.jl")
include("otherdays.jl")


include("seasons.jl")


include("reading.jl")

include("gregorian.jl")

include("debug.jl")

end # module Lectionary
