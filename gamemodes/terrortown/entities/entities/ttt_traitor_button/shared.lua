---
-- @class ENT
-- @desc Special button usable from range if your role has access to it
-- @section ttt_traitor_button

if SERVER then
    ---
    -- @realm server
    local cv_tbutton = CreateConVar(
        "ttt2_tbutton_admin_show",
        "0",
        { FCVAR_ARCHIVE, FCVAR_NOTIFY },
        "Always show the buttons to admins in range",
        0,
        1
    )

    hook.Add("TTT2SyncGlobals", "AddTButtonGlobals", function()
        SetGlobalBool(cv_tbutton:GetName(), cv_tbutton:GetBool())
    end)

    cvars.AddChangeCallback(cv_tbutton:GetName(), function(cv, old, new)
        SetGlobalBool(cv_tbutton:GetName(), tobool(tonumber(new)))
    end)
end

if CLIENT then
    net.Receive("TTT2SendTButtonConfig", function(len, ply)
        TButtonMapConfig = net.ReadTable()
        MapButtonEntIndexMapping = net.ReadTable()
        TBHUD:CacheEnts()
    end)

    hook.Add("TTTInitPostEntity", "TTT2TButtonsInitialize", function()
        net.Start("TTT2RequestTButtonConfig")
        net.SendToServer()
    end)
end

ENT.Type = "anim"
ENT.Base = "base_anim"

---
-- @realm shared
function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Delay")
    self:NetworkVar("Float", 1, "NextUseTime")
    self:NetworkVar("Bool", 0, "Locked")
    self:NetworkVar("String", 0, "Description")
    self:NetworkVar("String", 1, "Role")
    self:NetworkVar("String", 2, "Team")
    self:NetworkVar("Int", 0, "UsableRange", { KeyName = "UsableRange" })
end

---
-- @return boolean
-- @realm shared
function ENT:IsUsable()
    return not self:GetLocked() and self:GetNextUseTime() < CurTime()
end

---
-- Returns whether the player can use this specific button
-- @param Player ply Player
-- @return boolean access, overrideRole, overrideTeam, roleIntend, teamIntend
-- @realm shared
function ENT:PlayerRoleCanUse(ply)
    local role = self:GetRole()
    local team = self:GetTeam()
    local curRol = ply:GetRoleStringRaw()
    local curTeam = ply:GetTeam()
    local mapID = MapButtonEntIndexMapping and MapButtonEntIndexMapping[self:EntIndex()] or -1
    local overrideRole = nil
    local overrideTeam = nil

    if TButtonMapConfig and TButtonMapConfig[mapID] and TButtonMapConfig[mapID].Override then
        if TButtonMapConfig[mapID].Override.Role then
            overrideRole = TButtonMapConfig[mapID].Override.Role[curRol]
        end

        if TButtonMapConfig[mapID].Override.Team then
            overrideTeam = TButtonMapConfig[mapID].Override.Team[curTeam]
        end

        if overrideRole ~= nil or overrideTeam ~= nil then
            return overrideRole or (overrideRole ~= false and overrideTeam),
                overrideRole,
                overrideTeam,
                role,
                team
        end
    end

    if self:IsGeneric() then
        return ply:GetSubRoleData():CanUseTraitorButton(), overrideRole, overrideTeam, role, team
    else
        return (role == "none" or role == curRol) and (team == TEAM_NONE or team == curTeam),
            overrideRole,
            overrideTeam,
            role,
            team
    end
end

---
-- Returns whether this button was designed with a special role / team in mind or is just a generic button
-- @return boolean
-- @realm shared
function ENT:IsGeneric()
    local role = self:GetRole()
    local team = self:GetTeam()

    return role == "none" and team == TEAM_NONE
end
