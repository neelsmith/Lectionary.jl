@testset "Test correct formation of feast days in the RCL calendar" begin
    ly = LiturgicalYear(2023)
    # Dates for testing taken from:
    # https://www.lectionarypage.net/CalndrsIndexes/Calendar2023.html
    # https://www.lectionarypage.net/CalndrsIndexes/Calendar2024.html

    @test civildate(advent(1, ly)) == Date(2023, 12,3)
    @test civildate(christmas(1, ly)) == Date(2023, 12,31)

    @test civildate(epiphany(1, ly)) == Date(2024, 1, 7)
    @test civildate(ash_wednesday(ly)) == Date(2024,2,14)
    @test civildate(lent(1, ly)) == Date(2024,2,18)
    @test civildate(palm_sunday(ly)) == Date(2024,3,24)
    @test civildate(easter_sunday(ly)) == Date(2024,3,31)
    @test civildate(pentecost_day(ly)) == Date(2024, 5, 19)
    @test civildate(trinity()) == Date(2024, 5, 26)
    @test civildate(pentecost(2, ly)) == Date(2024, 6, 2)
    @test civildate(pentecost(27, ly)) == Date(2024, 11, 24)

    # Special days
    @test civildate(Commemoration(Lectionary.FEAST_PRESENTATION, ly)) == Date(2024,2,2)

    @test civildate(Commemoration(Lectionary.FEAST_ASCENSION,ly)) == Date(2024,5,9)

    @test civildate(Commemoration(Lectionary.FEAST_THANKSGIVING_DAY, ly))  == Date(2024, 11, 28)

    @test civildate(Commemoration(Lectionary.HOLY_WEEK_MONDAY, ly)) == Date(2024, 3, 25)
    @test civildate(Commemoration(Lectionary.HOLY_WEEK_TUESDAY, ly)) == Date(2024, 3, 26)
    @test civildate(Commemoration(Lectionary.HOLY_WEEK_WEDNESDAY, ly)) == Date(2024, 3, 27)

    @test civildate(Commemoration(Lectionary.MAUNDY_THURSDAY, ly)) == Date(2024, 3, 28)

    @test civildate(Commemoration(Lectionary.FAST_GOOD_FRIDAY, ly)) == Date(2024, 3, 29)

    @test civildate(Commemoration(Lectionary.HOLY_SATURDAY, ly)) == Date(2024, 3, 30)

    # Test this in a year where it doesn't collide with a Sunday:
    @test civildate(Commemoration(Lectionary.FEAST_ANNUNCIATION, LiturgicalYear(2022))) == Date(2023,3,25)
end