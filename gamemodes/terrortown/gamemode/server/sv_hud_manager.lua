util.AddNetworkString("TTT2RequestHUD")
util.AddNetworkString("TTT2ReceiveHUD")
util.AddNetworkString("TTT2DefaultHUDRequest")
util.AddNetworkString("TTT2DefaultHUDResponse")
util.AddNetworkString("TTT2ForceHUDRequest")
util.AddNetworkString("TTT2ForceHUDResponse")
util.AddNetworkString("TTT2RestrictHUDRequest")
util.AddNetworkString("TTT2RestrictHUDResponse")
util.AddNetworkString("TTT2RequestHUDManagerFullStateUpdate")
util.AddNetworkString("TTT2UpdateHUDManagerStringAttribute")
util.AddNetworkString("TTT2UpdateHUDManagerRestrictedHUDsAttribute")

local HUD_MANAGER_SQL_TABLE = "ttt2_hudmanager_model_data"
local HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE = "ttt2_hudmanager_model_data_restrictedhuds"

--[[----------------------------------------------------------------------------
	DB HELPER FUNCTIONS
--]]----------------------------------------------------------------------------

local function DB_EnsureTableExists(tablename, tablecolumns)
	if not tablename or not tablecolumns then
		return false
	end

	if not sql.TableExists(tablename) then
		local result = sql.Query("CREATE TABLE " .. sql.SQLStr(tablename, false) .. " (" .. tablecolumns .. ")")
		if result == false then
			return false
		end
	end

	return true
end

local function DB_GetStringValue(key)
	if DB_EnsureTableExists(HUD_MANAGER_SQL_TABLE, "key TEXT PRIMARY KEY, value TEXT") then
		local result = sql.Query("SELECT * FROM " .. HUD_MANAGER_SQL_TABLE .. " WHERE key = " .. sql.SQLStr(key, false))

		if istable(result) and #result > 0 and result[1].value ~= "nil" then
			return result[1].value
		else
			return nil
		end
	end
end

local function DB_GetStringTable(db_table)
	if DB_EnsureTableExists(db_table, "name TEXT PRIMARY KEY") then
		local res = sql.Query("SELECT * FROM " .. sql.SQLStr(db_table, false))

		if istable(res) then
			local tab = {}

			for _, v in ipairs(res) do
				table.insert(tab, v.name)
			end

			return tab
		end
	end

	return nil
end

--[[----------------------------------------------------------------------------
	SYNCING HELPER FUNCTIONS
--]]----------------------------------------------------------------------------

local function syncModelStringAttribute(key, ply)
	net.Start("TTT2UpdateHUDManagerStringAttribute")
	net.WriteString(key)
	net.WriteString(HUDManager.GetModelValue(key) or "NULL")

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

