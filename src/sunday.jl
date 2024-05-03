"""A Sunday in the liturgical year.
"""
struct LiturgicalSunday <: LiturgicalDay
    dt::Date
    calendar_day::Int
end


function LiturgicalSunday(sundayid::Int, lityear::LiturgicalYear = LiturgicalYear())
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
function ==(sday1::LiturgicalSunday, sday2::LiturgicalSunday)
    sday1.dt == sday2.dt &&
    sday1.calendar_day == sday1.calendar_day
end

"""Override `Base.show` for `Sunday`.
$(SIGNATURES)
"""
function show(io::IO, sday::LiturgicalSunday)
    formatteddate = string(monthname(sday.dt), " ",  dayofmonth(sday.dt), ", ", year(sday.dt))
    write(io, name(sday) * ", " * formatteddate)
end



"""Name of a Sunday in the liturgical calendar.

**Example**
```julia-repl
julia> name(easter_sunday())
"Easter Day"
```

$(SIGNATURES)
"""
function name(sday::LiturgicalSunday)
    sunday_names[sday.calendar_day]
end

"""Find the date in the civil calendar for a given Sunday.

**Example**
```julia-repl
julia> civildate(easter_sunday())
2024-03-31
```
$(SIGNATURES)
"""
function civildate(sday::LiturgicalSunday)
    sday.dt
end

function precedence(sday::LiturgicalSunday)
    SUNDAY
end

function sundayreadings(sday::LiturgicalSunday, lectionaryyr::Char) 
    

    
    if in_pentecost(sday)
        @info("Now we need to check for pentecost days")
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