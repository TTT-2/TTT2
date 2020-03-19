local materialIcon = Material("vgui/ttt/vskin/helpscreen/gameplay")

local function PopulateGeneralPanel(parent)
	local form = CreateForm(parent, "set_title_play")

	form:MakeCheckBox({
		label = "set_specmode",
		convar = "ttt_spectator_mode"
	})

	form:MakeCheckBox({
		label = "set_fastsw",
		convar = "ttt_weaponswitcher_fast"
	})

	form:MakeCheckBox({
		label = "hold_aim",
		convar = "ttt2_hold_aim"
	})

	form:MakeCheckBox({
		label = "set_mute",
		convar = "ttt_mute_team_check"
	})

	form:MakeCheckBox({
		label = "doubletap_sprint_anykey",
		convar = "ttt2_doubletap_sprint_anykey"
	})

	form:MakeCheckBox({
		label = "disable_doubletap_sprint",
		convar = "ttt2_disable_doubletap_sprint"
	})
end

local function PopulateRolesPanel(parent)
	local form = CreateForm(parent, "set_title_avoid_roles")

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

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_gameplay"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("menu_gameplay_title")
	bindingsData:SetDescription("menu_gameplay_description")
	bindingsData:SetIcon(materialIcon)
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_gameplay"] = function(helpData, id)
	local generalData = helpData:PopulateSubMenu(id .. "_general")

	generalData:SetTitle("submenu_gameplay_general_title")
	generalData:PopulatePanel(PopulateGeneralPanel)

	local rolesData = helpData:PopulateSubMenu(id .. "_avoid_roles")

	rolesData:SetTitle("submenu_gameplay_avoidroles_title")
	rolesData:PopulatePanel(PopulateRolesPanel)
end
