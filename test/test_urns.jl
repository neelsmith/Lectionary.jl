@testset "Test URN conversions with reading functions" begin
    expected1 = "Isaiah 60.1-60.6"
    expectedurn1 = CtsUrn("urn:cts:compnov:bible.isaiah:60.1-60.6")
    @test expectedurn1 == as_urn(expected1)

    epiph = epiphany_day(LiturgicalYear(2023))    
    @test reading1(epiph) == [[expected1]]
    @test_broken reading1(epiph, urns = true) == [[expectedurn1]]

    @test reading1(readings(epiph)) == [[expected1]]
    @test reading1(readings(epiph), urns = true) == [[expectedurn1]]


    expected2 = "Ephesians 3.1-3.12"
    expectedurn2 = CtsUrn("urn:cts:compnov:bible.ephesians:3.1-3.12")
    @test expectedurn2 == as_urn(expected2)

    @test reading2(epiph) == [[expected2]]
    @test_broken reading2(epiph, urns = true) == [[expectedurn2]]

    @test reading2(readings(epiph)) == [[expected2]]
    @test reading2(readings(epiph), urns = true) == [[expectedurn2]]


    expectedgospel = "Matthew 2.1-2.12"
    expectedgospelurn = CtsUrn("urn:cts:compnov:bible.matthew:2.1-2.12")
    @test expectedgospelurn == as_urn(expectedgospel)

    @test gospel(epiph) == [[expectedgospel]]
    @test_broken gospel(epiph, urns = true) == [[expectedgospelurn]]

    @test gospel(readings(epiph)) == [[expectedgospel]]
    @test gospel(readings(epiph), urns = true) == [[expectedgospelurn]]

    expectedpsalms = ["Psalm 72.1-72.7", "Psalm 72.10-72.14"]
    expectedpsalmurns = [CtsUrn("urn:cts:compnov:bible.psalms:72.1-72.7"), CtsUrn("urn:cts:compnov:bible.psalms:72.10-72.14")]
    
    @test psalm(epiph) == [expectedpsalms]
    @test_broken psalm(epiph, urns = true) == [expectedpsalmurns]

    @test psalm(readings(epiph)) == [expectedpsalms]
    @test psalm(readings(epiph), urns = true) == [expectedpsalmurns]

    
end