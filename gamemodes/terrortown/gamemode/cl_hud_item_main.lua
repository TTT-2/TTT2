-- item info
local defaultY = ScrH() * 0.5 + 20

local ipairs = ipairs

local function ItemInfo(client)
	local y = defaultY

	for _, item in ipairs(items.GetList()) do
		if item.icon and client:HasEquipmentItem(item.id) then
			surface.SetMaterial(item.icon)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(20, y, 64, 64)

			y = y - 80
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

hook.Add("TTTBodySearchPopulate", "TTT2ItemHUDIcon", function(search, raw)
	for _, item in ipairs(items.GetList()) do
		if not raw["eq_" .. item.id] then return end

		local highest = 0

		for _, v in pairs(search) do
			highest = math.max(highest, v.p)
		end

		search["eq_" .. item.id] = {img = item.material, text = item.desc, p = highest + 1}
	end
end)

hook.Add("TTTBodySearchEquipment", "TTT2ItemHUDCorpseIcon", function(search, eq)
	for _, item in ipairs(items.GetList()) do
		search["eq_" .. item.id] = table.HasValue(eq, item.id)
	end
end)
