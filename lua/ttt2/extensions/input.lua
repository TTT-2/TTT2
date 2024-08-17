---
-- Extension of the input module
-- @module input

if SERVER then
    AddCSLuaFile()

    return
end

local inputIsButtonDown = input.IsButtonDown
local inputGetKeyCode = input.GetKeyCode
local inputLookupBinding = input.LookupBinding

---
-- Checks if a specified key associated with a binding is down.
-- @param string binding The binding (e.g. "+attack") that should be checked
-- @return boolean Returns true if the binding is pressed
-- @realm client
function input.IsBindingDown(binding)
    local bindingLookup = inputLookupBinding(binding)

    if not bindingLookup then
        return false
    end

    return inputIsButtonDown(inputGetKeyCode(bindingLookup))
end
