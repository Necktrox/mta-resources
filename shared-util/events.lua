
events = {}

-- Examples:
-- events.trigger("name", 1, 2, 3)
-- events.trigger_once("name", 1, 2, 3)
-- events.async("name", 1, 2, 3)
-- events.on("name", function(a, b, c) end)

local Handlers = {}
local History = {}

-- Purpose:
--  Triggers an event
--
-- Arguments:
--  event : string
--  ... : callback arguments (optional)
function events.trigger(event, ...)
    assert(type(event) == "string", "expected string at argument 1, got ".. type(event))
    
    if not Handlers[event] then
        return
    end
    
    for callback in pairs(Handlers[event]) do
        pcall(callback, ...)
    end
    
    if History[event] then
        -- Free the memory for these 'trigger_once' handlers, because they have no usage anymore
        Handlers[event] = nil
    end
end

-- Purpose:
--  Marks the event as 'not triggerable' and triggers the event for the last time
-- 
-- Arguments:
--  event : string
--  ... : callback arguments (optional)
function events.trigger_once(event, ...)
    assert(type(event) == "string", "expected string at argument 1, got ".. type(event))

    if History[event] then
        return
    end
    
    History[event] = true
    events.trigger(event, ...)
end

-- Purpose:
--  An event should be fired after a small delay (non-blocking)
--
-- Arguments:
--  event : string
--  ... : callback arguments (optional)
function events.async(event, ...)
    assert(type(event) == "string", "expected string at argument 1, got ".. type(event))
    return Timer(events.trigger, 50, 1, event, ...)
end

-- Purpose:
--  Adds a handler for the event
--
-- Arguments:
--  event : string
--  callback : function
function events.on(event, callback)
    assert(type(event) == "string", "expected string at argument 1, got ".. type(event))
    assert(type(callback) == "function", "expected function at argument 2, got ".. type(callback))
    
    if History[event] then
        -- Do not add handers for used 'trigger_once' events
        return
    end
    
    if not Handlers[event] then
        Handlers[event] = {}
    end
    
    Handlers[event][callback] = true
end
