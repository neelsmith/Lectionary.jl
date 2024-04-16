struct LiturgicalYear
    starts_in::Int
    ends_in::Int
    function LiturgicalYear(startyr::Int)
        endyr = startyr + 1
        new(startyr, endyr)
    end
end

"""Override `Base.==` for `Codex`.
$(SIGNATURES)
"""
function ==(yr1::LiturgicalYear, yr2::LiturgicalYear)
    yr1.starts_in == yr.starts_in &&
    yr1.ends_in == yr.ends_in 
end

"""Override `Base.show` for `Codex`.
$(SIGNATURES)
"""
function show(io::IO, year::LiturgicalYear)
    write(io, string(year.starts_in,"-",year.ends_in))
end

"""Rules for finding lectionary year cycle,
as a Dict."""
const lectionary_year_dict = Dict(
    0 => "A",
    1 => "B",
    2 => "C"
)


"""Find lectionary year cycle for a given year.
$(SIGNATURES)
"""
function lectionary_year(yr::Int)
    remainder = mod(yr, 3)
    lectionary_year_dict[remainder]
end


"""Find lectionary year cycle for a given liturgical year.
$(SIGNATURES)
"""
function lectionary_year(lityear::LiturgicalYear)
    lectionary_year(lityear.starts_in)
end


function sundays(lityear::LiturgicalYear)
    
   vcat(
        adventseason(lityear), 
        christmas_sundays(lityear), 
        epiphany(lityear),
        lentseason(lityear),
        palmsunday(lityear),
        easter(lityear)
    )
end