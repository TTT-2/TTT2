local base = "pure_skin_element"

HUDELEMENT.Base = base

HUDELEMENT.togglable = true

DEFINE_BASECLASS(base)

if CLIENT then
	local margin = 14
	local element_margin = 6
	local row_count = 2

	-- values that will be overridden by code
	local parentInstance = nil
	local curPlayerCount = 0
	local ply_ind_size = 0
	local column_count = 0

	local x, y = 0, 0
	local h = 72
	local pad = 14 -- padding

	function HUDELEMENT:PreInitialize()
		hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
	end

	function HUDELEMENT:Initialize()
		parentInstance = hudelements.GetStored(self.parent)

		BaseClass.Initialize(self)
	end

	-- parameter overwrites
	function HUDELEMENT:ShouldShow()
		return GAMEMODE.round_state == ROUND_ACTIVE
	end

	function HUDELEMENT:InheritParentBorder()
		return true
	end
	-- parameter overwrites end

	function HUDELEMENT:RecalculateBasePos()

	end

	function HUDELEMENT:PerformLayout()
		local parent_pos = parentInstance:GetPos()
		local parent_size = parentInstance:GetSize()

		-- caching
		h = parent_size.h
		x, y = parent_pos.x - h, parent_pos.y

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
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x + pad, y + pad, iconSize, iconSize)
		end

		-- draw lines around the element
		self:DrawLines(x + pad, y + pad, iconSize, iconSize, 255)

		-- draw lines around the element
		if not self:InheritParentBorder() then
			self:DrawLines(x, y, h, h, self.basecolor.a)
		end
	end
end
