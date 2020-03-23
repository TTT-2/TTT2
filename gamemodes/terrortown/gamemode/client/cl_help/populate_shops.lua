local materialIcon = Material("vgui/ttt/vskin/helpscreen/shops")

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_shops"] = function(helpData, id)
	local shopData = helpData:RegisterSubMenu(id)

	shopData:SetTitle("menu_shops_title")
	shopData:SetDescription("menu_shops_description")
	shopData:SetIcon(materialIcon)

	shopData:AdminOnly(true)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_shops"] = function(helpData, id)
	-- IDEA: SubMenues: Roles
	-- each role has a form with a dropdown menu to select
	-- between modes. Depending on the mode, a second form
	-- is added to configure the shop based on the mode
	-- see: HUD Switcher

	--local hudData = helpData:PopulateSubMenu(id .. "_hud")

	--hudData:SetTitle("submenu_administration_hud_title")
	--hudData:PopulatePanel(PopulateHUDPanel)
end
