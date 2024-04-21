struct Season
    seasonid::Int
    lityr::LiturgicalYear
end

function kalendar(s::Season)
    @warn("`kalendar` not yet implemented for type Season.")
    nothing
end

#
# Advent
#
"""Find a given Sunday in Advent in a given liturgical year.
$(SIGNATURES)

**Examples**


```julia-repl
julia> advent(1) 
the first Sunday of Advent, December 3, 2023
julia> advent(1, LiturgicalYear(2023))
the first Sunday of Advent, December 3, 2023
```
"""
function advent(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())::Sunday
    advent(sunday, lityr.starts_in)
end

"""Find a given Sunday in Advent in a given year of the civil calendar.

**Example**

```julia-repl
julia> advent(1, 2023)
the first Sunday of Advent, December 3, 2023
```

$(SIGNATURES)
"""
function advent(sunday::Int, yr::Int)::Sunday
    sundaystofind = 5 - sunday
    @debug("Look back $(sundaystofind) Sundays")
    xmas = Date(yr, 12, 25)

    sundaysfound = 0
    prev = xmas
    while sundaysfound < sundaystofind #&& Dates.dayname(prev) != "Sunday"
        @debug("found: $(sundaysfound) / $(sundaystofind)")
        prev = prev - Dates.Day(1)
        @debug("Look at $(prev): $(dayname(prev))")
        if dayname(prev) == "Sunday"
            sundaysfound = sundaysfound + 1
        end
    end
    Sunday(prev, sunday)
end

"""Find all Sundays of Advent in a given year of the civil calendar.


**Example**

```julia-repl
julia> advent_sundays(2023)
4-element Vector{Sunday}:
 the first Sunday of Advent, December 3, 2023
 the second Sunday of Advent, December 10, 2023
 the third Sunday of Advent, December 17, 2023
 the fourth Sunday of Advent, December 24, 2023
```

$(SIGNATURES)
"""
function advent_sundays(yr::Int)::Vector{Sunday}
    advent_sundays(LiturgicalYear(yr))
end

"""Find all Sundays of Advent in a given liturgical year.


**Examples**

```julia-repl
julia> advent_sundays()
4-element Vector{Sunday}:
 the first Sunday of Advent, December 3, 2023
 the second Sunday of Advent, December 10, 2023
 the third Sunday of Advent, December 17, 2023
 the fourth Sunday of Advent, December 24, 2023
 julia> advent_sundays(LiturgicalYear(2023))
4-element Vector{Sunday}:
 the first Sunday of Advent, December 3, 2023
 the second Sunday of Advent, December 10, 2023
 the third Sunday of Advent, December 17, 2023
 the fourth Sunday of Advent, December 24, 2023
```

$(SIGNATURES)
"""
function advent_sundays(lityear::LiturgicalYear = LiturgicalYear())::Vector{Sunday}
    [advent(sunday, lityear.starts_in) for sunday in 1:4] 
end


#
# Christmas
#
"""Find all Sundays in the season of Christmas in a given liturgical year.


**Examples**

```julia-repl
julia> christmas_sundays()
1-element Vector{Sunday}:
 the first Sunday after Christmas Day, December 31, 2023
 julia> christmas_sundays(LiturgicalYear(2023))
1-element Vector{Sunday}:
 the first Sunday after Christmas Day, December 31, 2023
```

$(SIGNATURES)
"""
function christmas_sundays(lityr::LiturgicalYear = LiturgicalYear())::Vector{Sunday}
    epiphany = Date(lityr.ends_in, 1, 6)
    xmas = Date(lityr.starts_in, 12, 25)
    prev = epiphany
    sundaycount = 0
    sundays = []
    while prev > xmas
        @debug("Look at date $(prev): $(dayname(prev))")
        prev = prev  - Dates.Day(1)
        if dayname(prev) == "Sunday"
            sundaycount = sundaycount + 1
            @debug("Found Sunday $(sundaycount) on $(prev)")
            push!(sundays, prev)
        end
    end
    ordered = sundays |> reverse
    if length(ordered) == 2
        [Sunday(ordered[1], CHRISTMAS_1),
        Sunday(ordered[2], CHRISTMAS_2)
        ]
    else
        [Sunday(ordered[1], CHRISTMAS_1)]
    end

