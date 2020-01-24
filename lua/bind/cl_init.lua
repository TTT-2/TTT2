------------
-- Bind module.
-- @module bind
-- @author saibotk
-- @desc Source: https://github.com/MysteryPancake/GMod-Binding/

local ipairs = ipairs

bind = {}

local tablename = "ttt2_bindings"
local Bindings = {}
local Registry = {}
local FirstPressed = {}
local WasPressed = {}
local SettingsBindings = {}
local SettingsBindingsCategories = { "TTT2 Bindings", "Other Bindings" }

--
--
-- INTERNAL FUNCTIONS
--
--

---
-- @internal
local function DBCreateTable()
	if not sql.TableExists(tablename) then
		local result = sql.Query("CREATE TABLE " .. tablename .. " (guid TEXT, name TEXT, button TEXT)")
		if result == false then
			return false
		end
	end

	return true
end

---
-- @internal
local function SaveBinding(name, button)
	if DBCreateTable() then
		local result = sql.Query("INSERT INTO " .. tablename .. " VALUES('" .. LocalPlayer():SteamID64() .. "', " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(button) .. ")")
		if result == false then
			print("[TTT2][BIND][ERROR] Wasn't able to save binding to database...")
		end
	end
end

---
-- @internal
local function DBRemoveBinding(name, button)
	if DBCreateTable() then
		local result = sql.Query("DELETE FROM " .. tablename .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "' AND name = " .. sql.SQLStr(name) .. " AND button = " .. sql.SQLStr(button) )
		if result == false then
			print("[TTT2][BIND][ERROR] Wasn't able to remove binding from database...")
		end
	end
end

---
-- @internal
local function TTT2LoadBindings()
	if DBCreateTable() then
		local result = sql.Query("SELECT * FROM " .. tablename .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "'")
		if istable(result) then
			for _, tbl in ipairs(result) do
				local tmp = tbl.button

				bind.RemoveAll(tbl.name, false)

				Bindings[tmp] = Bindings[tmp] or {}

				table.insert(Bindings[tmp], tbl.name)
			end

			print("[TTT2][BIND] Loaded bindings...")
		end
	end
end

---
-- @internal
local function TTT2BindCheckThink()
	-- Make sure the user is currently not typing anything, to prevent unwanted execution of a binding.
	if vgui.GetKeyboardFocus() ~= nil or LocalPlayer():IsTyping() or gui.IsConsoleVisible() or HELPSCRN.IsOpen() then return end

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
function bind.GetTable()
	return Bindings
end

---
-- Finds the first button associated with a specific binding and returns
-- the button. Returns KEY_NONE if no button is found.
-- @param string name
-- @return number
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
function bind.RemoveAll(name, persistent)
	-- clear all bindings
	for _, v in ipairs(bind.FindAll(name)) do
		bind.Remove(v, name, persistent)
	end
end

---
-- Adds an entry to the SettingsBindings table, to easily present them eg. in a GUI.
-- @param string name
-- @param string label
-- @param string[opt] category
-- @param number[optchain] defaultKey
function bind.AddSettingsBinding(name, label, category, defaultKey)
	if not category then
		category = "Other Bindings"
	end

	if not table.HasValue(SettingsBindingsCategories, category) then
		SettingsBindingsCategories[#SettingsBindingsCategories + 1] = category
	end

	--set DefaultKey if needed
	if defaultKey then
		bind.Set(defaultKey, name, false)
	end

	-- check if it already exists
	for _, tbl in ipairs(SettingsBindings) do
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
-- @param[opt] nil|string|boolean dontShowOrCategory
-- @param string[optchain] settingsLabel
-- @param number[optchain] defaultKey
function bind.Register(name, onPressedFunc, onReleasedFunc, dontShowOrCategory, settingsLabel, defaultKey)
	if not isfunction(onPressedFunc) and not isfunction(onReleasedFunc) then
		return
	end

	Registry[name] = {
		onPressed  = onPressedFunc,
		onReleased = onReleasedFunc
	}

	if dontShowOrCategory ~= true then
		bind.AddSettingsBinding(name, settingsLabel or name, dontShowOrCategory, defaultKey)
	end

	if defaultKey then
		bind.Set(defaultKey, name, false)
	end
end


---
-- Add a binding to run a command when the button is pressed. This function is not used to register a new binding shown in
-- the UI, but to bind a specific key to a command
-- @param number btn The button ID, see: <a href="BUTTON_CODE_Enums">https://wiki.garrysmod.com/page/Enums/BUTTON_CODE</a>
-- @param string name The command that should be executed
-- @param boolean persistent
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
function bind.Set(btn, name, persistent)
	if not name or name == "" or not isnumber(btn) then return end

	bind.RemoveAll(name)
	bind.Add(btn, name, persistent)
end

---
-- Returns the SettingsBindings table.
-- @return table
function bind.GetSettingsBindings()
	return SettingsBindings
end


---
-- Returns the SettingsBindingsCategories table.
-- @return table
function bind.GetSettingsBindingsCategories()
	return SettingsBindingsCategories
end
