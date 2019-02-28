-- item info
COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	surface.CreateFont("ItemInfoFont", {font = "Trebuchet24", size = 14, weight = 700})

	local size = 64

	function HUDELEMENT:Initialize()
		self:RecalculateBasePos()
		self:SetSize(size, -size)

		BaseClass.Initialize(self)

		self.defaults.minWidth = 64
		self.defaults.minHeight = 64
		
		self:SetSize(size, -size)
		self.defaults.resizeableX = false
		self.defaults.resizeableY = false
	end

	function HUDELEMENT:RecalculateBasePos()
		self:SetBasePos(20, ScrH() * 0.5)
	end
	
	function HUDELEMENT:PerformLayout()
		local basepos = self:GetBasePos()
		local currSize = self:GetSize()
		
		self:SetPos(basepos.x, basepos.y)
		self:SetSize(size, -size)

		BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if not client:Alive() or client:Team() ~= TEAM_TERROR then return end

		local basepos = self:GetBasePos()

		self:SetPos(basepos.x, basepos.y)

		local itms = client:GetEquipmentItems()
		local pos = self:GetPos()
		local curY = pos.y
		
		-- at first, calculate old items because they don't take care of the new ones
		for _, itemCls in ipairs(itms) do
			local item = items.GetStored(itemCls)
			if item and item.oldHud then
				curY = curY - 80
			end
		end

		-- now draw our new items automatically
		for _, itemCls in ipairs(itms) do
			local item = items.GetStored(itemCls)
			if item and item.hud then
				surface.SetDrawColor(36, 115, 51, 255)
				surface.DrawRect(pos.x, curY, size, size)

				surface.SetMaterial(item.hud)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(pos.x, curY, size, size)

				self:DrawLines(pos.x, curY, size, size, 255)

				if isfunction(item.DrawInfo) then
					local info = item:DrawInfo()
					if info then
						-- right bottom corner
						local tx = pos.x + size
						local ty = curY + size
						local pad = 5

						surface.SetFont("ItemInfoFont")

						local infoW, infoH = surface.GetTextSize(info)

						local bx = tx - infoW * 0.5 - pad
						local by = ty - infoH * 0.5
						local bw = infoW + pad * 2

						self:DrawBg(bx, by, bw, infoH, COLOR_DARKGREY)

						draw.DrawText(info, "ItemInfoFont", tx, ty - infoH * 0.5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

						self:DrawLines(bx, by, bw, infoH, 255)
					end
				end

				curY = curY - (size + size * 0.25)
			end
		end

		self:SetSize(size, curY - basepos.y)
	end
end
