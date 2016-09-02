
-- Documentation for various functions can be found in the file utf8.lua

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

function string.split(self, separator)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    assert(type(separator) == "string", "expected string at argument 2, got ".. type(separator))

    local rows = {}
    local position, startpoint = false, 1
    local sepLength = separator:len()

    repeat
        position = self:find(separator, startpoint, true)
        local part = self:sub(startpoint, position and (position - 1) or nil)
        startpoint = position and (position + sepLength)

        if part ~= "" then
            rows[#rows + 1] = part
        end
    until not position

    return rows
end

function string.startsWith(self, token)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    assert(type(token) == "string", "expected string at argument 2, got ".. type(token))
    return token ~= "" and self:sub(1, token:len()) == token
end

function string.endsWith(self, token)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    assert(type(token) == "string", "expected string at argument 2, got ".. type(token))
    return token == "" or self:sub(-token:len()) == token
end

function string.trim(self)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    local from = self:match("^%s*()")
    return from > self:len() and "" or self:match(".*%S", from)
end
