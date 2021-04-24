local materialIcon = Material("vgui/ttt/vskin/helpscreen/guide")

local function PopulateRolesPanel(parent)
	local roles = roles.GetList()

	for i = 1, #roles do
		local role = roles[i]

		local rolename = role.name

		local Collapsible = vgui.Create( "DCollapsibleCategoryTTT2", parent); //Create a frame
		Collapsible:CopyWidth(parent);
		Collapsible:SetLabel(rolename)
		Collapsible:SetPos(0, (i - 1) * 150)

		local Content = vgui.Create("DContentPanelTTT2");
		-- Rich Text panel
		local richtext = vgui.Create( "RichText", Content )
		richtext:Dock( TOP )

		-- Text segment #1 (grayish color)
		richtext:InsertColorChange(192, 192, 192, 255)
		richtext:AppendText("This \nRichText \nis \n")

		-- Text segment #2 (light yellow)
		richtext:InsertColorChange(255, 255, 224, 255)
		richtext:AppendText("AWESOME\n\n")

		-- Text segment #3 (red ESRB notice localized string)
		richtext:InsertColorChange(255, 64, 64, 255)
		richtext:AppendText("#ServerBrowser_ESRBNotice")

		Collapsible:SetContents(Content);
	end
end

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
	roleData:PopulatePanel(PopulateRolesPanel)

	-- equipment
	local equipmentData = helpData:PopulateSubMenu(id .. "_equipment")

	equipmentData:SetTitle("submenu_guide_equipment_title")
end
