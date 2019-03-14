local base = "pure_skin_element"

HUDELEMENT.Base = base

HUDELEMENT.togglable = true

DEFINE_BASECLASS(base)

if CLIENT then
	local defaultColor = Color(49, 71, 94)

	local pad = 14
	local element_margin = 6

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 72, h = 72},
						minsize = {w = 0, h = 0}
	}

	function HUDELEMENT:PreInitialize()
		hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
	end

	function HUDELEMENT:Initialize()
		self.parentInstance = hudelements.GetStored(self.parent)
		self.pad = pad
		self.element_margin = element_margin
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor() or defaultColor

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:ShouldDraw()
		return GAMEMODE.round_state == ROUND_ACTIVE
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

		self.basecolor = self:GetHUDBasecolor() or defaultColor
		self.scale = size / parent_defaults.size.h
		self.pad = pad * self.scale
		self.element_margin = element_margin * self.scale

		self:SetPos(parent_pos.x - size, parent_pos.y)
		self:SetSize(size, size)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		-- draw team icon
		local team = client:GetTeam()
		local tm = TEAMS[team]

		if team == TEAM_NONE or not tm or tm.alone then return end

		-- draw bg and shadow
		self:DrawBg(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor)

		local iconSize = self.size.h - self.pad * 2
		local icon, c
		if LocalPlayer():Alive() then
			icon = Material(tm.icon)
			c = tm.color or Color(0, 0, 0, 255)
		else
			icon = Material("vgui/ttt/watching_icon")
			c = Color(91,94,99,255)
		end

		-- draw dark bottom overlay
		surface.SetDrawColor(0, 0, 0, 90)
		surface.DrawRect(self.pos.x, self.pos.y, self.size.h, self.size.h)

		surface.SetDrawColor(clr(c))
		surface.DrawRect(self.pos.x + self.pad, self.pos.y + self.pad, iconSize, iconSize)

		if icon then
			util.DrawFilteredTexturedRect(self.pos.x + self.pad, self.pos.y + self.pad, iconSize, iconSize, icon)
		end

		-- draw lines around the element
		self:DrawLines(self.pos.x + self.pad, self.pos.y + self.pad, iconSize, iconSize, 255)

		-- draw lines around the element
		if not self:InheritParentBorder() then
			self:DrawLines(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor.a)
		end
	end
end
