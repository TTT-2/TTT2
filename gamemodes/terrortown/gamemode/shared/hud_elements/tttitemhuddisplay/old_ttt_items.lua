-- item info
COLOR_DARKGREY = COLOR_DARKGREY or Color(100, 100, 100, 255)

local base = "old_ttt_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then
	surface.CreateFont("ItemInfoFont", {font = "Trebuchet24", size = 14, weight = 700})

	local size = 64

	function HUDELEMENT:Initialize()
		self:SetBasePos(20, ScrH() * 0.5)
		self:SetSize(size, -size)

		BaseClass.Initialize(self)

		self.defaults.minWidth = size
		self.defaults.minHeight = size
		self.defaults.resizeableX = false
		self.defaults.resizeableY = false
	end

	function HUDELEMENT:PerformLayout()
		local basepos = self:GetBasePos()

		self:SetPos(basepos.x, basepos.y)
		self:SetSize(size, -size)

		BaseClass.PerformLayout(self)
	end

	local old_ttt_bg = Material("vgui/ttt/perks/old_ttt_bg.png")

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
				surface.SetMaterial(old_ttt_bg)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(pos.x, curY, size, size)

				surface.SetMaterial(item.hud)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(pos.x, curY, size, size)

				local info = item:DrawInfo()
				if info then
					-- right bottom corner
					local tx = pos.x + size
					local ty = curY + size
					local pad = 5

					surface.SetFont("ItemInfoFont")

					local infoW, infoH = surface.GetTextSize(info)

					draw.RoundedBox(4, tx - infoW * 0.5 - pad, ty - infoH * 0.5, infoW + pad * 2, infoH, COLOR_DARKGREY)
					draw.DrawText(info, "ItemInfoFont", tx, ty - infoH * 0.5, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				curY = curY - (size + size * 0.25)
			end
		end

		self:SetSize(size, curY - basepos.y)
	end
end
