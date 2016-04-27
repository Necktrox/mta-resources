
local Enabled = true
-- local Separator = utf8.escape(" › ")

function debug.enabled()
    return Enabled
end

function debug.toggle(boolean)
    assert(type(boolean) == "boolean", "expected boolean at argument 1, got".. type(boolean))
    Enabled = boolean
end

function debug.print(formatting, ...)
    assert(type(section) == "string", "expected string at argument 1, got ".. type(section))
    assert(type(formatting) == "string", "expected string at argument 2, got ".. type(formatting))

    if not Enabled then
        return
    end

    outputDebugString(formatting:format(...))
end
