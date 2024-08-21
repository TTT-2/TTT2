--- @ignore

local draw = draw
local surface = surface
local math = math

local base = "base_stacking_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local width = 200
    local height = 20
    local font = "DefaultBold"
    local bordersize = 8

    HUDELEMENT.margin = 10
    HUDELEMENT.barcorner = surface.GetTextureID("gui/corner8")
    HUDELEMENT.PickupHistoryTop = ScrH() * 0.5

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 200, h = -height },
        minsize = { w = 200, h = height },
    }

    function HUDELEMENT:Initialize()
        BaseClass.Initialize(self)
    end

    function HUDELEMENT:IsResizable()
        return true, false
    end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] = { x = ScrW() - width - 20, y = ScrH() * 0.5 }

        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:DrawBar(x, y, w, h, tipSize, alpha, item)
        local client = LocalPlayer()
        local pad = 10

        draw.RoundedBox(8, x, y, w, h, Color(20, 20, 20, math.Clamp(alpha, 0, 200)))
        surface.SetTexture(self.barcorner)

        local tipColor

        if client:IsActive() then
            tipColor = client:GetRoleColor()
        else
            tipColor = COLOR_SPEC
        end

        surface.SetDrawColor(tipColor.r, tipColor.g, tipColor.b, alpha)
        surface.DrawTexturedRectRotated(
            x + bordersize * 0.5,
            y + bordersize * 0.5,
            bordersize,
            bordersize,
            0
        )
        surface.DrawTexturedRectRotated(
            x + bordersize * 0.5,
            y + h - bordersize * 0.5,
            bordersize,
            bordersize,
            90
        )
        surface.DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
        surface.DrawRect(x + bordersize, y, tipSize, h)

        draw.SimpleText(
            item.name,
            font,
            x + tipSize + bordersize + pad + 2,
            y + h * 0.5 + 2,
            Color(0, 0, 0, alpha * 0.75),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )
        draw.SimpleText(
            item.name,
            font,
            x + tipSize + bordersize + pad,
            y + h * 0.5,
            Color(255, 255, 255, alpha),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )

        if item.amount then
            draw.SimpleText(
                item.amount,
                font,
                x + w - pad,
                y + h * 0.5 + 2,
                Color(0, 0, 0, alpha * 0.75),
                TEXT_ALIGN_RIGHT,
                TEXT_ALIGN_CENTER
            )
            draw.SimpleText(
                item.amount,
                font,
                x + w - pad,
                y + h * 0.5,
                Color(255, 255, 255, alpha),
                TEXT_ALIGN_RIGHT,
                TEXT_ALIGN_CENTER
            )
        end
    end

    function HUDELEMENT:ShouldDraw()
        return PICKUP.items ~= nil or HUDEditor.IsEditing
    end

    function HUDELEMENT:Draw()
        local pickupList = {}

        for k, v in pairs(PICKUP.items) do
            if v.time >= CurTime() then
                continue
            end

            pickupList[#pickupList + 1] = { h = 20 }
        end

        self:SetElements(pickupList)
        self:SetElementMargin(self.margin)

        BaseClass.Draw(self)

        PICKUP.RemoveOutdatedValues()
    end

    function HUDELEMENT:DrawElement(i, x, y, w, h)
        local item = PICKUP.items[i]

        local alpha = 255
        local delta = (item.time + item.holdtime - CurTime()) / item.holdtime

        if delta > 1 - item.fadein then
            alpha = math.Clamp((1.0 - delta) * (255 / item.fadein), 1, 255)
        elseif delta < item.fadeout then
            alpha = math.Clamp(delta * (255 / item.fadeout), 0, 255)
        end

        local shiftX = x + w - self.size.w * (alpha / 255)
        local tipSize = h - 10

        self:DrawBar(shiftX, y, w, h, tipSize, alpha, item)

        --mark item for removal
        if alpha == 0 then
            item.remove = true
        end
    end
end
