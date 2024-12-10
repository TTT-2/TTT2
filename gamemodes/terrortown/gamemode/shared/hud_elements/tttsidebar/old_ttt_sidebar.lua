--- @ignore

-- item info
COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
    local TryT = LANG.TryTranslation

    local size = 64

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = size, h = -size },
        minsize = { w = size, h = size },
    }

    function HUDELEMENT:Initialize()
        BaseClass.Initialize(self)

        self.defaults.minWidth = size
        self.defaults.minHeight = size
        self.defaults.resizeableX = false
        self.defaults.resizeableY = false
    end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] = { x = 20, y = ScrH() * 0.5 }

        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        local basepos = self:GetBasePos()

        self:SetPos(basepos.x, basepos.y)
        self:SetSize(size, -size)

        BaseClass.PerformLayout(self)
    end

    local old_ttt_bg = Material("vgui/ttt/perks/old_ttt_bg.png")

    function HUDELEMENT:Draw()
        local client = LocalPlayer()

        if not client:Alive() or client:Team() ~= TEAM_TERROR then
            return
        end

        local basepos = self:GetBasePos()

        self:SetPos(basepos.x, basepos.y)

        local itms = client:GetEquipmentItems()
        local pos = self:GetPos()
        local curY = pos.y

        -- at first, calculate old items because they don't take care of the new ones
        for i = 1, #itms do
            local item = items.GetStored(itms[i])
            if not item or not item.oldHud then
                continue
            end

            curY = curY - 80
        end

        -- now draw our new items automatically
        for i = 1, #itms do
            local item = items.GetStored(itms[i])
            if not item or not item.hud then
                continue
            end

            surface.SetMaterial(old_ttt_bg)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(pos.x - 1, curY, size, size)

            draw.FilteredTexture(
                pos.x + 0.1 * size,
                curY + 0.1 * size,
                size - 0.2 * size,
                size - 0.2 * size,
                item.hud,
                175
            )

            if isfunction(item.DrawInfo) then
                local info = TryT(item:DrawInfo())
                if info then
                    -- right bottom corner
                    local tx = pos.x + size
                    local ty = curY + size
                    local pad = 5

                    surface.SetFont("ItemInfo")

                    local infoW, infoH = surface.GetTextSize(info)

                    draw.RoundedBox(
                        4,
                        tx - infoW * 0.5 - pad,
                        ty - infoH * 0.5,
                        infoW + pad * 2,
                        infoH,
                        COLOR_DARKGREY
                    )
                    draw.DrawText(
                        info,
                        "ItemInfo",
                        tx,
                        ty - infoH * 0.5,
                        COLOR_WHITE,
                        TEXT_ALIGN_CENTER
                    )
                end
            end

            curY = curY - (size + size * 0.25)
        end

        self:SetSize(size, curY - basepos.y)
    end
end
