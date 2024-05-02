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



"""Find correct liturgical year for a given date in the civil calendar.

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

"""Find correct liturgical day for a given date in the civil calendar.
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
function lectionary_year(lityr::LiturgicalYear = LiturgicalYear())::Int
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
function sundays(lityear::LiturgicalYear = LiturgicalYear())::Vector{Sunday}
    
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

function principal_feasts(lityear::LiturgicalYear = LiturgicalYear())::Vector{LiturgicalDay}
    [Commemoration(thefeast, lityear) for thefeast in PRINCIPAL_FEASTS]
end

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
function christmas_day(lityr::LiturgicalYear = LiturgicalYear())
    christmas_day(lityr.starts_in)
    
end



"""Find Christmas Day for a given year in the civil calendar.

$(SIGNATURES)
"""
function christmas_day(yr::Int)
    Commemoration(FEAST_CHRISTMAS, yr)
end



function advent_season(lityr::LiturgicalYear = LiturgicalYear())
    @info("Find advent")

    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(advent(1, lityr)) &&
        civildate(theday) < civildate(christmas_day(lityr))
    end
end


function christmastide(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(christmas_day(lityr)) &&
        civildate(theday) <= civildate(epiphany_day(lityr))
    end
end


function epiphany_season(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) > civildate(epiphany_day(lityr)) &&
        civildate(theday) < civildate(ash_wednesday(lityr))
    end
end


function lent_season(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(ash_wednesday(lityr)) &&
        civildate(theday) < civildate(easter_sunday(lityr))
    end
end


function eastertide(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) >= civildate(easter_sunday(lityr)) &&
        civildate(theday) <= civildate(pentecost_day(lityr))
    end
end

function pentecost_season(lityr::LiturgicalYear = LiturgicalYear())
    filter(kalendar(lityr)) do theday
        civildate(theday) > civildate(pentecost_day(lityr)) &&
        civildate(theday) < civildate(advent(1, lityr.ends_in))
    end
end