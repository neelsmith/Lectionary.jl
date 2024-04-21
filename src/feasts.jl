

"""A feast other than a regular Sunday in the liturgical year.

**Examples**
```julia-repl
julia> Feast(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> Feast(Lectionary.FEAST_PENTECOST, 2025)
The Day of Pentecost, June 1, 2025
```
"""
struct Feast <: LiturgicalDay
    feastid::Int
    yr::Int
end


"""Construct a `Feast` day.

"""
function Feast(feastid::Int, ly::LiturgicalYear = LiturgicalYear())
    if feastid in YEAR1_FEASTS
        Feast(feastid, ly.starts_in) 
    else
        Feast(feastid, ly.ends_in)
    end
end

"""Override `Base.==` for `Feast`.
$(SIGNATURES)
"""
function ==(f1::Feast, f2::Feast)
    f1.feastid == f2.feastid &&
    f1.yr == f2.yr
end

"""Override `Base.show` for type `Feast`.
$(SIGNATURES)
"""
function show(io::IO, fst::Feast)
    
    nm = name(fst)
    dt = civildate(fst)
    if isnothing(dt)
       write(io, string(nm, " (no date)"))
    else
        formatteddate = string(monthname(dt), " ",  dayofmonth(dt), ", ", year(dt))
        write(io, nm * ", " * formatteddate)
    end
    
    #write(io, string("Feast ",fst.feastid))
end

"""Name of feast.

**Example**
```julia-repl
julia> fst = Feast(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> name(fst)
"The Day of Pentecost"
```
$(SIGNATURES)
"""
function name(fst::Feast)
    haskey(feast_names, fst.feastid) ? feast_names[fst.feastid] : string(fst)
end

"""Priority of feast. Lower values override 
higher values in determining which of two sets
of readings to prefer.
$(SIGNATURES)
"""
function priority(fst::Feast)
    if fst.feastid in PRINCIPAL_FEASTS
        PRINCIPAL_FEAST
    elseif fst.feastid in HOLY_DAYS_1
        HOLY_DAY_1
    elseif fst.feastid in HOLY_DAYS_2
        HOLY_DAY_2

    else
        OTHER_DAY
    end
end

"""True if feast is movable.
$(SIGNATURES)
"""
function ismovable(fst::Feast)
    fst.feastid in MOVABLE
end

"""Date in civil calendar of movable feast.
$(SIGNATURES)
"""
function movabledate(fst::Feast)
    if fst.feastid == FEAST_EASTER
        easter_sunday(fst.yr) |> civildate
    elseif fst.feastid == FEAST_ASCENSION
        ascension(fst.yr)
    elseif fst.feastid == FEAST_PENTECOST
        pentecost(fst.yr).dt
    elseif fst.feastid == FEAST_TRINITY
        trinity(fst.yr).dt
    elseif fst.feastid == FEAST_THANKSGIVING_DAY
        thanksgiving(fst.yr)

    else
        @info("Movable feast not implemented! $(fst)")
        nothing
    end
end

"""Find date in civil calendar for feast.


**Example**
```julia-repl
julia> fst = Feast(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> civildate(fst)
2024-05-19
```
$(SIGNATURES)
"""
function civildate(fst::Feast)
    if ismovable(fst)
        movabledate(fst)

    elseif haskey(fixed_dates,fst.feastid)
        monthday =fixed_dates[fst.feastid]
        Date(fst.yr, calmonth(monthday), calday(monthday))
    else
        @warn("Key not found for fixed date of feast: $(fst)..")
        nothing
    end
end


"""Find name of day of week of feast.


**Example**
```julia-repl
julia> fst = Feast(Lectionary.FEAST_PENTECOST)
The Day of Pentecost, May 19, 2024
julia> weekday(fst)
"Sunday"
```

$(SIGNATURES)
"""
function weekday(fst::Feast)
    civildate(fst) |> dayname
end


"""Find readings for feast.
$(SIGNATURES)
"""
function feastreadings(feast::Feast, lectionaryyr::Char; as_urn = false) 
    if as_urn
        @warn("Support for URN references not implemented yet.")
    end
    if lectionaryyr == 'A'
        if haskey(feastselectionsA, feast.feastid)
            feastselectionsA[feast.feastid]
        else
            @warn("Could not find reading for $(feast) in year $(lectionaryyr)")
            nothing
        end

    elseif lectionaryyr == 'B'
        if haskey(feastselectionsB, feast.feastid)
            feastselectionsB[feast.feastid]
        else
            @warn("Could not find reading for $(feast) in year $(lectionaryyr)")
            nothing
        end
    
    elseif lectionaryyr == 'C'
        if haskey(feastselectionsC, feast.feastid)
            feastselectionsC[feast.feastid]
        else
            @warn("Could not find reading for $(faste) in year $(lectionaryyr)")
            nothing
        end

    else
        @warn("Invalid value for lectionary year: $(lectionaryyr)")
        nothing
    end     
   
end

