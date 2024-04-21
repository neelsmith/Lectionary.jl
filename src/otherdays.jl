

"""A day in the liturgical calendar that is not identified as
a feast, fast or Sunday.
"""
struct OtherDay <: LiturgicalDay
    dt::Date
end

"""Override `Base.==` for `OtherDay`.
$(SIGNATURES)
"""
function ==(day1::OtherDay, day2::OtherDay)
    day1.dt == day2.date
end


"""Override `Base.show` for type `OtherDay`.

**Example**
```julia-repl
julia> liturgical_day(Date(2024, 5, 6))
May 6, 2024, Monday following the sixth Sunday of Easter
```

$(SIGNATURES)
"""
function show(io::IO, otherday::OtherDay)
    
    nm = name(otherday)
    dt = civildate(otherday)
    if isnothing(dt)
       write(io, string(nm, " (no date)"))
    else
        formatteddate = string(monthname(dt), " ",  dayofmonth(dt), ", ", year(dt))
        write(io, formatteddate * ", " * nm  )
    end
end

## Modify to find liturgical year, look up found sunday in list of sundays
"""Name of an `OtherDay` in the liturgical calendar.

**Example**

```julia-repl
julia> otherday = OtherDay(Date(2024, 5, 6))
May 6, 2024, Monday following the sixth Sunday of Easter
julia> name(otherday)
"Monday following the sixth Sunday of Easter"
```

$(SIGNATURES)
"""
function name(other::OtherDay)
   
    backwardday = other.dt
    while dayname(backwardday) != "Sunday"
        backwardday = backwardday - Dates.Day(1)
    end
    sday = liturgical_day(backwardday)
   string(dayname(other.dt), " following ", name(sday))
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