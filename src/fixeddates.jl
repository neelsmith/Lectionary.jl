struct FixedDate
    month::Int
    day::Int
end

function calmonth(fd::FixedDate)
    fd.month
end

function calday(fd::FixedDate)
    fd.day
end

function caldate(fd::FixedDate, yr::Int)
    Date(yr, calmonth(fd), calday(fd))
end

function dayofweek(fd::FixedDate, yr::Int)
    caldate(fd, yr) |> dayname
end

const fixed_dates = Dict(
    # The principal feasts with fixed dates:
    FEAST_CHRISTMAS => FixedDate(12,25),
    FEAST_ALL_SAINTS => FixedDate(11,1),
    FEAST_EPIPHANY => FixedDate(1,6),
    # Major feasts that take precedence over Sundays:
    FEAST_HOLY_NAME => FixedDate(1,1),
    FEAST_PRESENTATION => FixedDate(2,2),
    FEAST_CONFESSION_OF_PETER => FixedDate(1,18),
    FEAST_CONVERSION_OF_PAUL => FixedDate(1,25),
    FEAST_SAINT_MATTHIAS => FixedDate(2,24),
    FEAST_SAINT_JOSEPH => FixedDate(3,19),
    FEAST_ANNUNCIATION => FixedDate(3,25),
    FEAST_SAINT_MARK => FixedDate(4,25),
    FEAST_SAINTS_PHILIP_AND_JAMES => FixedDate(5,1),
    FEAST_VISITATION => FixedDate(5,31),
    FEAST_SAINT_BARNABAS => FixedDate(6,11),
    FEAST_SAINT_JOHN_BAPTIST => FixedDate(6,24),
    FEAST_CONFESSION_OF_PETER => FixedDate(6,29),
    FEAST_CONVERSION_OF_PAUL => FixedDate(6,29),

    FEAST_INDEPENDENCE_DAY => FixedDate(7,4),
    FEAST_MARY_MAGDALENE => FixedDate(7,22),
    FEAST_SAINT_JAMES_APOSTLE => FixedDate(7,25),

    FEAST_MARY_THE_VIRGIN => FixedDate(8,15),
    FEAST_SAINT_BARTHOLOMEW => FixedDate(8,24),
    FEAST_HOLY_CROSS => FixedDate(9,14),
    FEAST_SAINT_MATTHEW => FixedDate(9,21),
    FEAST_MICHAEL_AND_ALL_ANGELS => FixedDate(9,29),

    FEAST_SAINT_LUKE => FixedDate(10,18),
    FEAST_SAINT_JAMES_JERUSALEM => FixedDate(10,23),
    FEAST_SAINTS_SIMON_AND_JUDE => FixedDate(10,28),

    FEAST_SAINT_ANDREW => FixedDate(11,30),

    FEAST_SAINT_THOMAS => FixedDate(12,21),
    FEAST_SAINT_STEPHEN => FixedDate(12,26),
    FEAST_SAINT_JOHN => FixedDate(12,27),
    FEAST_HOLY_INNOCENTS => FixedDate(12,28)
)
#=
const FEAST_THANKSGIVING_DAY = 24
=#



