---
-- @module HUDManager

HUDManager = {}

local updateListeners = {}
local updateAnyListeners = {}

local model = {
	restrictedHUDs = {},
	forcedHUD = nil,
	defaultHUD = "pure_skin"
}

---
-- Returns a model value
-- @param string key
-- @return any value
-- @realm shared
function HUDManager.GetModelValue(key)
	if not key then return end

	local val = model[key]

	if istable(model[key]) then
		val = table.Copy(model[key])
	end

	return val
end

---
-- Sets a model value
-- @param string key
-- @param any value
-- @realm shared
function HUDManager.SetModelValue(key, value)
	if not key then return end

	local oldvalue = model[key]
	model[key] = value

	if oldvalue ~= value then -- equal check does not work as expected for tables (always true)!
		-- call all listeners, that the value has changed
		for _, func in ipairs(updateAnyListeners) do
			func()
		end

		if updateListeners[key] then
			for _, func in ipairs(updateListeners[key]) do
				func(value, oldvalue)
			end
		end
	end
end

---
-- Calls a function on updating any attribute
-- @param function func
-- @realm shared
function HUDManager.OnUpdateAnyAttribute(func)
	if not isfunction(func) then return end

	if not table.HasValue(updateAnyListeners, func) then
		table.insert(updateAnyListeners, func)
	end
end

---
-- Calls a function on updating a specific attribute
-- @param string key identifier of the attribute (key)
-- @param function func
-- @realm shared
function HUDManager.OnUpdateAttribute(key, func)
	if not key or not isfunction(func) then return end

	updateListeners[key] = updateListeners[key] or {}

	if not table.HasValue(updateListeners[key], func) then
		table.insert(updateListeners[key], func)
	end
end

if SERVER then
	ttt_include("sv_hud_manager")
else
	ttt_include("cl_hud_editor")
	ttt_include("cl_hud_manager")
end
