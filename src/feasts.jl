

struct Feast <: LiturgicalDay
    feastid::Int
    yr::Int
end


"""Override `Base.==` for `Feast`.
$(SIGNATURES)
"""
function ==(f1::Feast, f2::Feast)
    f1.feastid == f2.feastid &&
    f1.yr == f2.yr
end

"""Override `Base.show` for `Feast`.
$(SIGNATURES)
"""
function show(io::IO, fst::Feast)
    dt = civildate(fst)
    formatteddate = string(monthname(dt), " ",  dayofmonth(dt), ", ", year(dt))
    write(io, name(fst) * ", " * formatteddate)
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
        caldate(CHRISTMAS_DATE, fst.yr)
    elseif fst.feastid == FEAST_EPIPHANY
        caldate(EPIPHANY_DATE, fst.yr)
    elseif fst.feastid == FEAST_ALL_SAINTS
        caldate(ALL_SAINTS_DATE, fst.yr)
    elseif fst.feastid == FEAST_EASTER
        easter_sunday(fst.yr) |> civildate
    elseif fst.feastid == FEAST_ASCENSION
        ascension(fst.yr)
    elseif fst.feastid == FEAST_PENTECOST
        pentecost(fst.yr).dt
    elseif fst.feastid == FEAST_TRINITY
        trinity(fst.yr).dt
    else
        @warn("Not yet imlemented...")
        nothing
    end
end

function weekday(fst::Feast)
    civildate(fst) |> dayname
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



function christmas_day(lityr::LiturgicalYear)
    christmas_day(lityr.starts_in)
    
end

function christmas_day(yr::Int)
    Feast(FEAST_CHRISTMAS, yr)
end