local function PopulateGeneralPanel(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName("set_title_play")

	local cb

	cb = form:CheckBox("set_specmode", "ttt_spectator_mode")
	cb:SetTooltip("set_specmode_tip")

	cb = form:CheckBox("set_fastsw", "ttt_weaponswitcher_fast")
	cb:SetTooltip("set_fastsw_tip")

	cb = form:CheckBox("hold_aim", "ttt2_hold_aim")
	cb:SetTooltip("hold_aim_tip")

	cb = form:CheckBox("doubletap_sprint_anykey", "ttt2_doubletap_sprint_anykey")
	cb:SetTooltip("doubletap_sprint_anykey_tip")

	cb = form:CheckBox("disable_doubletap_sprint", "ttt2_disable_doubletap_sprint")
	cb:SetTooltip("disable_doubletap_sprint_tip")

	-- TODO what is the following reason?
	-- For some reason this one defaulted to on, unlike other checkboxes, so
	-- force it to the actual value of the cvar (which defaults to off)
	local mute = form:CheckBox("set_mute", "ttt_mute_team_check")
	mute:SetValue(GetConVar("ttt_mute_team_check"):GetBool())
	mute:SetTooltip("set_mute_tip")

	form:Dock(FILL)
end

local function PopulateRolesPanel(parent)
	local form = vgui.Create("DForm", parent)
	form:SetName("set_title_avoid_roles")

	local cb

	for _, v in ipairs(roles.GetList()) do
		if ConVarExists("ttt_avoid_" .. v.name) then
			local rolename = v.name

			cb = form:CheckBox(rolename, "ttt_avoid_" .. v.name)
			cb:SetTooltip("avoid_role")
		end
	end

	form:Dock(FILL)
end

---
-- Function to populate main menu
-- @param table helpData The main menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.populate["ttt2_gameplay"] = function(helpData, id)
	local bindingsData = helpData:RegisterSubMenu(id)

	bindingsData:SetTitle("f1_settings_gameplay_title")
	bindingsData:SetDescription("Some cool text will be here...")
	bindingsData:SetIcon(Material("vgui/ttt/dynamic/roles/icon_inno"))
end

---
-- Function to populate sub menu
-- @param table helpData The sub menu data object
-- @param string id The unique id of this menu element
-- @internal
-- @realm client
HELPSCRN.subPopulate["ttt2_gameplay"] = function(helpData, id)
	local generalData = helpData:PopulateSubMenu(id .. "_general")

	generalData:SetTitle("ttt2_gameplay_general")
	generalData:PopulatePanel(PopulateGeneralPanel)

	local rolesData = helpData:PopulateSubMenu(id .. "_avoid_roles")

	rolesData:SetTitle("ttt2_gameplay_avoid_roles")
	rolesData:PopulatePanel(PopulateRolesPanel)
end
