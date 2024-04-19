@testset "Test seasons functions" begin
    @test christmas_day(2023) |> weekday == "Monday"

    @test advent(1,2023) == Lectionary.Sunday(Date(2023,12,3), Lectionary.ADVENT_1)
    @test advent(2,2023) == Lectionary.Sunday(Date(2023,12,10), Lectionary.ADVENT_2)
    @test advent(3,2023) == Lectionary.Sunday(Date(2023,12,17), Lectionary.ADVENT_3)
    @test advent(4,2023) == Lectionary.Sunday(Date(2023,12,24), Lectionary.ADVENT_4)


    
end