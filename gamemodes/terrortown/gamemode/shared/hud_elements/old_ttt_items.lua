HUDELEMENT.type = "TTTItemHUDDisplay"

-- item info
local defaultY = ScrH() * 0.5 + 20

function HUDELEMENT:Draw()
	local client = LocalPlayer()
	local y = defaultY
	local itms = client:GetEquipmentItems()

	-- at first, calculate old items because they doesn't take care of the new ones
	for _, itemCls in ipairs(itms) do
		local item = items.GetStored(itemCls)
		if item and item.oldHud then
			y = y - 80
		end
	end

	-- now draw our new items automatically
	for _, itemCls in ipairs(itms) do
		local item = items.GetStored(itemCls)
		if item and item.hud then
			surface.SetMaterial(item.hud)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(20, y, 64, 64)

			y = y - 80
		end
	end
end
