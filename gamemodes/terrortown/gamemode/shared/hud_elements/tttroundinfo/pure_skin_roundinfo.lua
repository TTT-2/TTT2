--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

HUDELEMENT.togglable = true
HUDELEMENT.disabledUnlessForced = true

if CLIENT then
    local GetLang = LANG.GetUnsafeLanguageTable

    local pad = 14

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 96, h = 72 },
        minsize = { w = 96, h = 72 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1.0
        self.basecolor = self:GetHUDBasecolor()
        self.pad = pad

        BaseClass.Initialize(self)
    end

    -- parameter overwrites
    function HUDELEMENT:IsResizable()
        return true, true
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] =
            { x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = 4 * self.scale }

        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        local defaults = self:GetDefaults()

        self.scale = math.min(self.size.w / defaults.minsize.w, self.size.h / defaults.minsize.h)
        self.basecolor = self:GetHUDBasecolor()
        self.pad = pad * self.scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local L = GetLang()
        local round_state = gameloop.GetRoundState()

        -- draw bg and shadow
        self:DrawBg(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor)

        -- draw haste / time
        -- Draw round time

        local isHaste = gameloop.IsHasteMode() and round_state == ROUND_ACTIVE
        local isOmniscient = not client:IsActive() or client:GetSubRoleData().isOmniscientRole
        local endtime = gameloop.GetPhaseEnd() - CurTime()
        local font = "PureSkinTimeLeft"
        local color = util.GetDefaultColor(self.basecolor)

        local tmpx = self.pos.x + self.size.w * 0.5
        local tmpy = self.pos.y + self.size.h * 0.5

        local rx = tmpx
        local ry = tmpy

        local vert_align_clock = TEXT_ALIGN_TOP

        -- Time displays differently depending on whether haste mode is on,
        -- whether the player is traitor or not, and whether it is overtime.
        if isHaste then
            local hastetime = gameloop.GetHasteEnd() - CurTime()
            if hastetime < 0 then
                if not isOmniscient or math.ceil(CurTime()) % 7 <= 2 then
                    -- innocent or blinking "overtime"
                    text = L.overtime
                    font = "PureSkinMSTACKMsg"

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
            vert_align_clock = TEXT_ALIGN_CENTER

            -- bog standard time when haste mode is off (or round not active)
            text = util.SimpleTime(math.max(0, endtime), "%02i:%02i")
        end

        draw.AdvancedText(
            text,
            font,
            rx,
            ry,
            color,
            TEXT_ALIGN_CENTER,
            vert_align_clock,
            true,
            self.scale
        )

        if isHaste then
            draw.AdvancedText(
                L.hastemode,
                "PureSkinMSTACKMsg",
                tmpx,
                self.pos.y + self.pad,
                util.GetDefaultColor(self.basecolor),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_TOP,
                true,
                self.scale
            )
        end

        -- draw lines around the element
        local border_pos, border_size = self:GetBorderParams()
        self:DrawLines(border_pos.x, border_pos.y, border_size.w, border_size.h, self.basecolor.a)
    end
end
