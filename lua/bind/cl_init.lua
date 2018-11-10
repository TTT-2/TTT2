-- Source: https://github.com/MysteryPancake/GMod-Binding/
bind = {}

local tablename = "ttt2_bindings"
local Bindings = {}
local Registry = {}
local FirstPressed = {}

--[[----------------------------

 	INTERNAL FUNCTIONS

-------------------------]]-----
local function DBCreateTable()
	local tblname = tablename
	if not sql.TableExists(tblname) then
		local result = sql.Query("CREATE TABLE " .. tblname .. " (guid TEXT, name TEXT, button TEXT)")
		if result == false then
			return false
		end

		return true
	else
		return true
	end
end

local function SaveBinding(name, button)
	if DBCreateTable() then
		local result = sql.Query("INSERT INTO " .. tablename .. " VALUES('" .. LocalPlayer():SteamID64() .. "','" .. name .. "','" .. button .. "')")
		if result then
			print("[TTT2][BIND] Saved binding...")
		else
			print("[TTT2][BIND][ERROR] Wasn't able to save binding...")
		end
	end
end

local function DBRemoveBinding(name, button)
	print("[TTT2][BIND] Deleting key from DB")

	if DBCreateTable() then
		local result = sql.Query("DELETE FROM " .. tablename .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "' AND name = '" .. name .. "' AND button = '" .. button .. "'")
		if result then
			print("[TTT2][BIND] Removed binding...")
		else
			print("[TTT2][BIND][ERROR] Wasn't able to remove binding...")
		end
	end
end

hook.Add("InitPostEntity", "TTT2LoadBindings", function()
	if DBCreateTable() then
		local result = sql.Query("SELECT * FROM " .. tablename .. " WHERE guid = '" .. LocalPlayer():SteamID64() .. "'")
		if istable(result) then
			for _, tbl in ipairs(result) do
				local tmp = tbl.button

				Bindings[tmp] = Bindings[tmp] or {}

				table.insert(Bindings[tmp], tbl.name)
			end

			print("[TTT2][BIND] Loaded bindings...")
		end
	end
end)

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
    Register( any identifier, function func )
    Register a function to run when the button for a specific binding is pressed.
-----------------------------------------------------------]]
function bind.Register(name, func)
	if not isfunction(func) then return end

	Registry[name] = func
end

--[[---------------------------------------------------------
    Add( number button, any identifier, bool persistent )
    Add a binding to run when the button is pressed.
-----------------------------------------------------------]]
function bind.Add(btn, name, pers)
	if not name or name == "" or not isnumber(btn) then return end

	Bindings[btn] = Bindings[btn] or {}

	table.insert(Bindings[btn], name)

	if pers then
		SaveBinding(name, btn)
	end
end

--[[---------------------------------------------------------
    Find( any identifier )
    Find buttons associated with a specific binding and returns
	the button. Returns KEY_NONE if no button is found.
-----------------------------------------------------------]]
function bind.Find(name)
	for btn, tbl in pairs(Bindings) do
		for _, id in ipairs(tbl) do
			if id == name then
				return btn
			end
		end
	end

	return KEY_NONE
end

--[[---------------------------------------------------------
    Remove( number button, any identifier )
    Removes the binding with the given identifier.
-----------------------------------------------------------]]
function bind.Remove(btn, name)
	print("[TTT2][BIND] Attempt to remove binding " .. name .. " on button id " .. tonumber(btn))

	DBRemoveBinding(name, btn) -- Still try to delete from DB

	if not Bindings[btn] then return end

	print("[TTT2][BIND] removing")

	for i, v in ipairs(Bindings[btn]) do
		if v == name then
			table.remove(Bindings[btn], i)
		end
	end
end

hook.Add("Think", "TTT2CallBindings", function()
	for btn, tbl in pairs(Bindings) do
		local cache = input.IsButtonDown(btn)

		if cache and FirstPressed[btn] then
			for _, name in ipairs(tbl) do
				if isfunction(Registry[name]) then
					Registry[name]()
				end
			end
		end

		FirstPressed[btn] = not cache
	end
end)
