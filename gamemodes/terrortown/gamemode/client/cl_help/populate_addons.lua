local materialIcon = Material("vgui/ttt/vskin/helpscreen/addons")

HELPSCRN.populate["ttt2_addons"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_addons_title")
	bindingsData:SetDescription("menu_addons_description")
	bindingsData:SetIcon(materialIcon)
end
