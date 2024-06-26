
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
    hw = holy_week(lityr)
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
        println("===> On  day $(dt): $(rdg)\n")

    end
    failed
end

function debugpropers(lityr::LiturgicalYear = LiturgicalYear())
    for sday in pentecost_season()
        println("++ $(sday) : $(readings(sday))")
        println("")
        
    end
end


function viewyear(lityr::LiturgicalYear = LiturgicalYear())
    for theday in kalendar(lityr)
        msg = string(civildate(theday), ": ", theday)
        println(msg)
    end
end





function get_urns(rlist)
    rdgslist = []
    
    for rdg in rlist
        record = []
        push!(record, reading1(rdg, urns = true))
        push!(record, reading2(rdg, urns = true))
        push!(record, gospel(rdg, urns = true))
        push!(record, psalm(rdg, urns = true))
        push!(rdgslist, record)
    end
    rdgslist
end