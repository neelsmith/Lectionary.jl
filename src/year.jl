"""A specific liturgical year.

**Examples**
```julia-repl
julia> LiturgicalYear()
2023-2024

julia> LiturgicalYear(2023)
2023-2024

julia> using Dates
julia> LiturgicalYear(Date(2024, 4, 1))
2023-2024

```
"""
struct LiturgicalYear
    starts_in::Int
    ends_in::Int
    function LiturgicalYear(startyr::Int)
        endyr = startyr + 1
        new(startyr, endyr)
    end
end


"""Construct a `LiturgicalYear` from a specified `Date`,
or default to constructing the liturgical year from today's date.
$(SIGNATURES)
"""
function LiturgicalYear(dt::Date = Date(Dates.now()))
    yr = year(dt)
    if dt >= advent(1, yr).dt
        LiturgicalYear(yr)
    else
        LiturgicalYear(yr - 1)
    end
end

"""Override `Base.==` for `LiturgicalYear`.
$(SIGNATURES)
"""
function ==(yr1::LiturgicalYear, yr2::LiturgicalYear)
    yr1.starts_in == yr2.starts_in &&
    yr1.ends_in == yr2.ends_in 
end

"""Override `Base.show` for `LiturgicalYear`.
$(SIGNATURES)
"""
function show(io::IO, year::LiturgicalYear = LiturgicalYear())
    write(io, string(year.starts_in,"-",year.ends_in))
end


"""Find range of dates in the civil calendar for a liturgical year.

**Examples**
```julia-repl
julia> date_range()
Date("2023-12-03"):Day(1):Date("2024-11-30")

julia> ly = LiturgicalYear()
2023-2024
julia> date_range(ly)
Date("2023-12-03"):Day(1):Date("2024-11-30")
```

$(SIGNATURES)
"""
function date_range(yr::LiturgicalYear = LiturgicalYear())
    lastday = advent(1,yr.ends_in).dt - Dates.Day(1)
    advent(1, yr.starts_in).dt:lastday
end



"""Find the correct liturgical year for a given date in the civil calendar.

**Examples**

```julia-rep
julia> liturgical_year()
2023-2024
julia> liturgical_year(Date(2024,4,1))
2023-2024
```

$(SIGNATURES)
"""
function liturgical_year(dt::Date = Date(Dates.now()))::LiturgicalYear
    if dt > advent(1, year(dt)).dt
        LiturgicalYear(year(dt))
    else
        LiturgicalYear(year(dt) - 1)
    end
end

"""Find the correct liturgical day for a given date in the civil calendar.

**Example**
```{julia-repl}
julia> liturgical_day(Date(2024,4,1))
April 1, 2024, Monday following Easter Day
```

$(SIGNATURES)
"""
function liturgical_day(dt::Date  = Date(Dates.now()))::LiturgicalDay
    lityr = liturgical_year(dt)
    feastlist = principal_feasts(lityr)
    feastmatch = findfirst(f -> civildate(f) == dt, feastlist)

    sundaylist = sundays(lityr)
    sundaymatch = findfirst(f -> civildate(f) == dt, sundaylist) 
  
    if ! isnothing(feastmatch)
        feastlist[feastmatch]
    elseif ! isnothing(sundaymatch)
        sundaylist[sundaymatch]
    else        
        otherday = OtherDay(dt)
    end
end

"""Rules for finding lectionary year cycle,
as a Dict."""
const lectionary_year_dict = Dict(
    0 => 'A',
    1 => 'B',
    2 => 'C'
)

"""Find lectionary year cycle for a given liturgical year.

**Example**

```julia-repl
julia> ly = LiturgicalYear()
2023-2024
julia> lectionary_year(ly)
'B': ASCII/Unicode U+0042 (category Lu: Letter, uppercase)
```

$(SIGNATURES)
"""
function lectionary_year(lityr::LiturgicalYear = LiturgicalYear())::Char
    lectionary_year(lityr.starts_in)
end


"""Find lectionary year cycle for the liturgical year begining in a given year of the civil calendar.

**Example**

```julia-repl
julia> lectionary_year(2023)
'B': ASCII/Unicode U+0042 (category Lu: Letter, uppercase)
```

$(SIGNATURES)
"""
function lectionary_year(yr::Int)::Char
    remainder = mod(yr, 3)
    lectionary_year_dict[remainder]
