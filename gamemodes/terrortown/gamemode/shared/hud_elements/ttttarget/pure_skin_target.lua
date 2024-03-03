--- @ignore

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
    local pad = 14 -- padding
    local iconSize = 64

    HUDELEMENT.icon = Material("vgui/ttt/target_icon")

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 365, h = 32 },
        minsize = { w = 225, h = 32 },
    }

    function HUDELEMENT:Initialize()
        self.scale = 1.0
        self.basecolor = self:GetHUDBasecolor()
        self.pad = pad
        self.iconSize = iconSize

        BaseClass.Initialize(self)
    end

    -- parameter overwrites
    function HUDELEMENT:IsResizable()
        return true, false
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        const_defaults["basepos"] = {
            x = 10 * self.scale,
            y = ScrH() - self.size.h - 146 * self.scale - self.pad - 10 * self.scale,
        }

        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        self.scale = appearance.GetGlobalScale()
        self.basecolor = self:GetHUDBasecolor()
        self.iconSize = iconSize * self.scale
        self.pad = pad * self.scale

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:DrawComponent(name)
        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h

        self:DrawBg(x, y, w, h, self.basecolor)
        draw.AdvancedText(
            name,
            "PureSkinBar",
            x + self.iconSize + self.pad,
            y + h * 0.5,
            util.GetDefaultColor(self.basecolor),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER,
            true,
            self.scale
        )
        self:DrawLines(x, y, w, h, self.basecolor.a)

        local nSize = self.iconSize - 16

        draw.FilteredShadowedTexture(
            x,
            y - 2 - (nSize - h),
            nSize,
            nSize,
            self.icon,
            255,
            util.GetDefaultColor(self.basecolor),
            self.scale
        )
    end

    function HUDELEMENT:ShouldDraw()
        local client = LocalPlayer()

        return IsValid(client)
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()

        local tgt = client:GetTargetPlayer()

        if HUDEditor.IsEditing then
            self:DrawComponent("- TARGET -")
        elseif IsValid(tgt) and client:IsActive() then
            self:DrawComponent(tgt:Nick())
        end
    end
end
