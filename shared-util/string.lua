
function string:getMemoryAddress()
    return self:match("(0x[a-fA-F0-9]+)")
end

function string:stripColorCodes()
    return self:gsub("#%x%x%x%x%x%x", "")
end

function string:json()
    return toJSON(self)
end

function string.s(number)
    assert(type(number) == "number", "expected number at argument 1, got ".. type(number))
    return (number ~= 1) and "s" or ""
end

function string.es(number)
    assert(type(number) == "number", "expected number at argument 1, got ".. type(number))
    return (number ~= 1) and "es" or ""
end
