

struct HolyDay <: LiturgicalDay
    name::String

end

function name(hd::HolyDay)
    hd.name
end

