local materialIcon = Material("vgui/ttt/vskin/helpscreen/gameplay")

local function PopulateGeneralPanel(parent)
	local form = CreateTTT2Form(parent, "header_gameplay_settings")

	form:MakeCheckBox({
		label = "label_gameplay_specmode",
		convar = "ttt_spectator_mode"
	})

	form:MakeCheckBox({
		label = "label_gameplay_fastsw",
		convar = "ttt_weaponswitcher_fast"
	})

	form:MakeCheckBox({
		label = "label_gameplay_hold_aim",
		convar = "ttt2_hold_aim"
	})

	form:MakeCheckBox({
		label = "label_gameplay_mute",
		convar = "ttt_mute_team_check"
	})

	local enbSprint = form:MakeCheckBox({
		label = "label_gameplay_dtsprint_enable",
		convar = "ttt2_enable_doubletap_sprint"
	})

	form:MakeCheckBox({
		label = "label_gameplay_dtsprint_anykey",
		convar = "ttt2_doubletap_sprint_anykey",
		master = enbSprint
	})

	form:MakeCheckBox({
		label = "label_shop_double_click_buy",
		convar = "ttt_bem_enable_doubleclick_buy"
	})
end

local function PopulateRolesPanel(parent)
	local form = CreateTTT2Form(parent, "header_roleselection")

	local roles = roles.GetList()

	for i = 1, #roles do
		local v = roles[i]

		if ConVarExists("ttt_avoid_" .. v.name) then
			local rolename = v.name

			form:MakeCheckBox({
				label = rolename,
				convar = "ttt_avoid_" .. rolename
			})
		end
	end

	form:Dock(TOP)
end

HELPSCRN.populate["ttt2_gameplay"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_gameplay_title")
	bindingsData:SetDescription("menu_gameplay_description")
	bindingsData:SetIcon(materialIcon)
end

HELPSCRN.subPopulate["ttt2_gameplay"] = function(helpData, id)
	local generalData = helpData:PopulateSubMenu(id .. "_general")

	generalData:SetTitle("submenu_gameplay_general_title")
	generalData:PopulatePanel(PopulateGeneralPanel)

	local rolesData = helpData:PopulateSubMenu(id .. "_avoid_roles")

	rolesData:SetTitle("submenu_gameplay_avoidroles_title")
	rolesData:PopulatePanel(PopulateRolesPanel)
end
