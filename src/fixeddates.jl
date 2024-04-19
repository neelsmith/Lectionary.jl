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

fixed_dates = Dict(
    # The principal feasts with fixed dates:
    FEAST_CHRISTMAS => FixedDate(12,25),
    FEAST_ALL_SAINTS => FixedDate(11,1),
    FEAST_EPIPHANY => FixedDate(1,6),
    # Major feasts that take precedence over Sundays:
    FEAST_HOLY_NAME => FixedDate(1,1),
    FEAST_PRESENTATION => FixedDate(2,2),
    FEAST_TRANSFIGURATION => FixedDate(8,6)

)



