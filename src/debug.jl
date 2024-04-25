
function calcheck(lityr::LiturgicalYear = LiturgicalYear())
    sundaylist = pentecost_season(lityr)[2:end]

    epiph_cf = epiphany_sundays(lityr)
    @info("Easter $(easter_sunday(lityr) |> civildate)")
    @info("$(length(epiph_cf)) Sundays after Epiphany") 
    @info("Ash Wednesday $(ash_wednesday_date(lityr))")
    @info("Ascension Day $(ascension(lityr))")
    @info("Pentencost $(pentecost_day(lityr) |> civildate)")
    
    @info("$(length(sundaylist)) Sundays in ordinary time")

    @info("$(epiph_cf)")
end