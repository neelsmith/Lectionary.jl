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
$(SIGNATURES)
"""
function liturgical_year(litday::LiturgicalDay)
    civildate(litday) |> liturgical_year
end