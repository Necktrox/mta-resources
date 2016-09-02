
function table.flip(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local copy = {}

    for key, value in pairs(self) do
        copy[value] = key
        self[key] = nil
    end

    for key, value in pairs(copy) do
        self[key] = value
    end

    return self
end

function table.keys(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local keys = {}

    for key in pairs(self) do
        keys[#keys + 1] = key
    end

    return keys
end

function table.values(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local values = {}
    local index = 1

    for key, value in pairs(self) do
        values[index] = value
        index = index + 1
    end

    return values
end

function table.size(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local index = next(self)
    local size = 0

    while index ~= nil do
        size = size + 1
        index = next(self, index)
    end

    return size
end

function table.empty(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    return next(self) == nil
end

function table.map(self, callback, ...)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(callback) == "function", "expected function at argument 2, got ".. type(callback))

    for key, value in pairs(self) do
        self[key] = callback(value, ...)
    end

    return self
end

function table.maptry(self, callback, ...)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(callback) == "function", "expected function at argument 2, got ".. type(callback))

    for key, value in pairs(self) do
        self[key] = callback(value, ...)

        if not self[key] then
            return false
        end
    end

    return true
end

function table.each(self, callback, ...)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(callback) == "function", "expected function at argument 2, got ".. type(callback))

    for key, value in pairs(self) do
        callback(key, value, ...)
    end

    return self
end

function table.valueach(self, callback, ...)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(callback) == "function", "expected function at argument 2, got ".. type(callback))

    for key, value in pairs(self) do
        callback(value, ...)
    end

    return self
end

function table.eachtry(self, callback, ...)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(callback) == "function", "expected function at argument 2, got ".. type(callback))

    for key, value in pairs(self) do
        if not callback(key, value, ...) then
            return false
        end
    end

    return true
end

function table.merge(self, other, overwrite)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(other) == "table", "expected table at argument 2, got ".. type(other))
    assert(overwrite == nil or type(overwrite) == "boolean", "expected boolean at argument 3, got ".. type(overwrite))

    for key, value in pairs(other) do
        if overwrite or self[key] == nil then
            self[key] = value
        end
    end

    return self
end

function table.insert(self, other)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(other) == "table", "expected table at argument 2, got ".. type(other))

    local length = #self

    for index = 1, #other do
        self[length + index] = other[index]
    end

    return self
end

function table.skipvalue(self, value)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(value ~= nil, "expected any value at argument 2, got nil")

    local found = false
    local collapse = false
    local length = #self

    for index = 1, length do
        if collapse then
            self[index - 1] = self[index]
        else
            if self[index] == value then
                found = index
                collapse = true
            end
        end
    end

    if collapse then
        self[length] = nil
    end

    return found
end

function table.unsetvalue(self, value)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(value ~= nil, "expected any value at argument 2, got nil")

    for key, data in pairs(self) do
        if data == value then
            self[key] = nil
        end
    end
end

function table.random(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    local length = #self
    return length > 0 and self[math.random(length)] or nil
end

function table.copy(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local references = {}

    local function deepcopy(self)
        local copy = {}

        for key, value in pairs(self) do
            if type(value) == "table" then
                if references[value] == nil then
                    references[value] = deepcopy(value)
                end
                copy[key] = references[value]
            else
                copy[key] = value
            end
        end

        return copy
    end

    return deepcopy(self)
end

function table.shuffle(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local length = #self

    if length > 1 then
        for index = 1, length do
            local pos = math.random(length)
            self[index], self[pos] = self[pos], self[index]
        end
    end

    return self
end

function table.pack(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local packed = {}
    local length = 0

    for key, value in pairs(self) do
        length = length + 1
        packed[length] = { key, value }
        self[key] = nil
    end

    for index = 1, length do
        self[index] = packed[index]
    end

    return self
end

function table.unpack(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local length = #self

    if length == 0 then
        return self
    end

    local unpacked = {}

    for index = 1, length do
        unpacked[self[index][1]] = self[index][2]
        self[index] = nil
    end

    for key, value in pairs(unpacked) do
        self[key] = value
    end

    return self
end

function table.reverse(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local length = #self

    if length < 2 then
        return self
    end

    for index = 1, length / 2 do
        local other = length - (index - 1)
        self[index], self[other] = self[other], self[index]
    end

    return self
end

function table.destroy(self, depth)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(depth == nil or type(depth) == "number", "expected number at argument 2, got ".. type(depth))

    for key, value in pairs(self) do
        if type(value) == "table" and depth ~= nil and depth > 0 then
            table.destroy(value, depth - 1)
        end
        
        self[key] = nil
    end

    return self
end

local function isKeyValuePairJSONCompatible(key_t, value_t)
    return (key_t == "boolean" or key_t == "number" or key_t == "string")
        and (value_t == "boolean" or value_t == "number" or value_t == "string" or value_t == "table") 
end

function table.raw(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local references = {}

    local function recursive(self)
        for key, value in pairs(self) do
            local key_t = type(key)
            local value_t = type(value)

            if isKeyValuePairJSONCompatible(key_t, value_t) then
                if value_t == "table" then
                    -- Recursive
                    if references[key] == nil then
                        references[key] = recursive(value)
                    end

                    self[key] = references[key]
                else
                    self[key] = value
                end
            else
                self[key] = nil
            end
        end

        return self
    end

    return recursive(self)
end

function table.rawcopy(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local references = {}

    local function recursive(self)
        local copy = {}

        for key, value in pairs(self) do
            local key_t = type(key)
            local value_t = type(value)

            if isKeyValuePairJSONCompatible(key_t, value_t) then
                if value_t == "table" then
                    -- Recursive
                    if references[key] == nil then
                        references[key] = recursive(value)
                    end

                    copy[key] = references[key]
                else
                    copy[key] = value
                end
            end
        end

        return copy
    end

    return recursive(self)
end

function table.json(self, compact)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(compact == nil or type(compact) == "boolean", "expected boolean at argument 2, got ".. type(compact))
    -- 1) Create a copy of the table with discarded JSON-incompatible properties
    -- 2) Convert this copy of table to a JSON string
    -- 3) Remove the array brackets around the JSON object (and the spaces when compact is off)
    return toJSON(table.rawcopy(self), compact):sub(compact and 2 or 3, compact and -2 or -3)
end
