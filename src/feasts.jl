
const FEAST_EASTER = 1
const FEAST_ASCENSION = 2
const FEAST_PENTECOST = 3
const FEAST_TRINITY = 4
const FEAST_ALL_SAINTS = 5
const FEAST_CHRISTMAS = 6
const FEAST_EPIPHANY = 7

const feast_names = Dict(
    FEAST_EASTER => "Easter Day",
    FEAST_ASCENSION => "Ascension Day",
    FEAST_PENTECOST => "The Day of Pentecost",
    FEAST_TRINITY => "Trinity Sunday",
    
    # Fixed dates:
    FEAST_ALL_SAINTS => "All Saints' Day",
    FEAST_CHRISTMAS => "Christmas Day",
    FEAST_EPIPHANY => "The Epiphany"
)

struct PrincipalFeast <: LiturgicalDay
    feastid::Int
    yr::Int
end

function name(pf::PrincipalFeast)
    feast_names[pf.feastid]
end


"""True if principal feast has a fixed date.
$(SIGNATURES)
"""
function isfixed(pf::PrincipalFeast)
    pf.feastid in [FEAST_ALL_SAINTS, FEAST_CHRISTMAS, FEAST_EPIPHANY]
end

function civildate(pf::PrincipalFeast)
    if pf.feastid == FEAST_CHRISTMAS
        caldate(CHRISTMAS_DATE, pf.yr)
    elseif pf.feastid == FEAST_EPIPHANY
        caldate(EPIPHANY_DATE, pf.yr)
    elseif pf.feastid == FEAST_ALL_SAINTS
        caldate(ALL_SAINTS_DATE, pf.yr)
    elseif pf.feastid == FEAST_EASTER
        easter_sunday(pf.yr) |> civildate
    elseif pf.feastid == FEAST_ASCENSION
        ascension(pf.yr)
    elseif pf.feastid == FEAST_PENTECOST
        pentecost(pf.yr).dt
    elseif pf.feastid == FEAST_TRINITY
        trinity(pf.yr).dt
    else
        @warn("Not yet imlemented...")
        nothing
    end
end