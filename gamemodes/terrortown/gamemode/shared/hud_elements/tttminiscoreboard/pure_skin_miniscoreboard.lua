local base = "pure_skin_element"

HUDELEMENT.Base = base

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

	function HUDELEMENT:PreInitialize()
		hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
	end

	function HUDELEMENT:Initialize()
		parentInstance = hudelements.GetStored(self.parent)
	end

	function HUDELEMENT:PerformLayout()
		local parent_pos = parentInstance:GetPos()
		local parent_size = parentInstance:GetSize()

		local height = parent_size.h
		ply_ind_size = math.Round((height - element_margin - margin * 2 ) / 2)

		local players = util.GetFilteredPlayers(function (ply) return ply:IsTerror() end)
		curPlayerCount = #players

		column_count = math.Round(#players / 2)
		local width = (margin + ply_ind_size) * column_count + margin

		self:SetPos(parent_pos.x + parent_size.w, parent_pos.y)
		self:SetSize(width, height)

		BaseClass.PerformLayout(self)
	end

	local function GetMSBColorForPlayer(ply)
		local ret_color = Color(0, 0, 0, 130)

		if ply:GetNWBool("body_found", false) then
			ret_color = ply:GetRoleColor()
		end

		return ret_color
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local round_state = GAMEMODE.round_state

		local players = util.GetFilteredPlayers(function (ply) return ply:IsTerror() end)
		if #players ~= curPlayerCount then
			self:PerformLayout()
		end

		-- draw bg and shadow
		self:DrawBg(self.pos.x, self.pos.y, self.size.w, self.size.h, self.basecolor)
		local tmp_x, tmp_y = self.pos.x, self.pos.y
		for i, p in ipairs(players) do
			tmp_x = self.pos.x + margin + (element_margin + ply_ind_size) * math.floor((i - 1) * 0.5)
			tmp_y = self.pos.y + margin + (element_margin + ply_ind_size) * ((i - 1) % row_count)
			local ply_color = GetMSBColorForPlayer(p)
			surface.SetDrawColor(ply_color)
			surface.DrawRect(tmp_x, tmp_y, ply_ind_size, ply_ind_size)
			-- draw lines around the element
			self:DrawLines(tmp_x, tmp_y, ply_ind_size, ply_ind_size)
		end
		-- draw lines around the element
		self:DrawLines(self.pos.x, self.pos.y, self.size.w, self.size.h)
	end
end
