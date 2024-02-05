--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local ParT = LANG.GetParamTranslation
    local TryT = LANG.TryTranslation

    local materialBlockingRevival = Material("vgui/ttt/hud_blocking_revival")

    local pad = 14
    local defaultHeight = 74

    local colorRevivingBar = Color(36, 154, 198)

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 321, h = defaultHeight },
        minsize = { w = 250, h = defaultHeight },
    }

    function HUDELEMENT:Initialize()
        self.pad = pad
        self.defaultHeight = defaultHeight
        self.basecolor = self:GetHUDBasecolor()

        BaseClass.Initialize(self)
    end

    -- parameter overwrites
    function HUDELEMENT:IsResizable()
        return true, false
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] =
            { x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = 0.5 * ScrH() + 100 }

        return const_defaults
    end

    function HUDELEMENT:ShouldDraw()
        local client = LocalPlayer()

        return HUDEditor.IsEditing or client:IsReviving()
    end

    function HUDELEMENT:PerformLayout()
        local scale = self:GetHUDScale()

        self.scale = scale
        self.basecolor = self:GetHUDBasecolor()
        self.pad = pad * scale
        self.defaultHeight = defaultHeight * scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h

        local timeLeft = HUDEditor.IsEditing and 1
            or math.ceil(
                math.max(
                    0,
                    client:GetRevivalDuration() - (CurTime() - client:GetRevivalStartTime())
                )
            )
        local progress = HUDEditor.IsEditing and 1
            or ((CurTime() - client:GetRevivalStartTime()) / client:GetRevivalDuration())

        local posHeaderY = y + self.pad
        local posBarY = posHeaderY + 20 * self.scale
        local barHeight = 26 * self.scale
        local iconPad = 5 * self.scale
        local iconSize = barHeight - 2 * iconPad
        local posReasonY = posBarY + barHeight + self.pad

        local revivalReasonLines = {}
        local lineHeight = 0

        if client:HasRevivalReason() then
            local rawRevivalReason = client:GetRevivalReason()

            local translatedText
            if rawRevivalReason.params then
                translatedText = ParT(rawRevivalReason.name, rawRevivalReason.params)
            else
                translatedText = TryT(rawRevivalReason.name)
            end

            local lines, _, textHeight =
                draw.GetWrappedText(translatedText, w - 2 * self.pad, "PureSkinBar", self.scale)

            revivalReasonLines = lines
            lineHeight = textHeight / #revivalReasonLines

            h = self.defaultHeight + textHeight + self.pad
        else
            h = self.defaultHeight
        end

        self:SetSize(w, h)

        -- draw bg and shadow
        self:DrawBg(x, y, w, h, self.basecolor)

        draw.AdvancedText(
            TryT("hud_revival_title"),
            "PureSkinBar",
            x + self.pad,
            posHeaderY,
            util.GetDefaultColor(self.basecolor),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            true,
            self.scale
        )

        draw.AdvancedText(
            ParT("hud_revival_time", { time = timeLeft }),
            "PureSkinBar",
            x + w - self.pad,
            posHeaderY,
            util.GetDefaultColor(self.basecolor),
            TEXT_ALIGN_RIGHT,
            TEXT_ALIGN_CENTER,
            true,
            self.scale
        )

        self:DrawBar(
            x + self.pad,
            posBarY,
            w - self.pad * 2,
            barHeight,
            colorRevivingBar,
            progress,
            1
        )

        if client:IsBlockingRevival() then
            draw.FilteredShadowedTexture(
                x + w - self.pad - iconSize - 4 * iconPad,
                posBarY + iconPad,
                iconSize,
                iconSize,
                materialBlockingRevival,
                255,
                COLOR_WHITE,
                self.scale
            )
        end

        for i = 1, #revivalReasonLines do
            draw.AdvancedText(
                revivalReasonLines[i],
                "PureSkinBar",
                x + self.pad,
                posReasonY + (i - 1) * lineHeight,
                util.GetDefaultColor(self.basecolor),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP,
                true,
                self.scale
            )
        end

        -- draw lines around the element
        self:DrawLines(x, y, w, h, self.basecolor.a)
    end
end
