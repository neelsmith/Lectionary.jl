
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
    urnlist = CtsUrn[]
    #for rdg in readings()
    for rdg in rlist
        for psgvect in reading1(rdg)
            for psg in psgvect
                tidied = replace(psg, r"^([1-9]) " => s"\1_")
                (bk, ref) = split(tidied)
                ctsu = string(BASE_CTS_URN,".",lowercase(bk),":",ref) |> CtsUrn
                push!(urnlist, ctsu)
            end
        end
    end
    urnlist
end