end

"""Find all Sundays in the season of Christmas in a given year of the civil calendar.

**Examples**

```julia-repl
julia> christmas_sundays(2023)
1-element Vector{Sunday}:
 the first Sunday after Christmas Day, December 31, 2023
 ```

$(SIGNATURES)
"""
function christmas_sundays(yr::Int)::Vector{Sunday}
    christmas_sundays(LiturgicalYear(yr))
end


"""Find a given Sunday of the Christmas season in a given year of the civil calendar.

**Example**
```julia-repl
julia> christmas(1,  2023)
the first Sunday after Christmas Day, December 31, 2023
```

$(SIGNATURES)
"""
function christmas(sunday::Int, yr::Int)::Sunday
    christmas(sunday, LiturgicalYear(yr))
end

"""Find a given Sunday of the Christmas season in a given liturgical year.

**Examples**
```julia-repl
julia> christmas(1)
the first Sunday after Christmas Day, December 31, 2023
julia> christmas(1, LiturgicalYear(2023))
the first Sunday after Christmas Day, December 31, 2023
```

$(SIGNATURES)
"""
function christmas(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())::Sunday
    sundays = christmas_sundays(lityr)
    sunday > length(sundays) ? nothing : sundays[sunday]
end

#
# Epiphany
#
"""Find all Sundays of ordinary time after Epiphany in a given liturgical year.

**Examples**
```julia-repl
julia> epiphany_sundays()
6-element Vector{Sunday}:
 the Epiphany, January 7, 2024
 the first Sunday after the Epiphany, January 14, 2024
 the second Sunday after the Epiphany, January 21, 2024
 the third Sunday after the Epiphany, January 28, 2024
 the fourth Sunday after the Epiphany, February 4, 2024
 the fifth Sunday after the Epiphany, February 11, 2024
 julia> epiphany_sundays(LiturgicalYear(2023))
6-element Vector{Sunday}:
 the Epiphany, January 7, 2024
 the first Sunday after the Epiphany, January 14, 2024
 the second Sunday after the Epiphany, January 21, 2024
 the third Sunday after the Epiphany, January 28, 2024
 the fourth Sunday after the Epiphany, February 4, 2024
 the fifth Sunday after the Epiphany, February 11, 2024

```


$(SIGNATURES)
"""
function epiphany_sundays(lityr::LiturgicalYear = LiturgicalYear())::Vector{Sunday}
    epiphany_sundays(lityr.ends_in)
end


"""Find all Sundays of ordinary time after Epiphany season in a given year of the civil calendar.

**Example**

```julia-repl
julia> epiphany_sundays(2023)
7-element Vector{Sunday}:
 the Epiphany, January 8, 2023
 the first Sunday after the Epiphany, January 15, 2023
 the second Sunday after the Epiphany, January 22, 2023
 the third Sunday after the Epiphany, January 29, 2023
 the fourth Sunday after the Epiphany, February 5, 2023
 the fifth Sunday after the Epiphany, February 12, 2023
 the sixth Sunday after the Epiphany, February 19, 2023
```
$(SIGNATURES)
"""
function epiphany_sundays(yr::Int)::Vector{Sunday}
    @debug("Get ash wed for year $(yr)")
    endpoint = ash_wednesday(yr)
    epiph = Dates.Date(yr, 1, 6)
    
    prev = endpoint
    sundays = []
    while prev > epiph
        prev = prev  - Dates.Day(1)
        if dayname(prev) == "Sunday"
            push!(sundays, prev)
        end
    end
    ordered = sundays |> reverse

    sundaylist = Sunday[]
    predecessor  = EPIPHANY  - 1
    for (i, sday) in enumerate(ordered)
        push!(sundaylist, Sunday(sday, predecessor + i))
    end
    sundaylist
