struct LiturgicalYear
    starts_in::Int
    ends_in::Int
    function LiturgicalYear(startyr::Int)
        endyr = startyr + 1
        new(startyr, endyr)
    end
end

function LiturgicalYear(dt::Date = Date(Dates.now()))
    yr = year(dt)
    if dt >= advent(1, yr).dt
        LiturgicalYear(yr)
    else
        LiturgicalYear(yr - 1)
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

function date_range(yr::LiturgicalYear)
    lastday = advent(1,yr.ends_in).dt - Dates.Day(1)
    advent(1, yr.starts_in).dt:lastday
end

#=
"""Find correct liturgical year for a given date in the civil calendar.
$(SIGNATURES)
"""
function liturgical_year(dt::Date)
    if dt > advent(1, year(dt)).dt
        LiturgicalYear(year(dt))
    else
        LiturgicalYear(year(dt) - 1)
    end
end=#

"""Find correct liturgical day for a given date in the civil calendar.
$(SIGNATURES)
"""
function liturgical_day(dt::Date)
    lityr = liturgical_year(dt)
    feastlist = principal_feasts(lityr) #.|> civildate
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
    0 => 'A',
    1 => 'B',
    2 => 'C'
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
        epiphany_season(lityear),
        lent_season(lityear),
        [palm_sunday(lityear), easter_sunday(lityear)],
        easter_season(lityear),
        [pentecost(lityear), trinity(lityear)],
        pentecost_season(lityear)
    )
end


function principal_feasts(lityear::LiturgicalYear)
    [
        Feast(thefeast, lityear.starts_in) for thefeast in PRINCIPAL_FEASTS
    ]
end

function holy_days(lityear::LiturgicalYear)
    allholydays = vcat(HOLY_DAYS_1, HOLY_DAYS_2)
    #[
     #   Feast(thefeast, lityear.starts_in) for thefeast in allholydays
    #]
    map(allholydays) do f
        Feast(f, lityear.ends_in)
    end
end


function kalendar(lityr::LiturgicalYear)
    
end

function christmas_day(lityr::LiturgicalYear)
    christmas_day(lityr.starts_in)
    
end

function christmas_day(yr::Int)
    Feast(FEAST_CHRISTMAS, yr)
end