end

"""Find daily office year cycle for a given liturgical year.


**Example**

```julia-repl
julia> ly = LiturgicalYear()
2023-2024
julia> daily_office_year(ly)
2
```

$(SIGNATURES)
"""
function daily_office_year(lityr::LiturgicalYear = LiturgicalYear())::Int
    daily_office_year(lityr.starts_in)
end

"""Find daily office year cycle for the liturgical year beginning in a given year in the civil calendar.


**Example**

```julia-repl
julia> daily_office_year(2023)
2
```
$(SIGNATURES)
"""
function daily_office_year(yr::Int)::Int
    mod(yr, 2) + 1 
end



"""Find Sundays in a given liturgical year.

**Examples**

```{julia-repl}

```

$(SIGNATURES)
"""
function sundays(lityear::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalSunday}
   vcat(
        advent_sundays(lityear), 
        christmas_sundays(lityear), 
        epiphany_sundays(lityear),
        lent_sundays(lityear),
        [palm_sunday(lityear), easter_sunday(lityear)],
        easter_sundays(lityear),
        [pentecost_day(lityear), trinity(lityear)],
        pentecost_sundays(lityear)
    )
end



"""Find the principal feasts for a given liturgical year. These seven feasts have priority 
over all other days in the liturgical calendar.

**Examples**
```{julia-repl}
julia> principal_feasts()
7-element Vector{LiturgicalDay}:
 Christmas Day in 2023
 The Epiphany in 2024
 Easter Day in 2024
 Ascension Day in 2024
 The Day of Pentecost in 2024
 Trinity Sunday in 2024
 All Saints' Day in 2024
 julia> principal_feasts(LiturgicalYear(2023))
7-element Vector{LiturgicalDay}:
 Christmas Day in 2023
 The Epiphany in 2024
 Easter Day in 2024
 Ascension Day in 2024
 The Day of Pentecost in 2024
 Trinity Sunday in 2024
 All Saints' Day in 2024
```
$(SIGNATURES)
"""
function principal_feasts(lityear::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalDay}
    sort([Commemoration(thefeast, lityear) for thefeast in PRINCIPAL_FEASTS], by = fst -> civildate(fst))
end



"""For a given liturgical year, find the other seventeen major feasts and fasts defined in the BCP pp. 16-17 but not included in the principal feasts found by the `principal_feasts`  function.

**Examples**
```{julia-repl}

julia> holy_days()
17-element Vector{Commemoration}:
 Christmas Day in 2023
 The Holy Name in 2024
 The Epiphany in 2024
 The Presentation in 2024
 The Annunciation in 2024
 The Visitation in 2024
 Holy Cross Day in 2024
 All Saints' Day in 2024
 Ascension Day in 2024
 Thanksgiving Day in 2024
 The First Day of Lent or Ash Wednesday in 2024
 Monday of Holy Week in 2024
 Tuesday of Holy Week in 2024
 Wednesday of Holy Week in 2024
 Holy Thursday in 2024
 Good Friday in 2024
 Holy Saturday in 2024

julia> holy_days(LiturgicalYear(2023))
17-element Vector{Commemoration}:
 Christmas Day in 2023
 The Holy Name in 2024
 The Epiphany in 2024
 The Presentation in 2024
 The Annunciation in 2024
 The Visitation in 2024
 Holy Cross Day in 2024
 All Saints' Day in 2024
 Ascension Day in 2024
 Thanksgiving Day in 2024
 The First Day of Lent or Ash Wednesday in 2024
 Monday of Holy Week in 2024
 Tuesday of Holy Week in 2024
 Wednesday of Holy Week in 2024
 Holy Thursday in 2024
 Good Friday in 2024
 Holy Saturday in 2024
 ```

$(SIGNATURES)
"""
function holy_days(lityear::LiturgicalYear = LiturgicalYear(); src = :RCL)
    if src == :BCP
        allholydays = vcat(HOLY_DAYS_1, HOLY_DAYS_2)
        map(allholydays) do f
            Commemoration(f, lityear)
        end
    elseif src == :RCL
        @debug("GET RCL feasts")
        map(RCL_FEASTS) do fst
            if fst == FEAST_CHRISTMAS
                Commemoration(fst, lityear.starts_in)
            else
                Commemoration(fst, lityear.ends_in)
            end
        end
    else
        @warn("Unrecognized source: $(src) (function `holy_days`)")
        nothing
    end
