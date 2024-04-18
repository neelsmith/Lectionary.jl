struct FixedDate
    month::Int
    day::Int
end

function month(fd::FixedDate)
    fd.month
end

function day(fd::FixedDate)
    fd.day
end

function fixeddate(fd::FixedDate, yr::Int)
    Date(yr, month(fd), day(fd))
end

function dayofweek(fd::FixedDate, yr::Int)
    fixeddate(fd, yr) |> dayname
end



const CHRISTMAS_DATE = FixedDate(12,25)
function christmasday(yr::Int)
    dayofweek(CHRISTMAS_DATE, yr)
end