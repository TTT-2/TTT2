HUDELEMENT.type = "TTTItemHUDDisplay"

-- item info
local x = 0
local y = 0

function HUDElement:Initialize()
	HUDELEMENT:SetPos(20, 20)

	self.BaseClass:Initialize()
end

function HUDELEMENT:PerformLayout()
	x = self.pos.x
	y = ScrH() * 0.5 + self.pos.y
end

function HUDELEMENT:Draw()
	local client = LocalPlayer()
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
end
