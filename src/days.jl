abstract type LiturgicalDay end

function name(theday::T) where {T <: LiturgicalDay}
    @warn("Function name not implemented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function civildate(theday::T) where {T <: LiturgicalDay}
    @warn("Function civildate not implemented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function precedence(theday::T) where {T <: LiturgicalDay}
    @warn("Function precedence not implemented for LiturgicalDay type $(typeof(theday))")
    nothing
end

"""Find correct liturgical year for a given liturgical day.

**Example**

```{julia-repl}
julia> liturgical_year(christmas_day())
2023-2024
```
$(SIGNATURES)
"""
function liturgical_year(litday::LiturgicalDay)
    civildate(litday) |> liturgical_year
end


"""Find first reading (normally Old Testament) for a given day.

**Example**
```{julia-repl}
julia> reading1(christmas_day())
1-element Vector{Vector{String}}:
 ["Isaiah 9.2-9.7"]
 ```

 $(SIGNATURES) 
"""
function reading1(theday::LiturgicalDay; urns = false)::Vector{Vector{String}}
    rdgs = readings(theday) 
    reading1(rdgs; urns = urns)
end

"""Find second reading (normally New Testament) for a given day.

**Example**
```{julia-repl}
julia> reading2(christmas_day())
1-element Vector{Vector{String}}:
 ["Titus 2.11-2.14"]]
 ```
$(SIGNATURES) 
"""
function reading2(theday::LiturgicalDay; urns = false)::Vector{Vector{String}}
    rdgs = readings(theday)
    reading2(rdgs; urns = urns)
end



"""Find second reading (normally New Testament) for a given day.

**Example**
```{julia-repl}
julia> psalm(christmas_day())
1-element Vector{Vector{String}}:
 ["Psalm 96"]
 ```
$(SIGNATURES) 
"""
function psalm(theday::LiturgicalDay; urns = false)::Vector{Vector{String}}
    rdgs = readings(theday)  
    psalm(rdgs; urns = urns)
end


"""Find second reading (normally New Testament) for a given day.

**Example**
```{julia-repl}
julia> gospel(christmas_day())
2-element Vector{Vector{String}}:
 ["Luke 2.1-1.14"]
 ["Luke 2.1-2.20"]
 ```
$(SIGNATURES) 
"""
function gospel(theday::LiturgicalDay; urns = false)::Vector{Vector{String}}
    rdgs = readings(theday)
    gospel(rdgs; urns = urns)
end