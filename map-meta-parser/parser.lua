
MapMeta = {}

addEventHandler("onResourceStart", resourceRoot,
    function ()
        if not isOOPEnabled() then
            outputServerLog("Map Meta Parser: This resource requires <oop>true</oop> in meta.xml")
            return cancelEvent(true)
        end

        if not resource:hasPermissionTo("general.ModifyOtherObjects", false) then
            outputServerLog("Map Meta Parser: ACL: No permission for 'general.ModifyOtherObjects'")
            return cancelEvent(true)
        end

        local resourceList = getResources()
        local resourceCount = #resourceList
        local mapList = {}
        local mapIndex = 0

        for index = 1, resourceCount do
            local resource = resourceList[index]
            if resource:getInfo("type") == "map" then
                mapIndex = mapIndex + 1
                mapList[mapIndex] = resource
            end
        end

        if mapIndex == 0 then
            outputServerLog("Map Meta Parser: Found zero map resources")
            return
        end

        outputServerLog("Map Meta Parser: Amount of maps on server: ".. mapIndex)
        parseMapResourceList(mapList)
    end,
false)

function parseMapResourceList(mapList)
    assert(type(mapList) == "table", "expected table at argument 1, got ".. type(mapList))

    local mapCount = #mapList

    if mapCount == 0 then
        return false
    end

    local mapsLeftCount = mapCount
    local deltaTime = getTickCount()
    local timeToSleep = false
    local secondsTicks = 0

    local function parseNextMapInList()
        -- Take map from top of map table
        local map = mapList[mapsLeftCount]
        mapList[mapsLeftCount] = nil
        mapsLeftCount = mapsLeftCount - 1

        -- Parse map
        local beforeTime = getTickCount()
        parseMapResource(map)
        local durationMS = getTickCount() - beforeTime

        -- Send warnings to log about parsing-heavy maps
        if durationMS >= 1000 then
            outputServerLog("Map Meta Parser: Warning: Map '".. map.name .."' took ".. durationMS .." ms for parsing")
        end

        -- Show progress percentage in server log each second
        if (getTickCount() - deltaTime) >= 1000 then
            local percentage = math.ceil((1 - (mapsLeftCount / mapCount)) * 100)
            outputServerLog("Map Meta Parser: ".. percentage .."% done")
            deltaTime = deltaTime + 1000
            secondsTicks = secondsTicks + 1
            timeToSleep = true
        end

        if mapsLeftCount > 0 then
            if timeToSleep then
                Timer(parseNextMapInList, 50, 1)
                timeToSleep = false
            else
                parseNextMapInList()
            end
        else
            local time = (getTickCount() - deltaTime) + (secondsTicks * 1000)
            local average = time / mapCount
            local summary = (" (time: %d ms, average: %.2f ms)"):format(time, average)
            outputServerLog("Map Meta Parser: ".. mapCount .." maps have been parsed" .. summary)
        end

        return true
    end

    return parseNextMapInList()
end

