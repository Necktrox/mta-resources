
function File.getMD5Hash(filepath)
    assert(type(filepath) == "string", "expected string at argument 1, got ".. type(filepath))
    local handle = File(filepath, true)

    if not handle then
        return false
    end

    local buffer = ""

    repeat
        -- Note: A high amount of read-in bytes doesn't make this faster
        buffer = hash("md5", buffer .. handle:read(1024))
    until handle.isEOF

    handle:close()

    return buffer
end
