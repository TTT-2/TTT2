local materialIcon = Material("vgui/ttt/vskin/helpscreen/equipment")

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_equipment"] = function(helpData, id)
	local equipmentData = helpData:RegisterSubMenu(id)

	equipmentData:SetTitle("menu_equipment_title")
	equipmentData:SetDescription("menu_equipment_description")
	equipmentData:SetIcon(materialIcon)

	equipmentData:AdminOnly(true)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_equipment"] = function(helpData, id)
	-- IDEA: submenu is populated with equipment, each thing gets their
	-- own menu page
end
