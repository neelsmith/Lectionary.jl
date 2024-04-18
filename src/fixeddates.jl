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
    fixeddate(fd, yr) |> dayname
end

# The principal feasts with fixed dates:
const CHRISTMAS_DATE = FixedDate(12,25)
const ALL_SAINTS_DATE = FixedDate(11,1)
const EPIPHANY_DATE = FixedDate(1,6)


# Major feasts that take precedence over Sundays:
const HOLY_NAME_DATE = FixedDate(1,1)
const PRESENTATION_DATE = FixedDate(2,2)
const TRANSFIGURATION_DATE = FixedDate(8,6)






function christmasday(yr::Int)
    dayofweek(CHRISTMAS_DATE, yr)
end