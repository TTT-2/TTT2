-- item info
surface.CreateFont("ItemInfoFont", {font = "Trebuchet24", size = 11, weight = 700})

COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

if CLIENT then
	local x = 0
	local y = 0

	function HUDELEMENT:Initialize()
		self:SetPos(20, 20)
	end

	function HUDELEMENT:PerformLayout()
		x = self.pos.x
		y = ScrH() * 0.5 + self.pos.y

		self.BaseClass.PerformLayout(self)
	end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()

		if not client:Alive() or client:Team() ~= TEAM_TERROR then return end

		local itms = client:GetEquipmentItems()
		local curY = y

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
				surface.SetMaterial(item.hud)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(x, curY, 64, 64)

				if isfunction(item.DrawInfo) then
					local info = item:DrawInfo()
					if info then
						-- right bottom corner
						local tx = x + 64
						local ty = curY + 64

						surface.SetFont("ItemInfoFont")

						local infoW, infoH = surface.GetTextSize(info)

						draw.RoundedBox(4, tx - infoW * 0.5 + 10, ty - infoH * 0.5, infoW, infoH, COLOR_DARKGREY)
						draw.DrawText(info, "ItemInfoFont", tx, ty - infoH * 0.5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end

				curY = curY - 80
			end
		end

		self:SetSize(64, curY - y)
	end
end
