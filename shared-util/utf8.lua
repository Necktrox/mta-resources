
function utf8.split(self, separator)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    assert(type(separator) == "string", "expected string at argument 2, got ".. type(separator))

    local rows = {}
    local position, startpoint = false, 1
    local sepLength = utf8.len(separator)

    repeat
        -- 1) Search for the separator string (beginning from position startpoint)
        position = utf8.find(self, separator, startpoint, true)

        -- 2) Substring the string beginning from the startpoint
        -- a) to the position of the separator
        -- b) to the end of the string
        local part = utf8.sub(self, startpoint, position and (position - 1) or nil)

        -- 3) Overwrite startpoint with the position after the separator
        startpoint = position and (position + sepLength)

        -- 4) Check if substring is empty 
        if part ~= "" then
            rows[#rows + 1] = part
        end
    until not position

    return rows
end

function utf8.startsWith(self, token)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    assert(type(token) == "string", "expected string at argument 2, got ".. type(token))
    -- 1a) Compare token against an empty string to check if it's empty
    -- 1b) Take the substring from index 1 to the length of the token
    --     and compare the substring to the token string
    return token ~= "" and utf8.sub(self, 1, utf8.len(token)) == token
end

function utf8.endsWith(self, token)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    assert(type(token) == "string", "expected string at argument 2, got ".. type(token))
    -- 1a) Compare token against an empty string to check if it's empty
    -- 1b) Compare the token with the substring from the last (utf8.len(token)) characters in the string
    --     (a negative offset will subtract the number from the length of the string)
    return token == "" or utf8.sub(self, -utf8.len(token)) == token
end

function utf8.trim(self)
    assert(type(self) == "string", "expected string at argument 1, got ".. type(self))
    -- 1) Match position of first non-whitespace character
    local from = utf8.match(self, "^%s*()")
    -- 2) Compare position to the length of the string (might be beyond the length of the string itself)
    -- 3a) Return an empty string, because the string only contains whitespace characters
    -- 3b) Otherwise return the match of the string to the point before it hits a whitespace character,
    --     beginning from the position of the first match to skip the whitespace in front
    return from > utf8.len(self) and "" or utf8.match(self, ".*%S", from)
end
