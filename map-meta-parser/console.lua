
addCommandHandler("map",
    function (player, command, mapName, section)
        if player.type ~= "console" then
            return
        end

        local sectionList = {
            info = printMapInfo,
            scripts = printMapScripts,
            files = printMapFiles,
            includes = printMapIncludes,
            settings = printMapSettings,
            maps = printMapMaps
        }

        if not mapName or not section then
            return outputServerLog("Syntax: /mapinfo [map name] [info|scripts|files|includes|settings|maps]")
        end

        local map = Resource.getFromName(mapName)

        if not map then
            return outputServerLog("Error: Map '".. mapName .."' not found")
        end

        if not MapMeta[map] then
            return outputServerLog("Error: Map '".. mapName .."' has not been parsed or is error'ish")
        end

        outputServerLog(">>> Map: ".. mapName .." <<<")
        sectionList[section](MapMeta[map][section])
    end
)

function printMapInfo(info)
    for key, value in pairs(info) do
        outputServerLog("  ".. key .." = ".. tostring(value))
    end
end

function printMapScripts(scripts)
    for index, script in pairs(scripts) do
        outputServerLog("  >> Script")
        outputServerLog("    type = ".. script.type)
        outputServerLog("    src.absolute = ".. script.src.absolute)
        outputServerLog("    src.relative = ".. script.src.relative)
        outputServerLog("    src.hash = ".. script.src.hash)
    end
end

function printMapFiles(files)
    for index, file in pairs(files) do
        outputServerLog("  >> File")
        outputServerLog("    src.absolute = ".. file.src.absolute)
        outputServerLog("    src.relative = ".. file.src.relative)
        outputServerLog("    src.hash = ".. file.src.hash)
    end
end

function printMapIncludes(includes)
    for index, include in pairs(includes) do
        outputServerLog("  >> Include")
        outputServerLog("    resource = ".. include.resource)
    end
end

function printMapSettings(settings)
    for index, setting in pairs(settings) do
        outputServerLog("  >> Setting")
        outputServerLog("    access = ".. setting.access)
        outputServerLog("    name = ".. setting.name)
        outputServerLog("    value = ".. setting.value)
    end
end

function printMapMaps(maps)
    for index, map in pairs(maps) do
        outputServerLog("  >> Map")
        outputServerLog("    src.absolute = ".. map.src.absolute)
        outputServerLog("    src.relative = ".. map.src.relative)
        outputServerLog("    src.hash = ".. map.src.hash)
    end
end
