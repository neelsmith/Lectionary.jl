abstract type LiturgicalDay end

function name(theday::T) where {T <: LiturgicalDay}
    @warn("Function name not implmented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function civildate(theday::T) where {T <: LiturgicalDay}
    @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
    nothing
end

function readings(theday::T, yr::Char; as_urn = false) where {T <: LiturgicalDay}
    if theday isa PrincipalFeast
        feastreadings(theday, yr; as_urn = as_urn)

    elseif theday isa Sunday
        sundayreadings(theday, yr; as_urn = as_urn)

    else
        @warn("Function civildate not implmented for LiturgicalDay type $(typeof(theday))")
        nothing
    end
end



