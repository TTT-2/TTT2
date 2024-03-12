---
-- Display of and interaction with ttt_traitor_button
-- @class TBHUD

local surface = surface
local pairs = pairs
local math = math
local abs = math.abs
local table = table
local net = net
local IsValid = IsValid
local TryT = LANG.TryTranslation
local ParT = LANG.GetParamTranslation

TBHUD = {}
TBHUD.buttons = {}
TBHUD.buttons_count = 0

TBHUD.focus_but = nil
TBHUD.focus_stick = 0

---
-- Clears the list of stored traitor buttons
-- @realm client
function TBHUD:Clear()
    self.buttons = {}
    self.buttons_count = 0

    self.focus_but = nil
    self.focus_stick = 0
end

---
-- Caches every available traitor button on the map for the local @{Player}
-- @realm client
function TBHUD:CacheEnts()
    local ply = LocalPlayer()
    self.buttons = {}

    if IsValid(ply) and ply:IsActive() then
        local admin = ply:IsAdmin()
        local team = ply:GetTeam()
        local btns = ents.FindByClass("ttt_traitor_button")

        for i = 1, #btns do
            local ent = btns[i]
            local access, overrideRole, overrideTeam, roleIntend, teamIntend =
                ent:PlayerRoleCanUse(ply)

            if not admin and not access then
                continue
            end

            self.buttons[ent:EntIndex()] = {
                ["ent"] = ent,
                ["access"] = access,
                ["overrideRole"] = overrideRole,
                ["overrideTeam"] = overrideTeam,
                ["roleIntend"] = roleIntend,
                ["teamIntend"] = teamIntend,
                ["admin"] = admin,
                ["roleColor"] = ply:GetRoleColor(),
                ["teamColor"] = TEAMS and TEAMS[team] and TEAMS[team].color or COLOR_BLACK,
            }
        end
    end

    self.buttons_count = table.Count(self.buttons)
end

---
-- Returns whether the local @{Player} is focussing a traitor button
-- @return boolean
-- @realm client
function TBHUD:PlayerIsFocused()
    local ply = LocalPlayer()

    return IsValid(ply)
        and ply:IsActive()
        and self.focus_but
        and (self.focus_but.access or self.focus_but.admin)
        and self.focus_stick >= CurTime()
        and IsValid(self.focus_but.ent)
end

---
-- Sends a request to server to change the access to the tbutton
-- @param boolean teamMode does this change apply to the current role or team
-- @return boolean whether the request was sent to server
-- @realm client
function TBHUD:ToggleFocused(teamMode)
    local buttonChecks = self.focus_but
        and IsValid(self.focus_but.ent)
        and self.focus_but.admin
        and self.focus_stick >= CurTime()
        and GetGlobalBool("ttt2_tbutton_admin_show", false)

    if buttonChecks then
        net.Start("TTT2ToggleTButton")
        net.WriteEntity(self.focus_but.ent)
        net.WriteBool(teamMode)
        net.SendToServer()

        self.focus_but = nil

        return true
    else
        return false
    end
end

local confirm_sound = Sound("buttons/button24.wav")

---
-- Plays a sound and caches all traitor buttons
-- @realm client
function TBHUD.ReceiveUseConfirm()
    surface.PlaySound(confirm_sound)

    TBHUD:CacheEnts()
end
net.Receive("TTT_ConfirmUseTButton", TBHUD.ReceiveUseConfirm)

local tbut_normal = Material("vgui/ttt/ttt2_hand_filled")

-- Handle markervision for ttt_traitor_button
hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionTraitorButton", function(mvData)
    local ent = mvData:GetEntity()
    local mvObject = mvData:GetMarkerVisionObject()
    local client = LocalPlayer()

    if
        not mvObject:IsObjectFor(ent, "ttt_traitor_button")
        or mvData:GetEntityDistance() > ent:GetUsableRange()
        or not ent:PlayerRoleCanUse(client)
        or not ent:IsUsable()
    then
        return
    end

    local teamAccess = ent.overrideTeam
        or ent.access
            and ent.teamIntend ~= TEAM_NONE
            and ent.overrideRole == nil
            and ent.overrideTeam == nil
    local outlineColor = teamAccess and ent.teamColor or ent.roleColor or COLOR_WHITE

    mvData:EnableText()
    mvData:SetTitle(ent:GetDescription() == "?" and "Traitor Button" or TryT(ent:GetDescription()))

    mvData:AddIcon(tbut_normal, outlineColor)

    mvData:SetSubtitle(ParT("tbut_help", { usekey = Key("+use", "USE") }))

    local delay = ent:GetDelay()
    -- add description time with some general info about this specific traitor button
    if delay < 0 then
        mvData:AddDescriptionLine(TryT("tbut_single"), client:GetRoleColor())
    elseif delay == 0 then
        mvData:AddDescriptionLine(TryT("tbut_reuse"), client:GetRoleColor())
    else
        mvData:AddDescriptionLine(ParT("tbut_retime", { num = delay }), client:GetRoleColor())
    end
end)
