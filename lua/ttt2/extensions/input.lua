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

function input.IsBindingDown(binding)
	return inputIsButtonDown(inputGetKeyCode(inputLookupBinding(binding)))
end
