

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


function lectionary_year(comm::Commemoration)
end

function litugical_year(comm::Commemoration)
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
function show(io::IO, comm::Commemoration)
  
    nm = name(comm)
  
    # This generates a stack overflow on movable feasts.
    # Consider work around?
    #dt = civildate(comm)
    
    #if isnothing(dt)
       #write(io, string(nm, " (no date)"))
    #else
       # formatteddate = string(monthname(dt), " ",  dayofmonth(dt), ", ", year(dt))
        #write(io, nm * ", " * formatteddate)
    #end
  
     write(io, string(nm , " in " , comm.yr))
end

"""Name of a commemoration in the liturgical calendar.

**Example**
```julia-repl
julia> name(ash_wednesday())
"The First Day of Lent or Ash Wednesday"
```
$(SIGNATURES)
"""
function name(comm::Commemoration)::String
    haskey(feast_names, comm.commemoration_id) ? feast_names[comm.commemoration_id] : string(comm)
end

"""Priority of a commemoration. Lower values override 
higher values in determining which of two sets
of readings to prefer.

**Examples**

```julia-repl

```

$(SIGNATURES)
"""
function precedence(comm::Commemoration)::Int
    if comm.commemoration_id in PRINCIPAL_FEASTS
        PRINCIPAL_FEAST
    elseif comm.commemoration_id in HOLY_DAYS_1
        HOLY_DAY_1
    elseif comm.commemoration_id in HOLY_DAYS_2
        HOLY_DAY_2

    else
        OTHER_DAY
    end
end


"""True if the date of commemoration identified by a given ID is movable.
$(SIGNATURES)
"""
function ismovable(commid::Int)::Bool
    commid in MOVABLE
end


"""True if date of commemoration is movable.
$(SIGNATURES)
"""
function ismovable(comm::Commemoration)::Bool
    comm.commemoration_id in MOVABLE
end

"""Date in civil calendar of a movable commemoration.
$(SIGNATURES)
"""
function movabledate(comm::Commemoration)::Date

    @debug("for $(comm),  $(comm.commemoration_id)")
    if comm.commemoration_id == FEAST_EASTER
        easter_sunday(comm.yr) |> civildate
    elseif comm.commemoration_id == FEAST_ASCENSION
        ascension(comm.yr)
    elseif comm.commemoration_id == FEAST_PENTECOST
        pentecost_day(comm.yr).dt
    elseif comm.commemoration_id == FEAST_TRINITY
        trinity(comm.yr).dt
    elseif comm.commemoration_id == FEAST_THANKSGIVING_DAY
        thanksgiving(comm.yr)

    elseif comm.commemoration_id == FAST_ASH_WEDNESDAY
        civildate(lent(1)) - Dates.Day(4)
    elseif comm.commemoration_id == HOLY_WEEK_MONDAY
        civildate(easter_sunday(comm.yr)) - Dates.Day(6)
        
    elseif comm.commemoration_id == HOLY_WEEK_TUESDAY
        civildate(easter_sunday(comm.yr)) - Dates.Day(5)
        
    elseif comm.commemoration_id == HOLY_WEEK_WEDNESDAY
        civildate(easter_sunday(comm.yr)) - Dates.Day(4)
        
    elseif comm.commemoration_id == MAUNDY_THURSDAY
        civildate(easter_sunday(comm.yr)) - Dates.Day(3)
        
    elseif comm.commemoration_id == FAST_GOOD_FRIDAY
        civildate(easter_sunday(comm.yr)) - Dates.Day(2)
        
    elseif comm.commemoration_id == HOLY_SATURDAY
        civildate(easter_sunday(comm.yr)) - Dates.Day(1)
        

    elseif comm.commemoration_id == EASTER_WEEK_MONDAY
        civildate(easter_sunday(comm.yr)) + Dates.Day(1)
    elseif comm.commemoration_id == EASTER_WEEK_TUESDAY
        civildate(easter_sunday(comm.yr)) + Dates.Day(2)
    elseif comm.commemoration_id == EASTER_WEEK_WEDNESDAY
        civildate(easter_sunday(comm.yr)) + Dates.Day(3)
    elseif comm.commemoration_id == EASTER_WEEK_THURSDAY
        civildate(easter_sunday(comm.yr)) + Dates.Day(4)
    elseif comm.commemoration_id == EASTER_WEEK_FRIDAY
        civildate(easter_sunday(comm.yr)) + Dates.Day(5)
    elseif comm.commemoration_id == EASTER_WEEK_SATURDAY
        civildate(easter_sunday(comm.yr)) + Dates.Day(6)      
        
    elseif comm.commemoration_id == FEAST_TRANSFIGURATION
        ash_wednesday_date(comm.yr) - Dates.Day(3)


    else
        @info("Movable feast not implemented! $(comm)")
        nothing
    end
end

"""Find the date in the civil calendar for a commemoration.

**Example**
```julia-repl
julia> civildate(ash_wednesday())
2024-02-14
```
$(SIGNATURES)
"""
function civildate(comm::Commemoration)::Date
    @debug("Find civildate for commeoration with id $(comm.commemoration_id)")
    if ismovable(comm)
        @debug("It moves")
        movabledate(comm)

    elseif haskey(fixed_dates,comm.commemoration_id)
        monthday = fixed_dates[comm.commemoration_id]
        Date(comm.yr, calmonth(monthday), calday(monthday))
    else
        @warn("Key not found for fixed date of commemoration id: $(comm.commemoration_id)..")
        nothing
    end
end


"""Find name of day of week of commemoration.

**Example**
```julia-repl
julia> weekday(christmas_day())
"Monday"
```

$(SIGNATURES)
"""
function weekday(fst::Commemoration)::String
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
            @warn(" $(feast) in year $(lectionaryyr)")
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

