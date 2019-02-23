-- item info
surface.CreateFont("ItemInfoFont", {font = "Trebuchet24", size = 14, weight = 700})

COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "pure_skin_element"

HUDELEMENT.Base = base

if CLIENT then
	local size = 64

	function HUDELEMENT:Initialize()
		self:SetBasePos(20, ScrH() * 0.5)
		self:SetSize(size, -size)
	end

	function HUDELEMENT:PerformLayout()
		local basepos = self:GetBasePos()

		self:SetPos(basepos.x, basepos.y)
		self:SetSize(size, -size)

		local bclass = baseclass.Get(base)

		bclass.PerformLayout(self)
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

				self:DrawLines(pos.x, curY, size, size)

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

					self:DrawLines(bx, by, bw, infoH)
				end

				curY = curY - (size + size * 0.25)
			end
		end

		self:SetSize(size, curY - basepos.y)
	end

	local defaults

	function HUDELEMENT:GetDefaults()
		if not defaults then
			local bclass = baseclass.Get(base)

			defaults = bclass.GetDefaults(self)
			defaults.minWidth = size
			defaults.minHeight = size
			defaults.resizeableX = false
			defaults.resizeableY = false
		end

		return table.Copy(defaults)
	end
end
