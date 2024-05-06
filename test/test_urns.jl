@testsuite "Test URN conversion" begin
   
    #=
julia> epiph = epiphany_day()
The Epiphany in 2024

julia> Lectionary.feastreadings(epiph, 'B')
Readings("Isaiah 60.1-60.6", "Ephesians 3.1-3.12", "Matthew 2.1-2.12", "Psalm 72.1-72.7, Psalm 72.10-72.14")

julia> Lectionary.feastreadings(epiph, 'B'; urns = true)
┌ Warning: Support for URN references not implemented yet.
└ @ Lectionary ~/Desktop/Lectionary.jl/src/commemorations.jl:226
Readings("Isaiah 60.1-60.6", "Ephesians 3.1-3.12", "Matthew 2.1-2.12", "Psalm 72.1-72.7, Psalm 72.10-72.14")
    =#

    #=
    julia> reading1(epiph)
1-element Vector{Vector{String}}:
 ["Isaiah 60.1-60.6"]

julia> reading1(epiph; urns = true)
ERROR: MethodError: Cannot `convert` an object of type CtsUrn to an object of type String
    =#
end