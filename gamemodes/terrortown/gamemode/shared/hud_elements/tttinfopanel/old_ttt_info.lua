local draw = draw
local math = math
local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local util = util

local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local x = 0
    local y = 0

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = HUDELEMENT.maxwidth, h = HUDELEMENT.maxheight },
        minsize = { w = HUDELEMENT.maxwidth, h = HUDELEMENT.maxheight },
    }

    ---
    -- @ignore
    function HUDELEMENT:Initialize()
        BaseClass.Initialize(self)
    end

    ---
    -- @ignore
    function HUDELEMENT:GetDefaults()
        const_defaults["size"] = { w = self.maxwidth, h = self.maxheight }
        const_defaults["minsize"] = { w = self.maxwidth, h = self.maxheight }
        const_defaults["basepos"] = { x = self.margin, y = ScrH() - (self.margin + self.maxheight) }

        return const_defaults
    end

    ---
    -- @ignore
    function HUDELEMENT:PerformLayout()
        local pos = self:GetPos()

        x = pos.x
        y = pos.y

        BaseClass.PerformLayout(self)
    end

    ---
    -- Draws the old role icon
    -- @param number xPos
    -- @param number yPos
    -- @param number wSize width
    -- @param number hSize height
    -- @param Material iconMat the role icon
    -- @param Color col
    -- @realm client
    local function DrawOldRoleIcon(xPos, yPos, wSize, hSize, iconMat, col)
        local base_mat = Material("vgui/ttt/dynamic/base")
        local base_overlay = Material("vgui/ttt/dynamic/base_overlay")

        surface.SetDrawColor(col.r, col.g, col.b, col.a)
        surface.SetMaterial(base_mat)
        surface.DrawTexturedRect(xPos, yPos, wSize, hSize)

        surface.SetDrawColor(col.r, col.g, col.b, col.a)
        surface.SetMaterial(base_overlay)
        surface.DrawTexturedRect(xPos, yPos, wSize, hSize)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(iconMat)
        surface.DrawTexturedRect(xPos, yPos, wSize, hSize)
    end

    ---
    -- @ignore
    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local L = GetLang()

        local maxwidth = self.maxwidth
        local width = maxwidth
        local height = self.maxheight
        local margin = self.margin

        if client:Alive() and client:Team() == TEAM_TERROR then
            self:DrawBg(x, y, width, height, client)

            local bar_height = 25
            local bar_width = width - self.dmargin

            -- Draw health
            local health = math.max(0, client:Health())
            local health_y = y + margin
            local health_string = health

            if GetGlobalBool("ttt_armor_dynamic", false) and client:GetArmor() > 0 then
                health_string = health_string .. " + " .. client:GetArmor()
            end

            self:PaintBar(
                x + margin,
                health_y,
                bar_width,
                bar_height,
                self.health_colors,
                health / client:GetMaxHealth()
            )
            self:ShadowedText(
                health_string,
                "HealthAmmo",
                x + bar_width,
                health_y,
                COLOR_WHITE,
                TEXT_ALIGN_RIGHT,
                TEXT_ALIGN_RIGHT
            )

            -- Draw ammo
            local ammo_y = health_y + bar_height + margin
            if client:GetActiveWeapon().Primary then
                local ammo_clip, ammo_max, ammo_inv = self:GetAmmo(client)

                if ammo_clip ~= -1 then
                    local text = string.format("%i + %02i", ammo_clip, ammo_inv)

                    self:PaintBar(
                        x + margin,
                        ammo_y,
                        bar_width,
                        bar_height,
                        self.ammo_colors,
                        ammo_clip / ammo_max
                    )
                    self:ShadowedText(
                        text,
                        "HealthAmmo",
                        x + bar_width,
                        ammo_y,
                        COLOR_WHITE,
                        TEXT_ALIGN_RIGHT,
                        TEXT_ALIGN_RIGHT
                    )
                end
            end

            -- sprint bar
            local sbh = 8 -- spring bar height

            if SPRINT.convars.enabled:GetBool() then
                self:PaintBar(
                    x + margin,
                    ammo_y + bar_height + 5,
                    bar_width,
                    sbh,
                    self.sprint_colors,
                    client:GetSprintStamina()
                )
            end

            local hastewidth = self.hastewidth
            local bgheight = self.bgheight
            local smargin = self.smargin
            local tmp = width - hastewidth - bgheight - smargin * 2

            -- Draw the current role
            local round_state = gameloop.GetRoundState()
            local traitor_y = y - 30
            local text

            if round_state == ROUND_ACTIVE then
                text = L[client:GetSubRoleData().name]
            else
                text = L[self.roundstate_string[round_state]]
            end

            self:ShadowedText(
                text,
                "TraitorState",
                x + tmp * 0.5,
                traitor_y,
                COLOR_WHITE,
                TEXT_ALIGN_CENTER
            )

            -- Draw team icon
            local team = client:GetTeam()

            if team ~= TEAM_NONE and round_state == ROUND_ACTIVE and not TEAMS[team].alone then
                local t = TEAMS[team]

                if t.iconMaterial then
                    DrawOldRoleIcon(
                        x + tmp + smargin,
                        traitor_y,
                        bgheight,
                        bgheight,
                        t.iconMaterial,
                        t.color or COLOR_BLACK
                    )
                end
            end

            -- Draw round time
            local isHaste = gameloop.IsHasteMode() and round_state == ROUND_ACTIVE
            local isOmniscient = client:IsActive() and client:GetSubRoleData().isOmniscientRole
            local endtime = gameloop.GetPhaseEnd() - CurTime()
            local font = "TimeLeft"
            local color = COLOR_WHITE

            tmp = width + x - hastewidth + smargin + hastewidth * 0.5

            local rx = tmp
            local ry = traitor_y + 3

            -- Time displays differently depending on whether haste mode is on,
            -- whether the player is traitor or not, and whether it is overtime.
            if isHaste then
                local hastetime = gameloop.GetHasteEnd() - CurTime()
                if hastetime < 0 then
                    if not isOmniscient or math.ceil(CurTime()) % 7 <= 2 then
                        -- innocent or blinking "overtime"
                        text = L.overtime
                        font = "Trebuchet18"

                        -- need to hack the position a little because of the font switch
                        ry = ry + 5
                        rx = rx - 3
                    else
                        -- traitor and not blinking "overtime" right now, so standard endtime display
                        text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
                        color = COLOR_RED
                    end
                else
                    -- still in starting period
                    local t = hastetime

                    if isOmniscient and math.ceil(CurTime()) % 6 < 2 then
                        t = endtime
                        color = COLOR_RED
                    end

                    text = util.SimpleTime(math.max(0, t), "%02i:%02i")
                end
            else
                -- bog standard time when haste mode is off (or round not active)
                text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
            end

            self:ShadowedText(text, font, rx, ry, color, TEXT_ALIGN_CENTER)

            if isHaste then
                draw.SimpleText(
                    L.hastemode,
                    "TabLarge",
                    tmp,
                    traitor_y - 8,
                    COLOR_WHITE,
                    TEXT_ALIGN_CENTER
                )
            end
        else
            -- Draw round state
            local smargin = self.smargin
            local hastewidth = self.hastewidth
            local bg_colors = self.bg_colors
            local round_y = y + height - self.bgheight
            local screenwidth = ScrW()

            height = self.bgheight

            -- move up a little on low resolutions to allow space for spectator hints
            if screenwidth < 1000 then
                round_y = round_y - 15
            end

            local time_x = width - hastewidth
            local time_y = round_y + 4

            draw.RoundedBox(8, x, round_y, width, height, bg_colors.background_main)
            draw.RoundedBox(8, x, round_y, time_x, height, bg_colors.noround)

            -- Draw current round state
            local text = L[self.roundstate_string[gameloop.GetRoundState()]]

            self:ShadowedText(
                text,
                "TraitorState",
                x + (width - hastewidth) * 0.5,
                round_y,
                COLOR_WHITE,
                TEXT_ALIGN_CENTER
            )

            -- Draw round/prep/post time remaining
            text = util.SimpleTime(math.max(0, gameloop.GetPhaseEnd() - CurTime()), "%02i:%02i")

            self:ShadowedText(
                text,
                "TimeLeft",
                x + time_x + smargin + hastewidth * 0.5,
                time_y,
                COLOR_WHITE,
                TEXT_ALIGN_CENTER
            )

            -- Draw name of spectated player
            local tgt = client:GetObserverTarget()
            if IsValid(tgt) and tgt:IsPlayer() then
                self:ShadowedText(
                    tgt:Nick(),
                    "TimeLeft",
                    screenwidth / 2,
                    margin,
                    COLOR_WHITE,
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_TOP
                )
            end
        end
    end
end