local function syncModelRestrictedHUDsAttribute(ply)
	net.Start("TTT2UpdateHUDManagerRestrictedHUDsAttribute")

	local value = HUDManager.GetModelValue("restrictedHUDs")

	if istable(value) then
		net.WriteUInt(#value, 16)

		for _, v in ipairs(value) do
			net.WriteString(v)
		end
	else
		net.WriteUInt(0, 16)
	end

	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

--[[----------------------------------------------------------------------------
	STORE/LOAD FUNCTIONS
--]]----------------------------------------------------------------------------

function HUDManager.StoreData()
	MsgN("[TTT2][HUDManager] Storing data in database...")

	if DB_EnsureTableExists(HUD_MANAGER_SQL_TABLE, "key TEXT PRIMARY KEY, value TEXT") then
		sql.Query("INSERT OR REPLACE INTO " .. HUD_MANAGER_SQL_TABLE .. " VALUES('forcedHUD', " .. sql.SQLStr(HUDManager.GetModelValue("forcedHUD")) .. ")")
		sql.Query("INSERT OR REPLACE INTO " .. HUD_MANAGER_SQL_TABLE .. " VALUES('defaultHUD', " .. sql.SQLStr(HUDManager.GetModelValue("defaultHUD")) .. ")")
	end

	-- delete the table to recreate it again, to remove all values that might have been removed from the table
	sql.Query("DROP TABLE " .. HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE)

	if DB_EnsureTableExists(HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE, "name TEXT PRIMARY KEY") then
		for _, v in ipairs(HUDManager.GetModelValue("restrictedHUDs")) do
			sql.Query("INSERT INTO " .. HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE .. " VALUES(" .. sql.SQLStr(v) .. ")")
		end
	end
end

function HUDManager.LoadData()
	MsgN("[TTT2][HUDManager] Loading data from database...")

	if sql.TableExists(HUD_MANAGER_SQL_TABLE) then
		HUDManager.SetModelValue("forcedHUD", DB_GetStringValue("forcedHUD"))
		HUDManager.SetModelValue("defaultHUD", DB_GetStringValue("defaultHUD"))
	end

	if sql.TableExists(HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE) then
		HUDManager.SetModelValue("restrictedHUDs", DB_GetStringTable(HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE) or {})
	end
end

-- load values from the database when this file is executed
HUDManager.LoadData()

-- Register update handlers to sync any changes to the client / store them in the database
HUDManager.OnUpdateAnyAttribute(HUDManager.StoreData)

HUDManager.OnUpdateAttribute("forcedHUD", function(newval, oldval)
	syncModelStringAttribute("forcedHUD")
end)

HUDManager.OnUpdateAttribute("defaultHUD", function(newval, oldval)
	syncModelStringAttribute("defaultHUD")
end)

HUDManager.OnUpdateAttribute("restrictedHUDs", function(newval, oldval)
	syncModelRestrictedHUDsAttribute()
end)

--[[----------------------------------------------------------------------------
	HUDManager commands / requests from clients
--]]----------------------------------------------------------------------------

net.Receive("TTT2RequestHUDManagerFullStateUpdate", function(_, ply)
	MsgN("[TTT2][HUDManager] Player " .. ply:Nick() .. " requested full state update...")

	syncModelStringAttribute("forcedHUD", ply)
	syncModelStringAttribute("defaultHUD", ply)
	syncModelRestrictedHUDsAttribute(ply)
end)

-- User wants to change / use a HUD
net.Receive("TTT2RequestHUD", function(_, ply)
	local hudname = net.ReadString() -- new requested HUD
	local oldHUD = net.ReadString() -- current HUD as fallback
	local forced = HUDManager.GetModelValue("forcedHUD")

	MsgN("[TTT2][DEBUG] User " .. ply:Nick() .. " requested to change the HUD to " .. tostring(hudname) .. ", alternative: " .. tostring(oldHUD))

	if not forced then
		local restrictions = HUDManager.GetModelValue("restrictedHUDs") or {}
		local restricted = false

		for _, v in ipairs(restrictions) do
			if v == hudname then
				restricted = true
				break
			end
		end

		-- is the HUD restricted? Then check the second HUD
		if restricted then
			restricted = false
			hudname = oldHUD

			for _, v in ipairs(restrictions) do
				if v == hudname then
					restricted = true

					break
				end
			end
		end

		-- still restricted? Then take the default
		if restricted then
			hudname = HUDManager.GetModelValue("defaultHUD")
		end
	end

	local hudToSend = forced or hudname
	local hudToSendTbl = huds.GetStored(hudToSend)

	if not hudToSendTbl or hudToSendTbl.isAbstract then
		hudToSend = HUDManager.GetModelValue("defaultHUD") or "pure_skin"
	end

	MsgN("[TTT2][DEBUG] The user will receive the HUD: " .. hudToSend)

	net.Start("TTT2ReceiveHUD")
	net.WriteString(hudToSend)
	net.Send(ply)
end)

-- An admin wants to set the default HUD value
net.Receive("TTT2DefaultHUDRequest", function(_, ply)
	local HUDToSet = net.ReadString()
	local acceptedRequest = false

	if ply:IsAdmin() then
		if HUDToSet == "" then -- Reset the forcedHUD value, to allow users to have a different HUD
			HUDManager.SetModelValue("defaultHUD", "pure_skin")

			acceptedRequest = true
		else
			local hudtbl = huds.GetStored(HUDToSet)
			if hudtbl ~= nil then
				HUDManager.SetModelValue("defaultHUD", HUDToSet)

				acceptedRequest = true
			end
		end
	end

	net.Start("TTT2DefaultHUDResponse")
	net.WriteBool(acceptedRequest)
	net.WriteString(HUDToSet)
	net.Send(ply)
end)

-- An admin wants to set the forceHUD value
net.Receive("TTT2ForceHUDRequest", function(_, ply)
	local HUDToForce = net.ReadString()
	local acceptedRequest = false

	if ply:IsAdmin() then
		if HUDToForce == "" then -- Reset the forcedHUD value, to allow users to have a different HUD
			HUDManager.SetModelValue("forcedHUD", nil)

			acceptedRequest = true
		else
			local hudtbl = huds.GetStored(HUDToForce)
			if hudtbl ~= nil then
				HUDManager.SetModelValue("forcedHUD", HUDToForce)

				acceptedRequest = true
			end
		end
	end

	net.Start("TTT2ForceHUDResponse")
	net.WriteBool(acceptedRequest)
	net.WriteString(HUDToForce)
	net.Send(ply)
end)

-- An admin wants to change the restricted status for an HUD
net.Receive("TTT2RestrictHUDRequest", function(_, ply)
	local HUDToRestrict = net.ReadString()
	local shouldBeRestricted = net.ReadBool()
	local acceptedRequest = false

	if ply:IsAdmin() then
		local hudtbl = huds.GetStored(HUDToRestrict)
		if hudtbl ~= nil then
			local restrictedHUDs = HUDManager.GetModelValue("restrictedHUDs") or {}

			if shouldBeRestricted and not table.HasValue(restrictedHUDs, HUDToRestrict) then
				table.insert(restrictedHUDs, HUDToRestrict)
			elseif not shouldBeRestricted then
				table.RemoveByValue(restrictedHUDs, HUDToRestrict)
			end

			HUDManager.SetModelValue("restrictedHUDs", restrictedHUDs)

			acceptedRequest = true
		end
	end

	net.Start("TTT2RestrictHUDResponse")
	net.WriteBool(acceptedRequest)
	net.WriteString(HUDToRestrict)
	net.Send(ply)
end)
