abstract type LiturgicalDay end

function name(theday::T) where {T <: LiturgicalDay}
    @warn("Function name not implemented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function civildate(theday::T) where {T <: LiturgicalDay}
    @warn("Function civildate not implemented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function priority(theday::T) where {T <: LiturgicalDay}
    @warn("Function civildate not implemented for LiturgicalDay type $(typeof(theday))")
    nothing
end


