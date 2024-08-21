--- @ignore

local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp
local IsValid = IsValid
local draw = draw

local base = "pure_skin_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

if CLIENT then
    local pad = 7
    local margin = 14

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 200, h = 40 },
        minsize = { w = 100, h = 40 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1.0
        self.basecolor = self:GetHUDBasecolor()

        self.pad = pad
        self.margin = margin

        self.cv_ttt_spectator_mode = GetConVar("ttt_spectator_mode")

        BaseClass.Initialize(self)
    end

    -- parameter overwrites
    function HUDELEMENT:IsResizable()
        return true, false
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] =
            { x = ScrW() * 0.5 - self.size.w * 0.5, y = ScrH() - 120 * self.scale }

        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        self.scale = appearance.GetGlobalScale()
        self.basecolor = self:GetHUDBasecolor()
        self.pad = pad * self.scale
        self.margin = margin * self.scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:ShouldDraw()
        local client = LocalPlayer()
        local tgt = client:GetObserverTarget()

        return client:IsSpec()
            and IsValid(tgt)
            and not tgt:IsPlayer()
            and tgt:GetNWEntity("spec_owner", nil) == client
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local L = GetLang()
        local punch = client:GetNWFloat("specpunches", 0)
        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h

        self:DrawBg(x, y, w, h, self.basecolor)
        self:DrawBar(
            x + self.pad,
            y + self.pad,
            w - self.pad * 2,
            h - self.pad * 2,
            COLOR_SPEC,
            punch,
            self.scale,
            L.punch_title
        )
        self:DrawLines(x, y, w, h, self.basecolor.a)

        local bonus = client:GetNWInt("bonuspunches", 0)
        if bonus ~= 0 then
            local text

            if bonus < 0 then
                text = interp(L.punch_bonus, { num = bonus })
            else
                text = interp(L.punch_malus, { num = bonus })
            end

            draw.AdvancedText(
                text,
                "TabLarge",
                x + w * 0.5,
                y + self.margin * 2 + 20,
                util.GetDefaultColor(self.basecolor),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                true,
                self.scale
            )
        end
    end
end
