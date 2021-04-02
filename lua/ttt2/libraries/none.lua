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
-- This @{function} creates a getter and a setter @{function} based on the name and the prefix "Get" and "Set"
-- @param table tbl the @{table} that should receive the Getter and Setter @{function}
-- @param string varname the name the tbl @{table} should have as key value
-- @param string name the name that should be concatenated to the prefix "Get" and "Set"
-- @realm shared
function AccessorFuncDT(tbl, varname, name)
	tbl["Get" .. name] = function(s)
		return s.dt and s.dt[varname]
	end

	tbl["Set" .. name] = function(s, v)
		if s.dt then
			s.dt[varname] = v
		end
	end
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
