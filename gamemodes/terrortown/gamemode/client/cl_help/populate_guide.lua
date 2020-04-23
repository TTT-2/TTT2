local materialIcon = Material("vgui/ttt/vskin/helpscreen/guide")

HELPSCRN.populate["ttt2_guide"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_guide_title")
	bindingsData:SetDescription("menu_guide_description")
	bindingsData:SetIcon(materialIcon)
end

HELPSCRN.subPopulate["ttt2_guide"] = function(helpData, id)
	-- gameplay
	local gameplayData = helpData:PopulateSubMenu(id .. "_gameplay")

	gameplayData:SetTitle("submenu_guide_gameplay_title")

	-- roles
	local roleData = helpData:PopulateSubMenu(id .. "_roles")

	roleData:SetTitle("submenu_guide_roles_title")

	-- equipment
	local equipmentData = helpData:PopulateSubMenu(id .. "_equipment")

	equipmentData:SetTitle("submenu_guide_equipment_title")
end
