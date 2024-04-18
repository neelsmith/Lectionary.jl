

struct OtherDay <: LiturgicalDay
    dt::Date
end

## Modify to find liturgical year, look up found sunday in list of sundays
function name(other::OtherDay)
   
    backwardday = other.dt
    while dayname(backwardday) != "Sunday"
        backwardday = backwardday - Dates.Day(1)
    end
    sday = liturgical_day(backwardday)
   string(dayname(other.dt), " following ", sday)
end

"""Find date in civil calendar for a day in the liturgical year.
$(SIGNATURES)
"""
function civildate(other::OtherDay)
    other.dt
end






function closestsunday(other::OtherDay)
    forwardcount = 0
    forwardday = other.dt
    while dayname(forwardday) != "Sunday"
        forwardcount = forwardcount + 1
        forwardday = forwardday + Dates.Day(1)
        @debug("Forwarfd day is $(forwardday) $(dayname(forwardday))")
    end

    backwardcount = 0
    backwardday = other.dt
    while dayname(backwardday) != "Sunday"
        backwardcount = backwardcount + 1
        backwardday = backwardday - Dates.Day(1)
        @debug("Back day is $(backwardday) $(dayname(backwardday))")
    end
    forwarddiff = forwardday - other.dt
    backwarddiff = backwardday - other.dt
    sunday = forwardcount > backwardcount ? forwardday : backwardday
    

    #forwarddiff > backwarddiff
end