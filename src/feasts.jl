
struct PrincipalFeast <: LiturgicalDay
    feastid::Int
    yr::Int
end

function name(pf::PrincipalFeast)
    feast_names[pf.feastid]
end


"""True if principal feast has a fixed date.
$(SIGNATURES)
"""
function isfixed(pf::PrincipalFeast)
    pf.feastid in [FEAST_ALL_SAINTS, FEAST_CHRISTMAS, FEAST_EPIPHANY]
end

function civildate(pf::PrincipalFeast)
    if pf.feastid == FEAST_CHRISTMAS
        caldate(CHRISTMAS_DATE, pf.yr)
    elseif pf.feastid == FEAST_EPIPHANY
        caldate(EPIPHANY_DATE, pf.yr)
    elseif pf.feastid == FEAST_ALL_SAINTS
        caldate(ALL_SAINTS_DATE, pf.yr)
    elseif pf.feastid == FEAST_EASTER
        easter_sunday(pf.yr) |> civildate
    elseif pf.feastid == FEAST_ASCENSION
        ascension(pf.yr)
    elseif pf.feastid == FEAST_PENTECOST
        pentecost(pf.yr).dt
    elseif pf.feastid == FEAST_TRINITY
        trinity(pf.yr).dt
    else
        @warn("Not yet imlemented...")
        nothing
    end
end


function feastreadings(feast::PrincipalFeast, lectionaryyr::Char; as_urn = false) 
    if as_urn
        @warn("Support for URN references not implemented yet.")
    end
    if lectionaryyr == 'A'
        if haskey(feastselectionsA, feast.feastid)
            feastselectionsA[feast.feastid]
        else
            @warn("Could not find reading for $(feast) in year $(lectionaryyr)")
            nothing
        end

    elseif lectionaryyr == 'B'
        if haskey(feastselectionsB, feast.feastid)
            feastselectionsB[feast.feastid]
        else
            @warn("Could not find reading for $(feast) in year $(lectionaryyr)")
            nothing
        end
    
    elseif lectionaryyr == 'C'
        if haskey(feastselectionsC, feast.feastid)
            feastselectionsC[feast.feastid]
        else
            @warn("Could not find reading for $(faste) in year $(lectionaryyr)")
            nothing
        end

    else
        @warn("Invalid value for lectionary year: $(lectionaryyr)")
        nothing
    end     
   
end