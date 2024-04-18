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
    # This formatting is wrong:
    #formatteddate = Dates.format(sday.dt,"U yy, yyyy")
    #formatteddate = sday.dt
    formatteddate = string(monthname(sday.dt), " ", day(sday.dt), ", ", year(sday.dt))
    write(io, string(formatteddate,", ", name(sday) ))
end

function name(sday::Sunday)
    sunday_names[sday.calendar_day]
end