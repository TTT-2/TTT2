--- @ignore

local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local ParT = LANG.GetParamTranslation
    local TryT = LANG.TryTranslation

    local materialBlockingRevival = Material("vgui/ttt/hud_blocking_revival")

    local pad = 14
    local defaultHeight = 74

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 321, h = defaultHeight },
        minsize = { w = 250, h = defaultHeight },
    }

    function HUDELEMENT:Initialize()
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
        defaultHeight = defaultHeight

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

        local posHeaderY = y + pad
        local posBarY = posHeaderY + 20
        local barHeight = 26
        local iconPad = 5
        local iconSize = barHeight - 2 * iconPad
        local posReasonY = posBarY + barHeight + pad

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
                draw.GetWrappedText(translatedText, w - 2 * pad, "HealthAmmo")

            revivalReasonLines = lines
            lineHeight = textHeight / #revivalReasonLines

            h = defaultHeight + textHeight + pad
        else
            h = defaultHeight
        end

        -- draw bg and shadow
        draw.RoundedBox(8, x, y, w, h, self.bg_colors.background_main)

        self:ShadowedText(
            TryT("hud_revival_title"),
            "HealthAmmo",
            x + pad,
            posHeaderY,
            COLOR_WHITE,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        self:ShadowedText(
            ParT("hud_revival_time", { time = timeLeft }),
            "HealthAmmo",
            x + w - pad,
            posHeaderY,
            COLOR_WHITE,
            TEXT_ALIGN_RIGHT,
            TEXT_ALIGN_CENTER
        )

        self:PaintBar(x + pad, posBarY, w - pad * 2, barHeight, self.sprint_colors, progress)

        if client:IsBlockingRevival() then
            draw.FilteredShadowedTexture(
                x + w - pad - iconSize - 4 * iconPad,
                posBarY + iconPad,
                iconSize,
                iconSize,
                materialBlockingRevival,
                255,
                COLOR_WHITE
            )
        end

        for i = 1, #revivalReasonLines do
            self:ShadowedText(
                revivalReasonLines[i],
                "HealthAmmo",
                x + pad,
                posReasonY + (i - 1) * lineHeight,
                COLOR_WHITE,
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_TOP
            )
        end
    end
end
