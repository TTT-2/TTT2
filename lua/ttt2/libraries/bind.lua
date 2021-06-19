------------
-- Bind module.
-- @ref https://github.com/MysteryPancake/GMod-Binding/
-- @author saibotk
-- @module bind

if SERVER then
	AddCSLuaFile()

	return
end

bind = {}

local BIND_TABLE_NAME = "ttt2_bindings"
local BIND_FLAG_TABLE_NAME = "ttt2_bindings_initialized"
local Bindings = {}
local Registry = {}
local FirstPressed = {}
local WasPressed = {}
local SettingsBindings = {}
local SettingsBindingsCategories = {
	"header_bindings_ttt2",
	"header_bindings_other"
}

--
--
-- INTERNAL FUNCTIONS
--
--

---
-- @internal
local function DBCreateBindsTable()
	if not sql.TableExists(BIND_TABLE_NAME) then
		local result = sql.Query("CREATE TABLE " .. BIND_TABLE_NAME .. " (guid TEXT, name TEXT, button TEXT)")

		if result == false then
			ErrorNoHalt("[TTT2][BIND][ERROR] Could not create the database table...")

			return false
		end
	end

	return true
end

---
-- @internal
local function DBCreateDefaultBindsFlagTable()
	if not sql.TableExists(BIND_FLAG_TABLE_NAME) then
		local result = sql.Query("CREATE TABLE " .. BIND_FLAG_TABLE_NAME .. " (guid TEXT, name TEXT)")

		if result == false then
			ErrorNoHalt("[TTT2][BIND][ERROR] Could not create the flag database table...")

			return false
		end
	end

	return true
end

---
-- @internal
local function SaveBinding(name, button)
	if DBCreateBindsTable() then
		local result = sql.Query("INSERT INTO " .. BIND_TABLE_NAME .. " VALUES('" .. LocalPlayer():SteamID64() .. "', " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(button) .. ")")

		if result == false then
			ErrorNoHalt("[TTT2][BIND][ERROR] Wasn't able to save binding to database...")
		end
	end
end

---
-- @internal
local function DBRemoveBinding(name, button)
	if DBCreateBindsTable() then
		local result = sql.Query("DELETE FROM " .. BIND_TABLE_NAME .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "' AND name = " .. sql.SQLStr(name) .. " AND button = " .. sql.SQLStr(button) )

		if result == false then
			ErrorNoHalt("[TTT2][BIND][ERROR] Wasn't able to remove binding from database...")
		end
	end
end

---
-- @internal
local function DBSetDefaultAppliedFlag(name)
	if DBCreateDefaultBindsFlagTable() then
		local result = sql.Query("INSERT INTO " .. BIND_FLAG_TABLE_NAME .. " VALUES('" .. LocalPlayer():SteamID64() .. "', " .. sql.SQLStr(name) .. ")")

		if result == false then
			ErrorNoHalt("[TTT2][BIND][ERROR] Wasn't able to save binding flag to database...")
		end
	end
end

---
-- @internal
local function WasDefaultApplied(name)
	if DBCreateDefaultBindsFlagTable() then
		local result = sql.Query("SELECT * FROM " .. BIND_FLAG_TABLE_NAME .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "' AND name = " .. sql.SQLStr(name))

		return istable(result)
	end

	return false
end

---
-- @internal
local function TTT2LoadBindings()
	if DBCreateBindsTable() then
		local result = sql.Query("SELECT * FROM " .. BIND_TABLE_NAME .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "'")

		if istable(result) then
			local resultCount = #result

			for i = 1, resultCount do
				local tbl = result[i]
				local tmp = tbl.button

				bind.RemoveAll(tbl.name, false)

				Bindings[tmp] = Bindings[tmp] or {}

				table.insert(Bindings[tmp], tbl.name)
			end

			print("[TTT2][BIND] Loaded bindings...")
		end
	end

	-- Try assigning the default key bind once if none is defined
	for name in pairs(Registry) do
		local item = Registry[name]

		if item.defaultKey and not WasDefaultApplied(name) then
			if bind.Find(name) == KEY_NONE then
				bind.Set(item.defaultKey, name, true)
			end

			-- We tried to assign the default, but a bind was already present, so do not retry
			-- and always set the applied flag.
			DBSetDefaultAppliedFlag(name)
		end
	end
end

---
-- @internal
local function TTT2BindCheckThink()
	-- Make sure the user is currently not typing anything, to prevent unwanted execution of a binding.
	if vgui.GetKeyboardFocus() ~= nil or LocalPlayer():IsTyping() or gui.IsConsoleVisible() or vguihandler.IsOpen() then return end

	for btn, tbl in pairs(Bindings) do
		local cache = input.IsButtonDown(btn)

		if cache and FirstPressed[btn] then
			for _, name in pairs(tbl) do
				if Registry[name] and isfunction(Registry[name].onPressed) then
					Registry[name].onPressed()
				end
			end
		end

		if not cache and WasPressed[btn] then
			for _, name in pairs(tbl) do
				if Registry[name] and isfunction(Registry[name].onReleased) then
					Registry[name].onReleased()
				end
			end
		end

		WasPressed[btn] = cache
		FirstPressed[btn] = not cache
	end
end

hook.Add("Think", "TTT2CallBindings", TTT2BindCheckThink)
hook.Add("InitPostEntity", "TTT2LoadBindings", TTT2LoadBindings)

--
--
-- END INTERNAL FUNCTIONS --
--
--

