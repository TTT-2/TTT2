---
-- @module HUDManager

util.AddNetworkString("TTT2RequestHUD")
util.AddNetworkString("TTT2ReceiveHUD")
util.AddNetworkString("TTT2DefaultHUDRequest")
util.AddNetworkString("TTT2ForceHUDRequest")
util.AddNetworkString("TTT2RestrictHUDRequest")

local HUD_MANAGER_SQL_TABLE = "ttt2_hudmanager_model_data"
local HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE = "ttt2_hudmanager_model_data_restrictedhuds"

HUDManager = {}

--
-- DB HELPER FUNCTIONS
--

local function DB_EnsureTableExists(tablename, tablecolumns)
    if not tablename or not tablecolumns then
        return false
    end

    if not sql.TableExists(tablename) then
        local result = sql.Query(
            "CREATE TABLE " .. sql.SQLStr(tablename, false) .. " (" .. tablecolumns .. ")"
        )
        if result == false then
            return false
        end
    end

    return true
end

local function DB_GetStringValue(key)
    if DB_EnsureTableExists(HUD_MANAGER_SQL_TABLE, "key TEXT PRIMARY KEY, value TEXT") then
        local result = sql.Query(
            "SELECT * FROM " .. HUD_MANAGER_SQL_TABLE .. " WHERE key = " .. sql.SQLStr(key, false)
        )

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

            for i = 1, #res do
                tab[i] = res[i].name
            end

            return tab
        end
    end

    return nil
end

--
-- STORE/LOAD FUNCTIONS
--

---
-- Stores the data into a defined SQL table
-- @realm server
-- @internal
function HUDManager.StoreData()
    Dev(1, "[TTT2][HUDManager] Storing data in database...")

    if DB_EnsureTableExists(HUD_MANAGER_SQL_TABLE, "key TEXT PRIMARY KEY, value TEXT") then
        sql.Query(
            "INSERT OR REPLACE INTO "
                .. HUD_MANAGER_SQL_TABLE
                .. " VALUES('forcedHUD', "
                .. sql.SQLStr(ttt2net.GetGlobal({ "hud_manager", "forcedHUD" }))
                .. ")"
        )
        sql.Query(
            "INSERT OR REPLACE INTO "
                .. HUD_MANAGER_SQL_TABLE
                .. " VALUES('defaultHUD', "
                .. sql.SQLStr(ttt2net.GetGlobal({ "hud_manager", "defaultHUD" }))
                .. ")"
        )
    end

    -- delete the table to recreate it again, to remove all values that might have been removed from the table
    sql.DropTable(HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE)

    if DB_EnsureTableExists(HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE, "name TEXT PRIMARY KEY") then
        local restrictedHuds = ttt2net.GetGlobal({ "hud_manager", "restrictedHUDs" })

        for i = 1, #restrictedHuds do
            sql.Query(
                "INSERT INTO "
                    .. HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE
                    .. " VALUES("
                    .. sql.SQLStr(restrictedHuds[i])
                    .. ")"
            )
        end
    end
end

---
-- Loads the data from a defined SQL table
-- @realm server
-- @internal
function HUDManager.LoadData()
    Dev(1, "[TTT2][HUDManager] Loading data from database...")

    ttt2net.SetGlobal(
        { "hud_manager", "forcedHUD" },
        { type = "string" },
        DB_GetStringValue("forcedHUD")
    )
    ttt2net.SetGlobal(
        { "hud_manager", "defaultHUD" },
        { type = "string" },
        DB_GetStringValue("defaultHUD") or "pure_skin"
    )
    ttt2net.SetGlobal(
        { "hud_manager", "restrictedHUDs" },
        { type = "table" },
        DB_GetStringTable(HUD_MANAGER_SQL_RESTRICTEDHUDS_TABLE) or {}
    )
end

-- load values from the database when this file is executed
HUDManager.LoadData()

--
-- HUDManager commands / requests from clients
--