end



"""
one method
$(SIGNATURES)
"""
function epiphany_day(lityr::LiturgicalYear = LiturgicalYear())::Feast
    epiphany_day(lityr.ends_in)
end

"""
another method
$(SIGNATURES)
"""
function epiphany_day(yr::Int)::Feast
    Feast(FEAST_EPIPHANY, yr)
end



#
# Lent
#
function ash_wednesday(lityr::LiturgicalYear = LiturgicalYear())::Feast
    ash_wednesday(lityr.ends_in)
end
function ash_wednesday(yr::Int)::Feast
    Feast(FAST_ASH_WEDNESDAY, yr)
end

function ash_wednesday_date(lityr::LiturgicalYear = LiturgicalYear())::Date
    ash_wednesday_date(lityr.ends_in)
end

"""Find date of Ash Wednesday for a given year.
$(SIGNATURES)
"""
function ash_wednesday_date(yr::Int)::Date
    lent(1, yr).dt - Dates.Day(4)
end


function lent(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())
    lent(sunday)
end

"""Find date of a given week of Lent in a given year.
$(SIGNATURES)
"""
function lent(sunday::Int, yr::Int)
    sundaystofind = 7 - sunday
    sunday_date = easter_sunday(yr).dt - Dates.Day(sundaystofind * 7)

    predecessor = LENT_1 - 1
    Sunday(sunday_date, predecessor + sunday)
end


"""Find date of Palm Sunday for a given liturgical year.
$(SIGNATURES)
"""
function palm_sunday(lityr::LiturgicalYear = LiturgicalYear())
    palm_sunday(lityr.ends_in)
end


"""Find date of Palm Sunday for a given year.
$(SIGNATURES)
"""
function palm_sunday(yr::Int)
    dt = easter_sunday(yr).dt - Dates.Day(7)
    Sunday(dt, PALM_SUNDAY)
end

"""Find Sundays of Lent in a given liturgical year.
$(SIGNATURES)
"""
function lent_season(yr::Int)
    lent_season(LiturgicalYear(yr))
end

"""Find Sundays of Lent in a given liturgical year.
$(SIGNATURES)
"""
function lent_season(lityear::LiturgicalYear = LiturgicalYear())
    [lent(sunday, lityear.ends_in) for sunday in 1:5] 
end



#
# EASTER AND EASTERTIDE
#

"""Find date of Easter in a given liturgical year.
$(SIGNATURES)
"""
function easter_sunday(lityr::LiturgicalYear = LiturgicalYear())
    easter_sunday(lityr.ends_in)
end

"""Find date of Easter in a given year.
$(SIGNATURES)
"""
function easter_sunday(yr::Int)
    hr = Dates.DateTime(yr, 3, 21)
    while mphase(jdcnv(hr)) < 0.99
        hr = hr + Dates.Hour(1)
    end
    fullmoon = Date(yr, month(hr), day(hr))
    nxtday = fullmoon + Dates.Day(1)
    while dayname(nxtday) != "Sunday"
        nxtday = nxtday + Dates.Day(1)
    end
    Sunday(nxtday, EASTER_SUNDAY)
end

"""Find date of a given week of Easter season in a given year.
$(SIGNATURES)
"""
function eastertide(sunday::Int, yr::Int)
    @assert sunday < 8 && sunday > 1
    #predecessor = easter_sunday(yr).dt - Dates.Day(1)
    @debug("Find sunday $(sunday) in $(yr)")
    @debug("Easter is $(easter_sunday(yr).dt)")
    thesunday =  easter_sunday(yr).dt + Dates.Day((sunday - 1) * 7)


    Sunday(thesunday, EASTER_SUNDAY + (sunday - 1))
end

