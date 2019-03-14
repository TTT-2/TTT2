local base = "pure_skin_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

HUDELEMENT.togglable = true

if CLIENT then
	local defaultColor = Color(49, 71, 94)

	local margin = 14
	local element_margin = 6

	local row_count = 2

	local const_defaults = {
						basepos = {x = 0, y = 0},
						size = {w = 72, h = 72},
						minsize = {w = 0, h = 0}
	}

	function HUDELEMENT:PreInitialize()
		hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
	end

	function HUDELEMENT:Initialize()
		self.margin = margin
		self.element_margin = element_margin
		self.column_count = 0
		self.parentInstance = hudelements.GetStored(self.parent)
		self.curPlayerCount = 0
		self.ply_ind_size = 0
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
		local h = parent_size.h

		self.basecolor = self:GetHUDBasecolor() or defaultColor
		self.scale = h / parent_defaults.size.h
		self.margin = margin * self.scale
		self.element_margin = element_margin * self.scale
		self.ply_ind_size = math.Round((h - self.element_margin - self.margin * 2) * 0.5)

		local players = util.GetFilteredPlayers(function (ply)
			return ply:IsTerror() or ply:IsDeadTerror()
		end)

		self.curPlayerCount = #players
		self.column_count = math.Round(#players * 0.5)

		local w = self.element_margin * (self.column_count - 1) + self.ply_ind_size * self.column_count + 2 * self.margin

		self:SetPos(parent_pos.x + parent_size.w, parent_pos.y)
		self:SetSize(w, h)

		BaseClass.PerformLayout(self)
	end

	local function GetMSBColorForPlayer(ply)
		local ret_color = Color(0, 0, 0, 130)

		if ply:GetNWBool("body_found", false) then
			color = ply:GetRoleColor()
			ret_color = Color(color.r, color.g, color.b, 155) -- make color a bit transparent
		end

		return ret_color
	end

	function HUDELEMENT:Draw()
		local players = util.GetFilteredPlayers(function (ply)
			return ply:IsTerror() or ply:IsDeadTerror()
		end)

		if #players ~= self.curPlayerCount then
			self:PerformLayout()
		end

		-- sort playerlist: confirmed players should be in the first position
		table.sort(players, function(a, b)
			return a:GetNWBool("body_found", false) and not b:GetNWBool("body_found", false)
		end)

		-- draw bg and shadow
		self:DrawBg(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor)

		-- draw dark bottom overlay
		surface.SetDrawColor(0, 0, 0, 90)
		surface.DrawRect(self.pos.x, self.pos.y, self.size.w, self.size.h)

		-- draw squares
		local tmp_x, tmp_y = self.pos.x, self.pos.y

		for i, p in ipairs(players) do
			tmp_x = self.pos.x + self.margin + (self.element_margin + self.ply_ind_size) * math.floor((i - 1) * 0.5)
			tmp_y = self.pos.y + self.margin + (self.element_margin + self.ply_ind_size) * ((i - 1) % row_count)

			local ply_color = GetMSBColorForPlayer(p)

			surface.SetDrawColor(clr(ply_color))
			surface.DrawRect(tmp_x, tmp_y, self.ply_ind_size, self.ply_ind_size)

			-- draw lines around the element
			self:DrawLines(tmp_x, tmp_y, self.ply_ind_size, self.ply_ind_size, ply_color.a)
		end

		-- draw lines around the element
		if not self:InheritParentBorder() then
			self:DrawLines(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor.a)
		end
	end
end
