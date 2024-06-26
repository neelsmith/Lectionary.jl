
#
# Advent
#
"""Find a numbered Sunday in Advent in a given liturgical year.
$(SIGNATURES)

**Examples**


```julia-repl
julia> advent(1) 
the first Sunday of Advent, December 3, 2023
julia> advent(1, LiturgicalYear(2023))
the first Sunday of Advent, December 3, 2023
```
"""
function advent(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    advent(sunday, lityr.starts_in)
end

"""Find a numbered Sunday in Advent in a given year of the civil calendar.

**Example**

```julia-repl
julia> advent(1, 2023)
the first Sunday of Advent, December 3, 2023
```

$(SIGNATURES)
"""
function advent(sunday::Int, yr::Int)::LiturgicalSunday
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
    LiturgicalSunday(prev, sunday)
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
function advent_sundays(yr::Int)::Vector{LiturgicalSunday}
    advent_sundays(LiturgicalYear(yr))
end

"""Find all Sundays of Advent in a given liturgical year.


**Examples**

```julia-repl
julia> advent_sundays()
4-element Vector{LiturgicalSunday}:
 the first Sunday of Advent, December 3, 2023
 the second Sunday of Advent, December 10, 2023
 the third Sunday of Advent, December 17, 2023
 the fourth Sunday of Advent, December 24, 2023
 julia> advent_sundays(LiturgicalYear(2023))
4-element Vector{LiturgicalSunday}:
 the first Sunday of Advent, December 3, 2023
 the second Sunday of Advent, December 10, 2023
 the third Sunday of Advent, December 17, 2023
 the fourth Sunday of Advent, December 24, 2023
```

$(SIGNATURES)
"""
function advent_sundays(lityear::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalSunday}
    [advent(sunday, lityear.starts_in) for sunday in 1:4] 
end


#
# Christmas
#
"""Find all Sundays in the season of Christmas in a given liturgical year.


**Examples**

```julia-repl
julia> christmas_sundays()
1-element Vector{LiturgicalSunday}:
 the first Sunday after Christmas Day, December 31, 2023
 julia> christmas_sundays(LiturgicalYear(2023))
1-element Vector{LiturgicalSunday}:
 the first Sunday after Christmas Day, December 31, 2023
```

$(SIGNATURES)
"""
function christmas_sundays(lityr::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalSunday}
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
        [LiturgicalSunday(ordered[1], CHRISTMAS_1),
        LiturgicalSunday(ordered[2], CHRISTMAS_2)
        ]
    else
        [LiturgicalSunday(ordered[1], CHRISTMAS_1)]
    end

end

"""Find all Sundays in the season of Christmas in a given year of the civil calendar.

**Examples**

```julia-repl
julia> christmas_sundays(2023)
1-element Vector{LiturgicalSunday}:
 the first Sunday after Christmas Day, December 31, 2023
 ```

$(SIGNATURES)
"""
function christmas_sundays(yr::Int)::Vector{LiturgicalSunday}
    christmas_sundays(LiturgicalYear(yr))
end


"""Find a numbered Sunday of the Christmas season in a given year of the civil calendar.

**Example**
```julia-repl
julia> christmas(1,  2023)
the first Sunday after Christmas Day, December 31, 2023
```

$(SIGNATURES)
"""
function christmas(sunday::Int, yr::Int)::LiturgicalSunday
    christmas(sunday, LiturgicalYear(yr))
end

"""Find a numbered Sunday of the Christmas season in a given liturgical year.

**Examples**
```julia-repl
julia> christmas(1)
the first Sunday after Christmas Day, December 31, 2023
julia> christmas(1, LiturgicalYear(2023))
the first Sunday after Christmas Day, December 31, 2023
```

$(SIGNATURES)
"""
function christmas(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    sundays = christmas_sundays(lityr)
    sunday > length(sundays) ? nothing : sundays[sunday]
end

#
# Epiphany
#
"""Find a numbered Sunday of the ordinary time after Epiphany in a given liturgical year.
"""
function epiphany(sunday::Int,  lityr::LiturgicalYear = LiturgicalYear())
    epiphany_sundays(lityr)[sunday]
end


"""Find all Sundays of ordinary time after Epiphany in a given liturgical year.

**Examples**
```julia-repl
julia> epiphany_sundays()
5-element Vector{LiturgicalDay}:
 the first Sunday after the Epiphany, January 7, 2024
 the second Sunday after the Epiphany, January 14, 2024
 the third Sunday after the Epiphany, January 21, 2024
 the fourth Sunday after the Epiphany, January 28, 2024
 the fifth Sunday after the Epiphany, February 4, 2024
julia> epiphany_sundays(LiturgicalYear(2023))
5-element Vector{LiturgicalDay}:
 the first Sunday after the Epiphany, January 7, 2024
 the second Sunday after the Epiphany, January 14, 2024
 the third Sunday after the Epiphany, January 21, 2024
 the fourth Sunday after the Epiphany, January 28, 2024
 the fifth Sunday after the Epiphany, February 4, 2024
```

$(SIGNATURES)
"""
function epiphany_sundays(lityr::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalSunday}
    @debug("Find sundays in ordinary time after Epiphany for $(lityr.ends_in)")
    epiphany_sundays(lityr.ends_in)
end


"""Find all Sundays of ordinary time after Epiphany season in a given year of the civil calendar. Omit Transfiguration, for inclusion in list of Commemorations.

**Example**

```julia-repl
julia> epiphany_sundays(LiturgicalYear(2023))
5-element Vector{LiturgicalDay}:
the first Sunday after the Epiphany, January 7, 2024
the second Sunday after the Epiphany, January 14, 2024
the third Sunday after the Epiphany, January 21, 2024
the fourth Sunday after the Epiphany, January 28, 2024
the fifth Sunday after the Epiphany, February 4, 2024
```
$(SIGNATURES)
"""
function epiphany_sundays(yr::Int)::Vector{LiturgicalSunday}
    
    endpoint = ash_wednesday(yr)
    @debug("Got ash wed for year $(yr): $(endpoint) with date $(civildate(endpoint))")
    epiph = Dates.Date(yr, 1, 6)
    
    prev = endpoint |> civildate
    @debug("Ranging from $(prev) back to $(epiph)")
    sundays = []
    while prev > epiph
        prev = prev  - Dates.Day(1)
        if dayname(prev) == "Sunday"
            @debug("Found Sunday $(prev)")
            push!(sundays, prev)
        end
    end
    ordered = sundays |> reverse
    
    sundaylist = LiturgicalDay[]
    predecessor  = EPIPHANY  # - 1
    for (i, sday) in enumerate(ordered[1:end - 1]) 
        push!(sundaylist, LiturgicalSunday(sday, predecessor + i))
    end
    xfig = LiturgicalSunday(ordered[end], TRANSFIGURATION_SUNDAY)
    push!(sundaylist, xfig)
    ##@debug("Added $(length(sundaylist))) Sundays; now add transfiguration for $(year(ordered[end]))")
    
    
    sundaylist
end


"""Construct the Day of Epiphany for a given liturgical year.

**Examples**

```julia-repl
julia> epiphany_day()
The Epiphany, January 6, 2024
julia> epiphany_day(LiturgicalYear(2023))
The Epiphany, January 6, 2024
```
$(SIGNATURES)
"""
function epiphany_day(lityr::LiturgicalYear = LiturgicalYear())::Commemoration
    epiphany_day(lityr.ends_in)
end

"""Construct the Day of Epiphany for a given year in the civil calendar.

**Example**
```julia-repl
julia> epiphany_day(2024)
The Epiphany, January 6, 2024
```
$(SIGNATURES)
"""
function epiphany_day(yr::Int)::Commemoration
    Commemoration(FEAST_EPIPHANY, yr)
end



#
# Lent
#
"""Construct Ash Wednesday for a given liturgical year.

**Examples**
```julia-repl
julia> ash_wednesday()
The First Day of Lent or Ash Wednesday, February 14, 2024
julia> ash_wednesday(LiturgicalYear(2023))
The First Day of Lent or Ash Wednesday, February 14, 2024
```
$(SIGNATURES)
"""
function ash_wednesday(lityr::LiturgicalYear = LiturgicalYear())::Commemoration
    ash_wednesday(lityr.ends_in)
end

"""Construct Ash Wednesday for a given year in the civil calendar.

**Example**
```julia-repl
julia> ash_wednesday(2024)
The First Day of Lent or Ash Wednesday, February 14, 2024
```
$(SIGNATURES)
"""
function ash_wednesday(yr::Int)::Commemoration
    Commemoration(FAST_ASH_WEDNESDAY, yr)
end




"""Construct Good Friday for a given liturtical year.

**Example**

$(SIGNATURES)
"""
function good_friday(lityr::LiturgicalYear = LiturgicalYear())::Commemoration
    good_friday(lityr.ends_in)
end

"""Construct Good Friday for a given year in the civil calendar.

**Example**

$(SIGNATURES)
"""
function good_friday(yr::Int)::Commemoration
    Commemoration(FAST_GOOD_FRIDAY, yr)
end





"""Find the date of Ash Wednesday in a given liturgical year in the civil calendar.

**Examples**
```julia-repl
julia> ash_wednesday_date()
2024-02-14
julia> ash_wednesday_date(LiturgicalYear(2023))
2024-02-14
```

$(SIGNATURES)
"""
function ash_wednesday_date(lityr::LiturgicalYear = LiturgicalYear())::Date
    ash_wednesday_date(lityr.ends_in)
end

"""Find the date of Ash Wednesday for a given year in the civil calendar.

**Examples*
```julia-repl
julia> ash_wednesday_date(2024)
2024-02-14
```
$(SIGNATURES)
"""
function ash_wednesday_date(yr::Int)::Date
    lent(1, yr).dt - Dates.Day(4)
end

"""Find a numbered Sunday of Lent in a given liturgial year.

**Examples**
```julia-repl
julia> lent(1)
the first Sunday in Lent, February 18, 2024
julia> lent(1, LiturgicalYear(2023))
the first Sunday in Lent, February 18, 2024
```

$(SIGNATURES)
"""
function lent(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    lent(sunday, lityr.ends_in)
end

"""Find a numbered Sunday of Lent in a given year in the civil calendar.


**Examples**
```julia-repl
julia> lent(1, 2024)
the first Sunday in Lent, February 18, 2024
```
$(SIGNATURES)
"""
function lent(sunday::Int, yr::Int)::LiturgicalSunday
    sundaystofind = 7 - sunday
    sunday_date = easter_sunday(yr).dt - Dates.Day(sundaystofind * 7)

    predecessor = LENT_1 - 1
    LiturgicalSunday(sunday_date, predecessor + sunday)
end

"""Find all Sundays in Lent in a given year of the civil calendar.

**Example**
```julia-repl
julia> lent_season(2024)
6-element Vector{LiturgicalDay}:
 The First Day of Lent or Ash Wednesday, February 14, 2024
 the first Sunday in Lent, February 18, 2024
 the second Sunday in Lent, February 25, 2024
 the third Sunday in Lent, March 3, 2024
 the fourth Sunday in Lent, March 10, 2024
 the fifth Sunday in Lent, March 17, 2024
```

$(SIGNATURES)
"""
function xlent_season(yr::Int)::Vector{LiturgicalDay}
    lent_season(LiturgicalYear(yr - 1))
end

"""Find all Sundays in Lent in a given liturgical year.

**Examples**

```julia-repl
julia> lent_season()
6-element Vector{LiturgicalDay}:
 The First Day of Lent or Ash Wednesday, February 14, 2024
 the first Sunday in Lent, February 18, 2024
 the second Sunday in Lent, February 25, 2024
 the third Sunday in Lent, March 3, 2024
 the fourth Sunday in Lent, March 10, 2024
 the fifth Sunday in Lent, March 17, 2024
julia> lent_season(LiturgicalYear(2023))
6-element Vector{LiturgicalDay}:
 The First Day of Lent or Ash Wednesday, February 14, 2024
 the first Sunday in Lent, February 18, 2024
 the second Sunday in Lent, February 25, 2024
 the third Sunday in Lent, March 3, 2024
 the fourth Sunday in Lent, March 10, 2024
 the fifth Sunday in Lent, March 17, 2024 
```

$(SIGNATURES)
"""
function xlent_season(lityear::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalDay}
    sundays = [lent(sunday, lityear.ends_in) for sunday in 1:5] 
    start = vcat([ash_wednesday()], sundays)
    vcat(start, holy_week(lityear))
end


function lent_sundays(lityear::LiturgicalYear = LiturgicalYear())
    sundays = [lent(sunday, lityear.ends_in) for sunday in 1:5] 
end

"""Add sig
$(SIGNATURES)
"""
function holy_week(lityr::LiturgicalYear = LiturgicalYear())
    holy_week(lityr.ends_in)
end


"""Add sig
$(SIGNATURES)
"""
function holy_week(yr::Int)
    @debug("Find holy week in yr $(yr)")
    dayids = [HOLY_WEEK_MONDAY,HOLY_WEEK_TUESDAY,HOLY_WEEK_WEDNESDAY, MAUNDY_THURSDAY,FAST_GOOD_FRIDAY,HOLY_SATURDAY]

    [Commemoration(id, yr) for id in dayids]
end

"""Construct Palm Sunday for a given liturgical year.

**Examples**
```julia-repl
julia> palm_sunday()
Palm Sunday, March 24, 2024
julia> palm_sunday(LiturgicalYear(2023))
Palm Sunday, March 24, 2024
```
$(SIGNATURES)
"""
function palm_sunday(lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    palm_sunday(lityr.ends_in)
end


"""Construct Palm Sunday for a given year in the civil calendar.

**Example**
```julia-repl
julia> palm_sunday(2024)
Palm Sunday, March 24, 2024
```

$(SIGNATURES)
"""
function palm_sunday(yr::Int)::LiturgicalSunday
    dt = easter_sunday(yr).dt - Dates.Day(7)
    LiturgicalSunday(dt, PALM_SUNDAY)
end



#
# EASTER AND EASTERTIDE
#

"""Construct Easter in a given liturgical year.

**Examples**
```julia-repl
julia> easter_sunday()
Easter Day, March 31, 2024
julia> easter_sunday(LiturgicalYear(2023))
Easter Day, March 31, 2024
```
$(SIGNATURES)
"""
function easter_sunday(lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    easter_sunday(lityr.ends_in)
end

"""Construct Easter in a given year of the civil calendar.

**Example**
```julia-repl
julia> easter_sunday(2024)
Easter Day, March 31, 2024
```
$(SIGNATURES)
"""
function easter_sunday(yr::Int)::LiturgicalSunday
    hr = Dates.DateTime(yr, 3, 21)
    while mphase(jdcnv(hr)) < 0.99
        hr = hr + Dates.Hour(1)
    end
    fullmoon = Date(yr, month(hr), day(hr))
    nxtday = fullmoon + Dates.Day(1)
    while dayname(nxtday) != "Sunday"
        nxtday = nxtday + Dates.Day(1)
    end
    LiturgicalSunday(nxtday, EASTER_SUNDAY)
end


"""Find a numbered Sunday of Easter season in a given liturgical year.

**Examples**
```julia-repl
julia> eastertide(2)
the second Sunday of Easter, April 7, 2024
julia> eastertide(2, LiturgicalYear(2023))
the second Sunday of Easter, April 7, 2024
```
$(SIGNATURES)
"""
function eastertide(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    eastertide(sunday, lityr.ends_in)

end

"""Find a numbered Sunday of Easter season in a given year of the civil calendar.

**Examples**
```julia-repl
julia> eastertide(2, 2024)
the second Sunday of Easter, April 7, 2024
```

$(SIGNATURES)
"""
function eastertide(sunday::Int, yr::Int)::LiturgicalSunday
    @assert sunday < 8 && sunday > 1
    #predecessor = easter_sunday(yr).dt - Dates.Day(1)
    @debug("Find sunday $(sunday) in $(yr)")
    @debug("Easter is $(easter_sunday(yr).dt)")
    thesunday =  easter_sunday(yr).dt + Dates.Day((sunday - 1) * 7)


    LiturgicalSunday(thesunday, EASTER_SUNDAY + (sunday - 1))
end



"""Find all Sundays following Easter in the Easter season of given liturgical year.

**Examples**
```juliarepl
julia> easter_sundays()
6-element Vector{LiturgicalSunday}:
 the second Sunday of Easter, April 7, 2024
 the third Sunday of Easter, April 14, 2024
 the fourth Sunday of Easter, April 21, 2024
 the fifth Sunday of Easter, April 28, 2024
 the sixth Sunday of Easter, May 5, 2024
 the seventh Sunday of Easter, May 12, 2024
 julia> easter_sundays(LiturgicalYear(2023))
6-element Vector{LiturgicalSunday}:
 the second Sunday of Easter, April 7, 2024
 the third Sunday of Easter, April 14, 2024
 the fourth Sunday of Easter, April 21, 2024
 the fifth Sunday of Easter, April 28, 2024
 the sixth Sunday of Easter, May 5, 2024
 the seventh Sunday of Easter, May 12, 2024 
```

$(SIGNATURES)
"""
function easter_sundays(lityr::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalSunday}
    easter_sundays(lityr.ends_in)
end



"""Find all Sundays following Easter in the Easter season of given year in the civil calendar.

**Examples**
```juliarepl
julia> easter_sundays(2024)
6-element Vector{LiturgicalSunday}:
 the second Sunday of Easter, April 7, 2024
 the third Sunday of Easter, April 14, 2024
 the fourth Sunday of Easter, April 21, 2024
 the fifth Sunday of Easter, April 28, 2024
 the sixth Sunday of Easter, May 5, 2024
 the seventh Sunday of Easter, May 12, 2024
 julia> easter_sundays(LiturgicalYear(2023)) 
```

$(SIGNATURES)
"""
function easter_sundays(yr::Int)::Vector{LiturgicalSunday}
    [eastertide(sunday, yr) for sunday in 2:7] 
end



#
# Pentecost
#
"""Find the Sunday of Pentecost in a given liturgical year.

**Examples**

```julia-repl
julia> pentecost_day()
the day of Pentecost, May 19, 2024
julia> pentecost_day(LiturgicalYear(2023))
the day of Pentecost, May 19, 2024
```
$(SIGNATURES)
"""
function pentecost_day(lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    pentecost_day(lityr.ends_in)
end


"""Find the Sunday of Pentecost in a year of the civil calendar.


**Example**

```julia-repl
julia> pentecost_day(2024)
the day of Pentecost, May 19, 2024
```

$(SIGNATURES)
"""
function pentecost_day(yr::Int)::LiturgicalSunday
    dt = easter_sundays(yr)[end].dt + Dates.Day(7)
    LiturgicalSunday(dt, PENTECOST)
end


"""Find Trinity Sunday in a given liturgical year.

**Examples**
```julia-repl
julia> trinity()
Trinity Sunday, May 26, 2024
julia> trinity(LiturgicalYear(2023))
Trinity Sunday, May 26, 2024
```


$(SIGNATURES)
"""
function trinity(lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    trinity(lityr.ends_in)
end

"""Find Trinity Sunday in a given year of the civil calendar.

**Example**
```julia-repl
julia> trinity(2024)
Trinity Sunday, May 26, 2024
```
$(SIGNATURES)
"""
function trinity(yr::Int)::LiturgicalSunday
    dt = pentecost_day(yr).dt + Dates.Day(7)
    LiturgicalSunday(dt, TRINITY_SUNDAY)
end


"""Find a numbered Sunday in ordinary time after Pentecost in a given liturgical year.

**Examples**
```julia-repl
julia> pentecost(3)
the third Sunday after Pentecost, June 9, 2024
julia> pentecost(3, LiturgicalYear(2023))
the third Sunday after Pentecost, June 9, 2024
```


$(SIGNATURES)
"""
function pentecost(sunday::Int, lityr::LiturgicalYear = LiturgicalYear())::LiturgicalSunday
    pentecost(sunday, lityr.ends_in)
end

"""Find a numbered Sunday in ordinary time after Pentecost in a given year of the civil calendar.

**Example**
```julia-repl
julia> pentecost(3,2024)
the third Sunday after Pentecost, June 9, 2024
```
$(SIGNATURES)
"""
function pentecost(sunday::Int, yr::Int)::Union{LiturgicalSunday,Nothing}
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

    sundaysfound > 0 && prev < endpoint ? LiturgicalSunday(prev, PENTECOST  + sunday) : nothing
end


"""In a given liturgical year, find all Sundays in ordinary time after Pentecost.

**Examples**
```julia-repl

julia> pentecost_season()
26-element Vector{LiturgicalSunday}:
 the second Sunday after Pentecost, June 2, 2024
 the third Sunday after Pentecost, June 9, 2024
 the fourth Sunday after Pentecost, June 16, 2024
 the fifth Sunday after Pentecost, June 23, 2024
 the sixth Sunday after Pentecost, June 30, 2024
 the seventh Sunday after Pentecost, July 7, 2024
 the eighth Sunday after Pentecost, July 14, 2024
 the ninth Sunday after Pentecost, July 21, 2024
 the tenth Sunday after Pentecost, July 28, 2024
 the eleventh Sunday after Pentecost, August 4, 2024
 ⋮
 the nineteenth Sunday after Pentecost, September 29, 2024
 the twentieth Sunday after Pentecost, October 6, 2024
 the twenty-first Sunday after Pentecost, October 13, 2024
 the twenty-second Sunday after Pentecost, October 20, 2024
 the twenty-third Sunday after Pentecost, October 27, 2024
 the twenty-fourth Sunday after Pentecost, November 3, 2024
 the twenty-fifth Sunday after Pentecost, November 10, 2024
 the twenty-sixth Sunday after Pentecost, November 17, 2024
 the twenty-seventh Sunday after Pentecost, November 24, 2024
 julia> pentecost_season(LiturgicalYear(2023))
26-element Vector{LiturgicalSunday}:
 the second Sunday after Pentecost, June 2, 2024
 the third Sunday after Pentecost, June 9, 2024
 the fourth Sunday after Pentecost, June 16, 2024
 the fifth Sunday after Pentecost, June 23, 2024
 the sixth Sunday after Pentecost, June 30, 2024
 the seventh Sunday after Pentecost, July 7, 2024
 the eighth Sunday after Pentecost, July 14, 2024
 the ninth Sunday after Pentecost, July 21, 2024
 the tenth Sunday after Pentecost, July 28, 2024
 the eleventh Sunday after Pentecost, August 4, 2024
 ⋮
 the nineteenth Sunday after Pentecost, September 29, 2024
 the twentieth Sunday after Pentecost, October 6, 2024
 the twenty-first Sunday after Pentecost, October 13, 2024
 the twenty-second Sunday after Pentecost, October 20, 2024
 the twenty-third Sunday after Pentecost, October 27, 2024
 the twenty-fourth Sunday after Pentecost, November 3, 2024
 the twenty-fifth Sunday after Pentecost, November 10, 2024
 the twenty-sixth Sunday after Pentecost, November 17, 2024
 the twenty-seventh Sunday after Pentecost, November 24, 2024
 ```

$(SIGNATURES)
"""
function pentecost_sundays(lityr::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalSunday}
    pentecost_sundays(lityr.ends_in)
end



"""In a given year in the civil calendar, find all Sundays in ordinary time after Pentecost.

**Example**
```julia-repl
julia> pentecost_season(2024)
26-element Vector{LiturgicalSunday}:
 the second Sunday after Pentecost, June 2, 2024
 the third Sunday after Pentecost, June 9, 2024
 the fourth Sunday after Pentecost, June 16, 2024
 the fifth Sunday after Pentecost, June 23, 2024
 the sixth Sunday after Pentecost, June 30, 2024
 the seventh Sunday after Pentecost, July 7, 2024
 the eighth Sunday after Pentecost, July 14, 2024
 the ninth Sunday after Pentecost, July 21, 2024
 the tenth Sunday after Pentecost, July 28, 2024
 the eleventh Sunday after Pentecost, August 4, 2024
 ⋮
 the nineteenth Sunday after Pentecost, September 29, 2024
 the twentieth Sunday after Pentecost, October 6, 2024
 the twenty-first Sunday after Pentecost, October 13, 2024
 the twenty-second Sunday after Pentecost, October 20, 2024
 the twenty-third Sunday after Pentecost, October 27, 2024
 the twenty-fourth Sunday after Pentecost, November 3, 2024
 the twenty-fifth Sunday after Pentecost, November 10, 2024
 the twenty-sixth Sunday after Pentecost, November 17, 2024
 the twenty-seventh Sunday after Pentecost, November 24, 2024
```


$(SIGNATURES)
"""
function pentecost_sundays(yr::Int)::Vector{LiturgicalSunday}
    sundayslist = []
    for i in 2:28
        sunday = pentecost(i, yr)
        if ! isnothing(sunday)
            push!(sundayslist, sunday)
        end
    end
    lastdate = sundayslist[end] |> civildate
    lastsunday = LiturgicalSunday(lastdate, CHRIST_THE_KING)
    sundayslist[end] = lastsunday
    # REPLACE LAST ONE WITH CHRIST THE KING

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
    easter_sunday(yr).dt + Dates.Day(39)
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


"""True if given Liturgical day falls within ordinary time following
Pentecost and if it is also a Sunday retrieved by pentecost_season function.

$(SIGNATURES)
"""
function in_pentecost(sunday::LiturgicalSunday)
    thedate = civildate(sunday)
    yr = year(thedate)
    sunday in pentecost_sundays(yr)
end

"""True if given Liturgical day falls within ordinary time following
Pentecost.

$(SIGNATURES)
"""
function in_pentecost(litday::LiturgicalDay)
    thedate = civildate(litday)
    yr = year(thedate)
    endpoint = advent(1, yr) |> civildate
    startpoint = pentecost_day(yr)  |> civildate
    thedate > startpoint && thedate < endpoint
end