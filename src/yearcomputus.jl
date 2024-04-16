"""Find day of week of Christmas in a given year.
$(SIGNATURES)
"""
function christmasday(yr::Int)
    Dates.dayname(Date(yr, 12, 25))
end

"""Find day of week of Epiphany in a given year.
$(SIGNATURES)
"""
function epiphanyday(yr::Int)
    Dates.dayname(Date(yr, 1, 6))
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
    prev
end


"""Find all Sundays in season of Christmas in a given year.
$(SIGNATURES)
"""
function christmas_sundays(yr::Int)
    christmas_sundays(LiturgicalYear(yr))
end


"""Find all Sundays in season of Christmas in a given liturgical year.
$(SIGNATURES)
"""
function christmas_sundays(lityr::LiturgicalYear)
    epiphany = Date(lityr.ends_in, 1, 6)
    xmas = Date(lityr.starts_in, 12, 25)
    prev = epiphany
    sundays = []
    while prev > xmas
        prev = prev  - Dates.Day(1)
        if dayname(prev) == "Sunday"
            push!(sundays, prev)
        end
    end
    sundays |> reverse
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


"""Find date of Ash Wedensday for a given year.
$(SIGNATURES)
"""
function ash_wednesday(yr::Int)
    lent(1, yr) - Dates.Day(4)
end

function palmsunday(lityr::LiturgicalYear)
    palmsunday(lityr.ends_in)
end


"""Find date of Palm Sunday for a given year.
$(SIGNATURES)
"""
function palmsunday(yr::Int)
    easter(yr) - Dates.Day(7)
end



## THIS IS BROKEN!
"""Find date of a given week of Advent in a given year.
$(SIGNATURES)
"""
function lent(sunday::Int, yr::Int)
    sundaystofind = 7 - sunday
    easter(yr) - Dates.Day(sundaystofind * 7)
end


function eastertide(sunday::Int, yr::Int)
    @assert sunday < 8
    easter(yr) + Dates.Day(sunday * 7)
end

function epiphany(lityr::LiturgicalYear)
    epiphany(lityr.ends_in)
end

function epiphany(yr::Int)

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
    sundays |> reverse

   
end


function adventseason(yr::Int)
    adventseason(LiturgicalYear(yr))
end

function adventseason(lityear::LiturgicalYear)
    [advent(sunday, lityear.starts_in) for sunday in 1:4] 
end


function lentseason(yr::Int)
    lentseason(LiturgicalYear(yr))
end

function lentseason(lityear::LiturgicalYear)
    [lent(sunday, lityear.ends_in) for sunday in 1:5] 
end
