-- item info

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

				curY = curY - 80
			end
		end

		self:SetSize(64, curY - y)
	end
end
