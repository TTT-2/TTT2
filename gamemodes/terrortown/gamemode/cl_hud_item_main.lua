-- item info
local HUD_ITEMS = {}
local defaultY = ScrH() * 0.5 + 20

function AddHUDItem(id, material)
	HUD_ITEMS[#HUD_ITEMS + 1] = {id = id, material = material}
end

local function getYCoordinate(currentPerkID)
	local amount, i, perk = 0, 1
	local client = LocalPlayer()

	while i < currentPerkID do
		perk = GetEquipmentItemByID(i)

		if istable(perk) and perk.hud and client:HasEquipmentItem(perk.id) then
			amount = amount + 1
		end

		i = i * 2
	end

	return defaultY - 80 * amount
end

local function ItemInfo(client)
	for k, itemData in ipairs(HUD_ITEMS) do
		if client:HasEquipmentItem(itemData.id) then
			local y = itemData.y

			if not y then
				y = client:HasEquipmentItem(itemData.id) and getYCoordinate(itemData.id) or defaultY
				HUD_ITEMS[k].y = y
			end

			surface.SetMaterial(itemData.material)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(20, y, 64, 64)
		end
	end
end

-- Paints player status HUD element in the bottom left
hook.Add("HUDPaint", "TTT2ItemHud", function()
	local client = LocalPlayer()

	-- Draw owned Item info
	if client:Alive() and client:Team() ~= TEAM_SPEC and hook.Call("HUDShouldDraw", GAMEMODE, "TTT2ItemInfo") then
		ItemInfo(client)
	end
end)
