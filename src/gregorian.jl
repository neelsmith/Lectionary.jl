"""Find the seven-day range beginning with Sunday 
that a given date falls in.


**Examples**
```julia-repl
julia> Lectionary.weekrange()
Date("2024-04-21"):Day(1):Date("2024-04-27")
julia> Lectionary.weekrange(Date(2024,4,23))
Date("2024-04-21"):Day(1):Date("2024-04-27")

```

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

**Examples**
```julia-repl
julia> calendar_week()
7-element Vector{Union{Nothing, LiturgicalDay}}:
 the fourth Sunday of Easter, April 21, 2024
 nothing
 nothing
 nothing
 Saint Mark the Evangelist, April 25, 2024
 nothing
 nothing
julia> calendar_week(Date(2024,4,24))
7-element Vector{Union{Nothing, LiturgicalDay}}:
 the fourth Sunday of Easter, April 21, 2024
 nothing
 nothing
 nothing
 Saint Mark the Evangelist, April 25, 2024
 nothing
 nothing
```
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

```julia-repl
julia> calendar_week(Commemoration(Lectionary.FEAST_SAINT_MARK, 2024))
7-element Vector{Union{Nothing, LiturgicalDay}}:
 the fourth Sunday of Easter, April 21, 2024
 nothing
 nothing
 nothing
 Saint Mark the Evangelist, April 25, 2024
 nothing
 nothing
```
$(SIGNATURES)
"""
function calendar_week(lday::LiturgicalDay)::Vector{Union{Nothing, LiturgicalDay}}
    calendar_week(civildate(lday))
end



"""Compose a vector of 4 or 5 week vectors for a calendar month, with values of either a liturgical day or nothing for each day in each week.

**Examples**
```julia-repl
julia> calendar_month()
5-element Vector{Vector{Union{Nothing, LiturgicalDay}}}:
 [Easter Day, March 31, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
 [the second Sunday of Easter, April 7, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
 [the third Sunday of Easter, April 14, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
 [the fourth Sunday of Easter, April 21, 2024, nothing, nothing, nothing, Saint Mark the Evangelist, April 25, 2024, nothing, nothing]
 [the fifth Sunday of Easter, April 28, 2024, nothing, nothing, Saint Philip and Saint James, Apostles, May 1, 2024, nothing, nothing, nothing]
 julia> calendar_month(Date(2024,4,2))
 5-element Vector{Vector{Union{Nothing, LiturgicalDay}}}:
  [Easter Day, March 31, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
  [the second Sunday of Easter, April 7, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
  [the third Sunday of Easter, April 14, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
  [the fourth Sunday of Easter, April 21, 2024, nothing, nothing, nothing, Saint Mark the Evangelist, April 25, 2024, nothing, nothing]
  [the fifth Sunday of Easter, April 28, 2024, nothing, nothing, Saint Philip and Saint James, Apostles, May 1, 2024, nothing, nothing, nothing] 
```

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

**Example**

```julia-repl
julia> calendar_month(eastertide(2,2024))
5-element Vector{Vector{Union{Nothing, LiturgicalDay}}}:
 [Easter Day, March 31, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
 [the second Sunday of Easter, April 7, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
 [the third Sunday of Easter, April 14, 2024, nothing, nothing, nothing, nothing, nothing, nothing]
 [the fourth Sunday of Easter, April 21, 2024, nothing, nothing, nothing, Saint Mark the Evangelist, April 25, 2024, nothing, nothing]
 [the fifth Sunday of Easter, April 28, 2024, nothing, nothing, Saint Philip and Saint James, Apostles, May 1, 2024, nothing, nothing, nothing]
```

$(SIGNATURES)
"""
function calendar_month(lday::LiturgicalDay)::Vector{Vector{Union{Nothing, LiturgicalDay}}}
    calendar_month(civildate(lday))
end


"""Construct a vector of twelve elements with each element containing the output of the `calendar_month` function.


**Examples**
```julia-repl
julia> calendar_year() |> typeof
Vector{Vector{Vector{Union{Nothing, LiturgicalDay}}}} (alias for Array{Array{Array{Union{Nothing, LiturgicalDay}, 1}, 1}, 1})
julia> calendar_year() == calendar_year(Date(2024, 4, 1))
true
```

$(SIGNATURES)
"""
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


"""Construct a calendar of months in the civil year for a given liturgical year.
$SIGNATURES
"""
function calendar_year(lday::LiturgicalDay)::Vector{Vector{Vector{Union{Nothing, LiturgicalDay}}}}
    calendar_year(civildate(lday))
end