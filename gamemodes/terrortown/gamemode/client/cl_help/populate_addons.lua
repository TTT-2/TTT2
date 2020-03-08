---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_addons"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("f1_settings_addons_title")
	bindingsData:SetDescription("Some cool text will be here...")
	bindingsData:SetIcon(Material("vgui/ttt/dynamic/roles/icon_inno"))
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_addons"] = function(helpData, id)

end
