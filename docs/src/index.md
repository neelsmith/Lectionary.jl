# `Lectionary.jl`: API documentation


## The liturgical year


```@docs
LiturgicalYear
date_range
lectionary_year
daily_office_year
```


## Liturgical days

Types:


```
LiturgicalDay
Sunday

OtherDay
```

```@docs
Feast
```

Functions:


```@docs
name
civildate
weekday
readings
priority
kalendar
```


# HolyDay


export LiturgicalYear, lectionary_year, daily_office_year
export sundays, principal_feasts, holy_days
export liturgical_year, liturgical_day, date_range

export advent, christmas, christmas_day
export advent_sundays
export epiphany_sundays
export easter_sunday
export ash_wednesday, lent, palm_sunday, eastertide
export lent_season, easter_season
export ascension
export pentecost, trinity, pentecost_season
export thanksgiving

export Reading, readings, ot, nt, psalm, gospel