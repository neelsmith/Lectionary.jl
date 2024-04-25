
function propersdict(lityr::LiturgicalYear = LiturgicalYear())
    lectyear = lectionary_year(lityr)
    if lectyear == 'A'
        propersA
    elseif lectyear == 'B'
        propersB
    elseif lectyear == 'C'
        propersC
    else
        @warn("Invalid value for lectionary year: $(lectyear)")
        nothing
    end
end

function calcheck(lityr::LiturgicalYear = LiturgicalYear())
    sundaylist = pentecost_season(lityr)[2:end]

    epiph_cf = epiphany_sundays(lityr)
    @info("Easter $(easter_sunday(lityr) |> civildate)")
    @info("$(length(epiph_cf)) Sundays after Epiphany") 
    @info("Ash Wednesday $(ash_wednesday_date(lityr))")
    @info("Ascension Day $(ascension(lityr))")
    @info("Pentencost $(pentecost_day(lityr) |> civildate)")
    
    @info("$(length(sundaylist)) Sundays in ordinary time")

    @info("$(epiph_cf)")
end

function properreadings(lityr::LiturgicalYear = LiturgicalYear(), track = 'A')
    sundaylist = pentecost_season(lityr)[2:end]

    epiph_cf = length(epiphany_sundays(lityr))
    @info("Easter on $(easter_sunday(lityr) |> civildate), $(epiph_cf) Sundays in Epiphany: $(length(sundaylist)) Sundays in ordinary time")

    readingsdict = propersdict(lityr)
    
    for (i,sunday) in enumerate(sundaylist)
        
        idx = i + 2
        #@info("Get proper $(idx)")
        if track == 'A'
            readingsdict[idx].A
        elseif track == 'B'
            readingsdict[idx].B
        else
            @warn("Invalid track $(track) for propers readings.")
            nothing
        end

    end
end

"""Find readings in RCL for a given liturgical year.
$(SIGNATURES)
"""
function readings(lityr::LiturgicalYear = LiturgicalYear(); 
    as_urn = false, track = 'A')
    lectyear = lectionary_year(lityr)

    kal = kalendar(lityr)
    epiphanydate = civildate(epiphany_day(lityr))
    dates1 = filter(theday -> civildate(theday) <= epiphanydate, kal)
    rdgs1 = [readings(theday, lectyear; as_urn = as_urn) for theday in dates1]
    rdgs2 = properreadings(lityr, track)
end

"""Find readings in RCL for a given day in a given liturgical year.
$(SIGNATURES)
"""
function readings(theday::T, lityr::LiturgicalYear; as_urn = false) where {T <: LiturgicalDay}
    readings(theday, lectionary_year(lityr); as_urn = as_urn)
end

"""Find readings in RCL for a given day in a given year of the civil calendar.
$(SIGNATURES)
"""
function readings(theday::T, yr::Char; as_urn = false) where {T <: LiturgicalDay}
    @info("Get readings for year $(yr)")
    if theday isa Commemoration
        @debug("Get readings for feast $(theday)")
        feastreadings(theday, yr; as_urn = as_urn)

    elseif theday isa Sunday
        @debug("Get readings for sunday $(theday)")
        sundayreadings(theday, yr; as_urn = as_urn)

    else
        @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
        nothing
    end
end


