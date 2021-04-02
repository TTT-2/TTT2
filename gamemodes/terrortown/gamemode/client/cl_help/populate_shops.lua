local materialIcon = Material("vgui/ttt/vskin/helpscreen/shops")

HELPSCRN.populate["ttt2_shops"] = function(helpData, id)
	local shopData = helpData:RegisterSubMenu(id)

	shopData:SetTitle("menu_shops_title")
	shopData:SetDescription("menu_shops_description")
	shopData:SetIcon(materialIcon)

	shopData:AdminOnly(true)
end

HELPSCRN.subPopulate["ttt2_shops"] = function(helpData, id)
	-- IDEA: SubMenues: Roles
	-- each role has a form with a dropdown menu to select
	-- between modes. Depending on the mode, a second form
	-- is added to configure the shop based on the mode
	-- see: HUD Switcher
end
