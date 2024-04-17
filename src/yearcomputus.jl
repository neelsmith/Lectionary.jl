#
# Advent
#

"""Find date of a given week of Advent in a given liturgical year.
$(SIGNATURES)
"""
function advent(sunday::Int, lityr::LiturgicalYear)
    advent(sunday, lityr.starts_in)
end

"""Find date of a given week of Advent in a given year.
$(SIGNATURES)
"""
function advent(sunday::Int, yr::Int)
    sundaystofind = 5 - sunday
    @debug("Look back $(sundaystofind) Sundays")
    xmas = Date(yr, 12, 25)

    sundaysfound = 0
    prev = xmas
    while sundaysfound < sundaystofind #&& Dates.dayname(prev) != "Sunday"
        @debug("found: $(sundaysfound) / $(sundaystofind)")
        prev = prev - Dates.Day(1)
        @debug("Look at $(prev): $(dayname(prev))")
        if dayname(prev) == "Sunday"
            sundaysfound = sundaysfound + 1
        end
        
    end
    Sunday(prev, sunday)
end

"""Find Sundays of Advent in a given year.
$(SIGNATURES)
"""
function advent_season(yr::Int)
    advent_season(LiturgicalYear(yr))
end

"""Find Sundays of Advent in a given liturgical year.
$(SIGNATURES)
"""
function advent_season(lityear::LiturgicalYear)
    [advent(sunday, lityear.starts_in) for sunday in 1:4] 
end


#
# Christmas
#
"""Find all Sundays in season of Christmas in a given liturgical year.
$(SIGNATURES)
"""
function christmas_sundays(lityr::LiturgicalYear)
    epiphany = Date(lityr.ends_in, 1, 6)
    xmas = Date(lityr.starts_in, 12, 25)
    prev = epiphany
    sundaycount = 0
    sundays = []
    while prev > xmas
        @debug("Look at date $(prev): $(dayname(prev))")
        prev = prev  - Dates.Day(1)
        if dayname(prev) == "Sunday"
            sundaycount = sundaycount + 1
            @debug("Found Sunday $(sundaycount) on $(prev)")
            push!(sundays, prev)
        end
    end
    ordered = sundays |> reverse
    if length(ordered) == 2
        [Sunday(ordered[1], CHRISTMAS_1),
        Sunday(ordered[2], CHRISTMAS_2)
        ]
    else
        [Sunday(ordered[1], CHRISTMAS_1)]
    end

end

"""Find all Sundays in season of Christmas in a given year.
$(SIGNATURES)
"""
function christmas_sundays(yr::Int)
    christmas_sundays(LiturgicalYear(yr))
end


"""Find date of a given week of Christmas in a given year.
$(SIGNATURES)
"""
function christmas(sunday::Int, yr::Int)
    christmas(sunday, LiturgicalYear(yr))
end

"""Find date of a given week of Christmas in a given year.
$(SIGNATURES)
"""
function christmas(sunday::Int, lityr::LiturgicalYear)
    sundays = christmas_sundays(lityr)
    sunday > length(sundays) ? nothing : sundays[sunday]
end

#
# Epiphany
#

"""Find sundays of Epiphany season in a given liturgical year.
$(SIGNATURES)
"""
function epiphany(lityr::LiturgicalYear)
    epiphany(lityr.ends_in)
end


"""Find sundays of Epiphany season in a given year.
$(SIGNATURES)
"""
function epiphany(yr::Int)
    @info("Get ash wed for year $(yr)")
    endpoint = ash_wednesday(yr)
    epiph = Dates.Date(yr, 1, 6)
    
    prev = endpoint
    sundays = []
    while prev > epiph
        prev = prev  - Dates.Day(1)
        if dayname(prev) == "Sunday"
            push!(sundays, prev)
        end
    end
    ordered = sundays |> reverse

    sundaylist = []
    predecessor  = EPIPHANY  - 1
    for (i, sday) in enumerate(ordered)
        push!(sundaylist, Sunday(sday, predecessor + i))
    end
    sundaylist
end


#
# Lent
#
"""Find date of Ash Wednesday for a given year.
$(SIGNATURES)
"""
function ash_wednesday(yr::Int)

    lent(1, yr).dt - Dates.Day(4)
end


## THIS IS BROKEN!
"""Find date of a given week of Lent in a given year.
$(SIGNATURES)
"""
function lent(sunday::Int, yr::Int)
    sundaystofind = 7 - sunday
    sunday_date = easter(yr) - Dates.Day(sundaystofind * 7)

    predecessor = LENT_1 - 1
    Sunday(sunday_date, predecessor + sunday)
end


"""Find date of Palm Sunday for a given liturgical year.
$(SIGNATURES)
"""
function palmsunday(lityr::LiturgicalYear)
    palmsunday(lityr.ends_in)
end


"""Find date of Palm Sunday for a given year.
$(SIGNATURES)
"""
function palmsunday(yr::Int)
    dt = easter(yr) - Dates.Day(7)
    Sunday(dt, PALM_SUNDAY)
end

"""Find Sundays of Lent in a given liturgical year.
$(SIGNATURES)
"""
function lentseason(yr::Int)
    lentseason(LiturgicalYear(yr))
end

"""Find Sundays of Lent in a given liturgical year.
$(SIGNATURES)
"""
function lentseason(lityear::LiturgicalYear)
    [lent(sunday, lityear.ends_in) for sunday in 1:5] 
end



#
# EASTER AND EASTERTIDE
#

"""Find date of Easter in a given liturgical year.
$(SIGNATURES)
"""
function easter(lityr::LiturgicalYear)
    easter(lityr.ends_in)
end

"""Find date of Easter in a given year.
$(SIGNATURES)
"""
function easter(yr::Int)
    hr = Dates.DateTime(yr, 3, 21) 
    while mphase(jdcnv(hr)) < 0.99
        hr = hr + Dates.Hour(1)
    end
    fullmoon = Date(yr, month(hr), day(hr))
    nxtday = fullmoon + Dates.Day(1)
    while dayname(nxtday) != "Sunday"
        nxtday = nxtday + Dates.Day(1)
    end
    nxtday
end



"""Find date of a given week of Easter season in a given year.
$(SIGNATURES)
"""
function eastertide(sunday::Int, yr::Int)
    @assert sunday < 8
    easter(yr) + Dates.Day(sunday * 7)
end



