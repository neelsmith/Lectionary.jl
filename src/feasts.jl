

struct Feast <: LiturgicalDay
    feastid::Int
    yr::Int
end

function name(fst::Feast)
    feast_names[fst.feastid]
end


function priority(fst::Feast)
    if fst.feastid in PRINCIPAL_FEASTS
        PRINCIPAL_FEAST
    elseif fst.feast in HOLY_DAYS_1
        HOLY_DAY_1
    elseif fst.feast in HOLY_DAYS_2
        HOLY_DAY_2

    else
        OTHER_DAY
    end
end

#=
"""True if principal feast has a fixed date.
$(SIGNATURES)
"""
function isfixed(pf::Feast)
    pf.feastid in [FEAST_ALL_SAINTS, FEAST_CHRISTMAS, FEAST_EPIPHANY]
end
=#

function civildate(fst::Feast)
    if fst.feastid == FEAST_CHRISTMAS
        caldate(CHRISTMAS_DATE, pf.yr)
    elseif fst.feastid == FEAST_EPIPHANY
        caldate(EPIPHANY_DATE, pf.yr)
    elseif fst.feastid == FEAST_ALL_SAINTS
        caldate(ALL_SAINTS_DATE, pf.yr)
    elseif fst.feastid == FEAST_EASTER
        easter_sunday(pf.yr) |> civildate
    elseif fst.feastid == FEAST_ASCENSION
        ascension(pf.yr)
    elseif fst.feastid == FEAST_PENTECOST
        pentecost(pf.yr).dt
    elseif fst.feastid == FEAST_TRINITY
        trinity(pf.yr).dt
    else
        @warn("Not yet imlemented...")
        nothing
    end
end


function feastreadings(feast::Feast, lectionaryyr::Char; as_urn = false) 
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