--- @ignore

local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 0, h = 45 },
        minsize = { w = 0, h = 45 },
    }

    function HUDELEMENT:PreInitialize()
        BaseClass.PreInitialize(self)

        hudelements.RegisterChildRelation(self.id, "old_ttt_info", false)
    end

    function HUDELEMENT:Initialize()
        BaseClass.Initialize(self)
    end

    function HUDELEMENT:GetDefaults()
        local _, height = self.maxwidth, 45
        local parent = self:GetParentRelation()
        local parentEl = hudelements.GetStored(parent)
        local x, y = 15, ScrH() - height - self.maxheight - self.margin

        if parentEl then
            x = parentEl.pos.x
            y = parentEl.pos.y - self.margin - height - 30
        end

        const_defaults["basepos"] = { x = x, y = y }
        const_defaults["size"] = { w = self.maxwidth, h = 45 }
        const_defaults["minsize"] = { w = self.maxwidth, h = 45 }

        return const_defaults
    end

    function HUDELEMENT:DrawComponent(name, col, val)
        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local width, height = size.w, size.h

        draw.RoundedBox(8, x, y, width, height, self.bg_colors.background_main)

        local bar_width = width - self.dmargin
        local bar_height = height - self.dmargin

        local tx = x + self.margin
        local ty = y + self.margin

        self:PaintBar(tx, ty, bar_width, bar_height, col)
        self:ShadowedText(
            val,
            "HealthAmmo",
            tx + bar_width * 0.5,
            ty + bar_height * 0.5,
            COLOR_WHITE,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )

        draw.SimpleText(
            name,
            "TabLarge",
            x + self.margin * 2,
            y,
            COLOR_WHITE,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
        )
    end

    local edit_colors = {
        border = COLOR_WHITE,
        background = Color(0, 0, 10, 200),
        fill = Color(100, 100, 100, 255),
    }

    function HUDELEMENT:Draw()
        local ply = LocalPlayer()

        if not IsValid(ply) then
            return
        end

        local tgt = ply:GetTargetPlayer()

        if HUDEditor.IsEditing then
            self:DrawComponent("TARGET", edit_colors, "- TARGET -")
        elseif IsValid(tgt) and ply:IsActive() then
            local col_tbl = {
                border = COLOR_WHITE,
                background = tgt:GetRoleDkColor(),
                fill = tgt:GetRoleColor(),
            }

            self:DrawComponent("TARGET", col_tbl, tgt:Nick())
        end
    end
end
