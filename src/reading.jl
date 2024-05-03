
"""Get dictionary mapping sequence of proper to readings for a given liturgical year.
$(SIGNATURES)
"""
function propersdict(lityr::LiturgicalYear = LiturgicalYear())::Union{Nothing,Dict{Int64, @NamedTuple{A::Readings, B::Readings}}}
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
function properreadings(lityr::LiturgicalYear = LiturgicalYear(), track = 'A')::Vector{Readings}
    sundaylist = pentecost_sundays(lityr)

    ordinary_cf = length(pentecost_sundays(lityr))

    @debug("Easter on $(easter_sunday(lityr) |> civildate), $(ordinary_cf) Sundays in ordinary time:")

    readingsdict = propersdict(lityr)
    
    readingslist = Readings[]
    for (i,sunday) in enumerate(sundaylist)
        
        idx = i + 3
        @debug("Get proper for Sunday with proper $(idx) on  $(civildate(sunday))")
        if track == 'A'
            push!(readingslist, readingsdict[idx].A)
        elseif track == 'B'
            push!(readingslist, readingsdict[idx].B)
        else
            @warn("Invalid track $(track) for propers readings.")
            nothing
        end
    end
    readingslist
end

#=
Get vector of propers
Get vector of sundays
Slice last n propers where n is lenght(sundays)
Then just index directly into sliced vector
    =#
function properreadings(litday::LiturgicalDay, track = 'A')
    @debug("\nGet proper readings for $(litday)\n")
    lityr = liturgical_year(litday)
    propers = properreadings(lityr, track)
    @debug("\n\nFound $(length(propers)) reading selections for propers")
    
    if name(litday) == "Christ the King"
        propers[end]

    else
        pent_sundays = pentecost_sundays(lityr)
        
        @debug("\nCompare $(length(pent_sundays)) Sundays with $(length(propers)) propers\n")
        idx = findfirst(sday -> sday == litday, pent_sundays)

        @debug("Index is $(idx)")
        propers[idx]

    end
end

# FIX THIS SO THERE'S NO Union{Nothing,...} !
"""Find all readings in RCL for a given liturgical year.
$(SIGNATURES)
"""
function readings(lityr::LiturgicalYear = LiturgicalYear(); 
    urns = false, track = 'A', service = 1)::Vector{Readings} # ::Vector{Union{Nothing, Readings}}
    lectyear = lectionary_year(lityr)

    kal = kalendar(lityr)
    pentecostdate = civildate(pentecost_day(lityr))
    dates1 = filter(theday -> civildate(theday) <= pentecostdate || ! isa(theday, LiturgicalSunday), kal)
    @debug("Get readings for $(length(dates1)) feasts")
    rdgs1 = [readings(theday, lectyear; urns = urns) for theday in dates1]
    rdgs2 = properreadings(lityr, track)
    @debug("Get readings for $(length(rdgs2)) propers")
    vcat(rdgs1, rdgs2)
end

"""Find readings in RCL for a given day in a given liturgical year.
$(SIGNATURES)
"""
function readings(theday::T, lityr::LiturgicalYear = LiturgicalYear(); urns = false, track = 'A', service = 1) where {T <: LiturgicalDay}
    readings(theday, lectionary_year(lityr); urns = urns, track = track, service  = service)
end

"""Find readings in RCL for a given day in a given year of the civil calendar.
$(SIGNATURES)
"""
function readings(theday::T, yr::Char; urns = false, service = 1, track = 'A') where {T <: LiturgicalDay} #::Union{Nothing, Readings} 
    
    # Need to check if we're in ordinary time after Pentecost, and is so
    # use propers selections
    
    @debug("Get readings for day $(theday) in year $(yr)")
    if theday isa Commemoration
        @debug("Get readings for feast $(theday)")
        # Check for Christmas Day, which has
        # readings for multiple services in RCL
        if name(theday) == "Christmas Day"
           @assert service in 1:3
           xmasliturgiesB[service]
           
        else
            feastreadings(theday, yr; as_urn = as_urn)
        end

    elseif theday isa LiturgicalSunday
        @debug("Get readings for sunday $(theday)")
        if  in_pentecost(theday)
            @debug("But we're ordinary time after PEnteccost")
            properreadings(theday, track)

        # Palm Sunday, and Easter have
        # readings for multiple services in RCL
        elseif name(theday) == "Palm Sunday"
            @debug("Need to check which service for Palm Sunday readings")
            @assert service in 1:2
            palmliturgiesB[service]

        elseif name(theday)== "Easter Day"
            @debug("Need to check which service for Easter readings")
            @assert service in 1:4
            easterliturgiesB[service]
            
        else
            sundayreadings(theday, yr; urns = urns)
        end
    
    else
        @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
        nothing
    end
end


