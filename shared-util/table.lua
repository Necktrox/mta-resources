
local table = table
local assert = assert
local pairs = pairs
local type = type

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

function table.size(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local size = 0

    for _ in pairs(self) do
        size = size + 1
    end

    return size
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

    return self
end

function table.each(self, callback)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(callback) == "function", "expected function at argument 2, got ".. type(callback))

    for key, value in pairs(self) do
        callback(key, value)
    end

    return self
end

function table.merge(self, other)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(other) == "table", "expected table at argument 2, got ".. type(other))

    for key, value in pairs(other) do
        if self[key] == nil then
            self[key] = value
        end
    end

    return self
end

function table.merge_insert(self, other)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(type(other) == "table", "expected table at argument 2, got ".. type(other))

    local length = #self

    for index = 1, #other do
        self[length + index] = other[index]
    end

    return self
end

function table.removevalue(self, value)
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
                self[index] = nil
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

function table.deletevalue(self, value)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    assert(value ~= nil, "expected any value at argument 2, got nil")

    for key, data in pairs(self) do
        if data == value then
            self[key] = nil
            return key
        end
    end

    return false
end

function table.random(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))
    return self[math.random(#self)]
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
        packed[length] = { key, value }
        length = length + 1
        self[key] = nil
    end

    for index = 1, length do
        self[index] = packed[index]
    end

    return self
end

function table.reverse(self)
    assert(type(self) == "table", "expected table at argument 1, got ".. type(self))

    local length = #self

    for index = 1, length do
        self[index] = self[length - (index - 1)]
    end

    return self
end