function parseMapResource(map)
    local resourceName = map:getName()
    local metaFilePath = (":%s/meta.xml"):format(resourceName)
    local metaRoot = XML.load(metaFilePath)

    if not metaRoot then
        return false
    end

    local mapParsingIssues = false

    local info = {
        name = false,
        author = false,
        type = false,
        version = false,
        description = false
    }

    local infoNode = metaRoot:getFirstNodeByTag("info")

    if infoNode then
        for key, value in pairs(infoNode.attributes) do
            info[key] = value
        end
    end

    local maps = {}

    if not metaRoot:anyNodeByTagExists("map") then
        outputServerLog("Map Meta Parser: Warning: Map resource '".. resourceName .."' has zero <map/> nodes")
        metaRoot:unload()
        return false
    else
        for index, node in metaRoot:iterByTag("map") do
            local attributeSrc = node:getAttribute("src")

            if attributeSrc and attributeSrc:len() > 0 then
                local absolutePath = (":%s/%s"):format(resourceName, attributeSrc)
                local fileHash = File.getMD5Hash(absolutePath)

                if fileHash then
                    maps[#maps + 1] = {
                        src = {
                            absolute = absolutePath,
                            relative = attributeSrc,
                            hash = fileHash
                        }
                    }
                else
                    outputServerLog("Map Meta Parser: Warning: File '".. attributeSrc .."' in map resource '".. resourceName .."' is not readable")
                    mapParsingIssues = true
                    break
                end
            end
        end
    end

    if mapParsingIssues then
        metaRoot:unload()
        return false
    end

    local scripts = {}

    for index, node in metaRoot:iterByTag("script") do
        local attributeSrc = node:getAttribute("src")
        local attributeType = node:getAttribute("type")

        if attributeSrc and attributeSrc:len() > 0 then
            if not attributeType or (attributeType ~= "client" and attributeType ~= "server" and attributeType ~= "shared") then
                attributeType = "server"
            end

            local absolutePath = (":%s/%s"):format(resourceName, attributeSrc)
            local fileHash = File.getMD5Hash(absolutePath)

            if fileHash then
                scripts[#scripts + 1] = {
                    src = {
                        absolute = absolutePath,
                        relative = attributeSrc,
                        hash = fileHash
                    },
                    type = attributeType
                }
            else
                outputServerLog("Map Meta Parser: Warning: File '".. attributeSrc .."' in map resource '".. resourceName .."' is not readable")
                mapParsingIssues = true
                break
            end
        end
    end

    if mapParsingIssues then
        metaRoot:unload()
        return false
    end

    local files = {}

    for index, node in metaRoot:iterByTag("files") do
        local attributeSrc = node:getAttribute("src")

        if attributeSrc and attributeSrc:len() > 0 then
            local absolutePath = (":%s/%s"):format(resourceName, attributeSrc)
            local fileHash = File.getMD5Hash(absolutePath)

            if fileHash then
                files[#files + 1] = {
                    src = {
                        absolute = absolutePath,
                        relative = attributeSrc,
                        hash = fileHash
                    }
                }
            else
                outputServerLog("Map Meta Parser: Warning: File '".. attributeSrc .."' in map resource '".. resourceName .."' is not readable")
                mapParsingIssues = true
                break
            end
        end
    end

    if mapParsingIssues then
        metaRoot:unload()
        return false
    end

    local includes = {}

    for index, node in metaRoot:iterByTag("files") do
        local attributeResource = node:getAttribute("resource")

        if attributeResource and attributeResource:len() > 0 then
            if Resource.getFromName(attributeResource) then
                files[#files + 1] = {
                    resource = attributeResource
                }
            else
                outputServerLog("Map Meta Parser: Warning: Include resource '".. attributeResource .."' in map resource '".. resourceName .."' does not exist")
                mapParsingIssues = true
                break
            end
        end
    end

    if mapParsingIssues then
        metaRoot:unload()
        return false
    end

    local settings = {}
    local settingsNode = metaRoot:getFirstNodeByTag("settings")

    if settingsNode then
        for index, node in settingsNode:iterByTag("setting") do
            local attributeName = node:getAttribute("name")
            local attributeValue = node:getAttribute("value")

            if attributeName and attributeName:len() > 0 and attributeValue then
                local access, name = attributeName:match("^([%*#@]?)(.+)$")

                if access == "#" then
                    access = "protected"
                elseif access == "@" then
                    access = "private"
                else
                    access = "public"
                end

                settings[#settings + 1] = {
                    access = access,
                    name = name,
                    value = fromJSON(attributeValue) or attributeValue
                }
            end
        end
    end

    if metaRoot:anyNodeByTagExists("config") then
        outputServerLog("Map Meta Parser: Warning: Map resource '".. resourceName .."' has one or more <config/> nodes")
        mapParsingIssues = true
    end

    if metaRoot:anyNodeByTagExists("export") then
        outputServerLog("Map Meta Parser: Warning: Map resource '".. resourceName .."' has one or more <export/> nodes")
        mapParsingIssues = true
    end

    if metaRoot:anyNodeByTagExists("html") then
        outputServerLog("Map Meta Parser: Warning: Map resource '".. resourceName .."' has one or more <html/> nodes")
        mapParsingIssues = true
    end

    metaRoot:unload()

    if not mapParsingIssues then
        MapMeta[map] = {
            info = info,
            maps = maps,
            files = files,
            scripts = scripts,
            includes = includes,
            settings = settings,
        }

        return true
    end

    return false
end
