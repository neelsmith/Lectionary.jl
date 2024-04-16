@testset "Test seasons functions" begin
    @test christmasday(2023) == "Monday"
    @test advent(1,2023) == Date(2023,12,3)
    @test advent(2,2023) == Date(2023,12,10)
    @test advent(3,2023) == Date(2023,12,17)
    @test advent(4,2023) == Date(2023,12,24)


    
end