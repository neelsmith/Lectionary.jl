
function calcheck(lityr::LiturgicalYear = LiturgicalYear())
    

    epiph_cf = epiphany_sundays(lityr)
    @info("Easter $(easter_sunday(lityr) |> civildate)")
    @info("$(length(epiph_cf)) Sundays after Epiphany") 
    @info("Ash Wednesday $(ash_wednesday_date(lityr))")
    @info("Ascension Day $(ascension(lityr))")
    @info("Pentencost $(pentecost_day(lityr) |> civildate)")
    
    sundaylist = pentecost_season(lityr)[2:end]
    @info("$(length(sundaylist)) Sundays in ordinary time")
    @info("Advent 1 of next year: $(civildate(advent(1, lityr.ends_in)))")
    
end

function debughw(lityr::LiturgicalYear = LiturgicalYear())
    hw = holyweek(lityr)
    @info(hw)
    eastersun = easter_sunday(lityr)
    @info("Easter is $(eastersun)")
    @info("add one: $(civildate(eastersun) + Dates.Day(1))")
    #datelist = civildate.(hw)
end


function debugreadings(lityr::LiturgicalYear = LiturgicalYear())
    kal = kalendar(lityr)
    failed = []
    for dt in kal
        rdg = readings(dt, lityr)
        if isnothing(rdg)
            push!(failed, dt)
        end
        println("===> On  day $(dt): $(rdg)")
    end
    failed
end