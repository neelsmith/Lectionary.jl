abstract type LiturgicalDay end

function name(theday::T) where {T <: LiturgicalDay}
    @warn("Function name not implmented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function civildate(theday::T) where {T <: LiturgicalDay}
    @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function readings(theday::T) where {T <: LiturgicalDay}
    @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
    nothing
end



