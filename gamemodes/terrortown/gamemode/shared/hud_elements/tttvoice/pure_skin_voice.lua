--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local TryT = LANG.TryTranslation

    local padding = 10

    local baseDefaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 240, h = 48 },
        minsize = { w = 120, h = 48 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1.0
        self.basecolor = self:GetHUDBasecolor()
        self.padding = padding

        BaseClass.Initialize(self)
    end

    function HUDELEMENT:IsResizable()
        return true, false
    end

    function HUDELEMENT:GetDefaults()
        baseDefaults["basepos"] = {
            x = 10 * self.scale,
            y = 10 * self.scale,
        }

        return baseDefaults
    end

    function HUDELEMENT:PerformLayout()
        self.scale = appearance.GetGlobalScale()
        self.basecolor = self:GetHUDBasecolor()
        self.padding = padding * self.scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()

        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h

        draw.Box(x + 6, y + 6, w - 6, h - 12, INNOCENT.color)
        self:DrawLines(x + 6, y + 6, w - 6, h - 12, self.basecolor.a)

        local data = client:GetFakeVoiceSpectrum(24)

        local widthBar = (w - h - 6) / #data - 1

        for i = 1, #data do
            local yValue = math.floor(data[i] * 15)

            draw.Box(
                x + h + 3 + (i - 1) * (widthBar + 1),
                y + 0.5 * h - yValue - 1,
                widthBar,
                yValue,
                Color(255, 255, 255, 35)
            )
            if yValue > 1 then
                draw.Box(
                    x + h + 3 + (i - 1) * (widthBar + 1),
                    y + 0.5 * h - yValue - 2,
                    widthBar,
                    1,
                    Color(255, 255, 255, 140)
                )
            end

            draw.Box(
                x + h + 3 + (i - 1) * (widthBar + 1),
                y + 0.5 * h,
                widthBar,
                1,
                Color(255, 255, 255, 175)
            )

            draw.Box(
                x + h + 3 + (i - 1) * (widthBar + 1),
                y + 0.5 * h + 2,
                widthBar,
                yValue,
                Color(255, 255, 255, 35)
            )
            if yValue > 1 then
                draw.Box(
                    x + h + 3 + (i - 1) * (widthBar + 1),
                    y + 0.5 * h + 2 + yValue,
                    widthBar,
                    1,
                    Color(255, 255, 255, 140)
                )
            end
        end

        draw.FilteredTexture(
            x,
            y,
            h,
            h,
            draw.GetAvatarMaterial(client:SteamID64(), "medium"),
            255,
            COLOR_WHITE
        )
        self:DrawLines(x, y, h, h, 255)

        draw.AdvancedText(
            client:Nick(),
            "PureSkinPopupText",
            x + h + self.padding,
            y + h * 0.5 - 1,
            util.GetDefaultColor(INNOCENT.color),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            true,
            self.scale
        )
    end
end
