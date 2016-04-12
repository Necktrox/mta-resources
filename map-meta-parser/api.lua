
function getMapMeta(map)
    assert(type(map) == "userdata" or type(map) == "string", "expected resource-resolvable at argument 1, got ".. type(map))

    if type(map) == "string" then
        map = Resource.getFromName(map)
    end

    return MapMeta[map] or false
end

function getMapMetaInfo(map)
    assert(type(map) == "userdata" or type(map) == "string", "expected resource-resolvable at argument 1, got ".. type(map))

    if type(map) == "string" then
        map = Resource.getFromName(map)
    end

    return (MapMeta[map] and MapMeta[map].info) or false
end

function getMapMetaMaps(map)
    assert(type(map) == "userdata" or type(map) == "string", "expected resource-resolvable at argument 1, got ".. type(map))

    if type(map) == "string" then
        map = Resource.getFromName(map)
    end

    return (MapMeta[map] and MapMeta[map].maps) or false
end

function getMapMetaFiles(map)
    assert(type(map) == "userdata" or type(map) == "string", "expected resource-resolvable at argument 1, got ".. type(map))

    if type(map) == "string" then
        map = Resource.getFromName(map)
    end

    return (MapMeta[map] and MapMeta[map].files) or false
end

function getMapMetaScripts(map)
    assert(type(map) == "userdata" or type(map) == "string", "expected resource-resolvable at argument 1, got ".. type(map))

    if type(map) == "string" then
        map = Resource.getFromName(map)
    end

    return (MapMeta[map] and MapMeta[map].scripts) or false
end

function getMapMetaIncludes(map)
    assert(type(map) == "userdata" or type(map) == "string", "expected resource-resolvable at argument 1, got ".. type(map))

    if type(map) == "string" then
        map = Resource.getFromName(map)
    end

    return (MapMeta[map] and MapMeta[map].includes) or false
end

function getMapMetaSettings(map)
    assert(type(map) == "userdata" or type(map) == "string", "expected resource-resolvable at argument 1, got ".. type(map))

    if type(map) == "string" then
        map = Resource.getFromName(map)
    end

    return (MapMeta[map] and MapMeta[map].settings) or false
end
