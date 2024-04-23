"""Find the seven-day range beginning with Sunday 
that a given date falls in.

$(SIGNATURES)
"""
function weekrange(dt::Date = Date(Dates.now()))
    sunday = dt
    while dayname(sunday) != "Sunday"
        sunday = sunday - Dates.Day(1)
    end
    saturday = sunday + Dates.Day(6)
    sunday:saturday
end


"""Find top priority in a list of liturgical days.

$(SIGNATURES)
"""
function prioritize(litdays::Vector{LiturgicalDay})::Union{Nothing, LiturgicalDay}
    isempty(litdays) ? nothing : sort!(litdays, by = ly -> precedence(ly))[1]
end

"""Compose a 7-element vector ordered from Sunday to Saturday and including the given date, with a value of either a liturgical day or nothing for each day in the week.

$(SIGNATURES)
"""
function calendar_week(dt::Date = Date(Dates.now()))::Vector{Union{Nothing, LiturgicalDay}}
    wkdays = Union{Nothing,LiturgicalDay}[]
    kal = liturgical_year(dt) |> kalendar
    for caldate in weekrange(dt)
        litdays = filter(lday -> civildate(lday) == caldate, kal)
        if length(litdays) == 0
            push!(wkdays, nothing)
        elseif length(litdays) == 1
            push!(wkdays, litdays[1])
        else
            push!(wkdays, prioritize(litdays))
        end
    end
    wkdays
end


"""Compose a 7-element vector ordered from Sunday to Saturday and including the given liturgical day, with a value of either a liturgical day or nothing for each day in the week.

$(SIGNATURES)
"""
function calendar_week(lday::LiturgicalDay)::Vector{Union{Nothing, LiturgicalDay}}
    calendar_week(civildate(lday))
end



"""Compose a vector of 4 or 5 week vectors for a calendar month, with values of either a liturgical day or nothing for each day in each week.


$(SIGNATURES)
"""
function calendar_month(dt::Date = Date(Dates.now()))::Vector{Vector{Union{Nothing, LiturgicalDay}}}
    @debug("Create month for date $(dt)")
    weekcount = Dates.daysinmonth(dt) > 28 ? 5 : 4
    weeks = Vector{Union{Nothing,LiturgicalDay}}[]
    for i in 1:weekcount
        daynum = 1 + (i - 1)*7
        @debug("week $(i)/$(weekcount): daynum is $(daynum)")
        day1 = Date(year(dt), month(dt), daynum)
        push!(weeks, calendar_week(day1))
    end
    weeks
end


"""Compose a vector of 4 or 5 week vectors for a calendar month, with values of either a liturgical day or nothing for each day in each week.


$(SIGNATURES)
"""
function calendar_month(lday::LiturgicalDay)::Vector{Vector{Union{Nothing, LiturgicalDay}}}
    calendar_month(civildate(lday))
end


function calendar_year(dt::Date = Date(Dates.now()))::Vector{Vector{Vector{Union{Nothing, LiturgicalDay}}}}
    ly = liturgical_year(dt)
    nextadv = advent(1, ly.ends_in)
    cutoff = Date(ly.ends_in, 12, 1)




    monthcals = Vector{Vector{Union{Nothing, LiturgicalDay}}}[]
    #monthcals = [] #Vector{Vector{Union{Nothing,LiturgicalDay}}}[]
    if civildate(advent(1, ly)) < Date(ly.starts_in, 12, 1)
        push!(monthcals, calendar_month(advent(1, ly)))
    end
    push!(monthcals, calendar_month(Date(ly.starts_in, 12))) 
   
    for mo in January:November
        targetdate = Date(ly.ends_in, mo)
        @debug("Push calendar month for $(targetdate)")
        push!(monthcals, calendar_month(targetdate))
    end
    if civildate(nextadv) > cutoff
        push!(monthcals, calendar_month(Date(ly.ends_in, 12)))
    end

    monthcals
end


function calendar_year(lday::LiturgicalDay)::Vector{Vector{Vector{Union{Nothing, LiturgicalDay}}}}
    calendar_year(civildate(lday))
end