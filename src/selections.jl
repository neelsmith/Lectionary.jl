"""A set of readings for a single liturgy.
$(SIGNATURES)
"""
struct Readings
    ot_string::String
    nt_string::String
    gospel_string::String
    psalm_string::String
end



# Returns a vector of choices for readings.
# Each choice in turn is a vector of one or more passages.
"""Organize string values from RCL lists into structured vectors of readings
(readings 1 and 2, psalm, gospel) where each reading in turn is a vector of one
or more passage references.

Colons delimit choices among different readings; commas separate references for disjoint passages of a single reading.
$(SIGNATURES)
"""
function formatreadingstring(s)
    tidier = replace(s, "_" => " ")
    alternates = split(tidier, ";") .|> strip
    map(alternates) do v
        [titlecase(strip(s)) for s in split.(v,",")]
    end
end


"""Find first reading (normally Old Testament) from the assigned readings for a liturgy.

**Example**
```{julia-repl}
julia> rdgs = readings(christmas_day())
Readings("Isaiah 9.2-9.7", "Titus 2.11-2.14", "Luke 2.1-1.14 ;  Luke 2.1-2.20", "Psalm 96")
julia> reading1(rdgs)
1-element Vector{Vector{String}}:
 ["Isaiah 9.2-9.7"]
```
$(SIGNATURES)
"""
function reading1(rdg::Readings; as_urn = false)::Vector{Vector{String}}
    
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.ot_string)
end

"""Find second reading (normally New Testament) from the assigned readings for a liturgy.

**Example**

```{julia-repl}
julia> rdgs = readings(christmas_day())
Readings("Isaiah 9.2-9.7", "Titus 2.11-2.14", "Luke 2.1-1.14 ;  Luke 2.1-2.20", "Psalm 96")
julia> reading2(rdgs)
1-element Vector{Vector{String}}:
 ["Titus 2.11-2.14"]
```

$(SIGNATURES)
"""
function reading2(rdg::Readings; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.nt_string)
end


"""Find Gospel selection from the assigned readings for a liturgy.

**Example**

```{julia-repl}
julia> rdgs = readings(christmas_day())
Readings("Isaiah 9.2-9.7", "Titus 2.11-2.14", "Luke 2.1-1.14 ;  Luke 2.1-2.20", "Psalm 96")
julia> gospel(rdgs)
2-element Vector{Vector{String}}:
 ["Luke 2.1-1.14"]
 ["Luke 2.1-2.20"]
```

$(SIGNATURES)
"""
function gospel(rdg::Readings; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.gospel_string)
end

"""Find Psalm selection from the assigned readings for a liturgy.



**Example**

```{julia-repl}
julia> rdgs = readings(christmas_day())
Readings("Isaiah 9.2-9.7", "Titus 2.11-2.14", "Luke 2.1-1.14 ;  Luke 2.1-2.20", "Psalm 96")
julia> gospel(rdgs)
1-element Vector{Vector{String}}:
 ["Psalm 96"]
```

$(SIGNATURES)
"""
function psalm(rdg::Readings; as_urn = false)
    if as_urn
        @warn("URN translation not yet implemented")
    end
    formatreadingstring(rdg.psalm_string)
end

