local base = "pure_skin_element"

HUDELEMENT.Base = base

DEFINE_BASECLASS(base)

HUDELEMENT.togglable = true

if CLIENT then
	local margin_default = 14
	local element_margin_default = 6
	local h_default = 72

	local margin = margin_default
	local element_margin = element_margin_default
	local row_count = 2

	local x, y = 0, 0
	local w, h = h_default, h_default
	local scale = 1.0

	-- values that will be overridden by code
	local parentInstance = nil
	local curPlayerCount = 0
	local ply_ind_size = 0
	local column_count = 0

	function HUDELEMENT:PreInitialize()
		hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
	end

	function HUDELEMENT:Initialize()
		w, h = h_default, h_default
		scale = 1.0
		margin = margin_default
		element_margin = element_margin_default

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

		x, y = parent_pos.x + parent_size.w, parent_pos.y
		h = parent_size.h
		scale = h / h_default
		margin = margin_default * scale
		element_margin = element_margin_default * scale

		ply_ind_size = math.Round((h - element_margin - margin * 2) * 0.5)

		local players = util.GetFilteredPlayers(function (ply)
			return ply:IsTerror() or ply:IsDeadTerror()
		end)

		curPlayerCount = #players

		column_count = math.Round(#players * 0.5)

		w = element_margin * (column_count - 1) + ply_ind_size * column_count + 2 * margin

		self:SetPos(x, y)
		self:SetSize(w, h)

		BaseClass.PerformLayout(self)
	end

	local function GetMSBColorForPlayer(ply)
		local ret_color = Color(0, 0, 0, 130)

		if ply:GetNWBool("body_found", false) then
			if ply:GetNWBool("role_found", false) then
				color = ply:GetRoleColor()
				ret_color = Color(color.r, color.g, color.b, 155) -- make color a bit transparent
			else
				ret_color = Color(255, 255, 255, 155) -- make color a bit transparent
			end
		end

		return ret_color
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		local players = util.GetFilteredPlayers(function (ply)
			return ply:IsTerror() or ply:IsDeadTerror()
		end)

		if #players ~= curPlayerCount then
			self:PerformLayout()
		end

		-- sort playerlist: confirmed players should be in the first position
		table.sort(players, function(a, b)
			return a:GetNWBool("body_found", false) and not b:GetNWBool("body_found", false)
		end)

		-- draw bg and shadow
		self:DrawBg(x, y, w, h, self.basecolor)

		-- draw dark bottom overlay
		surface.SetDrawColor(0, 0, 0, 90)
		surface.DrawRect(x, y, w, h)

		-- draw squares
		local tmp_x, tmp_y = self.pos.x, self.pos.y

		for i, p in ipairs(players) do
			tmp_x = self.pos.x + margin + (element_margin + ply_ind_size) * math.floor((i - 1) * 0.5)
			tmp_y = self.pos.y + margin + (element_margin + ply_ind_size) * ((i - 1) % row_count)

			local ply_color = GetMSBColorForPlayer(p)

			surface.SetDrawColor(clr(ply_color))
			surface.DrawRect(tmp_x, tmp_y, ply_ind_size, ply_ind_size)

			-- draw lines around the element
			self:DrawLines(tmp_x, tmp_y, ply_ind_size, ply_ind_size, ply_color.a)
		end

		-- draw lines around the element
		if not self:InheritParentBorder() then
			self:DrawLines(x, y, w, h, self.basecolor.a)
		end
	end
end
