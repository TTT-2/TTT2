local base = "pure_skin_element"

HUDELEMENT.Base = base

HUDELEMENT.togglable = true

DEFINE_BASECLASS(base)

if CLIENT then
	local defaultColor = Color(49, 71, 94)

	local margin_default = 14
	local element_margin_default = 6
	local pad_default = 14
	local h_default = 72

	local margin = margin_default
	local element_margin = element_margin_default
	local row_count = 2

	-- values that will be overridden by code
	local parentInstance = nil
	local curPlayerCount = 0
	local ply_ind_size = 0
	local column_count = 0

	local x, y = 0, 0
	local h = h_default
	local pad = pad_default -- padding

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 500, h = 500},
						minsize = {w = 500, h = 500}
	}

	function HUDELEMENT:PreInitialize()
		hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
	end

	function HUDELEMENT:Initialize()
		parentInstance = hudelements.GetStored(self.parent)
		margin = margin_default
		element_margin = element_margin_default
		pad = pad_default

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
		local parent_pos = parentInstance:GetPos()
		local parent_size = parentInstance:GetSize()

		-- caching
		self.basecolor = self:GetHUDBasecolor() or defaultColor
		h = parent_size.h
		x, y = parent_pos.x - h, parent_pos.y
		self.scale = h / h_default
		margin = margin_default * self.scale
		element_margin = element_margin_default * self.scale
		pad = pad_default * self.scale

		self:SetPos(x, y)
		self:SetSize(h, h)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local round_state = GAMEMODE.round_state

		-- draw team icon
		local team = client:GetTeam()
		local tm = TEAMS[team]

		if team == TEAM_NONE or not tm or tm.alone then return end

		-- draw bg and shadow
		self:DrawBg(x, y, h, h, self.basecolor)

		local iconSize = h - pad * 2
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
		surface.DrawRect(x, y, h, h)

		surface.SetDrawColor(clr(c))
		surface.DrawRect(x + pad, y + pad, iconSize, iconSize)

		if icon then
			util.DrawFilteredTexturedRect(x + pad, y + pad, iconSize, iconSize, icon)
		end

		-- draw lines around the element
		self:DrawLines(x + pad, y + pad, iconSize, iconSize, 255)

		-- draw lines around the element
		if not self:InheritParentBorder() then
			self:DrawLines(x, y, h, h, self.basecolor.a)
		end
	end
end