-- User wants to change / use a HUD
net.Receive("TTT2RequestHUD", function(_, ply)
    local hudname = net.ReadString() -- new requested HUD
    local oldHUD = net.ReadString() -- current HUD as fallback
    local forced = ttt2net.GetGlobal({ "hud_manager", "forcedHUD" })

    if not forced then
        local restrictions = ttt2net.GetGlobal({ "hud_manager", "restrictedHUDs" }) or {}
        local restricted = false

        for i = 1, #restrictions do
            if restrictions[i] == hudname then
                restricted = true

                break
            end
        end

        -- is the HUD restricted? Then check the second HUD
        if restricted then
            restricted = false
            hudname = oldHUD

            for i = 1, #restrictions do
                if restrictions[i] == hudname then
                    restricted = true

                    break
                end
            end
        end

        -- still restricted? Then take the default
        if restricted then
            hudname = ttt2net.GetGlobal({ "hud_manager", "defaultHUD" })
        end
    end

    local hudToSend = forced or hudname
    local hudToSendTbl = huds.GetStored(hudToSend)

    if not hudToSendTbl or hudToSendTbl.isAbstract then
        hudToSend = ttt2net.GetGlobal({ "hud_manager", "defaultHUD" }) or "pure_skin"
    end

    net.Start("TTT2ReceiveHUD")
    net.WriteString(hudToSend)
    net.Send(ply)
end)

-- An admin wants to set the default HUD value
net.Receive("TTT2DefaultHUDRequest", function(_, ply)
    local HUDToSet = net.ReadString()
    local acceptedRequest = false

    if admin.IsAdmin(ply) then
        if HUDToSet == "" then -- Reset the forcedHUD value, to allow users to have a different HUD
            ttt2net.SetGlobal({ "hud_manager", "defaultHUD" }, { type = "string" }, "pure_skin")

            acceptedRequest = true
        else
            local hudtbl = huds.GetStored(HUDToSet)
            if hudtbl ~= nil then
                ttt2net.SetGlobal({ "hud_manager", "defaultHUD" }, { type = "string" }, HUDToSet)

                acceptedRequest = true
            end
        end

        HUDManager.StoreData()
        HUDManager.LoadData()
    end

    if not acceptedRequest then
        LANG.Msg(ply, "hud_default_failed", { hudname = HUDToSet }, MSG_CHAT_PLAIN)
    end
end)

-- An admin wants to set the forceHUD value
net.Receive("TTT2ForceHUDRequest", function(_, ply)
    local HUDToForce = net.ReadString()
    local acceptedRequest = false

    if admin.IsAdmin(ply) then
        if HUDToForce == "" then -- Reset the forcedHUD value, to allow users to have a different HUD
            ttt2net.SetGlobal({ "hud_manager", "forcedHUD" }, { type = "string" }, nil)

            acceptedRequest = true
        else
            local hudtbl = huds.GetStored(HUDToForce)
            if hudtbl ~= nil then
                ttt2net.SetGlobal({ "hud_manager", "forcedHUD" }, { type = "string" }, HUDToForce)

                acceptedRequest = true
            end
        end

        HUDManager.StoreData()
    end

    if not acceptedRequest then
        LANG.Msg(ply, "hud_forced_failed", { hudname = HUDToForce }, MSG_CHAT_PLAIN)
    end
end)

-- An admin wants to change the restricted status for an HUD
net.Receive("TTT2RestrictHUDRequest", function(_, ply)
    local HUDToRestrict = net.ReadString()
    local shouldBeRestricted = net.ReadBool()
    local acceptedRequest = false

    if admin.IsAdmin(ply) then
        local hudtbl = huds.GetStored(HUDToRestrict)
        if hudtbl ~= nil then
            local restrictedHUDs = ttt2net.GetGlobal({ "hud_manager", "restrictedHUDs" }) or {}

            if shouldBeRestricted and not table.HasValue(restrictedHUDs, HUDToRestrict) then
                restrictedHUDs[#restrictedHUDs + 1] = HUDToRestrict
            elseif not shouldBeRestricted then
                table.RemoveByValue(restrictedHUDs, HUDToRestrict)
            end

            ttt2net.SetGlobal(
                { "hud_manager", "restrictedHUDs" },
                { type = "table" },
                table.Copy(restrictedHUDs)
            )

            HUDManager.StoreData()

            acceptedRequest = true
        end
    end

    if not acceptedRequest then
        LANG.Msg(ply, "hud_restricted_failed", { hudname = HUDToRestrict }, MSG_CHAT_PLAIN)
    end
end)