---
-- Returns a table of all the bindings
-- @return table
-- @realm client
function bind.GetTable()
	return Bindings
end

---
-- Finds the first button associated with a specific binding and returns
-- the button. Returns KEY_NONE if no button is found.
-- @param string name
-- @return[default=KEY_NONE] number
-- @realm client
function bind.Find(name)
	if not name then return end

	for btn, tbl in pairs(Bindings) do
		for _, id in pairs(tbl) do
			if id == name then
				return btn
			end
		end
	end

	return KEY_NONE
end


---
-- Finds all buttons associated with a specific binding and returns
-- the buttons. Returns an empty table if no button is found.
-- @param string name
-- @return table
-- @realm client
function bind.FindAll(name)
	if not name then return end

	local bt = {}

	for btn, tbl in pairs(Bindings) do
		for _, id in pairs(tbl) do
			if id == name then
				table.insert(bt, btn)
			end
		end
	end

	return bt
end

---
-- Whether or not this bind has been pressed and was not yet released.
-- @param string name
-- @return boolean
-- @realm client
function bind.IsPressed(name)
	if not name then return end

	local buttons = bind.FindAll(name)

	for i = 1, #buttons do
		if WasPressed[buttons[i]] then
			return true
		end
	end

	return false
end

---
-- Removes the binding (button) with the given identifier.
-- @param number btn
-- @param string name
-- @param boolean persistent
-- @realm client
function bind.Remove(btn, name, persistent)
	if persistent then
		DBRemoveBinding(name, btn) -- Still try to delete from DB
	end

	if not Bindings[btn] then return end

	for i, v in pairs(Bindings[btn]) do
		if v == name then
			Bindings[btn][i] = nil
		end
	end
end

---
-- Removes all bindings (buttons) associated with the given identifier.
-- @param string name
-- @param boolean persistent
-- @realm client
function bind.RemoveAll(name, persistent)
	local foundBinds = bind.FindAll(name)
	local foundBindsCount = #foundBinds

	-- clear all bindings
	for i = 1, foundBindsCount do
		bind.Remove(foundBinds[i], name, persistent)
	end
end

---
-- Adds an entry to the SettingsBindings table, to easily present them eg. in a GUI.
-- @param string name
-- @param string label
-- @param[opt] string category
-- @param[optchain] number defaultKey
-- @realm client
function bind.AddSettingsBinding(name, label, category, defaultKey)
	if not category then
		category = "header_bindings_other"
	end

	if not table.HasValue(SettingsBindingsCategories, category) then
		SettingsBindingsCategories[#SettingsBindingsCategories + 1] = category
	end

	-- check if it already exists
	for i = 1, #SettingsBindings do
		local tbl = SettingsBindings[i]

		if tbl.name == name then
			tbl.label = label -- update
			tbl.category = category
			tbl.defaultKey = defaultKey

			return -- don't insert again
		end
	end

	SettingsBindings[#SettingsBindings + 1] = {name = name, label = label, category = category, defaultKey = defaultKey}
end

---
-- Register a function to run when the button for a specific binding is pressed. This will also add the binding to the
-- BindingsCategories with the default category, otherwise set dontShowOrCategory to true.
-- If you wish to set a custom category name then set dontShowOrCategory to the category name and optionally also set the
-- label you wish to be displayed.
-- You can set a default key as well, so players don't need to bind manually if they don't want to.
--
-- @param string name
-- @param function onPressedFunc
-- @param function onReleasedFunc
-- @param[opt] string|boolean dontShowOrCategory
-- @param[optchain] string settingsLabel
-- @param[optchain] number defaultKey
-- @realm client
function bind.Register(name, onPressedFunc, onReleasedFunc, dontShowOrCategory, settingsLabel, defaultKey)
	if not isfunction(onPressedFunc) and not isfunction(onReleasedFunc) then return end

	Registry[name] = {
		onPressed  = onPressedFunc,
		onReleased = onReleasedFunc,
		defaultKey = defaultKey
	}

	if dontShowOrCategory ~= true then
		bind.AddSettingsBinding(name, settingsLabel or name, dontShowOrCategory, defaultKey)
	end
end

---
-- Add a binding to run a command when the button is pressed. This function is not used to register a new binding shown in
-- the UI, but to bind a specific key to a command
-- @param number btn The button ID, see: <a href="BUTTON_CODE_Enums">https://wiki.garrysmod.com/page/Enums/BUTTON_CODE</a>
-- @param string name The command that should be executed
-- @param boolean persistent
-- @realm client
function bind.Add(btn, name, persistent)
	if not name or name == "" or not isnumber(btn) then return end

	Bindings[btn] = Bindings[btn] or {}

	table.insert(Bindings[btn], name)

	if persistent then
		SaveBinding(name, btn)
	end
end

---
-- Add a binding to run when the button is pressed and clears all previous
-- buttons that are associated with this identifier.
-- @param number btn
-- @param string name
-- @param boolean persistent
-- @realm client
function bind.Set(btn, name, persistent)
	if not name or name == "" or not isnumber(btn) then return end

	bind.RemoveAll(name, persistent)
	bind.Add(btn, name, persistent)
end

---
-- Returns the SettingsBindings table.
-- @return table
-- @realm client
function bind.GetSettingsBindings()
	return SettingsBindings
end

---
-- Returns the SettingsBindingsCategories table.
-- @return table
-- @realm client
function bind.GetSettingsBindingsCategories()
	return SettingsBindingsCategories
end
