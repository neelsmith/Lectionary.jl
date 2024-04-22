struct Reading
    ot_string::String
    nt_string::String
    gospel_string::String
    psalm_string::String
end

# Returns a vector of choices for readings.
# Each choice in turn is a vector of one or more passages.
function formatreadingstring(s)
    tidier = replace(s, "_" => " ")
    alternates = split(tidier, ";") .|> strip
    map(alternates) do v
        [titlecase(strip(s)) for s in split.(v,",")]
    end
end

# Format: colon delimited options; comma-separated for disjoint passages
"""Get readings of Old Testament.
$(SIGNATURES)
"""
function ot(rdg::Reading; as_urn = false)
    
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.ot_string)
end

"""Get readings of New Testament.
$(SIGNATURES)
"""
function nt(rdg::Reading; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.nt_string)
end

"""Get readings of Gospel.
$(SIGNATURES)
"""
function gospel(rdg::Reading; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.gospel_string)
end

"""Get readings of Psalm.
$(SIGNATURES)
"""
function psalm(rdg::Reading; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.psalm_string)
end



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


