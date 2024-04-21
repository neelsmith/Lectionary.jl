@testset "Test lectionary year and functions" begin
    liturgicalyear = LiturgicalYear(1977)
    @test liturgicalyear.ends_in == 1978

    @test lectionary_year(1977) == 'A'
    @test lectionary_year(liturgicalyear) == 'A'

    kal = kalendar(liturgicalyear)
    @test kal isa Vector{LiturgicalDay}
end