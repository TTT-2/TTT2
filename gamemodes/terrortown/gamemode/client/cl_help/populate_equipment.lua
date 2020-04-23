local materialIcon = Material("vgui/ttt/vskin/helpscreen/equipment")

HELPSCRN.populate["ttt2_equipment"] = function(helpData, id)
	local equipmentData = helpData:RegisterSubMenu(id)

	equipmentData:SetTitle("menu_equipment_title")
	equipmentData:SetDescription("menu_equipment_description")
	equipmentData:SetIcon(materialIcon)

	equipmentData:AdminOnly(true)
end

HELPSCRN.subPopulate["ttt2_equipment"] = function(helpData, id)
	-- IDEA: submenu is populated with equipment, each thing gets their
	-- own menu page
end
