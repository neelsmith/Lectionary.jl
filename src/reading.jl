
"""Get dictionary mapping sequence of proper to readings for a given liturgical year.
$(SIGNATURES)
"""
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

"""Find readings for all propers in a given liturgical year
using a given track for Old Testament selections.

$(SIGNATURES)
"""
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

"""Find all readings in RCL for a given liturgical year.
$(SIGNATURES)
"""
function readings(lityr::LiturgicalYear = LiturgicalYear(); 
    as_urn = false, track = 'A', service = 1)
    lectyear = lectionary_year(lityr)

    kal = kalendar(lityr)
    epiphanydate = civildate(epiphany_day(lityr))
    dates1 = filter(theday -> civildate(theday) <= epiphanydate, kal)
    rdgs1 = [readings(theday, lectyear; as_urn = as_urn) for theday in dates1]
    rdgs2 = properreadings(lityr, track; service = service)
end

"""Find readings in RCL for a given day in a given liturgical year.
$(SIGNATURES)
"""
function readings(theday::T, lityr::LiturgicalYear = LiturgicalYear(); as_urn = false, track = 'A', service = 1) where {T <: LiturgicalDay}
    readings(theday, lectionary_year(lityr); as_urn = as_urn, track = track, service  = service)
end

"""Find readings in RCL for a given day in a given year of the civil calendar.
$(SIGNATURES)
"""
function readings(theday::T, yr::Char; as_urn = false, service = 1, track = 'A') where {T <: LiturgicalDay}
    
    # Need to check if we're in ordinary time after Pentecost, and is so
    # use propers selections
    
    @debug("Get readings for day $(theday) in year $(yr)")
    if theday isa Commemoration
        @debug("Get readings for feast $(theday)")
        # Check for Christmas Day, which has
        # readings for multiple services in RCL
        if name(theday) == "Christmas Day"
            @info("Need to check service for Christmas Day readings")
        else
            feastreadings(theday, yr; as_urn = as_urn)
        end

    elseif theday isa LiturgicalSunday
        # Palm Sunday, and Easter have
        # readings for multiple services in RCL
        @debug("Get readings for sunday $(theday)")
        if name(theday) == "Palm Sunday"
            @info("Need to check service for Palm Sunday readings")
        elseif name(theday)== "Easter Day"
            @info("Need to check service for Easter readings")
            

        else
        
            sundayreadings(theday, yr; as_urn = as_urn)
        end
    else
        @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
        nothing
    end
end


