

"""Find readings in RCL for a given liturgical year.
$(SIGNATURES)
"""
function readings(lityr::LiturgicalYear; 
    as_urn = false)
    lectyear = lectionary_year(lityr)
    [readings(theday, lectyear; as_urn = as_urn) for theday in kalendar(lityr)]
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
        #@info("Get readings for feast $(theday)")
        feastreadings(theday, yr; as_urn = as_urn)

    elseif theday isa Sunday
        #@info("Get readings for sunday $(theday)")
        sundayreadings(theday, yr; as_urn = as_urn)

    else
        @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
        nothing
    end
end


