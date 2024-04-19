struct Sunday <: LiturgicalDay
    dt::Date
    calendar_day::Int
end

"""Override `Base.==` for `Codex`.
$(SIGNATURES)
"""
function ==(sday1::Sunday, sday2::Sunday)
    sday1.dt == sday2.dt &&
    sday1.calendar_day == sday1.calendar_day
end

"""Override `Base.show` for `Codex`.
$(SIGNATURES)
"""
function show(io::IO, sday::Sunday)
    formatteddate = string(monthname(sday.dt), " ",  dayofmonth(sday.dt), ", ", year(sday.dt))
    write(io, name(sday) * ", " * formatteddate)
end

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