function easter_season(lityr::LiturgicalYear = LiturgicalYear())
    easter_season(lityr.ends_in)
end

function easter_season(yr::Int)
    [eastertide(sunday, yr) for sunday in 2:7] 
end



#
# Pentecost
#
"""Find the Sunday of Pentecost in a liturgical year.
$(SIGNATURES)
"""
function pentecost_day(lityr::LiturgicalYear = LiturgicalYear())
    pentecost_day(lityr.ends_in)
end


"""Find the Sunday of Pentecost in a year of the civil calendar.
$(SIGNATURES)
"""
function pentecost_day(yr::Int)
    dt = easter_season(yr)[end].dt + Dates.Day(7)
    Sunday(dt, PENTECOST)
end


"""Find Trinity Sunday in a liturgical year.
$(SIGNATURES)
"""
function trinity(lityr::LiturgicalYear = LiturgicalYear())
    trinity(lityr.ends_in)
end

"""Find Trinity Sunday in a year of the civil calendar.
$(SIGNATURES)
"""
function trinity(yr::Int)
    dt = pentecost_day(yr).dt + Dates.Day(7)
    Sunday(dt, TRINITY_SUNDAY)
end


"""Find a given Sunday in ordinary time after Pentecost.
$(SIGNATURES)
"""
function pentecost(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())
    pentecost(sunday, lityr.ends_in)
end

"""Find a given Sunday in ordinary time after Pentecost.
$(SIGNATURES)
"""
function pentecost(sunday::Int, yr::Int)
    @assert sunday > 1 && sunday < 30
    endpoint = advent(1, yr).dt
    startpoint = trinity(yr).dt

    @debug("Date range is $(startpoint) - $(endpoint)")
    sundaystofind = sunday - 1

    @debug("Look back $(sundaystofind) Sundays")
    

    sundaysfound = 0
    prev = startpoint
    while sundaysfound < sundaystofind
        @debug("found: $(sundaysfound) / $(sundaystofind)")
        prev = prev + Dates.Day(1)
        @debug("Look at $(prev): $(dayname(prev))")
        if dayname(prev) == "Sunday"
            sundaysfound = sundaysfound + 1
        end

    end

    sundaysfound > 0 && prev < endpoint ? Sunday(prev, PENTECOST  + sunday) : nothing
end


"""In a given liturgical year, find Sundays in ordinary time after Pentecost.
$(SIGNATURES)
"""
function pentecost_season(lityr::LiturgicalYear = LiturgicalYear())
    pentecost_season(lityr.ends_in)
end



"""In a given year in the civil calendar, find Sundays in ordinary time after Pentecost.
$(SIGNATURES)
"""
function pentecost_season(yr::Int)
    sundayslist = []
    for i in 2:28
        sunday = pentecost(i, yr)
        if ! isnothing(sunday)
            push!(sundayslist, sunday)
        end
    end
    sundayslist
end


"""Find Ascension Day in a given liturgical year.
$(SIGNATURES)
"""
function ascension(lityr::LiturgicalYear = LiturgicalYear())
    ascension(lityr.ends_in)
end

"""Find Ascension Day in a given year of the civil calendar.
$(SIGNATURES)
"""
function ascension(yr::Int)
    easter_sunday(yr).dt + Dates.Day(40)
end



"""Find Thanksgiving Day in a given liturgical year.
$(SIGNATURES)
"""
function thanksgiving(lityr::LiturgicalYear = LiturgicalYear())
    thanksgiving(lityr.ends_in)
end


"""Find Thanksgiving Day in a given year of the civil calendar.
$(SIGNATURES)
"""
function thanksgiving(yr::Int)
    currday = Date(yr, 11)
    thursdaycount = dayname(currday) == "Thursday" ? 1 : 0

    while thursdaycount < 4
        currday = currday + Dates.Day(1)
        if dayname(currday) == "Thursday"
            thursdaycount = thursdaycount + 1
        end
    end
    currday
end