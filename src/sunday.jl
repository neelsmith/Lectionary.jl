"""A Sunday in the liturgical year.
"""
struct Sunday <: LiturgicalDay
    dt::Date
    calendar_day::Int
end


function Sunday(sundayid::Int, lityear::LiturgicalYear = LiturgicalYear())
    matches = filter(sunday -> sunday.calendar_day == sundayid, sundays(lityear))
    if isempty(matches)
        @warn("No Sunday found with code: $(sundayid)")
        nothing
    else
        matches[1]
    end
end

"""Override `Base.==` for `Sunday`.
$(SIGNATURES)
"""
function ==(sday1::Sunday, sday2::Sunday)
    sday1.dt == sday2.dt &&
    sday1.calendar_day == sday1.calendar_day
end

"""Override `Base.show` for `Sunday`.
$(SIGNATURES)
"""
function show(io::IO, sday::Sunday)
    formatteddate = string(monthname(sday.dt), " ",  dayofmonth(sday.dt), ", ", year(sday.dt))
    write(io, name(sday) * ", " * formatteddate)
end



"""Name of a Sunday in the liturgical calendar.

**Example**
```julia-repl
julia> fst = Feast(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> name(fst)
"The Day of Pentecost"
```

$(SIGNATURES)
"""
function name(sday::Sunday)
    sunday_names[sday.calendar_day]
end

function civildate(sday::Sunday)
    sday.dt
end

function priority(sday::Sunday)
    SUNDAY
end

function sundayreadings(sday::Sunday, lectionaryyr::Char; as_urn = false) 
    if as_urn
        @warn("Support for URN references not implemented yet.")
    end
    if lectionaryyr == 'A'
        if haskey(sundayselectionsA, sday.calendar_day)
            sundayselectionsA[sday.calendar_day]
        else
            @warn("Could not find reading for $(sday) in year $(lectionaryyr)")
            nothing
        end

    elseif lectionaryyr == 'B'
        if haskey(sundayselectionsB, sday.calendar_day)
            sundayselectionsB[sday.calendar_day]
        else
            @warn("Could not find reading for $(sday) in year $(lectionaryyr)")
            nothing
        end
    
    elseif lectionaryyr == 'C'
        if haskey(sundayselectionsC, sday.calendar_day)
            sundayselectionsC[sday.calendar_day]
        else
            @warn("Could not find reading for $(sday) in year $(lectionaryyr)")
            nothing
        end

    else
        @warn("Invalid value for lectionary year: $(lectionaryyr)")
        nothing
    end     
   
end