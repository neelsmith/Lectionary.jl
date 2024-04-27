
@testset "Test computation of dates in civil calendar in regular year" begin
    # Calendar year 2023 was a normal year, so test dates in liturgical year
    # 2022-2023.

    lityr = LiturgicalYear(2022)
    
    # Expected values taken from https://www.lectionarypage.net/CalndrsIndexes/Calendar2023.html:
    
    @test civildate(easter_sunday(lityr))  == Date(2023,4,9)
    @test ash_wednesday_date(lityr) == Date(2023,2,22)
    @test ascension(lityr) == Date(2023, 5, 18)
    @test civildate(pentecost_day(lityr)) == Date(2023,5,28)
    @test civildate(advent(1, lityr.ends_in)) == Date(2023, 12, 3)
end

@testset "Test computation of dates in civil calendar in leap year" begin
    # Calendar year 2024 was a leap year, test dates in liturgical year
    # 2023-2024.
    
    lityr = LiturgicalYear(2023)
    
    # Expected values taken from https://www.lectionarypage.net/CalndrsIndexes/Calendar2024.html:
     
     @test civildate(easter_sunday(lityr))  == Date(2024,3,31)
     @test ash_wednesday_date(lityr) == Date(2024,2,14)
     @test ascension(lityr) == Date(2024, 5, 9)
     @test civildate(pentecost_day(lityr)) == Date(2024,5,19)
     @test civildate(advent(1, lityr.ends_in)) == Date(2024, 12, 1)
end