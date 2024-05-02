"""A set of readings for a single liturgy.
$(SIGNATURES)
"""
struct Readings
    ot_string::String
    nt_string::String
    gospel_string::String
    psalm_string::String
end

#=
"""A set of readings for a single liturgy.
$(SIGNATURES)
"""
function Readings()
    Readings("","","","")
end
=#


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
"""Find first reading (normally Old Testament).
$(SIGNATURES)
"""
function reading1(rdg::Readings; as_urn = false)
    
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.ot_string)
end

"""Find second reading (normally New Testament).
$(SIGNATURES)
"""
function reading2(rdg::Readings; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.nt_string)
end

"""Find Gospel selection.
$(SIGNATURES)
"""
function gospel(rdg::Readings; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.gospel_string)
end

"""Find Psalm selection.
$(SIGNATURES)
"""
function psalm(rdg::Readings; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.psalm_string)
end

