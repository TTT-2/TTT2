--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local padding = 6

    local colorVoiceBar = Color(255, 255, 255, 35)
    local colorVoiceLine = Color(255, 255, 255, 140)
    local colorVoiceDevider = Color(255, 255, 255, 175)

    local baseDefaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 240, h = 42 },
        minsize = { w = 120, h = 42 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1.0
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
        self.padding = padding * self.scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:DrawVoiceBar(ply, xPos, yPos, w, h)
        local color = VOICE.GetVoiceColor(ply)
        local data = VOICE.GetFakeVoiceSpectrum(ply, 24)

        local widthBar = (w - h - self.padding) / #data - 1
        local heightBar = h - 2 * self.padding
        local wNick = w - h - self.padding

        local offset = 3 * self.scale
        local heightBatteryBar = 2 * self.scale

        draw.Box(xPos + self.padding, yPos + self.padding, w - self.padding, heightBar, color)

        self:DrawLines(
            xPos + self.padding,
            yPos + self.padding,
            w - self.padding,
            heightBar,
            color.a
        )

        for i = 1, #data do
            local yValue = math.floor(data[i] * 0.5 * heightBar - 4 * self.scale)

            draw.Box(
                xPos + h + offset + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h - yValue - 1,
                widthBar,
                yValue,
                colorVoiceBar
            )
            if yValue > 1 then
                draw.Box(
                    xPos + h + offset + (i - 1) * (widthBar + 1),
                    yPos + 0.5 * h - yValue - 2,
                    widthBar,
                    self.scale,
                    colorVoiceLine
                )
            end

            draw.Box(
                xPos + h + offset + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h,
                widthBar,
                self.scale,
                colorVoiceDevider
            )

            draw.Box(
                xPos + h + offset + (i - 1) * (widthBar + 1),
                yPos + 0.5 * h + 2,
                widthBar,
                yValue,
                colorVoiceBar
            )
            if yValue > 1 then
                draw.Box(
                    xPos + h + offset + (i - 1) * (widthBar + 1),
                    yPos + 0.5 * h + 2 + yValue,
                    widthBar,
                    self.scale,
                    colorVoiceLine
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
            ply:NickElliptic(wNick, "PureSkinPopupText", self.scale),
            "PureSkinPopupText",
            xPos + h + self.padding,
            yPos + h * 0.5 - 1,
            util.GetDefaultColor(color),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            true,
            self.scale
        )

        if
            voicebattery.IsEnabled()
            and ply == LocalPlayer()
            and VOICE.GetVoiceMode(ply) == VOICE_MODE_GLOBAL
        then
            draw.Box(
                xPos + h,
                yPos + h - self.padding - heightBatteryBar,
                w - h,
                heightBatteryBar,
                colorVoiceBar
            )

            draw.Box(
                xPos + h,
                yPos + h - self.padding - heightBatteryBar,
                voicebattery.GetChargePercent() * (w - h),
                heightBatteryBar,
                colorVoiceLine
            )
        end
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

            if not VOICE.IsSpeaking(ply) then
                continue
            end

            if ply == client then
                table.insert(plysSorted, 1, ply)

                continue
            end

            plysSorted[#plysSorted + 1] = ply
        end

        for i = 1, #plysSorted do
            local ply = plysSorted[i]

            self:DrawVoiceBar(ply, x, y, w, h)

            y = y + h + self.padding
        end
    end
end
