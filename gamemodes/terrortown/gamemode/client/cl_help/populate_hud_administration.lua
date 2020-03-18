local materialIcon = Material("vgui/ttt/derma/helpscreen/guide")

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_hud_administration"] = function(helpData, id)
	local administrationData = helpData:RegisterSubMenu(id)

	administrationData:SetTitle("menu_guide_hud_administration")
	administrationData:SetDescription("menu_hud_administration_description")
	administrationData:SetIcon(materialIcon)

	administrationData:AdminOnly(true)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_hud_administration"] = function(helpData, id)
	-- gameplay
	--local gameplayData = helpData:PopulateSubMenu(id .. "_gameplay")

	--gameplayData:SetTitle("submenu_guide_gameplay_title")
end
