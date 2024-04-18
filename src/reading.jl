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

#
# Sunday reading selections
#

sundayselectionsA = Dict()

# Paste in from
# https://lectionary.library.vanderbilt.edu/downloads/Year%20B%202023-2024.pdf
sundayselectionsB = Dict(
    
    ADVENT_1 =>  Reading(
               "Isaiah 64.1-64.9","1_Corinthians 1.3-1.9","Mark 13.24-13.37","Psalm 80:1-80.7, Psalm 80.16-80.18"),
    ADVENT_2 => Reading(
        "isaiah 40.1-40.11",

        "2_Peter 3.8-3.15a",
        "Mark 1.1-1.8",
        "Psalm 85.1-85.2, Psalm 85.8-85.13"
    ),
    ADVENT_3 => Reading(
        "Isaiah 61.1-61.4, Isaiah 61.8-61.11",
        
        "1_Thessalonians 5.16-5.24",
        "John 1.6-1.8, John 1.19-1.28",
        "Psalm 126; Luke 1.46b-1.55",
    ),
    ADVENT_4 => Reading(
        "2_ Samuel 7.1-7.11, 2_ Samuel 7.16",
        
        "Romans 16.25-16.27",
        "Luke 1.26-1.38",
        "Luke 1:46b-1.55; Psalm 89.1-89.4, Psalm 89.19-89.26"
    ),

    CHRISTMAS_1 => Reading(
        "Isaiah 61:10-62:3",
        "Galatians 4.4-4.7",
        "Luke 2.22-2.40",
        "Psalm 148"
    ),

    #CHRISTMAS_2 => Reading(
    #    "Isaiah 61:10-62:3",
    #    "Galatians 4.4-4.7",
    #    "Luke 2.22-2.40",
    #    "Psalm 148"
    #),

    EPIPHANY => Reading(
        "Isaiah 60.1-60.6",
        "Ephesians 3.1-3.12",
        "Matthew 2.1-2.12",
        "Psalm 72.1-72.7, Psalm 72.10-72.14",
    )

)
sundayselectionsC = Dict()




#
# Reading selections for feast days
#
feastselectionsA = Dict()

feastselectionsB = Dict(
    FEAST_EPIPHANY => Reading(  
        "Isaiah 60.1-60.6",
        "Ephesians 3.1-3.12",
        "Matthew 2.1-2.12",
        "Psalm 72.1-72.7, Psalm 72.10-72.14",
    )

)


feastselectionsC = Dict()