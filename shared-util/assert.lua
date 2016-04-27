
-- Rewrite assert to show correct location of errorish code
function assert(statement, message)
    if not statement then
        message = (type(message) == "string") and message or "assert has failed"
        error(message, 3)
    end
end
