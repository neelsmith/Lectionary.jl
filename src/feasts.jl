
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
    FEAST_TRINITY => "Trinity Sunday",FEAST_ALL_SAINTS => "All Saints' Day",
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

function isfixed(pdf::PrincipalFeast)
    pdf.feastid in [FEAST_ALL_SAINTS, FEAST_CHRISTMAS, FEAST_EPIPHANY]
end
