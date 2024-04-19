# Categories of priority:
const PRINCIPAL_FEAST = 1
const HOLY_DAY_1 = 2
const SUNDAY = 3
const HOLY_DAY_2 = 4
const LESSER_FEAST = 5 # Not yet implemented
const OTHER_DAY = 6


# Principal feasts
const FEAST_EASTER = 1
const FEAST_ASCENSION = 2
const FEAST_PENTECOST = 3
const FEAST_TRINITY = 4
const FEAST_ALL_SAINTS = 5
const FEAST_CHRISTMAS = 6
const FEAST_EPIPHANY = 7
# HOLY_DAY_1
const FEAST_HOLY_NAME = 9
const FEAST_PRESENTATION = 10
const FEAST_TRANSFIGURATION = 11
# HOLY_DAY_2
const FEAST_ANNUNCIATION = 12
const FEAST_VISITATION = 13
const FEAST_SAINT_JOHN = 14
const FEAST_HOLY_CROSS = 15
const FEAST_SAINT_STEPHEN = 16
const FEAST_HOLY_INNOCENTS = 17
const FEAST_SAINT_JOSEPH = 18
const FEAST_MARY_MAGDALENE = 19
const FEAST_MARY_THE_VIRGIN = 20
const FEAST_MICHAEL_AND_ALL_ANGELS = 21
const FEAST_SAINT_JAMES_JERUSALEM = 22
const FEAST_INDEPENDENCE_DAY = 23
const FEAST_THANKSGIVING_DAY = 24
const FEAST_CONFESSION_OF_PETER = 25
const FEAST_CONVERSION_OF_PAUL = 26
const FEAST_SAINT_MATTHIAS = 27
const FEAST_SAINT_MARK = 28 
const FEAST_SAINTS_PHILIP_AND_JAMES = 29
const FEAST_SAINT_BARNABAS = 30
const FEAST_SAINT_JOHN_BAPTIST = 31
const FEAST_SAINT_JAMES_APOSTLE = 32
const FEAST_SAINT_BARTHOLOMEW = 33
const FEAST_SAINT_MATTHEW = 34
const FEAST_SAINT_LUKE = 35
const FEAST_SAINTS_SIMON_AND_JUDE = 36
const FEAST_SAINT_ANDREW = 37
const FEAST_SAINT_THOMAS = 39

const PRINCIPAL_FEASTS = [
    FEAST_EASTER, FEAST_ASCENSION, FEAST_PENTECOST, FEAST_TRINITY,
    FEAST_ALL_SAINTS, FEAST_CHRISTMAS, FEAST_EPIPHANY
]

const HOLY_DAYS_1 = [
    FEAST_HOLY_NAME, FEAST_PRESENTATION, FEAST_TRANSFIGURATION
]

const HOLY_DAYS_2 = [
    FEAST_ANNUNCIATION, FEAST_VISITATION, FEAST_SAINT_JOHN, FEAST_HOLY_CROSS, FEAST_SAINT_STEPHEN, FEAST_HOLY_INNOCENTS, FEAST_SAINT_JOSEPH, FEAST_MARY_MAGDALENE, FEAST_MARY_THE_VIRGIN, FEAST_MICHAEL_AND_ALL_ANGELS, FEAST_SAINT_JAMES_JERUSALEM,FEAST_INDEPENDENCE_DAY, FEAST_THANKSGIVING_DAY, FEAST_CONFESSION_OF_PETER,FEAST_CONVERSION_OF_PAUL, FEAST_SAINT_MATTHIAS,FEAST_SAINT_MARK, FEAST_SAINTS_PHILIP_AND_JAMES,FEAST_SAINT_BARNABAS,FEAST_SAINT_JOHN_BAPTIST,FEAST_SAINT_JAMES_APOSTLE, FEAST_SAINT_BARTHOLOMEW, FEAST_SAINT_MATTHEW,FEAST_SAINT_LUKE, FEAST_SAINTS_SIMON_AND_JUDE,FEAST_SAINT_ANDREW, FEAST_SAINT_THOMAS
]

const feast_names = Dict(
    # principal feasts: movable
    FEAST_EASTER => "Easter Day",
    FEAST_ASCENSION => "Ascension Day",
    FEAST_PENTECOST => "The Day of Pentecost",
    FEAST_TRINITY => "Trinity Sunday",
    
    # principal feasts: fixed dates:
    FEAST_ALL_SAINTS => "All Saints' Day",
    FEAST_CHRISTMAS => "Christmas Day",
    FEAST_EPIPHANY => "The Epiphany",
    FEAST_HOLY_NAME => "The Holy Name",
    FEAST_PRESENTATION => "The Presentation",
    FEAST_TRANSFIGURATION => "The Transfiguration",
    FEAST_ANNUNCIATION => "The Annunciation",
    FEAST_VISITATION => "The Visitation",
    FEAST_SAINT_JOHN => "Saint John Apostle and Evangelist",
    FEAST_SAINT_JOHN_BAPTIST => "Saint John the Baptist",
    FEAST_HOLY_CROSS => "Holy Cross Day",
    FEAST_MARY_THE_VIRGIN => "Saint Mary the Virgin",
    FEAST_MICHAEL_AND_ALL_ANGELS => "Saint Michael and All Angels",
    FEAST_INDEPENDENCE_DAY => "Independence Day",
    FEAST_THANKSGIVING_DAY => "Thanksgiving Day",
    FEAST_SAINT_JAMES_JERUSALEM => "Saint James of Jersualem",
    FEAST_HOLY_INNOCENTS => "The Holy Innocents",
    FEAST_SAINT_STEPHEN => "Saint Stephen",
    FEAST_MARY_MAGDALENE => "Saint Mary Magdalene",
    FEAST_SAINT_JOSEPH => "Saint Joseph",
    FEAST_CONFESSION_OF_PETER => "The Confession of Saint Peter the Apostle",
    FEAST_CONVERSION_OF_PAUL => "The Conversion of Saint Paul the Apostle",
    FEAST_SAINT_MATTHIAS => "Saint Matthias the Apostle",
    FEAST_SAINT_MARK => "Saint Mark the Evangelist",
    FEAST_SAINTS_PHILIP_AND_JAMES => "Saint Philip and Saint James, Apostles",
    FEAST_SAINT_BARNABAS => "Saint Barnabas the Apostle",
    FEAST_SAINT_JAMES_APOSTLE => "Saint James the Apostle",
    FEAST_SAINT_BARTHOLOMEW => "Saint Bartholomew the Apostle",
    FEAST_SAINT_MATTHEW => "Saint Matthew, Apostle and Evangelist",
    FEAST_SAINT_LUKE => "Saint Luke the Evangelist",
    FEAST_SAINTS_SIMON_AND_JUDE => "Saint Simon and Saint Jude, Apostles",
    FEAST_SAINT_ANDREW => "Saint Andrew the Apostle",
    FEAST_SAINT_THOMAS => "Saint Thomas the Apostle"
)

const MOVABLE = [
    FEAST_EASTER, FEAST_ASCENSION, FEAST_PENTECOST,
    FEAST_TRINITY, FEAST_THANKSGIVING_DAY
]