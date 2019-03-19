-- Source: https://github.com/MysteryPancake/GMod-Binding/
bind = {}

local tablename = "ttt2_bindings"
local Bindings = {}
local Registry = {}
local FirstPressed = {}
local WasPressed = {}
local SettingsBindings = {}
local SettingsBindingsCategories = {"TTT2 Bindings", "Other Bindings"}

--[[----------------------------

 	INTERNAL FUNCTIONS

-------------------------]]-----
local function DBCreateTable()
	if not sql.TableExists(tablename) then
		local result = sql.Query("CREATE TABLE " .. tablename .. " (guid TEXT, name TEXT, button TEXT)")
		if result == false then
			return false
		end
	end

	return true
end

local function SaveBinding(name, button)
	if DBCreateTable() then
		local result = sql.Query("INSERT INTO " .. tablename .. " VALUES('" .. LocalPlayer():SteamID64() .. "', " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(button) .. ")")
		if result ~= false then
			print("[TTT2][BIND] Saved binding...")
		else
			print("[TTT2][BIND][ERROR] Wasn't able to save binding...")
		end
	end
end

local function DBRemoveBinding(name, button)
	print("[TTT2][BIND] Deleting key from DB")

	if DBCreateTable() then
		local result = sql.Query("DELETE FROM " .. tablename .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "' AND name = " .. sql.SQLStr(name) .. " AND button = " .. sql.SQLStr(button) )
		if result ~= false then
			print("[TTT2][BIND] Removed binding...")
		else
			print("[TTT2][BIND][ERROR] Wasn't able to remove binding...")
		end
	end
end

local function TTT2LoadBindings()
	print("[TTT2][BIND] Loading button bindings...")

	if DBCreateTable() then
		local result = sql.Query("SELECT * FROM " .. tablename .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "'")
		if istable(result) then
			for _, tbl in ipairs(result) do
				local tmp = tbl.button
				
				bind.RemoveAll(tbl.name)

				Bindings[tmp] = Bindings[tmp] or {}

				table.insert(Bindings[tmp], tbl.name)
			end

			print("[TTT2][BIND] Loaded bindings...")
		end
	end
end

local function TTT2BindCheckThink()
	-- Make sure the user is currently not typing anything, to prevent unwanted execution of a binding.
	if vgui.GetKeyboardFocus() ~= nil then return end

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

--[[---------------------------------------------------------

			END INTERNAL FUNCTIONS

--]]----------------------------------------

--[[---------------------------------------------------------
    GetTable()
    Returns a table of all the bindings.
-----------------------------------------------------------]]
function bind.GetTable()
	return Bindings
end

--[[---------------------------------------------------------
    Find( any identifier )
    Finds the first button associated with a specific binding and returns
	the button. Returns KEY_NONE if no button is found.
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
    FindAll( any identifier )
    Finds all buttons associated with a specific binding and returns
	the buttons. Returns an empty table if no button is found.
-----------------------------------------------------------]]
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

--[[---------------------------------------------------------
    Remove( number button, any identifier )
    Removes the binding (button) with the given identifier.
-----------------------------------------------------------]]
function bind.Remove(btn, name)
	print("[TTT2][BIND] Attempt to remove binding " .. name .. " on button id " .. tonumber(btn))

	DBRemoveBinding(name, btn) -- Still try to delete from DB

	if not Bindings[btn] then return end

	print("[TTT2][BIND] removing binding")

	for i, v in pairs(Bindings[btn]) do
		if v == name then
			Bindings[btn][i] = nil
		end
	end
end

--[[---------------------------------------------------------
    RemoveAll( any identifier )
    Removes all bindings (buttons) associated with the given identifier.
-----------------------------------------------------------]]
function bind.RemoveAll(name)
	-- clear all bindings
	for _, v in ipairs(bind.FindAll(name)) do
		bind.Remove(v, name)
	end
end

--[[---------------------------------------------------------
    AddSettingsBinding( string name, string label )
    Adds an entry to the SettingsBindings table, to easily present them eg. in a GUI.
-----------------------------------------------------------]]
function bind.AddSettingsBinding(name, label, category)
	if not category then
		category = "Other Bindings"
	end

	if not table.HasValue(SettingsBindingsCategories, category) then
		SettingsBindingsCategories[#SettingsBindingsCategories + 1] = category
	end

	-- check if it already exists
	for _, tbl in ipairs(SettingsBindings) do
		if tbl.name == name then
			tbl.label = label -- update
			tbl.category = category
			return -- don't insert again
		end
	end

	SettingsBindings[#SettingsBindings + 1] = {name = name, label = label, category = category}
end

--[[---------------------------------------------------------
    Register( any identifier, function func, function onPressed, function onReleased, [OPTIONAL] dontShowOrCategory, [OPTIONAL] settingsLabel, [OPTIONAL] defaultKey )
    Register a function to run when the button for a specific binding is pressed. This will also add the binding to the
	BindingsCategories with the default category, otherwise set dontShowOrCategory to true.
	If you wish to set a custom category name then set dontShowOrCategory to the category name and optionally also set the
	label you wish to be displayed.
	You can set a default key as well, so players don't need to bind manually if they don't want to.
-----------------------------------------------------------]]
function bind.Register(name, onPressedFunc, onReleasedFunc, dontShowOrCategory, settingsLabel, defaultKey)
	if not isfunction(onPressedFunc) and not isfunction(onReleasedFunc) then
		return
	end

	Registry[name] = {
		onPressed  = onPressedFunc,
		onReleased = onReleasedFunc
	}

	if dontShowOrCategory ~= true then
		bind.AddSettingsBinding(name, settingsLabel or name, dontShowOrCategory)
	end

	if defaultKey then
		if bind.Find(name) == KEY_NONE then
			bind.Set(defaultKey, name, false)
		end
	end
end

--[[---------------------------------------------------------
    Add( number button, any identifier, bool persistent )
    Add a binding to run when the button is pressed.
-----------------------------------------------------------]]
function bind.Add(btn, name, persistent)
	if not name or name == "" or not isnumber(btn) then return end

	Bindings[btn] = Bindings[btn] or {}

	table.insert(Bindings[btn], name)

	if persistent then
		SaveBinding(name, btn)
	end
end

--[[---------------------------------------------------------
    Set( number button, any identifier, bool persistent )
    Add a binding to run when the button is pressed and clears all previous
	buttons that are associated with this identifier.
-----------------------------------------------------------]]
function bind.Set(btn, name, persistent)
	if not name or name == "" or not isnumber(btn) then return end

	bind.RemoveAll(name)
	bind.Add(btn, name, persistent)
end

--[[---------------------------------------------------------
    GetSettingsBinding()
    Returns the SettingsBindings table.
-----------------------------------------------------------]]
function bind.GetSettingsBindings()
	return SettingsBindings
end

--[[---------------------------------------------------------
    GetSettingsBindingsCategories()
    Returns the SettingsBindingsCategories table.
-----------------------------------------------------------]]
function bind.GetSettingsBindingsCategories()
	return SettingsBindingsCategories
end