end


"""Find a vector of all liturgical days with assigned readings in 
this liturgical year.

**Examples**

```{julia-repl}
julia> kalendar() |> typeof
Vector{LiturgicalDay} (alias for Array{LiturgicalDay, 1})
julia> kalendar() |> length
69

julia> ly = LiturgicalYear(2023)
2023-2024

julia> kalendar(ly) |> typeof
Vector{LiturgicalDay} (alias for Array{LiturgicalDay, 1})

julia> kalendar(ly) |> length
69

```

$(SIGNATURES)
"""
function kalendar(lityr::LiturgicalYear = LiturgicalYear(); src = :RCL)
    @debug("kal for $(lityr), using src $(src)")
    events = LiturgicalDay[]
    allcommems = holy_days(lityr)
    
    commems = if src == :BCP
        for ld in vcat(allcommems, sundays(lityr),principal_feasts(lityr))
            push!(events, ld)
        end
        
    elseif src == :RCL
        @debug("Filtering for RCL feasts..")
        commems = filter(allcommems) do litday
            litday.commemoration_id in RCL_FEASTS
        end
        for ld in vcat(commems, sundays(lityr))
            push!(events, ld)
        end
    end
    sort(events , by = litday -> civildate(litday))
    
end


"""Find Christmas Day for a given liturgical year.

$(SIGNATURES)
"""
function christmas_day(lityr::LiturgicalYear = LiturgicalYear())::Commemoration
    christmas_day(lityr.starts_in)
    
end



"""Find Christmas Day for a given year in the civil calendar.

$(SIGNATURES)
"""
function christmas_day(yr::Int)::Commemoration
    Commemoration(FEAST_CHRISTMAS, yr)
end


