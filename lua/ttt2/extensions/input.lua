---
-- Extension of the input module
-- @module input

if SERVER then
	AddCSLuaFile()

	return
end

local inputIsKeyDown = input.IsKeyDown
local inputGetKeyCode = input.GetKeyCode
local inputLookupBinding = input.LookupBinding

function input.IsBindingDown(binding)
	return inputIsKeyDown(inputGetKeyCode(inputLookupBinding(binding)))
end
