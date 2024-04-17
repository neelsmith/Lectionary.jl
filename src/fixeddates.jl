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
