HUDELEMENT.Base = "pure_skin_element"
DEFINE_BASECLASS("pure_skin_element")

if CLIENT then
	local parentInstance = nil

	local margin = 5
	local curPlayerCount = 0
	local ply_ind_size = 0
	local row_count = 2
	local column_count = 0

	function HUDELEMENT:Initialize()
		hudelements.RegisterChildRelation(self.id, "pure_skin_roundinfo", false)
		parentInstance = hudelements.GetStored(self.parent)
	end

	function HUDELEMENT:PerformLayout()
		local parent_pos = parentInstance:GetPos()
		local parent_size = parentInstance:GetSize()

		local height = parent_size.h
		ply_ind_size = math.Round((height - margin * 3) / 2)

		local players = util.GetFilteredPlayers(function (ply) return ply:IsTerror() end)
		curPlayerCount = #players

		column_count = math.Round(#players / 2)
		local width = (margin + ply_ind_size) * column_count + margin

		self:SetPos(parent_pos.x + parent_size.w, parent_pos.y)
		self:SetSize(width, height)

		BaseClass.PerformLayout(self)
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
			tmp_x = self.pos.x + (margin + ply_ind_size) * math.floor(i * 0.5)
			tmp_y = self.pos.y + margin + (margin + ply_ind_size) * (i % row_count)
			ply_color = p:GetRoleColor()
			surface.SetDrawColor(clr(ply_color))
			surface.DrawRect(tmp_x, tmp_y, ply_ind_size, ply_ind_size)
		end
		-- draw lines around the element
		self:DrawLines(self.pos.x, self.pos.y, self.size.w, self.size.h)
	end
end
