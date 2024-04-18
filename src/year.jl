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

"""Find correct liturgical year for a given date in the civil calendar.
$(SIGNATURES)
"""
function liturgical_year(dt::Date)
    if dt > advent(1, year(dt)).dt
        LiturgicalYear(year(dt))
    else
        LiturgicalYear(year(dt) - 1)
    end
end

"""Find correct liturgical day for a given date in the civil calendar.
$(SIGNATURES)
"""
function liturgical_day(dt::Date)
    lityr = liturgical_year(dt)
    feastlist = principalfeasts(lityr) #.|> civildate
    feastmatch = findfirst(f -> civildate(f) == dt, feastlist)

    sundaylist = sundays(lityr) #.|> civildate
    sundaymatch = findfirst(f -> civildate(f) == dt, sundaylist) 
  
    if ! isnothing(feastmatch)
        feastlist[feastmatch]
    elseif ! isnothing(sundaymatch)
        sundaylist[sundaymatch]
    else        
        otherday = OtherDay(dt)
    end
end



"""Rules for finding lectionary year cycle,
as a Dict."""
const lectionary_year_dict = Dict(
    0 => "A",
    1 => "B",
    2 => "C"
)

"""Find lectionary year cycle for a given liturgical year.
$(SIGNATURES)
"""
function lectionary_year(lityr::LiturgicalYear)
    lectionary_year(lityr.starts_in)
end


"""Find lectionary year cycle for a given year.
$(SIGNATURES)
"""
function lectionary_year(yr::Int)
    remainder = mod(yr, 3)
    lectionary_year_dict[remainder]
end

"""Find daily office year cycle for a given liturgical year.
$(SIGNATURES)
"""
function daily_office_year(lityr::LiturgicalYear)
    daily_office_year(lityr.starts_in)
end

"""Find daily office year cycle for a given year.
$(SIGNATURES)
"""
function daily_office_year(yr::Int)
    mod(yr, 2) + 1 
end



"""Find Sundays in a give liturgical year.
$(SIGNATURES)
"""
function sundays(lityear::LiturgicalYear)
    
   vcat(
        advent_season(lityear), 
        christmas_sundays(lityear), 
        epiphany(lityear),
        lent_season(lityear),
        [palm_sunday(lityear), easter_sunday(lityear)],
        easter_season(lityear),
        [pentecost(lityear), trinity(lityear)],
        pentecost_season(lityear)
    )
end


function principalfeasts(lityear::LiturgicalYear)
    [
        PrincipalFeast(FEAST_CHRISTMAS, lityear.starts_in),
        PrincipalFeast(FEAST_EPIPHANY, lityear.ends_in),
        PrincipalFeast(FEAST_EASTER, lityear.ends_in),
        PrincipalFeast(FEAST_ASCENSION, lityear.ends_in),
        PrincipalFeast(FEAST_PENTECOST, lityear.ends_in),
        PrincipalFeast(FEAST_TRINITY, lityear.ends_in),
        PrincipalFeast(FEAST_ALL_SAINTS, lityear.ends_in)
    ]
end