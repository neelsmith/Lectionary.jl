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



"""Find date of a given week of Christmas in a given year.
$(SIGNATURES)
"""
function christmas(sunday::Int, yr::Int)
    
end