"""Find a vector of all liturgical days with assigned readings in Advent of a given liturgical year.

**Examples**
```{julia-repl}
julia> advent_season()
4-element Vector{LiturgicalDay}:
 the first Sunday of Advent, December 3, 2023
 the second Sunday of Advent, December 10, 2023
 the third Sunday of Advent, December 17, 2023
 the fourth Sunday of Advent, December 24, 2023
 julia> advent_season(LiturgicalYear(2023))
 4-element Vector{LiturgicalDay}:
  the first Sunday of Advent, December 3, 2023
  the second Sunday of Advent, December 10, 2023
  the third Sunday of Advent, December 17, 2023
  the fourth Sunday of Advent, December 24, 2023
```
$(SIGNATURES)
"""
function advent_season(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(advent(1, lityr)) &&
        civildate(theday) < civildate(christmas_day(lityr))
    end
end


"""Find a vector of all liturgical days with assigned readings in Christmastide of a given liturgical year.

**Examples**
```{julia-repl}
julia> christmastide()
4-element Vector{LiturgicalDay}:
 Christmas Day in 2023
 the first Sunday after Christmas Day, December 31, 2023
 The Holy Name in 2024
 The Epiphany in 2024
 julia> christmastide(LiturgicalYear(2023))
4-element Vector{LiturgicalDay}:
 Christmas Day in 2023
 the first Sunday after Christmas Day, December 31, 2023
 The Holy Name in 2024
 The Epiphany in 2024
```
$(SIGNATURES)
"""
function christmastide(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(christmas_day(lityr)) &&
        civildate(theday) <= civildate(epiphany_day(lityr))
    end
end



"""Find a vector of all liturgical days with assigned readings in ordinary time after Epiphany of a given liturgical year.

**Examples**
```{julia-repl}
julia> epiphany_season()
7-element Vector{LiturgicalDay}:
 the first Sunday after the Epiphany, January 7, 2024
 the second Sunday after the Epiphany, January 14, 2024
 the third Sunday after the Epiphany, January 21, 2024
 the fourth Sunday after the Epiphany, January 28, 2024
 The Presentation in 2024
 the fifth Sunday after the Epiphany, February 4, 2024
 Transfiguration Sunday, February 11, 2024
 julia> epiphany_season(LiturgicalYear(2023))
7-element Vector{LiturgicalDay}:
 the first Sunday after the Epiphany, January 7, 2024
 the second Sunday after the Epiphany, January 14, 2024
 the third Sunday after the Epiphany, January 21, 2024
 the fourth Sunday after the Epiphany, January 28, 2024
 The Presentation in 2024
 the fifth Sunday after the Epiphany, February 4, 2024
 Transfiguration Sunday, February 11, 2024
```
$(SIGNATURES)
"""
function epiphany_season(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) > civildate(epiphany_day(lityr)) &&
        civildate(theday) < civildate(ash_wednesday(lityr))
    end
end


"""Find a vector of all liturgical days with assigned readings in Lent of a given liturgical year.

**Examples**
```{julia-repl}
julia> lent_season()
14-element Vector{LiturgicalDay}:
 The First Day of Lent or Ash Wednesday in 2024
 the first Sunday in Lent, February 18, 2024
 the second Sunday in Lent, February 25, 2024
 the third Sunday in Lent, March 3, 2024
 the fourth Sunday in Lent, March 10, 2024
 the fifth Sunday in Lent, March 17, 2024
 Palm Sunday, March 24, 2024
 The Annunciation in 2024
 Monday of Holy Week in 2024
 Tuesday of Holy Week in 2024
 Wednesday of Holy Week in 2024
 Holy Thursday in 2024
 Good Friday in 2024
 Holy Saturday in 2024
 julia> lent_season(LiturgicalYear(2023)) == lent_season()
 true
```
$(SIGNATURES)
"""
function lent_season(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(ash_wednesday(lityr)) &&
        civildate(theday) < civildate(easter_sunday(lityr))
    end
end


"""Find a vector of all liturgical days with assigned readings in Eastertide of a given liturgical year.

**Examples**
```{julia-repl}
julia> eastertide()
9-element Vector{LiturgicalDay}:
 Easter Day, March 31, 2024
 the second Sunday of Easter, April 7, 2024
 the third Sunday of Easter, April 14, 2024
 the fourth Sunday of Easter, April 21, 2024
 the fifth Sunday of Easter, April 28, 2024
 the sixth Sunday of Easter, May 5, 2024
 Ascension Day in 2024
 the seventh Sunday of Easter, May 12, 2024
 the day of Pentecost, May 19, 2024
julia> eastertide(LiturgicalYear(2023)) == eastertide()
true
```
$(SIGNATURES)
"""
function eastertide(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(easter_sunday(lityr)) &&
        civildate(theday) <= civildate(pentecost_day(lityr))
    end
end



"""Find a vector of all liturgical days with assigned readings in ordinary time after Pentecost of a given liturgical year.

**Examples**
```{julia-repl}
julia> pentecost_season()
31-element Vector{LiturgicalDay}:
 Trinity Sunday, May 26, 2024
 The Visitation in 2024
 the second Sunday after Pentecost, June 2, 2024
 the third Sunday after Pentecost, June 9, 2024
 the fourth Sunday after Pentecost, June 16, 2024
 the fifth Sunday after Pentecost, June 23, 2024
 the sixth Sunday after Pentecost, June 30, 2024
 the seventh Sunday after Pentecost, July 7, 2024
 the eighth Sunday after Pentecost, July 14, 2024
 the ninth Sunday after Pentecost, July 21, 2024
 ⋮
 the twenty-first Sunday after Pentecost, October 13, 2024
 the twenty-second Sunday after Pentecost, October 20, 2024
 the twenty-third Sunday after Pentecost, October 27, 2024
 All Saints' Day in 2024
 the twenty-fourth Sunday after Pentecost, November 3, 2024
 the twenty-fifth Sunday after Pentecost, November 10, 2024
 the twenty-sixth Sunday after Pentecost, November 17, 2024
 Christ the King, November 24, 2024
 Thanksgiving Day in 2024
julia> pentecost_season(LiturgicalYear(2023)) == pentecost_season()
true
```
$(SIGNATURES)
"""
function pentecost_season(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) > civildate(pentecost_day(lityr)) &&
        civildate(theday) < civildate(advent(1, lityr.ends_in))
    end
end