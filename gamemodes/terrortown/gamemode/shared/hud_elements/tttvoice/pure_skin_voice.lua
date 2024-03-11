--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
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

    function HUDELEMENT:DrawVoiceBar(ply, xPos, yPos, w, h)
        local color = ply:GetVoiceColor()

        draw.Box(xPos + 6, yPos + 6, w - 6, h - 12, color)
        self:DrawLines(xPos + 6, yPos + 6, w - 6, h - 12, color.a)

        local data = ply:GetFakeVoiceSpectrum(24)

        local widthBar = (w - h - 6) / #data - 1

        for i = 1, #data do
            local yValue = math.floor(data[i] * 15)

            draw.Box(
                xPos + h + 3 + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h - yValue - 1,
                widthBar,
                yValue,
                Color(255, 255, 255, 35)
            )
            if yValue > 1 then
                draw.Box(
                    xPos + h + 3 + (i - 1) * (widthBar + 1),
                    yPos + 0.5 * h - yValue - 2,
                    widthBar,
                    1,
                    Color(255, 255, 255, 140)
                )
            end

            draw.Box(
                xPos + h + 3 + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h,
                widthBar,
                1,
                Color(255, 255, 255, 175)
            )

            draw.Box(
                xPos + h + 3 + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h + 2,
                widthBar,
                yValue,
                Color(255, 255, 255, 35)
            )
            if yValue > 1 then
                draw.Box(
                    xPos + h + 3 + (i - 1) * (widthBar + 1),
                    yPos + 0.5 * h + 2 + yValue,
                    widthBar,
                    1,
                    Color(255, 255, 255, 140)
                )
            end
        end

        draw.FilteredTexture(
            xPos,
            yPos,
            h,
            h,
            draw.GetAvatarMaterial(ply:SteamID64(), "medium"),
            255,
            COLOR_WHITE
        )
        self:DrawLines(xPos, yPos, h, h, 255)

        draw.AdvancedText(
            ply:Nick(),
            "PureSkinPopupText",
            xPos + h + self.padding,
            yPos + h * 0.5 - 1,
            util.GetDefaultColor(color),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            true,
            self.scale
        )
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()

        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h

        local plys = player.GetAll()
        local plysSorted = {}

        for i = 1, #plys do
            local ply = plys[i]

            if not ply:IsSpeakingInVoice() then
                continue
            end

            if ply == client then
                table.insert(plysSorted, 1, ply)

                continue
            end

            plysSorted[#plysSorted + 1] = ply
        end

        for i = 1, #plysSorted do
            local ply = plys[i]

            self:DrawVoiceBar(ply, x, y, w, h)

            y = y + h + self.padding
        end
    end
end
