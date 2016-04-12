
function XML:getNodesByTag(nodeTag)
    assert(type(nodeTag) == "string", "expected string at argument 1, got ".. type(nodeTag))
    local index, node, nodeList = 0, false, {}

    repeat
        node = self:findChild(nodeTag, index)

        if node then
            nodeList[index + 1] = node
            index = index + 1
        end
    until not node

    return nodeList
end

function XML:getFirstNodeByTag(nodeTag)
    assert(type(nodeTag) == "string", "expected string at argument 1, got ".. type(nodeTag))
    return self:findChild(nodeTag, 0)
end

function XML:getNodeCountByTag(nodeTag)
    assert(type(nodeTag) == "string", "expected string at argument 1, got ".. type(nodeTag))
    local index = 0
    while self:findChild(nodeTag, index) do
        index = index + 1
    end
    return index
end

function XML:anyNodeByTagExists(nodeTag)
    assert(type(nodeTag) == "string", "expected string at argument 1, got ".. type(nodeTag))
    return self:findChild(nodeTag, 0) ~= false
end

function XML:iterByTag(nodeTag)
    assert(type(nodeTag) == "string", "expected string at argument 1, got ".. type(nodeTag))
    local index, node = 0, false

    return function ()
        node = self:findChild(nodeTag, index)

        if node then
            index = index + 1
            return index, node
        else
            return nil
        end
    end
end
