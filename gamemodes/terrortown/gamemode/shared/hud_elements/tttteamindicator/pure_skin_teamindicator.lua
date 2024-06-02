--- @ignore

local base = "pure_skin_element"

HUDELEMENT.Base = base

HUDELEMENT.togglable = true

DEFINE_BASECLASS(base)

if CLIENT then
    local pad = 14
    local element_margin = 6

    local material_watching = Material("vgui/ttt/watching_icon")

    local const_defaults = {
        basepos = { x = 0, y = 0 },
        size = { w = 72, h = 72 },
        minsize = { w = 0, h = 0 },
    }

    function HUDELEMENT:PreInitialize()
        hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
    end

    function HUDELEMENT:Initialize()
        self.parentInstance = hudelements.GetStored(self.parent)
        self.pad = pad
        self.element_margin = element_margin
        self.scale = 1.0
        self.basecolor = self:GetHUDBasecolor()

        BaseClass.Initialize(self)
    end

    -- parameter overwrites
    function HUDELEMENT:ShouldDraw()
        return gameloop.GetRoundState() == ROUND_ACTIVE
    end

    function HUDELEMENT:InheritParentBorder()
        return true
    end
    -- parameter overwrites end

    function HUDELEMENT:GetDefaults()
        return const_defaults
    end

    function HUDELEMENT:PerformLayout()
        local parent_pos = self.parentInstance:GetPos()
        local parent_size = self.parentInstance:GetSize()
        local parent_defaults = self.parentInstance:GetDefaults()
        local size = parent_size.h

        self.basecolor = self:GetHUDBasecolor()
        self.scale = size / parent_defaults.size.h
        self.pad = pad * self.scale
        self.element_margin = element_margin * self.scale

        self:SetPos(parent_pos.x - size, parent_pos.y)
        self:SetSize(size, size)

        BaseClass.PerformLayout(self)
    end

    function HUDELEMENT:Draw()
        local client = LocalPlayer()
        local pos = self:GetPos()
        local size = self:GetSize()
        local x, y = pos.x, pos.y
        local w, h = size.w, size.h

        -- draw team icon
        local team = client:GetTeam()
        local tm = TEAMS[team]

        -- draw bg and shadow
        self:DrawBg(x, y, w, h, self.basecolor)

        local iconSize = h - self.pad * 2
        local icon, c

        if client:Alive() and client:IsTerror() then
            icon = tm.iconMaterial
            c = tm.color or COLOR_BLACK
        else -- player is dead and spectator
            icon = material_watching
            c = COLOR_SPEC
        end

        -- draw dark bottom overlay
        surface.SetDrawColor(0, 0, 0, 90)
        surface.DrawRect(x, y, h, h)

        surface.SetDrawColor(clr(c))
        surface.DrawRect(x + self.pad, y + self.pad, iconSize, iconSize)

        if icon then
            draw.FilteredShadowedTexture(
                x + self.pad,
                y + self.pad,
                iconSize,
                iconSize,
                icon,
                255,
                util.GetDefaultColor(c),
                self.scale
            )
        end

        -- draw lines around the element
        self:DrawLines(x + self.pad, y + self.pad, iconSize, iconSize, 255)

        -- draw lines around the element
        if not self:InheritParentBorder() then
            self:DrawLines(x, y, w, h, self.basecolor.a)
        end
    end
end
