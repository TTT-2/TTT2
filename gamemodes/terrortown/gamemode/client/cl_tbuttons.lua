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
        local admin = admin.IsAdmin(ply)
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
-- Runs the "ttt_use_tbutton" concommand to activate the traitor button
-- @return boolean whether the activation was successful
-- @realm client
function TBHUD:UseFocused()
    local buttonChecks = self.focus_but
        and IsValid(self.focus_but.ent)
        and self.focus_but.access
        and self.focus_stick >= CurTime()

    if buttonChecks then
        net.Start("TTT2ActivateTButton")
        net.WriteEntity(self.focus_but.ent)
        net.SendToServer()

        self.focus_but = nil

        return true
    else
        return false
    end
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

local tbut_normal = Material("vgui/ttt/ttt2_hand_line")
local tbut_focus = Material("vgui/ttt/ttt2_hand_filled")
local tbut_outline = Material("vgui/ttt/ttt2_hand_outline")

local size = 32
local mid = size * 0.5
local focus_range = 25

---
-- Draws the traitor buttons on the HUD
-- @param Player client This should be the local @{Player}
-- @realm client
function TBHUD:Draw(client)
    if self.buttons_count == 0 then
        return
    end

    -- we're doing slowish distance computation here, so lots of probably
    -- ineffective micro-optimization
    local plypos = client:GetPos()
    local midscreen_x = ScrW() * 0.5
    local midscreen_y = ScrH() * 0.5
    local pos, scrpos, d
    local focus_but
    local focus_d, focus_scrpos_x, focus_scrpos_y = 0, midscreen_x, midscreen_y
    local showToAdmins = GetGlobalBool("ttt2_tbutton_admin_show", false)

    -- draw icon on HUD for every button within range
    for _, val in pairs(self.buttons) do
        local ent = val.ent
        local teamAccess = val.overrideTeam
            or val.access
                and val.teamIntend ~= TEAM_NONE
                and val.overrideRole == nil
                and val.overrideTeam == nil
        local outlineColor = teamAccess and val.teamColor or val.roleColor or COLOR_BLACK

        if not IsValid(ent) or not ent.IsUsable then
            continue
        end

        pos = ent:GetPos()
        scrpos = pos:ToScreen()

        if util.IsOffScreen(scrpos) or not ent:IsUsable() then
            continue
        end

        local usableRange = ent:GetUsableRange()

        if not val.access and not showToAdmins then
            continue
        end

        d = pos - plypos
        d = d:Dot(d) / (usableRange * usableRange)

        -- draw if this button is within range, with alpha based on distance
        if d >= 1 then
            continue
        end

        local scrPosXMid, scrPosYMid = scrpos.x - mid, scrpos.y - mid

        if val.access then
            draw.FilteredTexture(
                scrPosXMid,
                scrPosYMid,
                size,
                size,
                tbut_normal,
                200 * (1 - d),
                COLOR_WHITE
            )
        end

        draw.FilteredTexture(
            scrPosXMid,
            scrPosYMid,
            size,
            size,
            tbut_outline,
            200 * (1 - d),
            outlineColor
        )

        if d <= focus_d then
            continue
        end

        local x = abs(scrpos.x - midscreen_x)
        local y = abs(scrpos.y - midscreen_y)

        if
            x >= focus_range
            or y >= focus_range
            or x >= focus_scrpos_x
            or y >= focus_scrpos_y
            or self.focus_stick >= CurTime()
                and (ent ~= (self.focus_but and self.focus_but.ent or nil))
        then
            continue
        end

        -- avoid constantly switching focus every frame causing
        -- 2+ buttons to appear in focus, instead "stick" to one
        -- ent for a very short time to ensure consistency
        focus_but = val

        -- draw extra graphics and information for button when it's in-focus
        if not focus_but or not IsValid(focus_but.ent) then
            continue
        end

        self.focus_but = focus_but
        self.focus_stick = CurTime() + 0.1

        scrpos = focus_but.ent:GetPos():ToScreen()
        scrPosXMid, scrPosYMid = scrpos.x - mid, scrpos.y - mid

        -- redraw in-focus version of icon
        draw.FilteredTexture(
            scrPosXMid - 3,
            scrPosYMid - 3,
            size + 6,
            size + 6,
            tbut_focus,
            200,
            COLOR_WHITE
        )
        draw.FilteredTexture(
            scrPosXMid - 3,
            scrPosYMid - 3,
            size + 6,
            size + 6,
            tbut_outline,
            150,
            outlineColor
        )
    end
end
