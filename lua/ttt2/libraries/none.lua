---
-- A bunch of random function bundled in no module globally
-- @author Mineotopia
-- @author LeBroomer
-- @author Alf21
-- @author tkindanight
-- @module none

if SERVER then
	AddCSLuaFile()
end

---
-- Color unpacking
-- @param Color color
-- @return number red value of the given color
-- @return number green value of the given color
-- @return number blue value of the given color
-- @return number alpha value of the given color
-- @realm shared
function clr(color)
	return color.r, color.g, color.b, color.a
end

---
-- Short helper for input.LookupBinding, returns capitalised key or a default
-- @param string binding
-- @param string default
-- @return string
-- @realm shared
-- @ref https://wiki.garrysmod.com/page/input/LookupBinding
function Key(binding, default)
	local b = input.LookupBinding(binding)
	if not b then
		return default
	end

	return string.upper(b)
end

---
-- Debugging function
-- @param number level required level
-- @param any ... anything that should be printed
-- @realm shared
function Dev(level, ...)
	if not cvars or cvars.Number("developer", 0) < level then return end

	Msg("[TTT dev]")
	-- table.concat does not tostring, derp

	local params = {...}

	for i = 1, #params do
		Msg(" " .. tostring(params[i]))
	end

	Msg("\n")
end

---
-- A simple check whether an @{Entity} is a valid @{Player}
-- @param Entity ent
-- @return boolean
-- @realm shared
function IsPlayer(ent)
	return ent and IsValid(ent) and ent:IsPlayer()
end

---
-- A simple check whether an @{Entity} is a valid ragdoll
-- @param Entity ent
-- @return boolean
-- @realm shared
function IsRagdoll(ent)
	return ent and IsValid(ent) and ent:GetClass() == "prop_ragdoll"
end
