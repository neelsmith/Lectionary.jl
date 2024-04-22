

"""A commemoration in the liturgical year other than a regular Sunday.

**Examples**
```julia-repl
julia> Commemoration(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> Commemoration(Lectionary.FEAST_PENTECOST, 2025)
The Day of Pentecost, June 1, 2025
$(SIGNATURES)
```
"""
struct Commemoration <: LiturgicalDay
    commemoration_id::Int
    yr::Int
end


"""Construct a liturgical day for a commemoration.
$(SIGNATURES)
"""
function Commemoration(commemoration_id::Int, ly::LiturgicalYear = LiturgicalYear())
    if commemoration_id in YEAR1_FEASTS
        Commemoration(commemoration_id, ly.starts_in) 
    else
        Commemoration(commemoration_id, ly.ends_in)
    end
end

"""Override `Base.==` for `Commemoration`.
$(SIGNATURES)
"""
function ==(f1::Commemoration, f2::Commemoration)
    f1.commemoration_id == f2.commemoration_id &&
    f1.yr == f2.yr
end

"""Override `Base.show` for type `Commemoration`.
$(SIGNATURES)
"""
function show(io::IO, fst::Commemoration)
    
    nm = name(fst)
    
    dt = civildate(fst)
    if isnothing(dt)
       write(io, string(nm, " (no date)"))
    else
        formatteddate = string(monthname(dt), " ",  dayofmonth(dt), ", ", year(dt))
        write(io, nm * ", " * formatteddate)
    end
end

"""Name of a commemoration in the liturgical calendar.

**Example**
```julia-repl
julia> name(ash_wednesday())
"The First Day of Lent or Ash Wednesday"
```
$(SIGNATURES)
"""
function name(fst::Commemoration)
    haskey(feast_names, fst.commemoration_id) ? feast_names[fst.commemoration_id] : string(fst)
end

"""Priority of a commemoration. Lower values override 
higher values in determining which of two sets
of readings to prefer.

**Examples**

```julia-repl

```

$(SIGNATURES)
"""
function priority(fst::Commemoration)
    if fst.commemoration_id in PRINCIPAL_FEASTS
        PRINCIPAL_FEAST
    elseif fst.commemoration_id in HOLY_DAYS_1
        HOLY_DAY_1
    elseif fst.commemoration_id in HOLY_DAYS_2
        HOLY_DAY_2

    else
        OTHER_DAY
    end
end

"""True if date of commemoration is movable.
$(SIGNATURES)
"""
function ismovable(fst::Commemoration)
    fst.commemoration_id in MOVABLE
end

"""Date in civil calendar of a movable commemoration.
$(SIGNATURES)
"""
function movabledate(fst::Commemoration)
    if fst.commemoration_id == FEAST_EASTER
        easter_sunday(fst.yr) |> civildate
    elseif fst.commemoration_id == FEAST_ASCENSION
        ascension(fst.yr)
    elseif fst.commemoration_id == FEAST_PENTECOST
        pentecost_day(fst.yr).dt
    elseif fst.commemoration_id == FEAST_TRINITY
        trinity(fst.yr).dt
    elseif fst.commemoration_id == FEAST_THANKSGIVING_DAY
        thanksgiving(fst.yr)

    elseif fst.commemoration_id == FAST_ASH_WEDNESDAY
        ash_wednesday_date(fst.yr)

    else
        @info("Movable feast not implemented! $(fst)")
        nothing
    end
end

"""Find date in civil calendar for a commemoration.


**Example**
```julia-repl
julia> fst = Commemoration(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> civildate(fst)
2024-05-19
```
$(SIGNATURES)
"""
function civildate(fst::Commemoration)
    if ismovable(fst)

        movabledate(fst)

    elseif haskey(fixed_dates,fst.commemoration_id)
        monthday = fixed_dates[fst.commemoration_id]
        Date(fst.yr, calmonth(monthday), calday(monthday))
    else
        @warn("Key not found for fixed date of commemorations: $(fst)..")
        nothing
    end
end


"""Find name of day of week of commemoration.


**Example**
```julia-repl
julia> fst = Commemoration(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> weekday(fst)
"Sunday"
```

$(SIGNATURES)
"""
function weekday(fst::Commemoration)
    civildate(fst) |> dayname
end


"""Find readings for feast.
$(SIGNATURES)
"""
function feastreadings(feast::Commemoration, lectionaryyr::Char; as_urn = false) 
    if as_urn
        @warn("Support for URN references not implemented yet.")
    end
    if lectionaryyr == 'A'
        if haskey(feastselectionsA, feast.commemoration_id)
            feastselectionsA[feast.commemoration_id]
        else
            @warn("Could not find reading for $(feast) in year $(lectionaryyr)")
            nothing
        end

    elseif lectionaryyr == 'B'
        if haskey(feastselectionsB, feast.commemoration_id)
            feastselectionsB[feast.commemoration_id]
        else
            @warn("Could not find reading for $(feast) in year $(lectionaryyr)")
            nothing
        end
    
    elseif lectionaryyr == 'C'
        if haskey(feastselectionsC, feast.commemoration_id)
            feastselectionsC[feast.commemoration_id]
        else
            @warn("Could not find reading for $(faste) in year $(lectionaryyr)")
            nothing
        end

    else
        @warn("Invalid value for lectionary year: $(lectionaryyr)")
        nothing
    end     
   
end

