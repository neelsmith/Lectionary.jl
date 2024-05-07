# urn:cts:compnov:bible.genesis
const BASE_CTS_URN = "urn:cts:compnov:bible"


"""Compute CtsUrns for each string in a vector of RCL citation strings.

**Example**
```julia-repl
julia> as_urn(["Luke 2.1-1.14"])
1-element Vector{CitableText.CtsUrn}:
 urn:cts:compnov:bible.luke:2.1-1.14
```

$(SIGNATURES)
"""
function as_urn(v::Vector{String})::Vector{CtsUrn}
    #@info("IT'S a SIMPLE V")
    urnlist = CtsUrn[]
    for psg in v            
        push!(urnlist, as_urn(psg))
    end
    urnlist
end

"""Compute a nested vector of vectors of CtsUrns from a
nested vector of vectors of string values.

**Example**

```julia-repl
julia> advent(1, 2023) |> readings |> psalm |> as_urn
1-element Vector{Vector{CitableText.CtsUrn}}:
 [urn:cts:compnov:bible.psalm:80.1-80.7, urn:cts:compnov:bible.psalm:80.16-80.18]
```
$(SIGNATURES)
"""
function as_urn(v::Vector{Vector{String}})
    @debug("IT'S A V of Vs")
    urnlist = Vector{CtsUrn}[]
    for psgvect in v
        push!(urnlist, as_urn(psgvect))
    end
    urnlist
end



"""Compute a CtsUrn for a single RCL citation string.

**Example**

```julia-repl
julia> as_urn("Isaiah 64.1-64.9")
urn:cts:compnov:bible.isaiah:64.1-64.9
```

$(SIGNATURES)
"""
function as_urn(s::AbstractString)::CtsUrn
    spelled = replace(s, "Psalm " => "Psalms ")
    tidied = replace(spelled, r"^([1-9]) " => s"\1_")
    (bk, ref) = split(tidied)
    string(BASE_CTS_URN,".",lowercase(bk),":",ref) |> CtsUrn
end


