--- @ignore

local string = string
local GetLang = LANG.GetUnsafeLanguageTable
local interp = string.Interp
local IsValid = IsValid
local draw = draw

local base = "old_ttt_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

if CLIENT then
    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 0, h = 0 },
        minsize = { w = 0, h = 0 },
    }

    function HUDELEMENT:Initialize()
        self.cv_ttt_spectator_mode = GetConVar("ttt_spectator_mode")

        BaseClass.Initialize(self)
    end

    function HUDELEMENT:GetDefaults()
        return const_defaults
    end

    -- Paint punch-o-meter
    local function PunchPaint(el, client)
        local L = GetLang()
        local punch = client:GetNWFloat("specpunches", 0)
        local width, height = 200, 25
        local x = ScrW() * 0.5 - width * 0.5
        local y = ScrH() - 120

        el:PaintBar(x, y, width, height, el.ammo_colors, punch)

        local color = el.bg_colors.background_main

        draw.SimpleText(L.punch_title, "HealthAmmo", ScrW() * 0.5, y, color, TEXT_ALIGN_CENTER)

        local bonus = client:GetNWInt("bonuspunches", 0)
        if bonus ~= 0 then
            local text

            if bonus < 0 then
                text = interp(L.punch_bonus, { num = bonus })
            else
                text = interp(L.punch_malus, { num = bonus })
            end

            draw.SimpleText(text, "TabLarge", ScrW() * 0.5, y * 2, COLOR_WHITE, TEXT_ALIGN_CENTER)
        end
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local tgt = client:GetObserverTarget()

        if
            not client:IsSpec()
            or not IsValid(tgt)
            or tgt:IsPlayer()
            or tgt:GetNWEntity("spec_owner", nil) ~= client
        then
            return
        end

        PunchPaint(self, client)
    end
end
